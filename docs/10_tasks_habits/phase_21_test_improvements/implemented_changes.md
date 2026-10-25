# Momentum – Phase 21: Bereits umgesetzte Änderungen

Stand: 22. Oktober 2026

Status: #013, #002, bestehende Pakete und Kalender automatisiert geprüft; Gerätenachtests separat offen. Bestehende Kalender-APK 1.0.0+4 enthält #002/#013 nicht.

Dieses Dokument unterscheidet das aus Phase 20 übernommene erste Paket
(`7263ea9`), das Kartenpaket und den Kalender. Die weitere
Themenplanung steht im [Arbeitsplan](test_improvements_plan.md).

## Paket #013 – Aufgabenart Aufgabe ↔ Habit ändern

Am 22. Oktober A0–A5 umgesetzt. **212 Tests bestanden** im vollständigen Lauf
(65 Sekunden), gezielte Analyse von 17 Dateien ohne Befunde.

- Bearbeiten → Aufgabenart → **Art ändern**, Umfang ausdrücklich auswählen.
  Vorhandene Einträge behalten wahlweise ihre Art oder werden rückwirkend
  umgeordnet. Identität, Werte, Rhythmus, Ziele, Kalenderzeiten und #002 bleiben erhalten.
- Sperrmatrix im Schreibpfad und Dialog; aktuelles Laden auch von historischen
  Karten, Schutz ungespeicherter Formulare, veralteter Vorschauen und atomarer Rollback.
- Historische Typfilter in Listen/Scheduler; aktueller Projektbestand getrennt
  von historischer Eintragszuordnung. Detailhinweis auf letzten Artenwechsel.
- Schema 25: Artenwechselprotokoll, 20 Tabellen im Backup, Restore 22–25.
  Kalenderlesen bleibt schreibfrei; keine neue APK und kein anderes Paket umgesetzt.

