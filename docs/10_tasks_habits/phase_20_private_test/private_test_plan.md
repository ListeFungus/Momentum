# Momentum – Phase 20: Private Nutzung und Testphase

Stand: 16. Oktober 2026  
Status: Erstes Verbesserungspaket umgesetzt und automatisiert geprüft; Gerätenachtest offen

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
  Entscheidungen und Nachtests werden im Verlauf vermerkt.
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
| 20.5 | Rückmeldungen auswerten und in Planung einsortieren | begonnen; Vorschlag unten |

## Priorisierung der Testrückmeldungen am 16. Oktober 2026

**Vom Nutzer vorgegeben:** Datensicherung zuerst. Kleine Änderungen sollen in
diesem Chat abgearbeitet werden; größere Änderungen erhalten bei Bedarf einen
eigenen Konzept-/Umsetzungschat. Zunächst wird sortiert, noch keine App-Änderung
beauftragt oder ausgeführt. Die folgende Einteilung ist ein Arbeitsvorschlag;
Aufwand und Reihenfolge nach der Datensicherung sind noch nicht bestätigt.

| Reihenfolge / Paket | Feedback | Vorgehen und Grund |
|---|---|---|
| 1. Vollständiges Backup und Wiederherstellung | #014, Kernumfang | Höchste Priorität. Kurz den Produktumfang klären, technische Umsetzung separat: betrifft den gesamten Datenbestand und muss nachweisbar verlustfrei funktionieren. Lesbarer Export folgt unabhängig später. |
| 2. Kleine direkte Bedienungsverbesserung | #001 Datumsauswahl | In diesem Chat. Vorhandenen Tageszustand nutzen; Auswahlgrenzen und Rückkehr zu Heute kurz klären. Keine neue Kalenderfunktion nötig. |
| 3. Kleine Änderung nach einer Zählregel | #007 Tagesanzahl | In diesem Chat, sofern zunächst nur die gewählte Tagesansicht gemeint ist. Aufgaben/Habits, freie Tracker, Bündel und Überträge eindeutig zählen, doppelte Darstellung nicht doppelt zählen. Wochenübersicht gehört zu #018. |
| 4. Kompaktere Karten | #003 + #015 | Gemeinsam behandeln. Kleine Abstands-/Textänderungen hier; Einklappverhalten über Aufgaben-, Wert- und Bündelkarten als eigenes UI-Paket, falls es mehrere Eingabeabläufe verändert. Nicht automatisch vom großen Navigationsumbau abhängig machen. |
| 5. Historische Bearbeitungsgrenzen | #002 + #013 | Eigenes Konzept-/Umsetzungspaket. Widerspricht bisherigen Sperren aus Phase 16 P16-12. Wunsch nach alten Messwerten auch durch gezielte Nachtragfunktion prüfen, bevor das Startdatum allgemein freigegeben wird. Aufgabenartwechsel separat entscheiden. |
| 6. Tagesansicht und Tracking | #011 + #020 + A01 | Eigene kurze Konzeptklärung: Darstellung, Gruppierung und Navigation zuerst; keine neue Aufgabenart allein zur Lösung eines Anzeigeproblems voraussetzen. |
| 7. Unteraufgaben und Routinen | #010 + #004 | Eigene Konzeptklärung zu Teilabschluss, gemeinsamem Abschluss und Auswertung. Anzeigegruppen #020 bleiben unabhängig. |
| 8. Messwerte und Projekte | #005 + #006 + #012 | Getrennte aufeinander bezogene Pakete: Diagramme, Dashboards, Projektphasen. Historie und Zeitbezug vor Umsetzung klären; kein gemeinsamer Großumbau erforderlich. |
| 9. Zeit und Tagesplanung | #017 + #008 + #016 + #018 | Später in begrenzten Paketen planen. Aufwandsschätzung, Limit, Timer und Kalender sind einzeln nutzbar; gemeinsame Begriffe abstimmen. |
| 10. Optionale spätere Erweiterungen | #009 + #019 | Priorisierungsspiel und externe Kalenderanbindung zurückstellen; keine Voraussetzung für Phase 20. |
| Separater kleiner Kandidat | A02, nur Quick Task | Reine Schnellanlage einer heutigen einmaligen Aufgabe könnte nach Backup hier passen. Widgets, Quick Note und allgemeines Vorlagensystem bleiben separate Ideen. |

