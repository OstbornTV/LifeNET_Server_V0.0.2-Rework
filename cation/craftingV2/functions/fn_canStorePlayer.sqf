/*
    File: fn_canStorePlayer.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
    Returns how many items can be stored in player inventory.
*/
params [
	["_item","",[""]],
	["_vItem",false,[false]]
];
private _return = 0;

if (_vItem) then { // if vItem
	private _weight = [_item] call life_fnc_itemWeight; // get item weight
	_return = floor ((life_maxWeight - life_carryWeight) / _weight); // calculate amount of item that can be stored in player inventory
} else { // ArmA item
	private _category = switch (true) do { // get item category from config
        case (isClass(configFile >> "CfgMagazines" >> _item)): {"CfgMagazines"};
        case (isClass(configFile >> "CfgVehicles" >> _item)): {"CfgVehicles"};
        case (isClass(configFile >> "CfgGlasses" >> _item)): {"CfgGlasses"};
        default {"CfgWeapons"};
    };

	switch (_category) do { // switch item category
		case "CfgVehicles" : { // vehicles, here: only backpack
            if ((backpack player) isEqualTo "") then { _return = 1; }; // if no backpack 1
        };
		case "CfgWeapons" : { // weapons
			private _type = getNumber(configFile >> "CfgWeapons" >> _item >> "type"); // get weapon type from config
			if (_type in [1,2,4]) then { // if weapon
				switch (_type) do { // switch weapon type
					case 1 : { // primary weapon
						if (primaryWeapon player isEqualTo "") then {_return = 1;}; // if no primary weapon 1
					};
					case 2 : { // handgun
						if (handgunWeapon player isEqualTo "") then {_return = 1;}; // if no handgun 1
					};
					case 4 : { // secondary weapon
						if (secondaryWeapon player isEqualTo "") then {_return = 1;}; // if no secondary weapon 1
					};
				};
			} else {
				_base = [(configfile >> "CfgWeapons" >> _item),true ] call BIS_fnc_returnParents; // get base class from config
				while {player canAdd [_item,_return + 1]} do { // try adding to inventory directly
					_return = _return + 1; // +1
				};
				if (("Vest_Camo_Base" in _base) || ("Vest_NoCamo_Base" in _base)) then { // if vest
					if ((vest player) isEqualTo "") then { // if no vest
						_return = _return + 1; // +1
					};
				};
				if ("Uniform_Base" in _base) then { // if uniform
					if ((uniform player) isEqualTo "") then { // if no uniform
						_return = _return + 1; // +1
					};
				};
				if (("H_HelmetB" in _base) || ("HelmetBase" in _base)) then { // if helmet / headgear
					if ((headgear player) isEqualTo "") then { // if no headgear / helmet
						_return = _return + 1; // +1
					};
				};
			};
        };
        case "CfgGlasses" : { // if google
            while {player canAdd [_item,_return + 1]} do { // try adding to inventory directly
                _return = _return + 1; // +1
            };
        	if ((goggles player) isEqualTo "") then { // if no google
           		_return = _return + 1; // +1
            };
        };
	};
};

_return; // return item amount that can be stored in player inventory