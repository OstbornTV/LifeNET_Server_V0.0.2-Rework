#define true 1
#define false 0

/*
    Master settings for various features and functionality
*/

class Life_Settings {
/* Logging and Security Settings*/

    /* Data Logging Settings */
    battlEye_friendlyLogging = true; //False [default] - Read the logs from the server.rpt. True - Read the logs from the publicVariable.log. NOTE: Due to how diag_log works it will log to both files either way and the setting is merely for beautification purposes.
    player_advancedLog = true; //False [default] - No advanced logging. True - Logs house purchase and sale, vehicle purchase, sale, and chop shopping, police arrests, and gang creations. Search for: advanced_log
    player_moneyLog = true; //False [default] - No money logging. True - Logs player bank deposits, withdraws, and transfers, gang bank deposits and withdraws, money picked up off of the ground, and player robbery. Search for: money_log
    player_deathLog = true; //False [default] - No death logging. True - Logs victim and killer, and vehicle or weapon if used, when a player dies. Search for: death_log

    /* Performance Settings */
    /* Vehicle Wrecks */
    dead_vehicles_despawn_delay = 30; //delay in seconds before despawning dead vehicles
    dead_vehicles_max_units_distance = 300; //maximum distance between wreck and nearest player before despawning (vehicle despawns anyway after specified delay!)

    /* Cleanup */
    vehicles_despawn_max_distance = 2000; //maximum distance between a vehicle and the nearest player, before server puts it back to garage


/* Database Related Settings */
    /* Player Data Saving */
    save_virtualItems = true; //Save Virtual items (all sides)?
    saved_virtualItems[] = {}; // alle vItems werden nun gespeichert!! //Array of virtual items that can be saved on your player.
  //>> Config_vItems.hpp not2saved_virtualItems[] = {"dbeschluss","versiegeln","jcmk","jcmv","wundrk","wundrv","lack","lacv","ptk","ptv","rmk","rmv","volk","volv","gtk","gtv","dojk","dojv","einstellerjcmk","einstellerjcmv","einstellerwundrk","einstellerwundrv","einstellerlack","einstellerlacv","einstellerptk","einstellerptv","einstellerrmk","einstellerrmv","einstellervolk","einstellervolv","einstellergtk","einstellergtv","einstellerdojk","einstellerdojv"}; // alle vItems die NICHT gespeichert werden sollen, hier eintragen!!! //Array of virtual items that can't be saved on your player.
    save_playerStats = true; //Save food, water and damage (all sides)?
    save_civilian_weapons = true; //Allow civilians to save weapons on them?
    save_civilian_position = true; //Save civilian location?
    save_civilian_position_restart = true; //Save civilian location only between restarts. After a server restart you'll have to spawn again.
    /* !!!TO SAVE POSITION BETWEEN RESTARTS save_civilian_position MUST BE TRUE!!! */
    save_civilian_positionStrict = false; //Strip the player if possible combat-log?  WARNING: Server crashes and lack of reliable syncing can trigger this.

    /* Vehicle Data Saving */
    save_vehicle_virtualItems = true; //Save virtual items inside the vehicle (all sides)(-- See defined items on next line --)
    save_vehicle_items[] = {"reifen","fuelEmpty","fuelFull","vtoolkit"};
    save_vehicle_inventory = true; //Save Arma inventory of vehicle to the database
    save_vehicle_gearItems[] = {"axe","ACE_packingBandage","ACE_adenosine","ACE_atropine","ACE_epinephrine","ACE_morphine","ACE_bodybag","ACE_bloodIV","ACE_bloodIV_500","ACE_bloodIV_250","ACE_plasmaIV","ACE_plasmaIV_500","ACE_plasmaIV_250","ACE_salineIV","ACE_salineIV_500","ACE_salineIV_250","ACE_personalaidkit","ACE_surgicalkit","ACE_tourniquet","ACE_splint","Rangefinder","ItemGPS","Binocular","acc_flashlight","","tf_anprc152","tf_anprc148jem","ACE_quikclot","ACE_Earplugs","ACE_Flashlight_KSF1","V_Safety_yellow_F","ACE_packingBandage","ACE_elasticBandage","ACE_fielddressing","B_Parachute"};
    save_vehicle_weapons[] = {"Axe","Pickaxe"};
    save_vehicle_mags[] = {};
    save_vehicle_fuel = true; //Save vehicle fuel level to the database (Impounded/Garaged).
    save_vehicle_damage = true; //Save vehicle damage to the database.
    save_vehicle_illegal = false; //This will allow cops to be advised when a vehicle, with illegal items in it, is impounded. This will also save illegal items as proof of crime, and needs "save_vehicle_virtualItems" set as true. Illegal items don't need to be set in save_vehicle_items[] for being saved, if it's enabled.


/* System Settings */
    /* ATM & Federal Reserve System Configurations */
    global_ATM = true; //Allow users to access any ATM on the map (Marked & Unmarked).
    noatm_timer = 10; //Time in minutes that players cannot deposit money after selling stolen gold.
    minimum_cops = 5; //Minimum cops required online to rob the Federal Reserve
    fed_chargeTime = 5; //Time in minutes for the explosive charge at the Federal Reserve to explode

