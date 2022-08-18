/*
    File: fn_signVendor.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
	checks vendor's informations
*/
disableSerialization;

private _display = findDisplay 9600;
private _itemDropdown = _display displayCtrl 9609;
private _amount = ctrlText 9614;
private _price = ctrlText 9616;
private _checkbox = _display displayCtrl 9617;

private _itemSel = lbCurSel _itemDropdown;
if ((_itemDropdown lbData _itemSel) isEqualTo "") exitWith {hint format[["didNotSelect"] call cat_trade_fnc_getText];};
private _data = _itemDropdown lbData _itemSel;
_data = _data splitString ";";
private _case = parseNumber (_data select 0);
private _item = "";
private _itemType = -1;
private _magCount = -1;
private _value = -1;
switch (_case) do {
    case 0 : { 
        _item = _data select 2;
        _itemType = parseNumber(_data select 1);
        if ((count _data) isEqualTo 4) then {_magCount = parseNumber(_data select 3);};
        _value = lbValue [9609,(lbCurSel 9609)];
    };
    default { _item = _data select 1; };
};
private _receiver = _display getVariable ["receiver",objNull];
if (isNull _receiver || isNil "_receiver") exitWith {};

if (!([_price] call cat_trade_fnc_isNumber)) exitWith {hint format[["notNumberFormat"] call cat_trade_fnc_getText];};
private _priceValue = parseNumber(_price);
if (_priceValue <= 0) exitWith {hint format[["moneyTooLow"] call cat_trade_fnc_getText];};
private _exit = false;
if (_case isEqualTo 0) then {
    if (!([_amount] call cat_trade_fnc_isNumber)) exitWith {hint format[["notNumberFormat"] call cat_trade_fnc_getText]; _exit = true;};
    private _amountValue = parseNumber(_amount);
    if (_amountValue <= 0) exitWith {hint format[["amountTooLow"] call cat_trade_fnc_getText]; _exit = true;};
    if (_amountValue > _value) exitWith {hint format[["amountTooHigh"] call cat_trade_fnc_getText]; _exit = true;};
};
if (_exit) exitWith {};

if (cbChecked _checkbox) then {
    hint format[["waitForBuyer"] call cat_trade_fnc_getText,name _receiver];
    cat_trade_aborted = false;
    cat_trade_receiver = _receiver;
    cat_trade_esc_eventhandler = (findDisplay 46) displayAddEventHandler ["KeyDown", {
        _keyDown = _this select 1;
        if (_keyDown isEqualTo 1) then {
            [cat_trade_receiver,0] call cat_trade_fnc_abort;
        };
        true;
    }];
    [_receiver] spawn {
        params [["_receiver",objNull,[objNull]]];
        while {!cat_trade_aborted} do {
            sleep 1;
            if (isNull _receiver || !alive _receiver || isNull player || !alive player || (player getVariable ["restrained",false]) || (player getVariable ["Escorting",false]) || life_istazed || life_action_inUse) then {
                [_receiver,0] call cat_trade_fnc_abort;
            };
            if ((getNumber(missionConfigFile >> "Cation_Trade" >> "version")) > 4) then {
                if ((player getVariable ["playerSurrender",false]) || life_isknocked) then {
                    [_receiver,0] call cat_trade_fnc_abort;
                };
            };
        };
    };
    closeDialog 0;
    if ((getNumber(missionConfigFile >> "Cation_Trade" >> "DebugMode")) isEqualTo 1) then {
        diag_log "--------- Trade System: vendor signed ----------";
        diag_log format ["_item: %1",_item];
        diag_log format ["player: %1",player];
        diag_log format ["_price: %1",_price];
        diag_log format ["_amount: %1",_amount];
        diag_log format ["_case: %1",_case];
        diag_log format ["_itemType: %1",_itemType];
        diag_log format ["_magCount: %1",_magCount];
        diag_log "------------------------------------------------";
    };
    [_item,player,_price,_amount,_case,_itemType,_magCount] remoteExecCall ["cat_trade_fnc_openBuyer",_receiver];
} else {
    hint format[["notAccepted"] call cat_trade_fnc_getText];
};