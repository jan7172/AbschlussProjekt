/// <summary>
/// PageExtension CustomerCardExt (ID 50100) extends Record Customer Card with Place Autocomplete.
/// </summary>
pageextension 50100 CustomerCardExt extends "Customer Card"
{
    layout
    {
        modify(Address)
        {
            trigger OnBeforeValidate()
            begin
                if AddressPrediction.FindSet() then;
                AddressPrediction.DeleteAll();
            end;

            trigger OnAfterValidate()
            begin
                checkIfAddressIsValid();
                setAddressData();
            end;
        }
        modify("Address 2")
        {
            trigger OnBeforeValidate()
            begin
                AddressPrediction.DeleteAll();
            end;

            trigger OnAfterValidate()
            begin

            end;
        }
    }

    local procedure checkIfAddressIsValid()

    var
        Offset: Integer;
        FormattedAddress: Text[100];


        JsonContents: JsonObject;
        PredictionArray: JsonArray;
    begin
        if PlaceAPISetup.FindLast() then;
        Offset := Text.StrLen(Rec.Address);
        Place.GetPredictions(Rec.Address);
    end;

    /// <summary>
    /// Sets all Address values if Addressfield get validated.
    /// </summary>
    procedure setAddressData()
    var
        AddressData: Record AddressData;
    begin
        if AddressData.FindLast() then;
        Rec.Address := '';
        Rec.Address := AddressData.Address;
        Rec."Post Code" := AddressData.PostCode;
        Rec.City := AddressData.City;
        Rec."Country/Region Code" := AddressData.Country;
        AddressData.DeleteAll();
    end;

    var
        PlaceAPISetup: Record PlaceAPISetup;
        Place: Codeunit Place;
        CompleteAddress: Text[100];
        CompleteAddress2: Text[100];
        AddressPrediction: Record AddressPredictions;
}