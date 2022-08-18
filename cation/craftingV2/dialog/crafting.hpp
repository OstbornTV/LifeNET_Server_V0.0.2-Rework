/*
    File: crafting.hpp
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
    Dialog of crafting system. 
*/
class CationCraftingMenu {
   idd = 5100;
   name = "CationCraftingMenu";
   movingenable = 0;
   enablesimulation = 1;
   onload = "uiNamespace setVariable ['CationCraftingMenu',_this select 0];";
   class controlsBackground
   {
       class RscTitleBackground : Cat_RscText
       {
           colorbackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", "(profilenamespace getvariable ['GUI_BCG_RGB_A',0.7])"};
           x = 0.1 * safezoneW + safezoneX;
           y = 0.123561151079137 * safezoneH + safezoneY;
           w = 0.7 * safezoneW;
           h = 0.04 * safezoneH;
           idc = 1000;
       };
       class Background : Cat_RscText
       {
           colorbackground[] = {0, 0, 0, 0.7};
           x = 0.1 * safezoneW + safezoneX;
           y = 0.162769784172662 * safezoneH + safezoneY;
           w = 0.7 * safezoneW;
           h = 0.68873381294964 * safezoneH;
           idc = 1000;
       };
       class TitleText : Cat_RscText
       {
           sizeex = 0.060;
           colorbackground[] = {0, 0, 0, 0};
           idc = 5101;
           x = 0.0997093023255814 * safezoneW + safezoneX;
           y = 0.123456790123457 * safezoneH + safezoneY;
           w = 0.699709302325581 * safezoneW;
           h = 0.0399419026870007 * safezoneH;
           style = Cat_ST_CENTER;
       };
       class CraftingText : Cat_RscText
       {
           sizeex = 0.050;
           idc = 5102;
           colorbackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5};
           x = 0.11 * safezoneW + safezoneX;
           y = 0.182913669064748 * safezoneH + safezoneY;
           w = 0.258558042686101 * safezoneW;
           h = 0.04 * safezoneH;
           style = Cat_ST_CENTER;
       };
   };
   class controls
   {
       class LevelBar : Cat_RscProgressBar
       {
           w = 0.680515893694633 * safezoneW;
           h = 0.0410791366906475 * safezoneH;
           idc = 5103;
           x = 0.11 * safezoneW + safezoneX;
           y = 0.790382360778044 * safezoneH + safezoneY;
           colorframe[] = {0, 0, 0, 0.8};
           colorbar[] = {0,0.50,0,0.65};
       };
       class LevelBarText : Cat_RscText
       {
           sizeex = 0.050;
           w = 0.680515893694633 * safezoneW;
           h = 0.0410791366906474 * safezoneH;
           idc = 5104;
           x = 0.11 * safezoneW + safezoneX;
           y = 0.790382360778044 * safezoneH + safezoneY;
           style = Cat_ST_CENTER;
       };
       class Items : Cat_RscListBox
       {
           idc = 5105;
           text = "";
           sizeex = 0.050;
           x = 0.11 * safezoneW + safezoneX;
           y = 0.22956967759126 * safezoneH + safezoneY;
           w = 0.258558042686101 * safezoneW;
           h = 0.506294964028777 * safezoneH;
           onlbselchanged = "_this call cat_craftingV2_fnc_onItemlistChanged;";
       };
       class ComboCategory : Cat_RscCombo
       {
           sizeex = 0.050;
           x = 0.11 * safezoneW + safezoneX;
           y = 0.744537037037037 * safezoneH + safezoneY;
           w = 0.258558042686101 * safezoneW;
           h = 0.035 * safezoneH;
           idc = 5106;
           onlbselchanged = "_this call cat_craftingV2_fnc_onDropdownChanged;";
       };
       class ButtonPlans : Cat_RscButton
       {
           sizeex = 0.050;
           x = 0.646201873048907 * safezoneW + safezoneX;
           y = 0.744537037037037 * safezoneH + safezoneY;
           w = 0.144048402185224 * safezoneW;
           h = 0.035 * safezoneH;
           idc = 5107;
           colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", "(profilenamespace getvariable ['GUI_BCG_RGB_A',0.7])"};
       };
       class ButtonCraft : Cat_RscButton
       {
           sizeex = 0.050;
           x = 0.495317377731529 * safezoneW + safezoneX;
           y = 0.744537037037037 * safezoneH + safezoneY;
           w = 0.144048402185224 * safezoneW;
           h = 0.035 * safezoneH;
           idc = 5110;
           onbuttonclick = "_this spawn cat_craftingV2_fnc_onProcessButtonClicked;";
           colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", "(profilenamespace getvariable ['GUI_BCG_RGB_A',0.7])"};
       };
       class ButtonExit : Cat_RscButton
       {
           x = 0.779687159693149 * safezoneW + safezoneX;
           y = 0.123561151079137 * safezoneH + safezoneY;
           w = 0.020312840306851 * safezoneW;
           h = 0.04* safezoneH;
           idc = 5108;
           text = "x";
           onbuttonclick = "closeDialog 0;";
           colorbackgroundactive[] = {0.9,0,0,1};
           colortext[] = {1,1,1,1};
       };
       class Picture : Cat_RscPicture
       {
           idc = 5111;
           x = 0.678736632150738 * safezoneW + safezoneX;
           y = 0.2043003314664 * safezoneH + safezoneY;
           w = 0.1 * safezoneW;
           h = 0.2 * safezoneH;
       };
       class Cat_RscControlsGroup0 : Cat_RscControlsGroup
       {
           x = 0.376170655567118 * safezoneW + safezoneX;
           y = 0.183966271916654 * safezoneH + safezoneY;
           w = 0.413945623502649 * safezoneW;
           h = 0.500855805062286 * safezoneH;
           class Controls {
               class StructuredItemInfo : Cat_RscStructuredText
               {
                    idc = 5109;
                    x = 0;
                    y = 0;
                    h = 0.99 * safezoneh;
                    w = 0.304933995595673 * safezonew;
               };
           };

           class VScrollBar 
           {
                idc = 5112;
                color[] = {1,1,1,0.6};
                colorActive[] = {1,1,1,1};
                colorDisabled[] = {1,1,1,0.3};
                thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
                arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
                arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
                border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
                shadow = 0;
                scrollSpeed = 0.06;
                width = 0.021;
                height = 0;
                autoScrollEnabled = 1;
                autoScrollSpeed = -1;
                autoScrollDelay = 5;
                autoScrollRewind = 0;
           };

           class HScrollBar
           {
                color[] = {1,1,1,0.6};
                colorActive[] = {1,1,1,1};
                colorDisabled[] = {1,1,1,0.3};
                thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
                arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
                arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
                border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
                shadow = 0;
                scrollSpeed = 0.06;
                width = 0;
                height = 0.028;
                autoScrollEnabled = 1;
                autoScrollSpeed = -1;
                autoScrollDelay = 5;
                autoScrollRewind = 0;
           };
       };
       class EditAmount : Cat_RscEdit
       {
           x = 0.376170655567118 * safezoneW + safezoneX;
           y = 0.744537037037037 * safezoneH + safezoneY;
           h = 0.035 * safezoneH;
           w = 0.113536820055851 * safezoneW;
           idc = 5113;
           text = "1";
       };
       class ProgressBar : Cat_RscProgressBar
       {
           w = 0.413945623502649 * safezoneW;
           h = 0.0410791366906475 * safezoneH;
           idc = 5114;
           x = 0.376170655567118 * safezoneW + safezoneX;
           y = 0.694783597958235 * safezoneH + safezoneY;
           colorframe[] = {0, 0, 0, 0.8};
           colorbar[] = {0,0.50,0,0.65};
       };
       class ProgressBarText : Cat_RscText
       {
           sizeex = 0.050;
           w = 0.413945623502649 * safezoneW;
           h = 0.0410791366906475 * safezoneH;
           idc = 5115;
           x = 0.376170655567118 * safezoneW + safezoneX;
           y = 0.694783597958235 * safezoneH + safezoneY;
           style = Cat_ST_CENTER;
       };
   };
};