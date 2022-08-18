/*
    File: levels.cpp
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
    Level configuration for crafting system.
*/
class noob {
    value = 0; // you allways need a class containing "value = 0;" in combination with "minPoints = 0;" !
    // iterate value every level
    displayName = "STR_LEVEL_NOOB"; // defined in language.cpp
    minPoints = 0; // lowest point amount - no lower number possible
    // you allways need exactly one class containing "maxPoints = 0;" !
    maxPoints = 5; // maxPoints must be equal minPoints of next level
};

class apprentice {
    value = 1;
    displayName = "STR_LEVEL_APPRENTICE";
    minPoints = 5;
    maxPoints = 10;
};

class craftsman {
    value = 2;
    displayName = "STR_LEVEL_CRAFTSMAN";
    minPoints = 10;
    maxPoints = 50;
};

class master {
    value = 3;
    displayName = "STR_LEVEL_MASTER";
    minPoints = 50;
    maxPoints = 150;
};

class machine {
    value = 4;
    displayName = "STR_LEVEL_MACHINE";
    minPoints = 150;
    maxPoints = 500;
};

class factory {
    value = 5;
    displayName = "STR_LEVEL_FACTORY";
    minPoints = 500;
    maxPoints = 999999; // highist point amount - no bigger number possible
    // you allways need exactly one class containing "maxPoints = 999999;" !
};