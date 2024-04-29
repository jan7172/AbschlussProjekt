/// <summary>
/// Page SetPostCode (ID 50103).
/// </summary>
page 50103 "SetPostCode"
{
    Caption = 'SetPostCode';
    PageType = CardPart;
    // SourceTable = SetPostCode;
    // SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            group(Main)
            {
                field(TempPostCode; TempPostCode)
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        AddressPrediction: Record AddressPredictions;
                    begin
                        SetPostCode(TempPostCode);
                        CurrPage.Close();
                    end;
                }
            }
        }
    }

    local procedure SetPostCode(PostCode: Text[20])
    begin
        TempPostCode := PostCode;
    end;

    /// <summary>
    /// GetAddressData.
    /// </summary>
    /// <param name="Address">Text[255].</param>
    procedure GetAddressData(Address: Text[255])
    var
        PostCode: Text[20];
    begin
        TempLocation := Address;
        Page.RunModal(50103);
        Place.CheckForUpdatedPostCodeByUser(TempPostCode + ' ' + TempLocation);
    end;

    var
        TempPostCode: Text[20];
        TempLocation: Text[255];
        Place: Codeunit Place;
}

// Die Daten BEIM AUFRUFEN DER PAGE (setPostCode) übergeben.

//In der Page (SetPostCode) eine Funktion und eine lokale Variable. Bevor ich die Page aufrufe übergebe ich den Record

//Geht mit eienm RunModal einfach so nicht