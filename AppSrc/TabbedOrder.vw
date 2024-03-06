Use dfClient.pkg
Use DataDict.pkg
Use dfEntry.pkg
Use dfSpnEnt.pkg
Use dfCEntry.pkg
Use Windows.pkg
Use cDbScrollingContainer.pkg
Use cVendorDataDictionary.DD
Use cInventoryDataDictionary.DD
Use cCustomerDataDictionary.DD
Use cSalesPersonDataDictionary.DD
Use cOrderHeaderDataDictionary.DD
Use cOrderDetailDataDictionary.DD
Use cDbCJGrid.pkg
Use cCJGridColumnRowIndicator.pkg
Use MonthCalendarPrompt.dg

Use cDRReport.pkg
Use cDRPreview.pkg
Use DRStatuspanel.dg

Activate_View Activate_oTabbedOrderEntryView for oTabbedOrderEntryView
Object oTabbedOrderEntryView is a dbView
    Set Border_Style to Border_Thick
    Set Label to "Order Entry"
    Set Location to 2 3
    Set Size to 174 383
    Set piMinSize to 174 383
    Set pbAutoActivate to True

// If piMaxSize not set or is 0, it stretches to full length
//    Set piMaxSize to 300 450

    Object Vendor_DD is a cVendorDataDictionary
    End_Object

    Object Invt_DD is a cInventoryDataDictionary
        Set DDO_Server to Vendor_DD
    End_Object

    Object Customer_DD is a cCustomerDataDictionary
    End_Object

    Object SalesP_DD is a cSalespersonDataDictionary
    End_Object

    Object OrderHea_DD is a cOrderHeaderDataDictionary
        Set DDO_Server to Customer_DD
        Set DDO_Server to SalesP_DD

        // this lets you save a new OrderHea from within OrderDtl.
        Set Allow_Foreign_New_Save_State to True
    End_Object

    Object OrderDtl_DD is a cOrderDetailDataDictionary
        Set DDO_Server to OrderHea_DD
        Set DDO_Server to Invt_DD
        Set Constrain_File to OrderHeader.File_Number
    End_Object

    Set Main_DD to OrderHea_DD
    Set Server to OrderHea_DD

    Object oScrollingContainer1 is a cDbScrollingContainer

        Object oScrollingClientArea1 is a cDbScrollingClientArea
            Set pbAutoScroll to False

            Object oOrderHea_Order_Number is a dbForm
                Entry_Item OrderHeader.Order_Number
                Set Label to "Order Number:"
                Set Size to 12 42
                Set Location to 8 63
                Set peAnchors to anTopLeft
                Set Label_Col_Offset to 2
                Set Label_Justification_Mode to jMode_Right

            End_Object

            Object oOrderHea_Customer_Number is a dbForm
                Entry_Item Customer.Customer_Number
                Set Label to "Customer Number:"
                Set Size to 12 42
                Set Location to 8 201
                Set peAnchors to anTopRight
                Set Label_Col_Offset to 2
                Set Label_Justification_Mode to jMode_Right
            End_Object

            Object oOrderHea_Order_Date is a dbForm
                Entry_Item OrderHeader.Order_Date
                Set Label to "Order Date:"
                Set Size to 12 67
                Set Location to 8 299
                Set peAnchors to anTopRight
                Set Label_Col_Offset to 2
                Set Label_Justification_Mode to jMode_Right

                Set Prompt_Object to oMonthCalendarPrompt
                Set Prompt_Button_Mode to PB_PromptOn
            End_Object

            Object oCustomer_Name is a dbForm
                Entry_Item Customer.Name
                Set Label to "Customer Name:"
                Set Size to 12 180
                Set Location to 22 63
                Set peAnchors to anTopLeftRight
                Set Label_Col_Offset to 2
                Set Label_Justification_Mode to jMode_Right
            End_Object

            Object oCustomer_Address is a dbForm
                Entry_Item Customer.Address
                Set Label to "Street Address:"
                Set Size to 12 180
                Set Location to 36 63
                Set peAnchors to anTopLeftRight
                Set Label_Col_Offset to 2
                Set Label_Justification_Mode to jMode_Right
            End_Object

            Object oCustomer_City is a dbForm
                Entry_Item Customer.City
                Set Label to "City/State/Zip:"
                Set Size to 12 84
                Set Location to 50 63
                Set peAnchors to anTopLeftRight
                Set Label_Col_Offset to 2
                Set Label_Justification_Mode to jMode_Right
            End_Object

            Object oCustomer_State is a dbForm
                Entry_Item Customer.State
                Set Size to 12 20
                Set Location to 50 155
                Set peAnchors to anTopRight
            End_Object

            Object oCustomer_Zip is a dbForm
                Entry_Item Customer.Zip
                Set Size to 12 60
                Set Location to 50 183
                Set peAnchors to anTopRight
            End_Object

            Object oOrderHea_Ordered_By is a dbForm
                Entry_Item OrderHeader.Ordered_By
                Set Label to "Ordered By:"
                Set Size to 12 67
                Set Location to 37 299
                Set peAnchors to anTopRight
                Set Label_Col_Offset to 2
                Set Label_Justification_Mode to jMode_Right
            End_Object

            Object oOrderHea_Salesperson_ID is a dbForm
                Entry_Item SalesPerson.Id
                Set Label to "Salesperson ID:"
                Set Size to 12 40
                Set Location to 50 299
                Set peAnchors to anTopRight
                Set Label_Col_Offset to 2
                Set Label_Justification_Mode to jMode_Right
            End_Object

            Object oOrderHea_Terms is a dbComboForm
                Entry_Item OrderHeader.Terms
                Set Label to "Terms:"
                Set Size to 12 85
                Set Location to 64 63
                Set peAnchors to anTopLeft
                Set Form_Border to 0
                Set Label_Col_Offset to 2
                Set Label_Justification_Mode to jMode_Right

            End_Object

            Object oOrderHea_Ship_Via is a dbComboForm
                Entry_Item OrderHeader.Ship_Via
                Set Label to "Ship Via:"
                Set Size to 12 103
                Set Location to 64 183
                Set peAnchors to anTopRight
                Set Form_Border to 0
                Set Label_Col_Offset to 2
                Set Label_Justification_Mode to jMode_Right

            End_Object

            Object oOrderDtl_Grid is a cDbCJGrid
                Set Server to OrderDtl_DD
                Set Ordering to 1
                Set Size to 63 377
                Set Location to 90 3
                Set peAnchors to anAll
                Set pbAllowInsertRow to False
                Set pbRestoreLayout to False
                Set psLayoutSection to "OrderView_oOrderDtl_Grid2"
                Set piLayoutBuild to 6
                Set pbHeaderPrompts to True

                On_Key Key_F11 Send Request_InsertRow

                Object oMark is a cCJGridColumnRowIndicator
                End_Object

                Object oInvt_Item_ID is a cDbCJGridColumn
                    Entry_Item Inventory.Item_ID
                    Set piWidth to 91
                    Set psCaption to "Item ID"
                    Set psImage to "ActionPrompt.ico"
                End_Object

                Object oInvt_Description is a cDbCJGridColumn
                    Entry_Item Inventory.Description
                    Set piWidth to 213
                    Set psCaption to "Description"
                End_Object

                Object oInvt_Unit_Price is a cDbCJGridColumn
                    Entry_Item Inventory.Unit_Price
                    Set piWidth to 53
                    Set psCaption to "Unit Price"
                End_Object

                Object oOrderDtl_Qty_Ordered is a cDbCJGridColumn
                    Entry_Item OrderDetail.Qty_Ordered
                    Set piWidth to 50
                    Set psCaption to "Quantity"
                End_Object

                Object oOrderDtl_Price is a cDbCJGridColumn
                    Entry_Item OrderDetail.Price
                    Set piWidth to 62
                    Set psCaption to "Price"
                End_Object

                Object oOrderDtl_Extended_Price is a cDbCJGridColumn
                    Entry_Item OrderDetail.Extended_Price
                    Set piWidth to 81
                    Set psCaption to "Total"
                End_Object

            End_Object

            Object oOrderHea_Order_Total is a dbForm
                Entry_Item OrderHeader.Order_Total
                Set Label to "Order Total:"
                Set Size to 12 60
                Set Location to 158 320
                Set peAnchors to anBottomRight
                Set Label_Col_Offset to 3
                Set Label_Justification_Mode to jMode_Right
            End_Object

            Object oPrintBtn is a Button
                Set Label to "Print Order"
                Set Location to 158 3
                Set peAnchors to anBottomLeft
                Set psToolTip to "Print preview of current order"
        
                Procedure OnClick
                    Delegate Send PrintCurrentOrder // defined in view object
                End_Procedure        
            End_Object

            Object oShowCustomerModalBtn is a Button
                Set Size to 14 72
                Set Label to "Modal Customer"
                Set Location to 158 58
                Set peAnchors to anBottomLeft
                Set psToolTip to "Open Customer View Modal"

                Procedure OnClick
                    Handle hoView
                    Boolean bActive
                    // make sure view is created if deferred.
                    Get Activate_oTabbedCustomerView_Handle to hoView
                    Get Active_State of oTabbedCustomerView to bActive
                    If (bActive) Begin
                        Send Close_Panel of oTabbedCustomerView
                    End
                    Send Popup_Modal of oTabbedCustomerView
                End_Procedure
            End_Object

            // Change:   Create custom confirmation messages for save and delete
            //           We must create the new functions and assign verify messages
            //           to them.
            Function Confirm_Delete_Order Returns Integer
                Integer iRetVal
                Get Confirm "Delete Entire Order?" to iRetVal
                Function_Return iRetVal
            End_Function

            // Only confirm on the saving of new records
            Function Confirm_Save_Order Returns Integer
                Integer iNoSave iSrvr
                Boolean bOld
                Get Server to iSrvr
                Get HasRecord of iSrvr to bOld
                If not bOld Begin
                    Get Confirm "Save this NEW order header?" to iNoSave
                End
                Function_Return iNoSave
            End_Function

            // Define alternate confirmation Messages
            Set Verify_Save_MSG       to (RefFunc(Confirm_Save_Order))
            Set Verify_Delete_MSG     to (RefFunc(Confirm_Delete_Order))
            Set Auto_Clear_DEO_State  to False // don't clear Header on save

            Object oOrderReport is a cDRReport
                Set pbShowStatusPanel to True
                Set phoStatusPanel to oDRStatusPanel
                Set psReportName to "Orders with Pagelayers.dr"
                Set peOutputDestination to PRINT_TO_WINDOW

                Procedure OnCreate
                    String sReportId

                    Forward Send OnCreate

                    Get psReportId to sReportId
                    Set piReportLanguage sReportId to LANG_DEFAULT
                End_Procedure

                Procedure OnInitializeReport
                    Forward Send OnInitializeReport

                    Send SetFilters
                    Send SetParameters
                End_Procedure

                // Determine the path to the codemast.dat table and set the report parameter
                Procedure SetParameters
                    String sReportId sCodeMastPath
                    Integer iParameter

                    Get psReportId to sReportId

                    Get_File_Path "CodeMast.dat" to sCodeMastPath
                    Move (ExtractFilePath (sCodeMastPath)) to sCodeMastPath
                    Get ParameterIdByName sReportId "CodeMastPath" to iParameter
                    Set psParameterValue sReportId iParameter to sCodeMastPath
                End_Procedure

                // Set the report filter to the current orderheader ordernumber
                Procedure SetFilters
                    String sReportId
                    String sOrderHeaderOrderNumber

                    Get psReportId to sReportId

                    // Remove all the defined filters from the report
                    Send RemoveAllFilters sReportId

                    // Get the current order number from the Orderheader DDO
                    Get Field_Current_Value of OrderHea_DD Field Orderheader.Order_Number to sOrderHeaderOrderNumber
                    Send AddFilter sReportId "{OrderHeader.Order_Number}" C_drEqual sOrderHeaderOrderNumber
                End_Procedure
            End_Object

            // print the current order. This message will be sent
            // by the print button
            Procedure PrintCurrentOrder
                Boolean bHasRecord
        
                Get HasRecord of OrderHea_DD to bHasRecord
                If (bHasRecord) Begin // only do this if record exists
                    Send RunReport of oOrderReport
                End
            End_Procedure

            // refresh is sent to containers. We will use that to control the print button and only
            // enable it when an order exists
            Procedure Refresh Integer eMode
                Boolean bRec
                                
                Forward Send Refresh eMode
        
                Get HasRecord of OrderHea_DD to bRec
                Set Enabled_State of oPrintBtn to bRec
            End_Procedure
        End_Object
    End_Object
End_Object
