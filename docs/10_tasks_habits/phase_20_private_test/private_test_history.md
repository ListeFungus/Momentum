# Momentum - Private Nutzung und Testphase: Verlauf

Stand: 16. Oktober 2026  
Status: Praxistest auf Android läuft; erstes Verbesserungspaket umgesetzt, Gerätenachtest offen

## Zweck

Dieses Dokument hält später fest, wie die private Nutzung und der kleine
Testkreis verlaufen sind, welche Rückmeldungen entstanden sind und welche Punkte
vor dem öffentlichen Release noch relevant wurden.

## 16. Oktober 2026 – Datensicherung, Datumsauswahl und Tagesdiagramm

- Nutzer beauftragt #014, #001 und das präzisierte #007 direkt in diesem Chat.
  Wiederherstellung ersetzt den ganzen Bestand; Aufgaben und Habits zählen im
  Diagramm, reine Tracker nicht. Kein Zusammenführen von Sicherungen.
- Seitenleiste mit Import & Export ergänzt. Export aller 16 Tabellen in einer
  versionierten JSON-Datei mit Prüfsumme. Importprüfung in separater Datenbank,
  Bestätigung zum Ersetzen, atomare Wiederherstellung und Neustart der Navigation.
  Format 1 unterstützt Schema 22; für künftige Schemata Migration explizit ergänzen.
- Sieben-Tage-Diagramm nach `performedOn`, Tagesauswahl und Auswahl vergangener
  Zeiträume ergänzt. Bestehende Auswertung einmaliger Aufgaben bleibt separat.
- Deutsche Kalendertexte aktiviert. Zukunftsnavigation wegen T20-01 nach
  ausdrücklicher Nutzerbestätigung vorläufig gesperrt, inklusive Weiter-Pfeil.
- Zwei begrenzte Reviews: keine harten Standardverstöße; kleine Hinweise zu
  gemeinsam verwendeter Abschlussdefinition und neutralem Datenbankkonstruktor
  übernommen. Der fachliche Review fand T20-01; die bestätigte Begrenzung wurde
  anschließend nachgeprüft. Keine offenen Review-Blocker für dieses Paket.
- Sicherungstests prüfen alle 16 befüllten Tabellen einschließlich Historie,
  Papierkorb, Projektzuordnung und Korrekturinformationen, erneutes Öffnen,
  beschädigte/inkompatible Dateien sowie vollständiges Zurückrollen eines
  simulierten Schreibfehlers. Zählungs- und UI-Tests ergänzt. Ein Aufräumproblem
  im neuen Diagrammtest wurde behoben; statische Analyse ohne Befunde.
- Abschließende vollständige Testsuite: **149 Tests bestanden**. Testprotokoll
  lokal unter `build/phase20-tests.log` (generiertes, nicht versioniertes Artefakt).
- Release-APK erfolgreich gebaut: `1.0.0+2`, Schema weiterhin 22,
  `build/app/outputs/flutter-apk/app-release.apk`, 27.877.666 Bytes.
  SHA-256: `278BA693F5CE5F7C6FAD84270B1AC62EF365C62A290846F8DDBE2D1A47B2CBF3`.
  Anwendungskennung und Signaturkonfiguration unverändert.
- Noch offen: Update auf dem realen Handy, Android-Dateidialog, erste externe
  Sicherung und manueller Nachtest. Keine echten Handydaten verändert.

## 16. Oktober 2026 – Rückmeldungen sortiert, Datensicherung priorisiert

- Testprotokoll vom 13. Oktober mit #001–#020 sowie App-Konzeptideen A01/A02
  vollständig gelesen. Nutzer bestätigt durchgeführten Handytest.
- Nutzer legt Datensicherung als erstes Thema fest. Kleine Änderungen sollen
  hier bearbeitet, größere Änderungen bei Bedarf in andere Chats ausgelagert werden.
- Im Arbeitsplan eine vorläufige Paketaufteilung und einen begrenzten Vorschlag
  für vollständige Sicherung/Wiederherstellung festgehalten. Ersetzen versus
  Zusammenführen ist noch offen; keine fachliche Entscheidung vorweggenommen.
- Gezielt lokale Datenhaltung, Abhängigkeiten, Datumsnavigation und die bisherigen
  Bearbeitungsgrenzen geprüft. Keine Backup-/Restore-Funktion gefunden.
- Nur Dokumentation geändert. Keine App-Implementierung, Tests, neue APK,
  neuen Chats oder externen Issues in dieser Runde.

## 8. Oktober 2026 – Begleitete Testvorbereitung begonnen

- Nutzer wünscht eine schrittweise Begleitung für seinen ersten App-Test,
  einschließlich Dokumentation und späterer Hilfe bei Problemen.
- Kontingentschonende Arbeitsweise und ein noch abzustimmender Einstieg wurden
  im Arbeitsplan ergänzt. Testgerät und Installationsstand sind noch offen.
- Dokumentation und ausgewählte Codepfade gesichtet; keine App-Änderungen,
  Builds oder erneuten automatisierten Tests durchgeführt.

## 8. Oktober 2026 – Android-Testdatei erstellt

- Nutzer bestätigt das eigene Android-Handy als Testgerät.
- Aktuellen lokalen Projektstand erfolgreich mit `flutter build apk --release`
  gebaut: `build/app/outputs/flutter-apk/app-release.apk`, 26.447.643 Bytes.
- Version laut `pubspec.yaml`: `1.0.0+1`; Anwendung `com.example.momentum`.
  Bestehende Build-Konfiguration verwendet die lokale Debug-Signatur auch für
  diesen Release-Build. Für Folgeupdates Anwendungskennung und Signatur erhalten;
  dies ist noch keine Store-Veröffentlichung.
- Keine App-Codeänderung und keine erneute vollständige Testsuite. Erfolgreicher
  Build bestätigt noch keine Installation oder Funktionsprüfung auf dem Handy.
- APK-Übertragung per USB und manuelle Installation erklärt. Gerätemodell,
  Android-Version, Installations- und Startbestätigung stehen noch aus.
