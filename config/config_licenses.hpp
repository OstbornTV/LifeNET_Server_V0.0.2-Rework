/*
*    class:
*        variable = variable Name
*        displayName = License Name
*        price = License Price
*        illegal = Illegal License
*        side = side indicator
*/

class LicensesShops {
    class LizenzAmt {
        name = "STR_MAR_Lizenzamt";
        side = "civ";
        conditions = "";
        items[] = {"driver", "gun", "kleinst_lkw", "trucking", "home"};
    };

    class LizenzVerarbeitung {
		name = "STR_MAR_verarbeitung";
		side = "civ";
        conditions = "";
        items[] = { "eiswuerfel", "schmerzmittel", "apfelsaft", "kirschsaft", "plastik", "kupfer", "papier", "eisen", "glas", "diamanten", "kohle", "baumwolle", "mehl", "tequila", "apfelkorn", "oil", "fish", "stahl", "zink", "messing", "met_kirsche", "met_apfel"};
	};

    class GewerbeLizenzAmt {
		name = "STR_MAR_GLA";
		side = "civ";
        conditions = "";
        items[] = { "priester", "news", "anwalt", "jagdschein", "vermieter", "buchhaltung"};
	};

	class CraftingLizenzAmt {
		name = "STR_MAR_CLA";
		side = "civ";
        conditions = "";
        items[] = { "waffenteileklein", "waffenteilemittel", "waffenteilegross", "kleidungsherstellung", "magazineherstellung", "fahrzeugherstellung", "helikopterherstellung", "ersatzteilherstellung", "fahrzeugeupgrade"};
	};

	class RebellenLizenzAmt {
		name = "STR_MAR_RLA";
		side = "civ";
        conditions = "";
        items[] = { "lsd", "moonshine_traube", "moonshine_kirsch", "cannabis", "kokain", "kokaingestreckt", "heroin", "schiesspulver", "rebel", "turtle", "schildkroetenpanzer"};
	};
};


class Licenses {
    //Civilian Licenses
    class driver {
        variable = "driver";
        displayName = $STR_License_Driver;
        price = 500;
        illegal = false;
        side = "civ";
    };

    class pilot {
        variable = "pilot";
        displayName = $STR_License_Pilot;
        price = 25000;
        illegal = false;
        side = "civ";
    };

    class trucking {
        variable = "trucking";
        displayName = $STR_License_Truck;
        price = 20000;
        illegal = false;
        side = "civ";
    };

    class gun {
        variable = "gun";
        displayName = $STR_License_Firearm;
        price = 10000;
        illegal = false;
        side = "civ";
    };

    class home {
        variable = "home";
        displayName = $STR_License_Home;
        price = 75000;
        illegal = false;
        side = "civ";
    };

    class reise {
        variable = "reisefuhrer";
        displayName = $STR_License_Reisefuehrer;
        price = 500;
        illegal = false;
        side = "civ";
    };

    class flug {
        variable = "flug";
        displayName = $STR_License_Großraum_flieger_schein;
        price = 10000;
        illegal = false;
        side = "civ";
    };

    class kleinst_lkw {
        variable = "kleinst_lkw";
        displayName = $STR_License_Kleinst_LKW_schein;
        price = 10000;
        illegal = false;
        side = "civ";
    };

    //Processing Licenses
    class oil {
        variable = "oil";
        displayName = $STR_License_Oil;
        price = 10000;
        illegal = false;
        side = "civ";
    };

    class diamond {
        variable = "diamond";
        displayName = $STR_License_Diamond;
        price = 35000;
        illegal = false;
        side = "civ";
    };

    class salt {
        variable = "salt";
        displayName = $STR_License_Salt;
        price = 12000;
        illegal = false;
        side = "civ";
    };

    class sand {
        variable = "sand";
        displayName = $STR_License_Sand;
        price = 11500;
        illegal = false;
        side = "civ";
    };

    class iron {
        variable = "iron";
        displayName = $STR_License_Iron;
        price = 9500;
        illegal = false;
        side = "civ";
    };

    class copper {
        variable = "copper";
        displayName = $STR_License_Copper;
        price = 8000;
        illegal = false;
        side = "civ";
    };

    class zement {
        variable = "zement";
        displayName = $STR_License_zementmischer;
        price = 6500;
        illegal = false;
        side = "civ";
    };