    /* Messaging Settings */
    message_maxlength = 400; //maximum character count allowed in text messages. Used to prevent improper message displaying. -1 to disable the limit
    /*Death settings*/
    drop_weapons_onDeath = true; //Set true to enable weapon dropping on death. False (default) will delete player weapons on death, allowing them to be revived with them instead

    /* Basic System Configurations */
    donor_level = false; //Enable the donor level set in database (var = life_donorlevel; levels = 0,1,2,3,4,5). ATTENTION! Before enabling, read: https://www.bistudio.com/community/game-content-usage-rules & https://www.bistudio.com/monetization
    enable_fatigue = true; //Set to false to disable the ARMA 3 fatigue system.
    total_maxWeight = 24; //Static variable for the maximum weight allowed without having a backpack
    respawn_timer = 30; //How many seconds a player should wait, before being able to respawn. Minimum 5 seconds.

    /* Channel 7 News Station Configurations */
    news_broadcast_cost = 50000; //Cost for a player to send a news station broadcast.
    news_broadcast_cooldown = 10; //Time in minutes that is required between news station broadcasts. (Default = 20 minutes)
    news_broadcast_header_length = 60; //Number of characters that a header can consist of. Anything over this may clip. This depends on the font size and various other factors. Adjust with caution.

    /* Clothing System Configurations */
    civ_skins = false; //Enable or disable civilian skins. Before enabling, you must add all the SEVEN files to textures folder. (It must be named as: civilian_uniform_1.jpg, civilian_uniform_2.jpg...civilian_uniform_6.jpg, civilian_uniform_7.jpg)
    med_extendedSkins = true;
    cop_extendedSkins = true; //Enable or disable cop skins by level. Before enabling, you must add all the EIGHT files to textures folder. (It must be named as: cop_uniform.jpg + cop_uniform_1.jpg, cop_uniform_2.jpg...cop_uniform_6.jpg, cop_uniform_7.jpg; meaning cop_uniform = life_coplevel=0, cop_uniform_1 = life_coplevel=1, cop_uniform_2 = life_coplevel=2, etc...)
    clothing_noTP = false;  //Disable clothing preview teleport? (true = no teleport. false = teleport)
    clothing_box = true; //true = teleport to a black box. false = teleport to somewhere on map. (It only affects the game if clothing_noTP is set as false)
    clothing_masks[] = { "H_Shemag_olive", "H_Shemag_khk", "H_Shemag_tan", "H_Shemag_olive_hs", "H_ShemagOpen_khk", "H_ShemagOpen_tan", "G_Balaclava_blk", "G_Balaclava_combat", "G_Balaclava_lowprofile", "G_Balaclava_oli", "G_Bandanna_aviator", "G_Bandanna_beast", "G_Bandanna_blk", "G_Bandanna_khk", "G_Bandanna_oli", "G_Bandanna_shades", "G_Bandanna_sport", "G_Bandanna_tan", "U_O_GhillieSuit", "U_I_GhillieSuit", "U_B_GhillieSuit", "H_RacingHelmet_1_black_F", "H_RacingHelmet_1_red_F", "H_RacingHelmet_1_white_F", "H_RacingHelmet_1_blue_F", "H_RacingHelmet_1_yellow_F", "H_RacingHelmet_1_green_F", "H_RacingHelmet_1_F", "H_RacingHelmet_2_F", "H_RacingHelmet_3_F", "H_RacingHelmet_4_F" };

