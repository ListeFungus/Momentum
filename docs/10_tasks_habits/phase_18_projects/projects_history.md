# Momentum - Projekte: Verlauf

Stand: 6. Oktober 2026  
Status: Planung und Umsetzung abgeschlossen

## Zweck

Dieses Dokument hält fest, was in der Projektphase fachlich entschieden und
technisch umgesetzt wurde. Der aktive Arbeitsplan steht in
[`projects_plan.md`](projects_plan.md).

## Ausgangsstand am 21. Juli 2026

Im Code ist bereits ein erster Projektbereich vorhanden:

- `lib/features/projekte/data/projects_table.dart`
- `lib/features/projekte/data/project_repository.dart`
- `lib/features/projekte/presentation/projects_screen.dart`
- `lib/features/projekte/presentation/project_detail_screen.dart`
- `lib/features/projekte/presentation/project_create_screen.dart`
- `lib/features/projekte/presentation/project_edit_screen.dart`
- Projekt-Auswahl in Aufgaben-Erstellung und Aufgaben-Bearbeitung
- Projektanzeige auf Aufgabenkarte und in der Aufgaben-Detailansicht

Fachlich bereits erkennbar:

- Projekte haben Name, Beschreibung, Farbe und Sortierung.
- Aufgaben und Habits können einem Projekt zugeordnet werden.
- Projektzuordnungen werden in Aufgaben-Definitionsversionen mitgeführt.
- Die Projekt-Detailansicht besitzt bereits eine Übersicht und einen Analyse-Tab.
- Projektloeschung ist in der UI vorbereitet, aber noch nicht fachlich umgesetzt.

## 4.–6. Oktober 2026 – Planung im Dialog

- Flexibler Ordnungsrahmen ohne verpflichtende Projekttypen bestätigt.
- Reversible Archivierung; Aufgaben und Habits laufen unverändert weiter.
- Zwei Löschoptionen mit sieben Tagen Papierkorb; gemeinsame Wiederherstellung
  schützt spätere Nutzeränderungen. Nach reiner Projektlöschung keine automatische
  aktuelle Neuzuordnung beim Zurückholen.
- Historische Projektidentität bleibt erhalten, nach endgültiger Löschung
  ohne Namen/Beschreibung/Farbe.
- Einfache Statusauswertung mit vorhandenen Zeiträumen, kein pauschaler
  Projektfortschritt. Genauere Analysen später.
- Auf Nutzerkorrektur eigener Projektinhalt für berechnete Bündelwerte
  aufgenommen: unabhängige Zuordnung, bestehende Detailauswertung, dieselben
  Projektregeln und ein getrennter Statusbereich für Bündelergebnisse.
- Einfaches Bedienpaket bestätigt; keine zusätzlichen Spezialfilter oder
  zweite Bündelerstellung.
- Relevanten Code-/Dokumentstand gezielt geprüft. Unter anderem erneute
  Zuordnungsschreibvorgänge beim Metadatenspeichern und `ON DELETE SET NULL`
  bei historischen Projektverweisen als Umsetzungsrisiken berücksichtigt.
- Technische Verträge, Schemaänderung ab Version 20, fünf abhängige Pakete,
  gezielte Testmatrix und Startanweisung im Arbeitsplan ausgearbeitet.

Keine Implementierung, Migration oder Flutter-Testausführung in diesem Chat.
Der vorhandene Arbeitsbaum mit fremden Änderungen wurde nicht bereinigt.

## Zweite Planprüfung am 6. Oktober 2026

Auf ausdrücklichen Nutzerwunsch Codepfade und Nutzbarkeit erneut geprüft.
Archiv-Auswahl, Bündelzugang ohne heutige Instanz, zunächst zukünftige Bündel,
separat gelöschte Inhalte nach Projekt-Restore, Metadaten-/Zuordnungseditor,
historische Navigation und Restore-Vorschau im Plan nachgeschärft. Die
entsprechenden Szenarien sind der Abnahmematrix hinzugefügt. Keine Codeänderung
und keine ausgeführte UI-Prüfung; statischer Abgleich und Ablaufprüfung.

## Übergabe

Anderer Chat: mit der Startanweisung im Arbeitsplan und Paket 18a beginnen.
Bereits bestätigte Produktregeln nicht erneut diskutieren; tatsächliche
Abweichungen im inzwischen geänderten Code konkret behandeln. Paketstatus und
Verlauf bei der Umsetzung fortschreiben.

## 6. Oktober 2026 – Umsetzung abgeschlossen

- Schema 21 ergänzt Archiv-, Papierkorb-, Purge- und Revisionsfelder an
  Projekten, `projectId` an Bündeln sowie typisierte Zuordnungsereignisse für
  Aufgaben und Bündel.
- Projektlöschungen speichern einen eigenen Batch mit den exakten
  Lebenszyklusrevisionen der gemeinsam gelöschten Inhalte. Veraltete Vorschauen
  brechen atomar ab; Restore verändert separat behandelte Inhalte nicht.
- Endgültiges Löschen anonymisiert die Projektzeile statt historische
  Fremdschlüssel zu zerstören. Der sichtbare Bereich filtert diesen technischen
  Verweis vollständig aus.
- Archivieren verändert weder Planung noch Zuordnung. Metadatenbearbeitung
  schreibt nur bei echten Änderungen und verändert keine Mitgliedschaft.
- Die Projektübersicht gruppiert Aufgaben, Habits und Bündel. Die Analyse zählt
  Aufgabenstatus und Bündelstatus getrennt für 7/20/30 Tage oder seit Beginn.
- Aufgaben-/Habit-Erstellung unterstützt eine Projektvorauswahl; Bündel haben
  eine unabhängige Projektauswahl. Ein eigener Dialog ordnet bestehende Aufgaben,
  Habits und Bündel ab heute zu.
- Aktive Projekte, Archiv und Papierkorb sind erreichbar. Projekte wurden in
  die gemeinsame Lebenszyklusansicht und Gesamtleerung aufgenommen.

Prüfung:

- Drift-Codegenerierung nach Schemaänderung erfolgreich.
- Echte Schema-19- und Schema-20-Fixtures migrieren auf 21;
  `PRAGMA foreign_key_check` bleibt leer.
- Gezielte Projekt-, Zuordnungs-, Lebenszyklus- und Migrationstests bestanden.
- Vollständiges `flutter analyze`: keine Probleme gefunden.
- Gemeinsamer Flutter-Abschlusslauf für Aufgaben, Projekte und Widget-Smoke:
  **138 Tests bestanden**.

Bewusst nicht vorgezogen: Cloud-Outbox, geräteübergreifende Konfliktauflösung
und Sync-Zeitstempel. Diese Punkte gehören weiterhin in Phase 19.
