#include "..\..\script_macros.hpp"
/*
    File: fn_seizeWeapon.sqf
    Author: Skalicon
    Modified by powerafro2
    Beschreibung: Entfernt Objekte auf dem Boden
*/

// Finde "weaponholder"-Objekte in der Nähe des Spielers innerhalb eines Radius von 3 Metern.
_clear = nearestObjects [player, ["weaponholder"], 3];

// Zähler für die zerstörten Objekte initialisieren.
_destroyed = 0;

// Durchlaufe alle gefundenen "weaponholder"-Objekte.
{
    // Erhöhe den Zähler für jedes gelöschte Objekt.
    _destroyed = _destroyed + 1;

    // Lösche das "weaponholder"-Objekt.
    deleteVehicle _x;

    // Kurze Pause, um mögliche Konflikte zu vermeiden.
    sleep 0.1;

// forEach-Loop beenden.
} forEach _clear;

// Anzeige über zerstörte Objekte.
titleText[hint format ["%1 Sachen auf dem Boden wurden entfernt.", _destroyed], "PLAIN"];
