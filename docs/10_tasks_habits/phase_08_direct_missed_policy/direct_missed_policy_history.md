# Momentum – Phase 8: Verlauf und aktueller Stand

Stand: 16. Juli 2026  
Status: abgeschlossen; Kernlogik umgesetzt, komplex getestet und grob in der App geprüft

## Zweck dieses Dokuments

Dieses Dokument hält fest, was in Phase 8 geprüft, entschieden und umgesetzt
wurde.

Abgrenzung:

- [`direct_missed_policy_plan.md`](direct_missed_policy_plan.md): kurze Arbeitskarte mit Ablauf und offenen Punkten.
- Dieses Dokument: Verlauf, Entscheidungen, betroffene Dateien und Prüfergebnisse.

## Ausgangslage vor Phase 8

Bereits vorhanden:

- Statuswerte `pending`, `success`, `failure`, `noEntry`
- Zeitfelder `respondedAt`, `finalizedAt`, `effectiveAt`
- Herkunftsfeld `resolutionOrigin`
- Felder `appliedMissedPolicy` und `appliedMissedConsequence`
- `TaskInstanceScheduler` als idempotentes Grundgerüst
- Aufgaben-Konfiguration für `MissedPolicy.direct`
- Aufgaben-Konfiguration für Missed-Konsequenzen
- Grundauswertung aus Phase 7

Noch nicht vorhanden war die tatsächliche automatische Verarbeitung direkter
Konsequenzen.

## Geklärte fachliche Regeln

### Wann ist eine Instanz abgelaufen?

Eine Instanz ist für direkte Konsequenz abgelaufen, wenn ihr relevanter Tag
vorbei ist.

Beispiel:

- Instanz gehört zum 16. Juli.
- Am 17. Juli um 00:00 Uhr ist dieser Tag vorbei.
- Wenn sie dann noch `pending` ist und die Aufgabe `MissedPolicy.direct`
  verwendet, darf die direkte Konsequenz greifen.

### Welche Rolle haben `dueDate` und `scheduledDate`?

Fachlich denkt der Nutzer in einem Fälligkeitstag. Technisch verarbeitet die App
eine konkrete Instanz über `scheduledDate`.

Deshalb wurde festgelegt:

- Wiederkehrende Aufgaben erzeugen Instanzen auf ihren jeweiligen geplanten Tagen.
- Einmalige Aufgaben mit `dueDate` erzeugen ihre Instanz auf dem Fälligkeitstag.
- Die automatische Verarbeitung arbeitet anschließend über `scheduledDate`.

### Welche Konsequenz erzeugt `no_entry`?

`no_entry` erzeugt keine Konsequenz. Die Richtung ist umgekehrt:

- Die Missed-Konsequenz entscheidet, welcher Status gespeichert wird.
- `markAsNotDone` wird zu `failure`.
- `keepNeutral` wird zu `noEntry`.

`noEntry` ist damit ein abgeschlossener, aber nicht wertender Status. Er ist kein
Erfolg und kein aktiver Misserfolg.

### Was passiert nach längerer Nichtnutzung?

Fehlende vergangene Instanzen werden nacherzeugt und chronologisch verarbeitet.

Beispiel:

- Eine tägliche Aufgabe wurde fünf Tage lang nicht geöffnet.
- Beim nächsten Scheduler-Lauf entstehen die fehlenden Instanzen.
- Jede Instanz wird anhand ihrer Missed Policy gespeichert, also bei direkter
  Konsequenz zum Beispiel als `failure` oder `noEntry`.

### Nachträgliche Korrektur

Vergangene Einträge bleiben nachträglich bearbeitbar. Das ist wichtig, wenn die
App nicht rechtzeitig geöffnet wurde.

Dabei gilt weiterhin:

- Der Status und die Auswertung eines vergangenen Eintrags dürfen korrigiert
  werden.
- Bereits erzeugte Folgeinstanzen werden dadurch nicht automatisch neu terminiert
  oder gelöscht.

## Umgesetzte technische Änderungen

