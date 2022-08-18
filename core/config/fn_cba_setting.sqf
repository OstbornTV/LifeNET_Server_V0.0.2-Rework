/*
    https://cbateam.github.io/CBA_A3/docs/files/settings/fnc_init-sqf.html
*/

["HUD_Auswahl", "LIST","HUD Auswahl", "LifeNET Settings", [["hud_1","hud_2","hud_3"], ["HUD 1","HUD 2","HUD 3"], 0],false,{params ["_value"];life_hudsel=_value;[] spawn life_fnc_hudSetup;}] call cba_settings_fnc_init;

["Namen_sortieren", "LIST","Namen sortieren", "LifeNET Settings", [[false,true], ["nein","alphabetisch"], 1],false,{params ["_value"];life_sortname=_value;}] call cba_settings_fnc_init;

["Garage_sortieren", "LIST","Garage sortieren", "LifeNET Settings", [[false,true], ["nein","alphabetisch"], 1],false,{params ["_value"];life_sortgarage=_value;}] call cba_settings_fnc_init;

["vItem_sortieren", "LIST","vItem sortieren", "LifeNET Settings", [[false,true], ["nein","alphabetisch"], 1],false,{params ["_value"];life_sortvirt=_value;}] call cba_settings_fnc_init;

["gang_konto", "LIST","Abfrage mit Gangkonto zahlen", "LifeNET Settings", [[false,true], ["nein","ja"], 0],false,{params ["_value"];life_vitemgang=_value;}] call cba_settings_fnc_init;

["noweapon_getout", "LIST","Ohne Waffe austeigen anzeigen?", "LifeNET Settings", [[false,true], ["nein","ja"], 0],false,{params ["_value"];life_noweapongetout=_value;}] call cba_settings_fnc_init;

["essen_trinken", "LIST","Essen/trinken animationen?", "LifeNET Settings", [[false,true], ["nein","ja"], 1],false,{params ["_value"];life_essen_trinken=_value;}] call cba_settings_fnc_init;

["ace_gps_map", "LIST","GPS auf der Karte anzeigen?", "LifeNET Settings", [[false,true], ["nein","ja"], 1],false,{params ["_value"];ace_maptools_mapgpsshow=_value;}] call cba_settings_fnc_init;