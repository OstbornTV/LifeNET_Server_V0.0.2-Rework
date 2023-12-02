/*
    File: fn_onTakeItem.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Blockiert die Einheit daran, etwas aufzunehmen, das sie nicht haben sollte.
*/
private ["_unit","_container","_item","_restrictedClothing","_restrictedWeapons"];
_unit = [_this,0,objNull,[objNull]] call BIS_fnc_param;
_container = [_this,1,objNull,[objNull]] call BIS_fnc_param;
_item = [_this,2,"",[""]] call BIS_fnc_param;

// Überprüfe auf ungültige Einheiten oder Gegenstände
if (isNull _unit || _item isEqualTo "") exitWith {};

// Eingeschränkte Kleidung und Waffen aus den Einstellungen abrufen
_restrictedClothing = LIFE_SETTINGS(getArray,"restricted_uniforms");
_restrictedWeapons = LIFE_SETTINGS(getArray,"restricted_weapons");

// Fallunterscheidung nach Fraktion
switch (playerSide) do
{
    case west: {
        // Spezielle Behandlung für die Westseite
        if (_item in ["U_Rangemaster"]) then {
            [] call life_fnc_playerSkins;
        };
    };
    case civilian: {
        // Spezielle Behandlung für Zivilisten
        if (LIFE_SETTINGS(getNumber,"restrict_clothingPickup") isEqualTo 1) then {
            // Kleidungsaufnahme einschränken, falls aktiviert
            if (_item in _restrictedClothing) then {
                [_item,false,false,false,false] call life_fnc_handleItem;
            };
        };
        if (LIFE_SETTINGS(getNumber,"restrict_weaponPickup") isEqualTo 1) then {
            // Waffenaufnahme einschränken, falls aktiviert
            if (_item in _restrictedWeapons) then {
                [_item,false,false,false,false] call life_fnc_handleItem;
            };
        };
        // Spezielle Behandlung für bestimmte Kleidungsstücke
        if (_item in ["U_C_Poloshirt_blue","U_C_Poloshirt_burgundy","U_C_Poloshirt_stripped","U_C_Poloshirt_tricolour","U_C_Poloshirt_salmon","U_C_Poloshirt_redwhite","U_C_Commoner1_1"]) then {
            [] call life_fnc_playerSkins;
        };
    };
    case independent: {
        // Spezielle Behandlung für die Unabhängigen
        if (_item in ["U_Rangemaster"]) then {
            [] call life_fnc_playerSkins;
        };
        // Waffenbeschränkung für Sanitäter, falls aktiviert
        if (LIFE_SETTINGS(getNumber,"restrict_medic_weapons") isEqualTo 1) then {
            // Überprüfen, ob der Typ eine Waffe ist
            if (isClass (configFile >> "CfgWeapons" >> _item)) then { 
                // Entferne alle Waffen von der Einheit (_unit)
                removeAllWeapons _unit;
            };
        };
    };
};
