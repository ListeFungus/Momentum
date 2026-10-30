# Privates Update 1.0.0+5

Stand: 28. Oktober 2026

Auf ausdrücklichen Nutzerauftrag erstellt. Enthält den aktuellen lokalen Stand
einschließlich #002, #013, Gruppen-/Trackerpaket und Zeitumstellungskorrektur.
Keine weiteren Produktänderungen für den Build; Versionscode von 4 auf 5 erhöht.

## Prüfung

- Vorhandenen Gesamtlauf der Korrektur geprüft: 229 Tests grün, maschinenlesbarer
  Abschluss in `.dart_tool/goal_calendar_verified.json` erfolgreich.
- Erneut 27 gezielte Tests bestanden: Zielkalender/Mehrjahreshistorie, Gruppen,
  Kalendergrundlagen, Backup und Lifecycle-Migrationen. Alte Kalenderdaten ohne
  Planungszeit, gespeicherte Werte sowie Migration 25 auf 26 abgedeckt.
- Erneute Analyse von acht betroffenen Bereichen ohne Befunde.
- `flutter build apk --release --no-pub` erfolgreich, 141,9 Sekunden.
- APK: `build/app/outputs/flutter-apk/app-release.apk`, 28.505.211 Bytes.
- Paket `com.example.momentum`, versionName `1.0.0`, versionCode `5`;
  minSdk 21, targetSdk 35; ARM64, ARMv7, x86_64.
- APK-Signatur v1/v2 erfolgreich verifiziert. Zertifikat identisch mit der vor
  dem Build vorhandenen APK 1.0.0+4: SHA-256
  `0db81762df7a849b69929be5a1590a37e018c73ad794ad7cc45153f0c441ff50`.
  Weiterhin private Debug-Signierung, keine Store-Freigabe.
- APK SHA-256: `B4365B7B2CE90F8A8E3DDB2D40E67E43300D5E99256F55030059021C31CC3BC9`.

## Installation und Grenze der Aussage

Kein blockierender Datenfehler in den Prüfungen gefunden. Der persönliche
Handy-Datenbestand und die Installation auf dem Gerät wurden nicht geprüft.
Die Signatur passt zur vorherigen lokalen Release-APK, nicht nachweislich zu
jeder eventuell anders gebauten Handyinstallation.

1. Vollständiges Backup in der bisherigen App exportieren und extern aufbewahren.
2. APK als Update installieren. Nicht deinstallieren und keine App-Daten löschen.
   Bei Signatur-/Installationskonflikt abbrechen und melden, nicht durch Löschen umgehen.
3. Alte Aufgaben ohne Uhrzeit, mehrere historische Messwerte, Ziele und Kalender
   vergleichen. Anschließend Gruppen und das Speichern eines neuen Wertes testen.

Fehlende Planungszeiten bleiben leer. Die Zeitkorrektur migriert keine Messwerte;
früher eventuell falsch berechnete Zielvormerkungen werden nicht automatisch
umgeschrieben (siehe `goal_calendar_fix.md`). Datenbankschema 26; alte App-Versionen
nicht über die neue Datenbank zurückinstallieren. Geräteabnahme bleibt offen.
