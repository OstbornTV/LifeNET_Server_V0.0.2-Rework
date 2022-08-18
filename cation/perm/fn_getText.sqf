/*
    File: fn_getText.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
    Returns text from config.
*/
private _configText = param [0,"",[""]];
private _text = getText(missionConfigFile >> "Cation_Perm" >> "language" >> language >> _configText);
if (_text isEqualTo "") then {
    private _default = getText(missionConfigFile >> "Cation_Perm" >> "language" >> "defaultLanguage");
	_text = getText(missionConfigFile >> "Cation_Perm" >> "language" >> _default >> _configText);
};
_text;