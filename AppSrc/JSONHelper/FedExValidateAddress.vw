Use Windows.pkg
Use DFClient.pkg
Use APIStructs\FedExAddressValidationAPI.pkg
Use APIStructs\FedExValidateAddress\stFedExAddressRequest.pkg
Use JSONHelper\FedExAccount.bp

Activate_View Activate_oFedExValidateAddress for oFedExValidateAddress
Object oFedExValidateAddress is a dbView

    Object oFedExAddressValidationAPI is a cFedExAddressValidationAPI
        Set phHelper to oWebServiceHelper
        Set pbDisplay of oWebServiceHelper to True
    End_Object

    Set Border_Style to Border_Thick
    Set Size to 76 208
    Set Location to 2 2
    Set Label to "Validate Address with FedEx"
    Set pbAutoActivate to True

    Object frmStreet1 is a Form
        Set Size to 12 100
        Set Location to 10 55
        Set Label to "Street"
        Set Label_Col_Offset to 2
        Set Label_Justification_Mode to JMode_Right
        Set Value to "650 Weber Dr"
    End_Object

    Object frmStreet2 is a Form
        Set Size to 12 100
        Set Location to 25 55
        Set Value to "c/o IT Department"
    End_Object

    Object frmCity is a Form
        Set Size to 12 60
        Set Location to 40 55
        Set Label to "City/State/ZIP"
        Set Label_Col_Offset to 2
        Set Label_Justification_Mode to JMode_Right
        Set Value to "Geneseo"
    End_Object

    Object frmState is a Form
        Set Size to 12 30
        Set Location to 40 120
        Set Value to "IL"
    End_Object

    Object frmZIP is a Form
        Set Size to 12 40
        Set Location to 40 155
        Set Value to "61254"
    End_Object

    Object btnValidate is a Button
        Set Location to 55 55
        Set Label to "Validate"

        Procedure OnClick
            stFedExAddressRequest tAddress
            FedExAccountInfo tAcctInfo
            Boolean bValid

            Get Value   of frmStreet1   to tAddress.addressesToValidate[0].tAddress.streetLines[0]
            Get Value   of frmStreet2   to tAddress.addressesToValidate[0].tAddress.streetLines[0]
            Get Value   of frmCity      to tAddress.addressesToValidate[0].tAddress.city
            Get Value   of frmState     to tAddress.addressesToValidate[0].tAddress.stateOrProvinceCode
            Get Value   of frmZIP       to tAddress.addressesToValidate[0].tAddress.postalCode
            Move "US"   to tAddress.addressesToValidate[0].tAddress.countryCode

            Get LoadFedExAccountInfo    of bpFedExAccountInfo   to tAcctInfo

            Get ValidateAddress of oFedExAddressValidationAPI tAddress tAcctInfo.sClientID tAcctInfo.sClientPass tAcctInfo.sAccountNum    to bValid
        End_Procedure
    End_Object

End_Object
