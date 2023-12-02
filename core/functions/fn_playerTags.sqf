/*
    Datei: fn_playerTags.sqf
    Autor: Bryan "Tonic" Boardwine

    Beschreibung:
    Fügt den Tags über den Köpfen anderer Spieler hinzu, wenn sie sich in der Nähe befinden und sichtbar sind.
*/
#define iconID 78000
#define scale 0.8

// Überprüfen, ob die Karte sichtbar ist oder der Spieler tot ist oder ein Dialog aktiv ist
if (visibleMap || {!alive player} || {dialog}) exitWith {
    500 cutText["","PLAIN"];
};

// Initialisiere das UI-Element für die Namens-Tags
private _ui = uiNamespace getVariable ["Life_HUD_nameTags",displayNull];
if (isNull _ui) then {
    500 cutRsc["Life_HUD_nameTags","PLAIN"];
    _ui = uiNamespace getVariable ["Life_HUD_nameTags",displayNull];
};

// Finde Einheiten in der Nähe des Spielers
private _units = nearestObjects[(visiblePosition player),["CAManBase","Land_Pallet_MilBoxes_F","Land_Sink_F"],50];
_units = _units - [player];

// Hole die Liste der Masken aus den Einstellungen
private _masks = LIFE_SETTINGS(getArray,"clothing_masks");

private _index = -1;
{
    private "_text";
    _idc = _ui displayCtrl (iconID + _forEachIndex);

    // Überprüfe, ob eine Sichtlinie besteht und die Einheit lebendig ist und eine "realname" Variable hat
    if (!(lineIntersects [eyePos player, eyePos _x, player, _x]) && alive _x && {!isNil {_x getVariable "realname"}}) then {
        _pos = switch (typeOf _x) do {
            // Berechne die Position basierend auf dem Typ der Einheit
            case "Land_Pallet_MilBoxes_F": {[visiblePosition _x select 0, visiblePosition _x select 1, (getPosATL _x select 2) + 1.5]};
            case "Land_Sink_F": {[visiblePosition _x select 0, visiblePosition _x select 1, (getPosATL _x select 2) + 2]};
            default {[visiblePosition _x select 0, visiblePosition _x select 1, ((_x modelToWorld (_x selectionPosition "head")) select 2)+.5]};
        };
        _sPos = worldToScreen _pos;
        _distance = _pos distance player;

        // Überprüfe, ob die Einheit eine Maske trägt
        if (!((headgear _x) in _masks || (goggles _x) in _masks || (uniform _x) in _masks)) then {
            // Überprüfe, ob die Einheit innerhalb von 15 Metern ist
            if (count _sPos > 1 && {_distance < 15}) then {
                _text = switch (true) do {
                    // Zivilisten grün, wenn sie in der Gruppe des Spielers sind
                    case (_x in (units group player) && playerSide isEqualTo civilian): {format ["<t color='#00FF00'>%1</t>",(_x getVariable ["realname",name _x])];};
                    // Polizei mit blauem Rangtext
                    case (side _x isEqualTo west && {!isNil {_x getVariable "rank"}}): {format ["<t color='#0000FF'>[%1] %2</t>",_x getVariable ["rank", ""], _x getVariable ["realname",name _x]];};
                    // Unabhängige (Mediziner) mit rötlichem Rangtext ab dem Rang Paramedic TODO RÄNKE
                    case (side _x isEqualTo independent): {format ["<t color='#FF0000'>[%1] %2</t>", switch ((_x getVariable "rank")) do {
                        case 1: {"Paramedic"};
                        case 2: {"EMT"};
                        case 3: {"EMT-I"};
                        case 4: {"Paramedic Supervisor"};
                        default {""}; // Kein Rang für Rang 0 oder unbekannten Rang
                    }, _x getVariable ["realname",name _x]];};
                    default {
                        // Bandenmitglieder mit Bandennamen
                        if (!isNil {(group _x) getVariable "gang_name"}) then {
                            format ["%1<br/><t size='0.8' color='#B6B6B6'>%2</t>",_x getVariable ["realname",name _x],(group _x) getVariable ["gang_name",""]];
                        } else {
                            // Ansonsten einfach den Spielernamen anzeigen
                            if (alive _x) then {
                                _x getVariable ["realname",name _x];
                            } else {
                                // Wenn nicht lebendig, den Spielernamen oder "ERROR" anzeigen
                                if (!isPlayer _x) then {
                                    _x getVariable ["realname","ERROR"];
                                };
                            };
                        };
                    };
                };

                // Setze strukturierten Text und Position des Namens-Tags
                _idc ctrlSetStructuredText parseText _text;
                _idc ctrlSetPosition [_sPos select 0, _sPos select 1, 0.4, 0.65];
                _idc ctrlSetScale scale;
                _idc ctrlSetFade 0;
                _idc ctrlCommit 0;
                _idc ctrlShow true;
            } else {
                // Verstecke das Namens-Tag, wenn es außerhalb des sichtbaren Bereichs oder zu weit entfernt ist
                _idc ctrlShow false;
            };
        } else {
            // Verstecke das Namens-Tag, wenn die Einheit eine Maske trägt
            _idc ctrlShow false;
        };
    } else {
        // Verstecke das Namens-Tag, wenn eine Sichtlinie besteht oder die Einheit tot ist oder keine "realname" hat
        _idc ctrlShow false;
    };
    _index = _forEachIndex;
} forEach _units;

// Setze den strukturierten Text des letzten Namens-Tags auf leer, um eventuelle Resttags zu entfernen
(_ui displayCtrl (iconID + _index + 1)) ctrlSetStructuredText parseText "";
