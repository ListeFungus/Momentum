# Momentum – Phase 21: Bereits umgesetzte Änderungen

Stand: 16. Oktober 2026

Status: Beide Pakete automatisiert geprüft; Gerätenachtest des Kartenpakets offen

Dieses Dokument unterscheidet das aus Phase 20 übernommene erste Paket
(`7263ea9`) und das anschließend hier ausgearbeitete Kartenpaket. Die weitere
Themenplanung steht im [Arbeitsplan](test_improvements_plan.md).

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

