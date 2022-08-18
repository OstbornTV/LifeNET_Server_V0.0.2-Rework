/*
    File: buyer.hpp
    Author: Julian Bauer (julian.bauer@cationstudio.com)
   
   Description:
   Buyer dialog
*/
class Cat_trade_buyer {
   idd = 9600;
   name = "Cat_trade_buyer";
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
           font = "PuristaSemiBold";
           text = "cation\trade\treaty.paa";
           x = 0.296802325581395 * safezoneW + safezoneX;
           y = 0.0314183123877917 * safezoneH + safezoneY;
           w = 0.400872093023256 * safezoneW;
           h = 0.882405745062837 * safezoneH;
           idc = -1;
       };
       class map : Cat_RscMapControl
       {
           idc = 9612;
           x = 0.499479166666667 * safezoneW + safezoneX;
           y = 0.383756732495512 * safezoneH + safezoneY;
           w = 0.183333333333333 * safezoneW;
           h = 0.261665170556553 * safezoneH;
       };       
       class picture : Life_RscPicture
       {
           shadow = 0;
           type = 0;
           style = 48;
           sizeex = 0.023;
           colorbackground[] = {};
           colortext[] = {};
           text = "";
           idc = 9623;
           x = 0.499479166666667 * safezoneW + safezoneX;
           y = 0.383756732495512 * safezoneH + safezoneY;
           w = 0.183333333333333 * safezoneW;
           h = 0.261665170556553 * safezoneH;
       };
       class logo : Cat_RscPicture
       {
           idc = 9625;
           x = 0.582943317732709 * safezoneW + safezoneX;
           y = 0.0678571428571429 * safezoneH + safezoneY;
           w = 0.093083723348934 * safezoneW;
           h = 0.15 * safezoneH;
           text="\LifeNET_Skins\LifeNET.paa";
       };
   };
   class controls
   {
       class vendor : Life_RscText
       {
           x = 0.313275193798449 * safezoneW + safezoneX;
           y = 0.154234078530325 * safezoneH + safezoneY;
           h = 0.0360711279328709 * safezoneH;
           w = 0.104941860465116 * safezoneW;
           idc = 9604;
           colorText[] = {0.235,0.282,0.345,1};
           shadow = 0;
           sizeex = 0.05;
           font = "PuristaSemiBold";
       };
       class placeAndDate : Life_RscText
       {
           x = 0.313275193798449 * safezoneW + safezoneX;
           y = 0.761867145421903 * safezoneH + safezoneY;
           h = 0.035 * safezoneH;
           w = 0.369537306201551 * safezoneW;
           idc = 9619;
           colorText[] = {0.235,0.282,0.345,1};
           shadow = 0;
           sizeex = 0.05;
           font = "PuristaSemiBold";
       };
       class nameBuyer : Life_RscText
       {
           x = 0.503252180232558 * safezoneW + safezoneX;
           y = 0.846042120551925 * safezoneH + safezoneY;
           h = 0.0239371099194383 * safezoneH;
           w = 0.177997819767442 * safezoneW;
           idc = 9622;
           colorText[] = {0.235,0.282,0.345,1};
           shadow = 0;
           sizeex = 0.03;
           font = "PuristaSemiBold";
       };
       class buyer : Life_RscText
       {
           x = 0.313275193798449 * safezoneW + safezoneX;
           y = 0.116560564239206 * safezoneH + safezoneY;
           h = 0.0342473352221948 * safezoneH;
           w = 0.104941860465116 * safezoneW;
           idc = 9602;
           colorText[] = {0.235,0.282,0.345,1};
           shadow = 0;
           sizeex = 0.05;
           font = "PuristaSemiBold";
       };
       class price : Life_RscText
       {
           x = 0.313275193798449 * safezoneW + safezoneX;
           y = 0.685201117617072 * safezoneH + safezoneY;
           h = 0.0347270690974702 * safezoneH;
           w = 0.104941860465116 * safezoneW;
           idc = 9615;
           colorText[] = {0.235,0.282,0.345,1};
           shadow = 0;
           sizeex = 0.05;
           font = "PuristaSemiBold";
       };
       class signed : Life_RscText
       {
           x = 0.313275193798449 * safezoneW + safezoneX;
           y = 0.807395654339653 * safezoneH + safezoneY;
           w = 0.177870639534884 * safezoneW;
           h = 0.035 * safezoneH;
           idc = 9624;
           colorText[] = {0.235,0.282,0.345,1};
           shadow = 0;
           sizeex = 0.05;
           font = "LucidaConsoleB";
       };
       class sign : Cat_RscButton
       {
           onButtonClick = "[] call cat_trade_fnc_signBuyer;";
           x = 0.503252180232558 * safezoneW + safezoneX;
           y = 0.807395654339653 * safezoneH + safezoneY;
           w = 0.177870639534884 * safezoneW;
           h = 0.035 * safezoneH;
           idc = 9620;
           sizeex = 0.05;
           colorText[] = {0.235,0.282,0.345,1};
           colorBackground[] = {0,0,0,0};      
           colorBackgroundDisabled[]  = {0,0,0,0};
           colorBackgroundActive[] = {0.902,0.902,0.902,1};
           shadow = 0;
           font = "PuristaSemiBold";
       };
       class treaty : Life_RscTitle
       {
           idc = 9601;
           x = 0.313275193798449 * safezoneW + safezoneX;
           y = 0.0577159515977412 * safezoneH + safezoneY;
           w = 0.369016472868217 * safezoneW;
           h = 0.0562876390665317 * safezoneH;
           colorText[] = {0.235,0.282,0.345,1};
           sizeex = 0.1;
           style = ST_TITLE;
           shadow = 0;
           font = "PuristaSemiBold";
       };
       class buyerText : Life_RscText
       {
           x = 0.420571763799384 * safezoneW + safezoneX;
           y = 0.116560564239206 * safezoneH + safezoneY;
           h = 0.0342473352221948 * safezoneH;
           w = 0.262240736200616 * safezoneW;
           idc = 9603;
           colorText[] = {0.235,0.282,0.345,1};
           shadow = 0;
           sizeex = 0.05;
           font = "PuristaSemiBold";
       };
       class vendorText : Life_RscText
       {
           x = 0.420571763799384 * safezoneW + safezoneX;
           y = 0.154234078530325 * safezoneH + safezoneY;
           h = 0.0360711279328709 * safezoneH;
           w = 0.262240736200616 * safezoneW;
           idc = 9605;
           colorText[] = {0.235,0.282,0.345,1};
           shadow = 0;
           sizeex = 0.05;
           font = "PuristaSemiBold";
       };
       class checkbox : Cat_RscCheckBox
       {
           idc = 9617;
           x = 0.313275193798449 * safezoneW + safezoneX;
           y = 0.723326762972173 * safezoneH + safezoneY;
           w = 0.0143410852713185 * safezoneW;
           h = 0.0352010646759422 * safezoneH;
           color[] = {0.235,0.282,0.345,1};
           colorfocused[] = {0.235,0.282,0.345,1};
           colorhover[] = {0.235,0.282,0.345,1};
           colorpressed[] = {0.235,0.282,0.345,1};
           colordisabled[] = {0.235,0.282,0.345,1};
           sizeex = 0.05;
           font = "PuristaSemiBold";
       };
       class accept : Life_RscText
       {
           x = 0.329166666666667 * safezoneW + safezoneX;
           y = 0.723326762972173 * safezoneH + safezoneY;
           h = 0.0352010646759422 * safezoneH;
           w = 0.353645833333333 * safezoneW;
           idc = 9618;
           colorText[] = {0.235,0.282,0.345,1};
           shadow = 0;
           sizeex = 0.05;
           font = "PuristaSemiBold";
       };
       class priceNumber : Life_RscText
       {
           x = 0.420571763799384 * safezoneW + safezoneX;
           y = 0.685201117617072 * safezoneH + safezoneY;
           h = 0.035 * safezoneH;
           w = 0.227604166666667 * safezoneW;
           idc = 9616;
           colorText[] = {0.235,0.282,0.345,1};
           shadow = 0;
           sizeex = 0.05;
           font = "PuristaSemiBold";
       };
       class nameVendor : Life_RscText
       {
           x = 0.313275193798449 * safezoneW + safezoneX;
           y = 0.846042120551925 * safezoneH + safezoneY;
           h = 0.0239371099194383 * safezoneH;
           w = 0.176828972868217 * safezoneW;
           idc = 9621;
           colorText[] = {0.235,0.282,0.345,1};
           font = "PuristaSemiBold";
           shadow = 0;
           sizeex = 0.03;
       };
       class details : Cat_RscStructuredText
       {
           idc = 9611;
           x = 0.313275193798449 * safezoneW + safezoneX;
           y = 0.382858259898926 * safezoneH + safezoneY;
           h = 0.261665170556553 * safezoneH;
           w = 0.184641472868218 * safezoneW;
           class Attributes {
               color = "#3C4858";
               font = "PuristaSemiBold";
               shadow = 0;
               size = 1.2;
           };
       };
       class type : Life_RscText
       {
           x = 0.313275193798449 * safezoneW + safezoneX;
           y = 0.193895870736086 * safezoneH + safezoneY;
           h = 0.035 * safezoneH;
           w = 0.369537306201551 * safezoneW;
           colorText[] = {0.235,0.282,0.345,1};
           shadow = 0;
           font = "PuristaSemiBold";
           idc = 9606;
           sizeex = 0.05;
       };
       class typeName : Life_RscText
       {
           x = 0.313275193798449 * safezoneW + safezoneX;
           y = 0.231346499102334 * safezoneH + safezoneY;
           w = 0.370058139534884 * safezoneW;
           h = 0.035 * safezoneH;
           idc = 9607;
           colorText[] = {0.235,0.282,0.345,1};
           shadow = 0;
           sizeex = 0.05;
           font = "PuristaSemiBold";
       };
       class item : Life_RscText
       {
           x = 0.313275193798449 * safezoneW + safezoneX;
           y = 0.269946140035907 * safezoneH + safezoneY;
           h = 0.035 * safezoneH;
           w = 0.369537306201551 * safezoneW;
           idc = 9608;
           colorText[] = {0.235,0.282,0.345,1};
           shadow = 0;
           sizeex = 0.05;
           font = "PuristaSemiBold";
       };
       class itemName : Cat_RscStructuredText
       {
           x = 0.313275193798449 * safezoneW + safezoneX;
           y = 0.307648114901256 * safezoneH + safezoneY;
           w = 0.370058139534884 * safezoneW;
           h = 0.035 * safezoneH;
           idc = 9609;
           class Attributes {
               color = "#3C4858";
               font = "PuristaSemiBold";
               shadow = 0;
               size = 1.2;
           };
       };
       class detailsHeader : Life_RscText
       {
           x = 0.313275193798449 * safezoneW + safezoneX;
           y = 0.345350089766606 * safezoneH + safezoneY;
           h = 0.035 * safezoneH;
           w = 0.369537306201551 * safezoneW;
           idc = 9610;
           colorText[] = {0.235,0.282,0.345,1};
           shadow = 0;
           sizeex = 0.05;
           font = "PuristaSemiBold";
       };
       class amount : Life_RscText
       {
           x = 0.313275193798449 * safezoneW + safezoneX;
           y = 0.646909355936005 * safezoneH + safezoneY;
           h = 0.0347270690974702 * safezoneH;
           w = 0.104941860465116 * safezoneW;
           idc = 9613;
           colorText[] = {0.235,0.282,0.345,1};
           shadow = 0;
           sizeex = 0.05;
           font = "PuristaSemiBold";
       };
       class amountNumber : Life_RscText
       {
           x = 0.420571763799384 * safezoneW + safezoneX;
           y = 0.646909355936005 * safezoneH + safezoneY;
           h = 0.0347270690974702 * safezoneH;
           w = 0.227604166666667 * safezoneW;
           idc = 9614;
           colorText[] = {0.235,0.282,0.345,1};
           shadow = 0;
           sizeex = 0.05;
           font = "PuristaSemiBold";
       };
   };
};