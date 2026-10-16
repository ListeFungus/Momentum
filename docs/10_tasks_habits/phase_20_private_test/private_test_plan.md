# Momentum – Phase 20: Private Nutzung und Testphase

Stand: 16. Oktober 2026  
Status: Private Android-Nutzung und Nachtests laufen; Ausarbeitung in Phase 21

## Ziel

Die App soll vor dem öffentlichen Store-Release zuerst real privat genutzt und
danach gegebenenfalls an wenige bekannte Tester gegeben werden. Ziel ist, echte
Alltagsprobleme zu finden, bevor die App öffentlich sichtbar ist.

## Geplanter Ablauf

### Arbeitsweise für die begleitete Testphase

- Der Nutzer testet erstmals eine eigene App. Dieser Chat begleitet die
  Vorbereitung, die einzelnen Testschritte und die Einordnung von Problemen.
- Entscheidungen und Testanweisungen werden hier festgehalten; tatsächliche
  Beobachtungen stehen im [Testprotokoll](mobile_test_feedback_2026_10.md),
  Nachtests werden im Verlauf vermerkt. Konzeptentscheidungen und Umsetzungsstand stehen in Phase 21.
- Fragen auf grundlegende oder aktuell blockierende Unklarheiten beschränken.
  Kleine, leicht änderbare Details sammeln. Keine vollständige Neuplanung der App.
- Code und Fachdokumente passend zum nächsten Test oder Befund nachlesen.
  Umfangreiche Audits oder Untersuchungen vorher hinsichtlich Nutzen und
  Kontingent mit dem Nutzer abstimmen.
- Bei Problemen zunächst klären, was passiert ist und was erwartet wurde.
  Anschließend zwischen Fehlerbehebung, Bedienungsverbesserung und neuer Idee
  unterscheiden; die Ausarbeitung und Umsetzungspakete in Phase 21 dokumentieren.

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
  Phase 20, Phase-19-Abschluss, Store-Release-Abgrenzung (jetzt Phase 22) sowie ausgewählte Stellen für
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

Testgerät: eigenes Android-Handy. Installation und praktische Nutzung sind
inzwischen durch das Nutzerfeedback bestätigt. Modell, Android-Version und
genauer aktuell installierter Build sind noch nicht dokumentiert. Am 8. Oktober
wurde eine APK aus dem damaligen lokalen Projektstand bereitgestellt.

Bei späteren Updates vorhandene Testdaten erhalten: eine bestehende Installation
nicht vorsorglich deinstallieren oder ihre App-Daten löschen. Bei einem
Installationskonflikt zuerst die genaue Meldung prüfen.

### Bestehende Phasenschritte

| Schritt | Inhalt | Status |
|---:|---|---|
| 20.1 | Eigene Nutzung über mehrere Tage oder Wochen | läuft |
| 20.2 | Probleme, fehlende Pflichtfunktionen und verwirrende Stellen sammeln | läuft; 20 Punkte dokumentiert |
| 20.3 | Entscheiden, ob ein kleiner Bekannten-Test sinnvoll ist | offen |
| 20.4 | Testumfang, Feedbackfragen und Abbruchkriterien festlegen | offen |
| 20.5 | Rückmeldungen mit Quellen an Phase 21 übergeben | erfolgt; laufende Ergänzungen möglich |

## Ausarbeitung und Umsetzung in Phase 21

Die aktive Priorisierung und Ausarbeitung der Testergebnisse wird seit dem
16. Oktober in [Phase 21](../phase_21_test_improvements/README.md) geführt.
Dort stehen die vollständige Themenliste, offene Konzeptfragen, bestätigte
Regeln und der Umsetzungsstand. Neue Planung nicht parallel hier pflegen.

- [Themen und nächste Schritte](../phase_21_test_improvements/test_improvements_plan.md).
- [Bereits umgesetztes Paket und manueller Nachtest](../phase_21_test_improvements/implemented_changes.md).
- [Änderungs- und Entscheidungsverlauf](../phase_21_test_improvements/test_improvements_history.md).

Phase 20 bleibt für echte Nutzung, neue Beobachtungen und Geräte-Nachtests aktiv.
#001, #007 und #014 sind bereits implementiert. Nutzer bestätigt am 16. Oktober
das installierte Update und einen Sicherungsexport nach Google Drive; weitere
Gerätenachtests sind noch nicht ausdrücklich bestätigt.

## Nicht Teil dieser Phase

- neue große Kernfunktionen beginnen
- Paywall final entscheiden
- Store-Release durchführen
- Details einzelner Fachthemen nachholen, die vorher in eigenen Phasen geklärt
  werden sollten
