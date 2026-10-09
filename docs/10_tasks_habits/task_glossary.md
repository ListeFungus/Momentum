# Momentum – Glossar für Aufgaben, Habits und Auswertung

Stand: 9. August 2026  
Status: zentrales Nachschlagewerk für Begriffe

## Zweck

Dieses Dokument erklärt die Begriffe, die wir bei Aufgaben, Habits, Instanzen,
Missed Policies, Zeitpunkten und Auswertungen verwenden.

Es soll helfen, fachliche Begriffe und technische Speicherfelder auseinander zu
halten. Viele Begriffe klingen ähnlich, bedeuten aber an unterschiedlichen
Stellen etwas anderes.

## Kurzüberblick: wichtigste Begriffe

| Begriff | Kurz erklärt | Beispiel |
|---|---|---|
| Aufgabe | Die Definition dessen, was erledigt, beantwortet oder ausgewertet werden soll. | „Bad putzen“ |
| Habit | Eine Aufgabe, die regelmäßig beobachtet oder aufgebaut werden soll. | „Wasser trinken“ |
| Instanz | Ein einzelner geplanter Eintrag einer Aufgabe für einen konkreten Tag. | „Bad putzen am 16. Juli“ |
| Aufgabendefinition | Die dauerhafte Grundbeschreibung einer Aufgabe. | Name, Rhythmus, Missed Policy, Ziel |
| Task Entry / Eintrag | Technischer Datensatz einer Instanz. | Zeile in `task_entries` |
| Status | Der aktuelle oder endgültige Zustand einer Instanz. | `pending`, `success`, `failure`, `no_entry`, `recorded` |
| Missed Policy | Regel, was passiert, wenn eine Instanz nicht rechtzeitig bearbeitet wird. | direkte Konsequenz, Puffer, Aufstauen |
| Konsequenz | Ergebnis, das eine Missed Policy bei Ablauf speichern kann. | als Misserfolg oder als Kein Eintrag speichern |
| Ziel | Auswertungsregel, die prüft, ob ein gewünschtes Verhalten erreicht wurde. | dreimal pro Woche |
| Auswertung | Berechnung aus gespeicherten Instanzen und Statuswerten. | Erfolgsquote, offene Einträge |

## Aufgabenstruktur

| Begriff | Bedeutung | Beispiel |
|---|---|---|
| Aufgabe | Fachliche Definition, die angezeigt und bearbeitet wird. Eine Aufgabe kann einmalig oder wiederkehrend sein. | „Steuererklärung abgeben“ |
| Habit | Spezialisierte Aufgabe für regelmäßiges Verhalten. Habits verwenden dieselbe Datenstruktur wie Aufgaben. | „10 Minuten lesen“ |
| Einmalige Aufgabe | Aufgabe ohne Wiederholung. Sie hat normalerweise nur eine relevante Instanz. | „Rechnung bezahlen“ |
| Wiederkehrende Aufgabe | Aufgabe, die nach einem Rhythmus mehrere Instanzen erzeugt. | „Jeden Montag Müll rausstellen“ |
| Aufgabendefinition | Die gespeicherte Beschreibung einer Aufgabe. Sie enthält z. B. Name, Beschreibung, Rhythmus, Projekt, Ziel und Missed Policy. | „Bad putzen, wöchentlich, direkte Konsequenz“ |
| Definitionsversion | Historischer Snapshot der Aufgabendefinition. Neue Versionen entstehen bei relevanten Änderungen. | Alte Version: täglich; neue Version: wöchentlich |
| Projekt | Gruppierung für Aufgaben. Projekte können Farbe, Namen und Sortierung haben. | „Wohnung“, „Arbeit“ |
| Ohne Projekt | Aufgabe ohne Projektzuordnung. | „Spaziergang“ ohne Projekt |
| Unteraufgabe | Später geplantes Checklisten-Element innerhalb einer Aufgabe. Noch nicht umgesetzt. | „Dusche reinigen“ innerhalb von „Bad putzen“ |

## Instanzen und Einträge

