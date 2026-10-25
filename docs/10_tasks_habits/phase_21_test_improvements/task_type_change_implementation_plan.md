# Phase 21 – #013 Aufgabenart Aufgabe ↔ Habit ändern

Stand: 22. Oktober 2026
Status: A0–A5 implementiert; automatisierter Prüfnachweis unten.
Gerätenachtest separat offen. Keine neue APK und keine anderen Pakete umgesetzt.

## Auftrag und bestätigte Grenzen

Bestehende wiederkehrende Aufgabe in einen Habit und umgekehrt umwandeln, ohne
Neuanlage. Dieselbe Aufgabe, dieselben Werte und Einträge bleiben erhalten.
Der Nutzer wählt für jeden Wechsel ausdrücklich zwischen:

1. **Ab jetzt für neue Einträge:** Bereits vorhandene Einträge behalten ihre
   bisherige Artzuordnung; neue folgen der neuen Art.
2. **Auch bisherige Einträge umordnen:** Neue Art auch für die gesamte bisherige
   Zuordnung übernehmen. Dies ist eine bewusst gewählte rückwirkende Korrektur.

Einmalige Aufgabe → Habit ist ausdrücklich ausgeschlossen. Dafür einen neuen
Habit anlegen. Der Artenwechsel erhält den Rhythmus; Habit → Aufgabe erzeugt
keine einmalige Aufgabe. Keine gleichzeitige Änderung von Startdatum, Planung,
Messkonfiguration, Zielen oder Projektzuordnung in diesem Vorgang.

Alle Fälle bedenken, komplexe Fälle zunächst nachvollziehbar sperren. Keine neue
Grundsatzrunde beim Nutzer. Nur ein belegter Konflikt mit den Kernanforderungen
rechtfertigt Rückfragen. Eine Kopie ersetzt den freigegebenen Artenwechsel nicht.

