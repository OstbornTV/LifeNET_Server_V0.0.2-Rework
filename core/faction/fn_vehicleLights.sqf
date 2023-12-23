/*
    File: fn_vehicleLights.sqf
    Author: OsbornTV

    Description:
    Adds the light effect to cop and medic vehicles with day and night light effects.
*/

// Parameter definieren
params [
    ["_vehicle", objNull, [objNull]],   // Das Fahrzeug, dem Licht hinzugefügt werden soll
    ["_lightTime", 0.22, [0]]            // Die Blinkfrequenz der Lichter
];

// Überprüfen, ob das Fahrzeug gültig ist
if (isNil "_vehicle" || {isNull _vehicle || {!(_vehicle getVariable "lights")}}) exitWith {};

// Mod-Abhängigkeit überprüfen
private _modPresent = isClass (configFile >> "CfgVehicles" >> "LifeNET_BlueLight");

// Lichtfarben definieren
private _lightDay = [0.2, 0.2, 1];       // Farbe für den Tag
private _lightNight = [0.1, 0.1, 1];     // Farbe für die Nacht

// Überprüfen, ob es Tag oder Nacht ist
private _isDay = dayTime > 6 && dayTime < 18;

// Variablen für Lichter deklarieren
private _lightLeft;
private _lightRight;

// Mod-spezifisches Verhalten basierend auf Überprüfung
if (_modPresent) then {

    // Fahrzeugliste mit Balkenpositionen (X, Y, Z)
    private _vehicleBarPositions = [
        ["C_Offroad_01_F", [-1, 0, 0]],     // Position für Offroad-Fahrzeuge
        ["C_SUV_01_F", [0, -1.2, 0.42]]     // Position für SUV-Fahrzeuge
    ];

    // Balkenposition für das aktuelle Fahrzeug abrufen
    private _barPosition = []; // Standardwert, wenn das Fahrzeug nicht in der Liste ist
    {
        if (typeOf _vehicle isEqualTo (_x select 0)) then {
            _barPosition = _x select 1;
        };
    } forEach _vehicleBarPositions;

    // Abbruch, wenn die Positionen nicht korrekt gesetzt wurden
    if (count _barPosition isEqualTo 0) exitWith {
        diag_log format ["Vehicle emergency lights not set for: %1", _vehicle];
        hint localize "STR_NOTF_ELSNotSet";
    };

    // Mod-spezifisches Verhalten hinzufügen (zum Beispiel einen Balken erstellen)
    private [_bar] = ["Land_ConcreteWall_02_m_8m_F" createVehicleLocal getPos _vehicle, [0, 0, 0]];

    // Position anpassen
    _bar setPosATL [(getPosATL _vehicle select 0) + (_barPosition select 0), (getPosATL _vehicle select 1) + (_barPosition select 1), (getPosATL _vehicle select 2) + (_barPosition select 2)];

    // Lichter erstellen und konfigurieren
    _lightLeft = "#lightpoint" createVehicleLocal getPos _bar;
    _lightRight = "#lightpoint" createVehicleLocal getPos _bar;

    _lightLeft lightAttachObject [_bar, [-0.5, 0, 0]];
    _lightRight lightAttachObject [_bar, [0.5, 0, 0]];

} else {
    // Fallback-Verhalten, wenn die Mod nicht installiert ist
    private (_leftOffset isEqualTo [-1] || _rightOffset isEqualTo [-1]) = (switch (typeOf _vehicle) do {
        case "C_Offroad_01_F": { [-0.37, 0.0, 0.56], [0.37, 0.0, 0.56] };           // Offset für Offroad-Fahrzeuge
        case "B_MRAP_01_F": { [-0.37, -1.9, 0.7], [0.37, -1.9, 0.7] };              // Offset für MRAP-Fahrzeuge
        case "C_SUV_01_F": { [-0.37,-1.2,0.42], [0.37,-1.2,0.42] };                 // Offset für SUV-Fahrzeuge
        case "C_Hatchback_01_sport_F": { [-0.35,-0.2,0.25], [0.35,-0.2,0.25] };     // Offset für Sportwagen
        default { [-1, -1] };    // Standard-Offset, wenn nicht definiert
    });

    // Abbruch, wenn die Positionen nicht korrekt gesetzt wurden
    if (_leftOffset && _rightOffset isEqualTo [-1]) exitWith {
        diag_log format ["Vehicle emergency lights not set for: %1", _vehicle];
        hint localize "STR_NOTF_ELSNotSet";
    };

    // Licht erstellen und konfigurieren
    _lightLeft = "#lightpoint" createVehicleLocal getPos _vehicle;
    _lightRight = "#lightpoint" createVehicleLocal getPos _vehicle;
    sleep 0.2;

    // Licht mit dem Fahrzeug verbinden
    _lightLeft lightAttachObject [_vehicle, _leftOffset];
    _lightRight lightAttachObject [_vehicle, _rightOffset];
}

// Gemeinsame Konfiguration für beide Fälle
_lightLeft params [
    ["setLightColor", if (_isDay) then {_lightDay} else {_lightNight}],
    ["setLightAmbient", [0.1, 0.1, 1]],
    ["setLightAttenuation", [0.181, 0, 1000, 130]],
    ["setLightIntensity", 10],
    ["setLightFlareSize", 0.38],
    ["setLightFlareMaxDistance", 150],
    ["setLightUseFlare", true],
    ["setLightDayLight", true],
    ["setLightBrightness", 0.0]  // Hinzugefügt, um die Helligkeit zu initialisieren
];

_lightRight params [
    ["setLightColor", if (_isDay) then {_lightDay} else {_lightNight}],
    ["setLightAmbient", [0.1, 0.1, 1]],
    ["setLightAttenuation", [0.181, 0, 1000, 130]],
    ["setLightIntensity", 10],
    ["setLightFlareSize", 0.38],
    ["setLightFlareMaxDistance", 150],
    ["setLightUseFlare", true],
    ["setLightDayLight", true],
    ["setLightBrightness", 0.0]  // Hinzugefügt, um die Helligkeit zu initialisieren
];
// Wechselnde Blinklichter erstellen
private _Bluelight = true;
while {alive _vehicle} do {
    if !(_vehicle getVariable "lights") exitWith {};
    [_lightLeft, _lightRight] params [
        ["setLightBrightness", _Bluelight select [6, 0.0, 6]],
        ["setLightBrightness", _Bluelight select [0.0, 6, 0.0]]
    ];
    _Bluelight = !_Bluelight;
    sleep _lightTime;
};

// Lichter entfernen, wenn das Fahrzeug nicht mehr existiert
if (alive _vehicle) then {
    [_bar, _lightLeft, _lightRight] call {
        { deleteVehicle _x } forEach _this;
    };
};