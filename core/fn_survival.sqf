#include "..\script_macros.hpp"
/*
    File: fn_survival.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    All survival-related functions merged into one script.
*/

// Funktion zum Essen
_fnc_food =  {
    if (life_hunger < 2) then {player setDamage 1; hint localize "STR_NOTF_EatMSG_Death";}
    else
    {
        life_hunger = life_hunger - 10;
        [] call life_fnc_hudUpdate;
        
        if (life_hunger < 2) then {player setDamage 1; hint localize "STR_NOTF_EatMSG_Death";};
        
        switch (life_hunger) do {
            case 30: {hint localize "STR_NOTF_EatMSG_1";};
            case 20: {hint localize "STR_NOTF_EatMSG_2";};
            case 10: {
                hint localize "STR_NOTF_EatMSG_3";
                if (LIFE_SETTINGS(getNumber,"enable_fatigue") isEqualTo 1) then {player setFatigue 1;};
            };
        };
    };
};

// Funktion zum Trinken
_fnc_water = {
    if (life_thirst < 2) then {player setDamage 1; hint localize "STR_NOTF_DrinkMSG_Death";}
    else
    {
        life_thirst = life_thirst - 10;
        [] call life_fnc_hudUpdate;
        
        if (life_thirst < 2) then {player setDamage 1; hint localize "STR_NOTF_DrinkMSG_Death";};
        
        switch (life_thirst) do  {
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
};

// Funktion für den Gehaltsscheck
_fnc_paycheck = {
    if (alive player) then {
        private _paycheck = call life_paycheck;
        if (player distance (getMarkerPos "fed_reserve") < 120 && playerSide isEqualTo west) then {
            systemChat format [localize "STR_ReceivedPay",[_paycheck + 1500] call life_fnc_numberText];
            BANK = BANK + _paycheck + 1500;
        } else {
            BANK = BANK + _paycheck;
            systemChat format [localize "STR_ReceivedPay",[_paycheck] call life_fnc_numberText];
        };
    } else {
        systemChat localize "STR_MissedPay";
    };
    systemChat format [localize "STR_Paycheck",(getNumber(missionConfigFile >> "Life_Settings" >> "paycheck_period"))];
};

// Setup der zeitbasierten Variablen
_foodTime = time;
_waterTime = time;
private _paycheckTime = time;
private _paycheckPeriod = (getNumber(missionConfigFile >> "Life_Settings" >> "paycheck_period")) * 60;
_walkDis = 0;
_bp = "";
_lastPos = visiblePosition player;
_lastPos = (_lastPos select 0) + (_lastPos select 1);

// Hauptausführungsbereich
for "_i" from 0 to 1 step 0 do {
    /* Thirst / Hunger Anpassung basierend auf der Zeit */
    if ((time - _waterTime) > 600 && {!life_god}) then {[] call _fnc_water; _waterTime = time;};
    if ((time - _foodTime) > 850 && {!life_god}) then {[] call _fnc_food; _foodTime = time;};
    if ((time - _paycheckTime) > _paycheckPeriod) then {[] call _fnc_paycheck; _paycheckTime = time};
    
    /* Anpassung der Tragekapazität basierend auf Rucksackänderungen */
    if (backpack player isEqualTo "") then {
        life_maxWeight = LIFE_SETTINGS(getNumber,"total_maxWeight");
        _bp = backpack player;
    } else {
        if (!(backpack player isEqualTo "") && {!(backpack player isEqualTo _bp)}) then {
            _bp = backpack player;
            life_maxWeight = LIFE_SETTINGS(getNumber,"total_maxWeight") + round(FETCH_CONFIG2(getNumber,"CfgVehicles",_bp,"maximumload") / 4);
        };
    };

    /* Überprüfen, ob das Gewicht geändert wurde und der Spieler zu viel trägt */
    if (life_carryWeight > life_maxWeight && {!isForcedWalk player} && {!life_god}) then {
        player forceWalk true;
        if (LIFE_SETTINGS(getNumber,"enable_fatigue") isEqualTo 1) then {player setFatigue 1;};
        hint localize "STR_NOTF_MaxWeight";
    } else {
        if (isForcedWalk player) then {
            player forceWalk false;
        };
    };
    
    /* Zurückgelegte Strecke zur Verringerung von Durst / Hunger, die jede Sekunde erfasst wird, sodass die Strecke tatsächlich größer als 650 ist */
    if (!alive player || {life_god}) then {_walkDis = 0;} else {
        _curPos = visiblePosition player;
        _curPos = (_curPos select 0) + (_curPos select 1);
        if (!(_curPos isEqualTo _lastPos) && {(isNull objectParent player)}) then {
            _walkDis = _walkDis + 1;
            if (_walkDis isEqualTo 650) then {
                _walkDis = 0;
                life_thirst = life_thirst - 5;
                life_hunger = life_hunger - 5;
                [] call life_fnc_hudUpdate;
            };
        };
        _lastPos = visiblePosition player;
        _lastPos = (_lastPos select 0) + (_lastPos select 1);
    };
    uiSleep 1;
};
