# Momentum – Phase 21: Testergebnisse ausarbeiten und umsetzen

Stand: 25. Oktober 2026

Status: Aktiv; #013 A0–A5 implementiert, 212 Tests grün, gezielte Analyse ohne Befunde. Kalender und #002 erhalten. Schema 25; Gerätenachtests offen. Keine neue APK für #002/#013.

## Zweck

Diese Phase bündelt Änderungen, Verbesserungen und Erweiterungen aus dem
Praxistest. Sie hält fest, was gewünscht, entschieden, umsetzungsbereit,
implementiert und tatsächlich auf dem Handy nachgetestet ist.

## Dokumente

- [#011/#020/A01 und Bezug #004 – Gruppenplanung](daily_overview_groups_plan.md)
  – umsetzungsbereit G0–G6: eigener Gruppentab, kompakte Eingaben, vollständiger/
  teilweiser Abschluss, Zuordnung, V1-Sperren, Migration/Backup und Abnahme.
  Monitoring/A01 ist auf Nutzerwunsch verschoben; noch keine Implementierung.
- [Arbeitsplan und Themenübersicht](test_improvements_plan.md) – alle offenen
  Themen, Prioritäten, Abhängigkeiten und Übergabe an den nächsten Chat.
- [#013 – Aufgabenart wechseln: Auftrag A0–A5](task_type_change_implementation_plan.md)
  – zur Umsetzung vorbereitet, noch nicht implementiert. Beide Historienoptionen,
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