| Datei | Änderung |
|---|---|
| `lib/features/aufgaben/data/task_instance_scheduler.dart` | Fehlende vergangene Instanzen werden über den Scheduler nacherzeugt; abgelaufene `pending`-Instanzen mit direkter Missed Policy werden automatisch abgeschlossen. |
| `lib/features/aufgaben/data/aufgaben_repository.dart` | Repository bietet einen zentralen Aufruf `ensureTaskInstancesUpToDate`; einmalige Aufgaben mit `dueDate` erzeugen ihre Instanz auf dem Fälligkeitsdatum. |
| `lib/main.dart` | Scheduler-Lauf bei App-Start, Rückkehr aus dem Hintergrund und Tageswechsel bei geöffneter App ergänzt. |
| `test/features/aufgaben/data/aufgaben_repository_test.dart` | Gezielte Tests für direkte Konsequenz als `failure`, direkte Konsequenz als `noEntry`, einmalige Aufgabe mit Fälligkeit und ein komplexes Nachholszenario ergänzt. |

## Lifecycle-Anbindung

Der zentrale Abgleich läuft jetzt an drei Stellen:

1. beim App-Start,
2. wenn die App aus dem Hintergrund zurückkommt,
3. beim nächsten lokalen Tageswechsel um 00:00 Uhr, solange die App geöffnet ist.

Die Verarbeitung ist bewusst idempotent gedacht:

- Bereits vorhandene Instanzen werden nicht doppelt erzeugt.
- Bereits finale Instanzen werden nicht erneut verändert.
- Scheduler-Läufe ohne echte Änderung erzeugen keine zusätzlichen Schreibvorgänge.

Das ist wichtig für die spätere Firebase-Synchronisierung, weil dort unnötige
Schreibvorgänge Kosten und Konflikte erhöhen würden.

## Prüfergebnisse

### Erfolgreich extern geprüft

Der Nutzer hat die gezielten Tests extern in PowerShell ausgeführt. Alle drei
Tests liefen erfolgreich:

- `Scheduler verarbeitet direkte Konsequenz als Misserfolg`
- `Scheduler verarbeitet direkte Konsequenz als Kein Eintrag`
- `erstellt einmalige Aufgabe mit Faelligkeit als Instanzdatum`

Damit sind die Kernfälle der Phase-8-Logik gezielt abgesichert.

Zusätzlich wurde ein komplexerer Szenario-Test extern in PowerShell ausgeführt
und erfolgreich bestanden:

- mehrere Tage Nichtnutzung
- direkte Konsequenz als `failure`
- direkte Konsequenz als `noEntry`
- Aufgabe ohne Missed Policy bleibt offen
- manuell erledigte Instanz wird nicht überschrieben
- wöchentlicher Fixtermin
- einmalige Aufgabe mit Fälligkeit
- zweiter Scheduler-Lauf erzeugt keine Duplikate

Damit ist nicht nur das Einzelverhalten, sondern auch das Zusammenspiel mehrerer
typischer Phase-8-Fälle geprüft.

### In Codex geprüft

- `dart format` lief für die betroffenen Dart-Dateien erfolgreich.
- Die gezielte Flutter-/Dart-Analyse wurde mit hartem Prozess-Timer gestartet,
  hing aber in der Codex/VS-Code-Umgebung und wurde als `TIMEOUT` beendet.

Wichtig: Die externe PowerShell zeigt, dass Dart und Flutter grundsätzlich
funktionieren. Das Problem liegt wahrscheinlich in der eingebetteten
Codex-/VS-Code-Toolumgebung oder in dort hängenden Analyzer-Prozessen.

## Praxischeck in der App

Der Nutzer hat die laufende App grob geprüft. Ergebnis:

- Aufgabenansicht und Detailansichten laden wieder.
- Die App wirkt im geprüften Bereich plausibel.
- Gelegentliche diagonale Grafikartefakte wurden als wahrscheinliches
  Emulator-/Rendering-Artefakt eingeordnet, nicht als fachlicher App-Fehler.

Damit ist Phase 8 praktisch ausreichend geprüft, um mit Phase 9 fortzufahren.

## Nicht Teil dieser Phase

- Pufferlogik
- Carryover/Aufstauen
- Zielbewertung
- Papierkorb
- Unteraufgaben
- echte Firebase-Synchronisierung

Diese Punkte bleiben in späteren Phasen.
