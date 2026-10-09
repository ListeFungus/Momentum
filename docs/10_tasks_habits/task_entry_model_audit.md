# Momentum – TaskEntry-Modell und Phase-6-Stand

> Übergangsquelle: Dieses technische Audit bleibt vorerst erhalten, wird aber
> schrittweise in [`task_phase_history.md`](task_phase_history.md) integriert.
> Für den aktuellen Ablauf ist [`task_structure_plan.md`](task_structure_plan.md)
> führend.

Stand: 8. Juli 2026  
Status: Phase-6-Grundmodell und vollständige Definitionsversionierung mit Schema-Version 11 umgesetzt

## Zweck

Dieses Dokument hält die Bestandsaufnahme des früheren `TaskEntry`-Modells,
die daraus umgesetzten Korrekturen und die noch offenen Entscheidungen fest.

## Mit Schema-Version 9 umgesetzt

### Eindeutige Statuswerte

| Technischer Wert | Fachliche Bedeutung | Endgültiger Abschluss? |
|---|---|---:|
| `pending` | Instanz ist noch offen und unbeantwortet | nein |
| `success` | Instanz wurde erfolgreich abgeschlossen | ja |
| `failure` | Instanz wurde aktiv oder automatisch als Misserfolg abgeschlossen | ja |
| `no_entry` | Ohne wertende Antwort abgeschlossen, optional mit Grund/Notiz | nein; bei einem Rhythmus nach Abschluss kein Auslöser für eine Folgeinstanz |

Ein manuelles `Ja` wird als Erfolg und ein manuelles `Nein` als Misserfolg
gespeichert. Keine Auswahl bleibt während der laufenden Frist `pending`, also
offen. Nach Ablauf kann eine konfigurierte Konsequenz daraus `no_entry` machen.
Ein `no_entry`-Eintrag kann mit Grund beziehungsweise Notiz ergänzt werden.
`no_entry` besitzt einen Interaktionszeitpunkt, aber keinen endgültigen
Abschluss- oder Wirksamkeitszeitpunkt. Es bleibt eine eigene, später
auswertbare Ausnahmekategorie und ist weiterhin weder positive noch negative
Antwort.

### Zeitpunkte und Herkunft

| Feld | Bedeutung |
|---|---|
| `respondedAt` | Zeitpunkt der tatsächlichen manuellen Interaktion beziehungsweise späteren automatischen Verarbeitung |
| `finalizedAt` | Zeitpunkt, an dem Erfolg oder Misserfolg endgültig gespeichert wurde |
| `effectiveAt` | Fachlicher Wirksamkeitszeitpunkt; Ausgangspunkt für abschlussgebundene Folgetermine |
| `updatedAt` | Letzte technische Änderung am Datensatz, beispielsweise auch eine Notizänderung |
| `resolutionOrigin` | `manual`, `automatic` oder `migration` |
| `appliedMissedPolicy` | Bei automatischer Verarbeitung verwendete Missed Policy |
| `appliedMissedConsequence` | Bei automatischer Verarbeitung verwendete Konsequenz |

Die Policy-Felder sind vorbereitet. Sie werden erst befüllt, wenn die
automatische Missed-Policy-Verarbeitung in den Phasen 8 bis 10 umgesetzt wird.

Das frühere Altfeld `completedAt` wurde mit Schema-Version 11 entfernt. Seine
historischen Werte werden bei der Migration vor dem Entfernen in die eindeutigen
Felder `respondedAt`, `finalizedAt` und `effectiveAt` überführt.

### Schreibverhalten

- Checkbox erledigt: `success`, manuelle Herkunft und alle drei neuen
  Zeitpunkte werden gesetzt.
- Checkbox wieder geöffnet: `pending`; Abschlussmetadaten werden entfernt.
- Ja/Nein `Ja`: `success` mit manuellen Abschlussmetadaten.
- Ja/Nein `Nein`: `failure` mit manuellen Abschlussmetadaten.
- Abwählen einer Ja/Nein-Antwort: zurück zu `pending`; Antwort- und
  Abschlussmetadaten werden entfernt.
- `Kein Eintrag`: `no_entry` mit Interaktions- oder Verarbeitungszeitpunkt;
  Grund/Notiz kann ergänzt werden; endgültige Abschlussmetadaten werden nicht
  gesetzt.
- Eine Notizänderung erhält Antwort, Abschluss, Wirksamkeit, Herkunft und
  Policy-Snapshot. Nur `updatedAt` wird verändert.

### Rhythmus nach Abschluss

- Erfolg und Misserfolg gelten als endgültige Abschlüsse.
- Der nächste Abstand beginnt mit `effectiveAt`, nicht mit `scheduledDate`.
- Eine offene Instanz verhindert die Erzeugung einer weiteren Instanz.
- `no_entry` löst keine Folgeinstanz aus.

