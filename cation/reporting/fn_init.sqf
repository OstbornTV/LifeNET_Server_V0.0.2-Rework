/*
    File: fn_init.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
    Initializes clientside variables.
*/
private _status = switch (playerSide) do {
	case west: {getText(missionConfigFile >> "Cation_Reporting" >> "statusAtJoinWest");};
	case independent: {getText(missionConfigFile >> "Cation_Reporting" >> "statusAtJoinIndepent");};
	default {"";};
};
player setVariable ["reportStatus",_status,true];
player setVariable ["reportCenter","",true];