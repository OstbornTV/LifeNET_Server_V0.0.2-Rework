class CarShops {
    /*
    *    ARRAY FORMAT:
    *        0: STRING (Classname)
    *        1: STRING (Condition)
    *    FORMAT:
    *        STRING (Conditions) - Must return boolean :
    *            String can contain any amount of conditions, aslong as the entire
    *            string returns a boolean. This allows you to check any levels, licenses etc,
    *            in any combination. For example:
    *                "call life_coplevel && license_civ_someLicense"
    *            This will also let you call any other function.
    *
    *   BLUFOR Vehicle classnames can be found here: https://community.bistudio.com/wiki/Arma_3_CfgVehicles_WEST
    *   OPFOR Vehicle classnames can be found here: https://community.bistudio.com/wiki/Arma_3_CfgVehicles_EAST
    *   Independent Vehicle classnames can be found here: https://community.bistudio.com/wiki/Arma_3_CfgVehicles_GUER
    *   Civilian Vehicle classnames can be found here: https://community.bistudio.com/wiki/Arma_3_CfgVehicles_CIV
    */
    class civ_car_rosch {
        side = "civ";
        conditions = "";
        vehicles[] = {
            { "chBora", "" },
            { "Caddych", "" },
            { "chGolfV", "" },
            { "passatb6_civch", "" }
        };
    };

    class civ_car_stock {
        side = "civ";
        conditions = "";
        vehicles[] = {
            { "cmax_civ", "" },
            { "chfiesta", "" },
            { "focussw1998_civd", "" },
            { "ranger17ch", "" },
            { "kangool2_civ", "" },
            { "Trafic3civ", "" },
            { "chR21_H", "" },
            { "Scenic3_civ", "" },
            { "chEspacel", "" },
            { "chEspacelll", "" },
            { "Clioch_civ", "" },
            { "chmegane_4_estate_civ", "" },
            { "chtwingol_civ", "" },
            { "chtwingoll_civ", "" },
            { "Twizych", "" }
        };
    };

    class civ_car_oetzen {
        side = "civ";
        conditions = "";
        vehicles[] = {
            { "ch208", "" },
            { "chGrand_Cherokee", "" },
            { "chdefender_civ", "" },
            { "chrr_svr", "" }
        };
    };

    class civ_motorad {
        side = "civ";
        conditions = "";
        vehicles[] = {
            { "1150RT_ch", "" },
            { "S1000RR_2013_ch", "" }
        };
    };

    class civ_sport {
        side = "civ";
        conditions = "";
        vehicles[] = {
            { "chfcrsciv", "" },
            { "chTT_2", "" },
            { "chClass_A", "" },
            { "ch911_04", "" },
            { "chCayenne", "" },
            { "ch93TurboX", "" },
            { "subaruch_civ", "" }
        };
    };

    class civ_truck_molzen {
        side = "civ";
        conditions = "";
        vehicles[] = {
            { "midlum_p2", "" },
            { "midlum", "" },
            { "Renault_Range_T", "" },
            { "chciternvol_bp", "" }
        };
    };

    class civ_truck_klein {
        side = "civ";
        conditions = "";
        vehicles[] = { 
            { "Trafic2_civ", "" },
            { "Renault_Master_civ", "" },
            { "Mer_Vito_civ", "" },
            { "ch_sprinter_civ", "" },
            { "Peugeot_Boxer_civ", "" },
            { "j9ch", "" },
            { "chexpert3_civ", "" }
        };
    };

    class civ_air {
        side = "civ";
        conditions = "";
        vehicles[] = {
            { "ec135blanclu", "" }
        };
    };

    class civ_flug {
        side = "civ";
        conditions = "";
        vehicles[] = {
            { "A320_ch_LH", "" },
            { "do228_ch_ac", "" }
        };
    };

    class mafia_car {
        side = "civ";
        conditions = "";
        vehicles[] = {
            { "B_Quadbike_01_F", "" }
        };
    };

    class mafia_air {
        side = "civ";
        conditions = "";
        vehicles[] = { };
    };

    class med_shop {
        side = "med";
        conditions = "";
        vehicles[] = {
            { "C_Offroad_01_F", "" }
        };
    };

    class med_air_hs {
        side = "med";
        conditions = "";
        vehicles[] = {
            { "ec135adlu", "" },
            { "brancardlu", "" }
        };
    };

    class cop_car {
        side = "cop";
        conditions = "";
        vehicles[] = {
            { "C_Offroad_01_F", "" }
        };
    };

    class cop_air {
        side = "cop";
        conditions = "call life_coplevel >= 2";
        vehicles[] = {
            { "ec135grislu", "" }
        };
    };
};

