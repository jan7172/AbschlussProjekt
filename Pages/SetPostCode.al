/// <summary>
/// Page Set Postode (ID 50103).
/// </summary>
page 50103 "SetPostCode"
{
    Caption = 'SetPostCode';
    PageType = CardPart;

    layout
    {
        area(Content)
        {
            group(Main)
            {
                field(TempPostCode; TempPostCode)
                {
                    ApplicationArea = All;
                    // trigger OnValidate()
                    // begin
                    //     Page.RunModal(50101, Place.GetPredictions(TempPostCode + ' ' + TempLocation));
                    // end;
                }
            }
        }
    }

    trigger OnClosePage()
    begin
        Page.RunModal(50101, Place.GetPredictions(TempPostCode + ' ' + TempLocation));
    end;

    /// <summary>
    /// Transmits addressdata.
    /// </summary>
    /// <param name="Address">Text[255].</param>we
    procedure GetAddressData(Address: Text[255])
    var
        PostCode: Text[20];
    begin
        TempLocation := Address;
    end;

    var
        TempPostCode: Text[20];
        TempLocation: Text[255];
        Place: Codeunit Place;
}

/*
Pages können nicht innerhalb eines Triggers geschlossen werden.
^ Dies gilt sowohl für die Trigger im Feld als auch für globale Trigger.
Man kann dies nicht umgehen indem man z.B. eine Funktion schreibt welche die Page schließt und diese in einem Trigger öffnet.


Nachdem RunModal die Page schließt habe ich immer noch Zugriff auf die Variablen.
Die Werte bleiben gespeichert weil die Instanz noch geöffnet ist solange ich in der Action bin


 */