    /* Escape Menu Configuration */
    escapeMenu_timer = 5; //Time required to pass before you can click the abort button in the escape menu.
    escapeMenu_displayExtras = true; //Display the players UID & serverName specified below in the escape menu.
    escapeMenu_displayText = "Danke schön fürs dabei sein!"; //Text displayed in the escape menu. Make it short.. around 20 characters.

    /* Fuel System Configurations */
    pump_service = false; //Allow users to use pump service on the map. Default = false
    fuel_cost = 80; //Cost of fuel per liter at fuel stations (if not defined for the vehicle already).
    service_chopper = 50; //Cost to service chopper at chopper service station(Repair/Refuel).
    fuelCan_refuel = 25; //Cost to refuel an empty fuel canister at the fuel station pumps. (Be wary of your buy/sell prices on fuel cans to prevent exploits...)

    /* Gang System Configurations */
    gang_price = 99999999; //Gang creation price. --Remember they are persistent so keep it reasonable to avoid millions of gangs.
    gang_upgradeBase = 10000; //The base cost for purchasing additional slots in a gang
    gang_upgradeMultiplier = 2.5; //CURRENTLY NOT IN USE
    //gang_area[] = {"mafia_dorf"}; //Variable of gang zone markers

    /* Housing System Configurations */
    house_limit = 3; //Maximum number of houses a player can own.
    houseGarage_buyPrice = 99999999;
    houseGarage_sellPrice = 99999999;
    house_garage[] = {"Land_deox_House_B2","Land_deox_House_C1","Land_deox_House_C2","Land_A3F_House03_B1","Land_A3F_House03_B2","Land_A3F_House03_B3","Land_A3F_House03_B4","Land_A3F_House03_B5","Land_Ranch_DED_Ranch_01_F","Land_Ranch_DED_Ranch_02_F","Land_A3F_House01","Land_A3F_House01_1","Land_A3F_House01_2","Land_A3F_House01_3","Land_A3F_House01_4","Land_A3F_House01_5","Land_A3F_House01_B","Land_A3F_House01_B1","Land_A3F_House01_B2","Land_A3F_House01_B3","Land_A3F_House01_B4","Land_A3F_House01_B5","Land_A3F_House03","Land_A3F_House03_1","Land_A3F_House03_2","Land_A3F_House03_3","Land_A3F_House03_4","Land_A3F_House03_5","Land_A3F_House03_B","Land_House_Big_02_F","Land_CT_Wohnhaus_01_gelb","Land_CT_Wohnhaus_01_orange","Land_CT_Wohnhaus_01_rosa","Land_CT_Wohnhaus_01_tuerkis","Land_CT_Wohnhaus_01_weiss","Land_CT_Wohnhaus_02_green","Land_CT_Wohnhaus_02_orange","Land_CT_Wohnhaus_02_rosa","Land_CT_Wohnhaus_02_rot","Land_CT_Wohnhaus_02_tuerkis"};//Häuser wo man Aus/Einparken kann

    /* Hunting & Fishing System Configurations */
    animaltypes_fish[] = { "Salema_F", "Ornate_random_F", "Mackerel_F", "Tuna_F", "Mullet_F", "CatShark_F", "Turtle_F" }; //Classnames of fish you can catch
    animaltypes_hunting[] = { "Sheep_random_F", "Goat_random_F", "Hen_random_F", "Cock_random_F", "Rabbit_F" }; //Classnames of aniamls you can hunt/gut

    /* Item-related Restrictions */
    restrict_medic_weapons = true; //Set to false to allow medics to use any weapon --true will remove ANY weapon they attempt to use (primary,secondary,launcher)
    restrict_clothingPickup = false; //Set to false to allow civilians to pickup/take any uniform (ground/crates/vehicles)
    restrict_weaponPickup = false; //Set to false to allow civilians to pickup/take any weapon (ground/crates/vehicles)
    restricted_uniforms[] = {}; //{ "U_Rangemaster", "U_B_CombatUniform_mcam_tshirt", "U_B_CombatUniform_mcam_worn", "U_B_survival_uniform" };
    restricted_weapons[] = {}; //{ "hgun_P07_snds_F", "arifle_MX_F", "arifle_MXC_F" };

