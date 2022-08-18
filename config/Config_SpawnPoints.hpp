/*
*    Format:
*        3: STRING (Conditions) - Must return boolean :
*            String can contain any amount of conditions, aslong as the entire
*            string returns a boolean. This allows you to check any levels, licenses etc,
*            in any combination. For example:
*                "call life_coplevel && license_civ_someLicense"
*            This will also let you call any other function.
*
*/
class CfgSpawnPoints {
    
    class WL_Rosche {
        class civilian {
            class Rosche {
                displayName = "Rosche";
                spawnMarker = "civ_spawn_rosch";
                icon = "\a3\ui_f\data\map\MapControl\watertower_ca.paa";
                conditions = "";
            };
            
            class Stocken {
                displayName = "Stocken";
                spawnMarker = "civ_spawn_stock";
                icon = "\a3\ui_f\data\map\MapControl\watertower_ca.paa";
                conditions = "";
            };

            class MafiaDorf {
                displayName = "Mafia Dorf";
                spawnMarker = "mafia_dorf";
                icon = "";
                conditions = "call license_civ_reb";
            };
            /*
            class last_pos_civ {
                displayName = "letzte Position";
                spawnMarker = "lastPos_spawn";
                icon = "\a3\ui_f\data\map\MapControl\watertower_ca.paa";
                conditions = "";
            };
            */
        };

        class Cop {
            class HQRosche {
                displayName = "Polizei HQ Rosche";
                spawnMarker = "cop_spawn_rosch";
                icon = "\MarkerPack_Ultimate\icons\maker_policeman.pac";
                conditions = "";
            };

            class HZStocken {
                displayName = "Polizei HQ Stocken";
                spawnMarker = "cop_spawn_stock";
                icon = "\MarkerPack_Ultimate\icons\maker_policeman.pac";
                conditions = "";
            };

            class Gefaengnis {
                displayName = "Gefängnis";
                spawnMarker = "cop_spawn_gefang";
                icon = "\MarkerPack_Ultimate\icons\maker_wanted.pac";
                conditions = "";
            };
/*
            class last_pos_cop {
                displayName = "letzte Position";
                spawnMarker = "lastPos_spawn";
                icon = "\a3\ui_f\data\map\MapControl\watertower_ca.paa";
                conditions = "";
            };
            */
        };

        class Medic {
            class KHRosche {
                displayName = "Krankenhaus Rosche";
                spawnMarker = "med_spawn_1";
                icon = "\MarkerPack_Ultimate\icons\E_medical-team.pac";
                conditions = "";
            };

            class KHStocken {
                displayName = "Krankenhaus Stocken";
                spawnMarker = "med_spawn_2";
                icon = "\MarkerPack_Ultimate\icons\E_medical-team.pac";
                conditions = "";
            };

            class ADACLuft {
                displayName = "ADAC Luftrettungs Station";
                spawnMarker = "med_spawn_adac";
                icon = "\MarkerPack_Ultimate\icons\maker_heli.pac";
                conditions = "";
            };
/*
            class last_pos_med {
                displayName = "letzte Position";
                spawnMarker = "lastPos_spawn";
                icon = "\a3\ui_f\data\map\MapControl\hospital_ca.paa";
                conditions = "";
            };
*/            
        };

    };

};