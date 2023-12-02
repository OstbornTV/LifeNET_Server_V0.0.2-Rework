/*
    File: fn_playerSkins.sqf
    Author: Daniel Stuart

    Description:
    Setzt Skins für Spieler basierend auf ihrer Fraktion und Uniform.
*/
private ["_skinName", "_skinName2"];

// Fallunterscheidung nach Fraktion
switch (playerSide) do {
    case civilian: {
        // Zivilistenskins setzen, falls aktiviert
        if (LIFE_SETTINGS(getNumber,"civ_skins") isEqualTo 1) then {
            // Überprüfen und den passenden Skin basierend auf der Uniform setzen
            switch (uniform player) do {
                case "U_C_Poloshirt_blue": {
                    player setObjectTextureGlobal [0, "\LifeNET_Skins\Zivi\civilian_uniform_1.jpg"];
                };
                case "U_C_Poloshirt_burgundy": {
                    player setObjectTextureGlobal [0, "\LifeNET_Skins\Zivi\civilian_uniform_2.jpg"];
                };
                case "U_C_Poloshirt_stripped": {
                    player setObjectTextureGlobal [0, "\LifeNET_Skins\Zivi\civilian_uniform_3.jpg"];
                };
                case "U_C_Poloshirt_tricolour": {
                    player setObjectTextureGlobal [0, "\LifeNET_Skins\Zivi\civilian_uniform_4.jpg"];
                };
                case "U_C_Poloshirt_salmon": {
                    player setObjectTextureGlobal [0, "\LifeNET_Skins\Zivi\civilian_uniform_5.jpg"];
                };
                case "U_C_Poloshirt_redwhite": {
                    player setObjectTextureGlobal [0, "\LifeNET_Skins\Zivi\civilian_uniform_6.jpg"];
                };
                case "U_C_Commoner1_1": {
                    player setObjectTextureGlobal [0, "\LifeNET_Skins\Zivi\civilian_uniform_7.jpg"];
                };
            };
        };
    };

    case west: {
        // Polizeiskins setzen, falls die Uniform U_Rangemaster ist
        if (uniform player isEqualTo "U_Rangemaster") then {
            _skinName = "\LifeNET_Skins\polizei\polizei_uniform.paa";
            // Überprüfen, ob erweiterte Skins aktiviert sind
            if (LIFE_SETTINGS(getNumber,"cop_extendedSkins") isEqualTo 1) then {
                // Überprüfen, ob der Rang hoch genug ist, um spezifische Skins zu verwenden
                if (FETCH_CONST(life_coplevel) >= 1) then {
                    _skinName = ["\LifeNET_Skins\polizei\polizei_rang_",(FETCH_CONST(life_coplevel)),".paa"] joinString "";
                };
            };
            player setObjectTextureGlobal [0, _skinName];
        };
    };

    case independent: {
        // Medizinerskins setzen, falls die Uniform U_Rangemaster ist
        if (uniform player isEqualTo "U_Rangemaster") then {
            _skinName2 = "\LifeNET_Skins\medic\medic_uniform.paa";
            // Überprüfen, ob erweiterte Skins aktiviert sind
            if (LIFE_SETTINGS(getNumber,"med_extendedSkins") isEqualTo 1) then {
                // Überprüfen, ob das Medizinlevel hoch genug ist, um spezifische Skins zu verwenden
                if (FETCH_CONST(life_medicLevel) >= 1) then {
                    _skinName2 = ["\LifeNET_Skins\medic\Rettungsdienst_Uniform_",(FETCH_CONST(life_medicLevel)),".paa"] joinString "";
                };
            };
            player setObjectTextureGlobal [0, _skinName2];
        };
    };
};
