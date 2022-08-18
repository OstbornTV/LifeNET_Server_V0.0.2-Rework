/*
    File: config.cpp
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
    Master config for security system. 
*/
class Cation_Alarm {

    class language {
        #include "language.cpp"
    };

    DebugMode = 1; // Debug mode (0 = off | 1 = on)
    HeadlessSupport = 0; // Enable / Disable headless client support. Default: 1 (1 = Enabled / 0 = Disabled)

    price = 100000;
};