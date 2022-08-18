/*
    File: fn_canStore.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
    Checks how many items can be stored to locker, player or vehicle.
*/
params [
	["_item","",[""]],
	["_type",-1,[0]],
	["_storage",-1,[0]]
];
private _return = 0;

switch (_type) do {
	case 0 : {
		private _weight = [_item] call life_fnc_itemWeight;
		switch(_storage) do {
			case 0 : {
				_return = floor ((cat_locker_maxWeight - cat_locker_carryWeight) / _weight);
			};
			case 1 : {
				_return = floor ((life_maxWeight - life_carryWeight) / _weight);
			};
			case 2 : {
				_return = floor (((([cat_locker_vehicle] call life_fnc_vehicleWeight) select 0) - (([cat_locker_vehicle] call life_fnc_vehicleWeight) select 1))  / _weight);
			};
		};
	};
	case 1 : {
		switch(_storage) do {
			case 0 : {
				private _weight = [_item,_type] call cat_locker_fnc_itemWeight;
                _return = floor ((cat_locker_maxWeight - cat_locker_carryWeight) / _weight);
			};
			case 1 : {
				switch (getNumber(configFile >> "CfgWeapons" >> _item >> "type")) do {
					case 1 : {
						if (primaryWeapon player isEqualTo "") then {_return = 1;};
					};
					case 2 : {
						if (handgunWeapon player isEqualTo "") then {_return = 1;};
					};
					case 4 : {
						if (secondaryWeapon player isEqualTo "") then {_return = 1;};
					};
				};
			};
		};
	};
	case 2 : {
		switch(_storage) do {
			case 0 : {
                private _section = switch (true) do {
                    case (isClass(configFile >> "CfgMagazines" >> _item)): {"CfgMagazines"};
                    case (isClass(configFile >> "CfgVehicles" >> _item)): {"CfgVehicles"};
                    case (isClass(configFile >> "CfgGlasses" >> _item)): {"CfgGlasses"};
                    default {"CfgWeapons"};
                };
				private _weight = [_item,_type] call cat_locker_fnc_itemWeight;
                _return = floor ((cat_locker_maxWeight - cat_locker_carryWeight) / _weight);
			};
			case 1 : {
				private _count = 0;
				while {player canAdd [_item,_count + 1]} do {
                    _count = _count + 1;
                };
                _return = _count;
			};
		};
	};
	case 3 : {
        private _section = switch (true) do {
            case (isClass(configFile >> "CfgMagazines" >> _item)): {"CfgMagazines"};
            case (isClass(configFile >> "CfgVehicles" >> _item)): {"CfgVehicles"};
            case (isClass(configFile >> "CfgGlasses" >> _item)): {"CfgGlasses"};
            default {"CfgWeapons"};
        };
		switch(_storage) do {            
			case 0 : {
				private _weight = [_item,_type] call cat_locker_fnc_itemWeight;
                _return = floor ((cat_locker_maxWeight - cat_locker_carryWeight) / _weight);
            };
			case 1 : {
				private _count = 0;
                _base = [(configfile >> "CfgWeapons" >> _item),true ] call BIS_fnc_returnParents;
                switch (_section) do {
                    case "CfgVehicles" : {
                        if ((backpack player) isEqualTo "") then {
                            _count = 1;
                        };
                    };
                    case "CfgWeapons" : {
                        while {player canAdd [_item,_count + 1]} do {
                            _count = _count + 1;
                        };
                        if (("Vest_Camo_Base" in _base) || ("Vest_NoCamo_Base" in _base)) then {
                            if ((vest player) isEqualTo "") then {
                                _count = _count + 1;
                            };
                        };
                        if ("Uniform_Base" in _base) then {
                            if ((uniform player) isEqualTo "") then {
                                _count = _count + 1;
                            };
                        };
                        if (("H_HelmetB" in _base) || ("HelmetBase" in _base)) then {
                            if ((headgear player) isEqualTo "") then {
                                _count = _count + 1;
                            };
                        };
                    };
                    case "CfgGlasses" : {
                        while {player canAdd [_item,_count + 1]} do {
                            _count = _count + 1;
                        };
                        if ((goggles player) isEqualTo "") then {
                            _count = _count + 1;
                        };
                    };
                };                
                _return = _count;
			};
		};
	};
};
_return;