class LifeCfgVehicles {
    /*
    *    Vehicle Configs (Contains textures and other stuff)
    *
    *    "price" is the price before any multipliers set in Master_Config are applied.
    *
    *    Default Multiplier Values & Calculations:
    *       Civilian [Purchase, Sell]: [1.0, 0.5]
    *       Cop [Purchase, Sell]: [0.5, 0.5]
    *       Medic [Purchase, Sell]: [0.75, 0.5]
    *       ChopShop: Payout = price * 0.25
    *       GarageSell: Payout = price * [0.5, 0.5, 0.5, -1]
    *       Cop Impound: Payout = price * 0.1
    *       Pull Vehicle from Garage: Cost = price * [1, 0.5, 0.75, -1] * [0.5, 0.5, 0.5, -1]
    *           -- Pull Vehicle & GarageSell Array Explanation = [civ,cop,medic,east]
    *
    *       1: STRING (Condition)
    *    Textures config follows { Texture Name, side, {texture(s)path}, Condition}
    *    Texture(s)path follows this format:
    *    INDEX 0: Texture Layer 0
    *    INDEX 1: Texture Layer 1
    *    INDEX 2: Texture Layer 2
    *    etc etc etc
    *
    */

    class Default {
        vItemSpace = -1;
        conditions = "";
        price = -1;
        textures[] = { };
        storeLiquid = false;
    };
// Charlico89mods car
    class cmax_civ {
        vItemSpace = 75;
        conditions = "license_civ_driver || {!(playerSide isEqualTo civilian)}";
        price = 17500;
        textures[] = { };
        storeLiquid = false;
    };

    class chtt_2 { // sportwagen
        vItemSpace = 50;
        conditions = "license_civ_driver || {!(playerSide isEqualTo civilian)}";
        price = 26000;
        textures[] = { };
        storeLiquid = false;
    };

    class renault_Master_civ { // klein LKW
        vItemSpace = 65;
        conditions = "license_civ_klein_lkw || {!(playerSide isEqualTo civilian)}";
        textures[] = { };
        storeLiquid = false;
    };

    class chfiesta {
        vItemSpace = 75;
        conditions = "license_civ_driver || {!(playerSide isEqualTo civilian)}";
        price = 13450;
        textures[] = { };
        storeLiquid = false;
    };

    class chfcrsciv {
        vItemSpace = 75;
        conditions = "license_civ_driver || {!(playerSide isEqualTo civilian)}";
        price = 21000;
        textures[] = { };
        storeLiquid = false;
    };

    class focussw1998_civd {
        vItemSpace = 85;
        conditions = "license_civ_driver || {!(playerSide isEqualTo civilian)}";
        price = 15000;
        textures[] = { };
        storeLiquid = false;
    };

    class ranger17ch {
        vItemSpace = 100;
        conditions = "license_civ_driver || {!(playerSide isEqualTo civilian)}";
        price = 33500;
        textures[] = { };
        storeLiquid = false;
    };

    class chgrand_cherokee {
        vItemSpace = 95;
        conditions = "license_civ_driver || {!(playerSide isEqualTo civilian)}";
        price = 62000;
        textures[] = { };
        storeLiquid = false;
    };

    class x3ch {
        vItemSpace = 85 ;
        conditions = "license_civ_driver || {!(playerSide isEqualTo civilian)}";
        price = 46000;
        textures[] = { };
        storeLiquid = false;
    };

    class cctt_2 {
        vItemSpace = 50;
        conditions = "license_civ_driver || {!(playerSide isEqualTo civilian)}";
        price = 26000;
        textures[] = { };
        storeLiquid = false;
    };

