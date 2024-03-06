Use Windows.pkg
Use DFClient.pkg
Use cTagsForm.pkg
Use cVendorDataDictionary.dd
Use cInventoryDataDictionary.dd

Deferred_View Activate_oDemoWindowsTags for ;
Object oDemoWindowsTags is a dbView
    Object oVendor_DD is a cVendorDataDictionary
    End_Object

    Object oInventory_DD is a cInventoryDataDictionary
        Set DDO_Server to oVendor_DD
    End_Object

    Set Main_DD to oInventory_DD
    Set Server to oInventory_DD

    Set Border_Style to Border_Thick
    Set Size to 223 296
    Set Location to 2 2
    Set Label to "DemoWindowsTags"
    Set piMinSize to 223 296

    Object oTextBox1 is a TextBox
        Set Auto_Size_State to False
        Set Size to 45 278
        Set Location to 4 10
        Set Label to 'The cTagsForm control is a control that allows the selection of multiple entities (tags), visually represented as boxes. The control is very versatile and allows selection from a list of items as well as inline creation of items. Seeding the list of items is done by creating an object based on the cSelectionSource class that represents a list of selectable items.'
        Set Justification_Mode to JMode_Left
    End_Object

    Object oTagsFormBasic is a cTagsForm
        Set Size to 39 185
        Set Location to 53 100
        Set Label to "Basic Tags (no selection):"
        Set Label_Col_Offset to 90
        Set psValue to "DataFlex, CSS, SQL"
        Set peAnchors to anTopLeftRight

        Procedure OnTagClick tSelectionItem tTag
            Send Info_Box ("You clicked on tag " + tTag.aValues[0]) "Tag click!"
        End_Procedure
        
    End_Object

    Object oButtonAddPsValue is a Button
        Set Size to 14 73
        Set Location to 96 100
        Set Label to 'Add Using psValue'
    
        Procedure OnClick
            String sVal
            Get psValue of oTagsFormBasic to sVal
            Move (If(sVal <> "", sVal + ",", "") + "Javascript") to sVal
            
            Set psValue of oTagsFormBasic to sVal   
        End_Procedure
    
    End_Object

    Object oButtonUpdateTags is a Button
        Set Size to 14 81
        Set Location to 95 204
        Set Label to 'Add Using UpdateTags'
        Set peAnchors to anTopRight
    
        Procedure OnClick
            String[] aTags
            Get GetTags of oTagsFormBasic to aTags
            Move "HTML" to aTags[SizeOfArray(aTags)]
            Send UpdateTags of oTagsFormBasic aTags
        End_Procedure
    
    End_Object

    Object oButtonRemoveTag is a Button
        Set Size to 14 73
        Set Location to 114 100
        Set Label to 'Remove First Tag'
    
        Procedure OnClick
            String[] aTags
            
            Get GetTags of oTagsFormBasic to aTags
            If (SizeOfArray(aTags) > 0) Begin
                Move (RemoveFromArray(aTags, 0)) to aTags
                Send UpdateTags of oTagsFormBasic aTags
            End
        End_Procedure
    
    End_Object

    Object oTagsFormTableSource is a cTagsForm
        Set Size to 39 185
        Set Location to 132 100
        Set Label to "Table Source (Inventory):"
        Set Label_Col_Offset to 90
        Set psValue to "UNIXGUIDE,UPDATE,VINO-LM"
        Set peAnchors to anTopLeftRight
//        Set Prompt_Button_Mode to PB_PromptOn
    
        Object oSelectionSource is a cSelectionSource
            Entry_Item Inventory.Item_ID
            Set Server to oInventory_DD
        End_Object

    End_Object

    Object oTagsFormStaticSource is a cTagsForm
        Set Size to 39 185
        Set Location to 175 100
        Set Label to "Static Source:"
        Set Label_Col_Offset to 90
        Set psValue to "DataFlex, SQL"
        Set peAnchors to anAll
        Set pbAllowCreate to True
    
        Object oSelectionSource is a cSelectionSource
            Set pbAllData to True
                
            Procedure OnLoadAllItems tSelectionItem[] ByRef aItems
                Move "DataFlex" to aItems[0].aValues[0]
                Move "CSS" to aItems[1].aValues[0]
                Move "HTML" to aItems[2].aValues[0]
                Move "JavaScript"to aItems[3].aValues[0]
                Move "JSON" to aItems[4].aValues[0]
                Move "SQL" to aItems[5].aValues[0]
            End_Procedure
        End_Object

    End_Object

Cd_End_Object
