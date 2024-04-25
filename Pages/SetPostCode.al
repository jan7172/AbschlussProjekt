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
            group(Main)
            {
                field(TempPostCode; TempPostCode)
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        Place: Codeunit Place;
                        AddressPrediction: Record AddressPredictions;
                    begin
                        if rec.FindLast() then
                            Message('test');
                        Place.CheckForUpdatedPostCodeByUser(TempPostCode + ' ' + TempAddress);
                        Close();
                    end;
                }
                field(TempAddress; TempAddress)
                {

                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        if rec.FindSet() then;
        if rec.Get(1) then
            Message('test123');
        TempAddress := Rec.TempLocation;
    end;

    var
        TempPostCode: Text[20];
        TempLocation: Text[255];
        TempAddress: Text[255];
}

// Die Daten BEIM AUFRUFEN DER PAGE (setPostCode) übergeben.