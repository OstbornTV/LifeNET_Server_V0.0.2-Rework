private _text = round (( player distance2D (getMarkerPos ( format ["stig_sz_markerA%1",_this]))) - ((getMarkerSize ( format ["stig_sz_markerA%1",_this])) select 0 ) );
if(_text < 0)then{
	_text = "<br/><t color='#FF0000'>WARNUNG: Du bist in der Sperrzone!</t>"
}else{
	_text = format ["<br/>Diese liegt %1 Meter von dir entfernt.",_text];
};

hint parseText format ["<t size='2'><t color='#0026FF'>Sperrzone</t></t><br/>Die Einsatzleitung hat eine neue Sperrzone ausgerufen.<br/>%1 <br/><br/>Für weitere Informationen, siehe auf deine Karte.",_text];
