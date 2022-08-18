class Cxp_Config_Safezones {
    // This messages will only be available if you set 'true' on can_shoot propertie
	cxp_canShootMsg = "You can't shoot inside this area!"; // Message shown on player's screen when he try to shoot inside an area that's not made for shooting
	cxp_canShootMsgChat = "%1 is trying to shoot people in a safezone..."; // Message shown on players' chat when someone shoots inside an area that's not made for shooting

	class Cxp_Safezones { // Don't change this class' name
	/*	If you wanna create a new safezone you need to configure it like the following example:
		class Example_Safezone { 																// Classname
			coordinates[] = {XXXX,YYYY,ZZZZ}; 													// Position of the safezone's marker [x, y, z]
			size[] = {200,200}; 																// Marker's size {a-axis,b-axis}
			side = "ANYPLAYER"; 																// Who activates trigger ("EAST", "WEST", "GUER", "CIV", "LOGIC", "ANY", "ANYPLAYER")
			presence = "PRESENT"; 																// Presence: "PRESENT", "NOT PRESENT"
			in_message[] = {"Example SafeZone","You've entered in a safezone...","#ff4500"}; 	// Message shown when getting inside the area (check out https://www.color-hex.com/ for a new tilte color) - Check out the result on: https://i.imgur.com/NsBJ9Aw.png
			out_message[] = {"Example SafeZone","You've leaved a safezone...","#ff4500"}; 		// Message shown when leaving the area (check out https://www.color-hex.com/ for a new title color) - Check out the result on: https://i.imgur.com/un99juR.png
			brush = "Grid"; 																	// Marker's brush ("Solid", "SolidFull", "Horizontal", "Vertical", "Grid", "FDiagonal", "BDiagonal", "DiagGrid", "Cross", "Border", "SolidBorder")
			shape = "ELLIPSE"; 																	// Marker's shape ("RECTANGLE" or "ELLIPSE")
			color = "ColorGreen"; 																// Marker's color (Check out CfgMarkerColors on https://community.bistudio.com/wiki/Arma_3_CfgMarkerColors)
			opacity = 0.5; 																		// Color opacity (0: invisible - 1: visible)
			can_knockout = "false"; 															// "true": players can knockout inside the area, "false": players can't knockout inside the area
			can_shoot = "false"; 																// "true": players can shoot inside the area, "false": players can't shoot inside the area
			whitelistedSides[] = {"side"};                                                      // List of sides that can shoot inside the safezone when 'can_shoot' is set to 'false'. No matter which side is set on 'side' propertie, and doesn't apply to whitelisted vehicles
			whitelistedVehicles[] = {{"classname", "side"}};                                    // List of vehicles' classnames that can shoot inside the safezone when 'can_shoot' is set to 'false'.

			//	To whitelist a vehicle, write the classname of the vehicle followed by the playerside that have the right to shoot with it, example: 
			//  (The following side strings apply to whitelistedSides propertie too)
			//
			//    SYNTAX 1: Only one side (or "any") can shoot inside the zone with the given vehicle
			//		{"classname", "side"}
			//      "classname": classname of the vehicle that has gunner
			//	    "side": "West" (for cops), "Civilian" (for civilians), "East" (for red team), "Independent" (for medics),
			//								or "any" (to let everyone have the right to shoot with this vehicle)
			//
			//    SYNTAX 2: Let more than one side to shoot inside the zone with the given vehicle
			//		{"classname", {"side", "anotherside", ...}}
			//      "classname": same as SYNTAX 1
			//	    "side": same as SYNTAX 1
			//

			can_die = "false"; 																	// "true": players die normally inside the area, "false": players stay imortal inside the area
			can_lockpick = "false";																// "true": players can use lockpick inside the area, "false": players cannot use lockpick inside the area
		};
	*/

		/*
			Pre-configurated safezones examples.
			Check out the result on: https://i.imgur.com/YXxOOQN.jpg
		*/
		class Rosche_Safezone { // If you don't wanna this safezone anymore, just comment this whole class or delete it
			coordinates[] = {3614.526,13033.066,0};
			size[] = {500,500};
			side = "ANYPLAYER";
			presence = "PRESENT";
			in_message[] = {"Rosche SafeZone","You've entered in a safezone...","#ff4500"};
			out_message[] = {"Rosche SafeZone","You've leaved a safezone...","#ff4500"};
			brush = "Grid";
			shape = "ELLIPSE";
			color = "ColorGreen";
			opacity = 0.5;
			can_knockout = "false";
			can_shoot = "false";
			whitelistedSides[] = {"West"};
			whitelistedVehicles[] = {{"B_G_Offroad_01_armed_F", "West"}, {"B_G_Offroad_01_AT_F", "West"}};
			can_die = "false";
			can_lockpick = "false";
		};

		class Stocken_Safezone { // If you don't wanna this safezone anymore, just comment this whole class or delete it
			coordinates[] = {14024.19,18711.795,0};
			size[] = {250,150};
			side = "ANYPLAYER";
			presence = "PRESENT";
			in_message[] = {"Stocken SafeZone","You've entered in a safezone...","#ff4500"};
			out_message[] = {"Stocken SafeZone","You've leaved a safezone...","#ff4500"};
			brush = "Horizontal";
			shape = "RECTANGLE";
			color = "ColorRed";
			opacity = 0.5;
			can_knockout = "false";
			can_shoot = "false";
			whitelistedSides[] = {"West"};
			whitelistedVehicles[] = {{"B_G_Offroad_01_armed_F", "any"}, {"B_G_Offroad_01_AT_F", "West"}};
			can_die = "false";
			can_lockpick = "false";
		};
/*
		class _Safezone { // If you don't wanna this safezone anymore, just comment this whole class or delete it
			coordinates[] = {16842.861,12683.803,0};
			size[] = {400,400};
			side = "ANYPLAYER";
			presence = "PRESENT";
			in_message[] = {"Pyrgos SafeZone","You've entered in a safezone...","#ff4500"};
			out_message[] = {"Pyrgos SafeZone","You've leaved a safezone...","#ff4500"};
			brush = "Vertical";
			shape = "ELLIPSE";
			color = "ColorBlue";
			opacity = 0.5;
			can_knockout = "false";
			can_shoot = "false";
			whitelistedSides[] = {"West"};
			whitelistedVehicles[] = {{"B_G_Offroad_01_armed_F", {"West", "Independent"}}, {"B_G_Offroad_01_AT_F", "West"}};
			can_die = "false";
			can_lockpick = "false";
		};

		class Sofia_Safezone { // If you don't wanna this safezone anymore, just comment this whole class or delete it
			coordinates[] = {25658.46,21330.92,0};
			size[] = {350,350};
			side = "ANYPLAYER";
			presence = "PRESENT";
			in_message[] = {"Sofia SafeZone","You've entered in a safezone...","#ff4500"};
			out_message[] = {"Sofia SafeZone","You've leaved a safezone...","#ff4500"};
			brush = "Solid";
			shape = "ELLIPSE";
			color = "ColorCivilian";
			opacity = 0.5;
			can_knockout = "false";
			can_shoot = "true";
			whitelistedSides[] = {};
			whitelistedVehicles[] = {};
			can_die = "true";
			can_lockpick = "false";
		};
		*/
	};
};