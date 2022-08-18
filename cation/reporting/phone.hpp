/*
    File: phone.hpp
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
    unit dialog for reporting 
*/
class Cat_reporting_phone {
   idd = 9700;
   name = "Cat_reporting_phone";
   movingenable = 0;
   enablesimulation = 1;
   class controlsBackground
   {
       class background : Life_RscPicture
       {
           shadow = 0;
           type = 0;
           style = 48;
           sizeex = 0.023;
           font = "robotocondensed";
           text = "cation\reporting\phone.paa";
           colorbackground[] = {};
           colortext[] = {};
           x = 0.529765155652649 * safezoneW + safezoneX;
           y = 0.147266313932981 * safezoneH + safezoneY;
           w = 0.691739747044913 * safezoneW;
           h = 0.828042328042328 * safezoneH;
           tooltipcolortext[] = {1.1.1.1};
           tooltipcolorbox[] = {1.1.1.1};
           tooltipcolorshade[] = {0.0.0.0.65};
           idc = -1;
       };
   };
   class controls
   {
       class delete : Life_RscButtonMenu
       {
           idc = 9713;
           x = 0.911180812465866 * safezoneW + safezoneX;
           y = 0.729951082892416 * safezoneH + safezoneY;
           w = 0.0356394673675587 * safezoneW;
           h = 0.0557632028218695 * safezoneH;
           colorbackground[] = {1,1,1,0};
           colorbackgroundfocused[] = {1,1,1,0};
           colorbackground2[] = {1,1,1,0};
           color[] = {1,1,1,0};
           colorfocused[] = {1,1,1,0};
           color2[] = {1,1,1,0};
           colortext[] = {1,1,1,0};
           onbuttonclick = "[] call cat_reporting_fnc_unitDialogUpdate;";
       };
       class 1 : Life_RscButtonMenu
       {
           idc = 9701;
           x = 0.803792537001638 * safezoneW + safezoneX;
           y = 0.788696881834215 * safezoneH + safezoneY;
           w = 0.0427394127525942 * safezoneW;
           h = 0.0402272804232805 * safezoneH;
           colorbackground[] = {1,1,1,0};
           colorbackgroundfocused[] = {1,1,1,0};
           colorbackground2[] = {1,1,1,0};
           color[] = {1,1,1,0};
           colorfocused[] = {1,1,1,0};
           color2[] = {1,1,1,0};
           colortext[] = {1,1,1,0};
           tooltip = "1";
           onbuttonclick = "[""1""] call cat_reporting_fnc_unitDialogUpdate;";
       };
       class 2 : Life_RscButtonMenu
       {
           idc = 9702;
           x = 0.852469725628072 * safezoneW + safezoneX;
           y = 0.800348823633157 * safezoneH + safezoneY;
           w = 0.0427394127525942 * safezoneW;
           h = 0.032459319223986 * safezoneH;
           colorbackground[] = {1,1,1,0};
           colorbackgroundfocused[] = {1,1,1,0};
           colorbackground2[] = {1,1,1,0};
           color[] = {1,1,1,0};
           colorfocused[] = {1,1,1,0};
           color2[] = {1,1,1,0};
           colortext[] = {1,1,1,0};
           tooltip = "2";
           onbuttonclick = "[""2""] call cat_reporting_fnc_unitDialogUpdate;";
       };
       class esc : Life_RscButtonMenu
       {
           idc = 9711;
           x = 0.803792537001638 * safezoneW + safezoneX;
           y = 0.729951082892416 * safezoneH + safezoneY;
           w = 0.0356394673675587 * safezoneW;
           h = 0.0557632028218695 * safezoneH;
           colorbackground[] = {1,1,1,0};
           colorbackgroundfocused[] = {1,1,1,0};
           colorbackground2[] = {1,1,1,0};
           color[] = {1,1,1,0};
           colorfocused[] = {1,1,1,0};
           color2[] = {1,1,1,0};
           colortext[] = {1,1,1,0};
           onbuttonclick = "closeDialog 0;";
       };
       class 7 : Life_RscButtonMenu
       {
           idc = 9707;
           x = 0.803792537001638 * safezoneW + safezoneX;
           y = 0.861195384479718 * safezoneH + safezoneY;
           w = 0.0427394127525942 * safezoneW;
           h = 0.032459319223986 * safezoneH;
           colorbackground[] = {1,1,1,0};
           colorbackgroundfocused[] = {1,1,1,0};
           colorbackground2[] = {1,1,1,0};
           color[] = {1,1,1,0};
           colorfocused[] = {1,1,1,0};
           color2[] = {1,1,1,0};
           colortext[] = {1,1,1,0};
           tooltip = "7";
           onbuttonclick = "[""7""] call cat_reporting_fnc_unitDialogUpdate;";
       };
       class ok : Life_RscButtonMenu
       {
           idc = 9712;
           x = 0.843521720644457 * safezoneW + safezoneX;
           y = 0.729951082892416 * safezoneH + safezoneY;
           w = 0.0636328397050792 * safezoneW;
           h = 0.0698725502645502 * safezoneH;
           colorbackground[] = {1,1,1,0};
           colorbackgroundfocused[] = {1,1,1,0};
           colorbackground2[] = {1,1,1,0};
           color[] = {1,1,1,0};
           colorfocused[] = {1,1,1,0};
           color2[] = {1,1,1,0};
           colortext[] = {1,1,1,0};
           onbuttonclick = "[] call cat_reporting_fnc_statusChanged;";
       };
       class 9 : Life_RscButtonMenu
       {
           idc = 9709;
           x = 0.898892445453304 * safezoneW + safezoneX;
           y = 0.861195384479718 * safezoneH + safezoneY;
           w = 0.04594644040142 * safezoneW;
           h = 0.032459319223986 * safezoneH;
           colorbackground[] = {1,1,1,0};
           colorbackgroundfocused[] = {1,1,1,0};
           colorbackground2[] = {1,1,1,0};
           color[] = {1,1,1,0};
           colorfocused[] = {1,1,1,0};
           color2[] = {1,1,1,0};
           colortext[] = {1,1,1,0};
           tooltip = "9";
           onbuttonclick = "[""9""] call cat_reporting_fnc_unitDialogUpdate;";
       };
       class 0 : Life_RscButtonMenu
       {
           idc = 9710;
           x = 0.852469725628072 * safezoneW + safezoneX;
           y = 0.904405261022928 * safezoneH + safezoneY;
           w = 0.0427394127525942 * safezoneW;
           h = 0.032459319223986 * safezoneH;
           colorbackground[] = {1,1,1,0};
           colorbackgroundfocused[] = {1,1,1,0};
           colorbackground2[] = {1,1,1,0};
           color[] = {1,1,1,0};
           colorfocused[] = {1,1,1,0};
           color2[] = {1,1,1,0};
           colortext[] = {1,1,1,0};
           tooltip = "0";
           onbuttonclick = "[""0""] call cat_reporting_fnc_unitDialogUpdate;";
       };
       class 5 : Life_RscButtonMenu
       {
           idc = 9705;
           x = 0.852469725628072 * safezoneW + safezoneX;
           y = 0.836504026455026 * safezoneH + safezoneY;
           w = 0.0427394127525942 * safezoneW;
           h = 0.032459319223986 * safezoneH;
           colorbackground[] = {1,1,1,0};
           colorbackgroundfocused[] = {1,1,1,0};
           colorbackground2[] = {1,1,1,0};
           color[] = {1,1,1,0};
           colorfocused[] = {1,1,1,0};
           color2[] = {1,1,1,0};
           colortext[] = {1,1,1,0};
           tooltip = "5";
           onbuttonclick = "[""5""] call cat_reporting_fnc_unitDialogUpdate;";
       };
       class 4 : Life_RscButtonMenu
       {
           idc = 9704;
           x = 0.803792537001638 * safezoneW + safezoneX;
           y = 0.829092708994709 * safezoneH + safezoneY;
           w = 0.0427394127525942 * safezoneW;
           h = 0.032459319223986 * safezoneH;
           colorbackground[] = {1,1,1,0};
           colorbackgroundfocused[] = {1,1,1,0};
           colorbackground2[] = {1,1,1,0};
           color[] = {1,1,1,0};
           colorfocused[] = {1,1,1,0};
           color2[] = {1,1,1,0};
           colortext[] = {1,1,1,0};
           tooltip = "4";
           onbuttonclick = "[""4""] call cat_reporting_fnc_unitDialogUpdate;";
       };
       class 8 : Life_RscButtonMenu
       {
           idc = 9708;
           x = 0.852469725628072 * safezoneW + safezoneX;
           y = 0.870013726631393 * safezoneH + safezoneY;
           w = 0.0427394127525942 * safezoneW;
           h = 0.032459319223986 * safezoneH;
           colorbackground[] = {1,1,1,0};
           colorbackgroundfocused[] = {1,1,1,0};
           colorbackground2[] = {1,1,1,0};
           color[] = {1,1,1,0};
           colorfocused[] = {1,1,1,0};
           color2[] = {1,1,1,0};
           colortext[] = {1,1,1,0};
           tooltip = "8";
           onbuttonclick = "[""8""] call cat_reporting_fnc_unitDialogUpdate;";
       };
       class 6 : Life_RscButtonMenu
       {
           idc = 9706;
           x = 0.898892445453304 * safezoneW + safezoneX;
           y = 0.829092708994709 * safezoneH + safezoneY;
           w = 0.04594644040142 * safezoneW;
           h = 0.032459319223986 * safezoneH;
           colorbackground[] = {1,1,1,0};
           colorbackgroundfocused[] = {1,1,1,0};
           colorbackground2[] = {1,1,1,0};
           color[] = {1,1,1,0};
           colorfocused[] = {1,1,1,0};
           color2[] = {1,1,1,0};
           colortext[] = {1,1,1,0};
           tooltip = "6";
           onbuttonclick = "[""6""] call cat_reporting_fnc_unitDialogUpdate;";
       };
       class 3 : Life_RscButtonMenu
       {
           idc = 9703;
           x = 0.898892445453304 * safezoneW + safezoneX;
           y = 0.788696881834215 * safezoneH + safezoneY;
           w = 0.0470387396914254 * safezoneW;
           h = 0.0402272804232805 * safezoneH;
           colorbackground[] = {1,1,1,0};
           colorbackgroundfocused[] = {1,1,1,0};
           colorbackground2[] = {1,1,1,0};
           color[] = {1,1,1,0};
           colorfocused[] = {1,1,1,0};
           color2[] = {1,1,1,0};
           colortext[] = {1,1,1,0};
           tooltip = "3";
           onbuttonclick = "[""3""] call cat_reporting_fnc_unitDialogUpdate;";
       };
       class title : Life_RscStructuredText
       {
           x = 0.817039868924085 * safezoneW + safezoneX;
           y = 0.442699294532628 * safezoneH + safezoneY;
           h = 0.037 * safezoneH;
           w = 0.123429819770617 * safezoneW;
           idc = 9714;
       };
       class text : Life_RscText
       {
           x = 0.817039868924085 * safezoneW + safezoneX;
           y = 0.57497442680776 * safezoneH + safezoneY;
           h = 0.037 * safezoneH;
           w = 0.123429819770617 * safezoneW;
           idc = 9715;
       };
       class status : Life_RscText
       {
           x = 0.817039868924085 * safezoneW + safezoneX;
           y = 0.484145502645503 * safezoneH + safezoneY;
           h = 0.037 * safezoneH;
           w = 0.0868377935554342 * safezoneW;
           idc = 9716;
       };
       class own : Life_RscText
       {
           x = 0.817039868924085 * safezoneW + safezoneX;
           y = 0.526473544973545 * safezoneH + safezoneY;
           h = 0.037 * safezoneH;
           w = 0.0868377935554342 * safezoneW;
           idc = 9717;
       };
       class ownnumber : Life_RscText
       {
           x = 0.911180812465866 * safezoneW + safezoneX;
           y = 0.526473544973545 * safezoneH + safezoneY;
           h = 0.037 * safezoneH;
           w = 0.026558128003823 * safezoneW;
           idc = 9718;
       };
       class statusnumber : Life_RscText
       {
           x = 0.911180812465866 * safezoneW + safezoneX;
           y = 0.484145502645503 * safezoneH + safezoneY;
           h = 0.037 * safezoneH;
           w = 0.026558128003823 * safezoneW;
           idc = 9719;
       };
       class number : Life_RscText
       {
           x = 0.864383415517477 * safezoneW + safezoneX;
           y = 0.626120811287478 * safezoneH + safezoneY;
           h = 0.037 * safezoneH;
           w = 0.026558128003823 * safezoneW;
           idc = 9720;
       };
       class help : Life_RscButtonMenu
       {
           idc = 9721;
           x = 0.803792537001638 * safezoneW + safezoneX;
           y = 0.892993288826642 * safezoneH + safezoneY;
           w = 0.0427394127525942 * safezoneW;
           h = 0.032459319223986 * safezoneH;
           colorbackground[] = {1,1,1,0};
           colorbackgroundfocused[] = {1,1,1,0};
           colorbackground2[] = {1,1,1,0};
           color[] = {1,1,1,0};
           colorfocused[] = {1,1,1,0};
           color2[] = {1,1,1,0};
           colortext[] = {1,1,1,0};
           tooltip = ;
           onbuttonclick = "[] call cat_reporting_fnc_help;";
       };
   };
};