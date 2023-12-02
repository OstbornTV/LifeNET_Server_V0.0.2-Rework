/*
    File: fn_nearATM.sqf
    Author: Bryan "Tonic" Boardwine
    Modified : NiiRoZz : for use with new command cursorObject

    Description:
    Überprüft, ob sich der Spieler in der Nähe eines ATM-Objekts auf der Karte befindet.

    RETURNS:
        0: BOOL (True für ja, false für nein)
*/

// Das Objekt, auf das der Cursor zeigt
private _obj = cursorObject;

// Standardmäßig wird davon ausgegangen, dass der Spieler nicht in der Nähe eines ATMs ist
private _return = false;

// Überprüfen, ob das Objekt ein ATM ist und der Spieler in der Nähe ist
if ((str(_obj) find "atm_") != -1 && {player distance _obj < 2.3}) then { 
    // Wenn ja, wird der Rückgabewert auf true gesetzt
    _return = true; 
};

// Rückgabe des Ergebnisses
_return;
