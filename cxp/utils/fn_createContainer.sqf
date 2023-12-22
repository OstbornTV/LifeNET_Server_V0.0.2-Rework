/*
	Author: Casperento
	
	Description:
	Create a basic container to be used on the process of building a menu

	This code is provided by CXP SCRIPTS on https://bytex.market/sellers/profile/K970748533
*/
params [
	["_containerDisplay", displayNull, [displayNull]],
	["_resourceName", "", [""]],
	["_idc", -1, [0]],
	["_containerX", 0.0, [0.0]],
	["_containerY", 0.0, [0.0]],
	["_containerW", 1.0, [0.0]],
	["_containerH", 1.0, [0.0]],
	["_containerGroup", controlNull, [controlNull]]
];

// Überprüft, ob ein Display und ein Ressourcenname übergeben wurden
if (isNull _containerDisplay) exitWith {diag_log "[CXP-UTILS] ERROR: YOU NEED TO PASS A DISPLAY TO CREATE A NEW CONTAINER !!!"};
if (_resourceName isEqualTo "") exitWith {diag_log "[CXP-UTILS] ERROR: YOU NEED TO PASS A RESOURCE NAME TO CREATE A NEW CONTAINER !!!"};

// Erstellt einen Container basierend auf den Parametern
private "_container";
if (isNull _containerGroup) then {
	_container = _containerDisplay ctrlCreate [_resourceName, _idc];
} else {
	_container = _containerDisplay ctrlCreate [_resourceName, _idc, _containerGroup];
};
_container ctrlSetPosition [_containerX, _containerY, _containerW, _containerH];
_container ctrlCommit 0;
_container
