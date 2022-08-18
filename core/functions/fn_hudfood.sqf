#include "..\..\script_macros.hpp"

// fn_hudfood.sqf

private _wert = if(player getVariable ["ACE_isUnconscious",false])then{5}else{10};

if (life_hunger < 2) then 
{
    player setDamage 1; hint localize "STR_NOTF_EatMSG_Death";
} else 
{
    life_hunger = life_hunger - _wert;
    [] spawn life_fnc_hudUpdate;
    if (life_hunger < 2) then {player setDamage 1; hint localize "STR_NOTF_EatMSG_Death";};
    switch (life_hunger) do 
    {
        case 30: {hint localize "STR_NOTF_EatMSG_1";};
        case 20: {hint localize "STR_NOTF_EatMSG_2";};
        case 10: {
         hint localize "STR_NOTF_EatMSG_3";
         if (LIFE_SETTINGS(getNumber,"enable_fatigue") isEqualTo 1) then {player setFatigue 1;};
        };
    };
};
