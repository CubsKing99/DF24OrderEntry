Use Windows.pkg
Use DFClient.pkg
Use DFTabDlg.pkg

Use cClientWebService.pkg
Use cTextEdit.pkg
Use vWin32fh\vwin32fh.pkg
Use cJsonHttpTransfer.pkg

//Much of this code is copied from WebClientHelper.vw in 17.0
//2023-09-20 MRM (Tk#27372) Rewrote to work for REST in addition to SOAP web services.

#IFNDEF C_CRLF
Define C_CRLF   for (Character(13) + Character(10))
#ENDIF

Activate_View Activate_oWebServiceHelper for oWebServiceHelper
Object oWebServiceHelper is a dbView
    Set Label to "Web Service Information"
    Set Size to 272 510
    Set Location to 5 7
    
    Property Boolean pbRetainPrevious False //Should the previous data be wiped out or appended to?
    Property Boolean pbDisplay False //Should this view be shown to the users? We only have it set to True in our test environment.  In Live, it's only shown if we call DisplayAndSaveSOAP.
    Property Boolean pbSaved False //Has this transaction been saved?
    Property String psRequest ""
    Property String psResponse ""

    Object frmURL is a Form
        Set Label to "URL"
        Set Size to 13 439
        Set Location to 4 66
        Set peAnchors to anLeftRight
    End_Object    // frmURL

    Object frmEncoding is a Form
        Set Label to "Encoding"
        Set Size to 13 108
        Set Location to 18 397
        Set peAnchors to anRight
        Set Label_Col_Offset to 0
        Set Label_Justification_Mode to jMode_Right
    End_Object    // frmEncoding

    Object frmStyle is a Form
        Set Label to "Style"
        Set Size to 13 71
        Set Location to 18 291
        Set peAnchors to anRight
        Set Label_Col_Offset to 0
        Set Label_Justification_Mode to jMode_Right
    End_Object    // frmStyle

    Object frmAction is a Form
        Set Label to "Action"
        Set Size to 13 202
        Set Location to 18 66
        Set peAnchors to anLeftRight
    End_Object    // frmAction

    Object frmStatus is a Form
        Set Label to "Status"
        Set Size to 13 296
        Set Location to 33 66
        Set peAnchors to anLeftRight
    End_Object    // frmStatus

    Object frmMethod is a Form
        Set Label to "Method"
        Set Size to 13 441
        Set Location to 47 66
        Set peAnchors to anLeftRight
    End_Object    // frmMethod

    Object tdRequestResponse is a TabDialog
        Set Size to 200 499
        Set Location to 68 6
        Set peAnchors to anAll
        Set Default_Tab to 1

        Object tabRequest is a TabPage
            Set Label to "Request"

            Object txtRequest is a cTextEdit
                Set Size to 178 486
                Set Location to 4 5
                Set Read_only_state to True
                Set pbWrap to False
                Set peAnchors to anAll
            End_Object    // txtRequest
        End_Object
    
        Object tabResponse is a TabPage
            Set Label to "Response"

            Object txtResponse is a cTextEdit
                Set Size to 178 486
                Set Location to 4 5
                Set Read_only_state to True
                Set pbWrap to False
                Set peAnchors to anAll
            End_Object    // txtResponse
        End_Object
    
    End_Object
    
