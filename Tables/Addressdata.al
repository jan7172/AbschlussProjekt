/// <summary>
/// Stores Address Data from Google Place Details APi.
/// </summary>
table 50102 AddressData
{
    Caption = 'Addressdata';

    fields
    {
        field(1; "Address"; Text[100])
        {
            Caption = 'Address';
        }
        field(2; "City"; Text[30])
        {
            Caption = 'City';
        }
        field(3; "PostCode"; Code[20])
        {
            Caption = 'Post Code';
        }
        field(4; "Country"; Code[10])
        {
            Caption = 'Country';
        }

    }

    keys
    {
        key("PK"; PostCode)
        {

        }
    }
}