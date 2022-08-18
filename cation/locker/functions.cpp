/*
    File: functions.cpp
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
    Function config for locker system. 
*/
class Cation_Locker {
    tag = "cat_locker";
    class functions {
        file = "cation\locker";        
        // Client 
        class canStore {};
        class getText {};
        class handleItemLocker {};
        class handleItemPlayer {};  
        class handleItemVehicle {}; 
        class index {};
        class init {};
        class initDialog {};
        class isNumber {};
        class itemWeight {};
        class query { postInit = 1; };
        class refreshDialog {};
        class storeItem {};
        class StrToArray {};
        class switchDisplayMode {};
        class switchDisplayType {};
        class takeItem {};
        class upgrade {};
        class vehicleSelected {};
        // Server
        class add {};
        class fetchTrunk {};
        class updateTrunk {};
        // HC
        class addHC {};
        class fetchTrunkHC {};
        class updateTrunkHC {};
    };
};