Prüfdetails und **noch offener Gerätenachtest** im
[#013-Umsetzungsplan](task_type_change_implementation_plan.md#prüfnachweis-und-gerätenachtest--22-oktober-2026).

## Paket #002 – Startdatum nach Erstellung bearbeiten

Am 22. Oktober implementiert und automatisiert geprüft: **184 Tests bestanden**
mit `flutter test --no-pub --concurrency=2 --timeout=2m` (63 Sekunden).
Gezielte Analyse der 11 betroffenen/neuen Dateien: keine Befunde.
Neun neue #002-Tests decken Daten-/Formularfälle und laufende Streams ab.
Ein vorhandener Zielhistorientest erhielt ausschließlich eine kalenderfeste
Datumsrechnung für den Test über die Zeitumstellung; keine Statuszielregel geändert.

- Freigegeben: reine Werttracker ohne Missed-Policy/Abschlussabstände, auch mit
  täglicher Anzeige oder Wertziel. Aktuelle, historische und vorgemerkte Regeln
  sowie vorhandene Instanzen werden vor dem Schreiben geprüft.
- Terminserien, frühere verpflichtende Planung, widersprüchliche End-/Fälligkeits-
  grenzen und Papierkorb bleiben gesperrt. Gleichzeitige Formularänderungen
  umgehen die Sperre nicht; ein abgewiesenes Update bleibt atomar ohne Teilstand.
- Neue Startgrenze gilt für erwartete Messungen. Vorhandene Werte behalten ID,
  Datum, Einheit und Definition; Korrektur/Undo bleiben möglich. Frühere neue
  Nachträge nutzen die früheste Definition, keine nachträgliche Messkonfiguration.
- Kalender, Gesamter Verlauf, feste/custom Zeitfenster und Bündel (inklusive
  Tagversatz/Teilmessung) behalten echte Messwerte vor dem neuen Start. Keine
  künstlichen fehlenden Tage davor; Pausen/Ende und Bündelgültigkeit bleiben gültig.
- Schema 24 unverändert; Export/Restore umfasst weiterhin die gesamte Historie.
  Kein APK-Build, keine Umsetzung von #013 oder anderen Paketen.

Technische Ausführung: Bei identischem Versionszeitpunkt entscheidet zusätzlich
die Versionsnummer über das aktuelle Ziel. Wertauswertungsstreams reagieren auch
auf Aufgaben-/Definitions-/Pausenänderungen, nicht nur Messwertänderungen.

**Kurzer Gerätenachtest (noch offen):** Gewichtstracker bearbeiten → Beginn früher
setzen → älteren Wert erfassen. Beginn wieder hinter den Wert setzen: Verlauf,
passendes Zeitfenster und Kalender müssen ihn behalten, leere Tage davor dagegen
nicht als erwartet zählen. Alten Wert korrigieren/Undo prüfen. Bei verpflichtender
Terminserie muss das Startfeld mit Sperrgrund deaktiviert bleiben. Abbrechen
ändert nichts. Die vorhandene Kalender-APK enthält #002 noch nicht.

## Kalender #018/#017/T20-01 – K0–K7

Aktueller zusätzlicher Stand: **Kalender K0–K7** am 21. Oktober umgesetzt,
Schema 24 und APK `1.0.0+4`, 174 Tests und Analyse grün. Eigener Menüpunkt mit
Tag/Woche/Monat/Liste, standardmäßig nur Aufgaben, persistente Filter,
schreibfreie Zukunft und getrennte Überfällig-/Undatiert-/Unbestimmt-Listen.
Optionale Planungsdauer/Start/Ende sind keine Messwerte; Serienänderungen ab
morgen, freie offene Einzeltermine direkt per Dialog/Drag/Resize. Sperren werden
transaktional erzwungen. Schema-22/23-Sicherungen bleiben importierbar.
Details und Grenzen: [Kalenderplan](calendar_implementation_plan.md).
Artefakt und offene manuelle Abnahme: [Kalender-Nachtest](calendar_retest.md).
Keine Umsetzung weiterer Phase-21-Themen und kein Store-Release.

## Kartenpaket #003/#015 – Optionen und kompakte Karten

Umgesetzt am 16. Oktober 2026; Android-Version `1.0.0+3`, Datenbankschema 23.
Geräteinstallation und Nachtest dieses neuen Pakets sind noch nicht bestätigt.

- Seitenleiste → Optionen → Kartenanzeige: „Kompakt starten“, „Aufgeklappt
  starten“, „Letzten Zustand merken“. Standard kompakt, mehrere Karten erlaubt.
- Schalter „Nur eine Karte gleichzeitig aufklappen“; bei aufgeklapptem Start
  deaktiviert, gespeicherte Auswahl bleibt für andere Modi erhalten.
- Normale Karten behalten direkte Eingabe; Beschreibung und Kartenkennzahlen
  erscheinen aufgeklappt. Bündel zeigen kompakt Status und Ergebnis, aufgeklappt
  beide Werteingaben. Eingabeentwürfe bleiben beim Einklappen erhalten.
- Dauerhafter Zustand je Aufgabe/Bündel, unabhängig vom Datum. Einzelkartenmodus
  speichert automatisches Schließen; neue Karten beginnen kompakt.
- Zwei zusätzliche Präferenztabellen, insgesamt 18 Tabellen. Alte Schema-22-
  Sicherungen bleiben importierbar und erhalten Standard-Anzeigeeinstellungen.
  Neue Sicherungen enthalten die Einstellungen und gemerkten Zustände; die alte
  App-Version kann diese Schema-23-Sicherungen nicht importieren.
- Aufgaben, Einträge und Historie werden durch die Anzeigeoptionen nicht verändert.
- Abschließender vollständiger Testlauf: **156 Tests erfolgreich**, Analyse
  fehlerfrei; Standards- und Spec-Review jeweils ohne relevante Findings.
  Testbericht lokal `build/phase21-tests.json` (nicht versioniertes Artefakt).
- Release-APK `build/app/outputs/flutter-apk/app-release.apk`, 28.073.652 Bytes.
  SHA-256: `490E7935A46E603C27004F1D1142D15ED348D4F4F1FA15DD4E3CE6D33F290951`.
  Anwendungskennung und Signaturkonfiguration unverändert.

### Kurzer Gerätenachtest für Version 1.0.0+3

1. APK über die vorhandene Installation installieren; vorhandene Aufgaben prüfen.
2. Unter Optionen → Kartenanzeige alle drei Modi ausprobieren. In der Tagesansicht
   normale Karten und ein Bündel öffnen/schließen; direkte Eingabe prüfen.
3. Einzelkartenmodus aktivieren: Beim Öffnen einer anderen Karte schließt die
   vorherige. Angefangenen Bündelwert nach erneutem Öffnen kontrollieren.
4. „Letzten Zustand merken“ wählen, Karte öffnen, Datum wechseln und App neu
   starten. Die Aufgabe/das Bündel bleibt geöffnet, soweit an diesem Tag sichtbar.
5. Neue Sicherung nach Drive exportieren. Die vorhandene ältere Sicherung behalten;
   ein manueller Restore ist für diesen kurzen Nachtest nicht erforderlich.

## Erstes Paket #001/#007/#014 – historischer Abnahmestand

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

Nutzerrückmeldung am 16. Oktober: Die neue Version ist installiert und eine
Sicherungsdatei nach Google Drive exportiert. Damit sind Installation und externer
Export praktisch bestätigt. Bestandsprüfung, Datumsauswahl, Diagramm und eine
manuelle Wiederherstellung wurden noch nicht ausdrücklich bestätigt. Der Agent
hat die Sicherungsdatei nicht eingesehen oder geprüft.

Automatisierte Abnahme am 16. Oktober: **149 Tests bestanden**, vollständige
statische Analyse ohne Probleme, Release-APK `1.0.0+2` erfolgreich gebaut.

