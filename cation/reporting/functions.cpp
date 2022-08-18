/*
    File: functions.cpp
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
    Function config for reporting system. 
*/
class Cation_Reporting {
    tag = "cat_reporting";
    class functions {
        file = "cation\reporting";
        class createDialogControlCenter { };
        class createDialogUnit { };
        class finishStatusChange { };
        class getText { };
        class help { };
        class init { postInit=1; };
        class lbChanged { };
        class markers { };
        class setMapPosition { };
        class statusChanged { };
        class statusMessage { };
        class unitDialogUpdate { };
    };
};