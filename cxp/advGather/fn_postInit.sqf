/*
	Author: Casperento
	
	Description:
	Initializes system's markers to detect which zone a player is in

	This code is provided by CXP SCRIPTS on https://bytex.market/sellers/profile/K970748533
*/
// Initialisiere das Array für Zonennamen
cxpadg_zonesNames = [];

// Lese die Konfigurationen aus der Missionskonfiguration
private _rootConfig = missionConfigFile >> "Cxp_Config_AdvGather";

// Iteriere über Konfigurationen und erstelle Marker für Zonen
private "_mk";
private "_mkName";
private "_currCfg";
private "_type";
private "_zoneMkName";
private "_zoneMkSize";
{
	if !(isClass _x) then {continue};
	_type = configName _x;
	{
		_currCfg = configName _x;
		_zones = getArray(_x >> "zones");
		if (count _zones isEqualTo 0) then {
			diag_log format["Empty 'zones' array found for '%1' class...", _currCfg];
			continue;
		};

		{
			_zoneMkName = _x # 0;
			_zoneMkSize = _x # 1;
			if !(_zoneMkName in allMapMarkers) then {
				diag_log format["Marker not found: %1...", _zoneMkName];
				continue;
			};

			// Erstelle den Marker mit einem eindeutigen Namen
			_mkName = format["cxpadg@zone@%1@%2@%3", _type, _currCfg, _zoneMkName];
			cxpadg_zonesNames pushBack _mkName;
			_mk = createMarkerLocal [_mkName, getMarkerPos _zoneMkName];
			_mk setMarkerSizeLocal [_zoneMkSize, _zoneMkSize];
			_mk setMarkerShapeLocal "ELLIPSE";
			_mk setMarkerAlphaLocal 0;
			false
		} count _zones;
		false
	} count ("true" configClasses _x);
	false
} count ("true" configClasses _rootConfig);

// Setze eine Flagge, dass der Vorgang gestartet wurde
cxpadg_started = true;
