
/*
    File: fn_spawnVehicle.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
	Spawns vehicle and setups variables of vehicle
*/
params [
	["_item","",[""]],
	["_spawnPoint","",[""]],
	["_side","",[""]],
	["_skin","",[""]]
];
if (_item isEqualTo "" || _spawnPoint isEqualTo "") exitWith {false}; // check if variables are set
if !((nearestObjects[(getMarkerPos _spawnPoint),["Car","Ship","Air"],5]) isEqualTo []) exitWith {false}; // check if spawnpoint is not blocked by other vehicle

if ((getNumber(missionConfigFile >> "Cation_CraftingV2" >> "DebugMode")) isEqualTo 1) then { // if debug mode is enabled
    diag_log format["cationstudio crafting: [INFO] spawning vehicle %1. Function cat_craftingV2_fnc_spawnVehicle",_item]; // log entry
};

private _c = 0; // initialize variable
private _colorIndex = 0; // initialize variable
{
	private _flag = _x select 1; // get side
    private _textureName = _x select 0; // get skin name
    if (_flag isEqualTo _side && _textureName isEqualTo _skin) exitWith { // if side and skin is found
        _colorIndex = _c; // set color index
    };
    _c = _c + 1; // iterate variable
} forEach getArray(missionConfigFile >> "LifeCfgVehicles" >> _item >> "textures"); // for each skin of vehicle
_vehicle = createVehicle [_item, (getMarkerPos _spawnPoint), [], 0, "NONE"]; // create vehicle
waitUntil {!isNil "_vehicle" && {!isNull _vehicle}}; //Wait?
_vehicle allowDamage false; //Temp disable damage handling..
_vehicle setPos (getMarkerPos _spawnPoint); // set vehicle position to marker position
_vehicle setVectorUp (surfaceNormal (getMarkerPos _spawnPoint)); // setup height
_vehicle setDir (markerDir _spawnPoint); // setup direction
_vehicle lock 2; // lock vehicle
[_vehicle,_colorIndex] call life_fnc_colorVehicle; // set skin
[_vehicle] call life_fnc_clearVehicleAmmo; // remove items inside vehicle
[_vehicle,"trunk_in_use",false,true] remoteExecCall ["TON_fnc_setObjVar",2]; // setup variable
[_vehicle,"vehicle_info_owners",[[getPlayerUID player,profileName]],true] remoteExecCall ["TON_fnc_setObjVar",2]; // setup vehicle owners
_vehicle disableTIEquipment true; //No Thermals.. They're cheap but addictive.
_vehicle allowDamage true; // allow damage
life_vehicles pushBack _vehicle; // add to keyring
if (getNumber(missionConfigFile >> "Cation_CraftingV2" >> "HeadlessSupport") isEqualTo 0) then { // if headless client is disabled
	[getPlayerUID player,playerSide,_vehicle,1] remoteExecCall ["TON_fnc_keyManagement",2]; // call server keymanagement
    [(getPlayerUID player),playerSide,_vehicle,_colorIndex] remoteExecCall ["TON_fnc_vehicleCreate",2]; // call server to add vehicle to database
} else { // else if headless client is enabled
    if (life_HC_isActive) then { // if headless client is active
     	[getPlayerUID player,playerSide,_vehicle,1] remoteExecCall ["HC_fnc_keyManagement",HC_Life]; // call headless client keymanagement
        [(getPlayerUID player),playerSide,_vehicle,_colorIndex] remoteExecCall ["HC_fnc_vehicleCreate",HC_Life]; // call headless client to add vehicle to database
    } else { // else if headless client is inactive
        [getPlayerUID player,playerSide,_vehicle,1] remoteExecCall ["TON_fnc_keyManagement",2]; // call server keymanagement
        [(getPlayerUID player),playerSide,_vehicle,_colorIndex] remoteExecCall ["TON_fnc_vehicleCreate",2]; // call server to add vehicle to database
    };
};

true; // return success