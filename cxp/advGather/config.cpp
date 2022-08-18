class Cxp_Config_AdvGather {
    start_button_delay = 3; // Time in seconds that the player have to wait to start filling backpack again
    cancel_button_delay = 3; // Time in seconds that the player have to wait to cancel the current task

    /*
    class Sellables { // Sellables' classes - items that don't need to be processed to get sold
        class itemName { // Class name of the virtual item
            gather_time_multiplier = 0.7; // Gather time is given by the product of the multiplier and the current total amount of items that fills the player's backpack
            sound = ""; // Sound name (from CfgSounds) that will play when a player start gathering inside the current zone
            reqItem = ""; // Required virtual item the player must have in it's inventory to start gathering
            zones[] = { // Zones (marker's names) that will let players start gathering the current item
                {"zoneName_1", 30}, // {markerName, zoneSize}: zoneSize is the radius of the current marker, and indicates how far a player can get to start the gathering process
                {"zoneName_2", 30},
                {"zoneName_3", 30},
                {"zoneName_4", 30}
            };
            traders[] = { // Traders' markers
                "itemNameTrader"
            };
        };
    };
    */
    class Sellables {
        class apple {
            gather_time_multiplier = 0.7;
            sound = "harvest";
            reqItem = "";
            zones[] = {
                {"apple_1", 30},
                {"apple_2", 30}
            };
            traders[] = {
                "supermarkt",
                "supermarkt2"
            };
        };

        class peach {
            gather_time_multiplier = 0.7;
            sound = "harvest";
            reqItem = "";
            zones[] = {
                {"peaches_1", 30},
                {"peaches_2", 30}
            };
            traders[] = {
                "supermarkt",
                "supermarkt2"
            };
        };
    };

    /*
    class Tradables { // Tradables' classes - items that must be processed to get sold
        class itemName { // Class Name of the virtual item
            gather_time_multiplier = 0.7; // Gather time is given by the product of the multiplier and the current total amount of items that fills the player's backpack
            sound = ""; // Sound name (from CfgSounds) that will play when a player start gathering inside the current zone
            reqItem = ""; // Required virtual item the player must have in it's inventory to start gathering
            zones[] = { // Zones (marker's names) that will let players start gathering the current item
                {"zoneName_1", 30}, // {markerName, zoneSize}: zoneSize is the radius of the current marker, and indicates how far a player can get to start the gathering process
                {"zoneName_2", 30},
                {"zoneName_3", 30},
                {"zoneName_4", 30}
            };
            processors[] = { // Processors' markers
                "processorMarker"
            };
            processed = "itemName_processed"; // Processed name of the current item
        };
    };
    */
    class Tradables {
        class heroin_unprocessed {
            gather_time_multiplier = 0.7;
            sound = "harvest";
            reqItem = "";
            zones[] = {
                {"heroin_1", 30}
            };
            processors[] = {
                "heroin_p"
            };
            processed = "heroin_processed";
        };

        class cocaine_unprocessed {
            gather_time_multiplier = 0.7;
            sound = "harvest";
            reqItem = "";
            zones[] = {
                {"cocaine_1", 30}
            };
            processors[] = {
                "cocaine processing"
            };
            processed = "cocaine_processed";
        };

        class cannabis {
            gather_time_multiplier = 0.7;
            sound = "harvest";
            reqItem = "";
            zones[] = {
                {"weed_1", 30}
            };
            processors[] = {
                "Weed_p_1"
            };
            processed = "marijuana";
        };

        class kartoffeln {
            gather_time_multiplier = 0.2;
            sound = "harvest";
            reqItem = "";
            zones[] = {
                {"kartoffel", 20}
            };
            processors[] = {
                "kartoffel_schnibbler"
            };
            processed = "Pommes";
        };

        class kautschuk {
            gather_time_multiplier = 0.2;
            sound = "harvest";
            reqItem = "";
            zones[] = {
                {"kautschuck", 20};
            };
            processors[] = {
                "kautschuck_verarbeiter"
            };
            processed = "Reifen";
        };
    };

    /*
    class Minerals { // Minerals' classes - items that must be processed to get sold, but you can let players mine more than one item
        class itemZoneName { // Name of zone's class
            gather_time_multiplier = 0.7; // Gather time is given by the product of the multiplier and the current total amount of items that fills the player's backpack
            sound = ""; // Sound name (from CfgSounds) that will play when a player start gathering inside the current zone
            reqItem = ""; // Required virtual item the player must have in it's inventory to start gathering
            zones[] = { // Zones (marker's names) that will let players start gathering unprocessed items from 'mined' array
                {"zoneName_1", 30}, // {markerName, zoneSize}: zoneSize is the radius of the current marker, and indicates how far a player can get to start the gathering process
                {"zoneName_2", 30},
                {"zoneName_3", 30},
                {"zoneName_4", 30}
            };
            processors[] = { // Processors' markers
                "processorMarker"
            };
            mined[] = { // Names of mined items of the current zone
                {"itemName_unprocessed", "itemName_processed"} // Name of a unprocessed item followed by it's processed version
            };
        };
    };
    */
    class Minerals {
        class copper_zone {
            gather_time_multiplier = 0.7;
            sound = "mining";
            reqItem = "pickaxe";
            zones[] = {
                {"copper_mine", 30}
            };
            processors[] = {
                "copper_mine_1"
            };
            mined[] = {
                {"copper_unrefined", "copper_refined"}
            };
        };

        class iron_zone {
            gather_time_multiplier = 0.7;
            sound = "mining";
            reqItem = "pickaxe";
            zones[] = {
                {"iron_mine", 30}
            };
            processors[] = {
                "iron_processing"
            };
            mined[] = {
                {"iron_unrefined", "iron_refined"}
            };
        };

        class salt_zone {
            gather_time_multiplier = 0.7;
            sound = "mining";
            reqItem = "pickaxe";
            zones[] = {
                {"salt_mine", 30}
            };
            processors[] = {
                "salt_processing"
            };
            mined[] = {
                {"salt_unrefined", "salt_refined"}
            };
        };

        class sand_zone {
            gather_time_multiplier = 0.7;
            sound = "mining";
            reqItem = "pickaxe";
            zones[] = {
                {"sand_mine", 30}
            };
            processors[] = {
                "sand_processing"
            };
            mined[] = {
                {"sand", "glass"}
            };
        };

        class diamond_zone {
            gather_time_multiplier = 0.7;
            sound = "mining";
            reqItem = "pickaxe";
            zones[] = {
                {"diamond_mine", 30}
            };
            processors[] = {
                "diamond_processing"
            };
            mined[] = {
                {"diamond_uncut", "diamond_cut"}
            };
        };

        class rock_zone {
            gather_time_multiplier = 0.7;
            sound = "mining";
            reqItem = "pickaxe";
            zones[] = {
                {"rock_quarry", 30}
            };
            processors[] = {
                "rock_processing"
            };
            mined[] = {
                {"rock", "cement"}
            };
        };

        class oil_zone {
            gather_time_multiplier = 0.7;
            sound = "mining";
            reqItem = "pickaxe";
            zones[] = {
                {"oil_field", 30}
            };
            processors[] = {
                "OilP"
            };
            mined[] = {
                {"oil_unprocessed", "oil_processed"}
            };
        };
    };
};
