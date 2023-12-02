/*
    File: fn_bountyReceive.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Notifies the player he has received a bounty and distributes it evenly among online cops. !TODO
*/

params [
    ["_val", 0, [0]],
    ["_total", 0, [0]]
];

if (_val == 0) exitWith {};

// Anzahl der Online-Cops abrufen
private _cops = 0;
{
    if (side _x isEqualTo west && playerSide _x isEqualTo west && !(life_mediclevel > 0)) then {
        _cops = _cops + 1;
    };
} forEach playableUnits;

// Überprüfen, ob es Online-Cops gibt
if (_cops > 0) then {
    // Gleichmäßige Verteilung des Kopfgeldes
    private _bountyPerCop = _val / _cops;
    
    // BANK-Guthaben für jeden Online-Cop aktualisieren
    {
        if (side _x isEqualTo west && playerSide _x isEqualTo west && !(life_mediclevel > 0)) then {
            BANK = BANK + _bountyPerCop;
        };
    } forEach playableUnits;

    // Meldung an die Spieler ausgeben
    titleText[format [localize "STR_Cop_BountyKill",[_bountyPerCop] call life_fnc_numberText,[_total] call life_fnc_numberText],"PLAIN"];
} else {
    titleText["Keine Online-Cops verfügbar.","PLAIN"];
};
