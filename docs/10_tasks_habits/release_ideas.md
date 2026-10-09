# Momentum - Aufgaben/Habits: Ideen vor dem ersten Release

Stand: 25. Juli 2026  
Status: Ideenpool, noch nicht priorisiert

## Zweck

Dieses Dokument sammelt Ideen, die vor dem ersten App-Release diskutiert werden
sollten. Eine Idee in diesem Dokument ist noch keine Zusage fuer den Release.
Sie verhindert nur, dass gute Gedanken im Chat verloren gehen.

Wenn eine Idee fuer den ersten Release entschieden wird, wird sie in die
passende Phase im Arbeitsplan verschoben. Wenn sie bewusst spaeter kommt, bleibt
sie hier oder wandert in den allgemeinen Ideenparkplatz.

## Release-Ideen

| Idee | Beschreibung | Moeglicher Nutzen | Status |
|---|---|---|---|
| Paywall fuer Auswertungs-Detailgrad | Einfache Auswertungen bleiben frei; detaillierte Trends, Projektanalysen, Zielverlaeufe oder tiefere Vergleiche koennten bezahlt sein. | Monetarisierung ohne die Grundnutzung zu blockieren. | pruefen |
| Paywall fuer eigene Aufgaben-/Habit-Erstellung | Kostenlose Nutzung waere auf vorgefertigte Aufgaben und Habits begrenzt; detaillierte eigene Erstellung waere bezahlt. | Klare Free/Paid-Grenze, aber Risiko: Kernnutzen der App wirkt eingeschraenkt. | pruefen |
| Vorgefertigte Aufgaben und Habits | Starter-Vorlagen fuer typische Bereiche wie Gesundheit, Haushalt, Lernen, Training oder Schlaf. | Schneller Einstieg, besonders fuer Testnutzer. | pruefen |
| Private Testphase ohne Store-Sichtbarkeit | App zuerst selbst nutzen und danach an wenige bekannte Tester geben, bevor sie oeffentlich im Store sichtbar wird. | Echtes Nutzungsfeedback mit geringem Risiko. | fuer Phase 19 vorgesehen |
| Logbuch-Ansicht fuer reine Trackings | Reine Trackings koennten spaeter zusaetzlich in einer eigenen Logbuch-Ansicht gesammelt werden. Phase 12 nutzt zunaechst eine Tracking-Gruppe im Habits-Tab. | Schlankere Tagesansicht, falls sehr viele Messwerte entstehen. | spaeter pruefen |
| Tracking-Erinnerungen ohne Pflichtlogik | Fuer reine Trackings koennte spaeter eine Erinnerung wie "spaetestens alle 10 Tage wiegen" existieren, ohne daraus direkt eine Pflichtaufgabe zu machen. | Nutzer erinnert sich an seltenere Messwerte, ohne Missed-Policy-Druck. | spaeter pruefen |
| Mehrere Sessions pro Tracking-Tag | Ein Tracking koennte spaeter mehrere Tagesereignisse speichern, z. B. 3x 10 Minuten Spazieren, und daraus einen Tageswert summieren. | Genauere Protokolle, Timer- und Session-Auswertung. | spaeter pruefen |
| Eigene Einheitenverwaltung | Nutzende koennen eigene Einheiten anlegen und beim Erstellen auswaehlen, statt Freitext jedes Mal neu zu tippen. | Weniger Tippfehler, bessere Auswertung und spaeter strengere Kompatibilitaetspruefung ueber Einheiten-IDs. | spaeter pruefen |
| Monats- und Jahres-Blockansicht | Auswertung als Kalenderansicht mit Tagesbloecken, z. B. Monatszeilen mit 28 bis 31 kleinen Bloecken und spaeter Jahresueberblick. Die Darstellung nutzt `scheduledDate` und vorhandene Tages-/Zieldaten, ist aber kein eigener Zieltyp. | Macht langfristige Muster sichtbar, ohne das Zielmodell auf Kalendermonate festzulegen. | spaeter pruefen |
| Typische Habit-Streaks | Aktuelle Serie, laengste Serie und Unterbrechungen fuer einzelne Aufgaben oder Habits anzeigen. Fuer den Release kann ein 7-von-7-Ziel den einfachen Nicht-Unterbrechen-Fall abdecken; echte Streak-Auswertungen bleiben ein eigener spaeterer Ausbau. | Motiviert Nutzende und macht Kontinuitaet sichtbar, braucht aber eigene Regeln fuer `no_entry`, Puffer, Carryover, Nachtraege und Wert-Trackings. | spaeter pruefen |
| Mehrere Ziele pro Aufgabe | Eine Aufgabe koennte spaeter mehrere Zielperspektiven gleichzeitig haben, z. B. kurzfristig 5 von 7 in den letzten 7 Tagen und laengerfristig mindestens 80 % in den letzten 30 Tagen. Phase 14 v1 bleibt bei einem aktiven Ziel pro Aufgabe. | Erlaubt bessere Balance aus Tagesdruck und langfristigem Trend, erhoeht aber Datenmodell-, UI- und Priorisierungsaufwand. | spaeter pruefen |

## Offene Fragen zur Monetarisierung

1. Soll die erste oeffentliche Version schon eine echte Bezahlfunktion enthalten
   oder nur fachlich so vorbereitet sein, dass sie spaeter ergaenzt werden kann?
2. Welche Funktion ist der Kernnutzen, der kostenlos erlebbar bleiben muss?
3. Welche Grenze fuehlt sich fair an: Auswertungstiefe, Anzahl eigener
   Aufgaben/Habits, Projektanzahl, Vorlagen oder Sync?
4. Muss die Paywall vor dem Store-Release rechtlich, technisch und UX-seitig
   vollstaendig geklaert sein?

## Pflege

- Neue Chat-Ideen zuerst hier ergaenzen.
- Bei Entscheidung in den passenden Phasenplan verschieben.
- Keine Paywall-Regel stillschweigend implementieren, bevor die Free/Paid-
  Grenze als Produktentscheidung bestaetigt ist.
