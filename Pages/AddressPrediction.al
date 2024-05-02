page 50101 "AddressPrediction"
{
    Caption = 'Prediction';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = AddressPredictions;
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            repeater(Addresses)
            {
                field(Description; Rec.Description)
                {
                    Editable = false;
                    ApplicationArea = All;
                    trigger OnAssistEdit()
                    begin
                        Place.GetAddressData(Rec.Place_ID);
                        CurrPage.Close();
                    end;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(AddressNotListed)
            {
                ApplicationArea = All;
                ToolTip = 'If the address you are looking for is not listed, it cannot be clearly identified. Please enter the post code of the destination';
                trigger OnAction()
                var
                    SetPostCode: Page SetPostCode;
                begin
                    SetPostCode.GetAddressData(rec.TempLocation);
                    CurrPage.Close();
                    SetPostCode.RunModal();
                    CurrPage.Close();
                end;
            }
        }
    }
    var
        Place: Codeunit Place;
}