    /* Jail System Configurations */
    jail_seize_vItems[] = { "spikeStrip","lockpick","goldbar","blastingcharge","boltcutter","defusekit","heroin_unprocessed","heroin_processed","cannabis","marijuana","cocaine_unprocessed","cocaine_processed","turtle_raw" }; //Define VIRTUAL items you want to be removed from players upon jailing here. Use "jail_seize_inventory" for Arma inventory items.
    jail_seize_inventory = false; //Set to true to run the cop seize script on inmates. False will remove only weapons and magazines otherwise. (Basically used in case cops forget to seize items). [See Lines 127-131 below]
    sendtoJail_locations[] = { "cop_rosche", "cop_stocken", "cop_gefangnis" }; //Enter the variableName from the mission.sqm here to allow cops to send a person to jail at these locations.
    jail_forceWalk = true;
    jail_timeMultiplier = 15; //Put in minutes how long you want your victim in jail.
    
    /* Medical System Configurations */
    revive_cops = false; //true to enable cops the ability to revive everyone or false for only medics/ems.
    revive_civ = false; //true to enable civs the ability to revive everyone or false for only medics/ems or medic/ems/cops.
    revive_east = false; //true to enable opfor the ability to revive everyone or false for only medics/ems or medic/ems/cops.
    revive_fee = 100; //Revive fee that players have to pay and medics only EMS(independent) are rewarded with this amount.
    hospital_heal_fee = 100; //Fee to heal at a hospital NPC

    /* Paycheck & Bank System Configurations */
    bank_cop = 10000; //Amount of cash in bank for new cops
    bank_civ = 10000; //Amount of cash in bank for new civillians
    bank_med = 10000; //Amount of cash in bank for new medics

    paycheck_cop[] = { 500, 550, 600, 650, 700, 750, 800, 850 }; //Payment for cops, increases with rank {rank 0, rank 1, rank 2, etc.}
    paycheck_civ = 1000; //Payment for civillians
    paycheck_med[] = { 450, 500, 550, 600, 650, 700 }; //Payment for medics, increases with rank {rank 0, rank 1, rank 2, etc.}

    cash_pickup_limit = 100000;

    paycheck_period = 5; //Scaled in minutes
    bank_transferTax = 0.02; //Tax that player pays when transferring money from ATM. Tax = Amount * multiplier


    /* Player Job System Configurations */
    delivery_points[] = {}; //{ "dp_1", "dp_2", "dp_3", "dp_4", "dp_5", "dp_6", "dp_7", "dp_8", "dp_9", "dp_10", "dp_11", "dp_12", "dp_13", "dp_14", "dp_15", "dp_15", "dp_16", "dp_17", "dp_18", "dp_19", "dp_20", "dp_21", "dp_22", "dp_23", "dp_24", "dp_25" };
    fuelTank_winMultiplier = 1; //Win Multiplier in FuelTank Missions. Increase for greater payout. Default = 1

    /* Search & Seizure System Configurations */
    seize_exempt[] = { "Binocular", "ItemWatch", "ItemCompass", "ItemGPS", "ItemMap", "NVGoggles", "FirstAidKit", "ToolKit", "Chemlight_red", "Chemlight_yellow", "Chemlight_green", "Chemlight_blue", "optic_ACO_grn_smg" }; //Arma items that will not get seized from player inventories
    seize_uniform[] = {}; //{ "U_Rangemaster" }; //Any specific uniforms you want to be seized from players
    seize_vest[] = {}; //{ "V_TacVest_blk_POLICE" }; //Any specific vests you want to be seized from players
    seize_headgear[] = {}; //{ "H_Cap_police" }; //Any hats or helmets you want seized from players
    seize_minimum_rank = 2; //Required minimum CopLevel to be able to seize items from players

    /* Vehicle System Configurations */
    chopShop_vehicles[] = { "Car", "Air" }; //Vehicles that can be chopped. (Can add: "Ship" and possibly more -> look at the BI wiki...)
    vehicle_infiniteRepair[] = {false, false, true, false}; //Set to true for unlimited repairs with 1 toolkit. False will remove toolkit upon use. civilian, west, independent, east
    vehicleShop_rentalOnly[] = { "B_MRAP_01_hmg_F", "B_G_Offroad_01_armed_F", "B_Boat_Armed_01_minigun_F" }; //Vehicles that can only be rented and not purchased. (Last only for the session)
    vehicleShop_noRental[] = {}; //Vehicles that can't be rented
    vehicleShop_3D = true; //Add preview 3D inside Shop vehicle. Default : False
    vehicle_rentalReturn = false; //Can return rental vehicles to 'Store vehicle in garage', doesn't actually store it in garage.

