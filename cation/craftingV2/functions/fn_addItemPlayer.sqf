/*
    File: fn_addItemPlayer.sqf
    Author: Bryan "Tonic" Boardwine
    Modified: B4v4r!4n_Str!k3r (julian.bauer@cationstudio.com)

    Description
    Adds item to player.
*/
params [
	["_item","",[""]],
	["_amount",0,[0]]
];

if (isNull player || !alive player || (player getVariable ["restrained",false]) || (player getVariable ["Escorting",false]) || life_istazed) exitWith {closeDialog 0;}; // player not allowed to use crafting
if ((getNumber(missionConfigFile >> "Cation_CraftingV2" >> "version")) > 4) then {
    if ((player getVariable ["playerSurrender",false]) || life_isknocked) exitWith {closeDialog 0;}; // player not allowed to use crafting
};

if ((getNumber(missionConfigFile >> "Cation_CraftingV2" >> "DebugMode")) isEqualTo 1) then { // if debug mode is enabled
    diag_log format["cationstudio crafting: [INFO] Adding item %1, amount %2 to player inventory. Function cat_craftingV2_fnc_addItemPlayer", _item, _amount]; // log entry
};

if (_item isEqualTo "") exitWith {}; // no item passed
_details = [_item] call life_fnc_fetchCfgDetails; // fetch details
if (count _details isEqualTo 0) exitWith {}; // no details found

for "_i" from 1 to _amount do { // one item after another
    private _isgun = false; // is gun -> false
    switch (_details select 6) do { // switch base class
        case "CfgGlasses": { // glasses
            if (goggles player isEqualTo "") then {
                player addGoggles _item;
            } else {
                player addItem _item;
            };                
        };

        case "CfgVehicles": { // vehicles
            player addBackpack _item;
        };

        case "CfgMagazines": { // magazines
            player addMagazine _item;
        };

        case "CfgWeapons": { // weapons
            if ((_details select 4) in [1,2,4,5,4096]) then { // check if weapon or not
                if ((_details select 4) isEqualTo 4096) then {
                    if ((_details select 5) isEqualTo -1) then {
                        _isgun = true;
                    };
                } else {
                    _isgun = true;
                };
            };

            if (_isgun) then { // if weapon
                if (_item isEqualTo "MineDetector") then { // check if mineDetector
                    player addItem _item;
                } else {
                    player addWeapon _item;
                };
            } else { // no weapon -> maybe clothing?
                switch (_details select 5) do {
                    case 605: { // headgear
                        if (headgear player isEqualTo "") then {
                            player addHeadGear _item;
                        } else {
                            player addItem _item;
                        };
                    };

                    case 801: { // uniform
                        if (uniform player isEqualTo "") then {
                            player addUniform _item;
                        } else {
                            player addItem _item;
                        };
                    };

                    case 701: { // vest
                        if (vest player isEqualTo "") then {
                            player addVest _item;
                        } else {
                            player addItem _item;
                        };
                    };

                    default { // default: add item
                        player addItem _item;
                    };
                };
            };
        };
    };
};
[3] call SOCK_fnc_updatePartial; // save to database