    class chdefender_civ {
        vItemSpace = 125;
        conditions = "license_civ_driver || {!(playerSide isEqualTo civilian)}";
        price = 50000;
        textures[] = { };
        storeLiquid = false;
    };

    class chrr_svr {
        vItemSpace = 80;
        conditions = "license_civ_driver || {!(playerSide isEqualTo civilian)}";
        price = 21000;
        textures[] = { };
        storeLiquid = false;
    };

    class chclass_A {
        vItemSpace = 60;
        conditions = "license_civ_driver || {!(playerSide isEqualTo civilian)}";
        price =  17500;
        textures[] = { };
        storeLiquid = false;
    };

    class mer_vito_civ { //klein LKW
        vItemSpace = 175;
        conditions = "license_civ_klein_lkw || {!(playerSide isEqualTo civilian)}";
        price = 35000;
        textures[] = { };
        storeLiquid = false;
    };

    class ch_sprinter_civ { //klein LKW
        vItemSpace = 250;
        conditions = "license_civ_klein_lkw || {!(playerSide isEqualTo civilian)}";
        price = 40000;
        textures[] = { };
        storeLiquid = false;
    };

    class ch208 {
        vItemSpace = 60;
        conditions = "license_civ_driver || {!(playerSide isEqualTo civilian)}";
        price = 15500;
        textures[] = { };
        storeLiquid = false;
    };

    class peugeot_boxer_civ { //klein LKW
        vItemSpace = 185;
        conditions = "license_civ_klein_lkw || {!(playerSide isEqualTo civilian)}";
        price = 25000;
        textures[] = { };
        storeLiquid = false;
    };

    class j9ch { //klein LKW
        vItemSpace = -1;
        conditions = "license_civ_klein_lkw || {!(playerSide isEqualTo civilian)}";
        price = 5000;
        textures[] = { };
        storeLiquid = false;
    };

    class chexpert3_civ { //klein LKW
        vItemSpace = 75;
        conditions = "license_civ_klein_lkw || {!(playerSide isEqualTo civilian)}";
        price = 15000;
        textures[] = { };
        storeLiquid = false;
    };

    class ch911_04 { 
        vItemSpace = 35;
        conditions = "license_civ_driver || {!(playerSide isEqualTo civilian)}";
        price = 75000;
        textures[] = { };
        storeLiquid = false;
    };

    class chcayenne { 
        vItemSpace = 45;
        conditions = "license_civ_driver || {!(playerSide isEqualTo civilian)}";
        price = 70000;
        textures[] = { };
        storeLiquid = false;
    };

    class kangool2_civ {
        vItemSpace = 50;
        conditions = "license_civ_driver || {!(playerSide isEqualTo civilian)}";
        price = 7500;
        textures[] = { };
        storeLiquid = false;
    };

    class trafic3civ {
        vItemSpace = 55;
        conditions = "license_civ_driver || {!(playerSide isEqualTo civilian)}";
        price = 30000;
        textures[] = { };
        storeLiquid = false;
    };

    class trafic2_civ { // klein LKW
        vItemSpace = 55;
        conditions = "license_civ_klein_lkw || {!(playerSide isEqualTo civilian)}";
        price = 27500;
        textures[] = { };
        storeLiquid = false;
    };

    class rnault_master_civ { // klein LKW
        vItemSpace = 65;
        conditions = "license_civ_klein_lkw || {!(playerSide isEqualTo civilian)}";
        price = 40000;
        textures[] = { };
        storeLiquid = false;
    };

    class midlum_p2 { // LKW
        vItemSpace = 650;
        conditions = "license_civ_trucking || {!(playerSide isEqualTo civilian)}";
        price = 85000;
        textures[] = { };
        storeLiquid = false;
    };

    class midlum { // LKW
        vItemSpace = 675;
        conditions = "license_civ_trucking || {!(playerSide isEqualTo civilian)}";
        price = 90000;
        textures[] = { };
        storeLiquid = false;
    };

    class renault_range_t { // LKW
        vItemSpace = 750;
        conditions = "license_civ_trucking || {!(playerSide isEqualTo civilian)}";
        price = 115000;
        textures[] = { };
        storeLiquid = false;
    };