Die Originalbeobachtungen bleiben im Testprotokoll erhalten. Dort sind derzeit
keine reproduzierten technischen Defekte bestätigt; dies ist keine Aussage,
dass die App fehlerfrei ist. Keine neuen Chats oder GitHub-Issues in dieser
Sortierungsrunde angelegt. Kein vollständiger Audit und keine Tests ausgeführt.

### #014 – Empfohlener erster Umfang, noch abzustimmen

**Nutzerziel:** Alle vorhandenen Daten außerhalb der App sichern und nach einem
Versionswechsel beziehungsweise auf einem neuen Gerät wiederherstellen können.
Der aktuelle Code speichert lokal in Drift (Schema 22, 16 Tabellen); bei der
gezielten Sichtung wurde keine Backup-/Restore-Funktion gefunden.

- Zwei verständliche Aktionen: „Datensicherung erstellen“ und
  „Datensicherung wiederherstellen“. Eine vollständige Sicherungsdatei an einem
  vom Nutzer gewählten Ort außerhalb des internen App-Speichers ablegen,
  beispielsweise für die anschließende Kopie auf den PC.
- Alle dauerhaft gespeicherten Daten erhalten: Aufgaben/Habits, Einträge und
  Werte, Definitionshistorie, geplante Änderungen, Ziele, Projekte und
  Zuordnungen, Bündel und Versionen, Kartenpräferenzen, Korrekturen, Pausen und
  Papierkorb samt Wiederherstellungsinformationen. Beim Implementieren auch
  mögliche Daten außerhalb der Datenbank überprüfen.
- Empfehlung: Wiederherstellung ersetzt nach klarer Bestätigung den gesamten
  aktuellen Bestand durch den Sicherungsstand. Kein Zusammenführen zweier
  Datenbestände in der ersten Version; dies braucht eigene Konfliktregeln.
- Datei vor Ersetzen prüfen; beschädigte, fremde oder zu neue Dateien mit
  verständlicher Meldung ablehnen und aktuellen Bestand erhalten. Unterstützte
  ältere Sicherungen vor Verwendung auf den aktuellen Datenstand migrieren.
  Keine pauschale Garantie für beliebige zukünftige oder ältere App-Versionen.
- Konsistenten Schnappschuss erzeugen, laufende Schreibvorgänge berücksichtigen.
  Wiederherstellung gegen Teilfehler/Abbruch absichern; bisherigen Bestand bis
  zum erfolgreichen Abschluss erhalten. Nicht einfach eine geöffnete
  Datenbankdatei überschreiben.
- Abnahme: vollständiger Export-/Restore-Vergleich mit repräsentativen Daten,
  fehlerhafte/inkompatible Datei ohne Datenverlust, unterstützte ältere Sicherung,
  Neustart und normale Weiterbenutzung. Vor realen Nutzerdaten mit Testkopien
  prüfen; Automatik für Tageswechsel und Papierkorb nach Wiederherstellung
  ausdrücklich berücksichtigen.
- CSV/lesbarer Analyseexport, automatischer Backup-Zeitplan, Cloud-Sync und
  Zusammenführen sind separate Ausbauschritte. Dateiformat und konkrete
  technische Lösung werden erst im Umsetzungspaket festgelegt.

**Übergang für die bereits vorhandenen Handydaten:** Die erste Version mit
Backup muss als datenbewahrendes Update über die vorhandene App installiert
werden. Anwendungskennung und Signatur erhalten, Build eindeutig kennzeichnen;
kein vorsorgliches Deinstallieren oder Löschen der App-Daten. Für dieses erste
Update möglichst keine fachlichen Datenmodelländerungen bündeln. Nach
erfolgreichem Update zuerst sichern und die Datei außerhalb der App aufbewahren.
Eine vorhandene Sicherung der jetzigen Handydaten ist bisher nicht bestätigt.

### Beauftragtes Paket vom 16. Oktober 2026

Der Nutzer hat die Umsetzung von #014, #001 und dem nachfolgend präzisierten
#007 direkt in diesem Chat beauftragt. Die frühere Auslagerungsempfehlung für
dieses Backup-Paket ist damit überholt.

- #014: Eine Datei enthält den gesamten aktuellen Bestand; Import ersetzt
  den Bestand nach Bestätigung. Kein Zusammenführen. Eine erweiterbare
  Seitenleiste öffnet zunächst „Import & Export“.
- #001: Tippen auf das Datum der Tagesnavigation öffnet einen Date Picker.
  Nach technischem Prüfbefund T20-01 hat der Nutzer ausdrücklich zugestimmt,
  Kalender und Tagespfeile vorläufig auf heute und Vergangenheit zu begrenzen.
  Eine sichere Zukunftsvorschau bleibt ein eigenes Folgepaket.
