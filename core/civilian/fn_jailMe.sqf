#include "..\..\script_macros.hpp"
/*
    File: fn_jailMe.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Sobald der Server die Meldung erhält, wird der Rest des Gefängnisvorgangs abgeschlossen.
*/

params [
    ["_ret", [], [[]]], // Die Rückgabeparameter
    ["_bad", false, [false]] // Ein Flag, um zu kennzeichnen, ob der Spieler ein Krimineller ist
];

// Initialisierung von Variablen
private _esc = false; // Flag für die Flucht des Spielers
private _bail = false; // Flag für die Bezahlung der Kaution
private _time = time + (LIFE_SETTINGS(getNumber, "jail_timeMultiplier") * 60); // Berechnung der Gefängniszeit

// Falls der Spieler als "kriminell" markiert ist, wird die Gefängniszeit um 15 Minuten erhöht
if (_bad) then {
    _time = _time + 900;
}

// Bestimmung der Kautionssumme
if !(_ret isEqualTo []) then {
    life_bail_amount = _ret select 2;
} else {
    life_bail_amount = 1500;
    _time = time + (10 * 60);
}

// Ein Spawned Thread, um zu überprüfen, ob der Spieler die Kaution bezahlen kann
[_bad] spawn {
    life_canpay_bail = false;
    if (_this select 0) then {
        sleep (10 * 60);
    } else {
        sleep (5 * 60);
    };
    life_canpay_bail = true;
};

private "_countDown";
for "_i" from 0 to 1 step 0 do {
    if (round(_time - time) > 0) then {
        // Aktualisiert die Anzeige der verbleibenden Gefängniszeit
        _countDown = [(_time - time), "MM:SS.MS"] call BIS_fnc_secondsToString;
        hintSilent parseText format [(localize "STR_Jail_Time") + "<br/> <t size='2'><t color='#FF0000'>%1</t></t><br/><br/>" + (localize "STR_Jail_Pay") + " %3<br/>" + (localize "STR_Jail_Price") + " $%2", _countDown, [life_bail_amount] call life_fnc_numberText, if (life_canpay_bail) then {"Yes"} else {"No"}];
    }

    // Erzwingt das Gehen des Spielers, falls dies konfiguriert ist
    if (LIFE_SETTINGS(getNumber, "jail_forceWalk") isEqualTo 1) then {
        player forceWalk true;
    }

    // Überprüft die Distanz des Spielers zum Fluchtpunkt (jail_marker)
    private _escDist = [[["WL_Rosche", 60]]] call life_util_fnc_terrainSort;
    if (player distance (getMarkerPos "jail_marker") > _escDist) exitWith {
        _esc = true;
    }

    // Überprüft, ob die Kaution bereits bezahlt wurde
    if (life_bail_paid) exitWith {
        _bail = true;
    }

    // Überprüft, ob die Zeit abgelaufen ist
    if (round(_time - time) < 1) exitWith {hint ""};
    if (!alive player && {(round(_time - time)) > 0}) exitWith {};
    sleep 0.1;
}

// Entscheidet, was als Nächstes passieren soll
switch (true) do {
    // Fall: Kaution bezahlt
    case (_bail): {
        life_is_arrested = false;
        life_bail_paid = false;

        hint localize "STR_Jail_Paid";
        player setPos (getMarkerPos "jail_release");

        // Entfernt den Spieler von der Wanted-Liste
        if (life_HC_isActive) then {
            [getPlayerUID player] remoteExecCall ["HC_fnc_wantedRemove", HC_Life];
        } else {
            [getPlayerUID player] remoteExecCall ["life_fnc_wantedRemove", RSERV];
        }

        // Aktualisiert die Datenbankinformationen des Spielers
        [5] call SOCK_fnc_updatePartial;
    };

    // Fall: Spieler entkommen
    case (_esc): {
        life_is_arrested = false;
        hint localize "STR_Jail_EscapeSelf";

        // Fügt den Spieler der Wanted-Liste hinzu
        [0, "STR_Jail_EscapeNOTF", true, [profileName]] remoteExecCall ["life_fnc_broadcast", RCLIENT];
        if (life_HC_isActive) then {
            [getPlayerUID player, profileName, "901"] remoteExecCall ["HC_fnc_wantedAdd", HC_Life];
        } else {
            [getPlayerUID player, profileName, "901"] remoteExecCall ["life_fnc_wantedAdd", RSERV];
        }

        // Aktualisiert die Datenbankinformationen des Spielers
        [5] call SOCK_fnc_updatePartial;
    };

    // Fall: Spieler ist noch am Leben und hat weder bezahlt noch ist entkommen
    case (alive player && {!_esc} && {!_bail}): {
        life_is_arrested = false;
        hint localize "STR_Jail_Released";

        // Entfernt den Spieler von der Wanted-Liste
        if (life_HC_isActive) then {
            [getPlayerUID player] remoteExecCall ["HC_fnc_wantedRemove", HC_Life];
        } else {
            [getPlayerUID player] remoteExecCall ["life_fnc_wantedRemove", RSERV];
        }

        // Setzt den Spieler an den Freigabepunkt
        player setPos (getMarkerPos "jail_release");

        // Aktualisiert die Datenbankinformationen des Spielers
        [5] call SOCK_fnc_updatePartial;
    };
};

// Deaktiviert das erzwungene Gehen des Spielers (ermöglicht wieder das Laufen und Springen)
player forceWalk false;
