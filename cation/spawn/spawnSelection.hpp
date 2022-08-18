/*
    File: spawnSelection.hpp
    Author: Bryan Tonic Boardwine
    Modified: Julian Bauer (julian.bauer@cationstudio.com)
    
    Description:
    Dialog for spawn menu.
*/
class cat_spawn_selection {
   idd = 38500;
   name = "cat_spawn_selection";
   movingenable = false;
   enablesimulation = true;
   class controlsBackground
   {
       class TitleBackground : Cat_RscText
       {
           colorbackground[] = {0.294117647058824,0.286274509803922,0.286274509803922,0.8};
           x = 0.00319767441860465 * safezoneW + safezoneX;
           y = 0.594771241830065 * safezoneH + safezoneY;
           h = 0.393246187363834 * safezoneH;
           w = 0.143313953488372 * safezoneW;
           idc = 1000;
       };
       class MapBackground : Cat_RscText
       {
           colorbackground[] = {0.294117647058824,0.286274509803922,0.286274509803922,0.8};
           x = 0.769028871391076 * safezoneW + safezoneX;
           y = 0.59840232389252 * safezoneH + safezoneY;
           h = 0.393246187363834 * safezoneH;
           w = 0.228064151864738 * safezoneW;
           idc = 1000;
       };
       class Title : Cat_RscText
       {
           text = "$STR_Spawn_Title";
           x = 0.00685666279069768 * safezoneW + safezoneX;
           y = 0.605319898329702 * safezoneH + safezoneY;
           h = 0.037 * safezoneH;
           w = 0.135585197674419 * safezoneW;
           idc = 1000;
       };
       class SpawnPointTitle : Cat_RscText
       {
           idc = 38501;
           x = 0.772703412073491 * safezoneW + safezoneX;
           y = 0.610403413217139 * safezoneH + safezoneY;
           h = 0.037 * safezoneH;
           w = 0.220961279786974 * safezoneW;
       };
       class MapView : Cat_RscMapControl
       {
           idc = 38502;
           x = 0.773228346456693 * safezoneW + safezoneX;
           y = 0.654320987654321 * safezoneH + safezoneY;
           w = 0.21979490935726 * safezoneW;
           h = 0.328976034858388 * safezoneH;
       };
   };
   class controls
   {
       class spawnButton : Cat_RscButton
       {
           text = "$STR_Spawn_Spawn";
           x = 0.00685666279069768 * safezoneW + safezoneX;
           y = 0.94117631372549 * safezoneH + safezoneY;
           w = 0.135585197674419 * safezoneW;
           h = 0.039216 * safezoneH;
           idc = -1;
           onbuttonclick = "spawn_camera cameraEffect [""terminate"",""back""]; camDestroy spawn_camera; [] spawn life_fnc_spawnConfirm;";
       };
       class SpawnPointList : Cat_RscListBox
       {
           x = 0.00685666279069768 * safezoneW + safezoneX;
           y = 0.654320987654321 * safezoneH + safezoneY;
           w = 0.135585197674419 * safezoneW;
           h = 0.27563543936093 * safezoneH;
           idc = 38510;
           rowheight = 0.050;
           onlbselchanged = "_this call cat_spawn_fnc_spawnPointSelected;";
       };
   };
};
