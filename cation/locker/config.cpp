/*
    File: config.cpp
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
    Config file for locker system. 
*/
#include "locker.hpp"
class Cation_Locker {

    class language {
        #include "language.cpp"
    };

    locker_size_price[] = { // upgrade price and size stages - be aware reducing size in production may cause errors
        {100,10000}, //{size,price},
        {150,15000},
        {200,20000},
        {350,100000}
    };

    DebugMode = 1; // Debugmodus (1 = create log entries | 0 = do not create log entries)

    HeadlessSupport = 0; // Enable/Disable Headless client support. Default: 1 (1 = Enabled / 0 = Disabled)

    version = 5; // version 3.1.4.8 -> 3 | 4.0 - 4.3 -> 4 | version 4.4+ -> 5
    
    weightMultiplier = 0.25; // Weight Multiplier for ArmA Items

    distanceVehicle = 20; // Distance between player and vehicle
};
