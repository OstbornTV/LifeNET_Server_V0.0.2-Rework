/*
    File: fn_signBuyer.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
	checks buyer's information
*/
disableSerialization;

private _display = findDisplay 9600;
private _checkbox = _display displayCtrl 9617;
private _item = _display getVariable ["item",""];
private _vendor = _display getVariable ["vendor",objNull];
private _price = _display getVariable ["price",""];
private _priceNumber = parseNumber(_price);
private _amount = _display getVariable ["amount",""];
private _amountNumber = parseNumber(_amount);
private _case = _display getVariable ["case",-1];
private _itemType = _display getVariable ["itemType",-1];
private _magCount = _display getVariable ["magCount",-1];

if (isNull _vendor || isNil "_vendor") exitWith {};
if (_priceNumber > life_cash) exitWith {hint format[["noMoney"] call cat_trade_fnc_getText];};
private _bad = false;
if (_case isEqualTo 0) then {
    if (_itemType isEqualTo 1) then {
        private _num = [_item,_amountNumber,life_carryWeight,life_maxWeight] call life_fnc_calWeightDiff;
        if (_num isEqualTo 0) then {
            _bad = true;
        };
    } else {
        private _used = false;
        if (isClass(configfile >> "CfgVehicles" >> _item)) then {
            if !((backpack player) isEqualTo "") then {
                _bad = true;
            };
        } else {
            if (!(player canAdd [_item,_amountNumber])) then {
                _bad = true;
                for "_i" from 1 to _amountNumber do {
                    if (isClass(configfile >> "CfgWeapons" >> _item)) then {
                        private _base = [(configfile >> "CfgWeapons" >> _item),true ] call BIS_fnc_returnParents;
                        switch (getNumber(configFile >> "CfgWeapons" >> _item >> "type")) do {
                            case 1: {
                                if ((primaryWeapon player) isEqualTo "") then {
                                    if (_used) then {
                                        _bad = true;
                                    } else {
                                        _used = true;
                                        _bad = false;
                                    };
                                };
                            };
                            case 2: {
                                if !((handgunWeapon player) isEqualTo "") then {
                                    if (_used) then {
                                        _bad = true;
                                    } else {
                                        _used = true;
                                        _bad = false;
                                    };
                                };
                            };
                            case 4: {
                                if !((secondaryWeapon player) isEqualTo "") then {
                                    if (_used) then {
                                        _bad = true;
                                    } else {
                                        _used = true;
                                        _bad = false;
                                    };
                                };
                            };
                            default {};
                        };
                        if (("Vest_Camo_Base" in _base) || ("Vest_NoCamo_Base" in _base)) then {
                            if !((vest player) isEqualTo "") then {
                                if (_used) then {
                                    _bad = true;
                                } else {
                                    _used = true;
                                    _bad = false;
                                };
                            };
                        };
                        if ("Uniform_Base" in _base) then {
                            if !((uniform player) isEqualTo "") then {
                                if (_used) then {
                                    _bad = true;
                                } else {
                                    _used = true;
                                    _bad = false;
                                };
                            };
                        };
                        if (("H_HelmetB" in _base) || ("HelmetBase" in _base)) then {
                            if !((headgear player) isEqualTo "") then {
                                if (_used) then {
                                    _bad = true;
                                } else {
                                    _used = true;
                                    _bad = false;
                                };
                            };
                        };
                    };
                    if (isClass(configfile >> "CfgGlasses" >> _item)) then {
                        if !((goggles player) isEqualTo "") then {
                            if (_used) then {
                                _bad = true;
                            } else {
                                _used = true;
                            };
                        };
                    };
                };
            };
        };
    };
};

if (_case isEqualTo 2) then {
    if ((getNumber(missionConfigFile >> "Cation_Trade" >> "version")) isEqualTo 3) then {
        if (count life_houses >= call life_houseLimit) then {
            hint format [["houseLimit"] call cat_trade_fnc_getText,call life_houseLimit];
            _bad = true;
        };
    } else {
        if (count life_houses >= getNumber(missionConfigFile >> "Life_Settings" >> "house_limit")) then {
            hint format [["houseLimit"] call cat_trade_fnc_getText,getNumber(missionConfigFile >> "Life_Settings" >> "house_limit")];
            _bad = true;
        };
    };
};

if (_bad) exitWith {
    hint format[["invFull"] call cat_trade_fnc_getText];
    [_vendor,2] call cat_trade_fnc_abort;
};
if (cbChecked _checkbox) then {
    if (!alive _vendor) exitWith {};
    life_cash = life_cash - _priceNumber;
    [0] call SOCK_fnc_updatePartial;
    closeDialog 0;
    if ((getNumber(missionConfigFile >> "Cation_Trade" >> "DebugMode")) isEqualTo 1) then {
        diag_log "--------- Trade System: buyer signed ----------";
        diag_log format ["_item: %1",_item];
        diag_log format ["player: %1",player];
        diag_log format ["_price: %1",_price];
        diag_log format ["_amount: %1",_amount];
        diag_log format ["_case: %1",_case];
        diag_log format ["_itemType: %1",_itemType];
        diag_log format ["_magCount: %1",_magCount];
        diag_log "------------------------------------------------";
    };
    [_item,player,_price,_amount,_case,_itemType,_magCount] remoteExecCall ["cat_trade_fnc_delVendor",_vendor];
} else {
    hint format[["notAccepted"] call cat_trade_fnc_getText];
};