# Momentum – Phase 8: Direkte Missed-Konsequenz

Stand: 16. Juli 2026  
Status: abgeschlossen; Kernlogik umgesetzt, komplex getestet und grob in der App geprüft

## Zweck dieses Dokuments

Dieses Dokument ist die kurze Arbeitskarte für Phase 8. Der ausführliche Verlauf steht in
[`direct_missed_policy_history.md`](direct_missed_policy_history.md).

## Ziel von Phase 8

Wenn eine Instanz abgelaufen ist und die Aufgabe auf **direkte Konsequenz**
gestellt wurde, wird diese Instanz automatisch abgeschlossen.

Erlaubte automatische Konsequenzen:

- `failure`: als nicht erfolgreich abschließen
- `no_entry`: als „Kein Eintrag“ abschließen

Nicht erlaubt:

- automatischer Erfolg

## Fachliche Leitplanken

| Regel | Bedeutung |
|---|---|
| Kein automatischer Erfolg | Eine versäumte Aufgabe darf nie positiv gewertet werden. |
| Jede Instanz einzeln | Automatische Verarbeitung betrifft konkrete `task_entries`, nicht nur einen Zähler. |
| Nachvollziehbarkeit | Automatisch abgeschlossene Instanzen speichern Herkunft, Policy und Konsequenz. |
| Idempotenz | Mehrfaches Ausführen darf keine doppelten Einträge oder geänderten Ergebnisse erzeugen. |
| Schreibsparsamkeit | Für spätere Firebase-Synchronisierung werden nur echte Zustandsänderungen geschrieben. |

## Ablauf und Status

| Schritt | Inhalt | Status |
|---:|---|---|
| 8.1 | Bestandsaufnahme im Code | erledigt |
| 8.2 | Fälligkeitsregel festlegen | erledigt: Eine Instanz ist abgelaufen, wenn ihr relevanter Tag vorbei ist. |
| 8.3 | Konsequenz-Mapping festlegen | erledigt: `mark_as_not_done` → `failure`, `keep_neutral` → `no_entry`. |
| 8.4 | Scheduler erweitern | erledigt: Fehlende vergangene Instanzen werden nacherzeugt und direkte Konsequenz wird angewendet. |
| 8.5 | Metadaten setzen | erledigt: automatische Herkunft, Policy, Konsequenz, `finalizedAt`, `effectiveAt`. |
| 8.6 | Lifecycle anbinden | im Code ergänzt: App-Start, Rückkehr aus Hintergrund und Tageswechsel bei geöffneter App. |
| 8.7 | Gezielte Prüfung | Kernfälle und komplexes Nachholszenario extern per PowerShell erfolgreich getestet; Analyse in Codex-Umgebung hängt weiterhin. |
| 8.8 | Dokumentation aktualisieren | erledigt. |

## Geklärte Punkte

| Frage | Stand |
|---|---|
| Wann ist eine Instanz abgelaufen? | Wenn der relevante Tag vorbei ist; bei Tageswechsel um 00:00 Uhr wird der vorherige Tag verarbeitet. |
| Was ist der Stichtag? | Fachlich der Fälligkeitstag. Technisch verarbeitet die App die konkrete Instanz über `scheduledDate`. |
| Welche Rolle hat `dueDate`? | Bei einmaligen Aufgaben mit Fälligkeit wird die Instanz auf dieses Fälligkeitsdatum gelegt. |
| Was bedeutet `no_entry`? | `no_entry` erzeugt keine Konsequenz. Die gewählte Konsequenz kann eine abgelaufene Instanz als `no_entry` speichern. |
| Was passiert nach längerer Nichtnutzung? | Fehlende vergangene Instanzen werden nacherzeugt und nach ihrer Missed Policy verarbeitet. |
| Bleiben vergangene Einträge korrigierbar? | Ja. Vergangene Einträge sollen nachträglich bearbeitbar bleiben. Bestehende Folgeinstanzen werden dadurch nicht automatisch neu terminiert. |

## Weiterhin zu beachten

| Frage | Warum wichtig? | Vorschlag |
|---|---|---|
| Toolchain-Stabilität in Codex/VS Code | Analyzer und Flutter-Befehle hängen teilweise in der eingebetteten Umgebung, obwohl externe PowerShell funktioniert. | Größere Prüfungen vorerst extern in PowerShell ausführen; Codex nutzt nur kurze Befehle mit hartem Timer. |

## Nicht Teil von Phase 8

- Pufferlogik nach Kulanzzeit
- Carryover/Aufstauen mit Maximum
- Zielbewertung
- Unteraufgaben/Checklisten
- Papierkorb
- Firebase-Synchronisierung selbst
- frei konfigurierbare Reset-Zeit

## Erfolgsbedingung

Phase 8 ist fachlich abgeschlossen, wenn:

1. direkte Konsequenz automatisch aus `pending` einen endgültigen Status macht,
2. `failure` und `no_entry` korrekt unterstützt werden,
3. automatische Herkunft und angewendete Policy gespeichert werden,
4. fehlende vergangene Instanzen nach Nichtnutzung nacherzeugt werden,
5. der Scheduler bei App-Start, Rückkehr und Tageswechsel angestoßen wird,
6. die wichtigsten Kernfälle gezielt geprüft wurden,
7. die praktische App-Ansicht nach der Änderung keine Ladefehler zeigt.

Punkt 1 bis 7 sind erfüllt. Zusätzlich wurde ein komplexes Nachholszenario mit
mehreren Aufgabenarten erfolgreich geprüft. Phase 8 ist damit abgeschlossen.
