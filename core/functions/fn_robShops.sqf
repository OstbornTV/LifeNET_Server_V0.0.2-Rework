#include "..\..\script_macros.hpp"
/*
file: fn_robShops.sqf
Author: MrKraken
Description:
Executes the rob shob action!
*/

private["_robber","_shop","_kassa","_ui","_progress","_pgText","_cP","_rip","_pos"];
_shop = [_this,0,ObjNull,[ObjNull]] call BIS_fnc_param; //The object that has the action attached to it is _this. ,0, is the index of object, ObjNull is the default should there be nothing in the parameter or it's broken
_robber = [_this,1,ObjNull,[ObjNull]] call BIS_fnc_param; //Can you guess? Alright, it's the player, or the "caller". The object is 0, the person activating the object is 1
//_kassa = 1000; //The amount the shop has to rob, you could make this a parameter of the call (https://community.bistudio.com/wiki/addAction). Give it a try and post below ;)
_action = [_this,2] call BIS_fnc_param;//Action name

if(side _robber != civilian) exitWith { hint "Sie können diese Tankstelle nicht ausrauben!" };
if(_robber distance _shop > 15) exitWith { hint "Sie müssen sich innerhalb von 5 m von der Kasse befinden, um ihn auszurauben!" };

if !(_kassa) then { _kassa = 1000; };
if (_rip) exitWith { hint "Raub bereits im Gange!" };
if (vehicle player != _robber) exitWith { hint "Steig aus deinem Fahrzeug!" };

if !(alive _robber) exitWith {};
if (currentWeapon _robber == "") exitWith { hint "HaHa, du bedrohst mich ja nicht einmal! Verschwinde von hier, %1" };
if (_kassa == 0) exitWith { hint "Huch, Da habe ich wohl bereits mein Geld sicher verstaut. Es ist nichts mehr an Bargeld in der Kasse!" };

_rip = true;
_kassa = 35000 + round(random 6000);
_shop removeAction _action;
_shop switchMove "AmovPercMstpSsurWnonDnon";
_chance = random(100);
if(_chance >= 50) then {[1,format["ALARM! - Tankstelle: %1 wird ausgeraubt!", _shop]] remoteExec ["life_fnc_broadcast",west,civ]; };
[_shop,"robberyalarm"] remoteExec ["life_fnc_say3D",0];

_cops = (west countSide playableUnits);
if(_cops < 4) exitWith{[_vault,-1] remoteExec ["disableSerialization;",2]; hint "Es gibt nicht genug Polizisten im Dienst, um die Tankstelle auszurauben! ";};
disableSerialization;
5 cutRsc ["life_progress","PLAIN"];
_ui = uiNameSpace getVariable "life_progress";
_progress = _ui displayCtrl 38201;
_pgText = _ui displayCtrl 38202;
_pgText ctrlSetText format["Raub im Gange, bleiben Sie in der Nähe (10m) (1%1)...","%"];
_progress progressSetPosition 0.01;
_cP = 0.0001;

if(_rip) then
{
while{true} do
{
sleep 2;
_cP = _cP + 0.01;
_progress progressSetPosition _cP;
_pgText ctrlSetText format["Raub im Gange, bleiben Sie in der Nähe (10m) (%1%2)...",round(_cP * 100),"%"];
_Pos = position player; // by ehno: get player pos
				                _marker = createMarker ["Marker220", _Pos]; //by ehno: Place a Maker on the map
				                "Marker220" setMarkerColor "ColorRed";
				                "Marker220" setMarkerText "!ATTENTION! robbery !ATTENTION!";
				                "Marker220" setMarkerType "mil_warning";
								
							//Create a ring around the robbery (100m)
							_marker = createMarker ["Marker3", _Pos];
							_marker setMarkerShape "ELLIPSE";
							_marker setMarkerSize [50,50];
							_marker setMarkerColor "ColorRed";

								
if(_cP >= 1) exitWith {};
if(_robber distance _shop > 15) exitWith { };
if!(alive _robber) exitWith {};
};
if!(alive _robber) exitWith { _rip = false; };
if(_robber distance _shop > 15) exitWith { deleteMarker "Marker220"; deleteMarker "Marker3"; _shop switchMove ""; hint "Sie müssen innerhalb von 10m dort bleiben! - Jetzt ist der Raub gesperrt."; 5 cutText ["","PLAIN"]; _rip = false; };
5 cutText ["","PLAIN"];

titleText[format["Du hast gestohlen $%1, Jetzt geh weg, bevor die Bullen ankommen!",[_kassa] call life_fnc_numberText],"PLAIN"];
deleteMarker "Marker220"; // by ehno delete maker
deleteMarker "Marker3";
life_cash = life_cash + _kassa;

_rip = false;
life_use_atm = false;
sleep (30 + random(180));
life_use_atm = true;
if!(alive _robber) exitWith {};
[getPlayerUID _robber,name _robber,"211"] remoteExec ["life_fnc_wantedAdd",2];
};
sleep 300;
_action = _shop addAction["Raub die Tankstelle aus",life_fnc_robstore];
_shop switchMove "";