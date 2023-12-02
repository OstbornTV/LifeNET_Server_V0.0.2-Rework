/*
    File: fn_vehicleLights.sqf
    Author: mindstorm, 
    modified by Adanteh and on 2.12.23 OsbornTV
    Link: http://forums.bistudio.com/showthread.php?157474-Offroad-Police-sirens-lights-and-underglow

    Description:
    Adds the light effect to cop and medic vehicles with day and night light effects.
*/

// Parameter definieren
params [
    ["_vehicle", objNull, [objNull]],
    ["_lightTime", 0.22, [0]]
];

// Überprüfen, ob das Fahrzeug gültig ist
if (isNil "_vehicle" || {isNull _vehicle || {!(_vehicle getVariable "lights")}}) exitWith {};

// Lichtfarben definieren
private _lightDay = [0.2, 0.2, 1];
private _lightNight = [0.1, 0.1, 1];

// Überprüfen, ob es Tag oder Nacht ist
private _isDay = dayTime > 6 && dayTime < 18;

// Lichtfarbe entsprechend setzen
_lightLeft setLightColor (if (_isDay) then {_lightDay} else {_lightNight});
_lightRight setLightColor (if (_isDay) then {_lightDay} else {_lightNight});

// Linkes Licht erstellen und konfigurieren
private _lightLeft = "#lightpoint" createVehicleLocal getPos _vehicle;
sleep 0.2;

_lightLeft setLightColor _lightDay;
_lightLeft setLightBrightness 0.2;
_lightLeft setLightAmbient [0.1, 0.1, 1];

// Abhängig von der Seite des Spielers die Lichtfarbe und Position setzen
private [_leftOffset, _rightOffset] = (switch (typeOf _vehicle) do {
    case "C_Offroad_01_F": { [-0.37, 0.0, 0.56], [0.37, 0.0, 0.56] };
    case "B_MRAP_01_F": { [-0.37, -1.9, 0.7], [0.37, -1.9, 0.7] };
    case "C_SUV_01_F": { [-0.37,-1.2,0.42], [0.37,-1.2,0.42] };
    case "C_Hatchback_01_sport_F": { [-0.35,-0.2,0.25], [0.35,-0.2,0.25] };
    case "B_Heli_Light_01_F": { [-0.37, 0.0, -0.80], [0.37, 0.0, -0.80] };
    case "B_Heli_Transport_01_F": { [-0.5, 0.0, 0.81], [0.5, 0.0, 0.81] };
    default { [-1, -1] };
});

// Abbruch, wenn die Positionen nicht korrekt gesetzt wurden
if (_leftOffset isEqualTo [-1]) exitWith {
    diag_log format ["Vehicle emergency lights not set for: %1", _vehicle];
    hint localize "STR_NOTF_ELSNotSet";
};

// Linkes Licht mit dem Fahrzeug verbinden
_lightLeft lightAttachObject [_vehicle, _leftOffset];

// Linkes Licht konfigurieren
_lightLeft setLightAttenuation [0.181, 0, 1000, 130];
_lightLeft setLightIntensity 10;
_lightLeft setLightFlareSize 0.38;
_lightLeft setLightFlareMaxDistance 150;
_lightLeft setLightUseFlare true;

// Rechtes Licht erstellen und konfigurieren
private _lightRight = "#lightpoint" createVehicleLocal getPos _vehicle;
sleep 0.2;

// Rechtes Licht mit dem Fahrzeug verbinden
_lightRight lightAttachObject [_vehicle, _rightOffset];

// Rechtes Licht konfigurieren
_lightRight setLightAttenuation [0.181, 0, 1000, 130];
_lightRight setLightIntensity 10;
_lightRight setLightFlareSize 0.38;
_lightRight setLightFlareMaxDistance 150;
_lightRight setLightUseFlare true;

// Tageslicht für beide Lichter aktivieren
_lightLeft setLightDayLight true;
_lightRight setLightDayLight true;

// Wechselnde Blinklichter erstellen
private _leftBlue = true;
while {alive _vehicle} do {  
    if !(_vehicle getVariable "lights") exitWith {};
    if (_leftBlue) then {
        _lightRight setLightBrightness 0.0;
        sleep 0.05;
        _lightLeft setLightBrightness 6;
    } else {
        _lightLeft setLightBrightness 0.0;
        sleep 0.05;
        _lightRight setLightBrightness 6;
    };
    _leftBlue = !_leftBlue;
    sleep _lightTime;  
};

// Lichter entfernen, wenn das Fahrzeug nicht mehr existiert
deleteVehicle _lightLeft;
deleteVehicle _lightRight;