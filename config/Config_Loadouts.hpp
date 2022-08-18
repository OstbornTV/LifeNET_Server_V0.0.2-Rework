/*
    class PLAYERSIDE { // PLAYERSIDE can be: WEST (for cops), CIV (for civ/reb), GUER (for medics), EAST (for opfor)
        // NOTES:
        //     empty array means that nothing will be add on players
        //     CIV's loadout are selected randonly if he is not in jail,
        //         otherwise, for the other teams, player will get the uniform related to his level

		// Unit Loadout Array detailed information: https://community.bistudio.com/wiki/Unit_Loadout_Array
        class side_level_X : side_level_0 { // where side can be: civ, cop or med. And X is a level number of the given side
            uniformClass = "";
            backpack = "";
            linkedItems[] = {};
            weapons[] = {};
            items[] = {};
            magazines[] = {};
        };
    };
*/
class Loadouts {
    // CIV
    class CIV {
        uniform[] = {
            {"U_C_Poloshirt_blue", "!life_is_arrested"},
            {"U_C_Poloshirt_burgundy", "!life_is_arrested"},
            {"U_C_Poloshirt_stripped", "!life_is_arrested"},
            {"U_C_Poloshirt_tricolour", "!life_is_arrested"},
            {"U_C_Poloshirt_salmon", "!life_is_arrested"},
            {"U_C_Poloshirt_redwhite", "!life_is_arrested"},
            {"U_C_Commoner1_1", "!life_is_arrested"},
            {"U_C_ConstructionCoverall_Red_F", "life_is_arrested"}
        };
        headgear[] = {};
        vest[] = {};
        backpack[] = {};
        weapon[] = {};
        mags[] = {};
        items[] = {};
        linkedItems[] = {
            {"ItemMap", ""},
            {"ItemCompass", ""},
            {"ItemWatch", ""},
            {"ItemGPS", ""}
        };
    };

    // COP
    class WEST {
        uniform[] = {
            {"polizei_uniform", "call life_copLevel >= 1"}
        };
        headgear[] = {
            {"polizei_barret", "call life_copLevel >= 1"}
        };
        vest[] = {
            {"polizei_weste", "call life_copLevel >= 1"}
        };
        backpack[] = {};
        weapon[] = {
            {"hgun_P07_snds_F", "call life_copLevel >= 1"}
        };
        mags[] = {
            {"16Rnd_9x21_Mag", 6, "call life_copLevel >= 1"}
        };
        items[] = {};
        linkedItems[] = {
            {"ItemMap", "call life_copLevel >= 1"},
            {"ItemGPS", "call life_copLvel >= 1"},
            {"ItemCompass", "call life_copLevel >= 1"},
            {"ItemWatch", "call life_copLevel >= 1"}
        };
    };

    // MED
    class GUER {
        uniform[] = {
            {"medic_uniform", "call life_medicLevel >= 1"}
        };
        headgear[] = {
            {"H_Cap_red", "call life_medicLevel >= 1"}
        };
        vest[] = {};
        backpack[] = {};
        weapon[] = {};
        mags[] = {};
        items[] = {
            {"FirstAidKit", 2, "call life_medicLevel >= 1"}
        };
        linkedItems[] = {
            {"ItemMap", "call life_medicLevel >= 1"},
            {"ItemCompass", "call life_medicLevel >= 1"},
            {"ItemGPS", "call life_medicLevel >= 0"},
            {"ItemWatch", "call life_medicLevel >= 1"}
        };
    };
};
