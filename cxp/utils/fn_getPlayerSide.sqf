/*
	Author: Casperento
	
	Description:
	Returns player's side as a specific string

	This code is provided by CXP SCRIPTS on https://bytex.market/sellers/profile/K970748533
*/
private _side = call {
	if (playerSide isEqualTo west) exitWith {"West"};
	if (playerSide isEqualTo civilian) exitWith {"Civilian"};
	if (playerSide isEqualTo independent) exitWith {"Independent"};
	if (playerSide isEqualTo east) exitWith {"East"};
};
_side
