#include "..\..\script_macros.hpp"
/*
    File: fn_robShops.sqf
    Author: MrKraken
    Description:
    Führt die Aktion "Tankstelle ausrauben" aus.
*/

private["_räuber","_tankstelle","_kasse","_ui","_fortschritt","_pgText","_cP","_rip","_pos"];
_tankstelle = [_this, 0, ObjNull, [ObjNull]] call BIS_fnc_param; // Das Objekt, an dem die Aktion angebracht ist, ist _this. ,0, ist der Index des Objekts, ObjNull ist der Standard, wenn der Parameter leer oder defekt ist
_räuber = [_this, 1, ObjNull, [ObjNull]] call BIS_fnc_param; // Können Sie raten? Okay, es ist der Spieler oder der "Aufrufer". Das Objekt ist 0, die Person, die das Objekt aktiviert, ist 1
_action = [_this, 2] call BIS_fnc_param; // Aktionsname

// Überprüfe, ob der Räuber eine Zivilperson ist
if (side _räuber != civilian) exitWith { hint "Sie können diese Tankstelle nicht ausrauben!" };
// Überprüfe, ob der Räuber sich innerhalb von 15 Metern von der Tankstelle befindet
if (_räuber distance _tankstelle > 15) exitWith { hint "Sie müssen sich innerhalb von 5 m von der Kasse befinden, um ihn auszurauben!" };

// Setze den Standardwert für die Kasse, wenn nicht vorhanden
if !(_kasse) then { _kasse = 1000; };
// Überprüfe, ob der Raub bereits im Gange ist
if (_rip) exitWith { hint "Raub bereits im Gange!"; };
// Überprüfe, ob der Räuber in einem Fahrzeug ist
if (vehicle player != _räuber) exitWith { hint "Steig aus deinem Fahrzeug!"; };

// Überprüfe, ob der Räuber lebt
if !(alive _räuber) exitWith {};
// Überprüfe, ob der Räuber keine Waffe zieht
if (currentWeapon _räuber == "") exitWith { hint format["HaHa, du bedrohst mich ja nicht einmal! Verschwinde von hier, %1", name _räuber]; };
// Überprüfe, ob noch Geld in der Kasse ist
if (_kasse == 0) exitWith { hint "Huch, Da habe ich wohl bereits mein Geld sicher verstaut. Es ist nichts mehr an Bargeld in der Kasse!"; };

_rip = true;
_kasse = 35000 + round(random 6000);
_tankstelle removeAction _action;
_tankstelle switchMove "AmovPercMstpSsurWnonDnon";
_chance = random(100);

// Sende Alarm an Zivilisten, wenn die Chance größer oder gleich 50 ist
if (_chance >= 50) then {[1,format["ALARM! - Tankstelle: %1 wird ausgeraubt!", _tankstelle]] remoteExec ["life_fnc_broadcast",west,civ]; };
[_tankstelle,"robberyalarm"] remoteExec ["life_fnc_say3D",0];

// Zähle die Polizisten im Dienst
_cops = (west countSide playableUnits);
// Überprüfe, ob genügend Polizisten im Dienst sind
if (_cops < 4) exitWith{[_tankstelle,-1] remoteExec ["disableSerialization;",2]; hint "Es gibt nicht genug Polizisten im Dienst, um die Tankstelle auszurauben! ";};
disableSerialization;

5 cutRsc ["life_progress","PLAIN"];
_ui = uiNameSpace getVariable "life_progress";
_fortschritt = _ui displayCtrl 38201;
_pgText = _ui displayCtrl 38202;
_pgText ctrlSetText format["Raub im Gange, bleiben Sie in der Nähe (10m) (1%1)...","%"];
_fortschritt progressSetPosition 0.01;
_cP = 0.0001;

if(_rip) then
{
    while{true} do
    {
        sleep 2;
        _cP = _cP + 0.01;
        _fortschritt progressSetPosition _cP;
        _pgText ctrlSetText format["Raub im Gange, bleiben Sie in der Nähe (10m) (%1%2)...",round(_cP * 100),"%"];

        _Pos = position player; // Spielerposition holen
        _marker = createMarker ["Marker220", _Pos]; // Marker auf der Karte platzieren
        "Marker220" setMarkerColor "ColorRed";
        "Marker220" setMarkerText "!ACHTUNG! Raubüberfall !ACHTUNG!";
        "Marker220" setMarkerType "mil_warning";

        // Einen Ring um den Raubüberfall platzieren (100m)
        _marker = createMarker ["Marker3", _Pos];
        _marker setMarkerShape "ELLIPSE";
        _marker setMarkerSize [50,50];
        _marker setMarkerColor "ColorRed";

        if(_cP >= 1) exitWith {};
        if(_räuber distance _tankstelle > 15) exitWith { };
        if!(alive _räuber) exitWith {};
    };

    if!(alive _räuber) exitWith { _rip = false; };
    if(_räuber distance _tankstelle > 15) exitWith { deleteMarker "Marker220"; deleteMarker "Marker3"; _tankstelle switchMove ""; hint "Sie müssen innerhalb von 10m dort bleiben! - Jetzt ist der Raub gesperrt."; 5 cutText ["","PLAIN"]; _rip = false; };
    5 cutText ["","PLAIN"];

    titleText[format["Du hast gestohlen $%1, Jetzt geh weg, bevor die Bullen ankommen!",[_kasse] call life_fnc_numberText],"PLAIN"];
    deleteMarker "Marker220";
    deleteMarker "Marker3";
    life_cash = life_cash + _kasse;

    _rip = false;
    life_use_atm = false;
    sleep (30 + random(180));
    life_use_atm = true;
    if!(alive _räuber) exitWith {};
    [getPlayerUID _räuber,name _räuber,"211"] remoteExec ["life_fnc_wantedAdd",2];
};
sleep 300;
_action = _tankstelle addAction["Raub die Tankstelle aus",life_fnc_robstore];
_tankstelle switchMove "";
