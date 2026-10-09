# Momentum – Auswertung: Umsetzungsverlauf

Stand: 14. Juli 2026  
Status: Verlauf der umgesetzten Auswertungsphasen

## Zweck dieses Dokuments

Dieses Dokument hält fest, was in der Auswertung bereits umgesetzt wurde.

Abgrenzung:

- [`analytics_plan.md`](analytics_plan.md): kurze Arbeitskarte mit
  offenen Fragen und nächsten Schritten.
- [`analytics_concept.md`](analytics_concept.md): fachliches Konzept
  und Begründungen.
- Dieses Dokument: technischer und organisatorischer Verlauf der Umsetzung.

## Phase 7 / A1 – Grundkennzahlen festlegen

Umgesetzt:

- Statuswerte als Grundlage verwendet:
  - `pending`
  - `success`
  - `failure`
  - `no_entry`
- Kernkennzahlen festgelegt:
  - `dueCount`
  - `totalInstanceCount`
  - `successCount`
  - `failureCount`
  - `noEntryCount`
  - `pendingCount`
  - `answeredCount`
  - `resolvedCount`
  - `strictSuccessRate`
  - `valuedSuccessRate`
  - `completionRate`

Wichtige Entscheidungen:

- Offene `pending`-Einträge fließen nicht in Erfolgsquoten ein.
- `no_entry` zählt nicht als Erfolg und nicht als wertende Antwort.
- Für die erste Detailansicht wird keine einzelne Standardkennzahl benötigt.
- Instanz-Auswertung und Ziel-Auswertung werden getrennt.
- Falls später eine Kennzahl auf Karten gezeigt wird, ist `strictSuccessRate`
  nur bei Aufgaben ohne konkretes Ziel ein naheliegender Kandidat.
- Bei Aufgaben mit Ziel soll später die Zielerreichung die führende Aussage
  sein; Instanzwerte bleiben als erklärende Rohdaten sichtbar.

## Phase 7 / A2 – Technische Summary

Umgesetzt:

- Datei:
  - `lib/features/aufgaben/data/task_analytics_summary.dart`
- Inhalt:
  - Rohzählungen
  - abgeleitete Zähler
  - berechnete Quoten

Die Summary rechnet nur. Sie entscheidet nicht, wie Werte in der UI angezeigt
oder bewertet werden.

## Phase 7 / A2 – Zeitraum-Auswahl

Umgesetzt:

- Datei:
  - `lib/features/aufgaben/data/task_analytics_period.dart`
- Erste Zeiträume:
  - letzte 7 Tage
  - letzte 20 Tage
  - letzte 30 Tage
  - seit Beginn

Regel:

- Rollierende Zeiträume zählen inklusive heute.
- Wenn die Aufgabe später begonnen hat, startet der Zeitraum am Startdatum der
  Aufgabe.

## Phase 7 / A2 – Repository-Anbindung

Umgesetzt in:

- `lib/features/aufgaben/data/aufgaben_repository.dart`

Neue Methoden:

- `getTaskAnalyticsSummary(...)`
- `getTaskAnalyticsSummaryForPeriod(...)`
- `watchTaskAnalyticsSummary(...)`
- `watchTaskAnalyticsSummaryForPeriod(...)`

Wichtig:

- Die Detailansicht nutzt die Stream-Variante.
- Dadurch aktualisiert sich die Auswertung live, wenn sich passende
  `task_entries` ändern.

## Phase 7 / A2 – Anzeigeformat

Umgesetzt:

- Datei:
  - `lib/features/aufgaben/data/task_analytics_display.dart`

Regeln:

- Prozentwerte werden mit einer Nachkommastelle angezeigt, z. B. `66,7 %`.
- Quoten zeigen zusätzlich ein Verhältnis, z. B. `2 von 3`.
- Fehlende Bezugswerte erhalten freundliche Leertexte.
- Jede Kennzahl hat einen kurzen Info-Text.

## Phase 7 / A2 – Erste Detailansicht

Umgesetzt:

- Datei:
  - `lib/features/aufgaben/presentation/task_detail_screen.dart`

Zugang:

- über das Drei-Punkte-Menü der Aufgabenkarte
- Menüpunkt: „Details & Auswertung“

Die Detailansicht zeigt:

