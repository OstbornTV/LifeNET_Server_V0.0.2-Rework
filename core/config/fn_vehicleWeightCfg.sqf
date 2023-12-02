/*
    File: fn_vehicleWeightCfg.sqf
    Author: Bryan "Tonic" Boardwine
    Description: Master configuration for vehicle weight.
*/

// Parameters:
//   _className: The class name of the vehicle
params [
    ["_className", "", [""]]
];

// Check if the class name exists in LifeCfgVehicles
if !(isClass (missionConfigFile >> "LifeCfgVehicles" >> _className)) then {
    diag_log format ["%1: LifeCfgVehicles class doesn't exist", _className];
    _className = "Default"; // Use Default if the specified class doesn't exist
}

// Get the vItemSpace value from LifeCfgVehicles
private _weight = M_CONFIG(getNumber, "LifeCfgVehicles", _className, "vItemSpace");

// If vItemSpace is not defined, set it to -1
if (isNil "_weight") then {
    _weight = -1;
}

// Return the calculated weight
_weight;
