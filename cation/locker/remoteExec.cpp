/*
    File: remoteExec.cpp
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
    Remote exec config file for locker system. 
*/
class cat_locker_fnc_init {
    allowedTargets=1;
};
class cat_locker_fnc_fetchTrunk {
    allowedTargets=2;
};
class cat_locker_fnc_updateTrunk {
    allowedTargets=2;
};
class cat_locker_fnc_fetchTrunkHC {
    allowedTargets=HC_Life;
};
class cat_locker_fnc_updateTrunkHC {
    allowedTargets=HC_Life;
};