- #007: Keine Anzahl geplanter Aufgaben. Gewünscht ist eine kompakte grafische
  Übersicht der Erledigungen an den letzten sieben Tagen in der bisherigen
  Sammelauswertung „Einmalige Aufgaben“, mit Auswahl einzelner Tage. Aufgaben
  und Habits zählen, auch wiederkehrende. Reine Tracker zählen nicht. Diese
  Abgrenzung hat der Nutzer auf Rückfrage ausdrücklich bestätigt.
- Darstellung: sieben Balken mit Zahlen; Tagesauswahl per Balken, andere
  Sieben-Tage-Zeiträume per Datumsauswahl. Bestehende Kennzahlen für einmalige
  Aufgaben behalten ihren bisherigen Umfang und Zeitraum.
- Zählung: ein positiver Abschluss pro Instanz am gespeicherten tatsächlichen
  Erledigungstag (`performedOn`), einschließlich verbindlicher Werteingaben.
  Kein Eintrag, Misserfolg, offene/wieder geöffnete Einträge und reine Tracker
  zählen nicht. Historische Erfassungsart aus der Definitionsversion verwenden.
  Papierkorbinhalte wie in den bisherigen Auswertungen ausnehmen. Ältere
  Abschlüsse ohne bekanntes Erledigungsdatum separat als nicht zuordenbar
  kennzeichnen, kein Datum erfinden.
- Erster Backup-Vertrag: JSON-Datei mit Formatkennung, Formatversion 1,
  Datenbankschema, UTC-Erstellungszeit, vollständigen Tabellen und SHA-256-Prüfsumme.
  Unverschlüsselt; Speicherung über den System-Dateidialog. Aktuell Schema 22,
  maximal 50 MB. App-Versionen mit demselben Schema können diese Sicherung lesen.
  Bei einer künftigen Schemaänderung muss ausdrücklich ein Backup-Migrationspfad
  ergänzt und getestet werden; abweichende Schemaversionen werden bis dahin
  sicher abgelehnt. Keine historischen Backups vor Einführung dieses Formats.
- Import prüft Struktur, Datentypen und Datenbank-Constraints in einer separaten
  Prüfdatenbank, ersetzt atomar in einer Transaktion und setzt die Navigation
  zurück. Keine Schemaänderung für dieses Paket. Kein Zugriff auf die echten
  Handydaten während der Entwicklung.

### Übergabe und manueller Nachtest des Verbesserungspakets

1. APK `1.0.0+2` über die vorhandene App installieren (gleiche Anwendungskennung
   und Signatur, Schema bleibt 22). Bei Installationskonflikt genaue Meldung
   prüfen; nicht deinstallieren und keine App-Daten löschen.
2. Vorhandene Einträge kurz prüfen. Seitenleiste → Import & Export → Sicherung
   exportieren; Datei außerhalb des App-Speichers speichern und auf den PC kopieren.
3. Datum antippen, vergangenen Tag auswählen und zu heute zurückgehen.
   Zukunftsauswahl und Weiter-Pfeil auf heute sind bewusst gesperrt.
4. Sammelauswertung „Einmalige Aufgaben“ öffnen: Sieben-Tage-Diagramm prüfen,
   Balken antippen, vergangenen Zeitraum auswählen. Aufgaben und Habits zählen
   nach tatsächlichem Erledigungstag, reine Tracker nicht.
5. Die Wiederherstellung wurde zunächst mit Testdaten automatisiert geprüft.
   Für einen freiwilligen manuellen Restore-Test erst eine externe Kopie der
   Sicherung aufbewahren; Bestätigungsdialog beachten. Nach Wiederherstellung
   startet die Navigation neu. Bei weiterer Nutzung gelten die normalen
   Termin- und Papierkorbregeln bezogen auf das aktuelle Datum.

Android-Systemdateidialog und Installation über die vorhandene Handyversion
müssen auf dem echten Gerät noch bestätigt werden. Die lokale Entwicklung kann
den Erhalt der tatsächlich auf diesem Handy vorhandenen Daten nicht vorab prüfen.

Automatisierte Abnahme am 16. Oktober: **149 Tests bestanden**, vollständige
statische Analyse ohne Probleme, Release-APK `1.0.0+2` erfolgreich gebaut.

## Nicht Teil dieser Phase

- neue große Kernfunktionen beginnen
- Paywall final entscheiden
- Store-Release durchführen
- Details einzelner Fachthemen nachholen, die vorher in eigenen Phasen geklärt
  werden sollten
