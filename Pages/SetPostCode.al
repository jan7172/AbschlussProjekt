/// <summary>
/// Page Set Postode (ID 50103).
/// </summary>
page 50103 "SetPostCode"
{
    Caption = 'SetPostCode';
    PageType = CardPart;

    layout
    {
        area(Content)
        {
            group(Main)
            {
                Caption = 'Post Code';
                field(TempPostCode; TempPostCode)
                {
                    Caption = 'Enter Post Code';
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnClosePage()
    begin
        Page.RunModal(50101, Place.GetPredictions(TempPostCode + ' ' + TempLocation));
    end;

    /// <summary>
    /// Transmits addressdata.
    /// </summary>
    /// <param name="Address">Text[255].</param>we
    procedure GetAddressData(Address: Text[255])
    var
        PostCode: Text[20];
    begin
        TempLocation := Address;
    end;

    var
        TempPostCode: Text[20];
        TempLocation: Text[255];
        Place: Codeunit Place;
}