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
                    ToolTip = 'Just For Develope Purposes';
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
    begin
        if Rec.FindLast() then;
        TempKey := Rec.APiKey;
        if Rec.APiKey = '' then begin
            Message('API Key is empty');
        end;
    end;


    /// <summary>
    /// Changes the API key
    /// </summary>
    local procedure ChangeAPIKey()
    begin
        if Dialog.Confirm('Change API Key?') then begin //<--UserInput is yes
            Message('API Key sucessfull changed');
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
    begin
        if HttpClient.Get('https://maps.googleapis.com/maps/api/place/autocomplete/json?key=' + Rec.APiKey + '&input=New York', ResponseMessage) then begin
            ResponseMessage.Content.ReadAs(ResponseMessageAsString);
            JsonContent.ReadFrom(ResponseMessageAsString);
            if JsonContent.Get('error_message', JsonContentAsToken) then begin
                ErrorMessageAsString := Format(JsonContentAsToken).Replace('"', '') + '\ More Details?';
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