    /* Vehicle Purchase Prices */
    vehicle_purchase_multiplier_CIVILIAN = 1; //Civilian Vehicle Buy Price = Config_Vehicle price * multiplier
    vehicle_purchase_multiplier_COP = 1; //Cop Vehicle Buy Price = Config_Vehicle price * multiplier
    vehicle_purchase_multiplier_MEDIC = 1; //Medic Vehicle Buy Price = Config_Vehicle price * multiplier
    vehicle_purchase_multiplier_OPFOR = -1; // -- NOT IN USE -- Simply left in for east support.

    /* Vehicle Rental Prices */
    vehicle_rental_multiplier_CIVILIAN = 0.3; //Civilian Vehicle Rental Price = Config_Vehicle price * multiplier
    vehicle_rental_multiplier_COP = 0.3; //Cop Vehicle Rental Price = Config_Vehicle price * multiplier
    vehicle_rental_multiplier_MEDIC = 0.3; //Medic Vehicle Rental Price = Config_Vehicle price * multiplier
    vehicle_rental_multiplier_OPFOR = -1; // -- NOT IN USE -- Simply left in for east support.

    /* Vehicle Sell Prices */
    vehicle_sell_multiplier_CIVILIAN = 0.5; //Civilian Vehicle Garage Sell Price = Vehicle Buy Price * multiplier
    vehicle_sell_multiplier_COP = 0.5; //Cop Vehicle Garage Sell Price = Vehicle Buy Price * multiplier
    vehicle_sell_multiplier_MEDIC = 0.5; //Medic Vehicle Garage Sell Price = Vehicle Buy Price * multiplier
    vehicle_sell_multiplier_OPFOR = -1; // -- NOT IN USE -- Simply left in for east support.

    /* Vehicle Insurance Prices */
    vehicle_insurance_multiplier_CIVILIAN = 0.25; //Civilian Vehicle Insurance Price = Vehicle Buy Price * multiplier
    vehicle_insurance_multiplier_COP = 0.25; //Cop Vehicle Insurance Price = Vehicle Buy Price * multiplier
    vehicle_insurance_multiplier_MEDIC = 0.25; //Medic Vehicle Insurance Price = Vehicle Buy Price * multiplier
    vehicle_insurance_multiplier_OPFOR = -1; // -- NOT IN USE -- Simply left in for east support.

    /* "Other" Vehicle Prices */
    vehicle_chopShop_multiplier = 0.25; //Chop Shop price for vehicles. TO AVOID EXPLOITS NEVER SET HIGHER THAN A PURCHASE/RENTAL multipler!   Payout = Config_vehicle Price * multiplier
    vehicle_storage_fee_multiplier = 0; //Pull from garage cost --> Cost takes the playersides Buy Price * multiplier
    vehicle_cop_impound_multiplier = 0.1; //TO AVOID EXPLOITS NEVER SET HIGHER THAN A PURCHASE/RENTAL multipler!   Payout = Config_vehicle Price * multiplier

    disableCommanderView = true; //false - Group leaders can access the commander view. true [default] - Group leaders cannot access the commander view.
                                 //Commander/tactical view is accessed via pressing . [NUM] by default. It raises the camera significantly higher and steeper above the player in order to give a boarder tactical view of the surrounding area.

    maximumSpikestrips = -1; //Maximum number of spikes deployed per cop, -1 allows unlimited placement of spikestrips
    minimumSpikeSpeed = 0; //Minimum speed for a spikestrip to take effect, a negative speed will allow stationary vehicles to be spiked


    /* ! --- Do not change --- ! */
    framework_version = "LifeNET 0.0.2";
    /* ------------------------- */

};

#include "Config_Backpack.hpp"

#include "Config_WantedCrimes.hpp"

#include "Config_Clothing.hpp"

#include "Config_Licenses.hpp"

#include "Config_Vehicles.hpp"

#include "Config_Vitems.hpp"

#include "Config_Weapons.hpp"

#include "Config_Gather.hpp"

#include "Config_Spawnpoints.hpp"

#include "Config_Process.hpp"

#include "Config_Housing.hpp"

#include "Config_Garages.hpp"

#include "Config_Loadouts.hpp"

#include "Config_DisabledCommands.hpp"