/*
    File: fn_setupStationService.sqf
    Author: NiiRoZz
    Edit: BoGuu - Added Tanoa Stations

    Description:
    Add action fuel action in Station Service.

    put function in init file then execute it with:
    call getFuelpumps;
*/

// Funktion, um Treibstoffpumpen zu erstellen und Aktionen hinzuzufügen
getFuelpumps =
{
    private _wl_roschePositions = [
        // Hier können weitere Positionen hinzugefügt werden, wenn nötig
    ];

    private _stationPositions = [[["WL_Rosche", _wl_roschePositions]]] call life_util_fnc_terrainSort;

    {
        private _pump = nearestObjects [_x, ["Land_fs_feed_F", "Land_FuelStation_01_pump_F", "Land_FuelStation_02_pump_F"], 5] select 0;
        _pump setFuelCargo 0;

        // Füge Aktion hinzu, um den Treibstoffvorgang zu starten
        _pump addAction [localize "STR_Action_Pump", life_fnc_fuelStatOpen, 1, 3, true, true, "", '_this distance _target < 5 && cursorObject isEqualTo _target'];

        false
    } forEach _stationPositions;

    hint "Completed"; // Hinweis für den Abschluss
};

// Aufruf der Funktion
call getFuelpumps;
