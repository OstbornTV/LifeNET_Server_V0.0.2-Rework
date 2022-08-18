/*
    File: config.cpp
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
    Config file for management system. 
*/
#include "perm.hpp"
class Cation_Perm {

    class language {
        #include "language.cpp"
    };

    DebugMode = 1; //Debug mode (0 = off | 1 = on)

    HeadlessSupport = 0; //Enable/Disable Headless client support. Default: 1 (1 = Enabled / 0 = Disabled)
    
    version = 5; // version 4.4+ -> 4 | version 5.x -> 5

    // Min player level to change things

    // cops
    mincoplevel = 2; // access tool
    mincoplevelmoney = 3; // add money
    mincopleveladdlicense = 3; // add license
    mincoplevelremovelicense = 4; // remove license
    mincoplevelpromote = 5; // promote
    mincoplevelhire = 5; // hire
    mincopleveldegrade = 6; // degrade
    mincoplevelfire = 7; // fire

    // medics
    minmediclevel = 3; // access tool
    minmediclevelmoney = 3; // add money
    minmedicleveladdlicense = 3; // add license
    minmediclevelremovelicense = 3; // remove license
    minmediclevelpromote = 4; // promote
    minmediclevelhire = 4; // hire
    minmedicleveldegrade = 5; //degrade
    minmediclevelfire = 7; // fire

    // Max player level
    maxcoplevel = 7;
    maxmediclevel = 5;

    // open menu
    key = 35; //Key for opening the menu (https://community.bistudio.com/wiki/DIK_KeyCodes#German_keyboard)
    shift = 0; // 1 = true | 0 = false
    ctrl = 0; // 1 = true | 0 = false
    alt = 0; // 1 = true | 0 = false

    // money
    ownmoney = 1; // 1 = withdraw money from own wallet of cop/medic | 0 = give money without withdrawing it from own wallet of cop/medic
};