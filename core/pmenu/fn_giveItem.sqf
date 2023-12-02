#include "..\..\script_macros.hpp"

/*
    Datei: fn_giveItem.sqf
    Autor: Bryan "Tonic" Boardwine

    Beschreibung:
    Gibt das ausgewählte Item & die Menge an den ausgewählten Spieler
    und entfernt das Item & die Menge davon aus dem virtuellen Inventar des Spielers.
*/

// Ausblenden des Steuerelements mit der ID 2002
ctrlShow [2002,false];

// Anonyme Funktion, um Variablen zu begrenzen
call {
    // Wert des Textfelds mit der ID 2010
    private _value = ctrlText 2010;

    // Überprüfen, ob kein Spieler ausgewählt wurde
    if ((lbCurSel 2023) isEqualTo -1) exitWith {
        hint localize "STR_NOTF_noOneSelected";
    };

    // Überprüfen, ob kein Item zum Geben ausgewählt wurde
    if ((lbCurSel 2005) isEqualTo -1) exitWith {
        hint localize "STR_NOTF_didNotSelectItemToGive";
    };

    // Spielerobjekt aus den Daten des Listenfelds mit der ID 2023 extrahieren
    private _unit = lbData [2023, lbCurSel 2023];
    _unit = call compile format ["%1",_unit];

    // Überprüfen, ob das Spielerobjekt gültig ist und nicht der Spieler selbst ist
    if (isNil "_unit") exitWith {
        hint localize "STR_NOTF_notWithinRange";
    };
    if (isNull _unit || {_unit isEqualTo player}) exitWith {};

    // Item aus den Daten des Listenfelds mit der ID 2005 extrahieren
    private _item = lbData [2005, lbCurSel 2005];

    // Überprüfen, ob der eingegebene Wert eine Zahl ist
    if !([_value] call life_util_fnc_isNumber) exitWith {
        hint localize "STR_NOTF_notNumberFormat";
    };

    // Überprüfen, ob die eingegebene Menge größer als 0 ist
    if (parseNumber _value <= 0) exitWith {
        hint localize "STR_NOTF_enterAmountGive";
    };

    // Überprüfen, ob das Item erfolgreich übergeben wurde
    if !([false,_item, parseNumber _value] call life_fnc_handleInv) exitWith {
        hint localize "STR_NOTF_couldNotGive";
    };

    // Remote-Ausführung der Funktion "life_fnc_receiveItem" beim ausgewählten Spieler
    [_unit, _value, _item, player] remoteExecCall ["life_fnc_receiveItem", _unit];

    // Typ des übergebenen Items abrufen und eine Benachrichtigung anzeigen
    private _type = M_CONFIG(getText,"VirtualItems",_item,"displayName");
    hint format [localize "STR_NOTF_youGaveItem", _unit getVariable ["realname", name _unit], _value, _type];

    // Menü aktualisieren
    [] call life_fnc_p_updateMenu;
};

// Einblenden des Steuerelements mit der ID 2002
ctrlShow[2002,true];
