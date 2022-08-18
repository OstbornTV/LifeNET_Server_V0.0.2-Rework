/*
    File: categories.cpp
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
    Category configuration for crafting system.
*/
class weapon {
    displayName = "STR_WEAPON"; // defined in language.cpp
    class hgun_P07_F {
        itemsReq[] = { // required items as list {"ITEMNAME",AMOUNT}, {"ITEMNAME",AMOUNT}
            {"diamond_cut",2}
        };
        conditions = ""; // enter conditions
        minlevel = "noob"; // defined in levels.cpp: enter classname
        plan = ""; // defined in plans.cpp: enter classname
        skin = ""; // skin (defined in Config_Vehicles.hpp) - only used for vehicles
        skinSide = ""; // skinSide eg. civ, cop, reb etc. (defined in Config_Vehicles.hpp) - only used for vehicles
        vItem = false; // if is vItem
        time = 30; // time to craft item - must be positive
        nickName = ""; // nickName of item: Leave blank ("") if you want to use the default display name. Translations are defined in <mission>/stringtable.xml
        ep = 1; // experience points player receives when item was crafted successfully - must be positive
    };    
    class arifle_ARX_blk_F {
        itemsReq[] = {
            {"diamond_cut",4},
            {"copper_refined",1}
        };
        conditions = "";
        minlevel = "noob";
        plan = "";
        skin = "";
        skinSide = "";
        vItem = false;
        time = 60;
        nickName = "STR_Item_SuperCrazyWeapon"; // example for overriding displayname of item. 
        ep = 2;
    };
    class SMG_01_F {
        itemsReq[] = {
            {"diamond_cut",2},
            {"copper_refined",1}
        };
        conditions = "call life_adminlevel > 0";
        minlevel = "machine";
        plan = "";
        skin = "";
        skinSide = "";
        vItem = false;
        time = 60;
        nickName = ""; 
        ep = 3;
    };
};

class uniform {
    displayName = "STR_UNIFORM";
    class U_IG_Guerilla1_1 {
        itemsReq[] = {
            {"copper_refined",1}
        };
        conditions = "";
        minlevel = "noob";
        plan = "";
        skin = "";
        skinSide = "";
        vItem = false;
        time = 60;
        nickName = "";
        ep = 1;
    };
};

class backpack {
    displayName = "STR_BACKPACK";
    class B_Carryall_oli {
        itemsReq[] = {
            {"diamond_cut",1}
        };
        conditions = "";
        minlevel = "noob";
        plan = "";
        skin = "";
        skinSide = "";
        vItem = false;
        time = 30;
        nickName = "";
        ep = 2;
    };
};

class vest {
    displayName = "STR_VEST";
    class V_Press_F {
        itemsReq[] = {
            {"copper_refined",1}
        };
        conditions = "";
        minlevel = "noob";
        plan = "";
        skin = "";
        skinSide = "";
        vItem = false;
        time = 30;
        nickName = "";
        ep = 1;
    };
};

class item {
    displayName = "STR_ITEM";
    class copper_refined {
        itemsReq[] = {
            {"iron_refined",2}
        };
        conditions = "";
        minlevel = "noob";
        plan = "copper_refined_plan";
        skin = "";
        skinSide = "";
        vItem = true;
        time = 30;
        nickName = "";
        ep = 1;
    };
    class diamond_cut {
        itemsReq[] = {
            {"copper_refined",1},
            {"iron_refined",1}
        };
        conditions = "";
        minlevel = "apprentice";
        plan = "diamond_cut_plan";
        skin = "";
        skinSide = "";
        vItem = true;
        time = 45;
        nickName = "";
        ep = 2;
    };
};

class landvehicle {
    displayName = "STR_LANDVEHICLE";
    class C_SUV_01_F {
        itemsReq[] = {
            {"copper_refined",1},
            {"diamond_cut",2}
        };
        conditions = "";
        minlevel = "noob";
        plan = "";
        skin = "Dark Red";
        skinSide = "civ";
        vItem = false;
        time = 60;
        nickName = "";
        ep = 1;
    };
};

class airvehicle {
    displayName = "STR_AIRVEHICLE";
    class C_Heli_Light_01_civil_F {
        itemsReq[] = {
            {"copper_refined",1},
            {"diamond_cut",2}
        };
        conditions = "";
        minlevel = "noob";
        plan = "";
        skin = "Civ Blue";
        skinSide = "civ";
        vItem = false;
        time = 90;
        nickName = "";
        ep = 1;
    };
};

class watervehicle {
    displayName = "STR_WATERVEHICLE";
    class C_Rubberboat {
        itemsReq[] = {
            {"copper_refined",1}
        };
        conditions = "";
        minlevel = "noob";
        plan = "";
        skin = "";
        skinSide = "";
        vItem = false;
        time = 60;
        nickName = "";
        ep = 1;
    };
};