    class medmarijuana {
        variable = "medmarijuana";
        displayName = $STR_License_Medmarijuana;
        price = 15000;
        illegal = false;
        side = "civ";
    };

// Neue Lizenzen
    class breezel {
        variable = "breezel";
        displayName = $STR_License_Brezzel_Bäcker;
        price = 500;
        illegal = false;
        side = "civ";
    };

    class farbstoff_lizenz {
        variable = "farbstoff";
        displayName = $STR_License_Farbmisch_Lizenz;
        price = 1000;
        illegal = false;
        side = "civ";
    };

    class plastik_pellets {
        variable = "plastik_pellets";
        displayName = $STR_License_Plastik_Pelltes_Presser;
        price = 1000;
        illegal = false;
        side = "civ";
    };

    class muehler {
        variable = "mehl";
        displayName = $STR_License_Muehler;
        price = 1000;
        illegal = false;
        side = "civ";
    };

    class pommes {
        variable = "pommes";
        displayName = $STR_License_Kartoffel_Schnippler;
        price = 500;
        illegal = false;
        side = "civ";
    };

    class gartenstuhl {
        variable = "gartenstuhl";
        displayName = $STR_License_Gartenstuhl;
        price = 500;
        illegal = false;
        side = "civ";
    };

    class zucker {
        variable = "zucker";
        displayName = $STR_License_zucker;
        price = 11500;
        illegal = false;
        side = "civ";
	};

    class susswaren {
        variable = "susswaren";
        displayName = $STR_License_susswaren;
        price = 15500;
        illegal = false;
        side = "civ";
	};

    class holzsammel {
        variable = "holzsammel";
        displayName = $STR_License_holzsammel;
        price = "500";
        illegal = false;
        side = "civ";
    };
    
    //Illegal Licenses
    class cocaine {
        variable = "cocaine";
        displayName = $STR_License_Cocaine;
        price = 30000;
        illegal = true;
        side = "civ";
    };

    class heroin {
        variable = "heroin";
        displayName = $STR_License_Heroin;
        price = 25000;
        illegal = true;
        side = "civ";
    };

    class marijuana {
        variable = "marijuana";
        displayName = $STR_License_Marijuana;
        price = 19500;
        illegal = true;
        side = "civ";
    };

    class mafia {
        variable = "Mafia";
        displayName = $STR_License_Mafia;
        price = 75000;
        illegal = true;
        side = "civ";
    };

    class LSD {
        variable = "LSD";
        displayName = $STR_License_LSD;
        price = 15000;
        illegal = true;
        side = "civ";
    };

    //Cop Licenses (ändern Stringtabel einfürgen noch )
    class cAir 
    {
        variable = "cAir";
        displayName = $STR_License_cop_rotorflug; //STR_License_cop_rotorflug
        price = -1;
        illegal = false;
        side = "cop";
    };

    class cFahr 
    {
        variable = "cFahr";
        displayName = §STR_License_cop_fuhrer; //STR_License_cop_fuhrer
        price = -1;
        illegal = false;
        side = "cop";
    };

    class cZoll 
    {
        variable = "cZoll";
        displayName = $STR_License_zoll; //STR_License_zoll
        price = -1;
        illegal = false;
        side = "cop";
    };

    class cSEK 
    {
        variable = "cSEK";
        displayName = $STR_License_sek; //STR_License_sek
        price = -1;
        illegal = false;
        side = "cop";
    };

    class cLKW 
    {
        variable = "cLKW";
        displayName = $STR_License_cop_LKW; //STR_License_cop_LKW
        price = -1;
        illegal = false;
        side = "cop";
    };

    //Medic Licenses (ändern) Führerschein, LKW Schein, Roterflügler-Schein, Steifflügler-Schein
    class mAir 
    {
        variable = "mAir";
        displayName = $STR_License_Rotorflugler-Schein; //STR_License_Rotorflugler
        price = -1;
        illegal = false;
        side = "med"; 
    };

    class mFahr 
    {
        variable = "mFahr";
        displayName = $STR_License_Fuhrerschein; //STR_License_Fuhrerschein
        price = -1;
        illegal = false;
        side = "med";
    };

    class mLKW 
    {
        variable = "mLKW";
        displayName = $STR_License_med_LKW; //STR_License_med_LKW
        price = -1;
        illegal = false;
        side = "med";
    };

    class steilfluger {
        variable = "msteilflug";
        displayName = $STR_License_Steilflugler; //STR_License_Steilflugler
        price = -1;
        illegal = false;
        side = "med";
    };
};