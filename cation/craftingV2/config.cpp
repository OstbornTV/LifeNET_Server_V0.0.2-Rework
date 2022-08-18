/*
    File: config.cpp
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
    Master config for crafting system. 
*/
#include "dialog\master.hpp"

class Cation_CraftingV2 {

    class categories {
        #include "config\categories.cpp"
    };

    class language {
        #include "config\language.cpp"
    };

    class levels {
        #include "config\levels.cpp"
    };

    class plans {
        #include "config\plans.cpp"
    };

    class rarities {
        #include "config\rarities.cpp"
    };

    class stations {
        #include "config\stations.cpp"
    };

    version = 5; // version 4.4+ -> 5

    DebugMode = 0; // Debugmodus (1 = create log entries | 0 = do not create log entries)

    HeadlessSupport = 0; // Enable/Disable Headless client support. Default: 1 (1 = Enabled / 0 = Disabled)
    
};