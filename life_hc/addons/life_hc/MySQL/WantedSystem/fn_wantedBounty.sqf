/*
    File: fn_wantedBounty.sqf
    Author: Bryan "Tonic" Boardwine"
    Database Persistence By: ColinM
    Assistance by: Paronity
    Stress Tests by: Midgetgrimm

    This file is for Nanou's HeadlessClient.

    Description:
    Checks if the person is on the bounty list and awards the cop for killing them.
*/
params [
    ["_uid","",[""]],      // UID der gesuchten Person
    ["_civ",objNull,[objNull]],  // Zivilist, der auf der Wanted-Liste steht
    ["_cop",objNull,[objNull]],  // Polizist, der die Belohnung erhalten soll
    ["_half",false,[false]]  // Ob die Belohnung halbiert werden soll
];

if (isNull _civ || {isNull _cop}) exitWith {};  // Beende das Skript bei ungültigen Parametern

// Überprüfen, ob die gesuchte Person auf der Wanted-Liste steht
private _query = format ["selectWanted:%1", _uid];
private _queryResult = [_query,2] call HC_fnc_asyncCall;

private "_amount";
if !(_queryResult isEqualTo []) then {
    _amount = _queryResult param [3];
    if !(_amount isEqualTo 0) then {
        // Belohnung erhalten und an den Polizisten weiterleiten
        if (_half) then {
            // Belohnung halbieren, wenn _half true ist
            [((_amount) / 2),_amount] remoteExecCall ["life_fnc_bountyReceive", _cop];
        } else {
            [ _amount, _amount] remoteExecCall ["life_fnc_bountyReceive", _cop];
        };
    };
};
