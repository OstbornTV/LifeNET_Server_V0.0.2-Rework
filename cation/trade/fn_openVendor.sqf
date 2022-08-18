/*
    File: fn_openVendor.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
	opens dialog for vendor
*/
params[
    ["_receiver",objNull,[objNull]]
];
if (isNull _receiver || !alive _receiver || isNull player || !alive player || (player getVariable ["restrained",false]) || (player getVariable ["Escorting",false]) || life_istazed || life_action_inUse) exitWith {closeDialog 0;};
if ((getNumber(missionConfigFile >> "Cation_Trade" >> "version")) > 4) then {
    if ((player getVariable ["playerSurrender",false]) || life_isknocked) exitWith {closeDialog 0;};
};
closeDialog 0;
if (dialog) exitWith {};
if (!createDialog "Cat_trade_vendor") exitWith {};
disableSerialization;

private _display = findDisplay 9600;
(_display displayCtrl 9601) ctrlSetText format[["treaty"] call cat_trade_fnc_getText];
(_display displayCtrl 9602) ctrlSetText format["%1:",["buyer"] call cat_trade_fnc_getText];
(_display displayCtrl 9603) ctrlSetText format["%1",name _receiver];
(_display displayCtrl 9604) ctrlSetText format["%1:",["vendor"] call cat_trade_fnc_getText];
(_display displayCtrl 9605) ctrlSetText format["%1",name player];
(_display displayCtrl 9606) ctrlSetText format["%1",["type"] call cat_trade_fnc_getText];
private _typeDropdown = _display displayCtrl 9607;
(_display displayCtrl 9610) ctrlSetText format["%1",["details"] call cat_trade_fnc_getText];
(_display displayCtrl 9613) ctrlSetText format["%1:",["amount"] call cat_trade_fnc_getText];
(_display displayCtrl 9615) ctrlSetText format["%1:",["price"] call cat_trade_fnc_getText];
private _checkbox = _display displayCtrl 9617;
(_display displayCtrl 9618) ctrlSetText format[["accept"] call cat_trade_fnc_getText];
(_display displayCtrl 9619) ctrlSetText format["%1, %2.%3.%4",text ((nearestLocations [player,["NameCityCapital","NameCity","NameVillage"],10000]) select 0),date select 2, date select 1, date select 0];
(_display displayCtrl 9620) ctrlSetText format["%1",["sign"] call cat_trade_fnc_getText];
(_display displayCtrl 9621) ctrlSetText format["%1",name player];
(_display displayCtrl 9622) ctrlSetText format["%1",name _receiver];

private _marker = createMarkerLocal ["cat_trade_marker",[0,0]];

[] spawn {
    for "_i" from 0 to 1 step 0 do {
        sleep 1;
        if (!dialog) exitWith {
            deleteMarkerLocal "cat_trade_marker";
        };
    };
};

lbClear _typeDropdown;
_typeDropdown lbAdd format [["items"] call cat_trade_fnc_getText];
if (playerSide isEqualTo (side _receiver)) then {
    _typeDropdown lbAdd format [["vehicles"] call cat_trade_fnc_getText];
    _typeDropdown lbAdd format [["houses"] call cat_trade_fnc_getText];
};
_typeDropdown lbSetCurSel 0;

_checkbox ctrlSetChecked false;

_display setVariable ["receiver",_receiver];