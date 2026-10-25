# Momentum – Kalender: Umsetzungsplanung

Stand: 21. Oktober 2026
Status: K0–K7 implementiert und automatisiert geprüft; Release-APK 1.0.0+4 bereit.
Gerätenachtest bleibt offen. Prüfstatus siehe Fortschritt unten.

## Auftrag und maßgebliche Quelle

Der Nutzer möchte den Kalender als nächstes umsetzen und beauftragt nun eine
explizite Übergabe für einen anderen Chat. Dieses Dokument ist dessen Arbeitsauftrag;
der vollständige bisherige Chatverlauf ist nicht erforderlich. #013 ist für den
Nutzer fachlich erledigt; dessen technische Restarbeit und Paket #002 sind keine
Voraussetzungen und gehören nicht zur Kalenderumsetzung.

Quelle: [Kalenderkonzept V0.4](../phase_20_private_test/calendar_concept.md),
GitHub-Stand vom 21. Oktober, Datei-Blob `44e07c06c298cf3c88ea1af432cd5bf8e485de27`:
[Original auf GitHub](https://github.com/ListeFungus/Momentum/blob/main/docs/10_tasks_habits/phase_20_private_test/calendar_concept.md).
Beim Einstieg fehlte diese Datei lokal. Das Konzept wurde übernommen, nicht aus
der älteren Kurzbeschreibung #018 neu erfunden. Dieser Plan hält die folgenden
Entscheidungen und die Umsetzung fest; das Konzept bleibt die fachliche Quelle.

## Bereits beschrieben – nicht erneut grundsätzlich abfragen

- Eigener Kalenderzugang; Tag, Woche, Monat und chronologische Liste umschaltbar.
- Zeitblöcke und Bereich „Ohne Uhrzeit“; Dauer allein ist erlaubt, keine automatische
  Verteilung in freie Zeitfenster. Monatszellen zeigen kompakte Tageszahlen.
- Optionale geplante Dauer bzw. Start-/Enduhrzeit; vorhandene Fälligkeit erhalten.
- Details/Bearbeitung per Antippen. Freie unabhängige einmalige Termine mit offenem
  Schloss verschieben, auch zwischen Tagen; Blocklänge im 15-Minuten-Raster ändern.
- Serien/abhängige Termine mit geschlossenem Schloss: kein direktes Verschieben
  oder Resize, auch regelmäßige Uhrzeiten nur regulär bearbeiten. Keine einzelnen
  Serienausnahmen in V1. Sperre aus Eigenschaften ableiten, kein manuelles Schloss.
- Sichere Zukunftsanzeige eindeutig bestimmbarer Termine. Unbestimmte nächste
  Folgetermine nicht als feste Termine vortäuschen: eigener Gesamtzähler mit
  aufrufbarer Liste; je Serie höchstens eine +1-Markierung am begründbaren frühesten
  Datum. Keine tägliche Wiederholung und keine Mischung mit festen Tageszahlen.
- Kein zusätzlicher ±Tage-Radius. Externe Kalender #019 bleiben getrennt.

## Geprüfter Ausgangspunkt im Code

- Keine eigenständige Kalenderansicht in den geprüften Dateien gefunden. Vorhanden
  sind Tagesnavigation bis heute und Sieben-Tage-Erledigungsdiagramm; letzteres
  ersetzt die gewünschte Kalenderplanung nicht.
- `AufgabenRepository.watchTaskListForDate` wendet Projektänderungen an und ruft
  `TaskInstanceScheduler.ensureEntriesForDate` auf. Dieser Pfad erzeugt Instanzen,
  wendet Definitionsänderungen und Missed-/Puffer-/Carryover-Regeln bis zum
  übergebenen Tag an. Nicht für die zukünftige Kalendervorschau verwenden.
- `Aufgabe` hat Start/Ende/Fälligkeit und Rhythmus; `TaskEntry` hat geplantes Datum,
  ursprüngliches Datum und Abschlussdaten. Geplante Startuhrzeit/Dauer fehlen dort.
  `durationSeconds`/`timeMinutes` der Werteingabe sind erfasste Messwerte, kein
  Ersatz für neue Kalender-Planungsdaten.
- `_rescheduleOneTimeEntry` kann eine offene einmalige Aufgabe auf heute oder
  später verschieben, erhält das ursprüngliche Datum und erhöht die Revision.
  Mehrere Einträge oder bereits abgeschlossene Aufgaben werden abgelehnt.
  Diesen Schutz beim neuen Kalenderzugang erhalten; nicht nur UI-Sperren setzen.

## Bestätigt: Planungstag und Fälligkeit

Nutzer bestätigt am 21. Oktober die einfache gemeinsame Datumsregel:

In V1 ist der Kalendertag zugleich der
Fälligkeitstag; eine optionale Uhrzeit/Dauer konkretisiert die Planung an diesem
Tag. Verschieben einer freien Aufgabe auf einen anderen Tag verschiebt damit
auch ihre Fälligkeit. Kein zweites Datumsfeld für eine unabhängige Deadline in V1.
Gemessene Dauer und tatsächliche Erledigung bleiben weiterhin getrennt.

Eine unabhängige Frist zusätzlich zum Planungstag (z. B. Dienstag bearbeiten,
Freitag spätestens fertig) gehört nicht zu V1. Diese Entscheidung ersetzt den
entsprechenden offenen Punkt im Quellkonzept. Aus einer geplanten Enduhrzeit
folgt noch keine minutengenaue Missed-Konsequenz; die vorhandenen Tagesregeln
werden nicht durch eine Kalenderanzeige stillschweigend geändert.

## Bestätigt: Filter und Standardansicht

- Standardmäßig nur **Aufgaben** anzeigen. Habits sind häufig kleine Routinen
  und sollen den regulären Kalender nicht standardmäßig füllen.
- **Aufgaben, Habits und reine Tracker** unabhängig über einen gemeinsamen
  Filter ein-/ausblendbar. Jede Kombination ist möglich; keine Zwangsauswahl.
- Tageszahlen folgen dem Filter, damit Anzeige und Zahl dieselben Einträge
  beschreiben. Diese Kalenderregel ist unabhängig vom Erledigungsdiagramm #007.

Abgeleitete Ausführungsdetails, keine weiteren Nutzerfragen nötig:

- Ein Filterzustand für alle vier Kalenderansichten; Auswahl lokal merken und
  mit den Einstellungen sichern. Erstnutzung bzw. Altsicherung ohne Auswahl:
  Aufgaben an, Habits/Tracker aus. Alles ausgeschaltet zeigt einen klaren
  Leerzustand mit Zugang zum Filter, keine automatische Rücksetzung.
- Überschneidungsfreie Einordnung: `value` + `pureTracking` fällt unter „Tracker“,
  unabhängig vom gespeicherten `taskType`. Alle übrigen Einträge nach Aufgabenart
  einordnen. Eine verpflichtende Werteingabe ist nicht automatisch reines Tracking.
  So erscheinen Gewichtstracker nicht versehentlich schon mit „Aufgaben“.
- Unbestimmt-Zähler und seine Detailansicht folgen derselben Auswahl; die Zahl
  wird als für die aktuelle Auswahl geltend beschriftet. Messungen werden durch
  Kalenderanzeige/Filter nicht in verpflichtende Erledigungen umgewandelt.
- Im Kalender die beiden eigenständigen Quellen eines Bündels jeweils nach
  ihrer Kategorie anzeigen/zählen, keinen dritten Block für das berechnete
  Bündelergebnis erzeugen. Bündelzugehörigkeit in den Details kenntlich machen.
  Bestehende kompakte Bündelkarten der normalen Tagesansicht bleiben unverändert.

## Erste Fallabgrenzung für V1

Aus Konzept und bestätigten Grenzen abgeleitet; im Datenpfad und in der Oberfläche
durchsetzen. Die folgenden Abschnitte konkretisieren Speicherung und Projektion.

| Fall | Anzeige | Direkte Kalenderänderung |
|---|---|---|
| Offene unabhängige einmalige Aufgabe | Am Fälligkeitstag, mit oder ohne Uhrzeit | Verschieben auf heute/später; Resize bei Zeitblock, solange zulässig |
| Regelmäßig festgelegter Termin | Eindeutige Tage lesend projizieren | Gesperrt; Rhythmus/Uhrzeit über reguläres Bearbeiten |
| Abschlussabhängige Serie, nächster Termin bereits bestimmbar | Den tatsächlich bestimmbaren nächsten Termin zeigen | Gesperrt; keine fiktive Kette weiterer Erledigungen |
| Abschlussabhängige Serie, Voraussetzung noch offen | Vorhandenen Termin erhalten; unbestimmte nächste Folge separat zählen | Gesperrt; begründbare +1-Markierung höchstens einmal je Serie |
| Abgeschlossener Eintrag | Historisch anzeigen, Status erhalten | Verschieben/Resize gesperrt; vorhandene Korrekturwege getrennt |
| Überfälliger offener Eintrag | Ursprünglichen Tag erhalten; Überfälligkeit kennzeichnen | Nur bei sonst freigegebener einmaliger Aufgabe auf heute/später verlegen |
| Pause, Ende oder Papierkorb | Keine neuen Vorkommen in ausgeschlossenen Zeiträumen; Bestands-/Historienregeln beachten | Kalenderoperation im ausgeschlossenen Zustand gesperrt |
| Bündel oder abhängige Quelle | Fachlich gültige vorhandene Darstellung, Filter und Zählung konsistent | Direktänderung zunächst sperren; kein automatisches Mitverschieben der Quellen |
| Zeitblock über Mitternacht / mehrtägiger Block | V1 unterstützt nur Blöcke innerhalb eines lokalen Tages | Grenzüberschreitung verständlich ablehnen, nichts teilweise speichern |
| Unzulässige/mehrdeutige Uhrzeit durch Zeitumstellung | Keine stillschweigende Zeitkorrektur | Betroffene Zeitwahl zunächst sperren und gültige Uhrzeit verlangen |

Vergangene Erledigungen bleiben sichtbar, erzeugen aber keine frei verschiebbaren
Planungseinträge. Der Kalender kopiert überfällige Aufgaben nicht als neue feste
Termine in jeden Folgetag. Offene ältere Einträge werden zusätzlich in einer
kompakten aufrufbaren Liste „Überfällig“ geführt, unabhängig vom sichtbaren
Kalenderzeitraum, aber gemäß Kategorienfilter. Sie zählen an ihrem ursprünglichen
Tag und nicht nochmals zu heutigen/geplanten Tageszahlen. Vorhandene Übertrags-
und Pufferregeln bleiben unverändert; „überfällig“ bedeutet hier Datum vor heute,
nicht automatisch Misserfolg. Einen laufenden Puffer bei der Darstellung beachten.

Zusätzlicher Codebefund: `_isAfterCompletionDue` beantwortet teilweise „ab diesem
Tag fällig“, nicht „an genau diesem Tag beginnt ein neues Vorkommen“. Für die
Vorschau darf deshalb nicht jeder positive Tag zu einem eigenen Termin werden.
Die Projektion muss explizite Vorkommen und offene/unbestimmte Nachfolger trennen.

## Technischer Vertrag V1

Diese Festlegungen schließen die technische Vorbereitung ab. Es sind abgeleitete
Implementierungsentscheidungen innerhalb des vereinbarten Umfangs. Gleichwertige
kleine technische Anpassungen sind erlaubt und hier zu dokumentieren. Keine
zusätzlichen Produktoptionen erfinden und bestätigte Funktionen nicht streichen.

### Zeitplanung und Datenhaltung

- Eine **geplante Dauer**, keine zusätzlichen parallelen Felder für Schätzung und
  Reservierung in V1. Ohne Startzeit ist sie ein Aufwandshinweis; mit Startzeit
  bestimmt sie die Blocklänge. Tatsächlich erfasste Dauer bleibt separat.
- Vorgesehene nullable Integer-Felder `plannedStartMinute` und
  `plannedDurationMinutes` auf `Aufgaben`, `TaskDefinitionVersions` und
  `TaskEntries`. Startzeit als lokale Minute seit 00:00, Dauer in Minuten;
  Endzeit ausschließlich daraus ableiten. Keine zweite Endzeit als konkurrierende
  Wahrheit speichern. Keine separaten Kopien von Aufgaben als Kalenderereignisse.
- Erlaubt: beide leer; nur positive Dauer; Startzeit mit positiver Dauer.
  Startzeit allein verlangt im Formular Dauer oder Endzeit. Start/Ende wandelt
  das Formular in Start/Dauer um. Start 0–1439, Dauer 1–1440; Zeitblock muss
  innerhalb des Tages enden (Endgrenze 24:00 erlaubt). Formulare minutengenau;
  Ziehen/Resize im 15-Minuten-Raster. Negative/Null-Dauer und Übernachtblöcke sperren.
- Kalenderzeiten sind lokale Wandzeiten, keine neuen UTC-Termine oder
  Zeitzonen-Synchronisierung. Kalendertage über Jahr/Monat/Tag fortschreiten,
  nicht durch Addition von 24 Stunden. Ungültige/mehrdeutige Uhrzeiten an
  Zeitumstellungstagen im Schreibpfad ablehnen; vorprojizierte Serienzeit auf
  solchem Tag mit Hinweis ohne erfundenen Zeitblock im Tagesbereich zeigen.
- Neue Einträge übernehmen Planungsfelder aus ihrer wirksamen Definition.
  Bestehende abgeschlossene Einträge behalten ihren Snapshot. Altdaten erhalten
  null, also keine erfundene rückwirkende Uhrzeit. Alle Instanzerzeugungswege
  berücksichtigen, auch direkte Wert-/Status-/Notizeingaben und Kopieren.
- Änderungen einer freien offenen einmaligen Aufgabe gelten sofort und ändern
  ihren vorhandenen offenen Eintrag atomar mit. Kein vorhandener Eintrag:
  erst beim bewussten Schreiben den bestehenden sicheren Anlegepfad verwenden.
  No-op erzeugt keine zusätzliche Historie. Abgeschlossene Einträge nicht anfassen.
- Regelmäßige Planungszeit/Dauer über reguläres Bearbeiten ändern, wirksam **ab
  morgen**, analog vorgemerkten Rhythmusänderungen. Bestehenden Vormerkungsmechanismus
  um eine eigene Gruppe `calendar` samt Payload erweitern; Tabellen-Constraint
  erlaubt bislang nur `schedule`/`goal` und muss mitmigriert werden. Kalendergruppe
  darf ausstehende Rhythmus-/Zieländerungen nicht löschen oder ersetzen.
- Beim tatsächlichen Anwenden einer Zeitänderung ausschließlich noch offene,
  nicht überfällige Instanzen ab deren Wirksamkeit mit dem neuen Planungssnapshot
  aktualisieren; alte/offene Rückstände und Abschlüsse bleiben unverändert.
  Korrektur-/Undo-Snapshots um die neuen Felder erweitern, alte JSON-Snapshots
  kompatibel lesen. Keine rückwirkende Änderung fachlicher Messdefinitionen nötig.
- Separater Singleton `CalendarSettings`: drei Filter-Booleans, optional letzte
  Ansicht; keine Liste aller projizierten Termine speichern. Datumsbereich ist
  flüchtiger UI-Zustand. Standardansicht Woche, Datum heute, Wochenbeginn Montag.

### Migration und Sicherungen

Ausgangsstand bei Vorbereitung: Schema 23, App `1.0.0+3`, Commit `a85e3d0` plus
lokale Dokumentationsänderungen. Im Umsetzungschat vor Beginn erneut prüfen.

- Bei unverändertem Ausgangsstand Schema 24: sechs nullable Planungsfelder,
  neue Einstellungstabelle und Erweiterung des Pending-Gruppen-Constraints.
  Bei zwischenzeitlicher Schemaänderung nächste freie Version verwenden.
- Alte Aufgaben/Versionen/Einträge unverändert übernehmen, neue Zeitfelder null;
  leere Einstellungen bedeuten Aufgaben an, Habits/Tracker aus. Alte ausstehende
  Änderungen und Korrekturen dürfen nicht verloren gehen.
- `BackupService.prepare` prüft derzeit Tabellen **und Spaltenanzahl exakt**.
  Deshalb Schema-22- und Schema-23-Dateien jeweils nach ihrer ursprünglichen
  Struktur prüfen, erst danach im Speicher neue nullable Spalten/Settings ergänzen
  und gegen das aktuelle Scratch-Schema validieren. Schema 22 zusätzlich um
  die schon bekannten Kartenpräferenzen ergänzen. Nicht bloß Versionsnummer freigeben.
- Formatversion 1 kann bleiben, wenn die Hülle unverändert ist. Neue Sicherung
  enthält alle neuen Daten; ältere Apps dürfen sie weiter verständlich ablehnen.
  Restore bleibt vollständiger Ersatz, keine Zusammenführung. Ungültige Zeitwerte
  und ungültige neue Payloads vor Bestandsänderung ablehnen.

### Lesende Kalenderprojektion

- Neues kleines Modul unter `lib/features/calendar/` vorsehen: Projektionsmodelle,
  reine Projektionslogik, Repository zum Laden/Beobachten und Command-Service für
  ausdrückliche Änderungen. Die normale Terminverarbeitung bleibt getrennt.
- Vorschlag Schnittstelle: `watchRange(from, to, filter)` liefert Vorkommen,
  Tageszahlen, offene Überträge und unbestimmte Serien. Vorkommen enthalten stabile
  Identität (Eintrag-ID oder Task-ID + lokaler Tag), Quelle, Datum, optionale
  Planungszeit/Dauer, echten Status oder Kennzeichnung „geplant“, Projekt und
  Änderbarkeit mit Sperrgrund. Pro Task/Tag höchstens ein Vorkommen.
- Daten einmal je beobachtetem Bereich gebündelt laden: Aufgaben, Einträge,
  historische Definitionen, ausstehende Patches, Projektzuordnungen, Unterbrechungen
  und nötige Bündelverknüpfungen. Für abschlussabhängige Serien zusätzlich den
  relevanten Vorgänger/offenen Eintrag außerhalb des sichtbaren Bereichs laden.
  Keine Datenbankabfrage pro Aufgabe und Tag. Änderungen an allen Abhängigkeiten,
  Korrektur/Undo, Filter, Mitternacht und Restore invalidieren die Projektion.
- Historische Definitionen datumsbezogen auflösen; ausstehende Rhythmus-, Ziel-,
  Kalender- und Projektänderungen ab ihrem Datum nur auf In-Memory-Kopien anwenden.
  Gleiche Payload-Auslegung wie beim tatsächlichen Anwenden verwenden. Keine
  `applyDueChanges`, `ensureEntriesForDate`, Missed-Verarbeitung oder Inserts im
  Leseweg – auch nicht beim Antippen einer Zukunftsprojektion.
- Vorhandene Instanzen haben Vorrang vor virtuellen Vorkommen und behalten ihre
  echten Status-/Datums-/Planungssnapshots. Im Zukunftsbereich noch nicht angewandte
  Zeit-Patches als Vorschau kenntlich auf offene Instanzen anwenden, ohne sie zu
  speichern; abgeschlossene Instanzen niemals projiziert überschreiben.
- Tages-/Wochen-/Monatsrhythmen aus vorhandener Domain verwenden; keine neue
  „alle N Tage ab festem Anker“-Rhythmusart erfinden, die der Code noch nicht kennt.
  Einmalige Aufgaben ohne Fälligkeit haben keinen erfundenen Kalendertag; eine
  kompakte Liste „Ohne Datum“ erlaubt ihre Details und reguläre Terminvergabe.
- Zukunftsserien nur als geplante Vorkommen berechnen. Niemals voraussetzen,
  dass zukünftige Aufgaben erfolgreich erledigt werden oder ausfallen. Pause,
  Ende und Papierkorb begrenzen Projektionen; echte historische Einträge bleiben
  gemäß vorhandener Sichtbarkeitsregeln lesbar. Keine ausgedachten Vergangenheit-
  Abschlüsse, wenn noch keine Instanz persistiert wurde.
- Der Kalender selbst bleibt beim Öffnen rein lesend. Falls normale Pflege bis
  heute erforderlich ist, muss sie im bestehenden App-Lebenszyklus getrennt und
  mit echtem Heute erfolgen, nie mit dem sichtbaren Kalenderdatum. Die bestehende
  Zukunftssperre der alten Tagesansicht nicht einfach entfernen; neue Vorschau
  erhält einen eigenen sicheren Zugang.
- Bereich begrenzen: Tag/Woche/Monat nur sichtbares Raster, Agenda in 30-Tage-
  Seiten nachladen. Kein Vorberechnen jahrelanger oder unendlicher Serien.

### Abschlussabhängige Termine und Zählung

- Auf bestehende Intervallregeln und deren tatsächliche Abschlussdefinition
  stützen: aktuell nutzt der Scheduler `effectiveAt`/`finalizedAt` und
  `finalValues`; `no_entry` kann die Folge blockieren. Diese bestehende Semantik
  nicht im Kalender zu „nur erfolgreiche Erledigung“ umdefinieren.
- Vorhandenes offenes/blockierendes Vorkommen zeigen; dessen Nachfolger bleibt
  unbestimmt. Nach tatsächlich maßgeblichem Abschluss genau den nächsten ableitbaren
  Termin projizieren, keine Kette hypothetischer Abschlüsse. Bei noch nie gestarteter
  Serie höchstens den ersten zulässigen Termin ab Start projizieren. Ältere bereits
  fällige nächste Termine nicht auf heute umdatieren.
- Pro sichtbarer Serie höchstens einen unbestimmten nächsten Folgetermin zählen;
  auch bei bereits projiziertem nächsten Termin keine unendliche Folge zählen.
  Liste erklärt die ausstehende Voraussetzung und trennt sie von festen Tageszahlen.
- Frühestmarkierung nur mit belastbarer Untergrenze. Normalfall offene Instanz:
  frühestmögliche neue Durchführung ab `max(heute, scheduledDate)` plus Intervall,
  sofern Definition, Ende/Pause und zulässige Durchführung das tragen. Diese
  Markierung bedeutet „frühestens/möglich“, nicht „fällig“. Rückwirkende Korrekturen
  können die Rechnung ändern und lösen Neuprojektion aus. Bei unklarer Historie,
  Regelwechsel oder anderer Mehrdeutigkeit nur allgemeinen Zähler/Liste anzeigen.
- Feste Tageszahl = einmalige Vorkommen nach Filter, einschließlich abgeschlossener
  Einträge am geplanten Tag. Status zusätzlich kennzeichnen; echtes Erledigungsdatum
  bleibt Information des Abschlusses und verschiebt den Kalendertermin nicht.
  Unbestimmt-, Überfällig- und Ohne-Datum-Zähler bleiben getrennt und filterabhängig.
- Reine Tracker erzeugen keine echten Termininstanzen durch Anschauen. Erwartete
  Messtage als virtuelle Vorkommen, echte Werte vorrangig; weder fehlender Messwert
  noch Sichtbarkeit macht einen Tracker zum Misserfolg. Quellen eines Bündels
  einmal zählen, berechnetes Ergebnis nicht zusätzlich.

### Schreibzugang und Bedienung

- Ein gemeinsamer Command für `move/resize/setTime/clearTime`, mit aktueller
  Freigabeprüfung innerhalb der Transaktion. UI-Vorschau beim Ziehen flüchtig;
  erst Loslassen speichert einmal. Abbrechen/Fehler/ungültiges Ziel setzt Darstellung
  zurück und hinterlässt keinerlei Teiländerung.
- Erneut aus der DB prüfen: Aufgabe/Eintrag aktuell, nicht gelöscht/pausiert,
  unabhängig und einmalig, höchstens eine Instanz, Status offen, kein Bündelkonflikt
  oder relevante Vormerkung, Ziel heute/später und innerhalb Start-/Endgrenzen.
  Zwischenzeitlich geänderte Revision/`updatedAt` führt zu Neuladen statt Überschreiben.
- Tag verschieben verändert `dueDate` und vorhandenes `scheduledDate` atomar,
  behält `originalScheduledDate`, speichert neue Planungsfelder und Versionsnachweis.
  Unabhängige Text-/Projekt-/Zieländerungen nicht über ein veraltetes Vollobjekt
  zurückschreiben. Bestehenden Verschiebepfad gezielt erweitern/wiederverwenden.
- Überlappungen verschiedener Aufgaben sind zulässig und werden nebeneinander
  dargestellt. Keine automatische Konfliktauflösung, Tageskapazität oder Zeitoptimierung.
- Serien bearbeiten: aktuelle Definition öffnen, nicht eine künstliche Instanz
  anlegen. Zukunftseinträge nicht vorzeitig abhaken oder mit Messwerten befüllen;
  diese Aktionen im Kalender sperren. Gesperrte Direktbearbeitung erklärt ihren Grund.
- Tag/Woche: Antippen Details; lang drücken aktiviert Verschieben, ausgewählter
  Block bietet eindeutigen unteren Resize-Griff. Sichtbare Tageswechsel-Ziele
  beim Ziehen in Tagesansicht; Wochenansicht wechselt per Zielspalte. Ohne-Uhrzeit-
  Einträge dürfen in die Zeitachse gezogen werden; ohne vorhandene Dauer erst
  Dauer wählen, Abbruch ohne Änderung. Rückweg nach „Ohne Uhrzeit“ entfernt nur
  die Startzeit, erhält Dauer. Kein Drag in Monats-/Agendaansicht nötig.
- Zusätzlich zugänglicher Dialog „Termin ändern“ für alle freigegebenen Aktionen,
  damit Drag/Resize nicht die einzige Bedienmöglichkeit ist. Keine zweite Logik.
- Monat: Zahl und knappe Statushinweise, Tag antippen öffnet Tagesansicht.
  Agenda: datumsweise mit Uhrzeit/Dauer, danach „Ohne Uhrzeit“. Woche: Titel gekürzt,
  Projektfarbe/Projektname in Details; keine zusätzliche Beschriftungsoption in V1.

## Arbeitspakete und Abnahme

Reihenfolge K0 → K1 → K2 → K3 → K4 → K5 → K6 → K7.

### Fortschritt am 21. Oktober 2026

- **K0 geprüft:** Ausgangsschema 23, App 1.0.0+3, keine Kalenderansicht.
  Vorhandene lokale Änderungen betreffen AGENTS/Phase-21-Planung und bleiben
  erhalten. Keine fachlichen Rückfragen nach Abgleich mit Konzept/Plan.
- **K1 implementiert:** Schema 24 mit sechs nullable Planungsfeldern und
  `calendar_settings`. Eigene Änderungsgruppe `calendar`, Definitions-/Eintrags-
  und Korrektursnapshots, Kopiervorlage sowie alle direkten Erzeugungspfade
  ergänzt. Schema-22/23-Backups werden zuerst in ihrer Originalstruktur geprüft,
  anschließend verlustfrei ergänzt. Migration ab alten Schemata erhält die
  nullable Spalten bereits vor älteren Tabellen-Neuanlagen (Schutz gegen
  SQLite-Spaltennamen als Textwerte). Schema-23-Migration und Backup-Tests grün.
- **K2 implementiert:** Zeitdialog für Dauer/Start/Ende in Erstellung und Editor;
  Serien ab morgen, freie offene Einzeltermine sofort. Gemeinsamer atomarer
  Command prüft aktuelle Aufgabe/Revision, Zeitraum, Pause, Bündel und Vormerkungen.
  Bereits gespeicherte Kalender-Vormerkungen werden im Editor angezeigt;
  unveränderte Felder ersetzen sie nicht. DST-Endpunkte werden auf eindeutige
  lokale Zeit geprüft; Zeitzonenprüfung/Uhr sind für Tests injizierbar.
- **K3 implementiert:** Eigenes CalendarRepository und reine Projektion ohne
  Scheduler/Schreibaufrufe. Bereich maximal 43 Tage; einmalige/abhängige Vorgänger
  und offene Einträge werden zusätzlich in einer gemeinsamen Abfrage geladen.
  Definitionen, Vormerkungen, Projektzuordnung, Pausen und Bündelquellen wirken
  in der Vorschau. Vollständiger Tabellenvergleich beweist Schreibfreiheit.
  Komplexe Rhythmuswechsel in abschlussabhängige Serien bleiben ohne erfundenes
  Datum als unbestimmt sichtbar. Keine zusätzlichen Bündel-Ergebnisereignisse.
- **K4 implementiert:** Menü → Kalender, persistente Filter/Ansicht, Standard
  Woche/nur Aufgaben, Monat und 30-Tage-Agenda, schreibfreie Details und getrennte
  Listen für Überfällig/Ohne Datum/Unbestimmt. Alle Filter aus ist erlaubt.
- **K5 implementiert:** Gemeinsame Tages-/Wochenzeitachse, Überlappungsspalten,
  Projektfarben, Ohne-Uhrzeit-Bereich; Woche auf schmalen Displays horizontal
  scrollbar. Monat/Tag nutzen identische Vorkommen und separate +1?-Markierungen.
- **K6 implementiert:** Long-Press/Drag, Tageswechsel-Ablageflächen, Resize im
  15-Minuten-Raster, Dauerabfrage bei erstmaligem Zeitblock und alternativer
  Dialog „Termin ändern“. Sperren gelten zusätzlich in der Transaktion.
  Widgettests für Ansichten/Details und Drag/Resize bestehen.
- **K7 abgeschlossen:** Analyse ohne Befunde, finaler Gesamtlauf **174 Tests
  bestanden**. Erster Gesamtlauf zeigte alte Migrationsfixtures und einen
  DST-abhängigen 24-Stunden-Test; behoben und erneut geprüft. Release-APK
  `1.0.0+4` erfolgreich gebaut, Manifest und v1/v2-Signatur geprüft.
  [APK-Nachweis und Gerätenachtest](calendar_retest.md). Keine manuelle
  Geräteabnahme behauptet; andere Phase-21-Themen unverändert offen.
  Abschließende Historienkorrektur für rückdatierte Erstnotizen und lokale
  Tagesgrenzen zusätzlich mit 88 Kalender-/Aufgabenrepositorytests geprüft;
  APK anschließend erneut erzeugt.

### Abgeleitete Ausführungsdetails (keine neuen Produktentscheidungen)

- Monatsraster: sechs Montag-beginnende Wochen; Agenda: 30-Tage-Seiten.
- Überlappungen: nebeneinander angeordnete Spalten je zusammenhängender Gruppe.
- Native lokale Zeitzone; nicht existierende/doppelte Start- oder Endminute wird
  beim Schreiben abgewiesen und bei der Vorschau als Warnung ohne Block angezeigt.
- Zukünftige Kalenderdetails bieten keine Status-/Werteingabe. Der vorhandene
  Tagesaufgaben-Zugang bleibt bei heute/Vergangenheit; nur der Kalender hat den
  neuen schreibfreien Zukunftspfad. Keine externe Kalenderanbindung.
- Kleine Symbol-/Layoutdetails und Mindestspaltenbreite sind technische Defaults,
  keine Änderungen der bestätigten fachlichen Regeln.
Nicht nach jeder erledigten Teilaufgabe dieselbe Freigabe erneut erfragen. Ein
expliziter Auftrag für einen Teilbereich endet dagegen an dessen Paketgrenze.

| Paket | Arbeit und betroffene Bereiche | Fertig, wenn |
|---|---|---|
| K0 – Einstieg abgleichen | `AGENTS.md`, dieser Plan, Konzept, Git-Status, Schema/App-Version lesen; lokale fremde Änderungen bewahren. Keine Gesamtrepo-Neuanalyse. Konkrete Abweichungen hier notieren. | Ausgangsstand und Paketumfang feststehen; keine bekannten fachlichen Blocker verbleiben. |
| K1 – Daten und Sicherung | Aufgaben-/Versions-/Eintragstabellen, `app_database.dart`, neue Kalender-Settings, Payload/Constraint, Versionswriter/-resolver, Kopier- und Instanzerzeugungswege, Korrektursnapshots, `backup_service.dart`. Drift neu generieren. | Schema-23-Migration erhält alle Daten; Schema-22/23-Sicherungen importieren; neue Zeiten/Filter rundreisen; ungültiger Import lässt Bestand unverändert. |
| K2 – Zeitplanung schreiben | Gemeinsame Validierung/Command; `aufgaben_repository.dart`, `aufgabe_hinzufuegen_screen.dart`, `task_edit_screen.dart`, neue kleine Zeitfelder. Vormerkung ab morgen für Serien; kombiniert mit bestehenden Bearbeitungszweigen nichts verlieren. | Alle erlaubten Zeitkombinationen speicherbar; gesperrte Fälle auch direkt im Repository abgewiesen; keine Änderung alter Abschlüsse. |
| K3 – Sichere Projektion | Neue Calendar-Datenmodelle, Repository und reine Projektion; ausgewählte Helfer aus Definitions-/Projekt-/Lifecycle-Logik wiederverwenden. Bereichsweise laden, keine Scheduler-Aufrufe für Zukunft. | Deterministische/abhängige Fälle, Filter und Zähler stimmen; vollständiger DB-Vergleich vor/nach Lesen beweist Schreibfreiheit. |
| K4 – Navigation, Filter, Monat und Agenda | Kalender-Menü in `lib/hauptseiten/hauptseite.dart`, gemeinsamer Controller/Filter, Monatsraster und paginierte Agenda, Details und Listen für unbestimmt/überfällig/ohne Datum. | Nur Aufgaben im Erststart, Filter persistieren; Zahlen stimmen mit Tageseinträgen überein; Details von Projektionen schreiben nichts. |
| K5 – Tages- und Wochenansicht | Gemeinsames Zeitachsenlayout, Überlappungen, Ohne-Uhrzeit-Bereich, aktuelle Auswahl/Heute-Navigation, schmale Displays. | Beide Ansichten nutzen exakt K3-Daten; bekannte Zeiten und Status korrekt; gleiche Filter/Details wie Monat/Agenda. |
| K6 – Direktbearbeitung | Schlossanzeige, Long-Press/Drag, Resize-Griff, 15-Minuten-Raster, Tageswechsel-Ziele, alternativer Änderungsdialog; ausschließlich K2-Commands. | Erlaubtes Verschieben/Resize ändert den korrekten Bestand; gesperrte Ziele, Abbruch und konkurrierende Änderung bleiben ohne Teilspeicherung. |
| K7 – Gesamtprüfung und Übergabe | Gezielte Tests, Analyse, einmal vollständige Tests; Umsetzungsstand/Arbeitsplan aktualisieren, App-Version erhöhen und Release-APK für Gerätenachtest bauen. | Prüfungen bestanden, APK-Pfad dokumentiert, Einschränkungen benannt; Gerätenachtest ausdrücklich noch offen, solange Nutzer ihn nicht bestätigt. |

### Konkrete Testfälle statt allgemeiner Testversprechen

Neue Testdateien unter `test/features/calendar/` sind vorgeschlagene Ziele, noch
keine vorhandenen Dateien. Bestehende Backup-/History-/Lifecycle-Tests ergänzen.

1. **Migration/Backup:** echte Schema-23-Testdaten mit Einträgen, Vormerkungen,
   Korrekturen und Kartenoptionen migrieren; Schema-22- und -23-Import; neue
   Planungsfelder und alle drei Filter nach Export/Restore identisch. Fehlerhafte
   Dauer/Payload löst keinen Austausch der produktiven Daten aus.
2. **Zeit-/Historienregeln:** Dauer allein, Start+Dauer, Start+Ende, Entfernen der
   Uhrzeit; einmalig sofort, Serie ab morgen; heutiger/alter Abschluss unverändert.
   Bestehende Rhythmus-/Zielvormerkung bleibt bei Kalenderänderung erhalten.
3. **Schreibfreie Zukunft:** DB mit offenen direct/buffer/carryover-Einträgen,
   künftigen Definitionen/Projektwechseln und Pause; mehrere Zukunftsbereiche
   lesen und Details öffnen. Alle Tabellen inklusive Revisionen/Zeitstempel
   danach unverändert. Kein Test nur gegen einen Mock-Scheduler-Aufrufzähler.
4. **Vorkommen:** täglich, feste Wochentage/Monatstage einschließlich fehlendem
   Monatstag, Start/Ende/Pause; bestehende Instanz verdrängt Projektion. Serie nach
   Abschluss zeigt genau nächsten Termin; offene/no_entry-Serie keine tägliche
   Duplizierung. Korrektur/Undo aktualisiert Datum und Unbestimmt-Zähler.
5. **Filter/Zähler:** Default nur Aufgaben; reine Tracker trotz Task-Typ aus;
   beliebige Kombination einschließlich alle aus; Übertrag nur am Ursprungstag,
   eine unbestimmte Serie einmal, Bündelquellen ohne zusätzliches Ergebnis;
   gleiche Zahlen in allen Ansichten und nach Restore.
6. **Commands:** freies Ereignis an anderen Tag/andere Uhrzeit verschieben,
   Dauer ändern; No-op, Vergangenheit, abgeschlossen, Serie, Bündel, Pause,
   Vormerkung, Start-/Endgrenze und veraltete Revision abweisen. Vorher/nachher
   Bestände prüfen, inklusive Abbruch und atomarer Fehlerbehandlung.
7. **UI:** Menü → Kalender → vier Ansichten/Filter/Details; Drag zwischen Tagen,
   Resize-Raster, Ohne-Uhrzeit-Wechsel, geschlossene Schlösser, alternative
   Dialogbedienung und schmale Displays. Lokale Tagesgrenzen/DST mit steuerbarer
   Uhr/Zeitzonenauflösung testen, nicht vom Testrechnerdatum abhängig machen.

Passende Befehle nach tatsächlichen Änderungen: `dart run build_runner build
--delete-conflicting-outputs`, Formatierung der geänderten Dart-Dateien,
`flutter analyze`, gezielte `flutter test`-Aufrufe; zum Abschluss
`flutter test --concurrency=2 --timeout=2m` und `flutter build apk --release`.
Den vollständigen Lauf nicht nach jeder Dokumentations- oder Kleinänderung
wiederholen. Generierte Dateien nicht von Hand editieren.

## Übergabe und Fortschritt

Der neue Chat darf die Arbeitspakete anhand dieses Vertrags umsetzen. Keine neue
Anforderungsinterview-Runde; nur bei belegtem Konflikt mit einer Kernanforderung
nachfragen. Komplexe zusätzliche Fälle begründet sperren und dokumentieren.
Keine Umsetzung von #002/#013, externen Kalendern, Timer, Routinen, Dashboard,
Serienausnahmen oder einem allgemeinen Scheduler-Neuentwurf nebenbei beginnen.

Der Kalender ist ein größerer Auftrag. Bei Beauftragung aller Pakete den Umfang
zu Beginn kurz benennen; keine zusätzlichen aufwendigen Prototypen, Audits oder
Bibliotheksvergleiche ohne Anlass. Bestehende Flutter-Bausteine bevorzugen.
Ein Auftrag für K0–K3 erlaubt einen gezielten ersten Umsetzungsteil; dann UI und
APK nicht als fertig melden. Kein automatisches Erstellen/Messaging anderer Chats.

Nach jedem Paket hier Status und relevante Tests knapp eintragen. Bei Unterbrechung
genauen nächsten Schritt und verbleibende Fehler notieren. Erst nach K7 den
Kalender als implementiert/automatisiert geprüft markieren; Gerätenachtest bleibt
separat. Änderungen lokal nachvollziehbar sichern; keine automatische Veröffentlichung.

**Kopierbarer Auftrag für den Umsetzungschat:**

> Setze die Kalenderfunktion der Phase 21 gemäß
> `docs/10_tasks_habits/phase_21_test_improvements/calendar_implementation_plan.md`
> um. Arbeite die Pakete K0–K7 in Reihenfolge ab und aktualisiere dort den Fortschritt.
> Die bestätigten Anforderungen stehen im Dokument; lies das verlinkte Kalenderkonzept
> V0.4 ergänzend. Keine neue Grundsatzplanung, keine Umsetzung anderer Phase-21-Themen.
> Berücksichtige alle Randfälle, sperre die dokumentierten komplexen Fälle zunächst
> und stelle nur bei einem konkreten Konflikt mit Kernanforderungen Rückfragen.
> Bewahre bestehende Daten und fremde lokale Änderungen, prüfe Migration/Backup und
> die Schreibfreiheit der Zukunftsvorschau. Führe die vorgesehenen Tests aus und
> stelle abschließend eine APK mit kurzer Gerätenachtestanleitung bereit.
