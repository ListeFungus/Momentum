# Kalender – APK und kurzer Gerätenachtest

Stand: 21. Oktober 2026

## Prüfstand

- App-Version: `1.0.0+4`, Datenbankschema 24, Backupformat weiterhin 1.
- `flutter analyze`: keine Befunde.
- Abschließender vollständiger Testlauf: **174 Tests bestanden**
  (`flutter test --no-pub --concurrency=2 --timeout=2m`).
- Danach letzter Historienabgleich: erstmalige rückdatierte Notiz übernimmt die
  damalige Planungszeit; Versionsgrenze verwendet lokale Kalendertage statt 24h.
  Ergänzender Regressionstest mit Kalender-/Aufgabenrepository: **88 bestanden**
  einschließlich neuem Notizfall. APK anschließend erneut gebaut.
- Drift-Code generiert; `git diff --check` ohne Whitespacefehler.
- Historische Migrationspfade nach erstem Gesamtlauf repariert und im finalen
  Gesamtlauf erneut grün; ein vorhandener Test verwendete 24 Stunden statt
  lokaler Kalendertage über die Zeitumstellung und wurde entsprechend korrigiert.
- `flutter build apk --release`: erfolgreich (abschließender Neubau: 43,8 Sekunden).
- APK: `build/app/outputs/flutter-apk/app-release.apk`, 28.274.746 Bytes.
- Manifest geprüft: `com.example.momentum`, versionName `1.0.0`, versionCode `4`,
  minSdk 21, targetSdk 35; ARM64, ARMv7 und x86_64 enthalten.
- `apksigner verify`: erfolgreich, v1/v2-Signatur, bestehendes Android-Debug-Zertifikat.
  Tool meldet ergänzend die üblichen v1-META-INF-Warnungen; v2-Prüfung erfolgreich.
- SHA-256: `71EC3505D4E3244C7E047022878CB033D055E6E789950686FCFB6B16EF42F8DC`.
- **Gerätenachtest offen.** Keine Installation oder manuelle Abnahme behauptet.

## Nachtest (etwa fünf Minuten)

1. Vor Installation in der bisherigen App eine Sicherung exportieren. APK als
   Update installieren, nicht vorher deinstallieren. Bestehende Aufgaben/Werte
   stichprobenartig prüfen.
2. Seitenmenü → **Kalender**: standardmäßig Woche/nur Aufgaben. Tag, Monat und
   Liste öffnen; Habits/Tracker zuschalten und alle Filter ausschalten. Nach
   erneutem Öffnen sollen Filter und Ansicht erhalten bleiben.
3. Freie einmalige Aufgabe ab heute erstellen: zuerst nur Dauer, dann Start/Ende.
   Im Kalender Details → **Termin ändern** prüfen. Block lange drücken und
   verschieben; am unteren Griff Dauer ändern. Serien/Abschlüsse müssen gesperrt
   sein. Tagesansicht hat Ablageflächen für Vor-/Folgetag, Woche Tagespalten.
4. In kommende Wochen blättern und Details ansehen. Danach zurück zur normalen
   Tagesansicht: kein vorzeitiger Abschluss, kein zukünftiger Wert und keine
   vorzeitig angewendete Regeländerung. Unbestimmte Folgeaufgaben separat prüfen;
   `+1?` bedeutet frühestens möglicher Nachfolger, keinen festen Termin.
5. Einem Habit im regulären Editor eine andere Planungszeit geben: gilt ab morgen,
   heutige/ältere Einträge bleiben unverändert. Überfällige und undatierte Aufgaben
   über ihre separaten Listen auffinden. Bei Bedarf neue Sicherung exportieren.

## Bewusste Grenzen

- Kein Timer, keine gemessenen Werte aus Planungszeiten, keine externe
  Kalenderanbindung und keine anderen Phase-21-Themen.
- Kein direktes Ändern von Serienausnahmen, abgeschlossenen, pausierten oder
  gebündelten Terminen; normale Bearbeitung beziehungsweise Kopie verwenden.
- Keine Planung über Mitternacht, keine automatischen freien Zeitfenster.
- Doppelte/nicht existierende lokale Uhrzeit durch DST: Schreiben abgelehnt,
  Vorschau mit Warnung außerhalb der Zeitachse.
- Release-Modus mit bestehender Debug-Signierkonfiguration für private Tests;
  kein Store-Release und keine neue Signieridentität.
