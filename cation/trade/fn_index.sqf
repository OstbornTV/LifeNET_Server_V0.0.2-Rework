/*
    File: fn_index.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
	Checks if String in array and optional if Number on position 2 is the same.   
*/
private["_string","_count","_itemOnIndex","_array","_return","_number"];
_string = _this select 0;
_array = _this select 1;
_number = _this select 2;
if (typeName _array != "ARRAY") exitWith {};
_count = (count _array) - 1;
for "_i" from 0 to _count do {
    _itemOnIndex = (_array select _i);
    if ((_string in _itemOnIndex) && (isNil { _return })) then {
        if (_number isEqualTo -1) then {
            _return = _i;
        } else {
            if (_number isEqualTo (_itemOnIndex select 2)) then {
                _return = _i;
            };
        };
    };
};
if (isNil { _return }) then {
    _return = -1;
};
_return;