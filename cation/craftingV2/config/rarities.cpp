/*
    File: rarities.cpp
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
    Rarity configuration for crafting system.
    Info:
    * The value specifies the drop chance. 
    * The higher the number, the lower is the drop chance.
    * The lowest value must be 0 and all other rarity levels should increase step by step by 1.
    * Displaynames are defined in language.cpp
*/
class normal {
    value = 0; // you allways need a class containing "value = 0;"
    displayName = "STR_RARITY_NORMAL"; // defined in language.cpp
};

class rare {
    value = 1;
    displayName = "STR_RARITY_RARE";
};

class precious {
    value = 2;
    displayName = "STR_RARITY_PRECIOUS";
};

class epic {
    value = 3;
    displayName = "STR_RARITY_EPIC";
};