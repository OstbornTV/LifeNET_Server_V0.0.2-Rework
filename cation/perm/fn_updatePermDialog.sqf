/*
    File: fn_updatePermDialog.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
    Creates perm dialog
*/
params [
	["_cash","0",[""]],
	["_bank","0",[""]],
	["_level",0,[0]],
	["_licences",[],[[]]],
    ["_receiver",objNull,[objNull]]
];
if (isNull player || !alive player || (player getVariable ["restrained",false]) || (player getVariable ["Escorting",false]) || life_istazed || life_action_inUse) exitWith {closeDialog 0;};
if ((player getVariable ["playerSurrender",false]) || life_isknocked) exitWith {closeDialog 0;};
if (!(cursorObject isEqualTo _receiver)) exitWith {closeDialog 0;};
disableSerialization;
hint "";
_playerLevel = 0;
_moneyLevel = 0;
_addLicenseLevel = 0;
_removeLicenseLevel = 0;
_promoteLevel = 0;
_hireLevel = 0;
_degradeLevel = 0;
_fireLevel = 0;
if (playerSide isEqualTo west) then {
    _playerLevel = call life_coplevel;
    _moneyLevel = getNumber(missionConfigFile >> "Cation_Perm" >> "mincoplevelmoney");
    _addLicenseLevel = getNumber(missionConfigFile >> "Cation_Perm" >> "mincopleveladdlicense");
    _removeLicenseLevel = getNumber(missionConfigFile >> "Cation_Perm" >> "mincoplevelremovelicense");
    _promoteLevel = getNumber(missionConfigFile >> "Cation_Perm" >> "mincoplevelpromote");
    _hireLevel = getNumber(missionConfigFile >> "Cation_Perm" >> "mincoplevelhire");
    _degradeLevel = getNumber(missionConfigFile >> "Cation_Perm" >> "mincopleveldegrade");
    _fireLevel = getNumber(missionConfigFile >> "Cation_Perm" >> "mincoplevelfire");
};
if (playerSide isEqualTo independent) then {
    _playerLevel = call life_mediclevel;
    _moneyLevel = getNumber(missionConfigFile >> "Cation_Perm" >> "minmediclevelmoney");
    _addLicenseLevel = getNumber(missionConfigFile >> "Cation_Perm" >> "minmedicleveladdlicense");
    _removeLicenseLevel = getNumber(missionConfigFile >> "Cation_Perm" >> "minmediclevelremovelicense");
    _promoteLevel = getNumber(missionConfigFile >> "Cation_Perm" >> "minmediclevelpromote");
    _hireLevel = getNumber(missionConfigFile >> "Cation_Perm" >> "minmediclevelhire");
    _degradeLevel = getNumber(missionConfigFile >> "Cation_Perm" >> "minmedicleveldegrade");
    _fireLevel = getNumber(missionConfigFile >> "Cation_Perm" >> "minmediclevelfire");
};

private _display = findDisplay 9500;
_display setVariable ["receiver",_receiver];
(_display displayCtrl 9501) ctrlSetText format[["administration"] call cat_perm_fnc_getText];
(_display displayCtrl 9502) ctrlSetText format[["playername"] call cat_perm_fnc_getText];
(_display displayCtrl 9503) ctrlSetText format["%1",name _receiver];
(_display displayCtrl 9504) ctrlSetText format[["rank"] call cat_perm_fnc_getText];
(_display displayCtrl 9506) ctrlSetText format["%1",_level];
_display setVariable ["rank",_level];
(_display displayCtrl 9507) ctrlSetStructuredText parseText format ["<img size='1.3' image='cation\perm\ico_money.paa'/> <t font='PuristaMedium'>%1%2</t>",_cash,["currency"] call cat_perm_fnc_getText];
(_display displayCtrl 9508) ctrlSetStructuredText parseText format ["<img size='1.3' image='cation\perm\ico_bank.paa'/> <t font='PuristaMedium'>%1%2</t>",_bank,["currency"] call cat_perm_fnc_getText];
(_display displayCtrl 9509) ctrlSetText format[["changeRank"] call cat_perm_fnc_getText];
(_display displayCtrl 9511) ctrlSetText format[(["ok"] call cat_perm_fnc_getText)];

ctrlShow [9521,false];
ctrlShow [9501,true];
ctrlShow [9502,true];
ctrlShow [9504,true];

