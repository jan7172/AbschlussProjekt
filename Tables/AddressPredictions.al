table 50101 AddressPredictions
{
    TableType = Temporary;

    fields
    {
        field(1; "Place_ID"; Text[255])
        {
            Caption = 'Place ID';
        }
        field(2; "Description"; Text[255])
        {
            Caption = 'Description';
        }

    }

    keys
    {
        key("PK"; "Place_ID")
        {
        }
    }

}