| Begriff | Bedeutung | Beispiel |
|---|---|---|
| Instanz | Eine konkrete Ausprägung einer Aufgabe für einen bestimmten Tag oder Termin. Sie entsteht z. B. durch Wiederholung. | Die tägliche Aufgabe „Sport“ erzeugt eine Instanz für den 16. Juli. |
| Task Entry / Eintrag | Technischer Datensatz einer Instanz. In der Datenbank heißt er `task_entries`. | Eintrag mit `taskId`, `scheduledDate`, `status` |
| Geplante Instanz | Instanz, die aus Rhythmus, Startdatum oder Fälligkeit entstehen soll. | „Medikament nehmen am 17. Juli“ |
| Offene Instanz | Instanz mit Status `pending`. Sie ist noch nicht endgültig beantwortet oder verarbeitet. | Heute noch nicht abgehakt |
| Abgeschlossene Instanz | Instanz mit endgültigem Status, z. B. `success`, `failure`, `no_entry` oder `recorded`. | Gestern als erledigt gespeichert |
| Aufgestaute Instanz | Vergangene offene Instanz, die sichtbar bleibt, während neuere Instanzen zusätzlich entstehen. | Drei nicht erledigte Tageskarten derselben Aufgabe |
| Folgeinstanz | Neue Instanz, die nach einem Rhythmus oder nach Abschluss einer vorherigen Instanz entsteht. | „X Tage nach Abschluss“ erzeugt nach Erledigung eine neue Instanz |

Wichtig:

Eine Instanz ist nicht einfach nur ein Zähler. Sie ist ein eigener Eintrag, der
unabhängig beantwortet, korrigiert und später ausgewertet werden kann.

## Statuswerte

| Technischer Status | UI-Bedeutung | Wertend? | Abgeschlossen? | Beispiel |
|---|---|---:|---:|---|
| `pending` | Offen / noch nicht beantwortet | nein | nein | Aufgabe läuft noch oder wurde noch nicht angefasst |
| `success` | Erfolg / erledigt / Ja | ja, positiv | ja | „Bad geputzt“ wurde erledigt |
| `failure` | Misserfolg / nicht erledigt / Nein | ja, negativ | ja | Aufgabe wurde aktiv oder automatisch als nicht erledigt gespeichert |
| `no_entry` | Kein Eintrag / neutral abgeschlossen | nein | ja | Keine sinnvolle Antwort möglich, z. B. krank |
| `recorded` | Wert erfasst | neutral als Rohstatus | ja | Gewicht, Dauer oder Uhrzeit wurde eingetragen |

Merksatz:

- `pending` = läuft noch.
- `no_entry` = abgeschlossen, aber ohne Ja-/Nein-Wertung.
- `success` und `failure` = wertende Antworten.
- `recorded` = Wert wurde erfasst; Zielerfolg wird später separat berechnet.

## Eingabe und Antwort

| Begriff | Bedeutung | Beispiel |
|---|---|---|
| Ja | Positive Antwort, wird als `success` gespeichert. | „Heute trainiert?“ → Ja |
| Nein | Negative Antwort, wird als `failure` gespeichert. | „Heute trainiert?“ → Nein |
| Keine Auswahl | Solange die Instanz läuft: `pending`. | Noch nicht beantwortet |
| Kein Eintrag | Bewusster oder automatischer neutraler Abschluss: `no_entry`. | Krank, Urlaub, nicht möglich |
| Notiz | Freier Text zu einer Instanz. Kann Gründe oder Kontext enthalten. | „Krank“, „Termin verschoben“ |
| Wert-Eingabe | Eingabe eines Mess- oder Trackingwerts statt Ja/Nein. | 2,5 Liter, 35 Minuten, 23:15 Uhr |
| Reines Tracking | Wert wird freiwillig erfasst; leere Tage werden nicht automatisch gespeichert. | Gewicht notieren |
| Verbindliche Wert-Eingabe | Wert muss erfasst werden; bei Ablauf kann eine Missed Policy greifen. | täglich Blutzucker eintragen |

## Erweiterte Erfassungsarten

