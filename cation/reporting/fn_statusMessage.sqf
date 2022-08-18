/*
    File: fn_statusMessage.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
    Message from control center to unit.
*/
params [
	["_status","",[""]],
	["_text","",[""]]
];
hint parseText format ["<t color='#316dff'><t size='2'><t align='center'>%3: %1<br/><br/><t color='#ffffff'>%2",_status,_text,["newStatus"] call cat_reporting_fnc_getText];
["TaskAssigned",["",format ["%2: %1",_status,["newStatusFromCenter"] call cat_reporting_fnc_getText]]] call bis_fnc_showNotification;
systemChat format ["--- %2: %1",_status,["newStatusFromCenter"] call cat_reporting_fnc_getText];