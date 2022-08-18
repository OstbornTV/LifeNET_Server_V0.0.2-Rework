/*
    File: functions.cpp
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
    Function config for management system. 
*/
class Cation_Perm {
    tag = "cat_perm";
    class functions {
        file = "cation\perm";
        class getText {};
        class handleAction {};
        class initPerm { postInit = 1; };
        class mresToArray {};
        class numberSafe {};
        class refreshPermDialog {};
        class setup {};
        class updatePermDialog {};
        class updatePlayer {};
        // Server
        class getInfos {};
        class updateRank {};
        // HC
        class getInfosHC {};
        class updateRankHC {};
    };
};