Quellen: [Originalmeldung #013](../phase_20_private_test/mobile_test_feedback_2026_10.md),
[bestätigte Entscheidungen im Arbeitsplan](test_improvements_plan.md#paket-013--aufgabenart-aufgabe--habit-ändern).
Bei abweichender Interpretation haben die dort dokumentierten Nutzerentscheidungen
Vorrang; dieser Plan konkretisiert die technische Durchführung.

## Geprüfter Ausgangspunkt

- Kalender und #002 sind inzwischen implementiert; Schema 24. #002 hat keinen
  Schemawechsel ausgelöst. Bestehende Kalender-/Trackingänderungen bewahren.
- `AufgabenRepository.updateTask` und `TaskEditScreen` sperren `taskType` bisher.
  `taskType` ist sowohl auf der aktuellen Aufgabe als auch auf Definitionsversionen
  gespeichert. Instanzen referenzieren diese Versionen über `taskDefinitionVersionId`.
- `TaskDefinitionResolver.taskForEntry` nutzt die referenzierte Definition;
  `taskForDate` löst datumsbezogen auf. Damit lässt sich der neue Umfang ohne
  zweite Aufgabenidentität oder neue Terminserie abbilden.
- Tageslisten und Scheduler filtern teilweise **vor** der historischen Auflösung
  anhand der aktuellen Aufgabenart. Das würde alte Einträge nach einem Wechsel
  im falschen Reiter anzeigen oder ausblenden. Dieser Fehlerpfad muss mitgelöst werden.
- `CalendarProjection` unterscheidet aktuelle und wirksame Aufgabe. Filter,
  Sonderlisten und Projektionen müssen die zum Vorkommen passende Art benutzen.
  Reines Tracking bleibt unabhängig davon unter dem Kalenderfilter „Tracker“.
- Projektlisten zählen aktuell nach Aufgabe/Habit. Bündel setzen kompatible
  Quellen derselben Art voraus. Ausstehende Definitions-/Projektänderungen können
  sonst mit der Konvertierung kollidieren.
- Bestehende Rückdatierung reiner Tracker aus #002 und deren früheste
  Definitionsauflösung beibehalten; keine pauschale neue Sperre für reine Tracker.

## Verbindliche Umsetzungsmatrix für V1

Die Freigabeprüfung wird für Oberfläche und Schreibpfad gemeinsam verwendet.
Sie liefert je gewünschtem Umfang eine Freigabe oder einen konkreten Grund.

| Fall | Entscheidung | Hinweis/Ausweg |
|---|---|---|
| Aktive wiederkehrende Aufgabe/Habit, gültiger bekannter Rhythmus, keine Konflikte | Beide Umfänge erlaubt | Rhythmus und Eingabeart bleiben gleich |
| Ohne bisherige Einträge | Erlaubt | Beide Optionen bleiben auswählbar; Hinweis, dass noch keine Einträge betroffen sind |
| Abgeschlossene Historie, heutiger offener Eintrag | Erlaubt | Bei „neue Einträge“ bleibt auch der bereits vorhandene heutige Eintrag in seiner alten Art; Dialog zeigt diese Folge |
| Reines wiederkehrendes Tracking | Erlaubt, soweit übrige Prüfung erfüllt | Im Kalender weiterhin Tracker-Kategorie; Werte bleiben erhalten |
| Bekannte abschlussabhängige Wiederholung ohne Rückstand/Vormerkung | Erlaubt | Keine Änderung von Intervall, Abschlussanker oder unbestimmter Folge |
| Einmalig/ohne Rhythmus oder unbekannte Konfiguration | Gesperrt | „Einmalige Aufgaben können nicht umgewandelt werden. Lege einen neuen Habit an.“; unbekannte Konfiguration gesondert erklären |
| Offene ältere Rückstände oder schon gespeicherte offene Zukunftsinstanzen | Vorerst gesperrt | Bestehende Einträge zuerst über reguläre Wege klären; keine automatische Erledigung, Löschung oder Umplanung |
| Ausstehende Rhythmus-, Ziel-, Kalender- oder Projektänderung | Vorerst gesperrt | Vormerkung zuerst regulär anwenden lassen oder bewusst abbrechen; Konvertierung cancelt nichts selbst |
| Aktuelle/zukünftige wirksame Bündelverknüpfung | Beide Umfänge vorerst gesperrt | „Die Aufgabe ist mit einem Bündel verknüpft.“; über reguläre Bündelverwaltung lösen, keine automatische zweite Quellenkonvertierung |
| Nur frühere beendete Bündelverknüpfung | „Neue Einträge“ erlaubt; gesamte Historie gesperrt | Frühere Quellenpaarung bleibt unverändert; nicht behaupten, erneutes Auflösen beseitige alte Verknüpfung |
| Für die Gesamthistorie relevante frühere Definition mit einmaligem/unklarem Rhythmus | Nur rückwirkende Option gesperrt | „Frühere Planung kann nicht sicher umgeordnet werden.“; Wechsel für neue Einträge bleibt möglich, wenn aktuell zulässig |
| Pausiert, beendet oder im Papierkorb | Vorerst gesperrt | Erst regulär fortsetzen/wiederherstellen, falls gewünscht; keine Umgehung des Schreibschutzes |
| Veralteter Dialog, zwischenzeitlich geänderte Daten oder unsichere Versionszuordnung | Ablehnen und neu laden | Keine Teiländerung, keine geratenen Zuordnungen |
| Zielart entspricht aktueller Art | No-op | Keine Ereignis-/Definitionsversion erzeugen; kein versteckter rückwirkender Umordnungsauftrag |

„Offene ältere Rückstände“ meint `pending` vor heute und bei abschlussabhängigen
Serien auch das dort blockierende `no_entry`. Normale abgeschlossene `no_entry`-
Historie kalendergebundener Serien ist kein Rückstand. Beendete Bündel nach ihrer
Gültigkeit prüfen; stornierte, nie wirksame Vormerkungen sind kein historisches Bündel.

## Speicherung und beide Historienoptionen

### Grundsatz: vorhandene Definitionszuordnung nutzen

Kein neues universelles Kategorien-/Terminmodell. `Aufgabe.taskType` beschreibt
die aktuelle Art. Für vorhandene Einträge bleibt ihre referenzierte Definition
maßgeblich, für virtuelle Vorkommen die zum Tag gültige Definition. Der Artenwechsel
ändert niemals Rhythmus, Status, Planungssnapshot, Werte, Eintragsdatum oder IDs.

Vor dem ersten Wechsel alle versionlosen vorhandenen Einträge eindeutig an ihre
bisher wirksame Definition binden. Das ist ausschließlich eine technische
Fixierung ihrer bisherigen Bedeutung. Wenn keine eindeutige Zuordnung möglich
ist, Wechsel ablehnen; nicht die neue Definition an alte Einträge hängen.

### Option 1: Ab jetzt für neue Einträge

- Transaktion: aktuelle Aufgabe neu laden, Freigabe prüfen, `taskType` und
  `updatedAt` der Aufgabe ändern, neue vollständige Definitionsversion aus dem
  aktuellen Stand anlegen, Wechsel protokollieren. Alte Definitionen nicht ändern.
- Bestehende Einträge behalten ihre Versions-ID und Art, auch der heutige offene
  oder abgeschlossene Eintrag. Die aktuelle Aufgabe hat sofort die neue Art;
  bestehende Tageskarten können deshalb heute noch im alten Reiter stehen.
  Das wird im Dialog vor dem Wechsel erklärt, nicht als technischer Fehler versteckt.
- Neue Einträge/virtuelle Vorkommen ab dem heutigen Tag nutzen die neue Definition.
  Nachträglich angelegte Einträge für **frühere Kalendertage** nutzen weiterhin
  die damals gültige Art. Keine rückwirkende Neuklassifizierung allein wegen
  späteren Erfassens. Der bisherige Tagesauflösungsmechanismus bleibt maßgeblich.
- Mehrere Wechsel am selben Tag sind durch fortlaufende Versionsnummern eindeutig;
  existierende Einträge bleiben gepinnt, neue verwenden die letzte wirksame Version.

### Option 2: Auch bisherige Einträge umordnen

- Dies ist die ausdrücklich gewünschte **Korrektur des Art-Metadatums**. In einer
  Transaktion ausschließlich `taskType` aller Definitionen dieser Aufgabe auf die
  Zielart korrigieren, einschließlich referenzierter ersetzter Versionen, damit
  vorhandene Einträge/Korrekturen keine alte Art versehentlich wiederherstellen.
  Alle übrigen Felder, IDs, Gültigkeitsdaten und Referenzen unverändert lassen.
- Aktuelle Aufgabe ändern und zusätzliche aktuelle Definition als nachvollziehbaren
  Stand des Wechsels anlegen. Keine neue Definition pro altem Eintrag, keine
  Neuberechnung/Erzeugung/Löschung einer Termininstanz und keine Umhängung ihrer IDs.
- Diese eng begrenzte, protokollierte Metadatenkorrektur ist die konkrete Umsetzung
  der vom Nutzer gewählten Rückwirkung. Sie ersetzt nicht generell die bisherigen
  Regeln für unveränderliche Mess-/Planungssnapshots. Kein generischer UPDATE aller
  Definitionsfelder und keine Nutzung dieses Pfads für andere Konfigurationsänderungen.
- Nach mehreren früheren Wechseln bedeutet „gesamte Historie“ tatsächlich alle
  bisherigen Artzuordnungen dieser Aufgabe. Ein späterer Wechsel nur für neue
  Einträge erstellt wieder eine neue Version und erhält die korrigierte Vergangenheit.

### Kleines Änderungsprotokoll und Migration

- Neue Tabelle `TaskTypeChanges` mit FK `taskId` (Cascade bei endgültiger Löschung),
  ID, je Aufgabe eindeutiger fortlaufender `sequence`, UTC-Änderungszeit,
  `previousType`, `targetType`, `scope` (`new_entries`/`all_history`), neuer
  Definitionsversions-ID und JSON der bei Rückwirkung korrigierten Versions-IDs
  mit ihrer **vorherigen** Art. Bei Option 1 ist diese Liste leer.
- Das Protokoll bewahrt die vorherige Klassifikation trotz bewusster rückwirkender
  Korrektur. Es ist kein zweiter Resolver und keine parallele Wahrheit. In Details
  den letzten Wechsel mit Umfang/Datum anzeigen; keine neue große Historienoberfläche.
- Constraints für gültige Typen/Scopes, unterschiedliche Quell-/Zielart, Sequence
  und FK; JSON beim Schreiben und Backup-Import gegen Task/Versionszugehörigkeit
  prüfen. Kein generisches Undo des Artenwechsels in V1. Erneuter Wechsel ist
  möglich; er wird nicht als exakte Wiederherstellung früherer Aufteilungen beworben.
- Bei unverändertem Schema 24 nächste Version 25 verwenden; bei zwischenzeitlicher
  Änderung neu ermitteln. Leere neue Tabelle für Bestandsdaten, keine erfundenen
  alten Wechsel. Keine zusätzlichen Felder auf `TaskEntry` erforderlich.
- Backups 22/23/24 weiter importierbar halten, neue Tabelle nach Validierung der
  jeweiligen Originalstruktur leer ergänzen. Bestehende Kompatibilitätsbedingungen
  in `BackupService` **versionsgenau** machen: „nicht aktuelles Schema“ darf nach
  Erhöhung nicht Schema 24 fälschlich Kalenderfelder/-Settings absprechen.
  Neue Backups enthalten das Wechselprotokoll. Format-Hülle kann bei Version 1 bleiben.

## Lesewege und Folgewirkungen

- Tageslisten zunächst ausreichende Kandidaten laden, dann je bestehendem Eintrag
  `taskForEntry`, sonst `taskForDate` auflösen und **danach** nach Art filtern.
  Ein SQL-Filter nur auf `aufgaben.taskType` ist für historische Listen unzulässig.
  Kein doppeltes Anzeigen desselben Eintrags in Aufgaben und Habits.
- Scheduler ebenfalls auf vorzeitige Typfilter prüfen: `_earliestRelevantDate`,
  `_ensureEntriesForSingleDate`, Direct-/Buffer-/Carryover-Verarbeitung. Kandidaten
  dürfen wegen inzwischen anderer aktueller Art nicht fehlen; die zum Tag bzw.
  Eintrag aufgelöste Art entscheidet, wenn ein Typfilter verlangt ist. Keine
  allgemeine Änderung von Missed-/Abschlussregeln und keine Zukunftsschreibvorschau.
- Neue historische Instanzen müssen weiterhin die zum geplanten Tag passende
  Definition referenzieren. Der heutige gepinnte Eintrag verhindert über den
  bestehenden Unique-Key `(taskId, scheduledDate)` eine zweite Instanz anderer Art.
- Kalender nutzt vor Filterung dieselbe Versionsauflösung: vergangene echte
  Einträge nach ihrer Referenz, virtuelle Tage nach Datum, unbestimmte Listen nach
  wirksamer Serie. `currentTask` bleibt das Ziel für reguläres Bearbeiten, nicht
  Ersatz der historischen Darstellungsart. Zukunftsprojektion bleibt schreibfrei.
- Dringlichkeitsansicht mit offenem Eintrag folgt dessen Art; reine Aufgabendefinition
  ohne Eintrag folgt aktueller Art. Projekt-Bestandslisten zählen aktuelle Definitionen,
  datumsbezogene Historien-/Kalenderansichten deren damalige bzw. korrigierte Art.
  Diese beiden Zwecke nicht vermischen. Aufgabenspezifische Zahlen dürfen sich
  durch bewusste Umordnung ändern, Gesamterledigungen/Messwerte nicht.
- Einmalige-Aufgaben-Auswertungen behalten zusätzlich ihren Rhythmusfilter; ein
  konvertierter Habit ist weiterhin wiederkehrend und gehört nicht plötzlich in
  eine Statistik ausschließlich einmaliger Aufgaben. Das gemeinsame Tagesdiagramm
  für Aufgaben/Habits bleibt insgesamt gleich; Tracker bleiben dort ausgeschlossen.
- Aktive Streams auf Definitions-/Aufgaben-/Wechseländerungen reagieren lassen.
  Wechsel muss nach Speichern, Neustart und Restore konsistent sein. Bestehende
  Kartenpräferenzen bleiben dank unveränderter Identität erhalten.
- Task-Copy erzeugt eine neue Identität mit aktueller Art und ohne fremdes
  Wechselprotokoll. Korrektur/Undo von Werten oder Abschlüssen darf weder die
  gewählte Artzuordnung zurücksetzen noch Planungsdaten aus dem Kalender verlieren.

## Schreibzugang und Bedienung

- Separater Vorgang `changeTaskType(taskId, targetType, scope, expectedRevision)`
  bzw. gleichwertiger enger Command. Nicht alle bestehenden Sperren in `updateTask`
  entfernen. Direkte Typänderung über dessen allgemeinen Speicherweg weiterhin
  ablehnen; so können Daten-/Zeit-/Projektänderungen nicht unbemerkt mitlaufen.
- Im Bearbeitungsbildschirm bei „Aufgabenart“ Aktion „Art ändern“ anbieten.
  Eigener Dialog zeigt Zielart und beide Umfänge, zunächst **keinen** ausgewählten
  Umfang; Speichern erst nach ausdrücklicher Auswahl. Gesperrte Option mit Grund
  sichtbar lassen, zulässige andere Option anbieten. Abbrechen verändert nichts.
- Bei noch ungespeicherten Formularänderungen zuerst Speichern/Verwerfen verlangen;
  kein automatisches Speichern. Nach erfolgreichem Wechsel aktuellen Stand neu laden,
  damit ein altes Formular `taskType`, Frage/Anzeigetext oder andere Felder nicht
  wieder überschreibt. Wechsel verändert `questionText` nicht.
- Wird Bearbeiten von einer historischen Karte geöffnet, ebenfalls die aktuelle
  Aufgabe anhand ihrer ID laden. Die historische Karte darf weiterhin ihre alte
  Art zeigen, aber nicht deren überholte Konfiguration in den normalen Editor
  zurückschreiben. Dieser Schutz gilt in Tagesansicht und Kalender gleichermaßen.
- Dialogvorschau nennt Anzahl bisheriger Einträge und ausdrücklich den heutigen
  verbleibenden Eintrag bei Option 1. Keine vierte Konfigurationsseite, keine
  zusätzliche Rhythmuswahl. Sperrgrund möglichst mit passendem regulärem Weg verlinken.
- Beim Speichern innerhalb **einer Transaktion** Aufgabe, Definitionen, Instanzen,
  Vormerkungen und Bündelkonflikte neu prüfen. Revisionstoken darf nicht nur auf
  `task.updatedAt` vertrauen: auch geänderte Einträge/Vormerkungen berücksichtigen
  (z. B. Fingerprint der Vorschau). Veralteten Dialog ablehnen und neu laden.
- Snapshot-Zuordnung versionloser Einträge, Typkorrektur, neue Version, aktuelle
  Aufgabe und Protokoll gemeinsam committen oder vollständig zurückrollen.
  Reiner Artenwechsel ruft weder Scheduler noch vorzeitiges `applyDueChanges` auf.

## Arbeitspakete A0–A5

In Reihenfolge bearbeitet. Freigabeprüfung und Command teilen sich das neue
`task_type_change_service.dart`; kein zusätzliches Policy-Modul nötig.

| Paket | Umsetzungsstand am 22. Oktober |
|---|---|
| A0 | Abgeschlossen: Schema 24, Kalender, #002 und lokale Änderungen abgeglichen; kein fachlicher Widerspruch. |
| A1 | Abgeschlossen: gemeinsamer Scope-Check, Fingerprint, atomarer Command, Versions-Pins, Protokoll und Schema 25; Backup 22–25. |
| A2 | Abgeschlossen: Tageslisten, Dringlichkeit und Scheduler filtern nach aufgelöster Art. Kalender nutzt bereits historische Definitionen und bleibt schreibfrei. Projektbestand zählt aktuelle Aufgaben auch ohne zum Projekt gehörige alte Einträge; deren historische Statistik bleibt getrennt. |
| A3 | Abgeschlossen: „Art ändern“, keine vorausgewählte Option, Sperrgründe, Formularschutz, aktuelles Laden auch von historischen Karten und letzter Wechsel in Details. |
| A4 | Automatisierte Prüfung: siehe Nachweis unten. |
| A5 | Dokumentation/Indizes aktualisiert; Gerätenachtest unten, ausdrücklich kein APK-Build. |

Ursprünglicher Paketumfang zur Nachvollziehbarkeit:

| Paket | Arbeit | Abnahme |
|---|---|---|
| A0 – Ausgangsstand | Aktuellen Code/Schema, Kalender und #002 sowie lokale Änderungen prüfen; nur relevante Dateien lesen. | Bereits implementierte Funktionen bleiben Bestandteil der Basis; keine neue Grundsatzplanung. |
| A1 – Freigabe, Daten, Command | `task_type_change_policy.dart`, `task_type_change_service.dart`, Protokolltabelle, Schema/Backup; bestehende Versionswriter/-resolver nutzen. | Beide Umfänge atomar; Sperrmatrix auch ohne UI wirksam; Versionen/Protokoll nachvollziehbar; alte Backups funktionieren. |
| A2 – Auflösung und Filter | `aufgaben_repository.dart`, `task_instance_scheduler.dart`, `task_definition_resolver.dart`, Kalenderprojektion/-repository, Projektansichten; betroffene `taskType`-Filter gezielt suchen. | Historische und künftige Kategorien stimmen; kein verschwundener/doppelter Eintrag und keine Neuberechnung durch den Wechsel. |
| A3 – Dialog und Details | `task_edit_screen.dart` plus kleiner Wechsel-Dialog; Detailhinweis und Neuladen; normale Sperren beibehalten. | Beide Optionen klar wählbar; Gründe sichtbar; heutige bestehende Einträge erklärt; Abbruch/ungespeicherte Eingaben sicher. |
| A4 – Regression und Sicherung | Tests unten, gezielte Analyse und vollständiger Testlauf; Kalender/#002/Backup-Regression. | Alle relevanten Prüfungen grün, Fehler behoben, kein Scope-Zuwachs durch neue Features. |
| A5 – Abschluss | Arbeitsplan/Verlauf/umgesetzten Stand aktualisieren, kurze Gerätenachtestanleitung; falls APK beauftragt Version erhöhen und bauen. | #013 korrekt als implementiert markiert, tatsächliche Tests/Buildstatus benannt; Gerätenachtest bleibt separat offen. |

### Erforderliche Tests

1. Wiederkehrende Aufgabe → Habit und zurück, beide Umfänge; mit und ohne Historie.
   Option 1 erhält bestehende Eintragszuordnung einschließlich heute, neue Tage
   verwenden neue Art; rückdatierter neuer Messwert verwendet historische Art.
2. Rückwirkende Korrektur nach mehreren Wechseln: alle bisherigen Versionen nur
   in `taskType` verändert, Protokoll bewahrt vorherige Zuordnung. Späterer Wechsel
   für neue Einträge erhält diese korrigierte Vergangenheit. Gleicher Zieltyp ist No-op.
3. Alle Sperrfälle der Matrix direkt über den Command testen, insbesondere aktuelle
   versus nur historische Bündel und Rückstände. Abbruch/konkurrierende Änderung
   hinterlässt keine halbe Transaktion und kein unvollständiges Protokoll.
4. Vorher/nachher-Vergleich von Task/Versionen/Entries/Values/Korrekturen:
   nur erlaubte Typ-/Versions-/Logfelder ändern sich. Datum, Termine, Startgrenze,
   Planungszeit, Messwerte, Eintrags-IDs und Abschlüsse unverändert. Versionslose
   Einträge werden nur eindeutig an ihre bisherige Definition gebunden.
5. Historische Tagesreiter, heutiger offener Eintrag, zukünftige Kalenderprojektion,
   Projektzählung und Dringlichkeit stimmen. Gesamterledigungsdiagramm unverändert;
   keine Vermischung mit einmaliger Aufgabenstatistik oder Trackerfilter.
6. Scheduler nach Wechsel in beiden Typansichten mehrfach ausführen: keine
   fehlenden/duplizierten Instanzen; Direct/Buffer/Carryover und Abschlussintervalle
   verwenden die bisherigen Regeln. Kalenderlesen vor/nach Wechsel schreibt nichts.
7. #002-Regressionsfall: reinen wiederkehrenden Tracker umwandeln, Start rückdatieren,
   alte Werte korrigieren/Undo; keine verlorene Historie oder falsche Kalendergrenze.
8. Migration von Schema 24 und Restore 22/23/24; neue Sicherung erhält beide
   Historienoptionen, Protokoll, Kalenderzeiten und Filter. Ungültige Protokoll-
   Referenzen/JSON vor Bestandsänderung ablehnen; altes Korrektur-Undo bleibt lesbar.
9. UI: zwei explizite Optionen, Sperrgrund, Abbrechen, ungespeicherte Eingaben,
   erfolgreicher Wechsel mit Neuladen und sofort aktualisierten Streams.

Neue Tests vorzugsweise in `test/features/aufgaben/data/task_type_change_test.dart`
und entsprechendem Dialogtest, vorhandene History-/Calendar-/Backup-Tests ergänzen.
Drift generieren, geänderte Dateien formatieren, Analyse und gezielte Tests ausführen;
abschließend einmal `flutter test --concurrency=2 --timeout=2m`. Keine Tests bereits
als bestanden markieren, bevor sie tatsächlich gelaufen sind.

## Prüfnachweis und Gerätenachtest – 22. Oktober 2026

- Drift generiert; gezielte Analyse aller 17 angepassten/neuen Dart-Dateien ohne Befunde.
- Vollständiger Lauf `flutter test --no-pub --concurrency=2 --timeout=2m`:
  **212 Tests bestanden in 65 Sekunden**, davon 26 neue Command-/Regressionstests
  und zwei neue Dialog-/Editortests. Kalender, #002, Projekte und Backup eingeschlossen.
- Geprüft: beide Umfänge, wiederholte Wechsel, No-op, Pinning, Rückdatierung,
  heutige Einträge, direkte Sperrprüfungen (auch Ziel-/Kalender-/Projektvormerkungen),
  veraltete Vorschau, erzwungener Transaktions-Rollback, Scheduler mit
  Direct/Buffer/Carryover, Korrektur/Undo, Projektbestand und schreibfreier Kalender.
- Schema 25 mit 20 Tabellen; echte Migration 24 → 25, Restore 22/23/24 und
  neue Sicherung mit beiden Wechselumfängen geprüft. Ungültiges Protokoll wird
  vor Bestandsänderung abgelehnt. Frühere Migrationstests ebenfalls grün.
- Beim ersten Prüflauf entdeckten Projektbestands-Randfall korrigiert:
  aktuelle Projektmitgliedschaft bleibt sichtbar, auch wenn alte Einträge noch
  vor dieser Zuordnung liegen. Historische Eintragsstatistik bleibt unverändert.
- Bestehende Drift-Debugwarnungen bei mehreren isolierten Testdatenbanken;
  keine Testfehler. Kein APK-Build, keine Versionsanhebung, keine Veröffentlichung.

**Noch offen: kurzer Nachtest auf dem Gerät mit einem Build dieses Quellstands.**
Die vorhandene Kalender-APK `1.0.0+4` enthält #002/#013 nicht.

1. Wiederkehrende Aufgabe mit altem Wert und heutigem Eintrag öffnen:
   **Bearbeiten → Aufgabenart → Art ändern**. Ohne Auswahl bleibt Speichern gesperrt.
   „Ab jetzt für neue Einträge“ wählen: heutige/alte Karte bleibt unter der alten
   Art, neue Tage unter der neuen. Wert und Kalenderzeit bleiben gleich.
2. Zurückwechseln mit „Auch bisherige Einträge umordnen“: alte Karten wechseln
   die Kategorie, Daten bleiben gleich; Details zeigen den letzten Wechsel.
3. Einmalige Aufgabe und aktive Bündelquelle prüfen: verständlicher Sperrgrund.
   Ungespeicherte Formulareingaben und Abbrechen dürfen keinen Wechsel speichern.
4. Von einer historischen Karte Bearbeiten öffnen: aktuelle Konfiguration sehen.
   Reinen Tracker nach #002 rückdatieren, alten Wert korrigieren/Undo; Kalender
   und Messhistorie bleiben erhalten. App neu öffnen und Zuordnung kontrollieren.

## Ursprüngliche Übergabe an den Umsetzungschat

Dieser Plan ist der vollständige begrenzte Auftrag. Dateistruktur/kleine Details
selbst sinnvoll lösen; nur konkrete Kernkonflikte eskalieren. Nach jedem Paket
Status und relevante Tests hier notieren. Keine Kalender-Neuimplementierung,
keine Erweiterung von #002 und keine zusätzliche Typ-/Rhythmuskonvertierung.
Kein eigener Chat, Issue, PR oder externe Veröffentlichung ohne passenden Auftrag.

> Setze ausschließlich Phase 21 #013 gemäß
> `docs/10_tasks_habits/phase_21_test_improvements/task_type_change_implementation_plan.md`
> um. Arbeite A0–A5 ab, erhalte Kalender und #002 und bewahre fremde lokale Änderungen.
> Beide Historienoptionen sind bestätigt; einmalige Aufgaben und dokumentierte
> Konfliktfälle bleiben gesperrt. Keine neue Grundsatzplanung. Prüfe Migration,
> Backup, historische Zuordnung und schreibfreie Kalenderprojektion anhand der
> Abnahmetests und aktualisiere anschließend den dokumentierten Status.