- Zeitraum-Auswahl
- Erfolgsquote
- Fortschritt
- Erfolge
- Misserfolge
- Kein Eintrag
- Offen
- weitere Werte, aktuell insbesondere `valuedSuccessRate`
- Info-Button pro Kennzahl

Bewusst nicht umgesetzt:

- Anzeige direkt auf Aufgaben-/Habit-Karten
- freie Zeiträume
- Aussagekraft-Schwellen
- Zielbewertung
- Serien/Streaks
- Liste einzelner Antworten mit Notizen
- visuelle Raster-/Symbolansicht pro Eintrag
- unterschiedliche Auswertungsansichten je Aufgabenart für alle späteren
  Spezialfälle
- Sammelauswertung für einmalige Aufgaben
- bedingte Anzeige von `Kein Eintrag` je Aufgaben-Konfiguration
- Überfälligkeitsauswertung für wiederkehrende Aufgaben mit Puffer/Carryover
- Aufgaben-Abhängigkeiten

## Phase 7 / A2.2 – Einmalige Aufgaben in der Detailansicht

Umgesetzt:

- Aufgaben ohne Wiederholung zeigen keine Habit-artige Zeitraum-Auswertung mehr.
- Die Detailansicht zeigt stattdessen konkrete Aufgabeninformationen:
  - Status
  - Erstellungszeitpunkt
  - Datum, ab dem die Aufgabe zählt
  - Projektname und Projektfarbe, falls vorhanden
  - Fälligkeitsdatum
  - Abschlusszeitpunkt
  - Dauer bis Abschluss
  - Abweichung vom Fälligkeitstag, falls ein Fälligkeitsdatum vorhanden ist
  - Abschlussart: manuell, automatisch, Migration oder noch offen
  - Notiz, falls vorhanden

Technisch ergänzt:

- `task.createdAt` für den Erstellungszeitpunkt der Aufgabendefinition
- `entry.createdAt` für den Erzeugungszeitpunkt einer konkreten Instanz
- Migration auf Schema-Version 13 mit Backfill für bestehende Daten
- Repository-Stream für die neueste Instanz einer Aufgabe

Wichtig:

- `task.startDate` bleibt fachlich „ab wann zählt die Aufgabe“.
- `task.createdAt` bleibt „wann wurde die Aufgabe angelegt“.
- Bei neu erzeugten Instanzen nach Abschluss bekommt jede Instanz ein eigenes
  `entry.createdAt`; der fachliche Tag bleibt `scheduledDate`.

## Phase 7 / A2 – Tests und Prüfung

Ergänzte Tests:

- `test/features/aufgaben/data/aufgaben_repository_test.dart`
- `test/features/aufgaben/data/task_analytics_display_test.dart`

Ergänzt für A2.2:

- Prüfung, dass neue und migrierte Aufgaben/Instanzen einen `createdAt`-Wert
  besitzen.

Geprüft:

- gezieltes `flutter analyze` für die betroffenen Auswertungsdateien
- Ergebnis: keine Analyzer-Probleme

Nicht zuverlässig geprüft:

- vollständige Flutter-Testläufe, weil sie in dieser Umgebung mehrfach hängen
  geblieben sind.

## Aktueller offener Rest

- Detailansicht wurde grob im laufenden App-Betrieb geprüft; Wirkung passt.
- Prüfen, ob `valuedSuccessRate` als Zusatzwert verständlich genug ist.
- Prüfen und anpassen, welche Auswertung bei einmaligen Aufgaben überhaupt
  angezeigt werden soll. Erste einfache Detailansicht ist umgesetzt.
- Später ergänzen: Einzelantworten-Liste mit Notizanzeige.
- Später ergänzen: visuelle Raster-/Symbolansicht je Eintrag und Status.
- Später ergänzen: Sammelauswertung für einmalige Aufgaben, z. B. Dauer bis
  Erledigung und Abweichung vom Fälligkeitsdatum.
- Später ergänzen: Überfälligkeitswerte für wiederkehrende Aufgaben, z. B.
  rechtzeitig, im Puffer, nach Puffer, Carryover-Alter und Rückstandstage.
- Später strukturell berücksichtigen: Abhängigkeiten zwischen Aufgaben, z. B.
  „Aufgabe B wartet auf Aufgabe A“.
- Danach entscheiden, ob Phase 8 begonnen wird.
