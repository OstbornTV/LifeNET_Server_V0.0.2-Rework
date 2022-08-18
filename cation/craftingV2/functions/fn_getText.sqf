/*
    File: fn_getText.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
    Returns text from language config.
*/
private _configText = param [0,"",[""]]; // get config text
private _text = getText(missionConfigFile >> "Cation_CraftingV2" >> "language" >> language >> _configText); // get text from language file
if (_text isEqualTo "") then { // if text is empty
    private _default = getText(missionConfigFile >> "Cation_CraftingV2" >> "language" >> "defaultLanguage"); // get default language
	_text = getText(missionConfigFile >> "Cation_CraftingV2" >> "language" >> _default >> _configText); // get text in default language
};
_text; // return text