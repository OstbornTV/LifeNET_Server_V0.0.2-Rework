#define ST_CENTER         0x02
#define INFINITE 1e+1000
#define IDC_LIFE_BAR_SERVERNAME 3202
#define IDC_LIFE_BAR_PLAYERNAME 3203
/*
    Author: Daniel Stuart

    File: hud_stats.hpp
*/

class playerHUD {
    idd = -1;
    duration = 10e10;
    movingEnable = 0;
    fadein = 0;
    fadeout = 0;
    name = "playerHUD";
    onLoad = "uiNamespace setVariable ['playerHUD',_this select 0]";
    objects[] = {};
    controls[] = {
        Life_RscBackground_HUD,
        Life_RscProgress_HUDFood,
        Life_RscProgress_HUDWater,
        Life_RscText_HUDFood,
        Life_RscText_HUDWater,
        LIFE_BAR_SERVERNAME,
        LIFE_BAR_PLAYERNAME
    };

    /* Background */
    class Life_RscBackground_HUD: Life_RscBackground {
        colorBackground[] = {0,0,0,0.35};
        x = 0.414815 * safezoneW + safezoneX;
        y = 0.966667 * safezoneH + safezoneY;
        w = 0.170371 * safezoneW;
        h = 0.0333333 * safezoneH;
    };

    /* Progress Bars */
    class LIFE_RscProgress_HUDCommon: Life_RscProgress {
        colorFrame[] = {0, 0, 0, 0.8};
        y = 0.972223 * safezoneH + safezoneY;
        w = 0.0462964 * safezoneW;
        h = 0.0222222 * safezoneH;
    };

    class Life_RscProgress_HUDFood: LIFE_RscProgress_HUDCommon {
        idc = 2200;
        colorBar[] = {0,0.50,0,0.65};
        x = 0.418981 * safezoneW + safezoneX;
    };
/*
    class Life_RscProgress_HUDHealth: LIFE_RscProgress_HUDCommon {
        idc = 2201;
        colorBar[] = {0.85,0.05,0,0.65};
        x = 0.476852 * safezoneW + safezoneX;
    };
*/
    class Life_RscProgress_HUDWater: LIFE_RscProgress_HUDCommon {
        idc = 2202;
        colorBar[] = {0,0.25,0.65,0.65};
        x = 0.534723 * safezoneW + safezoneX;
    };

    /* Texts */
    class Life_RscText_HUDCommon: Life_RscText {
        SizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
        style = ST_CENTER;
        y = 0.972223 * safezoneH + safezoneY;
        w = 0.0462964 * safezoneW;
        h = 0.0222222 * safezoneH;
    };

    class Life_RscText_HUDFood: Life_RscText_HUDCommon {
        idc = 1200;
        text = "$STR_HUD_Food";
        x = 0.418981 * safezoneW + safezoneX;
    };

    class Life_RscText_HUDWater: Life_RscText_HUDCommon {
        idc = 1202;
        text = "$STR_HUD_Water";
        x = 0.534723 * safezoneW + safezoneX;
    };

    class LIFE_BAR_SERVERNAME : Life_RscText
    {
        idc = IDC_LIFE_BAR_SERVERNAME;
        x = safezoneX;
        y = safezoneY + safezoneH - 0.038;
        w = safezoneW;
        h = 0.045;
        shadow = 0;
        font = "PuristaBold";
        size = 0.032;
        type = 13;
        style = 2;
        colorText[] = {1, 1, 1, 0.85};
        text="LifeNET.RPG | V3 Reworked";
        class Attributes 
        {
            align="left";
            color = "#ffffff";
            font = "PuristaBold";
        };
    };
    class LIFE_BAR_PLAYERNAME: life_RscStructuredText
    {
        idc=IDC_LIFE_BAR_PLAYERNAME;
        text="";
        style=1;
        x="0.371094 * safezoneW + safezoneX";
        y="0.96 * safezoneH + safezoneY";
        w="0.629062 * safezoneW";
        h="0.4 * safezoneH";
        sizeEx="1.2 * GUI_GRID_H";
        font = "EtelkaNarrowMediumPro";	
    };
};
