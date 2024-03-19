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
        field(3; TempLocation; Text[255])
        {
            Caption = 'Temp Location';
        }

    }

    keys
    {
        key("PK"; "Place_ID")
        {
        }
    }

}