Use Windows.pkg
Use DFClient.pkg
Use File_dlg.pkg
Use cTextEdit.pkg
Use cSelectFolderDialog.pkg
Use cCJGrid.pkg
Use cCJGridColumn.pkg

Deferred_View Activate_oDemoDialogs for ;
Object oDemoDialogs is a dbView

    Set Border_Style to Border_Thick
    Set Size to 152 335
    Set Location to 3 3
    Set Label to "Dialogs Demo"

    Object oSelectFolderDialog1 is a cSelectFolderDialog
    End_Object

    Object oSelectFolderButton is a Button
        Set Size to 14 73
        Set Location to 5 6
        Set Label to "Select Folder to Open"
    
        // fires when the button is clicked
        Procedure OnClick
            String sFolder sInitialFolder
            
            Get Value of oInitialFolder to sInitialFolder
            Get SelectFolder of oSelectFolderDialog1 "Select a Folder" sInitialFolder to sFolder
            If (sFolder <> "") Begin
                Set Value of oSelectedFolder to sFolder
            End
            Else ;
                Set Value of oSelectedFolder to "No Folder Selected"
        End_Procedure
    
    End_Object
    
    Object oInitialFolder is a Form
        Set Size to 12 201
        Set Location to 6 129
        Set peAnchors to anTopLeftRight
        Set Label to "Initial Folder:"
        Set Label_Col_Offset to 46
    End_Object

    Object oSelectedFolder is a Form
        Set Size to 12 247
        Set Location to 22 83
        Set peAnchors to anTopLeftRight
        Set Label to "Selected Folder:"
        Set Label_Col_Offset to 56
    End_Object

    Object oOpenDialog1 is a OpenDialog
        // this allows for selection of more than 1 file in the dialog
        Set MultiSelect_State to True
    End_Object

    Object oSelectFileButton is a Button
        Set Size to 14 73
        Set Location to 44 6
        Set Label to "Select File(s) to Open"
    
        // fires when the button is clicked
        Procedure OnClick
            Boolean bOk
            String[] sSelectedFiles sBlankFiles
            String sFiles
            Integer i iCount
            
            Get Show_Dialog of oOpenDialog1 to bOk
            If (bOk) Begin
                Get Selected_Files of oOpenDialog1 to sSelectedFiles
                Send LoadData of oSelectedFiles sSelectedFiles
            End
            Else Begin
                // send blank array to LoadData
                // because if bOk = False, Selected_Files will contain
                // data from the last successful dialog call
                Send LoadData of oSelectedFiles sBlankFiles
            End            
        End_Procedure
    
    End_Object

    Object oSelectedFiles is a cCJGrid
        Set Location to 45 83
        Set Size to 101 246
        Set peAnchors to anAll
        
        Procedure LoadData String[] TheFiles
            tDataSourceRow[] TheData
            Integer i
            
            If (SizeOfArray(TheFiles) > 0) Begin
                For i from 0 to (SizeOfArray(TheFiles)-1)
                    Move TheFiles[i] to TheData[i].sValue[0]
                Loop
            End
            Else Begin
                Move "No File(s) Selected" to TheData[0].sValue[0]
            End
            
            Send InitializeData TheData
            Send MoveToFirstRow
        End_Procedure

        Object oCJGridColumn1 is a cCJGridColumn
            Set piWidth to 410
            Set psCaption to "File Name"
        End_Object

    End_Object

Cd_End_Object
