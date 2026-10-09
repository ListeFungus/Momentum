# Momentum – Phase 20: Private Nutzung und Testphase

Stand: 8. Oktober 2026  
Status: Testvorbereitung im Dialog begonnen; praktischer Teststart noch offen

## Ziel

Die App soll vor dem öffentlichen Store-Release zuerst real privat genutzt und
danach gegebenenfalls an wenige bekannte Tester gegeben werden. Ziel ist, echte
Alltagsprobleme zu finden, bevor die App öffentlich sichtbar ist.

## Geplanter Ablauf

### Arbeitsweise für die begleitete Testphase

- Der Nutzer testet erstmals eine eigene App. Dieser Chat begleitet die
  Vorbereitung, die einzelnen Testschritte und die Einordnung von Problemen.
- Entscheidungen und Testanweisungen werden hier festgehalten; tatsächliche
  Beobachtungen und Nachtests kommen in den Verlauf. Noch keine Testbefunde.
- Fragen auf grundlegende oder aktuell blockierende Unklarheiten beschränken.
  Kleine, leicht änderbare Details sammeln. Keine vollständige Neuplanung der App.
- Code und Fachdokumente passend zum nächsten Test oder Befund nachlesen.
  Umfangreiche Audits oder Untersuchungen vorher hinsichtlich Nutzen und
  Kontingent mit dem Nutzer abstimmen.
- Bei Problemen zunächst klären, was passiert ist und was erwartet wurde.
  Anschließend zwischen Fehlerbehebung, Bedienungsverbesserung und neuer Idee
  unterscheiden; größere Umsetzungspakete für einen anderen Chat vorbereiten.

### Ausgangslage am 8. Oktober 2026

- Phase 19 ist laut Abschlussprotokoll abgeschlossen: 142 Tests und die
  vollständige Analyse waren dort erfolgreich. In diesem Planungsdialog wurden
  diese Prüfungen nicht erneut ausgeführt. Für den Phase-19-Abschluss wurde kein
  manueller Gerätetest dokumentiert.
- Der Code verwendet eine lokale Drift-Datenbank, Schema 22. Phase 19 enthält
  keine aktive Cloud-Synchronisierung; Sync-Vorbereitung ist keine Datensicherung.
- Die Terminverarbeitung wird bei App-Start, Rückkehr in die App und Tageswechsel
  angestoßen. Diese Übergänge sind deshalb sinnvolle praktische Testfälle.
- Bisherige Sichtung: Dokumentationsstruktur, zentrale Arbeitskarte, Fachbegriffe,
  Phase 20, Phase-19-Abschluss, Phase-21-Abgrenzung sowie ausgewählte Stellen für
  App-Start, Navigation und Datenhaltung. Kein vollständiger Code-/Dokumentenaudit.

### Vorschlag für den Einstieg – noch abzustimmen

1. Testgerät, installierten App-Stand und vorhandene Daten klären; daraus einen
   passenden Installations-/Updateweg und Umgang mit Testdaten ableiten.
2. Einen kurzen begleiteten Funktionstest mit wenigen Beispielen durchführen:
   anlegen, beantworten, erneut öffnen, Auswertung nachvollziehen. Weitere
   Risikofälle wie Bearbeitung, Tageswechsel und Wiederherstellung gezielt ergänzen.
3. Danach echte Alltagsnutzung; Auffälligkeiten knapp mit Schritten,
   erwartetem/tatsächlichem Verhalten, Datum und Teststand dokumentieren.
4. Schwere Probleme vor weiterer betroffener Nutzung klären; kleinere Punkte
   bündeln. Nach einer Korrektur den ursprünglichen Fehlerfall erneut prüfen.
5. Erst anhand dieser Erfahrungen über einen kleinen externen Testkreis entscheiden.

Testgerät: eigenes Android-Handy (vom Nutzer bestätigt). Modell, Android-Version
und eine möglicherweise vorhandene Momentum-Installation sind noch nicht bekannt.
Für den Einstieg wird eine APK aus dem aktuellen Projektstand erstellt und zur
manuellen Installation bereitgestellt. Die Installation auf dem Handy und der
erste erfolgreiche Start müssen anschließend vom Nutzer bestätigt werden.

Bei späteren Updates vorhandene Testdaten erhalten: eine bestehende Installation
nicht vorsorglich deinstallieren oder ihre App-Daten löschen. Bei einem
Installationskonflikt zuerst die genaue Meldung prüfen.

### Bestehende Phasenschritte

| Schritt | Inhalt | Status |
|---:|---|---|
| 20.1 | Eigene Nutzung über mehrere Tage oder Wochen | offen |
| 20.2 | Probleme, fehlende Pflichtfunktionen und verwirrende Stellen sammeln | offen |
| 20.3 | Entscheiden, ob ein kleiner Bekannten-Test sinnvoll ist | offen |
| 20.4 | Testumfang, Feedbackfragen und Abbruchkriterien festlegen | offen |
| 20.5 | Rückmeldungen auswerten und in Planung einsortieren | offen |

## Nicht Teil dieser Phase

- neue große Kernfunktionen beginnen
- Paywall final entscheiden
- Store-Release durchführen
- Details einzelner Fachthemen nachholen, die vorher in eigenen Phasen geklärt
  werden sollten
