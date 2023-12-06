/*
  Dieses Skript erstellt eine Meldung basierend auf der Entfernung des Spielers zur Sperrzone.
*/

// Entfernung des Spielers zur Sperrzone berechnen und runden
private _text = round(player distance2D (getMarkerPos (format ["stig_sz_markerA%1", _this])) - (getMarkerSize (format ["stig_sz_markerA%1", _this]) select 0));

// Überprüfen, ob die Entfernung negativ ist (Spieler ist in der Sperrzone)
if (_text < 0) then {
  _text = "<br/><t color='#FF0000'>WARNUNG: Du befindest dich in der Sperrzone!</t>";
} else {
  // Die Entfernung in die Meldung einfügen
  _text = format ["<br/>Die Sperrzone liegt %1 Meter von dir entfernt.", _text];
}

// Meldung generieren und anzeigen
hint parseText format ["<t size='2'><t color='#0026FF'>Sperrzone</t></t><br/>Die Einsatzleitung hat eine neue Sperrzone ausgerufen.%1 <br/><br/>Für weitere Informationen, siehe auf deine Karte.", _text];
