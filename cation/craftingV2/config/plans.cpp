/*
    File: plans.cpp
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
    Plan configuration for crafting system.
*/
class copper_refined_plan { // classname
    variable = "copper_refined_plan"; // must be same as classname
    displayName = "STR_PLAN_COPPER"; // defined in <mission>/stringtable.xml
    rarity = "normal"; // defined in rarities.cpp
    icon = "cation\craftingV2\icons\normal.paa"; // path to icon
    weight = 1; // item weight - do not edit
    buyPrice = -1; // buy price - do not edit
    sellPrice = 0; // sell price - do not edit
    illegal = false; // if plan is illegal
    edible = -1; // edible - do not edit
    drinkable = -1; // drinkable - do not edit
};

class diamond_cut_plan { // classname
    variable = "diamond_cut_plan"; // must be same as classname
    displayName = "STR_PLAN_DIAMOND"; // defined in <mission>/stringtable.xml
    rarity = "rare"; // defined in rarities.cpp
    icon = "cation\craftingV2\icons\rare.paa"; // path to icon
    weight = 1; // item weight - do not edit
    buyPrice = -1; // buy price - do not edit
    sellPrice = 0; // sell price - do not edit
    illegal = false; // if plan is illegal
    edible = -1; // edible - do not edit
    drinkable = -1; // drinkable - do not edit
};