Damit folgt das Laufzeitmodell den bestätigten Regeln für „7 Tage nach
Abschluss“ und „X Tage nach Abschluss“.

### Migration bestehender Daten

- Der frühere Wert `completed` wird zu `success`.
- Ein gespeichertes `false` einer Drei-Wege-Aufgabe wird als `failure`
  übernommen.
- Bestehende endgültige Einträge erhalten die Herkunft `migration`.
- Alte Version-2- und unvollständige Version-7-Datenbanken werden robust auf
  das aktuelle Schema angehoben.

Die Migration kann bei alten Daten nicht rekonstruieren, ob `updatedAt` früher
nur durch eine Notizänderung entstand. Für bereits endgültige Alteinträge ist
dieser Wert deshalb die bestmögliche, aber nicht garantiert exakte Annäherung.

## Darstellung und Statistiken

- Offene Ansichten verwenden den endgültigen Status und behandeln einen
  Misserfolg nicht mehr als offen.
- Erfolg und Misserfolg werden gemeinsam als „abgeschlossen“ bezeichnet.
- „Erledigt“ beziehungsweise „Erfolg“ bleibt der positiven Wertung vorbehalten.
- Projektstatistiken behandeln `pending` als offen und zählen `success` als
  Erfolg. `no_entry` ist eine separate Ausnahmekategorie und nicht automatisch
  offen.
  Detaillierte Fehler-/Ausnahmequoten gehören in die Grundauswertung von Phase 7.

## Definitionsversionierung seit Schema-Version 11

Die Tabelle `task_definition_versions` speichert vollständige
Aufgabendefinitionen mit stabiler ID, fortlaufender Versionsnummer,
`previousVersionId` und Gültigkeitsbeginn. Die gemeinsame `taskId` verbindet die
Versionskette. `task_entries.task_definition_version_id` verbindet jede Instanz
mit ihrer damals gültigen Version.

- Bei der Aufgabenerstellung entsteht Version 1.
- Jede tatsächliche Änderung, einschließlich Name, Beschreibung, Fragetext und
  Projekt-ID, erzeugt eine neue vollständige Version.
- Unverändertes Speichern erzeugt keine zusätzliche Version.
- Bereits vorhandene Einträge behalten auch bei einer späteren Statuskorrektur
  ihre Versions-ID.
- Neu erzeugte Einträge verwenden die aktuelle Version.
- Bestehende Datenbanken erhalten bei der Migration eine Version 1; vorhandene
  Einträge werden mit ihr verknüpft.

Gesamtauswertungen dürfen gemeinsame Rohkennzahlen über Versionen aggregieren.
Zielzeiträume werden zuerst nach ihrer jeweiligen Version bewertet und erst
danach als Anteil erreichter Zeiträume zusammengeführt.

## Noch bestehende technische Grenzen

1. Ein zentrales `TaskInstanceScheduler`-Grundgerüst ist umgesetzt und geprüft.
   Es wird bereits als gemeinsame technische Nahtstelle für die Tagesansicht
   verwendet. Die vollständige App-Start-, Rückkehr- und Tageswechsel-
   Verarbeitung ist aber noch nicht angebunden. Bis dahin sind nicht geöffnete
   Tage außerhalb expliziter Scheduler-Läufe noch nicht garantiert vollständig
   materialisiert.
2. Automatische Missed Policies, Puffer und Carryover sind noch nicht aktiv;
   ihre Metadatenfelder sind lediglich vorbereitet.
3. Rückwirkende Statuskorrekturen überschreiben aktuell den Eintrag. Bereits
   erzeugte Folgeinstanzen bleiben gemäß E-47 unverändert; eine gesonderte
   Änderungshistorie des korrigierten Eintrags ist noch nicht umgesetzt.
4. Die ID `taskId:YYYY-MM-DD` erlaubt höchstens eine Instanz derselben Aufgabe
   pro Kalendertag. Für die derzeit vereinbarten Rhythmen genügt das.
5. Die damalige Projekt-ID ist gespeichert; historische Namen und Farben des
   Projekts selbst benötigen bei Bedarf eine eigene Projektversionierung.

## Verifikation

- Drift-Code für Schema-Version 11 erfolgreich generiert.
- Gezielter Aufgaben-Repository-, Scheduler- und Migrationstest: 14 Tests
  bestanden.
- Gezielter Projekt-Repository-Test: 2 Tests bestanden.
- Gezielte statische Prüfung der geänderten Aufgaben- und Projektansichten:
  keine Probleme gefunden.

Es wurden keine Widget-Tests und kein vollständiger Flutter-Testlauf ausgeführt.
