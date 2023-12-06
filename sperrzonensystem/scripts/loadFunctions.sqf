/*
  Dieses Skript lädt alle Funktionen in Variablen.
*/

// Liste der zu ladenden Funktionen
["_add", "_del", "_find", "_hideGUI", "_msg_add", "_msg_del"] params ["_function"];

// Iteration über die Funktionen
{
  // Kompiliere und weise die Funktion der entsprechenden Variable zu
  call compile format [
    "%1 = compileFinal preprocessfilelinenumbers ""%2functions\stig_sz_%1.sqf""",
    _x,
    stig_sz_root
  ];
} forEach [
  "add",
  "del",
  "find",
  "hideGUI",
  "msg_add",
  "msg_del"
];