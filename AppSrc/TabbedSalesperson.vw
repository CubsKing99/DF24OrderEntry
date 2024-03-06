Use dfClient.pkg
Use DataDict.pkg
Use dfEntry.pkg
Use cDbScrollingContainer.pkg
Use cSalesPersonDataDictionary.DD

Deferred_View Activate_oTabbedSalesPersonView for ;
;
Object oTabbedSalesPersonView is a dbView
    Set Border_Style to Border_None
    Set Label to "Sales Person Entry View"
    Set Location to 6 6
    Set Size to 51 245
    Set piMaxSize to 51 245
    
    Object SalesP_DD is a cSalespersonDataDictionary
    End_Object
    
    Set Main_DD to SalesP_DD
    Set Server to SalesP_DD
    
    Object oScrollingContainer1 is a cDbScrollingContainer
        
        Object oScrollingClientArea1 is a cDbScrollingClientArea
            
            Object oSalesPerson_ID is a dbForm
                Entry_Item SalesPerson.ID
                Set Label to "Sales Person ID:"
                Set Size to 12 46
                Set Location to 4 70
                Set Label_Col_Offset to 2
                Set Label_Justification_Mode to jMode_Right
            End_Object
            
            Object oSalesPerson_Name is a dbForm
                Entry_Item SalesPerson.Name
                Set Label to "Sales Person Name:"
                Set Size to 12 156
                Set Location to 19 70
                Set Label_Col_Offset to 2
                Set Label_Justification_Mode to jMode_Right
            End_Object
            
        End_Object
    End_Object
    
Cd_End_Object


