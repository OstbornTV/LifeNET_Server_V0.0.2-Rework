class Cxp_Config_MapFilter {
/*
	SYNTAX:

	class MapName { // Put the name of the map that your server runs

		class PlayerSide { // Put the player side that you want to have access to the markers below

			class FirstCategoryName { // Put a name for this category

				class FirstSubCategoryName { // Put a name for this sub category

					mpfl_mks[] { // Put the markers' names on this array which will be shown on this 'Category >> Subcategory >> MarkerName'
						"markerName" // DON'T LET A COMMA AFTER THE LAST ELEMENT OF EACH ARRAY !!!
					};
				};
			};

			class SecondCategoryName { // Put a name for this category

				class FirstSubCategoryName { // Put a name for this sub category

					mpfl_mks[] { // Put the markers' names on this array which will be shown on this 'Category >> Subcategory >> MarkerName'
						"markerName" // DON'T LET A COMMA AFTER THE LAST ELEMENT OF EACH ARRAY !!!
					};
				};
			};

		};
	};

	TUTORIAL - HOW TO GET ALL OF YOUR MAP MARKERS' NAMES AT ONCE
		1. Open your mission.sqm on Eden Editor
		2. Place a unit on the map and check if this unit has it's 'Player' checkbox marked
		3. Open up your debug console by pressing 'ESC'
		4. Copy and Paste the following code into the 'Execute' text field and click on the button 'Local Exec':

			_str = "";_endl = toString[13,10];{if !((markerText _x) isEqualTo "") then {_str = _str + str(_x) + "," + _endl;};} forEach allMapMarkers;copyToClipboard _str;

		5. Now open a text editor of your choice and press CTRL+V and you shall see all of your map markers' names
		6. Take these strings and choose what's the better category/subcategory for them on the configuration options below!
*/
	// ALL ALTISLIFE DEFAULT MARKERS
    class WL_Rosche {

		class Civilian { // Civilians' markers

			class Farms {

				class Processors {
					mpfl_mks[] = {
						"copper_mine_1",
						"salt_processing",
						"OilP",
						"iron_processing",
						"cocaine processing",
						"diamond_processing",
						"Weed_p_1",
						"rock_processing",
						"sand_processing",
						"heroin_p" // DON'T LET A COMMA AFTER THE LAST ELEMENT OF AN ARRAY !!!
					};
				};
				class Traders {
					mpfl_mks[] = {
						"oil_trader",
						"salt_trader",
						"diamond_trader",
						"glass_trader",
						"iron_copper_trader",
						"oil_trader_3_1",
						"turle_dealer",
						"turle_dealer_1",
						"turle_dealer_2",
						"gold_bar_dealer",
						"Dealer_1",
						"Dealer_1_3",
						"Dealer_1_4"
					};
				};
				class Zones {
					mpfl_mks[] = {
						"iron_mine",
						"salt_mine",
						"sand_mine",
						"copper_mine",
						"diamond_mine",
						"apple_1",
						"apple_2",
						"peaches_2",
						"peaches_1",
						"apple_3",
						"apple_4",
						"peaches_3",
						"oil_field_2",
						"oil_field_1",
						"weed_1",
						"cocaine_1",
						"heroin_1",
						"rock_quarry",
						"turtle_1_name",
						"turtle_1_name_1",
						"turtle_1_name_2",
						"hunting_marker"
					};
				};
			};

			class Shops {
				class Guns {
					mpfl_mks[] = {
						"gun_store_1",
						"gun_store_1_1"
					};
				};
				class Vehicles {
					mpfl_mks[] = {
						"airshop",
						"civ_truck_shop1",
						"truck_1",
						"Carshop",
						"air_serv_1",
						"car1_1",
						"car1_2_1_1",
						"boat_2",
						"car1_1_1",
						"airshop_1",
						"civ_ship_1",
						"civ_truck_shop1_1",
						"boat_1",
						"boat_2_1",
						"civ_ship_2",
						"boat_2_1_1",
						"civ_ship_3",
						"kart_shop_text_1"
					};
				};
				class Cloths {
					mpfl_mks[] = {
						"Gen_3_4_1",
						"Gen_3_4",
						"Gen_3_3",
						"Gen_3",
						"dive_shop",
						"dive_shop_1"
					};
				};
				class Markets {
					mpfl_mks[] = {
						"fish_market_1",
						"Gen_3_1",
						"Gen_3_1_1",
						"Gen_3_1_1_1",
						"Gen_3_1_1_2",
						"Gen_3_1_1_3"
					};
				};
				class Licenses {
					mpfl_mks[] = {
						"license_shop",
						"license_shop_1",
						"license_shop_2",
						"license_shop_2_1"
					};
				};
				class General {
					mpfl_mks[] = {
						"Gen_4",
						"Gen_2",
						"Gen_2_1",
						"Gen",
						"Gen_1"
					};
				};
			};

			class Government {
				class Hospital {
					mpfl_mks[] = {
						"hospital_marker",
						"Hospital_1",
						"hospital_2",
						"hospital_3"
					};
				};
				class Bank {
					mpfl_mks[] = {
						"atm",
						"lbank"
					};
				};
				class Cop {
					mpfl_mks[] = {
						"cop_spawn_3",
						"cop_spawn_4",
						"Correctional_Facility",
						"police_hq_1",
						"police_hq_2",
						"CG",
						"Police HQ_1",
						"cop_spawn_5"
					};
				};
				class Extra {
					mpfl_mks[] = {
						"7News_1",
						"fed_reserve"
					};
				};
			};

			class Missions {
				class Delivery {
					mpfl_mks[] = {
						"dp_1_1",
						"dp_1_2",
						"dp_1_3",
						"dp_1_4",
						"dp_1_5",
						"dp_1_6",
						"dp_1_7",
						"dp_1_8",
						"dp_1_9",
						"dp_1_10",
						"dp_1_11",
						"dp_1_12",
						"dp_1_13",
						"dp_1_14",
						"dp_1_15",
						"dp_1_16",
						"dp_1_17",
						"dp_1_19",
						"dp_1_20",
						"dp_1_18",
						"dp_1_21",
						"dp_1_18_1",
						"dp_1_18_2",
						"dp_1_14_1",
						"dp_1_15_1",
						"dp_missions"
					};
				};
				class Fuel {
					mpfl_mks[] = {
						"fuel_storage_1",
						"fuel_storage_2"
					};
				};
			};

			class Illegal {
				class Gangs {
					mpfl_mks[] = {
						"gang_area_1",
						"gang_area_2",
						"gang_area_3"
					};
				};
				class Zones {
					mpfl_mks[] = {
						"Rebelop",
						"Rebelop_1",
						"Rebelop_2"
					};
				};
				class ChopShop {
					mpfl_mks[] = {
						"chop_shop_1",
						"chop_shop_2",
						"chop_shop_3",
						"chop_shop_4"
					};
				};
			};

			class Garage {
				class Cars {
					mpfl_mks[] = {
						"civ_gar_1",
						"civ_gar_1_1",
						"civ_gar_1_2",
						"civ_gar_1_3"
					};
				};
			};
		};

		class West { // Cops' markers
			class HQs {
				class HQs {
					mpfl_mks[] = {
						"cop_spawn_3",
						"cop_spawn_4",
						"Correctional_Facility",
						"police_hq_1",
						"police_hq_2",
						"CG",
						"Police HQ_1",
						"cop_spawn_5"
					};
				};
			};
		};

		class Independent { // Meds' markers
			class Hospital {
				class Hospitals {
					mpfl_mks[] = {
						"hospital_marker",
						"Hospital_1",
						"hospital_2",
						"hospital_3"
					};
				};
			};
		};
	};
};
