# Momentum – Phase 10: Verlauf und aktueller Stand

Stand: 20. Juli 2026  
Status: Abgeschlossen

## Zweck dieses Dokuments

Dieses Dokument hält fest, was in Phase 10 geprüft, entschieden und umgesetzt
wurde.

Abgrenzung:

- [`carryover_plan.md`](carryover_plan.md): kurze Arbeitskarte mit Ablauf und
  offenen Punkten.
- Dieses Dokument: Verlauf, Entscheidungen, betroffene Dateien und spätere
  Prüfergebnisse.

## Ausgangslage vor Phase 10

Bereits vorhanden:

- Statusmodell aus Phase 6:
  - `pending`
  - `success`
  - `failure`
  - `no_entry`
- automatische Herkunft und Policy-Metadaten
- zentraler `TaskInstanceScheduler`
- direkte Missed-Konsequenz aus Phase 8
- Puffer-Missed-Policy aus Phase 9
- gespeichertes Feld `maxCarryoverCount`
- Validierungslogik kennt `MissedPolicy.carryover` bereits grundsätzlich

Noch zu prüfen:

- ob Carryover im Scheduler schon teilweise vorbereitet ist
- ob der Validator bereits alle ungültigen Carryover-Kombinationen sperrt
- ob die Erstellungs-/Bearbeitungs-UI Maximum und Konsequenz vollständig zeigt
- wie Tages-, Habit- und Dringlichkeitsansicht alte offene Instanzen aktuell
  laden und sortieren

## Fachlicher Startstand

Carryover bedeutet:

- Nicht erledigte Instanzen bleiben offen.
- Neue Instanzen entstehen trotzdem weiter.
- Jeder aufgestaute Eintrag bleibt eine eigene Instanz.
- Jede Instanz kann unabhängig erledigt, als Misserfolg markiert, als Kein
  Eintrag gespeichert, kommentiert und ausgewertet werden.

## Aus Phase 9 übernommen

Phase 9 hat bewusst entschieden:

- `keep_open` ist kein Puffer-Sonderfall.
- Wenn eine kalendergebundene Aufgabe offen bleiben soll, obwohl neue Instanzen
  entstehen, ist das fachlich Carryover.
- Die sichtbare Anzeige `Puffer Tag X/Y` wird mit Carryover zusammen umgesetzt,
  weil beide Themen die Anzeige alter offener Instanzen betreffen.

## Erwartete betroffene Dateien

| Datei | Erwartete Rolle |
|---|---|
| `lib/features/aufgaben/data/task_instance_scheduler.dart` | Carryover-Instanzen nachholen, Maximum prüfen, älteste überzählige Instanz verarbeiten. |
| `lib/features/aufgaben/data/task_configuration_validator.dart` | Carryover-Regeln, Pflichtfelder und ungültige Kombinationen absichern. |
| `lib/features/aufgaben/presentation/widgets/missed_policy_field.dart` | Hinweise zu Aufstauen, Maximum und Konsequenz. |
| `lib/features/aufgaben/data/aufgaben_repository.dart` | Tages-/Dringlichkeitslisten mit alten offenen Instanzen versorgen. |
| `lib/features/aufgaben/presentation/aufgaben_screen.dart` | Darstellung und Sortierung alter offener Instanzen. |
| `test/features/aufgaben/data/aufgaben_repository_test.dart` | Scheduler-/Repository-Tests für Carryover. |
| `test/features/aufgaben/data/task_configuration_validator_test.dart` | Validierungstests für Carryover. |

## Bestandsaufnahme 10.1

Geprüft wurden Scheduler, Repository, Validator, UI-Feld und Aufgabenanzeige.

Bereits vorhanden:

- `maxCarryoverCount` ist in Aufgabe und Definitionsversion gespeichert.
- `MissedPolicy.carryover` existiert bereits.
- Validator erlaubt Carryover nur bei kalendergebundenen Rhythmen.
- Validator verlangt bei Carryover eine gültige Konsequenz.
- UI zeigt bei Carryover bereits:
  - maximale Anzahl aufgestauter Einträge
  - Konsequenz bei überschrittener Grenze

Noch fehlend vor der Umsetzung:

- Scheduler begrenzte Carryover noch nicht automatisch.
- Alte offene Carryover-Instanzen wurden in Tageslisten nicht zuverlässig als
  eigene Karten angezeigt.
- Dringlichkeitsansicht nutzte noch nicht alle offenen Instanzen.
- `Puffer Tag X/Y` war fachlich geplant, aber noch nicht sichtbar angebunden.

## Umsetzung 10.2 bis 10.7

Umgesetzt wurde:

- Der Scheduler prüft nach der Instanzerzeugung pro Tag das Carryover-Maximum.
- Das Maximum zählt alle offenen Carryover-Instanzen bis einschließlich der
  heutigen Instanz.
- Wenn das Maximum überschritten wird, werden die ältesten überzähligen
  Instanzen automatisch verarbeitet.
- Erlaubte automatische Konsequenzen:
  - `failure`
  - `no_entry`
- Automatischer Erfolg bleibt ausgeschlossen.
- Die Verarbeitung speichert:
  - `resolutionOrigin = automatic`
  - `appliedMissedPolicy = carryover`
  - `appliedMissedConsequence`
  - `finalizedAt`
  - `effectiveAt`
- Die Tages-/Habit-Ansicht lädt alte offene Carryover-Instanzen zusätzlich zur
  aktuellen Instanz.
- Die Dringlichkeitsansicht lädt offene Task-Instanzen statt nur eine
  Aufgabenzeile.
- Aktionen auf Karten verwenden die tatsächliche `scheduledDate` der Instanz,
  nicht pauschal das sichtbare Tagesdatum.
- Alte offene Carryover-Instanzen werden über das Instanzdatum sortiert; älteste
  Einträge kommen zuerst.
- Alte offene Puffer-Instanzen werden während des Puffers ebenfalls sichtbar.
- Puffer wird auf Karten als `Puffer Tag X/Y` angezeigt.
- Carryover/überfällige Instanzen werden als `−X` angezeigt.

## Betroffene Dateien

| Datei | Änderung |
|---|---|
| `lib/features/aufgaben/data/task_instance_scheduler.dart` | Carryover-Limit nach Instanzerzeugung prüfen und überzählige älteste Instanzen automatisch abschließen. |
| `lib/features/aufgaben/data/aufgaben_repository.dart` | Alte offene Carryover-/Puffer-Instanzen in Tageslisten laden; Dringlichkeit über offene Instanzen aufbauen; Sortierung nach Instanzdatum. |
| `lib/features/aufgaben/presentation/aufgaben_screen.dart` | Kartenaktionen nutzen echte Instanzdaten; Anzeige `−X` und `Puffer Tag X/Y`. |
| `test/features/aufgaben/data/aufgaben_repository_test.dart` | Gezielte Tests für Carryover-Maximum, No-Entry-Konsequenz, Tagesansicht, Dringlichkeitsansicht und Puffer-Sichtbarkeit ergänzt. |

## Prüfnachweise

Extern in PowerShell ausgeführt:

```powershell
flutter test --no-pub test\features\aufgaben\data\aufgaben_repository_test.dart --plain-name "Carryover"
```

Ergebnis: `+4 All tests passed`

Extern in PowerShell ausgeführt:

```powershell
flutter test --no-pub test\features\aufgaben\data\aufgaben_repository_test.dart --plain-name "Tagesansicht zeigt alte offene Puffer-Instanzen im Puffer"
```

Ergebnis: `+1 All tests passed`

Damit ist Phase 10 fachlich, technisch und dokumentarisch abgeschlossen.
