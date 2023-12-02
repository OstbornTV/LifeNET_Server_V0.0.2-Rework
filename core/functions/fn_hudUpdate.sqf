#include "..\..\script_macros.hpp"

/*
    File: fn_hudUpdate.sqf
    Author: Daniel Stuart

    Description:
    Updates the HUD when it needs to.
*/
#define IDC_LIFE_BAR_SERVERNAME 3202
#define IDC_LIFE_BAR_PLAYERNAME 3203

// Deaktiviere die Serialisierung, um sicherzustellen, dass bestimmte Variablen nicht gespeichert werden
disableSerialization;

// Überprüfe, ob LIFEdisplay bereits erstellt wurde
if (isNull LIFEdisplay) then {
    // Wenn nicht, schneide die Ressource "playerHUD" ab und zeige sie an
    cutRsc ["playerHUD", "PLAIN", 2, false];
}

// Aktualisiere die Fortschrittsbalken für Hunger und Durst basierend auf den aktuellen Werten
LIFEctrl(2200) progressSetPosition (life_hunger / 100);
LIFEctrl(2202) progressSetPosition (life_thirst / 100);

/*
// Kommentierte Codeabschnitte, die den Durst- und Hungerwert begrenzen
if(isNil "life_thirst") then
{
    life_thirst = 100;
};

if(life_thirst > 100)then 
{
    life_thirst = 100;
};

if(isNil "life_hunger") then
{
    life_hunger = 100;
};

if(life_hunger > 100)then 
{
    life_hunger = 100;
};
*/

// Setze den strukturierten Text für den Spielername im HUD
LIFEctrl(IDC_LIFE_BAR_PLAYERNAME) ctrlSetStructuredText parseText format ["<t font='EtelkaNarrowMediumPro' size='1' color='#FFFFFF' align='right'>%1</t>", (player getVariable ["realname",profileName])];
