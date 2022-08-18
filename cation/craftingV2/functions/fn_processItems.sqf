/*
    File: fn_processItems.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
    Processes items - but first checks if all items are available and crafted items can be stored.
*/

params [
	["_item","",[""]],
    ["_category","",[""]],
	["_amount",0,[0]],
	["_location",-1,[0]],
    ["_station","",[""]]
];

private _error = false; // initialize error variable

if (isNull player || !alive player || (player getVariable ["restrained",false]) || (player getVariable ["Escorting",false]) || life_istazed) exitWith { //If null / dead exit menu
    if ((getNumber(missionConfigFile >> "Cation_CraftingV2" >> "DebugMode")) isEqualTo 1) then { // if debug mode is enabled
        diag_log "cationstudio crafting: [ERROR] player is not allowed to craft. Function cat_craftingV2_fnc_processItems"; // log entry
    };
};
if ((getNumber(missionConfigFile >> "Cation_CraftingV2" >> "version")) > 4) then { // if version 4 or greater
    if ((player getVariable ["playerSurrender",false]) || life_isknocked) exitWith { // check some variables
        if ((getNumber(missionConfigFile >> "Cation_CraftingV2" >> "DebugMode")) isEqualTo 1) then { // if debug mode is enabled
            diag_log "cationstudio crafting: [ERROR] player is not allowed to craft. Function cat_craftingV2_fnc_processItems"; // log entry
        };
    };
};

if (_item isEqualTo "" || _amount isEqualTo 0 || _location isEqualTo -1 || _category isEqualTo "") exitWith { // undefined variables
    if ((getNumber(missionConfigFile >> "Cation_CraftingV2" >> "DebugMode")) isEqualTo 1) then { // if debug mode is enabled
        diag_log "cationstudio crafting: [ERROR] variables undifined. Function cat_craftingV2_fnc_processItems"; // log entry
    };
};

private _itemsNeeded = getArray(missionConfigFile >> "Cation_CraftingV2" >> "categories" >> _category >> _item >> "itemsReq"); // get required items from config
private _vItem = getNumber(missionConfigFile >> "Cation_CraftingV2" >> "categories" >> _category >> _item >> "vItem"); // get vItem boolean from config
if (_vItem isEqualTo 1) then { // parse _vItem to boolean
    _vItem = true; // set true
} else {
    _vItem = false; // set false
};
private _skin = getText(missionConfigFile >> "Cation_CraftingV2" >> "categories" >> _category >> _item >> "skin"); // get vItem boolean from config
private _skinSide = getText(missionConfigFile >> "Cation_CraftingV2" >> "categories" >> _category >> _item >> "skinSide"); // get vItem boolean from config
private _spawnPoint = ""; // initialize spawnpoint variable
if (_location isEqualTo 2) then { // is vehicle
    _spawnPoint = getText(missionConfigFile >> "Cation_CraftingV2" >> "stations" >> _station >> "spawnmarker"); // get spawnmarker from config
};

// check if enough items
private _itemsPlayer = [] call cat_craftingV2_fnc_getItems; // get player items
private _itemsLacked = []; // initialize items lacked variable
{
    private _itemNeeded = _x select 0; // get needed item
    private _amountNeeded = (_x select 1) * _amount; // get amount needed
    private _found = false; // initialize variable
    {
        private _itemPlayer = _x select 0; // get item of player inventory
        private _amountPlayer = _x select 1; // get amount of item of player inventory
        if (_itemPlayer isEqualTo _itemNeeded) then { // if playeritem equals itemNeeded
            _found = true; // set found true
            if (_amountNeeded > _amountPlayer) then { // check if player has not enough items
                _itemsLacked pushBack [_itemNeeded,_amountNeeded-_amountPlayer]; // add item to lacked items + calculate lacked items
            };
        };
    } forEach _itemsPlayer; // player items - format: [[variable,amount],[variable,amount],...]
    if !(_found) then { // if item not found
        _itemsLacked pushBack [_itemNeeded,_amountNeeded]; // add item to lacked items
    };
} forEach _itemsNeeded; // all items needed - format: [[varname,amount],[varname,amount],...]

if ((getNumber(missionConfigFile >> "Cation_CraftingV2" >> "DebugMode")) isEqualTo 1) then { // if debug mode is enabled
    diag_log format["cationstudio crafting: [INFO] items needed: %2x %1",_itemsNeeded,_amount]; // log entry
    diag_log format["cationstudio crafting: [INFO] items lacked: %1",_itemsLacked]; // log entry
};

