/*
    File: fn_setupEVH.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Master eventhandler file
*/

// Definiere die Event-Handler-Funktionen
private ["_onPlayerKilledEH", "_handleDamageEH", "_onPlayerRespawnEH", "_onTakeItemEH", "_onFiredEH", "_inventoryClosedEH", "_inventoryOpenedEH", "_handleRatingEH", "_getInManEH", "_getOutManEH", "_checkMapEH", "_onGameInterruptEH"];

_onPlayerKilledEH = {_this call life_fnc_onPlayerKilled};
_handleDamageEH = {_this call life_fnc_handleDamage};
_onPlayerRespawnEH = {_this call life_fnc_onPlayerRespawn};
_onTakeItemEH = {_this call life_fnc_onTakeItem};
_onFiredEH = {_this call life_fnc_onFired};
_inventoryClosedEH = {_this call life_fnc_inventoryClosed};
_inventoryOpenedEH = {_this call life_fnc_inventoryOpened};
_handleRatingEH = {0}; // Dummy-Event-Handler für "HandleRating"

_getInManEH = {_this call life_fnc_getInMan};
_getOutManEH = {_this call life_fnc_getOutMan};
_checkMapEH = {_this call life_fnc_checkMap};
_onGameInterruptEH = {_this call life_fnc_onGameInterrupt};

// Registriere die Event-Handler-Funktionen
player addEventHandler ["Killed", _onPlayerKilledEH];
player addEventHandler ["HandleDamage", _handleDamageEH];
player addEventHandler ["Respawn", _onPlayerRespawnEH];
player addEventHandler ["Take", _onTakeItemEH];
player addEventHandler ["Fired", _onFiredEH];
player addEventHandler ["InventoryClosed", _inventoryClosedEH];
player addEventHandler ["InventoryOpened", _inventoryOpenedEH];
player addEventHandler ["HandleRating", _handleRatingEH];

player addEventHandler ["GetInMan", _getInManEH];
player addEventHandler ["GetOutMan", _getOutManEH];

addMissionEventHandler ["Map", _checkMapEH];

[missionNamespace, "OnGameInterrupt", _onGameInterruptEH] call BIS_fnc_addScriptedEventHandler;
