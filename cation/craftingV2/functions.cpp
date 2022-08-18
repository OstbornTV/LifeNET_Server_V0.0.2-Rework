/*
    File: functions.cpp
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
    Function config for crafting system. 
*/
class Cation_CraftingV2 {
    tag = "cat_craftingV2";
    class functions {
        file = "cation\craftingV2\functions";
        class add {};
        class addHC {};
        class addItemPlayer {};
        class canStoreLocker {};
        class canStorePlayer {};
        class getItems {};
        class getItemsLocker {};
        class getItemsPlayer {};
        class getLockerItemType {};
        class getText {};
        class handleInvLocker {};
        class handlePlan {};
        class handlePoints {};
        class init { postInit = 1; };
        class initDialog {};
        class initLevel {};
        class initPlans {};
        class levelCheck {};
        class onDropdownChanged {};
        class onItemListChanged {};
        class onProcessButtonClicked {};
        class processItems {};
        class query {};
        class queryHC {};
        class randomPlan {};
        class refundItems {};
        class seizeItems {};
        class showCrafting {};
        class showPlans {};
        class spawnVehicle {};
        class updateLevelBar {};
        class updatePlans {};
        class updatePlansClient {};
        class updatePlansHC {};
        class updatePoints {};
        class updatePointsHC {};
    };
};