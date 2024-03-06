Use dfClient.pkg
Use DataDict.pkg
Use dfEntry.pkg

Use cSalesPersonDataDictionary.dd

Deferred_View Activate_oSalesPersonView for ;
;
Object oSalesPersonView is a dbView
    Set Border_Style to Border_None
    Set Label to "Sales Person Entry View"
    Set Location to 6 6
    Set Size to 51 245
    
    Object oSalesPersonDataDictionary is a cSalesPersonDataDictionary
    End_Object
    
    Set Main_DD to oSalesPersonDataDictionary
    Set Server to oSalesPersonDataDictionary
    
    Object oSalesPerson_ID is a dbForm
        Entry_Item SalesPerson.ID
        Set Label to "Sales Person ID:"
        Set Size to 12 46
        Set Location to 11 69
        Set Label_Col_Offset to 2
        Set Label_Justification_Mode to jMode_Right
    End_Object
    
    Object oSalesPerson_Name is a dbForm
        Entry_Item SalesPerson.Name
        Set Label to "Sales Person Name:"
        Set Size to 12 156
        Set Location to 25 69
        Set Label_Col_Offset to 2
        Set Label_Justification_Mode to jMode_Right
    End_Object
        
    
Cd_End_Object


