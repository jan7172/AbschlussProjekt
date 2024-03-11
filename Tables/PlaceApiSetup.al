/// <summary>
/// Table PlaceAPISetup (ID 50100).
/// </summary>
table 50100 PlaceAPISetup
{
    Caption = 'Place Setup';


    fields
    {
        field(1; "APiKey"; Text[255])
        {
            Caption = 'Api Key';
        }
        field(2; "LanguageCode"; Code[3])
        {
            Caption = 'Language Code';
        }
        field(3; TestLocation; Text[255])
        {
            Caption = 'Location Test';
        }
    }

    keys
    {
        key(PK; "APiKey")
        {
        }
    }
}