| Begriff | Bedeutung | Beispiel |
|---|---|---|
| Werttyp | Art des gespeicherten Werts. | Zahl, Dauer, Uhrzeit |
| Zahl | Numerischer Wert mit fester Einheit oder eigener Beschriftung. | 2,5 Liter, 10 Seiten |
| Dauer | Zeitspanne als Wert. | 35 Minuten |
| Uhrzeit | Tageszeit mit Bezug zum Instanztag oder Folgetag. | 23:00 Uhr am geplanten Tag |
| Einheit | Feste Eingabeeinheit eines Trackings. | ml, km, Minuten |
| Einheitenfamilie | Gruppe kompatibler Einheiten, die umgerechnet werden können. | Liter und Milliliter |
| Eigene Einheit | Freie Beschriftung ohne automatische Umrechnung. | Schritte, Seiten, Wiederholungen |
| Zwei-Werte-Bündel | Gemeinsame Eingabekarte aus zwei eigenständigen Trackings. | Schlafenszeit + Aufstehzeit |
| Bündelwert | Abgeleiteter Wert aus zwei Teilwerten. Er wird nicht doppelt als eigener Entry gespeichert. | Schlafdauer aus Start- und Endzeit |
| Teil-Tracking | Eines der beiden eigenständigen Trackings innerhalb eines Bündels. | Bettgehzeit |
| Buendelstatus | Abgeleiteter Anzeigestatus eines Buendels. | leer, teilweise erfasst, vollstaendig, nicht berechenbar |
| Zeitintervall | Buendeltyp, der aus zwei Uhrzeiten eine Dauer berechnet. | 23:30 bis 07:15 = 7 h 45 min |
| Differenz-Buendel | Buendeltyp, der zwei kompatible Werte voneinander abzieht. | Aufnahme minus Verbrauch |
| Summen-Buendel | Buendeltyp, der zwei kompatible Werte addiert. | Dauer A plus Dauer B |

## Zeit- und Datumsbegriffe

| Begriff / Feld | Ebene | Bedeutung | Beispiel |
|---|---|---|---|
| `task.createdAt` | Aufgabe | Zeitpunkt, an dem die Aufgabe angelegt wurde. | Aufgabe wurde am 10. März erstellt |
| `task.startDate` | Aufgabe | Datum, ab dem eine Aufgabe fachlich zählt oder sichtbar werden darf. | Erst ab 15. März starten |
| `task.dueDate` | Aufgabe | Ausgewähltes Fälligkeitsdatum der Aufgabe. Besonders relevant bei einmaligen Aufgaben. | Steuererklärung fällig am 31. Juli |
| `entry.createdAt` | Instanz | Zeitpunkt, an dem die konkrete Instanz gespeichert oder erzeugt wurde. | Instanz wurde beim App-Start nacherzeugt |
| `entry.scheduledDate` | Instanz | Fachlicher Tag, zu dem die Instanz gehört. Für Missed Policies ist das der technische Stichtag der Instanz. | Tagesinstanz für den 16. Juli |
| `entry.updatedAt` | Instanz | Zeitpunkt der letzten technischen Änderung an der Instanz. | Notiz wurde später geändert |
| `entry.respondedAt` | Instanz | Zeitpunkt, an dem eine Person aktiv geantwortet hat. | Nutzer tippt um 20:15 auf Ja |
| `entry.finalizedAt` | Instanz | Zeitpunkt, an dem die Instanz endgültig abgeschlossen wurde. | Automatisch um 00:00 abgeschlossen |
| `entry.effectiveAt` | Instanz | Fachlich wirksamer Abschlusszeitpunkt für Auswertung und Rückrechnung. | Abschluss zählt für den abgelaufenen Tag |
| Tageswechsel | Systemregel | Aktuell 00:00 Uhr. Dann werden abgelaufene Tage verarbeitet. | Am 17. Juli wird der 16. Juli verarbeitet |
| Nachtragefenster | Spätere Idee | Optionales Zeitfenster, das nur für Rechtzeitigkeitsauswertung zählt. | „Nachteulen-Modus“ bis 04:00 Uhr |

### Unterschied `dueDate` und `scheduledDate`

| Frage | Antwort |
|---|---|
| Warum gibt es beide? | `dueDate` beschreibt die Aufgabe. `scheduledDate` beschreibt die konkrete Instanz. |
| Wann sind sie gleich? | Bei einer einmaligen Aufgabe mit Fälligkeit sollte die Instanz fachlich auf dieses Fälligkeitsdatum gelegt werden. |
| Was nutzt die Missed Policy technisch? | Die konkrete Instanz, also `scheduledDate`. |
| Was meint der Nutzer fachlich? | Den ausgewählten Fälligkeitstag. Dieser muss technisch korrekt als Instanztermin abgebildet werden. |

