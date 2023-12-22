/*
	Author: Casperento
	
	Description:
	Store selected item into player's backpack

	This code is provided by CXP SCRIPTS on https://bytex.market/sellers/profile/K970748533
*/
params [
	["_varName", "", [""]],
	["_weight", 0, [-1]],
	["_amount", 0, [-1]]
];

// Überprüfen, ob das Menü geöffnet ist und die erforderlichen Parameter vorhanden sind
if (isNil "cxpadg_menuOpened" || _varName isEqualTo "" || _amount isEqualTo 0 || _weight isEqualTo 0) exitWith {false};

// Konstruiere den Variablennamen
private _varName = "life_inv_" + _varName;

// Ermittle die aktuelle Menge des Elements
private _currentAmount = missionNamespace getVariable [_varName, 0];

// Berechne die Gesamtmenge und das Gesamtgewicht
private _totalAmount = _currentAmount + _amount;
private _totalWeight = _amount * _weight;

// Überprüfe, ob das Gesamtgewicht die maximale Traglast überschreitet
if (_totalWeight + life_carryWeight > life_maxWeight) exitWith {false};

// Aktualisiere die Variable in der Mission Namespace und das Tragegewicht des Spielers
missionNamespace setVariable [_varName, _totalAmount];
life_carryWeight = life_carryWeight + _totalWeight;

// Erfolgreiche Ausführung der Funktion
true