//    Function ParamDataTypeName Integer eType Returns String
//        String sType
//        Case Begin
//            Case (eType=xsString  ) Move "string"    to sType
//            Case (eType=xsNumber  ) Move "number"    to sType
//            Case (eType=xsDate    ) Move "date"      to sType
//            Case (eType=xsInteger ) Move "integer"   to sType
//            Case (eType=xsReal    ) Move "real"      to sType
//            Case (eType=xsBigint  ) Move "bigint "   to sType
//            Case (eType=xsTime    ) Move "time"      to sType
//            Case (eType=xsDatetime) Move "dateTime"  to sType
//            Case (eType=xsFloat   ) Move "float"     to sType
//            Case (eType=xsChar    ) Move "char"      to sType
//            Case (eType=xsUchar   ) Move "uchar"     to sType
//            Case (eType=xsShort   ) Move "short"     to sType
//            Case (eType=xsUShort  ) Move "ushort"    to sType
//            Case (eType=xsUinteger) Move "uinteger"  to sType
//            Case (eType=xsBoolean ) Move "boolean"   to sType
//            Case (eType=xsUbigint ) Move "ubigint"   to sType
//            Case (eType=xsCurrency) Move "currency"  to sType
//            Case (eType=xsDecimal ) Move "decimal"   to sType
//            Case Else               Move "xmlHandle"   to sType
//        Case End
//        
//        Function_Return sType
//    End_Function
    
    Function PrettyFormatXMLToAddress Handle hoXml Returns Address
        Handle hoXsl
        String sPath
        Boolean bok
        Pointer pXML

        Get_File_Path "PrettyFormatXml.xsl" to sPath
        If (sPath<>"") Begin
            Get Create U_cXmlDomDocument to hoXSL
            Set psDocumentName of hoXSL to spath
            Get LoadXMLDocument of hoXSL to bOk
            If bOk Begin
                Get XSLTransformationToAddress of hoXML hoXSL to pXml
            End
            Send Destroy of hoXSL
        End

        Function_Return pXml
    End_Function
    
    Procedure OnSoapReceived Handle hoSoapClient
        String  sValue sText sFaultCode sParamName sParamValue sSchemaType
        String  sNs sContentType sRequest sResponse
        Handle  hoXml hoObj hoRoot hoStruct
        Integer eXmlTransferStatus
        Pointer pXML
        Boolean bOk

        Set Label to ("Web Service Information - " * object_label(hoSoapClient))

        Set pbSaved to False

        If (pbDisplay(Self)) Begin
            If not (active_state(Self)) Send Activate_View
        End

        Send Delete_Data of frmStyle
        Send Delete_Data of frmEncoding
        Send Delete_Data of frmMethod
        Send Delete_Data of frmStatus
        Send Delete_Data of frmURL
        Send Delete_Data of frmAction
        
        Set Dynamic_Update_state of txtRequest to False
        Set Dynamic_Update_state of txtResponse to False

        If (pbRetainPrevious(Self)) Begin //If they're keeping the previous data, retrieve it
            Get psRequest   to sRequest
            Append sRequest C_CRLF C_CRLF

            Get psResponse  to sResponse
            Append sResponse C_CRLF C_CRLF
        End
        Else Begin
            Move "" to sRequest
            Move "" to sResponse
        End

        Get psServiceLocation of hoSoapClient to sValue
        Set Value of frmURL to sValue
    
        Get psSoapAction of hoSoapClient to sValue
        Set Value of frmAction to sValue
    
        Get peSoapStyle of hoSoapClient to sValue
        Set Value of frmStyle to (If(sValue=ssRpc,"rpc","document"))
    
        Get peSoapEncoding of hoSoapClient to sValue
        Move ("in:"+If(sValue=seLiteral,"literal","encoded")) to stext
        Get peResponseSoapEncoding of hoSoapClient to sValue
        Move (sText * "out:"+If(sValue=seLiteral,"literal","encoded")) to sText
        Set Value of frmEncoding to sText
    
        Get peTransferStatus of hoSoapClient to eXmlTransferStatus
        Case Begin
            Case (eXmlTransferStatus=wssOk)                 Move "wssOK - Transmission Successful (Check Response for Logical State)" to sValue
            Case (eXmlTransferStatus=wssHttpRequestFailed)  Move "wssHttpRequestFailed - Http request failed" to sValue
            Case (eXmlTransferStatus=wssBadRequest)         Move "wssBadRequest - Bad or missing data sent" to sValue
            Case (eXmlTransferStatus=wssInvalidContentType) Move (SFormat("wssInvalidContentType - Invalid contentType received (%1)",psContentTypeReceived(oHttp(hoSoapClient))))  to sValue
            Case (eXmlTransferStatus=wssNoData)             Move "wssNoData - No data was received" to sValue
            Case (eXmlTransferStatus=wssNotXml)             Move "wssNotXml - Received data not in proper XML format" to sValue
            Case (eXmlTransferStatus=wssNotSoap)            Move "wssInvalidSoap - Received data not in proper Soap format" to sValue
            Case (eXmlTransferStatus=wssInvalidSoap)        Move "wssInvalidSoap - Received SOAP data not formatted according to service description" to sValue
            Case (eXmlTransferStatus=wssInvalidDataForType) Move "wssInvalidDataForType - Attempt to move data from XML to ValueTree (to Struct) failed." to sValue
            Case (eXmlTransferStatus=wssCouldNotResolveHRef) Move "wssCouldNotResolveHRef - XML contained href elements and we could not find the Id data that matches it" to sValue

            Case (eXmlTransferStatus=wssSoapFault) Begin
                Move "wssSoapFault - " to sValue
                Get psFaultCode of hoSoapClient to sFaultCode
                Move (sValue * "Fault Code=" * sFaultCode ) to sValue
            End
            Case Else ;
                Move "wssError - Received data is bad" to sValue
        Case End
        Set Value of frmStatus to sValue

        Get psMethodRequest of hoSoapClient to sValue
        Set Value of frmMethod to sValue
    
        Get phoSoapRequest of hoSoapClient to hoXml
        If (hoXml) Begin
            Get PrettyFormatXmlToAddress hoXml to pXML
            If (pXML <> 0) Begin
                Append sRequest (CString(pXML))
                Move (Free(pXML)) to bOk
            End
        End

        Set Value   of txtRequest   to sRequest
        Set psRequest   to sRequest

        Get phoSoapResponse of hoSoapClient to hoXml
        If (hoXml) Begin
            Get PrettyFormatXmlToAddress hoXml to pXML
            If (pXML <> 0) Begin
                Append sResponse (CString(pXML))
                Move (Free(pXML)) to bOk
            End
        End
        Else If (eXmlTransferStatus=wssInvalidContentType) Begin
            // if there was an error and it was invald html content, we will display the html in this
            // window
            Get psContentTypeReceived of (oHttp(hoSoapClient)) to sContentType
            If (pos("html",lowercase(sContentType))) Begin
                 Append sResponse "Response: An Invalid html response was received:" C_CRLF C_CRLF
                 // if a content error occurred we keep the bad data in the http object
                 Get pucDataReceived of (oHttp(hoSoapClient)) to sText
                 Move (Left(sText,16000)) to sText
                 Move (Replaces(Character(10), sText, C_CRLF)) to sText
                 Append sResponse sText
            End
        End

        Set Value   of txtResponse  to sResponse
        Set psResponse  to sResponse