if !(_itemsLacked isEqualTo []) exitWith { // if not enough items
    private _itemsLackedString = ""; // initialize string
    {
        private _itemDisplayName = ""; // displayname
        private _itemNeeded = _x select 0; // get item lacked
        private _amountNeeded = _x select 1; // get amount lacked
		private _itemDisplayName = localize getText(missionConfigFile >> "VirtualItems" >> _itemNeeded >> "displayName"); // display name
        private _icon = getText(missionConfigFile >> "VirtualItems" >> _itemNeeded >> "icon"); // get icon
        _itemsLackedString = _itemsLackedString + format["<br/><t>%1x <img image='%2'/> %3</t>",_amountNeeded,_icon,_itemDisplayName]; // format string
    } forEach _itemsLacked; // for each lacked item
    [
        parseText format [["NotEnoughItems"] call cat_craftingV2_fnc_getText,_itemsLackedString], // main text
        (["NotEnoughItemsHeading"] call cat_craftingV2_fnc_getText) // title
    ] call BIS_fnc_guiMessage; // show messge box
};

private _itemsSeized = [_itemsNeeded,_amount,_location] call cat_craftingV2_fnc_seizeItems; // remove items
if ((getNumber(missionConfigFile >> "Cation_CraftingV2" >> "DebugMode")) isEqualTo 1) then { // if debug mode is enabled
    diag_log format["cationstudio crafting: [INFO] items seized: %1",_itemsSeized]; // log entry
};

// check if can store
try {
    if (_location isEqualTo 0) then { // store to player inventory
        if ((getNumber(missionConfigFile >> "Cation_CraftingV2" >> "DebugMode")) isEqualTo 1) then { // if debug mode is enabled
            diag_log format["cationstudio crafting: [INFO] player inventory can store: %1",[_item,_vItem] call cat_craftingV2_fnc_canStorePlayer]; // log entry
        };
        if (_amount > [_item,_vItem] call cat_craftingV2_fnc_canStorePlayer) throw "not enough space"; // check if enough space and throw error
    };
    if (_location isEqualTo 1) then { // store to locker
        if ((getNumber(missionConfigFile >> "Cation_CraftingV2" >> "DebugMode")) isEqualTo 1) then { // if debug mode is enabled
            diag_log format["cationstudio crafting: [INFO] locker can store: %1",[_item,_vItem] call cat_craftingV2_fnc_canStoreLocker]; // log entry
        };
        if (_amount > [_item,_vItem] call cat_craftingV2_fnc_canStoreLocker) throw "not enough space"; // check if enough space and throw error
    };
    if (_location isEqualTo 2) then { // Check if spawn is empty
        if (_spawnPoint isEqualTo "") throw "no spawn point";
        if ((getNumber(missionConfigFile >> "Cation_CraftingV2" >> "DebugMode")) isEqualTo 1) then { // if debug mode is enabled
            diag_log format["cationstudio crafting: [INFO] spawn point: %1",_spawnPoint]; // log entry
            diag_log format["cationstudio crafting: [INFO] nearest objects (5m) %1",nearestObjects[(getMarkerPos _spawnPoint),["Car","Ship","Air"],5]]; // log entry
        };
        if !((nearestObjects[(getMarkerPos _spawnPoint),["Car","Ship","Air"],5]) isEqualTo []) throw "spawn point blocked"; // check if spawn point is blocked by other vehicle and throw error
    };
} catch {
    [_itemsSeized] call cat_craftingV2_fnc_refundItems; // refund items
    switch (_exception) do { // switch exception message
        case "spawn point blocked": { // spawn point blocked
            hint (["SpawnPointBlocked"] call cat_craftingV2_fnc_getText); // show error message
        };
        case "not enough space": { // not enough space in inventory
            hint (["NotEnoughSpace"] call cat_craftingV2_fnc_getText); // show error message
        };
    };
    if ((getNumber(missionConfigFile >> "Cation_CraftingV2" >> "DebugMode")) isEqualTo 1) then { // if debug mode is enabled
        diag_log format["cationstudio crafting: [ERROR] cannot store item: %1",_exception]; // log entry
    };
    _error = true; // set error variable to true
};
if (_error) exitWith {}; // exit script

