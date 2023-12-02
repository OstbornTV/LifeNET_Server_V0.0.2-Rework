#include "..\..\script_macros.hpp"
/*
    Datei: fn_giveMoney.sqf
    Autor: Bryan "Tonic" Boardwine

    Beschreibung:
    Gibt den ausgewählten Geldbetrag an den ausgewählten Spieler.
*/

// Ausblenden des Steuerelements mit der ID 2001
ctrlShow[2001,false];

// Abrufen des eingegebenen Geldbetrags aus dem Textfeld mit der ID 2018
private ["_unit","_amount"];
_amount = ctrlText 2018;

// Überprüfen, ob kein Spieler ausgewählt wurde
if ((lbCurSel 2022) isEqualTo -1) exitWith {
    hint localize "STR_NOTF_noOneSelected";
    ctrlShow[2001,true];
};

// Extrahieren des Spielerobjekts aus den Daten des Listenfelds mit der ID 2022
_unit = lbData [2022,lbCurSel 2022];
_unit = call compile format ["%1",_unit];

// Überprüfen, ob das Spielerobjekt gültig ist und nicht der Spieler selbst ist
if (isNil "_unit" || _unit == player || isNull _unit) exitWith {
    ctrlShow[2001,true];
};

// Eine Reihe von Überprüfungen durchführen
// *ugh* - Manchmal werden diese Überprüfungen als umständlich empfunden
if (!life_use_atm) exitWith {
    hint localize "STR_NOTF_recentlyRobbedBank";
    ctrlShow[2001,true];
};
if (!([_amount] call life_util_fnc_isNumber)) exitWith {
    hint localize "STR_NOTF_notNumberFormat";
    ctrlShow[2001,true];
};
if (parseNumber(_amount) <= 0) exitWith {
    hint localize "STR_NOTF_enterAmount";
    ctrlShow[2001,true];
};
if (parseNumber(_amount) > CASH) exitWith {
    hint localize "STR_NOTF_notEnoughtToGive";
    ctrlShow[2001,true];
};
if (isNil "_unit") exitWith {
    hint localize "STR_NOTF_notWithinRange";
    ctrlShow[2001,true];
};

// Benachrichtigung über den erfolgreichen Geldtransfer anzeigen
hint format [localize "STR_NOTF_youGaveMoney",[(parseNumber(_amount))] call life_fnc_numberText,_unit getVariable ["realname",name _unit]];

// Abziehen des Geldbetrags vom Spieler
CASH = CASH - (parseNumber(_amount));

// Teilaktualisierung des Spielerinventars
[0] call SOCK_fnc_updatePartial;

// Remote-Ausführung der Funktion "life_fnc_receiveMoney" beim ausgewählten Spieler
[_unit,_amount,player] remoteExecCall ["life_fnc_receiveMoney",_unit];

// Menü aktualisieren
[] call life_fnc_p_updateMenu;

// Einblenden des Steuerelements mit der ID 2001
ctrlShow[2001,true];
