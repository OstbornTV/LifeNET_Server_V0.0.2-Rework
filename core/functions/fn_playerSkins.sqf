#include "..\..\script_macros.hpp"
/*
    File: fn_playerSkins.sqf
    Author: Daniel Stuart

    Description:
    Sets skins for players by their side and uniform.
*/
private ["_skinName"];
private ["_skinName2"];

switch (playerSide) do {
    case civilian: {
        if (LIFE_SETTINGS(getNumber,"civ_skins") isEqualTo 1) then {
            if (uniform player isEqualTo "U_C_Poloshirt_blue") then {
                player setObjectTextureGlobal [0, "\LifeNET_Skins\Zivi\civilian_uniform_1.jpg"];
            };
            if (uniform player isEqualTo "U_C_Poloshirt_burgundy") then {
                player setObjectTextureGlobal [0, "\LifeNET_Skins\Zivi\civilian_uniform_2.jpg"];
            };
            if (uniform player isEqualTo "U_C_Poloshirt_stripped") then {
                player setObjectTextureGlobal [0, "\LifeNET_Skins\Zivi\civilian_uniform_3.jpg"];
            };
            if (uniform player isEqualTo "U_C_Poloshirt_tricolour") then {
                player setObjectTextureGlobal [0, "\LifeNET_Skins\Zivi\civilian_uniform_4.jpg"];
            };
            if (uniform player isEqualTo "U_C_Poloshirt_salmon") then {
                player setObjectTextureGlobal [0, "\LifeNET_Skins\Zivi\civilian_uniform_5.jpg"];
            };
            if (uniform player isEqualTo "U_C_Poloshirt_redwhite") then {
                player setObjectTextureGlobal [0, "\LifeNET_Skins\Zivi\civilian_uniform_6.jpg"];
            };
            if (uniform player isEqualTo "U_C_Commoner1_1") then {
                player setObjectTextureGlobal [0, "\LifeNET_Skins\Zivi\civilian_uniform_7.jpg"];
            };
        };
    };

    case west: {
        if (uniform player isEqualTo "U_Rangemaster") then {
            _skinName = "\LifeNET_Skins\polizei\polizei_uniform.paa";
            if (LIFE_SETTINGS(getNumber,"cop_extendedSkins") isEqualTo 1) then {
                if (FETCH_CONST(life_coplevel) >= 1) then {
                    _skinName = ["\LifeNET_Skins\polizei\polizei_rang_",(FETCH_CONST(life_coplevel)),".paa"] joinString "";
                };
            };
            player setObjectTextureGlobal [0, _skinName];
        };
    };

    case independent: {
        if (uniform player isEqualTo "U_Rangemaster") then {
            _skinName2 = "\LifeNET_Skins\medic\medic_uniform.paa";
            if (LIFE_SETTINGS(getNumber,"med_extendedSkins") isEqualTo 1) then {
                if (FETCH_CONST(life_medicLevel) >= 1) then {
                    _skinName2 = ["\LifeNET_Skins\medic\Rettungsdienst_Uniform_",(FETCH_CONST(life_medicLevel)),".paa"] joinString "";
                };
            };
            player setObjectTextureGlobal [0, _skinName2];
        };
    };
};
