/// <summary>
/// Page PlaceApiSetup (ID 50100).
/// </summary>
page 50100 "PlaceApiSetup"
{
    Caption = 'Place Api Setup';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = PlaceAPISetup;

    layout
    {
        area(Content)
        {
            group(Setup)
            {
                field(APiKey; Rec.APiKey)
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        checkIfApiKeyIsValid();
                        changeAPIKey();
                    end;
                }
                field(LanguageCode; Rec.LanguageCode)
                {
                    ApplicationArea = All;
                }
                field("Test/Dev Settings"; EnableDevSettings)
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        if EnableDevSettings = true then begin
                            DevSettingVisibility := true;
                        end else
                            if EnableDevSettings = false then begin
                                DevSettingVisibility := false;
                            end;
                    end;
                }

            }
            group("Test/Dev")
            {
                Visible = DevSettingVisibility;
                field(TestLocation; Rec.TestLocation)
                {
                    ApplicationArea = All;
                    ToolTip = 'Just For Develope Purposes', Locked = false, Comment = 'Translate this ToolTip.';
                    trigger OnValidate()
                    var
                        place: Codeunit Place;
                    begin
                        place.GetPredictions(Rec.TestLocation);
                    end;
                }
            }
        }
    }
    var
        TempKey: Text[255];
        DevSettingVisibility: Boolean;
        EnableDevSettings: Boolean;

    /// <summary>
    /// Checks whether the entered API key is empty
    /// </summary>
    local procedure CheckIfApiKeyIsEmpty()
    var
        ApiKeyEmptyErrorLbl: Label 'Api Key is empty.';
    begin
        if Rec.FindLast() then;
        TempKey := Rec.APiKey;
        if Rec.APiKey = '' then begin
            Message(Format(ApiKeyEmptyErrorLbl));
        end;
    end;


    /// <summary>
    /// Changes the API key
    /// </summary>
    local procedure ChangeAPIKey()
    var
        ChangeKeyLbl: Label 'Change API Key?';
        ApiKeyChangedLbl: Label 'API Key sucessfull changed';
    begin
        if Dialog.Confirm(Format(ChangeKeyLbl)) then begin //<--UserInput is yes
            Message(Format(ApiKeyChangedLbl));
        end else begin //<--UsetInput is no
            Rec.Delete();
            Rec.APiKey := TempKey;
            Rec.Insert();
        end;
    end;

    /// <summary>
    /// Checks whether the entered API key is valid
    /// </summary>
    local procedure CheckIfApiKeyIsValid()
    var
        HttpClient: HttpClient;
        ResponseMessage: HttpResponseMessage;
        ResponseMessageAsString: Text;
        JsonContent: JsonObject;
        JsonContentAsToken: JsonToken;
        ErrorMessageAsString: Text;
        MoreDetailsLbl: Label '\ More Details?';
    begin
        if HttpClient.Get('https://maps.googleapis.com/maps/api/place/autocomplete/json?key=' + Rec.APiKey + '&input=New York', ResponseMessage) then begin
            ResponseMessage.Content.ReadAs(ResponseMessageAsString);
            JsonContent.ReadFrom(ResponseMessageAsString);
            if JsonContent.Get('error_message', JsonContentAsToken) then begin
                ErrorMessageAsString := Format(JsonContentAsToken).Replace('"', '') + MoreDetailsLbl;
                if Dialog.Confirm(ErrorMessageAsString) then begin
                    Message(Format(ResponseMessageAsString));
                end else begin
                end;
            end;
        end;
    end;

    trigger OnOpenPage()
    begin
        CheckIfApiKeyIsEmpty();
    end;
}