Beispiel:

- Aufgabe: „Steuererklärung abgeben“
- `dueDate`: 31. Juli
- Instanz: „Steuererklärung am 31. Juli“
- `scheduledDate`: 31. Juli

Bei wiederkehrenden Aufgaben gibt es mehrere Instanzen:

- Aufgabe: „Medikament nehmen“
- Instanz 1: `scheduledDate` 16. Juli
- Instanz 2: `scheduledDate` 17. Juli
- Instanz 3: `scheduledDate` 18. Juli

## Rhythmus

| Begriff | Bedeutung | Beispiel |
|---|---|---|
| Einmalig | Keine Wiederholung. | „Pass verlängern“ |
| Täglich | Jeden Tag entsteht eine Instanz. | „Zähne putzen“ |
| Wöchentlich | Instanzen entstehen an bestimmten Wochentagen oder nach Abschluss. | Montag und Donnerstag |
| Monatlich | Instanzen entstehen an bestimmten Monatstagen oder am letzten Tag des Monats. | Jeden 15. |
| Kalendergebundener Rhythmus | Neue Instanzen entstehen anhand des Kalenders. | täglich, feste Wochentage |
| Abschlussgebundener Rhythmus | Neue Instanz entsteht erst nach Erfolg oder Misserfolg der vorherigen Instanz. | X Tage nach Abschluss |
| X Tage nach Abschluss | Abstand startet erst nach endgültigem Erfolg oder Misserfolg. | 3 Tage nach erledigter Aufgabe |

## Missed Policies

| Begriff | Bedeutung | Beispiel |
|---|---|---|
| Missed Policy | Regel, was bei nicht rechtzeitiger Bearbeitung passiert. | direkte Konsequenz |
| Keine Missed Policy | Instanz bleibt offen, auch wenn sie überfällig ist. | Aufgabe bleibt mit `−X Tage` sichtbar |
| Direkte Konsequenz | Nach Ablauf des relevanten Tages wird automatisch ein Status gespeichert. | am nächsten Tag `failure` |
| Puffer | Nach Ablauf des regulären Tages bleibt noch eine Kulanzzeit. Danach greift eine Folgeregel. | drei Puffertage |
| Puffertag | Tag innerhalb der Kulanzzeit nach dem regulären Fälligkeitstag. | `Puffer Tag 2/5` |
| Carryover / Aufstauen | Nicht erledigte Instanzen bleiben sichtbar, neue Instanzen kommen dazu. | fünf offene Tageskarten |
| Konsequenz | Ergebnis, das bei Ablauf gespeichert wird. | als Misserfolg speichern |
| Automatischer Erfolg | Ausgeschlossen. Eine versäumte Instanz darf nie automatisch Erfolg werden. | nicht erlaubt |
| Konsequenz `failure` | Abgelaufene Instanz wird als nicht erfolgreich abgeschlossen. | „Nicht erledigt“ |
| Konsequenz `no_entry` | Abgelaufene Instanz wird als neutral „Kein Eintrag“ abgeschlossen. | keine aktive Antwort |

Wichtig:

`no_entry` erzeugt keine Konsequenz. Die Konsequenz erzeugt den Status
`no_entry`.

Zusatz für Puffer:

- Puffer ist eine verzögerte Konsequenz.
- Innerhalb des Puffers soll die Aufgabe als im Spielraum sichtbar sein, nicht
  einfach als `−X Tage`.
- Nach dem Puffer sind automatische Abschlüsse als `failure` oder `no_entry`
  möglich.
- `no_entry` nach Puffer ist erlaubt, sollte aber mit einem Hinweis erklärt
  werden, weil es die Auswertung neutral behandelt.
- `keep_open` ist nicht dasselbe wie `no_entry`: `keep_open` bedeutet, dass die
  Instanz offen bleibt. Diese Logik wird nicht als Puffer-Sonderfall
  gespeichert, sondern über Carryover oder keine automatische Abschlussregel
  modelliert.
- Für kalendergebundene Rhythmen soll der Puffer maximal bis zur übernächsten
  regulären Erstellung reichen.

