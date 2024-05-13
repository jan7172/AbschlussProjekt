/// <summary>
/// PageExtension CompanyInfoExt (ID 50105) extends Page Company Information with Place Api
/// </summary>
pageextension 50105 CompanyInfoExt extends "Company Information"
{
    layout
    {
        modify(Address)
        {
            trigger OnAfterValidate()
            begin
                Place.CheckIfAddressIsValid(Rec.Address);
                if Place.GetPredictions(rec.Address).FindFirst() then;
                Page.RunModal(50101, Place.GetPredictions(Rec.Address));
                SetAddressData();
            end;
        }
    }

    /// <summary>
    /// Sets all address values if an addressfield get validated.
    /// </summary>
    procedure SetAddressData()
    var
        AddressData: Record AddressData;
    begin
        if AddressData.FindLast() then;
        Rec.Address := AddressData.Address;
        Rec."Post Code" := AddressData.PostCode;
        Rec.City := AddressData.City;
        Rec."Country/Region Code" := AddressData.Country;
        AddressData.DeleteAll();
    end;

    var
        PlaceAPISetup: Record PlaceAPISetup;
        Place: Codeunit Place;
}