    class chr21_h { 
        vItemSpace = 30;
        conditions = "license_civ_driver || {!(playerSide isEqualTo civilian)}";
        price = 10000;
        textures[] = { };
        storeLiquid = false;
    };

    class scenic3_civ { 
        vItemSpace = 40;
        conditions = "license_civ_driver || {!(playerSide isEqualTo civilian)}";
        price = 23000;
        textures[] = { };
        storeLiquid = false;
    };

    class chEspacel { //ändern
        vItemSpace = 45;
        conditions = "license_civ_driver || {!(playerSide isEqualTo civilian)}";
        price = 2500;
        textures[] = { };
        storeLiquid = false;
    };

    class chEspacelll { //ändern
        vItemSpace = 50;
        conditions = "license_civ_driver || {!(playerSide isEqualTo civilian)}";
        price = 4500;
        textures[] = { };
        storeLiquid = false;
    };

    class chlioch_civ { 
        vItemSpace = 35;
        conditions = "license_civ_driver || {!(playerSide isEqualTo civilian)}";
        price = 1500;
        textures[] = { };
        storeLiquid = false;
    };

    class chmegane_4_estate_civ { 
        vItemSpace = 45;
        conditions = "license_civ_driver || {!(playerSide isEqualTo civilian)}";
        price = 20000;
        textures[] = { };
        storeLiquid = false;
    };

    class megane_civ { 
        vItemSpace = 35;
        conditions = "license_civ_driver || {!(playerSide isEqualTo civilian)}";
        price = 15000;
        textures[] = { };
        storeLiquid = false;
    };

    class chtwingol_civ { //ändern
        vItemSpace = 30;
        conditions = "license_civ_driver || {!(playerSide isEqualTo civilian)}";
        price = 2000;
        textures[] = { };
        storeLiquid = false;
    };

    class chtwingoll_civ { //ändern
        vItemSpace = 40;
        conditions = "license_civ_driver || {!(playerSide isEqualTo civilian)}";
        price = 3500;
        textures[] = { };
        storeLiquid = false;
    };

    class twizych { 
        vItemSpace = 10;
        conditions = "license_civ_driver || {!(playerSide isEqualTo civilian)}";
        price = 500;
        textures[] = { };
        storeLiquid = false;
    };

    class ch93turboX { // sportwagen
        vItemSpace = 45;
        conditions = "license_civ_driver || {!(playerSide isEqualTo civilian)}";
        price = 25000;
        textures[] = { };
        storeLiquid = false;
    };

    class subaruch_civ { 
        vItemSpace = 50;
        conditions = "license_civ_driver || {!(playerSide isEqualTo civilian)}";
        price = 45000;
        textures[] = { };
        storeLiquid = false;
    };

    class 1150rt_ch { //motorad
        vItemSpace = 15;
        conditions = "license_civ_driver || {!(playerSide isEqualTo civilian)}";
        price = 4500;
        textures[] = { };
        storeLiquid = false;
    };

    class s1000rr_2013_ch { //motorad
        vItemSpace = 15;
        conditions = "license_civ_driver || {!(playerSide isEqualTo civilian)}";
        price = 5000;
        textures[] = { };
        storeLiquid = false;
    };

    class chbora { 
        vItemSpace = 40;
        conditions = "license_civ_driver || {!(playerSide isEqualTo civilian)}";
        price = 3500;
        textures[] = { };
        storeLiquid = false;
    };

    class caddych { 
        vItemSpace = 50;
        conditions = "license_civ_driver || {!(playerSide isEqualTo civilian)}";
        price = 19000;
        textures[] = { };
        storeLiquid = false;
    };

    class chgolfV { 
        vItemSpace = 40;
        conditions = "license_civ_driver || {!(playerSide isEqualTo civilian)}";
        price = 22500;
        textures[] = { };
        storeLiquid = false;
    };

    class passatb6_civch { 
        vItemSpace = 45;
        conditions = "license_civ_driver || {!(playerSide isEqualTo civilian)}";
        price = 12500;
        textures[] = { };
        storeLiquid = false;
    };

    class chciternvol_bp {
        vItemSpace = 750;
        conditions = "license_civ_trucking || {!(playerSide isEqualTo civilian)}";
        price = 130000;
        textures[] = { };
        storeLiquid = true;
    };