private _displayName = ""; // initialize variable
private _nickName = getText(missionConfigFile >> "Cation_CraftingV2" >> "categories" >> _category >> _item >> "nickname"); // get variable nickname
if (!(_nickName isEqualTo "")) then { // nickname defined
	_displayName = localize _nickName; // set displayname to localized nickname
} else { // no nickname defined
    if (_vItem) then { // is vItem
        _displayName = localize (getText(missionConfigFile >> "VirtualItems" >> _item >> "displayName")); // get displayname
    } else {
        private _itemInfo = [_item] call life_fnc_fetchCfgDetails; // get item details
        if ((getText(missionConfigFile >> "Cation_CraftingV2" >> "categories" >> _category >> _item >> "skin")) isEqualTo "") then { // no skin found
            _displayName = _itemInfo select 1; // get displayname
        } else {
            _displayName = format["%1 - %2",_itemInfo select 1,getText(missionConfigFile >> "Cation_CraftingV2" >> "categories" >> _category >> _item >> "skin")]; // get displayname and skin
        };
    };
};

disableSerialization;

private _display = findDisplay 5100; // get dialog
if (isNull _display) exitWith {}; // dialog not closed
if (life_is_processing || life_action_inUse) exitWith {}; // if action or processing is in use
life_is_processing = true; // set processing variable to in use: true
life_action_inUse = true; // set action in Use variable to in use: true
private _progressBar = _display displayCtrl 5114; // get progress bar
ctrlShow [5110, false]; // hide crafting button
ctrlShow [5113, false]; // hide item amount field
private _errorAborted = false; // initialize 2nd error variable
private _errorDistance = false; // initialize 3rd error variable
private _dialogClosed = false; // initialize dialog status variable
private _pos = getPos player;
private ["_externalProgressBar","_externalProgressBarText"];
if ((getNumber(missionConfigFile >> "Cation_CraftingV2" >> "DebugMode")) isEqualTo 1) then { // if debug mode is enabled
    diag_log format["cationstudio crafting: [INFO] start crafting of %1x %2. Function cat_craftingV2_fnc_processItems",_amount,_displayName]; // log entry
};
for "_a" from 1 to _amount step 1 do { // for each item that should be crafted
    private _duration = getNumber(missionConfigFile >> "Cation_CraftingV2" >> "categories" >> _category >> _item >> "time"); // get crafting time
    for "_i" from 0 to 100 step 1 do { // from 0 to 100
        if (isNull findDisplay 5100) then { // dialog closed
            _dialogClosed = true;
            private _ui = uiNameSpace getVariable ["life_progress", displayNull];
            if (_ui isEqualTo displayNull) then {
                "progressBar" cutRsc ["life_progress","PLAIN"];
                _ui = uiNameSpace getVariable "life_progress";      
                _externalProgressBar = _ui displayCtrl 38201;
                _externalProgressBarText = _ui displayCtrl 38202;
            };
        };
        if (_dialogClosed) then {            
            _externalProgressBar progressSetPosition (_i/100); // set progress bar percentage
            _externalProgressBarText ctrlSetText format["%1 %2 %3/%4 - %5%6",["Crafting"] call cat_craftingV2_fnc_getText,_displayName,_a,_amount,_i,"%"]; // // set text - Format: Crafting Item current/Amount - xx%
        } else {
            _progressBar ctrlCommit (_duration/100); // set progress bar percentage
            _progressBar progressSetPosition (_i/100); // set progress bar percentage
            ctrlSetText[5115,format["%1 %2 %3/%4 - %5%6",["Crafting"] call cat_craftingV2_fnc_getText,_displayName,_a,_amount,_i,"%"]]; // set text - Format: Crafting Item current/Amount - xx%
        };
        uiSleep (_duration/100); // sleep for craftingtime/100

        if (player distance _pos > 10) exitWith { // too far away
            _errorDistance = true; // error happened -> set error variable to true
            if ((getNumber(missionConfigFile >> "Cation_CraftingV2" >> "DebugMode")) isEqualTo 1) then { // if debug mode is enabled
                diag_log "cationstudio crafting: [ERROR] player is not allowed to craft anymore because he move to far away from starting point. Function cat_craftingV2_fnc_processItems"; // log entry
            };
        };

        if (isNull player || !alive player || (player getVariable ["restrained",false]) || (player getVariable ["Escorting",false]) || life_istazed) exitWith { //If null / dead exit menu
            _errorAborted = true; // error happened -> set error variable to true
            if ((getNumber(missionConfigFile >> "Cation_CraftingV2" >> "DebugMode")) isEqualTo 1) then { // if debug mode is enabled
                diag_log "cationstudio crafting: [ERROR] player is not allowed to craft anymore. Function cat_craftingV2_fnc_processItems"; // log entry
            };
        };
        if ((getNumber(missionConfigFile >> "Cation_CraftingV2" >> "version")) > 4) then { // if version 4 or greater
            if ((player getVariable ["playerSurrender",false]) || life_isknocked) exitWith { // check some variables
                _errorAborted = true; // error happened -> set error variable to true
                if ((getNumber(missionConfigFile >> "Cation_CraftingV2" >> "DebugMode")) isEqualTo 1) then { // if debug mode is enabled
                    diag_log "cationstudio crafting: [ERROR] player is not allowed to craft anymore. Function cat_craftingV2_fnc_processItems"; // log entry
                };
            };
        };
    };
    if (_errorAborted || _errorDistance) exitWith {}; // exit loop

    // try to add items
    try {
        if (_location isEqualTo 0) then { //save in player inventory
            if (_vItem) then { // if vItem
                if !([true,_item,1] call life_fnc_handleInv) throw "not enough space"; // save item in player inventory else -> error
            } else { // else Arma item
                [_item,1] call cat_craftingV2_fnc_addItemPlayer; // add ArmA item to player inventory
            };
        };
        if (_location isEqualTo 1) then { // save in locker inventory
            if !([true,_item,1,_vItem] call cat_craftingV2_fnc_handleInvLocker) throw "not enough space"; // save item in locker inventory else -> error
        };
        if (_location isEqualTo 2) then { // spawn object
            if !([_item,_spawnPoint,_skinSide,_skin] call cat_craftingV2_fnc_spawnVehicle) throw "cannot spawn vehicle"; // spawn vehicle else -> error
        };
    } catch { // catch errors
        [_itemsSeized] call cat_craftingV2_fnc_refundItems; // refund items
        _error = true; // set error variable -> true
        switch (_exception) do { // switch exception message
            case "spawn point blocked": { // spawn point blocked
                hint (["SpawnPointBlocked"] call cat_craftingV2_fnc_getText); // show error message
            };
            case "not enough space": { // not enough space in inventory
                hint (["NotEnoughSpace"] call cat_craftingV2_fnc_getText); // show error message
            };
        };
        if ((getNumber(missionConfigFile >> "Cation_CraftingV2" >> "DebugMode")) isEqualTo 1) then { // if debug mode is enabled
            diag_log format["cationstudio crafting: [ERROR] cannot store item: %1. Function cat_craftingV2_fnc_processItems",_exception]; // log entry
        };
    }; 
    if (_error) exitWith { // exit loop if error
        ctrlShow [5110, true]; // show crafting button
        ctrlShow [5113, true]; // show item amount field
    };
    hint ""; // clear hint message
    private _points = getNumber(missionConfigFile >> "Cation_CraftingV2" >> "categories" >> _category >> _item >> "ep"); // get ep for item from config
    if (_points < 0) then { // if experience points for item are negative
        if ((getNumber(missionConfigFile >> "Cation_CraftingV2" >> "DebugMode")) isEqualTo 1) then { // if debug mode is enabled
            diag_log format["cationstudio crafting: [WARNING] experience points (ep) for item %1 in category %1 is negative. Using default value 1. Funtion cat_craftingV2_fnc_processItems", _item, _category]; // log entry
        };
        _points = 1; // default it to 1
    };
    if (_points == 0) then { // if experience points for item is 0, value is set to 0 or is unset.
        _points = 1; // default it to 1
    };
    [_points,true] call cat_craftingV2_fnc_handlePoints; // add ep to player crafting points
};
life_is_processing = false; // set processing variable to in use: false
life_action_inUse = false; // set action in Use variable to in use: false
[3] call SOCK_fnc_updatePartial; // update gear to database
if (_errorAborted) exitWith { // aborted because of error
    closeDialog 0; // close dialog
    hint (["Error"] call cat_craftingV2_fnc_getText); // error notification
};
if (_errorDistance) exitWith { // aborted because moved too far away
    "progressBar" cutText ["","PLAIN"];
    hint (["ErrorDistance"] call cat_craftingV2_fnc_getText); // error notification
};
if (_error) exitWith {}; // Exit if error occured
if ((getNumber(missionConfigFile >> "Cation_CraftingV2" >> "DebugMode")) isEqualTo 1) then { // if debug mode is enabled
    diag_log format["cationstudio crafting: [INFO] finished crafting of %1x %2. Function cat_craftingV2_fnc_processItems",_amount,_displayName]; // log entry
};
hint format [["Success"] call cat_craftingV2_fnc_getText, _amount, _displayName]; // Success notification
if (_dialogClosed) then {
    "progressBar" cutText ["","PLAIN"];
} else {
    ctrlShow [5110, true]; // show crafting button
    ctrlShow [5113, true]; // show item amount field
};