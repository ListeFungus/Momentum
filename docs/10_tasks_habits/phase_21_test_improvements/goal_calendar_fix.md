# Phase 21 – Zielzeiträume über Zeitumstellungen

Stand: 28. Oktober 2026

Status: Korrektur implementiert; vollständige Suite 229 Tests grün, Analyse
der acht betroffenen/neuen Dart-Dateien ohne Befunde. Kein APK-Build und keine
Datenmigration. Persönlicher Langzeitbestand nicht geprüft.

## Fehler und Ursache

Die beiden gemeldeten Repositorytests wurden vor der Korrektur reproduziert:
ein noch laufender Zielblock erschien bereits in der Historie; eine für den
29. Oktober erwartete Zielvormerkung wurde auf den 28. Oktober gelegt.
Lokale Tage wurden als 24-Stunden-Dauern behandelt. Über Sommer-/Winterzeit
entstanden dadurch Grenzen um 23:00/01:00 statt am lokalen Tagesanfang.
Die gleiche Rechnung stand auch in den rollierenden Fenstern für Wert-/Bündelziele.

## Umsetzung

- Gemeinsame Kalenderarithmetik in `lib/core/date/calendar_days.dart`: Tage über
  Datumsbestandteile verschieben, Tagesabstände über UTC-Datumslabels zählen.
  Keine Konvertierung der gespeicherten lokalen Zeitpunkte nach UTC.
- Bereits vorhandene Kalenderhilfen aus `calendar_clock.dart` exportieren diese
  identischen Grundfunktionen weiter; keine Änderung der Kalender-API.
- Aktueller/nächster Zielblock, historische Blöcke, rollierende Status-/Wert-/
  Bündelziele und zugehörige Daten-/Versionsgrenzen verwenden Kalendertage.
  Bündel-Quelltage behalten ihre konfigurierten Tagesversätze ohne DST-Drift.
  Die gemeinsame Auswahl „letzte 7/20/30 Tage“ verwendet ebenfalls Kalendertage.
- Gemessene Dauern bleiben echte Dauern. Zielwerte, Rhythmen und Erfolgsregeln
  wurden nicht verändert; es gibt keine Schemaänderung (weiterhin 26).
- Ein im Gesamtlauf zusätzlich aufgefallener alter Karten-Widgettest erwartete
  den früheren Fehlertext und benötigte den inzwischen im App-Rahmen vorhandenen
  `ValueDraftScope`. Beide Testvoraussetzungen aktualisiert. Danach wurde ein
  echter kleiner Folgefehler sichtbar: Die lokale Validierungsmarkierung ging
  beim Wechsel zwischen kompaktem und großem Layout verloren. Die Markierung
  wird jetzt auch im bestehenden Entwurfszustand erhalten. Keine Lockerung der
  Eingabevalidierung; Karten- und Gruppen-Widgettests sind grün (5 Tests).

## Daten und Grenze des Nachweises

Keine automatische Reparatur früher gespeicherter Zielvormerkungen: Aus einem
Datum allein lässt sich nicht sicher unterscheiden, ob es bewusst gewählt oder
fehlerhaft berechnet wurde. Neue Vormerkungen werden korrekt berechnet; vorhandene
Messwerte, Einträge und Definitionen werden durch diese Korrektur nicht migriert.

Die Testdatenbanken sind unabhängig vom persönlichen Bestand. Ein künstlicher
Verlauf vom 1. Januar 2024 bis 28. Oktober 2026 prüft lückenlose Siebentagesblöcke
über mehrere Zeitumstellungen. Das ist kein Nachweis für die Integrität des
persönlichen Langzeitexports. Eine Prüfung dieses Exports wäre separat auf einer
Kopie möglich, ohne ihn in die benutzte App zurückzuspielen.

## Prüfnachweis

- Neu: `test/features/aufgaben/data/task_goal_calendar_test.dart`, fünf Tests.
  Feste Daten über beide Zeitumstellungen, laufender/abgeschlossener Block,
  nächste Zielvormerkung, Einzel-/Bündelwerte inklusive Randtag und ausgeschlossener
  Messung außerhalb des Fensters, Future-/Stream-Leser sowie Mehrjahreshistorie.
  Vorher/Nachher-Vergleich schützt gespeicherte Einträge und Werte in den Tests.
- Vor dem Fix alle fünf Tests fachlich rot; nach dem Fix alle fünf grün (22 s).
  Die ursprünglichen zwei Tests sind im folgenden Gesamtlauf ebenfalls grün.
- Erste Gesamtläufe nach dem Datumfix: jeweils 228 bestanden, ein Karten-Widgettest
  fehlgeschlagen. Fehlermeldung/Testaufbau und anschließend den Erhalt der
  Validierungsmarkierung wie oben korrigiert; gezielte Wiederholung grün.
- Gezielte abschließende Analyse von Kalenderhilfen, Zielberechnung, Zeitraumwahl,
  Repository, Werteingabe und Tests (acht Dateien): keine Befunde.
- Abschließender Gesamtlauf: **229 bestanden, 0 fehlgeschlagen**, 95 Sekunden.
  Befehl: `flutter test --no-pub --concurrency=2 --timeout=2m
  --reporter=failures-only --file-reporter=json:.dart_tool/goal_calendar_verified.json`.
  Lokaler maschinenlesbarer Nachweis im angegebenen ignorierten `.dart_tool`-Pfad.
  Bestehende Drift-Debugwarnungen bei Backup-Testdatenbanken sind keine Testfehler.

Prävention: Kalendergrenzen ausschließlich mit Kalenderarithmetik bilden und
Regressionen an festen Umstellungstagen prüfen. Ein Test mit `DateTime.now()`
allein kann den Fehler außerhalb der Umstellungswochen verbergen.