//        If (pbSaveWebServiceFiles(oProperties(Self))) Begin
//            Send SaveRequestResponse "SOAP"
//        End

        Send beginning_of_data   of txtRequest
        Send beginning_of_data   of txtResponse
        Set Dynamic_Update_state of txtRequest to True
        Set Dynamic_Update_state of txtResponse to True
    End_Procedure
    
    Procedure DisplayAndSaveSOAP
        If not (active_state(Self)) Send Activate_View

        Send SaveRequestResponse "SOAP"
    End_Procedure

    Procedure SaveSOAP
        Send SaveRequestResponse "SOAP"
    End_Procedure

    Procedure SaveRequestResponse String sFormat
        DateTime dtNow
        String  sOutputPath sComputerName sRequestFileName sResponseFileName sDate sDestFolder sText
        Integer iCh iResult
        Boolean bExists
        
        If (not(pbSaved(Self))) Begin
            Move (CurrentDateTime()) to dtNow
            ConvertToXML xsDateTime dtNow to sDate
            Move (Replaces(":", sDate, ".")) to sDate //Change the : in the time so Windows doesn't freak out.
            Get_Environment "COMPUTERNAME" to sComputerName

            If (sFormat = "SOAP") Begin
                Move "\Logs\SOAP"   to sDestFolder
            End
            Else If (sFormat = "JSON") Begin
                Move "\Logs\JSON"   to sDestFolder
            End
            Else Begin
                Move "\Logs"    to sDestFolder
            End

            Get psProgramPath of (phoWorkspace(ghoApplication)) to sOutputPath
            Move (Replace("\Programs", sOutputPath, sDestFolder)) to sOutputPath

            //2021-06-09 MRM (Tk#13619) Create the log folder if it doesn't exist.
            Get vFolderExists sOutputPath to bExists
            If (not(bExists)) Begin
                Get vshCreateDirectoryEX sOutputPath  to iResult
            End

            Move sOutputPath to sRequestFileName
            Append sRequestFileName "\" sDate " - " sComputerName " - Request.txt"

            Get psRequest   to sText
            If (sText <> "") Begin
                // 10/02/2018 CBA - added channels
                Move (Seq_New_Channel()) to iCh
                Direct_Output channel iCh sRequestFileName
                    Writeln channel iCh sText
                Close_Output channel iCh
                Send Seq_Release_Channel iCh
            End
            
            Move sOutputPath to sResponseFileName
            Append sResponseFileName "\" sDate " - " sComputerName " - Response.txt"

            Get psResponse  to sText
            If (sText <> "") Begin
                // 10/02/2018 CBA - added channels
                Move (Seq_New_Channel()) to iCh
                Direct_Output channel iCh sResponseFileName
                    Writeln channel iCh sText
                Close_Output channel iCh
                Send Seq_Release_Channel iCh
            End

            Set pbSaved to True
        End
    End_Procedure
    
    Procedure LogMessage String sLogName String sMessage
        DateTime dtNow
        String  sOutputPath sComputerName sFileName sDate
        Integer iCh iResult
        Boolean bExists

        Move (CurrentDateTime()) to dtNow
        ConvertToXML xsDateTime dtNow to sDate
        Move (Replaces(":", sDate, ".")) to sDate //Change the : in the time so Windows doesn't freak out.
        Get_Environment "COMPUTERNAME" to sComputerName

        Get psProgramPath of (phoWorkspace(ghoApplication)) to sOutputPath
        Move (Replace("\Programs", sOutputPath, "\Logs\")) to sOutputPath

        //2023-09-20 MRM (Tk#27372) Added
        //Create the log folder If it doesn't exist.
        Get vFolderExists sOutputPath to bExists
        If (not(bExists)) Begin
            Get vshCreateDirectoryEX sOutputPath  to iResult
        End

        Move sOutputPath to sFileName
        Append sFileName "\" sLogName " - " sDate " - " sComputerName ".txt"
        
        // 10/02/2018 CBA - added channels
        Move (Seq_New_Channel()) to iCh
        Append_Output channel iCh sFileName
            Writeln channel ich sMessage
        Close_Output channel iCh
        Send Seq_Release_Channel iCh
    End_Procedure

    Procedure DisplayJSON Handle hReader String sPath String sAction String sRequest String sResponse Boolean bSaveJSON
        String  sValue sType sDataReceived
        Integer iValue iStatus
        UChar[] ucDataReceived

        Set pbSaved to False

        If (pbDisplay(Self)) Begin
            If not (active_state(Self)) Send Activate_View
        End

        Send Delete_Data of frmStyle
        Send Delete_Data of frmEncoding
        
        Set Dynamic_Update_state of txtRequest to False
        Set Dynamic_Update_state of txtResponse to False

        Get psRemoteHost    of hReader  to sValue
        Set Value of frmURL to sValue
        Set Value of frmAction to sAction
        Set Value of frmMethod to sPath

        Get ResponseStatusCode of hReader   to iValue
//        Get LastErrorCode   of hReader  to iValue
        Move iValue to sValue
        Get peJsonTransferStatus    of hReader  to iStatus
        Case Begin
            Case (iStatus = jtsOk)
                Append sValue " - OK - Transmission Successful (Check Response for Logical State)"
                Case Break
            Case (iStatus = jtsHttpRequestFailed)
                Append sValue " - Http request failed"
                Case Break
            Case (iStatus = jtsInvalidContentType)
                Get psContentTypeReceived   of hReader  to sType
                Append sValue " - Invalid contentType received (" sType ")"
                Case Break
            Case (iStatus = jtsNotJson)
                Append sValue " - Non-JSON response received"
                Case Break
            Case (iStatus = jtsError)
                Append sValue " - Other Error"
                Case Break
        Case End
        Set Value of frmStatus to sValue

        If (iStatus <> jtsOk) Begin //Get the string returned on an error so we can show & save it as part of the response
            Get pucDataReceived  of hReader  to ucDataReceived
            Append sResponse C_CRLF C_CRLF (CString(ucDataReceived))
        End

        If (pbRetainPrevious(Self)) Begin //If they're keeping the previous data, add a pair of newlines and the new data
            Get psRequest   to sValue
            Append sValue C_CRLF C_CRLF sRequest
            Set Value   of txtRequest   to sValue
            Set psRequest   to sValue

            Get psResponse  to sValue
            Append sValue C_CRLF C_CRLF sResponse
            Set Value   of txtResponse  to sValue
            Set psResponse  to sValue
        End
        Else Begin
            Set Value   of txtRequest   to sRequest
            Set psRequest   to sRequest

            Set Value   of txtResponse  to sResponse
            Set psResponse  to sResponse
        End

//        If (bSaveJSON or (pbSaveWebServiceFiles(oProperties(Self)))) Begin
        If bSaveJSON Begin
            Send SaveRequestResponse "JSON"
        End

        Send Beginning_of_Data   of txtRequest
        Send Beginning_of_Data   of txtResponse
        Set Dynamic_Update_State of txtRequest to True
        Set Dynamic_Update_State of txtResponse to True
    End_Procedure

    Procedure DisplayAndSaveJSON
        If not (active_state(Self)) Send Activate_View

        Send SaveRequestResponse "JSON"
    End_Procedure

End_Object