## Scheduler und automatische Verarbeitung

| Begriff | Bedeutung | Beispiel |
|---|---|---|
| Scheduler | Technische Logik, die fällige Instanzen erzeugt und später Missed Policies ausführt. | `TaskInstanceScheduler` |
| Instanzerzeugung | Erstellen fehlender geplanter Einträge. | fünf vergangene Tagesinstanzen nach Nichtnutzung |
| Nachholerzeugung | Fehlende vergangene Instanzen werden später nachträglich erzeugt. | App wurde fünf Tage nicht geöffnet |
| Idempotent | Mehrfaches Ausführen erzeugt keine Duplikate und verändert nichts unnötig. | Scheduler läuft zweimal, aber es gibt jede Instanz nur einmal |
| Schreibsparsam | Nur echte Änderungen werden gespeichert. Wichtig für spätere Firebase-Kosten. | Kein Cloud-Schreibvorgang bei reiner Anzeige |
| Lifecycle-Anbindung | Scheduler läuft bei App-Start, Rückkehr in die App oder Tageswechsel. | App öffnet → fehlende Tage werden verarbeitet |

## Ziele

| Begriff | Bedeutung | Beispiel |
|---|---|---|
| Kein Ziel | Nur Tracking, keine Zielprüfung. | „Stimmung notieren“ |
| Anzahl pro Zeitraum | Bestimmte Anzahl erfolgreicher Einträge in Woche/Monat. | dreimal pro Woche |
| Prozentziel | Gewünschter Erfolgsanteil. | 80 % |
| Maximale Fehlschläge | Ziel ist erreicht, wenn nicht zu viele Misserfolge auftreten. | maximal zweimal pro Monat |
| Rollierendes Ziel | Betrachtet die letzten X Tage. | 3 Erfolge in den letzten 10 Tagen |
| Zielbewertung | Prüfung, ob ein Ziel aktuell erreicht ist. | 2 von 3 pro Woche geschafft |

## Auswertung

| Begriff | Bedeutung | Formel / Beispiel |
|---|---|---|
| `successCount` | Anzahl erfolgreicher Instanzen. | 5 Erfolge |
| `failureCount` | Anzahl negativer Instanzen. | 2 Misserfolge |
| `noEntryCount` | Anzahl neutral abgeschlossener Instanzen. | 1 Kein Eintrag |
| `pendingCount` | Anzahl offener Instanzen. | 3 offen |
| `answeredCount` | Wertende Antworten. | `successCount + failureCount` |
| `resolvedCount` | Alle nicht mehr offenen Instanzen. | `success + recorded + failure + no_entry` |
| `dueCount` | Bereits fällige/vergangene Instanzen im Zeitraum. | vergangene Instanzen |
| `totalInstanceCount` | Alle Instanzen im Zeitraum, inklusive offener. | vergangene + offene |
| `strictSuccessRate` | Strenge Erfolgsquote. | `successCount / dueCount` |
| `valuedSuccessRate` | Erfolgsquote nur unter Ja-/Nein-Antworten. | `successCount / answeredCount` |
| `completionRate` | Anteil verarbeiteter Instanzen. | `resolvedCount / totalInstanceCount` |

## Historisierung und Bearbeitung

| Begriff | Bedeutung | Beispiel |
|---|---|---|
| Historische Einträge | Vergangene Instanzen bleiben erhalten. | Eintrag vom 1. Juli bleibt auswertbar |
| Nachträgliche Korrektur | Vergangene Einträge können später geändert werden. | Gestern nachträglich auf Erfolg setzen |
| Sammelkorrektur | Mehrere vergangene Einträge werden bewusst auf einmal geändert. | Alle `no_entry`-Einträge im Juli zu `failure` ändern |
| Definitionsversion | Snapshot der Aufgabe bei Änderung. | alte Version täglich, neue Version wöchentlich |
| `taskDefinitionVersionId` | Verknüpft eine Instanz mit der damals gültigen Definition. | Eintrag weiß, welche Regeln damals galten |
| Eingefrorene Folgeinstanz | Bereits erzeugte Folgeinstanzen werden durch spätere Korrekturen nicht neu terminiert. | Korrektur verändert Auswertung, aber löscht keine späteren Karten |

## UI-Begriffe

