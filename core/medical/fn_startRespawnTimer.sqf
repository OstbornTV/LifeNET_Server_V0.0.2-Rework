/*
    Datei: fn_startRespawnTimer.sqf
    Autor: OsbornTV

    Beschreibung:
    Startet einen Timer für den automatischen Respawn-Prozess,
    wenn nach einer gewissen Zeit niemand verfügbar ist, um den Spieler wiederzubeleben.
*/

params [
    ["_corpse", objNull, [objNull]],
    ["_playerName", "", ""]
];

private _maxRespawnTime = 1800; // Maximale Zeit in Sekunden, bevor der automatische Respawn erfolgt

// Warte für die maximale Respawn-Zeit oder bis der Spieler respawned wurde
waitUntil {
    sleep 1;
    _maxRespawnTime = _maxRespawnTime - 1;

    // Überprüfe, ob jemand den Spieler wiederbelebt hat
    if (alive _corpse) exitWith { true };

    // Überprüfe, ob die maximale Respawn-Zeit erreicht wurde
    _maxRespawnTime <= 0
};

// Wenn der Spieler nicht wiederbelebt wurde, führe den automatischen Respawn durch
life_corpse respawn;

// Optional: Füge hier weitere Aktionen hinzu, die nach dem Respawn ausgeführt werden sollen
