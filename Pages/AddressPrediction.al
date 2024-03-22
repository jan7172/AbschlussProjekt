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
                    var
                        AddressPrediction: Page AddressPrediction;
                    begin
                        Place.GetAddressData(Rec.Place_ID);
                        Close();
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
                    SetPostCode: Record SetPostCode;
                    SetPostCodeAsPage: Page SetPostCode;
                begin
                    SetPostCode.Init();
                    SetPostCode.TempLocation := Rec.TempLocation;
                    SetPostCode.Insert();
                    Page.RunModal(50103, SetPostCode);
                end;
            }
        }
    }
    var
        Place: Codeunit Place;
}