| Begriff | Bedeutung | Beispiel |
|---|---|---|
| Tagesansicht | Ansicht für Aufgaben eines bestimmten Tages. | Heute, gestern, morgen |
| Habit-Ansicht | Ansicht für Habits. | regelmäßige Gewohnheiten |
| Dringlichkeit | Sortierung/Ansicht nach Priorität oder Überfälligkeit. | älteste offene Instanz oben |
| Ohne Zeitdruck | Aufgaben ohne konkretes Fälligkeitsdatum. | irgendwann erledigen |
| Überfällig | Relevanter Tag ist vorbei, Instanz aber noch offen. | `−3 Tage` |
| Details & Auswertung | Detailansicht einer Aufgabe mit Kennzahlen oder konkreten Aufgabendaten. | Erfolgsquote, Status, Notizen |

## Technische Namen und fachliche Bedeutung

| Technischer Name | Fachliche Bedeutung | Hinweis |
|---|---|---|
| `Aufgabe` | Aufgabendefinition | Drift-Datenklasse für Aufgaben |
| `TaskEntry` | Instanz / Eintrag | Drift-Datenklasse für einzelne Instanzen |
| `TaskListForDate` | Gemeinsames Anzeigeergebnis fuer einen Tag | Enthaelt normale Aufgaben plus aktive Wert-Buendel |
| `TaskValueBundleForDate` | Sichtbares Buendel fuer einen konkreten Tag | Enthaelt Buendeldefinition, zwei Teil-Trackings, Status und berechneten Wert |
| `TaskValueBundleCalculation` | Berechneter Buendelwert | Dauer, Differenz oder Summe; wird nicht als eigener Entry gespeichert |
| `TaskValueBundleDisplayStatus` | Technischer Buendelstatus fuer die UI | `empty`, `partial`, `complete`, `not_calculable` |
| `taskId` | ID der Aufgabe | Verbindet Instanzen mit ihrer Aufgabe |
| `id` bei `TaskEntry` | ID der Instanz | Aktuell oft aus `taskId:YYYY-MM-DD` ableitbar |
| `projectId` | Projektzuordnung | Kann leer sein |
| `taskType` | Aufgabenart | z. B. Aufgabe oder Habit |
| `recurrence` | Wiederholungsrhythmus | täglich, wöchentlich, keine Wiederholung |
| `missedPolicy` | Missed Policy | keine, direkt, Puffer, Carryover |
| `missedConsequence` | Konsequenz bei Ablauf | z. B. `mark_as_not_done`, `keep_neutral` |
| `postBufferBehavior` | Verhalten nach Puffer | `mark_as_failure` oder `mark_as_no_entry`; `keep_open` ist nur noch Altwert/Legacy und kein neues Pufferverhalten |
| `maxCarryoverCount` | Maximal erlaubte Anzahl offener Carryover-Instanzen. Wird die Grenze überschritten, verarbeitet der Scheduler die ältesten überzähligen Instanzen automatisch. | 3 offene Karten erlaubt |
| `task_value_bundles` | Technische Buendel-Huelle. Speichert stabile Buendel-ID und Aktivitaetsstatus. | Buendel Schlafdauer |
| `task_value_bundle_versions` | Versionierte technische Buendeldefinition. Speichert Quellen, Formel, Rollen und Gueltigkeit. | Version 1: Bettgehzeit + Aufstehzeit |
| `goalType` | Zielart | z. B. Prozentziel |
| `goalValue` | Zielwert | z. B. 3 |
| `goalWindowDays` | Zeitraum für rollierendes Ziel | z. B. 10 Tage |

## Merksätze

- Eine Aufgabe ist die Definition.
- Eine Instanz ist ein konkreter Eintrag dieser Aufgabe.
- Wiederholung erzeugt Instanzen.
- Die Missed Policy verarbeitet Instanzen.
- `dueDate` beschreibt die Aufgabe; `scheduledDate` beschreibt die Instanz.
- `pending` ist offen.
- `no_entry` ist abgeschlossen, aber neutral.
- `recorded` ist abgeschlossen, aber noch keine Zielwertung.
- Erfolg darf nie automatisch entstehen.
- Auswertung zählt gespeicherte Instanzen, nicht nur sichtbare Karten.