if (!(side _receiver isEqualTo playerSide) || _level isEqualTo 0) then {
    ctrlShow [9503,true];
    ctrlShow [9506,true];
    if (_level isEqualTo 0) then {
        if (_playerLevel >= _hireLevel) then {
            private _dropdown = _display displayCtrl 9510;
            lbClear _dropdown;
            _dropdown lbAdd format[["hire"] call cat_perm_fnc_getText]; _dropdown lbSetData [(lbSize 9510)-1,str(1)];
            ctrlShow [9509,true];
            ctrlShow [9510,true];
            ctrlShow [9511,true];
        } else {
            ctrlShow [9509,false];
            ctrlShow [9510,false];
            ctrlShow [9511,false];
        };
    } else {
        ctrlShow [9509,false];
        ctrlShow [9510,false];
        ctrlShow [9511,false];
    };
    ctrlShow [9512,false];
    ctrlShow [9513,false];
    ctrlShow [9514,false];
    ctrlShow [9515,false];
    ctrlShow [9516,false];
    ctrlShow [9517,false];
    ctrlShow [9518,false];
    ctrlShow [9519,false];
    ctrlShow [9520,false];
} else {
    ctrlShow [9503,true];
    ctrlShow [9506,true];
    ctrlShow [9507,true];
    ctrlShow [9508,true];
    ctrlShow [9509,true];
    ctrlShow [9510,true];
    ctrlShow [9511,true];
    ctrlShow [9512,true];
    ctrlShow [9513,true];
    ctrlShow [9514,true];
    if (_playerLevel >= _moneyLevel) then {
        ctrlShow [9515,true];
        ctrlShow [9516,true];
        ctrlShow [9517,true];
    };
    ctrlShow [9518,true];
    ctrlShow [9519,true];
    ctrlShow [9520,true];
    private _dropdown = _display displayCtrl 9510;
    private _maxlevel = switch (playerSide) do {
        case west: { getNumber(missionConfigFile >> "Cation_Perm" >> "maxcoplevel") };
        case independent: { getNumber(missionConfigFile >> "Cation_Perm" >> "maxmediclevel") };
        default { 0 };
    };
    if (_maxlevel > _playerLevel) then {
        _maxlevel = _playerLevel;
    };
    lbClear _dropdown;
    for "_i" from 0 to _maxlevel step 1 do {
        if (!(_level isEqualTo _i)) then {
            switch (_i) do {
                case 0: {
                    if (_playerLevel >= _fireLevel) then {
                        _dropdown lbAdd format[["fire"] call cat_perm_fnc_getText];
                        _dropdown lbSetData [(lbSize 9510)-1,str(_i)];
                    };
                };
                default {
                    if ((_level > _i) && (_playerLevel >= _degradeLevel)) then {
                        _dropdown lbAdd (format["%1",_i]);
                        _dropdown lbSetData [(lbSize 9510)-1,str(_i)];
                    };
                    if ((_level < _i) && (_playerLevel >= _promoteLevel)) then {
                        _dropdown lbAdd (format["%1",_i]);
                        _dropdown lbSetData [(lbSize 9510)-1,str(_i)];
                    };
                };
            };
        };
    };
    if (lbSize _dropdown isEqualTo 0) then {
        ctrlShow [9509,false];
        ctrlShow [9510,false];
        ctrlShow [9511,false];
    } else {
        _dropdown lbSetCurSel 0;
    };
    (_display displayCtrl 9512) ctrlSetText format[["giveLicence"] call cat_perm_fnc_getText];
    _dropdown = _display displayCtrl 9513;
    lbClear _dropdown;
    (_display displayCtrl 9518) ctrlSetText format[["Licences"] call cat_perm_fnc_getText];
    private _listbox = _display displayCtrl 9519;
    lbClear _listbox;
    {
        private _varName = ((_x select 0) splitString "_" select 2);
        if (_x select 1 isEqualTo 1) then {
            _listbox lbAdd localize getText(missionConfigFile >> "Licenses" >> _varName >> "displayName");
            _listbox lbSetData[(lbSize 9519)-1,_varName];
            if (_playerLevel < _removeLicenseLevel) then {
                ctrlShow [9520,false];
            };
        } else {
            if (_playerLevel >= _addLicenseLevel) then {
                _dropdown lbAdd localize getText(missionConfigFile >> "Licenses" >> _varName >> "displayName");
                _dropdown lbSetData[(lbSize 9513)-1,_varName];
            } else {
                ctrlShow [9512,false];
                ctrlShow [9513,false];
                ctrlShow [9514,false];
            };
        };
    } forEach (_licences);
    _dropdown lbSetCurSel 0;
    if (lbSize _dropdown isEqualTo 0) then {
        if (_playerLevel >= _addLicenseLevel) then {
            ctrlEnable[9514,false];
        } else {
            ctrlShow [9512,false];
            ctrlShow [9513,false];
            ctrlShow [9514,false];
        };
    } else {
        ctrlEnable[9514,true];
    };
    _listbox lbSetCurSel 0;
    if (lbSize _listbox isEqualTo 0) then {
        if (_playerLevel >= _removeLicenseLevel) then {
            ctrlEnable[9520,false];
        } else {
            ctrlShow[9520,false];
        }
    } else {
        ctrlEnable[9520,true];
    };
    (_display displayCtrl 9514) ctrlSetText format[(["ok"] call cat_perm_fnc_getText)];
    (_display displayCtrl 9520) ctrlSetText format[(["withdrawLicence"] call cat_perm_fnc_getText)];
    (_display displayCtrl 9515) ctrlSetText format[(["giveMoney"] call cat_perm_fnc_getText)];
    (_display displayCtrl 9517) ctrlSetText format[(["ok"] call cat_perm_fnc_getText)];
};