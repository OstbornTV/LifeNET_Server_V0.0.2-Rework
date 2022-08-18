/*
	Author: Casperento
	
	Description:
	Returns a given string, localized or not

	This code is provided by CXP SCRIPTS on https://bytex.market/sellers/profile/K970748533
*/
params [["_str", "", [""]]];
if (isLocalized _str) exitWith {localize _str};
_str
