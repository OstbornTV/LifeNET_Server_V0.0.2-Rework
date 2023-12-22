/*
    File: fn_updatePartial.sqf
    Author: Bryan "Tonic" Boardwine

    This file is for Nanou's HeadlessClient.

    Description:
    Takes partial data of a player and updates it, this is meant to be
    less network intensive towards data flowing through it for updates.
*/

params [
    ["_uid", "", [""]],
    ["_side", sideUnknown, [civilian]],
    "_value",
    ["_mode", -1, [0]],
    "_value1"
];

// Ensure essential parameters are not empty or invalid
if (_uid isEqualTo "" || {_side isEqualTo sideUnknown}) exitWith {"Error: Invalid parameters."};

// Initialize the query string
private _query = "";

// Choose the appropriate query based on the mode
switch (_mode) do {
    case 0: {
        // Update cash
        _query = format ["updateCash:%1:%2", _value, _uid];
    };

    case 1: {
        // Update bank
        _query = format ["updateBank:%1:%2", _value, _uid];
    };

    case 2: {
        // Update licenses
        for "_i" from 0 to (count _value) - 1 do {
            (_value select _i) params ["_license", "_owned"];
            _value set[_i, [_license, [0, 1] select _owned]];
        };
        switch (_side) do {
            case west: {_query = format ["updateWestLicenses:%1:%2", _value, _uid];};
            case civilian: {_query = format ["updateCivLicenses:%1:%2", _value, _uid];};
            case independent: {_query = format ["updateIndepLicenses:%1:%2", _value, _uid];};
        };
    };

    case 3: {
        // Update gear based on side
        switch (_side) do {
            case west: {_query = format ["updateWestGear:%1:%2", _value, _uid];};
            case civilian: {_query = format ["updateCivGear:%1:%2", _value, _uid];};
            case independent: {_query = format ["updateIndepGear:%1:%2", _value, _uid];};
        };
    };

    case 4: {
        // Update civilian position
        _value = [0, 1] select _value;
        _value1 = if (count _value1 isEqualTo 3) then {_value1} else {[0, 0, 0]};
        _query = format ["updateCivPosition:%1:%2:%3", _value, _value1, _uid];
    };

    case 5: {
        // Update arrested status
        _value = [0, 1] select _value;
        _query = format ["updateArrested:%1:%2", _value, _uid];
    };

    case 6: {
        // Update both cash and bank
        _query = format ["updateCashAndBank:%1:%2:%3", _value, _value1, _uid];
    };

    case 7: {
        // Execute key management function
        [_uid, _side, _value, 0] call TON_fnc_keyManagement;
    };
};

// Ensure a valid query is constructed before executing it
if (_query isEqualTo "") exitWith {};

// Execute the asynchronous database call
[_query, 1] call HC_fnc_asyncCall;
