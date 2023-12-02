/*
    File: fn_onGameInterrupt.sqf
    Author: DomT602
    Description: Behandelt Spielunterbrechungen - z.B. wenn das ESC-Menü geöffnet ist.
*/
params [
    ["_display",displayNull,[displayNull]]
];

// Zugriff auf die Steuerelemente des ESC-Menüs
private _abortButton = _display displayCtrl 104;
private _respawnButton = _display displayCtrl 1010;
private _fieldManual = _display displayCtrl 122;
private _saveButton = _display displayCtrl 103;
private _topButton = _display displayCtrl 2;

// Deaktiviere bestimmte Steuerelemente
_abortButton ctrlEnable false;
_abortButton buttonSetAction "call SOCK_fnc_updateRequest; [player] remoteExec [""TON_fnc_cleanupRequest"",2];";
_fieldManual ctrlEnable false;
_saveButton ctrlEnable false;

// Überprüfe, ob der Spieler auf der Westseite ist oder bestimmte Bedingungen erfüllt sind
private _conditions = playerSide isEqualTo west || {!((player getVariable ["restrained",false]) || {player getVariable ["Escorting",false]} || {player getVariable ["transporting",false]} || {life_is_arrested} || {life_istazed} || {life_isknocked})};

// Deaktiviere das Wiederbeleben-Steuerlement, wenn die Bedingungen nicht erfüllt sind
if (_conditions) then {
    // Überwache die Zeit, bis der Abbruch-Button wieder aktiviert wird
    [_display,_abortButton] spawn {
        params ["_display","_abortButton"];
        private _abortTime = LIFE_SETTINGS(getNumber,"escapeMenu_timer");
        private _timeStamp = time + _abortTime;

        waitUntil {
            // Aktualisiere den Text des Abbruch-Buttons mit der verbleibenden Zeit
            _abortButton ctrlSetText format [localize "STR_NOTF_AbortESC",[(_timeStamp - time),"SS.MS"] call BIS_fnc_secondsToString];

            // Schließe das Dialogfeld, wenn eines geöffnet ist
            if (dialog && {isNull (findDisplay 7300)}) then {closeDialog 0};

            // Überprüfe, ob die Zeit abgelaufen ist oder der Spieler nicht mehr lebt
            (_timeStamp - time) <= 0 || {isNull _display || {!alive player}}
        };

        // Beende den Prozess, wenn der Spieler nicht mehr lebt
        if (!alive player) exitWith {};

        // Aktiviere den Abbruch-Button wieder und ändere den Text
        _abortButton ctrlSetText localize "STR_DISP_INT_ABORT";
        _abortButton ctrlEnable true;
    };
} else {
    // Deaktiviere das Wiederbeleben-Steuerlement, wenn die Bedingungen nicht erfüllt sind
    _respawnButton ctrlEnable false;    
};
