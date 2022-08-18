class CfgGather {
    class Resources {
        class apple {
            amount = 2;
            zones[] = {"apple_1", "apple_2"};
            item = "";
            gathered[] = {"apple"};
            zoneSize = 30;
        };

        class peach {
            amount = 5;
            zones[] = {"peaches_1", "peaches_2"};
            item = "";
            gathered[] = {"peach"};
            zoneSize = 30;
        };

        class heroin_unprocessed {
            amount = 3;
            zones[] = {"heroin_1"};
            item = "";
            gathered[] = {"heroin_unprocessed"};
            zoneSize = 30;
        };

        class cocaine_unprocessed {
            amount = 3;
            zones[] = {"cocaine_1"};
            item = "";
            gathered[] = {"cocaine_unprocessed"};
            zoneSize = 30;
        };

        class cannabis {
            amount = 3;
            zones[] = {"weed_1"};
            item = "";
            gathered[] = {"cannabis"};
            zoneSize = 30;
        };
 // neue routen //
        class kartoffeln {
            amount = 2;
            zones[] = {"kartoffel"};
            item = "";
            gathered[] = {"Kartoffeln"};
            zoneSize = 20;
        };

        class zucker {
            amount = 1;
            zones[] = {"zucker_rube"};
            gathered[] = {"zucker_rube"};
            item = "schaufel";
            zoneSize = 20;
        };
 // Sammel objekte //
        class kautschuck {
            amount = 1;
            zone[] = {"kautschuck"};
            item = "";
            gathered[] = {"Kautschuck"};
            zoneSize = 30;
        };

        class getreide {
            amount = 1;
            zone[] = {"getreide_field"};
            item = "";
            gathered[] = {"Getreide"};
            zoneSize = 30;
        };

        class holz {
            amount = 2;
            zone[] = {"holzsammel"};
            item = "axt";
            gathered[] = {"Holz"};
            zoneSize = 10;
        };

        class oil {
            amount = 2;
            zones[] = {"oil_field"};
            item = "";
            gathered[] = {"oil"};
            zoneSize = 30;
        };

    };

/*
This block can be set using percent,if you want players to mine only one resource ,just leave it as it is.
Example:
        class copper_unrefined
    {
            amount = 2;
        zones[] = { "copper_mine" };
        item = "pickaxe";
        mined[] = { "copper_unrefined" };
This will make players mine only copper_unrefined
Now let's go deeper
Example 2:
        class copper_unrefined
    {
            amount = 2;
        zones[] = { "copper_mine" };
        item = "pickaxe";
        mined[] = { {"copper_unrefined",0,25},{"iron_unrefined",25,95},{"diamond_uncut",95,100} };
    };
    This will give :
    25(±1)% to copper_unrefined;
    70(±1)% to iron_unrefined;
    5%(±1)% to diamond_uncut;

                                                         ! Watch Out !
 If percents are used,you MUST put more than 1 resource in the mined parameter
 mined[] = { {"copper_unrefined",0,25} }; NOT OK (But the script will work)
 mined[] = { {"copper_unrefined",0,45 },{"iron_unrefined",45} };  NOT OK (The script won't work )
 mined[] = { {"copper_unrefined",0,45},{"copper_unrefined",80,100} }; NOT OK
 mined[] = { "copper_unrefined" }; OK
 mined[] = { {"copper_unrefined",0,35} , { "iron_unrefined" ,35,100 } }; OK
*/

    class Minerals {
        class copper_unrefined {
            amount = 2;
            zones[] = {"copper_mine"};
            item = "pickaxe";
            mined[] = {"copper_unrefined"};
            zoneSize = 30;
        };

        class iron_unrefined {
            amount = 2;
            zones[] = {"iron_mine"};
            item = "pickaxe";
            mined[] = {"iron_unrefined"};
            zoneSize = 30;
        };

        class salt_unrefined {
            amount = 2;
            zones[] = {"salt_mine"};
            item = "schaufel";
            gathered[] = {"salt_unrefined"};
            zoneSize = 30;
        };
// neue routen
        class sand {
            amount = 2;
            zones[] = {"sand_mine"};
            item = "schaufel";
            mined[] = {"sand"};
            zoneSize = 30;
        };
// alte routen
        class diamond_uncut {
            amount = 2;
            zones[] = {"diamond_mine"};
            item = "pickaxe";
            mined[] = {"diamond_uncut"};
            zoneSize = 30;
        };

        class rock {
            amount = 2;
            zones[] = { "rock_quarry"};
            item = "pickaxe";
            mined[] = {"rock"};
            zoneSize = 30;
        };
    };
};