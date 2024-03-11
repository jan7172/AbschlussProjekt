/// <summary>
/// Table SetPostCode (ID 50103).
/// </summary>
table 50103 SetPostCode
{
    TableType = Temporary;

    fields
    {
        field(1; "TempPostCode"; Text[20])
        {
            Caption = 'TempPostCode';
        }
        field(2; "TempLocation"; Text[255])
        {
            Caption = 'Temp Location';
        }
    }

    keys
    {
        key(PK; TempPostCode)
        {
        }
    }
}