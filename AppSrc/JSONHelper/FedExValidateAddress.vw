Use Windows.pkg
Use DFClient.pkg
Use APIStructs\FedExAddressValidationAPI.pkg
Use APIStructs\FedExValidateAddress\stFedExAddressRequest.pkg
Use APIStructs\FedExValidateAddress\stFedExAddressResponse.pkg
Use JSONHelper\FedExAccount.bp

Activate_View Activate_oFedExValidateAddress for oFedExValidateAddress
Object oFedExValidateAddress is a dbView

    Object oFedExAddressValidationAPI is a cFedExAddressValidationAPI
        Set phHelper to oWebServiceHelper
        Set pbDisplay of oWebServiceHelper to True
    End_Object

    Set Border_Style to Border_Thick
    Set Size to 92 208
    Set Location to 2 2
    Set Label to "Validate Address with FedEx REST API"
    Set piMaxSize to 92 208

    Object frmName is a Form
        Set Size to 12 100
        Set Location to 10 55
        Set Label to "Name"
        Set Label_Col_Offset to 2
        Set Label_Justification_Mode to JMode_Right
        Set Value to "Springfield Armory"
    End_Object

    Object frmStreet1 is a Form
        Set Size to 12 100
        Set Location to 25 55
        Set Label to "Street"
        Set Label_Col_Offset to 2
        Set Label_Justification_Mode to JMode_Right
        Set Value to "650 Weber Dr"
    End_Object

    Object frmStreet2 is a Form
        Set Size to 12 100
        Set Location to 40 55
        Set Value to "c/o IT Department"
    End_Object

    Object frmCity is a Form
        Set Size to 12 60
        Set Location to 55 55
        Set Label to "City/State/ZIP"
        Set Label_Col_Offset to 2
        Set Label_Justification_Mode to JMode_Right
        Set Value to "Geneseo"
    End_Object

    Object frmState is a Form
        Set Size to 12 30
        Set Location to 55 120
        Set Value to "IL"
    End_Object

    Object frmZIP is a Form
        Set Size to 12 40
        Set Location to 55 155
        Set Value to "61254"
    End_Object

    Object btnValidate is a Button
        Set Location to 70 55
        Set Label to "Validate"

        Procedure OnClick
            stFedExAddressRequest tAddress
            stFedExAddressResponse tResponse
            FedExAccountInfo tAcctInfo
            Boolean bValid
            String  sResponseAddress

            Get Value   of frmName      to tAddress.addressesToValidate[0].contact.companyName

            Get Value   of frmStreet1   to tAddress.addressesToValidate[0].tAddress.streetLines[0]
            Get Value   of frmStreet2   to tAddress.addressesToValidate[0].tAddress.streetLines[1]
            Get Value   of frmCity      to tAddress.addressesToValidate[0].tAddress.city
            Get Value   of frmState     to tAddress.addressesToValidate[0].tAddress.stateOrProvinceCode
            Get Value   of frmZIP       to tAddress.addressesToValidate[0].tAddress.postalCode
            Move "US"   to tAddress.addressesToValidate[0].tAddress.countryCode

            Get LoadFedExAccountInfo    of bpFedExAccountInfo   to tAcctInfo

            Get ValidateAddress of oFedExAddressValidationAPI tAddress tAcctInfo.sClientID tAcctInfo.sClientPass tAcctInfo.sAccountNum    to bValid
            Get ptFedExAddressResponse  of oFedExAddressValidationAPI   to tResponse

            Case Begin
                Case (not(bValid))
                    Send UserError "The address could not be validated." "Validation Error"
                    Case Break
                Case (SizeOfArray(tResponse.errors) > 0)
                    Send UserError (SFormat("Error %1 - %2", tResponse.errors[0].code, tResponse.errors[0].message)) "FedEx Error"
                    Case Break
                Case (SizeOfArray(tResponse.Output.resolvedAddresses) > 0)
                    If (SizeOfArray(tResponse.Output.resolvedAddresses[0].streetLinesToken) > 0) Begin
                        Send Info_Box (SFormat("The resolved address is%1%1%2%1%3, %4 %5", C_CRLF, tResponse.Output.resolvedAddresses[0].streetLinesToken[0], tResponse.Output.resolvedAddresses[0].cityToken, tResponse.Output.resolvedAddresses[0].stateOrProvinceCode, tResponse.Output.resolvedAddresses[0].parsedPostalCode.base)) "Address Parsed"
                    End
                    Else Begin
                        Send UserError "FedEx says they validated the address, but they didn't give us back a parsed address..." "What's Going On?"
                    End
                    Case Break
                Case Else
                    Send UserError "Something weird happened..." "Unknown Error"
                    Case Break
            Case End
        End_Procedure
    End_Object

End_Object
