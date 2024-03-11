/// <summary>
/// Page SetPostCode (ID 50103).
/// </summary>
page 50103 "SetPostCode"
{
    Caption = 'SetPostCode';
    PageType = CardPart;
    SourceTable = SetPostCode;
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            repeater(Main)
            {
                field(TempPostCode; Rec.TempPostCode)
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    var
                        Place: Codeunit Place;
                    begin
                        Place.CheckForUpdatedPostCodeByUser(Rec.TempPostCode);
                        Close();
                    end;
                }
            }
        }
    }
}