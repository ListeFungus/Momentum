# Momentum – Phase 11: Vollständige Auswertung: Verlauf

Stand: 22. Juli 2026  
Status: Abgeschlossen in erster Ausbaustufe

## Ausgangslage

Phase 11 wurde neu vor die Zielbewertung gezogen. Grund: Die App soll zuerst
alle relevanten Auswertungen verständlich und stabil anbieten. Ziele werden
danach auf diese Auswertungen gelegt.

## Beschlossene Kurskorrektur

Am 21. Juli 2026 wurde entschieden:

- Nicht zuerst Zielbewertung umsetzen.
- Zuerst vollständige Auswertung für Statusaufgaben und Habits fertigstellen.
- Danach erweiterte Eingabearten wie Zahl, Dauer und Uhrzeit planen/umsetzen.
- Danach Wert-Auswertungen ergänzen.
- Erst danach Zielbewertung als eigene Phase umsetzen.

## Nächster Schritt

Bestandsaufnahme der vorhandenen Auswertung aus Phase 7:

1. Welche Kennzahlen existieren im Code?
2. Welche davon reichen für Release 1?
3. Welche fehlen für wiederkehrende Aufgaben/Habits?
4. Welche fehlen für einmalige Aufgaben?
5. Welche UI-Orte und Detailansichten fehlen?

Stand: 21. Juli 2026  
Status: Noch nicht begonnen

## Zweck

Dieses Dokument hält später fest, welche zusätzlichen Auswertungen für die erste
Version entschieden, umgesetzt und geprüft wurden.

## Ergänzung: Matrix und Tabellenansicht

Am 21. Juli 2026 wurde festgelegt:

- Die Auswertungs-Matrix soll nicht nur Kennzahlen sammeln, sondern Aufgaben-
  und Habit-Arten mit sinnvollen Auswertungen verbinden.
- Die strenge Erfolgsquote bleibt die Standardquote für wiederkehrende
  Status-Aufgaben und Habits.
- Wenn eine Aufgabe `no_entry` nicht erzeugen kann, ist die strenge Erfolgsquote
  automatisch besonders eindeutig, weil nur Erfolg und Misserfolg in die
  abgeschlossene Grundmenge fallen.
- Für später ist eine tabellarische Detailansicht sinnvoll: links die
  Auswertung, daneben kurze Erklärung oder Info-Button, rechts der berechnete
  Wert im gewählten Zeitraum.
- Diese Darstellung eignet sich besonders für eine spätere Browser-Version und
  kann als komfortable Premium-Ansicht erweitert werden. Die Berechnung der
  Kennzahlen bleibt davon unabhängig.

## Ergänzung: Sichtbarkeit von Status-Kennzahlen

Am 21. Juli 2026 wurde entschieden:

- Alle Auswertungen aus „Wiederkehrende Aufgaben und Habits“ bleiben fachlich
  vorgesehen.
- Die App soll aber nicht jede Kennzahl blind anzeigen und dann technische
  Nullwerte interpretieren.
- Jede Kennzahl braucht zuerst eine Verfügbarkeitsprüfung.
- Beispiel: „Kein Eintrag: 0“ ist nur sinnvoll, wenn die Aufgabe `no_entry`
  überhaupt erzeugen kann. Wenn `no_entry` nie möglich ist, soll diese Kennzahl
  in der normalen Ansicht nicht angezeigt werden.
- Die konkrete Sichtbarkeit wurde in
  [`status_metric_visibility.md`](status_metric_visibility.md) ausgelagert, damit
  der Phase-11-Plan übersichtlich bleibt.

## Ergänzung: Einzelne einmalige Aufgaben

Am 21. Juli 2026 wurde festgelegt:

- Einzelne einmalige Aufgaben bekommen keine klassische Habit-Auswertung.
- Stattdessen bekommen sie eine verständliche Aufgabenakte.
- Dabei wird zwischen Detailfeldern und echten Auswertungswerten unterschieden.
- Detailfelder sind zum Beispiel Status, Erstellungsdatum, Startpunkt, Projekt
  und Fälligkeit.
- Auswertungswerte sind zum Beispiel Dauer bis Abschluss, aktuelle Laufzeit,
  aktuelle Überfälligkeit und Abweichung vom Fälligkeitstag.
- Die konkrete Sichtbarkeit steht in
  [`single_task_metric_visibility.md`](single_task_metric_visibility.md).

## Ergänzung: Projekt-, Gesamt- und Spezialauswertungen

Am 22. Juli 2026 wurde entschieden:

- Projektauswertungen werden nicht in Phase 11 vorgezogen.
- Sie gehören hauptsächlich in Phase 18, weil vorher Projektzuordnung,
  historische Projektwechsel, gelöschte Projekte und Projektzeiträume fachlich
  geklärt werden müssen.
- Echte Gesamtstatistiken über alle Aufgaben werden ebenfalls nicht in Phase 11
  vollständig umgesetzt, weil unterschiedliche Aufgabenarten nicht unkritisch
  zusammengezählt werden dürfen.
- Spezialauswertungen werden getrennt betrachtet:
  - Rasteransichten und Antwortlisten können Phase-11-relevant sein, weil sie
    vorhandene Daten anders darstellen.
  - Serien/Streaks und Log-in-Streaks bleiben später, weil sie eigene fachliche
    Regeln brauchen.
- Aussagekraft-Hinweise bleiben Phase-11-relevant, weil sie direkt helfen,
  Kennzahlen verständlich zu machen.

## Umsetzung der ersten Ausbaustufe

Am 22. Juli 2026 wurde Phase 11 technisch in einer ersten Ausbaustufe umgesetzt:

- Wiederkehrende Aufgaben und Habits zeigen in der Detailansicht alle
  vorgesehenen Status-Auswertungen.
- Nicht verfügbare Auswertungen werden ausgegraut und mit kurzem Grund erklärt.
- Einzelne einmalige Aufgaben zeigen alle vorgesehenen Detailfelder und
  Auswertungswerte in der Aufgabenakte.
- Für Sammelauswertungen einmaliger Aufgaben wurde eine eigene Seite angelegt.
- Der Zugang erfolgt zunächst pragmatisch über einen Icon-Button im Header der
  Aufgabenansicht.
- Die Auswertung einmaliger Aufgaben nutzt in dieser ersten Version das
  Erstellungsdatum für den gewählten Zeitraum.
- Die gezielte Analyse der betroffenen Dart-Dateien war grün.
- Flutter-Tests hingen in der eingebetteten Umgebung erneut; deshalb sollen die
  betroffenen Tests bei Bedarf extern in PowerShell ausgeführt werden.

Nicht Teil dieser Umsetzung:

- Antwortliste einzelner Einträge mit Notizen.
- Raster-/Kalenderansicht.
- Projekt-Auswertung.
- echte Gesamtstatistiken über alle Aufgabenarten.
