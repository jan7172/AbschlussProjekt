/// <summary>
/// PageExtension CustomerCardExt (ID 50100) extends Record Customer Card with Place Autocomplete.
/// </summary>
pageextension 50100 CustomerCardExt extends "Customer Card"
{
    layout
    {
        modify(Address)
        {
            trigger OnAfterValidate()
            begin
                CheckIfAddressIsValid();
                if Place.GetPredictions(rec.Address).FindFirst() then;
                Page.RunModal(50101, Place.GetPredictions(rec.Address));
                SetAddressData();
            end;
        }
    }

    /// <summary>
    /// Checks whether the entered address is valid.
    /// </summary>
    local procedure CheckIfAddressIsValid()
    begin
        if PlaceAPISetup.FindLast() then begin
            if PlaceAPISetup.APiKey <> '' then begin
                Place.GetPredictions(Rec.Address);
            end else begin
                Message('Your API-Key is not valid. Please enter a valid API-Key in the Place Api Setup.');
            end
        end else begin
            Message('Your API-Key is not valid. Please enter a valid API-Key in the Place Api Setup.');
        end;
    end;

    /// <summary>
    /// Sets all address values if an addressfield get validated.
    /// </summary>
    procedure SetAddressData()
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
        AddressPrediction: Record AddressPredictions;
}