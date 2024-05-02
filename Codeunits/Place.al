/// <summary>
/// Codeunit Place (ID 50100). Google Place API
/// </summary>
codeunit 50100 Place
{
    /// <summary>
    /// Checks whether an address is valid and suggests address predictions.
    /// </summary>
    /// <param name="LocationInput">Location | Text[255].</param>
    procedure GetPredictions(LocationInput: Text[255])
    var
        PredictionArray: JsonArray;
        DescriptionArrayAsToken: JsonToken;
        DescriptionArray: JsonArray;
        PlaceIDAsToken: JsonToken;

    begin
        if PlaceSetup.FindLast() then begin
            if PlaceSetup.APiKey <> '' then begin
                AddressPrediction.DeleteAll();
                if TempUpdatedPostCode = '' then begin
                    HttpClient.Get('https://maps.googleapis.com/maps/api/place/autocomplete/json?key=' + PlaceSetup.APiKey + '&language=' + PlaceSetup.LanguageCode + '&input=' + LocationInput, ResponseMessage);
                    TempAddress := LocationInput;
                end else
                    if TempUpdatedPostCode <> '' then begin
                        HttpClient.Get('https://maps.googleapis.com/maps/api/place/autocomplete/json?key=' + PlaceSetup.APiKey + '&language=' + PlaceSetup.LanguageCode + '&input=' + TempAddress, ResponseMessage);
                    end;
                ResponseMessage.Content.ReadAs(ResponseJsonAsString);
                JsonContent.ReadFrom(ResponseJsonAsString);
                JsonContent.Get('predictions', JsonContentAsToken);
                PredictionArray := JsonContentAsToken.AsArray();
                foreach JsonContentAsToken in PredictionArray do begin
                    AddressPrediction.Init();
                    JsonContentAsToken.AsObject().Get('description', DescriptionArrayAsToken);
                    AddressPrediction.Description := Format(DescriptionArrayAsToken);
                    JsonContentAsToken.AsObject().Get('place_id', PlaceIDAsToken);
                    AddressPrediction.Place_ID := Format(PlaceIDAsToken);
                    AddressPrediction.TempLocation := LocationInput;
                    AddressPrediction.Insert();
                end;
                if AddressPrediction.FindFirst() then;
                if AddressIsFinal = false then
                    Page.RunModal(50101, AddressPrediction);
            end else begin
                Message('Your API-Key is not valid. Please enter a valid API-Key in the Place Api Setup.');
            end;
        end else begin
            Message('Your API-Key is not valid. Please enter a valid API-Key in the Place Api Setup.');
        end;
    end;

    /// <summary>
    /// Get Address Data by Google Place ID.
    /// </summary>
    /// <param name="PlaceID">Text[255].</param>
    procedure GetAddressData(PlaceID: Text[255])
    var
        AddressComponentsToken: JsonToken;
        AddressComponentsArray: JsonArray;
        TypesToken: JsonToken;
        TypesArray: JsonArray;
        StreetNumberAsToken: JsonToken;
        StreetNumberAsValue: JsonValue;
        RouteAsToken: JsonToken;
        LocalityAsToken: JsonToken;
        CountryAsToken: JsonToken;
        PostCodeAsToken: JsonToken;
        Addressdata: Record AddressData;
    begin
        if PlaceSetup.FindLast() then;
        Addressdata.DeleteAll();
        PlaceID := PlaceID.Replace('"', '');
        HttpClient.Get('https://maps.googleapis.com/maps/api/place/details/json?key=' + PlaceSetup.APiKey + '&language=' + PlaceSetup.LanguageCode + '&place_id=' + PlaceID, ResponseMessage);
        ResponseMessage.Content.ReadAs(ResponseJsonAsString);
        Jsoncontent.ReadFrom(ResponseJsonAsString);
        JsonContent.Get('result', JsonContentAsToken);
        JsonContentAsToken.AsObject().Get('address_components', AddressComponentsToken);
        AddressComponentsArray := AddressComponentsToken.AsArray();
        Addressdata.Init();
        foreach AddressComponentsToken in AddressComponentsArray do begin
            AddressComponentsToken.AsObject().Get('types', TypesToken);
            TypesArray := TypesToken.AsArray();
            foreach Typestoken in TypesArray do begin
                if Format(TypesToken) = '"street_number"' then begin
                    AddressComponentsToken.AsObject().Get('long_name', StreetNumberAsToken);
                end else
                    if Format(TypesToken) = '"route"' then begin
                        AddressComponentsToken.AsObject().Get('long_name', RouteAsToken);
                    end else
                        if Format(TypesToken) = '"locality"' then begin
                            AddressComponentsToken.AsObject().Get('long_name', LocalityAsToken);
                        end else
                            if Format(TypesToken) = '"country"' then begin
                                AddressComponentsToken.AsObject().Get('short_name', CountryAsToken);
                            end else
                                if Format(TypesToken) = '"postal_code"' then begin
                                    AddressComponentsToken.AsObject().Get('long_name', PostCodeAsToken);
                                end;
            end;
        end;

        Addressdata.Address := Format(RouteAsToken).Replace('"', '') + ' ' + Format(StreetNumberAsToken).Replace('"', '');
        Addressdata.City := Format(LocalityAsToken).Replace('"', '');
        Addressdata.Country := Format(CountryAsToken).Replace('"', '');
        Addressdata.PostCode := Format(PostCodeAsToken).Replace('"', '');
        StreetNumberAsValue := StreetNumberAsToken.AsValue();
        if StreetNumberAsValue.IsNull then
            Error('The entered address does not include a house number. Please enter a house number.');
        Addressdata.Insert();
    end;

    /// <summary>
    /// Checks whether the user has updated the post code
    /// </summary>
    /// <param name="input">Boolean.</param>
    procedure CheckForUpdatedPostCodeByUser(input: Text[255])
    var
        Addressprediction: Record AddressPredictions;
    begin
        TempUpdatedPostCode := 'updated'; //Wird geändert, diese Lösung ist nicht sauber.
        TempAddress := input;
        GetPredictions(input);
        AddressIsFinal := true;
    end;

    trigger OnRun()
    begin
        AddressIsFinal := false;
    end;

    var
        HttpClient: HttpClient;
        ResponseMessage: HttpResponseMessage;
        ResponseJsonAsString: Text;
        PlaceSetup: Record PlaceAPISetup;
        JsonContent: JsonObject;
        JsonContentAsToken: JsonToken;
        AddressPrediction: Record AddressPredictions;
        Google_Place_ID: Text[255];
        TempUpdatedPostCode: Text[20];
        TempAddress: Text[255];
        AddressIsFinal: Boolean;
}