# Momentum – Phase 21: Testergebnisse ausarbeiten und umsetzen

Stand: 28. Oktober 2026

Status: Aktiv; #011/#020/#004 implementiert, Schema 26. Zielblock-/Zeitumstellungsfehler korrigiert; vollständige Suite 229 Tests grün, gezielte Analyse ohne Befunde. Gerätenachtest offen. Keine neue APK.

## Aktuelle Test-APK

Am 28. Oktober auf Nutzerauftrag **1.0.0+5** gebaut und Signatur/Version geprüft.
27 Update-/Datenprüfungen erneut grün; ersetzt die obige frühere Aussage „Keine
neue APK“. [Downloadpfad, Nachweis und Installation](update_1_0_0_5.md).

## Zweck

Diese Phase bündelt Änderungen, Verbesserungen und Erweiterungen aus dem
Praxistest. Sie hält fest, was gewünscht, entschieden, umsetzungsbereit,
implementiert und tatsächlich auf dem Handy nachgetestet ist.

## Dokumente

- [Neuer Android-Praxistest N01–N11 (Phase 20)](../phase_20_private_test/mobile_test_round_2_2026_10_11.md) – neue Nutzerbeobachtungen, noch nicht fachlich entschieden oder umgesetzt; für weitere Planung zunächst berücksichtigen.

- [Zielzeiträume und Zeitumstellung – Korrektur vom 28. Oktober](goal_calendar_fix.md)
  – Ursache, Umsetzung, vollständiger Prüfnachweis und Grenzen der Datenprüfung.
- [#011/#020/A01 und Bezug #004 – Gruppenplanung](daily_overview_groups_plan.md)
  – G0–G6 umgesetzt und dokumentiert: eigener Gruppentab, kompakte Eingaben, vollständiger/
  teilweiser Abschluss, Zuordnung, V1-Sperren, Migration/Backup und Abnahme.
  Monitoring/A01 ist auf Nutzerwunsch verschoben; Prüfvorbehalte siehe Gruppenplan.
- [Arbeitsplan und Themenübersicht](test_improvements_plan.md) – alle offenen
  Themen, Prioritäten, Abhängigkeiten und Übergabe an den nächsten Chat.
- [#013 – Aufgabenart wechseln: Auftrag A0–A5](task_type_change_implementation_plan.md)
  – implementiert. Beide Historienoptionen,
  Sperrmatrix, aktueller Kalender-/Trackingstand, Datenregeln und Tests.
- [Kalender-Umsetzungsplan und Auftrag K0–K7](calendar_implementation_plan.md) –
  aktuelle Priorität; bestätigter Umfang, Daten-/Projektionsregeln, Freigaben und
  Sperren, konkrete Arbeitspakete und Abnahmetests. Mit kopierbarem Auftrag für
  einen anderen Umsetzungschat. Baut auf dem
  [Kalenderkonzept V0.4](../phase_20_private_test/calendar_concept.md) auf.
- [Bereits umgesetzter Stand](implemented_changes.md) – bestätigte Regeln,
  technische Grenzen und Nachtests für Kartenanzeige, Backup, Datumsauswahl und Tagesdiagramm.
- [Kalender-Nachtest und APK](calendar_retest.md) – Versions-/Prüfnachweis und
  kurze Bedienprüfung auf dem Gerät; kein Ersatz für die ausstehende Geräteabnahme.
- [Verlauf](test_improvements_history.md) – Entscheidungen und abgeschlossene Pakete.

## Abgrenzung und Arbeitsweise

- [Phase 20](../phase_20_private_test/README.md): App benutzen, Beobachtungen und
  Nachtests dokumentieren. Originalmeldungen bleiben dort als Quelle erhalten.
- **Phase 21:** Ergebnisse fachlich ausarbeiten, begrenzte Änderungspakete
  festlegen und umsetzen. Planung und Umsetzung können in diesem Chat erfolgen;
  für den Kalender hat der Nutzer nun ausdrücklich eine dokumentierte Übergabe
  an einen anderen Umsetzungschat angefordert. Kein neuer Chat wird automatisch
  angelegt. Die Dokumente ermöglichen die Umsetzung ohne vollständigen Chatverlauf.
- [Phase 22](../phase_22_store_release/README.md): Store-Release vorbereiten;
  bisher Phase 21. Keine spätere nummerierte Phase ist derzeit dokumentiert.

Test und Verbesserung dürfen sich abwechseln. Phase 20 wird durch diese
Neuordnung nicht als abgeschlossen markiert. Eine Idee im Themenplan ist noch
kein Umsetzungsauftrag und nicht automatisch Voraussetzung für den Store-Release.

Für den nächsten Planungschat zunächst diesen Einstieg und den Arbeitsplan lesen,
danach nur die zum gewählten Thema gehörenden Quellen und Codepfade. Der aktuelle
App-Stand steht in `implemented_changes.md`; die drei dort dokumentierten
Funktionen nicht erneut als unimplementiert planen.