    // Cop fahrzeuge
/*
    class Default { 
        vItemSpace = -1;
        conditions = "license_cop_driver || {!(playerSide isEqualTo west)}";
        price = -1;
        textures[] = { };
        storeLiquid = false;
    };

    class Default { 
        vItemSpace = -1;
        conditions = "license_cop_driver || {!(playerSide isEqualTo west)}";
        price = -1;
        textures[] = { };
        storeLiquid = false;
    };

    class Default { 
        vItemSpace = -1;
        conditions = "license_cop_driver || {!(playerSide isEqualTo west)}";
        price = -1;
        textures[] = { };
        storeLiquid = false;
    };

    class Default { 
        vItemSpace = -1;
        conditions = "license_cop_driver || {!(playerSide isEqualTo west)}";
        price = -1;
        textures[] = { };
        storeLiquid = false;
    };

    class Default { 
        vItemSpace = -1;
        conditions = "license_cop_driver || {!(playerSide isEqualTo west)}";
        price = -1;
        textures[] = { };
        storeLiquid = false;
    };
*/ 
    // Eurocopter
    class ec135blanclu { // weiß
        vItemSpace = 75;
        conditions = "license_civ_pilot || {!(playerSide isEqualTo civilian)}";
        price = 150000;
        textures[] = { }; //grün, rosa, blau, grau
    };

    class ec135adlu {
        vItemSpace = 15;
        conditions = "license_med_mAir || {!(playerSide isEqualTo Independent)}";
        price = 10;
        textures[] = {};
    };

    class brancardlu {
        vItemSpace = 0;
        conditions = "";
        price = 10;
        textures[] = {};
    };

    class ec135grislu {
        vItemSpace = 20;
        conditions = "license_cop_cAir || {!(playerSide isEqualTo west)}";
        price = 10;
        vehicles[] = {};
    };
    //Charlico89mods
    class A320_ch_LH {
        vItemSpace = 0;
        conditions = "call life_adminlevel >= 1";
        price = 3200000;
        textures[] = {};
    };

    class do228_ch_ac {
        vItemSpace = 300;
        conditions = "license_civ_pilot || {!(playerSide isEqualTo civilian)}";
        price = 450000;
        textures[] = {};
    };

    class B_MRAP_01_hmg_F {
        vItemSpace = 100;
        conditions = "";
        price = 750000;
        textures[] = {
            { "Black", "cop", {
                "#(argb,8,8,3)color(0.05,0.05,0.05,1)",
                "#(argb,8,8,3)color(0.05,0.05,0.05,1)",
                "#(argb,8,8,3)color(0.05,0.05,0.05,1)"
            }, "" }
        };
    };

    class O_Truck_03_transport_F {
        vItemSpace = 285;
        conditions = "license_civ_trucking || {!(playerSide isEqualTo civilian)}";
        price = 200000;
        textures[] = { };
    };

    class B_G_Offroad_01_armed_F {
        vItemSpace = 65;
        conditions = "license_civ_mafia || {!(playerSide isEqualTo civilian)}";
        price = 750000;
        textures[] = { };
    };

    class O_Heli_Light_02_unarmed_F {
        vItemSpace = 210;
        conditions = "license_civ_pilot || {license_med_mAir} || {(playerSide isEqualTo west)}";
        price = 750000;
        textures[] = {
            { "Black", "cop", {
                "\a3\air_f\Heli_Light_02\Data\heli_light_02_ext_co.paa"
            }, "" },
            { "White / Blue", "civ", {
                "\a3\air_f\Heli_Light_02\Data\heli_light_02_ext_civilian_co.paa"
            }, "" },
            { "Digi Green", "civ", {
                "\a3\air_f\Heli_Light_02\Data\heli_light_02_ext_indp_co.paa"
            }, "" },
            { "Desert Digi", "reb", {
                "\a3\air_f\Heli_Light_02\Data\heli_light_02_ext_opfor_co.paa"
            }, "" },
            { "EMS White", "med", {
                "#(argb,8,8,3)color(1,1,1,0.8)"
            }, "" }
        };
    };
};
