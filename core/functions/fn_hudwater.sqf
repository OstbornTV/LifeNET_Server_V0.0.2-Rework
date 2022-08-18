#include "..\..\script_macros.hpp"

// fn_hudwater.sqf

private _wert = if(player getVariable ["ACE_isUnconscious",false])then{5}else{10};

if (life_thirst < 2) then 
{
    player setDamage 1; hint localize "STR_NOTF_DrinkMSG_Death";
} else 
{
    life_thirst = life_thirst - _wert;
    [] spawn life_fnc_hudUpdate;
    if (life_thirst < 2) then {player setDamage 1; hint localize "STR_NOTF_DrinkMSG_Death";};
    switch (life_thirst) do 
    {
        case 30: {hint localize "STR_NOTF_DrinkMSG_1";};
        case 20: {
            hint localize "STR_NOTF_DrinkMSG_2";
            if (LIFE_SETTINGS(getNumber,"enable_fatigue") isEqualTo 1) then {player setFatigue 1;};
        };
        case 10: {
            hint localize "STR_NOTF_DrinkMSG_3";
            if (LIFE_SETTINGS(getNumber,"enable_fatigue") isEqualTo 1) then {player setFatigue 1;};
        };
    };
};
