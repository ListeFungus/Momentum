# Momentum – Phasenprotokoll der Aufgabenstruktur

Stand: 16. Oktober 2026

Status: Aufgaben-Konzept, Regeln und Umsetzungshistorie

## Zweck

Dieses Dokument erklärt das Aufgaben- und Habit-Konzept von Momentum und hält
nachvollziehbar fest, was in den einzelnen Phasen beschlossen und umgesetzt
wurde.

Es ist das langfristige Hauptdokument für Außenstehende: Wer später verstehen
möchte, warum Aufgaben, Instanzen, Missed Policies und Historisierung so gebaut
sind, soll hier eine verständliche Erklärung finden.

Der laufende Arbeitsplan steht in
[`task_structure_plan.md`](task_structure_plan.md). Die Auswertung hat eigene
Dokumente:

- [`analytics_plan.md`](phase_07_analytics/analytics_plan.md)
- [`analytics_concept.md`](phase_07_analytics/analytics_concept.md)
- [`analytics_history.md`](phase_07_analytics/analytics_history.md)

Release-Ideen vor der ersten App-Version werden in
[`release_ideas.md`](release_ideas.md) gesammelt. Projekte haben ab Phase 18
eigene Dokumente im Ordner
[`phase_18_projects`](phase_18_projects/README.md). Die eigentliche
Release-Vorbereitung beginnt erst nach den fachlichen Aufgaben-/Habit-Phasen.
Die Zuordnung von Aufgabenarten zu passenden Auswertungen steht in
[`task_analytics_matrix.md`](task_analytics_matrix.md).

Pflegeprinzip:

- Der Plan bleibt kurz und zeigt den aktuellen Arbeitsstand.
- Dieses Dokument wächst und erklärt dauerhaft Konzept, Regeln, Entscheidungen
  und umgesetzte Phasen.
- Alte Spezialdokumente werden erst entfernt, wenn ihre Inhalte hier sauber
  eingeordnet sind.

## Konsolidierungsstand der Aufgaben-Dokumente

Die Inhalte aus diesen bisherigen Spezialdokumenten werden schrittweise hier
eingeordnet:

| Altes Dokument | Inhalt | Ziel |
|---|---|---|
| `task_rule_matrix.md` | Fachliche Regeln, erlaubte Kombinationen, Pflichtfelder, Sperren | in diesem Dokument unter „Fachliche Regeln“ und den jeweiligen Phasen erklären |
| `task_entry_model_audit.md` | Technische Bestandsaufnahme des Entry-/Statusmodells | in Phase 6 und im Abschnitt „Instanz- und Statusmodell“ erklären |

Bis zur vollständigen Übernahme bleiben die Spezialdokumente als Arbeitsquellen
erhalten. Sie sollen nicht dauerhaft die Hauptnavigation bilden.

## Kurzüberblick des Konzepts

Eine Aufgabe ist die zentrale Definition dessen, was angezeigt, beantwortet und
später ausgewertet wird. Wiederkehrende Aufgaben erzeugen einzelne Instanzen.
Diese Instanzen sind die eigentliche Grundlage für Status, Missed Policies und
Auswertung.

Die wichtigsten Status sind:

| Status | Bedeutung |
|---|---|
| `pending` | offen, solange noch keine wertende oder abschließende Verarbeitung erfolgt ist |
| `success` | erfolgreich erledigt beziehungsweise mit `Ja` beantwortet |
| `failure` | nicht erfolgreich beziehungsweise mit `Nein` oder entsprechender Missed Policy abgeschlossen |
| `no_entry` | abgeschlossen ohne wertende Antwort; kann automatisch nach Ablauf entstehen oder begründet werden |

Grundsatz: Die App soll beim Erreichen von Zielen helfen. Deshalb sind `Ja` und
`Nein` die normale Erfassung; `Kein Eintrag` ist sichtbar auswertbar, aber kein
prominenter Ausweichbutton neben der Zielantwort.

## Aktueller Überblick

| Phase | Kurzstatus | Ergebnis |
|---:|---|---|
| 1 | abgeschlossen | Fachliche Regelmatrix als gemeinsame Grundlage erstellt und gepflegt |
| 2 | abgeschlossen | Zentrale Validierungslogik als fachliche Quelle für UI und Speicherung erstellt |
| 3 | abgeschlossen | Erstellungs-UI an Validierungsregeln angebunden |
| 4 | abgeschlossen | Drift-Schema um vollständige Konfigurationsfelder erweitert |
| 5 | abgeschlossen | Bearbeitungs-UI auf denselben Feld- und Regelumfang gebracht |
| 6 | abgeschlossen | Eindeutiges Instanz- und Statusmodell umgesetzt |
| 6a | abgeschlossen | Scheduler-Grundgerüst und idempotenter Range-Abgleich geprüft vorbereitet |
| 7 | abgeschlossen | Grundauswertung und erste Detailansicht stehen |
| 8 | abgeschlossen | Direkte Konsequenz umgesetzt, komplex getestet und grob in der App geprüft |
| 9 | abgeschlossen | Puffer-Kernlogik, Validierung und Randfalltests umgesetzt und extern bestätigt |
| 10 | abgeschlossen | Carryover/Aufstauen mit Maximum, automatischer Konsequenz und Anzeige umgesetzt und extern bestätigt |
| 11 | abgeschlossen | Vollständige Status-Auswertung, einzelne Aufgaben und erste Sammelauswertung umgesetzt |
| 12 | abgeschlossen; release-relevant | Erweiterte Erfassungsarten wie Zahl, Dauer, Uhrzeit, reines Tracking und Zwei-Werte-Bündel vor Firebase; extern bestaetigt |
| 13 | abgeschlossen; release-relevant | Auswertung erweiterter Eingaben abgeschlossen und dokumentiert |
| 14 | abgeschlossen; release-relevant | Zielbewertung; 14a bis 14e abgeschlossen und extern geprueft |
| 15 | abgeschlossen; release-relevant | Frei waehlbare Kartenkennzahl mit zielbasiertem Default, Zeitraum, Ausblenden und lokaler Berechnung; automatisiert und manuell extern bestätigt |
| 16 | abgeschlossen; release-relevant | Historische Definitionen, Korrekturen und datierte Zuordnungen umgesetzt |
| 17 | abgeschlossen; release-relevant | Papierkorb, Wiederherstellung und Pausen umgesetzt |
| 18 | abgeschlossen; release-relevant | Projekte als Ordnungs-, Lebenszyklus- und Auswertungsebene umgesetzt |
| 19 | abgeschlossen; release-relevant | Lokale Grundlagen für spätere Firebase-Synchronisierung umgesetzt; Cloud-Sync bleibt später |
| 20 | läuft | Private Nutzung, Beobachtungen und Gerätenachtests ohne Store-Sichtbarkeit |
| 21 | aktiv | Testergebnisse ausarbeiten und umsetzen; erstes Verbesserungspaket bereits umgesetzt |
| 22 | geplant; Release-Vorbereitung | Store-Release vorbereiten, inklusive Paywall-/Free-Version-Entscheidung |
| 22+ | geplant/später | Unteraufgaben, Unterprojekte und weitere Komfortfunktionen nach dem ersten Release |

## Phase 1 – Fachliche Regelmatrix

Ziel war, die möglichen Kombinationen aus Rhythmus, Fälligkeit, Missed Policy,
Zielen und Erfassungsmodus fachlich greifbar zu machen.

Ergebnis:

- `task_rule_matrix.md` wurde als zentrale fachliche Regeldatei angelegt.
- Erlaubte, verpflichtende, automatische und gesperrte Felder wurden mit einer
  Legende dokumentiert.
- Positiv formulierte Aufgaben wurden als Grundregel festgelegt.
- `Ja` ist Erfolg, `Nein` ist aktiver Misserfolg.
- Keine Auswahl bedeutet offen (`pending`).
- `Kein Eintrag` ist kein Standardbutton, kann aber als Ablauf-Konsequenz oder
  bewusst gesetzter Sonderfall als `no_entry` gespeichert werden.
- Automatische Erfolge wurden ausgeschlossen.
- Sinnlose oder nicht sicher speicher-/auswertbare Kombinationen sollen
  gesperrt werden; riskante, aber gültige Kombinationen erhalten Hinweise.

Wichtige Grenze:

- Die Matrix beschreibt Fachregeln, nicht automatisch den aktuellen
  Implementierungsstand.

## Phase 2 – Zentrale Validierungslogik

Ziel war, die fachlichen Regeln nicht mehrfach in UI und Speicherung zu
verdoppeln.

Ergebnis:

- Eine zentrale Validierungslogik für Aufgabenkonfigurationen wurde eingeführt.
- Ungültige Kombinationen können normalisiert oder blockiert werden.
- UI und Repository können dieselbe fachliche Grundlage verwenden.

Wichtige Grenze:

- Validierung verhindert falsche Konfigurationen, führt aber noch keine
  Missed Policies aus.

## Phase 3 – Erstellungs-UI

Ziel war, die Regelmatrix beim Erstellen neuer Aufgaben verständlich sichtbar zu
machen.

Ergebnis:

- Fachliche Hauptfelder bleiben sichtbar, wenn sie gesperrt sind.
- Reine Folgefelder werden erst angezeigt, wenn die vorherige Auswahl sie
  benötigt.
- Ungültige Auswahlen werden auf gültige Werte zurückgeführt.
- Hinweise erklären riskante, aber erlaubte Kombinationen.

Wichtige Grenze:

- UI-Hinweise ersetzen keine Laufzeitlogik für verpasste Aufgaben.

## Phase 4 – Schema und Migrationen

Ziel war, die geplanten Einstellungen dauerhaft und typsicher speichern zu
können.

Ergebnis:

- Schema-Version 8 ergänzte die erweiterten Aufgabenfelder, unter anderem:
  Missed Policy, Konsequenz, Puffer, Verhalten nach Puffer, Carryover-Maximum,
  Zieltyp, Zielwert, Zielzeitraum und Zielausrichtung.
- Bestehende Daten wurden per Migration auf die neuen Standardwerte gebracht.

Wichtige Grenze:

- Die Felder waren damit speicherbar, aber direkte Konsequenz, Puffer und
  Carryover wurden noch nicht automatisch verarbeitet.

## Phase 5 – Erstellungs- und Bearbeitungs-UI

Ziel war, Erstellung und Bearbeitung auf denselben vollständigen Feldumfang zu
bringen.

Ergebnis:

- Erstellung und Bearbeitung nutzen denselben fachlichen Regelumfang.
- Gesperrte und abhängige Felder werden konsistenter dargestellt.
- Einmalige Aufgaben erhalten keine Zeitraumziele, weil diese fachlich keinen
  Sinn ergeben.

Wichtige Grenze:

- Änderungen an Aufgaben werfen langfristige Historisierungsfragen auf. Diese
  wurden später durch Definitionsversionen vorbereitet.

## Phase 6 – Instanz- und Statusmodell

Ziel war, einzelne geplante Instanzen fachlich eindeutig zu speichern.

Ergebnis:

- Schema-Version 9 führte eindeutige Statuswerte ein; später wurde die
  Begrifflichkeit präzisiert:
  `pending`, `success`, `failure`, `no_entry`.
- Erfolg und Misserfolg sind endgültige Abschlüsse.
- `pending` bedeutet offen beziehungsweise noch nicht beantwortet.
- `no_entry` ist ein Abschluss ohne wertende Antwort, optional mit Grund oder
  Notiz, aber kein Erfolg und kein aktiver Misserfolg.
- Neue Zeitfelder trennen Interaktion, Abschluss und fachliche Wirksamkeit:
  `respondedAt`, `finalizedAt`, `effectiveAt`.
- `resolutionOrigin` unterscheidet manuelle, automatische und migrierte Werte.
- Automatische Policy-Herkunft kann später über `appliedMissedPolicy` und
  `appliedMissedConsequence` gespeichert werden.

Spätere Ergänzung innerhalb dieses Grundlagenblocks:

- Schema-Version 11 entfernte das alte Feld `completedAt`.
- Vollständige Definitionsversionen wurden eingeführt.
- Jede Instanz kann auf die damals gültige Aufgabendefinition verweisen.

Wichtige Grenze:

- Eine Änderungshistorie einzelner Statuskorrekturen ist noch nicht umgesetzt.

## Phase 6a – Scheduler-Grundgerüst

Ziel ist, die Erzeugung geplanter Instanzen aus der Tagesansicht herauszulösen
und an einer zentralen Stelle zu bündeln.

Umgesetzt:

- `TaskInstanceScheduler` wurde als eigene technische Nahtstelle eingeführt.
- Er kann einen Datumsbereich chronologisch abgleichen.
- Der Abgleich ist idempotent: Bereits vorhandene Instanzen werden
  nicht doppelt erzeugt.
- Kalendergebundene fällige Instanzen können nachgeholt werden.
- Abschlussgebundene Rhythmen behalten die Regel, dass höchstens eine offene
  Instanz existiert.
- Nachgeholte Instanzen werden mit der passenden Definitionsversion des
  geplanten Tages verknüpft.
- `watchTasksForDate` nutzt die neue Scheduler-Nahtstelle statt einer privaten
  Erzeugungslogik im Repository.

Damals noch offen:

- Die App-Lifecycle-Anbindung fehlte noch: App-Start, Rückkehr aus dem
  Hintergrund und Tageswechsel riefen den Scheduler noch nicht zentral auf.
- Direkte Konsequenz, Puffer und Carryover waren noch nicht im Scheduler aktiv.
- Ein persistenter „letzter erfolgreicher Scheduler-Lauf“ ist noch nicht
  umgesetzt.

Verifikation:

- `dart format` für die betroffenen Dateien erfolgreich ausgeführt.
- Gezielte Analyse der betroffenen Dateien: keine Probleme gefunden.
- Gezielter Aufgaben-Repository-Test:
  `flutter test --no-pub test/features/aufgaben/data/aufgaben_repository_test.dart`
  mit 14 bestandenen Tests.

Einordnung:

Phase 6a ist eine technische Vorbereitung für Phase 8 bis 10. Sie ist nicht
Teil der Grundauswertung aus Phase 7 und bedeutet noch nicht, dass direkte
Missed-Konsequenzen umgesetzt sind. Phase 8 hat diese direkte Konsequenz
anschließend auf dem Scheduler-Grundgerüst ergänzt.

## Phase 7 – Grundauswertung

Abgeschlossen als erste Version; spätere Erweiterungen dokumentiert.

Ziel:

- Gemeinsame Kennzahlen definieren, bevor Ziele bewertet werden.
- Geplante, beantwortete, erfolgreiche, negative, ausgenommene und offene Einträge
  sauber unterscheiden.
- Erfolgsquoten, Vollständigkeit und Aussagekraft festlegen.
- Später auswählbare Kennzahlen auf Aufgaben- oder Habit-Karten vorbereiten.

Aktueller Stand:

- Die erste Summary berechnet Kernwerte aus `task_entries`.
- Feste Zeiträume sind vorbereitet: letzte 7 Tage, letzte 20 Tage, letzte
  30 Tage und seit Beginn.
- Prozentwerte werden mit einer Nachkommastelle und zusätzlichem Verhältnis
  angezeigt, zum Beispiel `66,7 %` und `2 von 3`.
- Jede Analyse-Kennzahl erhält einen Info-Text.
- Eine erste Aufgaben-/Habit-Detailansicht ist über „Details & Auswertung“ im
  Aufgabenmenü erreichbar.
- Die Karte selbst bleibt zunächst unverändert; spätere Kartenkennzahlen werden
  erst nach der Detailansicht auswählbar gemacht.
- Die Detailansicht aktualisiert live, wenn sich Einträge im gewählten Zeitraum
  ändern.
- Die Detailansicht wurde grob im laufenden App-Betrieb geprüft und wirkt auf
  den ersten Blick passend.
- Bei fehlender Bezugsmenge werden freundliche Leertexte statt nur technischer
  Platzhalter angezeigt.

Betroffene zentrale Dateien:

- `lib/features/aufgaben/data/task_analytics_summary.dart`
- `lib/features/aufgaben/data/task_analytics_period.dart`
- `lib/features/aufgaben/data/task_analytics_display.dart`
- `lib/features/aufgaben/data/aufgaben_repository.dart`
- `lib/features/aufgaben/presentation/task_detail_screen.dart`
- `lib/features/aufgaben/presentation/widgets/task_card.dart`
- `lib/features/aufgaben/presentation/aufgaben_screen.dart`

Bewusst offen:

- Wording-Konsistenz weiter glätten
- Behandlung einmaliger Aufgaben in der Detailansicht kurz abgrenzen
- Aussagekraft-Schwellen
- frei wählbare Zeiträume
- auswählbare Kartenkennzahl
- Zielbewertung auf Basis der Grundkennzahlen

Ergänzende Entscheidung:

- Die Grundauswertung ist eine Instanz-Auswertung. Sie zeigt ehrlich, was mit
  den erzeugten Einträgen passiert ist.
- Bei Aufgaben mit Ziel soll später nicht pauschal die strenge
  Instanz-Erfolgsquote die führende Aussage sein.
- Stattdessen soll die Zielerreichung führen, zum Beispiel bei „täglich
  anzeigen, aber Ziel 2x pro Woche“.
- Die Instanzwerte bleiben darunter als Erklärung und Rohdaten sichtbar.

## Phase 8 – Direkte Missed-Konsequenz

Abgeschlossen: Kernlogik umgesetzt, zentrale Lifecycle-Anbindung ergänzt,
komplexer Szenario-Test bestanden und grob in der App geprüft.

Ziel:

- Die erste automatische Missed Policy technisch ausführen.
- Abgelaufene `pending`-Instanzen automatisch in einen endgültigen Status
  überführen.
- Automatische Herkunft und angewendete Policy nachvollziehbar speichern.

Fachliche Regeln:

- Automatischer Erfolg ist ausgeschlossen.
- Erlaubte automatische Ergebnisse sind:
  - `failure`
  - `no_entry`
- Bereits endgültige Instanzen werden nicht verändert.
- Die Verarbeitung muss idempotent sein.
- Mehrfaches Ausführen darf keine doppelten Instanzen erzeugen und keine
  unnötigen Schreibvorgänge auslösen.

Vorbereitete Detaildokumente:

- [`phase_08_direct_missed_policy/direct_missed_policy_plan.md`](phase_08_direct_missed_policy/direct_missed_policy_plan.md)
- [`phase_08_direct_missed_policy/direct_missed_policy_history.md`](phase_08_direct_missed_policy/direct_missed_policy_history.md)

Zu Beginn vorhandene technische Grundlage:

- `TaskInstanceScheduler`
- Statusmodell aus Phase 6
- Abschlussmetadaten aus Phase 6
- Grundauswertung aus Phase 7
- gespeicherte Missed-Policy-Konfigurationen

Noch offen:

- praktische Prüfung im laufenden App-Betrieb

Umgesetzt:

- Fehlende vergangene Instanzen werden bei vorhandenen Scheduler-Aufrufen bis
  zum geöffneten Tag nacherzeugt.
- Abgelaufene `pending`-Instanzen mit `MissedPolicy.direct` werden automatisch
  abgeschlossen.
- `MissedConsequence.markAsNotDone` erzeugt `failure`.
- `MissedConsequence.keepNeutral` erzeugt `no_entry`.
- Automatische Verarbeitung speichert Herkunft, angewendete Policy,
  angewendete Konsequenz sowie `finalizedAt` und `effectiveAt`.
- Einmalige Aufgaben mit `dueDate` erzeugen ihre Instanz auf diesem
  Fälligkeitsdatum, sodass `scheduledDate` den fachlichen Stichtag abbildet.
- Das Repository stellt einen zentralen Abgleich bis heute bereit.
- `main.dart` stößt den Scheduler bei App-Start, Rückkehr aus dem Hintergrund
  und beim Tageswechsel an, solange die App geöffnet ist.

Geprüft:

- gezielte Analyse der betroffenen Scheduler-/Repository-/Testdateien:
  keine Probleme gefunden.
- Die drei Kernfälle wurden extern in PowerShell erfolgreich getestet:
  direkte Konsequenz als Misserfolg, direkte Konsequenz als Kein Eintrag und
  einmalige Aufgabe mit Fälligkeit als Instanzdatum.
- Ein komplexes Nachholszenario wurde extern in PowerShell erfolgreich getestet:
  mehrere Tage Nichtnutzung, `failure`, `no_entry`, keine Missed Policy,
  manuell erledigte Instanz, wöchentlicher Fixtermin, einmalige Fälligkeit und
  Idempotenz ohne Duplikate.
- Nach der Lifecycle-Ergänzung lief `dart format` erfolgreich. Die gezielte
  Analyse hängt in der Codex-/VS-Code-Umgebung weiterhin und wurde per Timer
  beendet.

## Phase 9 – Puffer-Missed-Policy

In Umsetzung; fachliche Regeln festgelegt und Kernlogik technisch ergänzt.

Ziel:

- Puffer als verzögerte Konsequenz technisch ausführen.
- Nutzenden nach Fälligkeit eine klare Kulanzzeit geben.
- Nach dem Puffer eine eindeutige Folgeregel anwenden.
- Die Anzeige vor unkontrolliert vielen offenen Instanzen schützen.

Vorbereitete Detaildokumente:

- [`phase_09_buffer_policy/buffer_policy_plan.md`](phase_09_buffer_policy/buffer_policy_plan.md)
- [`phase_09_buffer_policy/buffer_policy_history.md`](phase_09_buffer_policy/buffer_policy_history.md)

Geklärte Regeln:

- Puffer beginnt nach Ablauf des regulären Fälligkeitstags.
- Nach der gewählten Anzahl voller Puffertage greift die Folgeregel.
- Bei Puffer ist eine Folgeregel Pflicht.
- Automatischer Erfolg bleibt ausgeschlossen.
- Erlaubte Folgeregeln sind `failure` und `no_entry`.
- `no_entry` ist erlaubt, braucht aber einen Warnhinweis, weil es die Auswertung
  neutralisiert beziehungsweise ihre Aussage verändern kann.
- Für kalendergebundene Rhythmen darf der Puffer maximal bis zur übernächsten
  regulären Erstellung reichen.
- Wenn der Puffer in die nächste reguläre Instanz hineinreicht, ist das erlaubt,
  braucht aber einen UI-Hinweis.
- `keep_open` wird nicht als Puffer-Sonderlogik gespeichert. Offen bleiben wird
  über Carryover oder über keine automatische Abschlussregel modelliert.
- Bei abschlussgebundenen Rhythmen dient Puffer vor allem der
  Rechtzeitigkeitsauswertung und Anzeige, zum Beispiel `Puffer Tag 2/5` statt
  `−X Tage`.

Umgesetzt:

- `mark_as_no_entry` als Puffer-Folgeregel ergänzt.
- `keep_open` bleibt nur als Legacy-Wert lesbar und ist keine neue
  Puffer-Auswahl mehr.
- Validator erlaubt bei Puffer nur `mark_as_failure` oder `mark_as_no_entry`.
- Validator begrenzt kalendergebundene Puffer auf den Abstand zur nächsten
  konkreten Instanz mal 2.
- Monatsrhythmen berechnen den nächsten Termin konkret, nicht pauschal mit 30
  Tagen.
- Scheduler verarbeitet Puffer automatisch und schließt nach Ablauf als
  `failure` oder `no_entry`.
- UI-Auswahl nach Puffer zeigt nur noch Misserfolg oder Kein Eintrag.
- Gezielte Tests für Validator, Monatsgrenze, Scheduler, Idempotenz,
  Überschneidung und abschlussgebundene Rhythmen sind ergänzt.

Nach Phase 9 noch offen:

- Vollständige Anzeige `Puffer Tag X/Y` in Tages-/Dringlichkeitslisten; diese
  Anzeige hängt eng mit Carryover/Phase 10 zusammen.

Prüfnachweis:

- Extern in PowerShell ausgeführt:
  `flutter test --no-pub test\features\aufgaben\data\aufgaben_repository_test.dart --plain-name "Puffer"`
- Ergebnis: `+5 All tests passed`.

## Phase 10 – Carryover/Aufstauen

Abgeschlossen. Diese Phase baut auf dem Scheduler-Grundgerüst und den
Entscheidungen aus Phase 8 und 9 auf.

Detaildokumente:

- [`phase_10_carryover/carryover_plan.md`](phase_10_carryover/carryover_plan.md)
- [`phase_10_carryover/carryover_history.md`](phase_10_carryover/carryover_history.md)

Umgesetzt:

- aufgestaute Instanzen als echte einzelne offene Einträge behandeln,
- neue Instanzen trotzdem weiter erzeugen,
- maximale Anzahl aufgestauter Instanzen begrenzen,
- älteste überzählige Instanz automatisch als `failure` oder `no_entry`
  verarbeiten,
- Tages-/Dringlichkeitslisten für alte offene Instanzen erweitern,
- `−X` für Carryover/Überfälligkeit und `Puffer Tag X/Y` für Puffer sauber
  unterscheiden.

Konkret umgesetzt:

- Der Scheduler prüft nach jeder chronologischen Instanzerzeugung das
  Carryover-Maximum.
- Das Maximum zählt alle offenen Carryover-Instanzen bis einschließlich der
  heutigen Instanz.
- Wird das Maximum überschritten, verarbeitet der Scheduler die ältesten
  überzähligen Instanzen automatisch als `failure` oder `no_entry`.
- Automatischer Erfolg bleibt ausgeschlossen.
- Die Verarbeitung speichert Herkunft und Policy-Metadaten:
  `resolutionOrigin = automatic`, `appliedMissedPolicy = carryover`,
  `appliedMissedConsequence`, `finalizedAt` und `effectiveAt`.
- Tages- und Habitansicht laden alte offene Carryover-Instanzen zusätzlich zur
  aktuellen Instanz.
- Die Dringlichkeitsansicht verwendet offene Instanzen als Grundlage, damit
  mehrere offene Einträge derselben Aufgabe sichtbar werden können.
- Alte offene Instanzen werden nach echtem Instanzdatum sortiert; die älteste
  Instanz kommt zuerst.
- Puffer-Instanzen im laufenden Puffer bleiben sichtbar und werden als
  `Puffer Tag X/Y` angezeigt.
- Carryover/überfällige Instanzen verwenden weiterhin die knappe `−X`-Anzeige.
- Gezielte Repository-Tests für Carryover-Maximum, `no_entry`-Konsequenz,
  Tagesansicht, Dringlichkeitsansicht und Puffer-Sichtbarkeit wurden ergänzt.

Nächster Schritt:

- Phase 11 vorbereiten: vollständige Auswertung vor Zielbewertung planen.

Prüfnachweis:

- Extern in PowerShell ausgeführt:
  `flutter test --no-pub test\features\aufgaben\data\aufgaben_repository_test.dart --plain-name "Carryover"`
- Ergebnis: `+4 All tests passed`
- Extern in PowerShell ausgeführt:
  `flutter test --no-pub test\features\aufgaben\data\aufgaben_repository_test.dart --plain-name "Tagesansicht zeigt alte offene Puffer-Instanzen im Puffer"`
- Ergebnis: `+1 All tests passed`

## Phase 11 – Vollständige Status-Auswertung

Abgeschlossen in erster Ausbaustufe. Diese Phase baut auf der Grundauswertung
aus Phase 7 und den stabilen Instanzen aus Phase 8 bis 10 auf.

Sie wurde bewusst vor die Zielbewertung gezogen. Die App soll zuerst alle
notwendigen Auswertungen verständlich anbieten; Ziele werden später auf diese
Werte gelegt.

Detaildokumente:

- [`phase_11_complete_analytics/complete_analytics_plan.md`](phase_11_complete_analytics/complete_analytics_plan.md)
- [`phase_11_complete_analytics/complete_analytics_history.md`](phase_11_complete_analytics/complete_analytics_history.md)

Startziel:

- Status-Auswertungen für wiederkehrende Aufgaben/Habits vervollständigen,
- Auswertungen für einzelne einmalige Aufgaben sauber abgrenzen,
- Sammelauswertungen für einmalige Aufgaben planen,
- Detailansicht einzelner Antworten, Notizen und visuelle Raster planen,
- `pending`, `failure` und `no_entry` korrekt und verständlich auswerten,
- eine stabile Grundlage für spätere Zielbewertung schaffen.

Bisher umgesetzt:

- Ordner `phase_11_complete_analytics` angelegt.
- Arbeitskarte `complete_analytics_plan.md` angelegt.
- Verlauf/Nachschlagewerk `complete_analytics_history.md` angelegt.
- Sichtbarkeitsdokumente für Status-Auswertungen und einzelne einmalige
  Aufgaben angelegt.
- Wiederkehrende Aufgaben/Habits zeigen alle vorgesehenen Status-Kennzahlen in
  der Detailansicht.
- Nicht verfügbare Auswertungen werden ausgegraut und erklärt.
- Einzelne einmalige Aufgaben zeigen alle vorgesehenen Detailfelder und
  Einzelwerte.
- Sammelauswertung einmaliger Aufgaben wurde als eigene Seite ergänzt.
- Hauptübersicht auf Phase 12 umgestellt.

Nächster Schritt:

- Phase 12 starten: erweiterte Erfassungsarten Zahl, Dauer und Uhrzeit
  fachlich und technisch vorbereiten.

## Phase 12 – Erweiterte Erfassungsarten

Gestartet am 26. Juli 2026. Phase 12 wird in kleinere Teilabschnitte 12a bis
12f umgesetzt, damit die breite Schema-, UI- und Auswertungsbasis kontrollierbar
bleibt.

Phase 12a legt die Grundlage und ist abgeschlossen:

- `recorded` wird als neuer Status fuer erfasste Wertdaten eingefuehrt.
- `recorded` gilt technisch als abgeschlossen und als positive
  Abschlussausloesung, ist aber noch keine Zielwertung.
- Werttypen werden zentral benannt: Zahl, Dauer und Uhrzeit.
- Verbindlichkeit wird zentral benannt: kein Wert, reines Tracking,
  verbindliche Wert-Eingabe.
- Bekannte Einheiten werden vorbereitet:
  - Liter und Milliliter,
  - Kilometer, Meter und Zentimeter,
  - Uhrzeit,
  - Stunden, Minuten und Sekunden.
- Eigene Zahlenbeschriftungen bleiben fuer Werte wie Schritte, Seiten oder
  Wiederholungen moeglich.
- Buendelbegriffe werden vorbereitet: Zeitintervall, Differenz und Summe.

Bewusst noch nicht Teil von 12a:

- neue Drift-Spalten oder neue Tabellen,
- Eingabe-UI fuer Werte,
- Speichern echter Wertdaten ausserhalb des bestehenden `numberValue`,
- virtuelle Tracking-Tage,
- Zwei-Werte-Buendel-UI,
- Wert-Auswertung aus Phase 13.

Pruefung:

- Gezielte Analyse der betroffenen Dateien: keine Probleme gefunden.
- Externe PowerShell-Pruefung:
  `flutter test --no-pub test\features\aufgaben\data\task_value_foundation_test.dart`
  mit `+5 All tests passed`.

Phase 12b ist am 4. August 2026 als abgeschlossen eingeordnet:

- Einzelwerte fuer Zahl, Dauer und Uhrzeit koennen in Aufgaben/Habits
  konfiguriert werden.
- Werte werden pro Instanz in einer eigenen Wertstruktur gespeichert.
- Ein gespeicherter Wert erzeugt den Status `recorded`.
- Einzelwerte koennen auf der Karte eingetragen und geaendert werden.
- Einmalige abgeschlossene Wert-Aufgaben sind ueber eine eigene Ansicht wieder
  auffindbar.
- Reines Tracking sperrt Missed Policy bereits sichtbar und fachlich.
- Praxisfehler aus 12b wurden korrigiert:
  - Speicherbutton bei `Wert erfassen`,
  - eigene Einheit,
  - Aufgabenart-Wechsel ohne Verlust der Wert-Konfiguration,
  - Wertfeld setzt sich beim Datumswechsel zurueck,
  - Fokus wird nach dem Speichern entfernt.

Bewusst nicht Teil von 12b:

- virtuelle leere Tracking-Tage,
- eigene Tracking-Gruppe in der Habits-Ansicht,
- verbindliche Wert-Eingaben mit Missed Policies,
- Zwei-Werte-Buendel,
- Wert-Auswertung und Wert-Ziele.

Phase 12c ist gestartet:

- Reines Tracking soll ohne automatische leere Datenbankeintraege funktionieren.
- Leere Tage sollen fuer Anzeige, Matrix und spaetere Auswertung ableitbar sein.
- Die Habits-Ansicht soll reine Trackings verstaendlich von verpflichtenden
  offenen Habits trennen.

Phase 12c ist am 4. August 2026 abgeschlossen:

- Reine Trackings erscheinen ohne gespeicherten Entry in Tages-/Habits-Ansichten.
- Der Scheduler und die Erstellung erzeugen fuer reine Trackings keine leeren
  Entries.
- Erst eine echte Eingabe erzeugt einen Entry mit Wertdaten.
- Reine Trackings werden im Habits-Tab separat als `Tracking` gruppiert.
- Zwei Repository-Tests wurden fuer diese Regeln ergaenzt; der lokale
  Flutter-Testlauf haengte in der Codex-Umgebung, deshalb ist externe
  PowerShell-Pruefung empfohlen.

Phase 12d ist am 4. August 2026 abgeschlossen:

- Verbindliche Wert-Eingaben erzeugen normale `pending`-Instanzen.
- Ein eingetragener Wert schliesst die Instanz als `recorded` ab.
- `recorded` wird nicht durch spaetere Missed-Policy-Laeufe ueberschrieben.
- Direkte Konsequenz, Puffer und Carryover funktionieren fuer Pflichtwerte.
- Die externe PowerShell-Pruefung durch den Nutzer ist erfolgreich gelaufen:
  `reines Tracking` mit `+2 All tests passed` sowie die Pflichtwert-/Wert-Tests
  mit `All tests passed`.

Phase 12e wurde am 4. August 2026 bewusst abgegrenzt und am 9. August 2026
als erster technischer Buendel-Kern abgeschlossen:

- Fachlich ist festgelegt, wie Zwei-Werte-Buendel funktionieren sollen.
- Buendel-Tabellen und Buendelversionierung sind vorhanden.
- Repository-Methoden erstellen, laden und loesen Buendel auf.
- Zeitintervall, Differenz und Summe werden aus zwei Teilwerten berechnet.
- In Tages-/Habit-Ansichten ersetzt die Buendelkarte die zwei Einzelkarten.
- Eingaben schreiben weiter auf die Teil-Entries; abgeleitete Werte werden
  nicht doppelt gespeichert.
- Beim Aufloesen bleiben Rohdaten erhalten und Teil-Trackings erscheinen wieder
  einzeln.
- Ein Teil-Tracking darf in Phase 12 nur in einem aktiven Eingabe-Buendel sein.
- Gezielt vorbereitete Tests decken Zeitintervall, Freitext-Zahlendifferenz,
  Mehrfachbuendel-Sperre, Aufloesen und Loeschschutz ab.
- Die externe PowerShell-Pruefung dieser neuen Buendeltests wurde am
  10. August 2026 erfolgreich mit `+5 All tests passed` bestaetigt.
- Phase 12f ist damit abgeschlossen.

## Phase 12 bis Store-Release

Noch geplant oder bewusst vertagt, aber release-relevant, solange es zur ersten
Aufgaben-/Habit-App-Version gehört:

- Phase 12: erweiterte Erfassungsarten vor Firebase:
  - Zahleneingaben
  - Dauer
  - Uhrzeit
  - später Skalen
- Phase 13: Auswertung erweiterter Eingaben:
  - Summe, Durchschnitt, Min/Max, Verlauf und Wertvergleiche für Zahl, Dauer,
    Uhrzeit und später Skalen
- Phase 14: Zielbewertung:
  - Ziele werden auf vorhandene Status- und Wert-Auswertungen gelegt
  - Zielbewertung erhält keine eigene versteckte Rechenlogik
- Phase 15: Kennzahl auf Aufgaben-/Habit-Karten:
  - pro Aufgabe oder Habit eine kompakte, frei oder sinnvoll auswählbare
    Statistik
- Phase 16: Historisierung und Bearbeitung:
  - vollständige Definitionsversionierung anhand realistischer Änderungen
    prüfen
  - Projektwechsel, Zieländerungen und alte Einträge verständlich halten
- Phase 17: Papierkorb und Wiederherstellung:
  - kontrolliertes Löschen statt sofortiger endgültiger Entfernung
  - Wiederherstellung und Aufbewahrungsdauer klären
- Phase 18: Projekte:
  - Projektzuordnung von Aufgaben und Habits
  - Projektansicht und Projektauswertung
  - sichere Entscheidung zur Projektlöschung
  - spätere Unterprojekte und Projekt-in-Projekt-Strukturen abgrenzen
- Phase 19: Firebase-Synchronisierung vorbereiten:
  - synchronisierbare Struktur nach erweitertem Eingabemodell
  - Konfliktfähigkeit und schreibsparsame Deltas vorbereiten
- Phase 20: private Nutzung und Testphase:
  - App selbst real im Alltag nutzen
  - wenige bekannte Tester ohne öffentliche Store-Sichtbarkeit einladen
  - Rückmeldungen zu Verständlichkeit, Stabilität und Nutzen sammeln
- Phase 21: Testergebnisse ausarbeiten und umsetzen:
  - Änderungen und Erweiterungen aus dem Test konzipieren
  - bestätigte Pakete umsetzen, prüfen und Nachtests zuordnen
  - Prioritäten, aktuellen Stand und zurückgestellte Ideen dokumentieren
- Phase 22: Store-Release vorbereiten:
  - Datenintegrität prüfen
  - UX-Feinschliff und leere Zustände prüfen
  - Store-/Distribution-Entscheidung treffen
  - offene Paywall-/Monetarisierungsentscheidung einordnen

Später:

- Unteraufgaben
- Unterprojekte
- Aufgaben-Abhängigkeiten
- Auswertungen, die nicht für die erste App-Version nötig sind
- weitere Komfortfunktionen nach dem ersten Release

Wichtige neue Release-Entscheidung:

- Die App soll möglichst erst released werden, wenn neben Ja/Nein auch
  Zahleneingaben beziehungsweise weitere einfache Eingabearten möglich sind.
- Firebase-Synchronisierung wird deshalb hinter das erweiterte Eingabemodell
  geschoben.
- Grund: Das lokale Datenmodell soll die wichtigsten Eingabearten kennen, bevor
  es synchronisierbar und damit schwerer änderbar wird.

## Phase 13 - Wert-Auswertung abgeschlossen

Phase 13 schliesst die Auswertung erweiterter Eingaben als release-relevanten
Block ab. Die App kann damit Wertdaten aus Phase 12 auswerten, ohne Ziele,
Kartenkennzahlen oder Cloud-Synchronisierung vorwegzunehmen.

Umgesetzt und geprueft:

- Einzelwert-Auswertung fuer Zahl, Dauer und Uhrzeit.
- Zeitraumbezogene Kennzahlen fuer letzte 7, 20, 30 Tage und seit Beginn.
- Summe, Durchschnitt, Minimum und Maximum fuer passende Wertarten.
- Uhrzeit-Auswertung mit Tagesbezug ueber `dayOffset`.
- getrennte Verarbeitung von `recorded`, `pending`, `failure`, `no_entry` und
  virtuell fehlenden reinen Tracking-Tagen.
- Einzelwertdetails fuer einmalige Wert-Aufgaben.
- Zwei-Werte-Buendel fuer Zeitintervall, Differenz und Summe.
- Buendel-Erstellung ueber Aufgabenoption `Buendeln`.
- `Gilt ab`, Differenzrichtung, Anzeigeart und Cross-Day-Zuordnung bei
  Buendeln.
- verknuepfte Einzelkarten mit Buendel-Hinweis und Zugang zur
  Buendel-Auswertung.

Pruefung:

- Externe PowerShell-Buendeltests liefen mit `+9 All tests passed`.
- Gezielte Analyse der Phase-13-Dateien lief mit `No issues found`.
- Abschluss-Cleanup in 13d entfernte einen ungenutzten Import; die betroffene
  Datei wurde erneut gezielt mit `No issues found` analysiert.

Bewusst spaeter:

- Zielbewertung: Phase 14.
- Kartenkennzahl: Phase 15.
- mehrere Werte pro Aufgabe und Tag.
- eigene Einheitenverwaltung.
- Diagramme, Trends, Logbuch und Messwert-Historie.
- historisch datumsscharfe Rekonstruktion aufgeloester Buendel.

Damit ist Phase 14 der naechste aktive Schritt: Ziele werden auf die
vorhandenen Status- und Wert-Auswertungen gelegt, ohne eigene parallele
Rechenlogik aufzubauen.

## Phase 14a - Erste Zielbewertung umgesetzt

Am 15. September 2026 wurde der erste technische Schnitt von Phase 14
umgesetzt.

Kern:

- Statusziele werden erstmals live bewertet.
- Der fuehrende Release-Fall ist `X Erfolge in X Tagen`.
- Die Bewertung schaut rollierend rueckwaerts inklusive heute.
- Zielbewertung nutzt die vorhandene `TaskAnalyticsSummary`; es entsteht keine
  zweite Rohdatenlogik.
- In der Detailansicht erscheint bei Aufgaben mit Ziel ein Abschnitt `Ziel`.
- Wiederkehrende Aufgaben duerfen nicht mit aktivem Ziel und
  `MissedPolicy.none` gespeichert werden, weil Zielbloecke sonst unklar offen
  bleiben koennen.

Ampel:

- `Erreicht`: genug Erfolge im Zielzeitraum.
- `Auf Kurs`: noch nicht genug Erfolge, aber offene Eintraege koennen das Ziel
  noch erreichbar machen.
- `Nicht erreichbar`: selbst mit offenen Eintraegen reichen die moeglichen
  Erfolge nicht mehr.
- `Keine Daten`: im Zielzeitraum gibt es noch keine Eintraege.
- `Noch nicht unterstuetzt`: Zieltyp gehoert nicht zum ersten Statusziel-
  Schnitt, z. B. `max_failures` oder Wertziele.

Bewusst offen:

- 14b: historische abgeschlossene Zielbloecke fuer Statusziele.
- 14c: Wirksamkeitsstart von Zielaenderungen.
- 14d: Wertziele fuer Zahl, Dauer und Buendel.
- UI-Vereinfachung der Zielerstellung.

Planbereinigung am 15. September 2026:

- Die aktuelle Phase-14-Struktur lautet jetzt 14a bis 14e:
  - 14a rollierende Statusziel-Livebewertung;
  - 14b historische Zielbloecke fuer Statusziele;
  - 14c Zielaenderungen / Wirksamkeitsstart;
  - 14d Wertziele fuer Zahl, Dauer und Buendel;
  - 14e UI-Vereinfachung und Abschluss.
- Die alte Paketplanung mit Nummern wie `14a.1`, `14a.2` und `14b.1` bleibt
  im Phase-14-Plan als Vorplanung/Archiv erhalten und ist nicht mehr der
  aktuelle Hauptablauf.

Pruefung:

- Formatierung der betroffenen Dart-Dateien lief durch.
- Analyzer und gezielter Flutter-Test haengen in der Codex-Umgebung ohne
  Ausgabe. Externe PowerShell-Pruefung wurde deshalb genutzt.
- Extern bestaetigt:
  - Zielbewertungs-Tests `rollierendes Statusziel`: `+3 All tests passed`
  - Validator-Test fuer Missed-Policy-Pflicht: `+1 All tests passed`
  - gezielte Analyse: `No issues found`

## Phase 14b - Historische Zielbloecke umgesetzt

Am 15. September 2026 wurde die historische Zielbewertung fuer Statusziele
umgesetzt.

Kern:

- Historische Zielbloecke werden dynamisch aus vorhandenen Eintraegen
  berechnet.
- Es gibt keine gespeicherten Zielbewertungen und keine neue Ziel-Cache-Tabelle.
- Die Detailansicht zeigt unter der Live-Zielkarte einen aufklappbaren Bereich
  `Zielhistorie`.
- Die Zielquote zaehlt nur bewertbare abgeschlossene Bloecke.
- Der laufende Zielblock wird nicht als Historienblock angezeigt.
- Abgeschlossene Bloecke mit offenen `pending`-Eintraegen werden als
  `Nicht gewertet` angezeigt und aus der Quote herausgerechnet.

Betroffene Dateien:

- `lib/features/aufgaben/data/task_goal_evaluation_summary.dart`
- `lib/features/aufgaben/data/task_goal_evaluation_display.dart`
- `lib/features/aufgaben/data/aufgaben_repository.dart`
- `lib/features/aufgaben/presentation/task_detail_screen.dart`
- `test/features/aufgaben/data/aufgaben_repository_test.dart`

Pruefung:

- `dart format` lief erfolgreich.
- Externe PowerShell-Pruefung ist gruen:
  - gezielte Analyse der betroffenen Dateien: `No issues found`
  - Zielhistorien-Tests `historische Statusziel`: `+3 All tests passed`

Empfohlener PowerShell-Test:

```powershell
cd "C:\Users\maxkr\Documents\Flutter Apps\Upgear\momentum"
flutter test --no-pub test\features\aufgaben\data\aufgaben_repository_test.dart --plain-name "historische Statusziel"
```

Naechster Schritt:

- Phase 14c: Zielaenderungen / Wirksamkeitsstart.

## Phase 14c - Zielaenderungen / Wirksamkeitsstart umgesetzt

Am 15. September 2026 wurde die Behandlung reiner Zielaenderungen umgesetzt.

Kern:

- Reine Zielaenderungen mitten im Zielblock koennen ab dem naechsten Zielblock
  vorgemerkt werden.
- Die aktive Aufgabe bleibt dabei bis zum Wirksamkeitsdatum fachlich auf der
  bisherigen Zieldefinition.
- Die zukuenftige Zieldefinition wird in `task_definition_versions` gespeichert.
- Live-Zielbewertung und historische Zielbloecke lesen die gueltige
  Zieldefinition fuer das betrachtete Datum beziehungsweise den Blockstart.
- Sofortige Zielaenderungen mitten im Block machen den betroffenen
  historischen Mischblock spaeter `Nicht gewertet`.
- Die Bearbeitungs-UI fragt bei reiner Zielaenderung mitten im Block nach:
  `Ab naechstem Zielblock` oder `Sofort anwenden`.

Bewusst nicht erweitert:

- Keine allgemeine Zukunfts-Queue fuer beliebige Aufgabenprofil-Aenderungen.
- Keine gespeicherten Zielbewertungen.

Pruefung:

- `dart format` lief erfolgreich.
- Externe PowerShell-Pruefung ist gruen:
  - gezielte Analyse der betroffenen Dateien: `No issues found`
  - Zielaenderungs-Tests `Zielaenderung`: `+4 All tests passed`

Empfohlener PowerShell-Test:

```powershell
cd "C:\Users\maxkr\Documents\Flutter Apps\Upgear\momentum"
flutter test --no-pub test\features\aufgaben\data\aufgaben_repository_test.dart --plain-name "Zielaenderung"
```

Naechster Schritt:

- Phase 14d: Wertziele fuer Zahl, Dauer und Buendel.

## Phase 14d.1 - Wertziele fuer einzelne Zahl-/Dauer-Aufgaben umgesetzt

Am 15. September 2026 wurde der erste Wertziel-Schnitt umgesetzt.

Kern:

- Neue Zieltypen:
  - `value_sum_min`
  - `value_average_min`
  - `value_average_max`
- Wiederkehrende Zahl- und Dauer-Aufgaben koennen Wertziele nutzen.
- Uhrzeit-Aufgaben bleiben Tracking-only und bekommen keine Wertzielauswahl.
- Der Zielwert nutzt fuer diesen Release-Schnitt das vorhandene Feld
  `goalValue`:
  - Zahl: direkter Zahlenwert;
  - Dauer: Minuten in der UI, intern Sekunden.
- Die Wert-Detailansicht zeigt Zielstatus, Zielergebnis, Zielzeitraum und
  Datenbasis.
- Fehlende/offene/verpasste Eintraege werden nicht als `0` gewertet.
- Rechnerisch erreichte Wertziele mit Datenluecken werden als Warnstatus
  angezeigt, nicht als uneingeschraenktes Gruen.

Bewusst offen:

- Buendel-Wertziele sind noch nicht abgeschlossen, weil Buendel-Versionen keine
  eigenen Zielfelder besitzen.
- Ein Buendel-Ziel soll nicht an eine Teilaufgabe gehaengt werden, sondern an
  den abgeleiteten Buendelwert.

Pruefung:

- `dart format` lief erfolgreich.
- Gezielte Analyse der betroffenen Dateien: `No issues found`.
- Gezielte Flutter-Tests hingen in der Codex-Umgebung ohne Ausgabe und muessen
  extern per PowerShell bestaetigt werden.

## Phase 14d.2 - Buendel-Wertziele abgeschlossen

Am 15. September 2026 wurde der naechste Wertziel-Schnitt fuer Buendel
umgesetzt und extern bestaetigt.

Umgesetzt:

- Buendel-Zielfelder wurden am Buendel-Versionsmodell vorgesehen.
- Schema-Version wurde fuer die Migration auf 17 angehoben.
- Repository-Methoden fuer Buendel-Wertzielbewertung wurden ergaenzt.
- Die Buendel-Erstellung bietet Wertziel-Konfiguration an.
- Die Buendel-Detailansicht zeigt Zielbewertungen direkt am Buendel.
- Tests fuer Buendel-Wertziele wurden ergaenzt.

Pruefung:

- Drift-Codegenerierung wurde extern erfolgreich ausgefuehrt.
- Gezielte Analyse wurde extern bestaetigt: `No issues found`.
- Gezielte Buendel-Wertziel-Tests wurden extern bestaetigt:
  `+3 All tests passed`.

Empfohlene PowerShell-Tests:

```powershell
cd "C:\Users\maxkr\Documents\Flutter Apps\Upgear\momentum"
flutter test --no-pub test\features\aufgaben\data\aufgaben_repository_test.dart --plain-name "Wertziel"
```

```powershell
cd "C:\Users\maxkr\Documents\Flutter Apps\Upgear\momentum"
flutter test --no-pub test\features\aufgaben\data\task_configuration_validator_test.dart --plain-name "value goal"
```

## Phase 14e - UI-Vereinfachung der Zielauswahl abgeschlossen

Am 15. September 2026 wurde der UI-Abschluss fuer Phase 14 umgesetzt und
extern bestaetigt.

Umgesetzt:

- Zieloptionen werden kontextabhaengig gefiltert.
- Statusaufgaben zeigen keine Wertziele.
- Buendel zeigen keine Statusziele.
- Zeitintervall-Buendel zeigen keine Summenziele.
- Kurze Hinweise erklaeren die verfuegbaren Zielarten.
- Unpassende gespeicherte Zieltypen fallen im Widget sicher auf `Kein Ziel`
  zurueck.
- Ein gezielter Widget-Test fuer die Zielauswahl wurde ergaenzt.

Pruefung:

- `dart format` lief erfolgreich.
- Gezielte Analyse wurde in der Codex-Umgebung bestaetigt: `No issues found`.
- Gezielte Analyse wurde extern bestaetigt: `No issues found`.
- Der gezielte Widget-Test wurde extern bestaetigt: `+3 All tests passed`.

Empfohlener PowerShell-Test:

```powershell
cd "C:\Users\maxkr\Documents\Flutter Apps\Upgear\momentum"
flutter test --no-pub test\features\aufgaben\presentation\widgets\task_goal_field_test.dart --plain-name "Zielauswahl"
```

## Phase 16 - Historisierung und Bearbeitung abgeschlossen

Am 20. September 2026 wurden die Pakete 16a–16f umgesetzt und automatisiert
abgenommen.

Umgesetzt:

- Datenbankschema 19 mit getrennten Vormerkungen, zeitbezogenen
  Projektzuordnungen, Korrekturvorgängen und Eintragsrevisionen.
- Ein zentraler Definitionsresolver für Scheduler, Tagesansicht, Eingaben und
  Auswertungen; alte Einträge verwenden ihren historischen Definitionsstand.
- Planungsänderungen ab morgen, gruppierte Zielvormerkungen, sofortige
  Textänderungen sowie Sperren für Identitäts- und Messkonfiguration.
- Kopiervorlage mit neuer ID und ohne Übernahme von Historie oder Bündeln.
- Stabile Identität beim Verschieben einmaliger Aufgaben einschließlich
  ursprünglichem Termin und Notiz.
- Einzel- und Sammelkorrekturen, Wertentfernung, Durchführungstag und
  persistentes einfaches Undo mit Revisionsschutz.
- Projektwechsel ab Stichtag oder für die gesamte Historie sowie Projekt-Undo,
  ohne fachliche Aufgaben-Snapshots als Zuordnungshistorie zu missbrauchen.
- Historische Bündelintervalle, sofort sichtbare Auflösung und Schutz vor
  stiller Aggregation inkompatibler Wertdefinitionen.

Prüfung:

- Drift-Codegenerierung erfolgreich.
- `flutter test --no-pub test/features/aufgaben test/features/projekte`:
  117 Tests bestanden.
- Vollständiges `flutter analyze`: keine Probleme gefunden.
- Der dokumentierte manuelle Geräteablauf bleibt eine zusätzliche
  Praxisprüfung und ist keine offene Produktentscheidung.

Bewusst später: kompatible Einheitenwechsel, freie rückwirkende
Projektstichtage, mehrere Vormerkungen derselben Gruppe, wechselnde
Bündelquellen innerhalb derselben ID, mehrstufiges Undo und eine ausführliche
sichtbare Änderungshistorie. Papierkorbregeln für die neuen Daten gehören in
Phase 17.

## Phase 15 - Automatischer Prototyp (Abschlussbewertung revidiert)

Nachtrag vom 17. September 2026: Die fachliche Neuplanung wurde inzwischen
technisch umgesetzt. Pro Aufgabe/Habit und Bündel kann eine Kennzahl gewählt,
auf Standard zurückgesetzt oder ausgeblendet werden. Die Einstellung liegt in
einer separaten, versionierten Preference-Tabelle und erzeugt keine fachliche
Definitionsversion. Ziel-, Status-, Wert-, Instanz- und Bündelkennzahlen nutzen
die vorhandenen Auswertungen mit Stichtag und sichtbarer Datenbasis.

Schema 18 und die Drift-Codegenerierung wurden extern erfolgreich bestätigt.
Die gezielte Analyse meldete `No issues found`; Parser-, Migrations-,
Repository-, Auswahl- und Layouttests sind grün. Ein dabei gefundener
Tagesgrenzenfehler für Definitionsänderungen am aktuellen Tag wurde für Aufgaben
und Bündel korrigiert und durch den Einheitenwechsel-Regressionstest bestätigt.
Der begrenzte manuelle Praxistest wurde anschließend vom Nutzer bestätigt.
Phase 15 ist damit vollständig abgeschlossen. Der ausführliche Stand steht im
[`card_metric_plan.md`](phase_15_card_metric/card_metric_plan.md) und im
[`card_metric_history.md`](phase_15_card_metric/card_metric_history.md).

Nachtrag vom 17. September 2026: Die folgende Umsetzung wurde ohne ausreichende
Produktabstimmung abgeschlossen. Phase 15 ist erneut geplant; massgeblich ist
[`card_metric_plan.md`](phase_15_card_metric/card_metric_plan.md). Nutzerauswahl
kommt bereits in Phase 15. Die folgenden Angaben bleiben als Prototyp-Verlauf
erhalten und belegen keine Umsetzung der neuen Planung.

Am 15. September 2026 wurde die automatische Kennzahl auf Aufgaben-/Habit- und
Buendelkarten umgesetzt und extern bestaetigt.

Umgesetzt:

- Neues berechnetes Modell `TaskCardMetric`.
- Kartenkennzahlen werden nicht gespeichert, sondern aus vorhandenen Daten
  abgeleitet.
- Ziele haben Vorrang vor Rohwerten.
- Wert-Aufgaben ohne Ziel zeigen den aktuellen Wert.
- Status-Aufgaben ohne Ziel zeigen bei vorhandener Antwort den aktuellen
  Status.
- Buendel ohne Ziel zeigen das berechnete Buendelergebnis.
- Teilweise erfasste Buendel zeigen eine warnende Status-Kennzahl.
- Aufgaben- und Buendelkarten nutzen denselben Kennzahl-Chip.

Bewusst nicht Teil des Release-Schnitts:

- frei waehlbare Kartenkennzahl pro Aufgabe/Habit,
- mehrere Kennzahlen pro Karte,
- eigene Persistenz fuer Kartenkennzahl-Einstellungen,
- Diagramme oder Trendpfeile.

Pruefung:

- `dart format` lief erfolgreich.
- Gezielte Analyse wurde in der Codex-Umgebung bestaetigt: `No issues found`.
- Gezielte Analyse wurde extern bestaetigt: `No issues found`.
- Der gezielte Flutter-Test wurde extern bestaetigt: `+3 All tests passed`.

Externer PowerShell-Test:

```powershell
cd "C:\Users\maxkr\Documents\Flutter Apps\Upgear\momentum"
flutter test --no-pub test\features\aufgaben\data\aufgaben_repository_test.dart --plain-name "Kartenkennzahl"
```

Ergänzung am 21. Juli 2026:

- Projekte werden als eigene release-relevante Phase ergänzt, weil Aufgaben
  bereits Projektzuordnungen speichern und der Code erste Projektansichten
  enthält.
- Release-Vorbereitung beginnt erst, nachdem die fachlichen Phasen des
  Aufgaben-/Habit-Blocks abgeschlossen sind.
- Vor einem öffentlichen Store-Release ist eine private Nutzungs- und Testphase
  vorgesehen.
- Paywall-Ideen werden zunächst gesammelt und nicht als stillschweigende
  Release-Pflicht behandelt. Die konkrete Einordnung folgt erst, wenn die App
  fachlich steht.

## Phase 17 – Papierkorb, Pausen und Wiederherstellung abgeschlossen

Abschluss am 4. Oktober 2026:

- Schema 20 speichert Lebenszykluszustände für Aufgaben und Bündel,
  kalenderbezogene Pause-/Papierkorbintervalle, minimale endgültige
  Löschmarker und die Herkunft freiwilliger Pauseneingaben.
- Löschen verschiebt Aufgaben und Bündel zunächst für exakt 168 Stunden in den
  Papierkorb. Wiederherstellung erhält IDs, Historie und vorhandene Einträge,
  erzeugt aber keine Pflichtinstanzen für ausgesparte Tage.
- Pausieren gilt ab morgen, Fortsetzen ab heute. Alte offene Instanzen behalten
  ihre Regeln. Über die Lebenszyklusübersicht kann während einer Pause trotzdem
  freiwillig für heute erfasst werden.
- Papierkorbobjekte sind aus regulären Tages-, Projekt-, Rohdaten- und
  Analytics-Lesern ausgeschlossen. Betroffene Zielfenster werden neutral als
  nicht bewertet behandelt.
- Ein Tracking darf mehreren Bündeln angehören. Bündel bleiben bei einer
  fehlenden Quelle erhalten und erklären Papierkorb, endgültige Löschung oder
  unerwartete Nichtverfügbarkeit ohne Null-Ersatz.
- Die Übersicht „Planung & Papierkorb“ unterstützt Fortsetzen, Restore,
  endgültige Einzellöschung und eine bestätigte Gesamtleerung. Die automatische
  Bereinigung nutzt die vorhandenen Start-, Resume- und Tageswechsel-Hooks.

Technische Prüfung:

- Drift-Code nach Schemaänderung erfolgreich generiert.
- Echte Schema-19-Fixture verlustfrei auf Schema 20 migriert;
  `foreign_key_check` bleibt leer.
- Vollständige Analyse: `No issues found`.
- Vollständiger Flutter-Testlauf: 129 Tests bestanden.
- Gezielte Lebenszyklus- und Migrationstests: 11 Tests bestanden (Teilmenge).

Bewusst nicht vorgezogen: Projekt-Papierkorb und Projektstruktur aus Phase 18
sowie Firebase-/Outbox-/Mehrgeräte-Konflikte aus Phase 19.

## Phase 18 – Projekte abgeschlossen

Abschluss am 6. Oktober 2026:

- Schema 21 macht Projekte revisionsfähig und ergänzt Archiv, Papierkorb,
  Sieben-Tage-Purge sowie einen anonymisierten endgültigen Identitätsverweis.
- Aufgaben, Habits und Bündel verwenden einen gemeinsamen datierten
  Zuordnungsdienst. Bündel bleiben unabhängig von ihren Quellen genau einem
  Projekt oder keinem Projekt zugeordnet.
- Projektmetadaten und Mitgliedschaft sind getrennte Schreibvorgänge; ein
  unverändertes Speichern erzeugt keine Historienereignisse.
- Beide Projektlöschvarianten sind umgesetzt. Gemeinsame Löschungen speichern
  exakte Batch-Mitglieder samt Revision; Restore kann nur das Projekt oder die
  noch unveränderten Batch-Inhalte zurückholen.
- Die Übersicht gruppiert aktuelle Aufgaben, Habits und Bündel. Die Analyse
  wertet historische Projektbeiträge in 7/20/30 Tagen oder seit Beginn aus und
  trennt Aufgabenstatus von Bündelstatus.
- Archiv und Projektpapierkorb sind im Projektbereich erreichbar; Projekte
  sind außerdem Teil der gemeinsamen Ansicht „Planung & Papierkorb“.

Technische Prüfung:

- Drift-Codegenerierung für Schema 21 erfolgreich.
- Echte Schema-19- und Schema-20-Migrationsfixtures sind grün und behalten
  gültige Fremdschlüssel.
- Projekt-, Zuordnungs-, Stale-Preview-, Restore-, Purge- und Analytics-
  Regressionen sind grün.
- Vollständige Analyse ohne Befund; gemeinsamer Abschlusslauf mit
  **138 bestandenen Tests**.

Phase 19 übernimmt die neuen Revisionen, Zuordnungsereignisse,
Projekt-Löschbatches und anonymen Projektmarker in die Sync-Vorbereitung.

## Phase 19 – Lokale Sync-Vorbereitung abgeschlossen

Abschluss am 8. Oktober 2026:

- Schema 22 ergänzt nullable technische Änderungszeitpunkte an Aufgaben und
  Bündelversionen. Für Altbestände wird kein unzuverlässiger Zeitpunkt
  erfunden; `null` bleibt ein ausdrücklich unbekannter Ausgangsstand.
- Neue und echte Änderungen an Aufgabenstamm, fälligen Definitionen,
  Projektzuordnung und Lebenszyklus führen den Aufgabenzeitpunkt mit. Reine
  Anzeige und identisches Speichern bleiben ohne erneuten Write.
- Bündelversionen erhalten bei Erstellung, Textänderung, Intervallende und
  Aufhebung einen Zeitpunkt. Wiederholtes Auflösen ist idempotent.
- Projekt-Neusortierung lehnt doppelte, unbekannte und nicht aktive IDs vor dem
  ersten Write ab und erhöht Revision/Zeitpunkt nur an verschobenen Projekten.
- Kartenpräferenzen unterscheiden nun fehlende Standardeinstellung, explizites
  Ausblenden und einen tatsächlich gespeicherten Reset. Reset und Setzen nutzen
  denselben Papierkorb-Schreibschutz; endgültiges Löschen räumt per Cascade auf.
- Bestehende Text-IDs, fachliche Tage, Rohwerte, Historien, Undo-/Restore-
  Metadaten und Projekt-Löschbatches bleiben unverändert erhalten.

Technische Prüfung:

- Drift-Codegenerierung für Schema 22 erfolgreich.
- Echte Schema-19- und Schema-20-Migrationsfixtures sind grün; alte neue
  Zeitfelder bleiben `null`, bestehende Kartenpräferenzen erhalten
  `isReset=false`, Fremdschlüssel bleiben gültig.
- Gezielte No-op-, Reset-, Bündel-, Historien-, Lebenszyklus-, Zuordnungs- und
  Projektregressionen sind grün.
- Vollständige Analyse ohne Befund; vollständiger Flutter-Testlauf mit
  **142 bestandenen Tests**.
- Kein manueller Gerätetest in diesem Umsetzungslauf.

Bewusst nicht umgesetzt: Firebase-Abhängigkeiten, Konto-/Geräteverwaltung,
Cloud-Outbox, Erstabgleich, Delta-Cursor, Konfliktkopien, Konfliktoberfläche und
echte Übertragung. Diese Grenzen sind im Phase-19-Plan als T19-06 festgehalten.

## Pflege dieses Dokuments

- Nach jeder abgeschlossenen oder begonnenen Phase kurz ergänzen:
  - was umgesetzt wurde,
  - welche Dateien/Modelle betroffen sind,
  - was bewusst noch nicht umgesetzt wurde,
  - welche Prüfung durchgeführt wurde.
- Keine fachlichen Regeln nur hier dokumentieren. Fachregeln gehören weiterhin
  in die Regelmatrix.
- Keine offenen Fragen stillschweigend als entschieden darstellen.

## 16. Oktober 2026 – Verbesserungsphase eingefügt

Phase 20 bleibt der Praxistest. Die neue [Phase 21](phase_21_test_improvements/README.md) führt Ausarbeitung und Umsetzung der Ergebnisse; Store-Release verschiebt sich auf [Phase 22](phase_22_store_release/README.md). Bereits implementierte Verbesserungen aus Commit `7263ea9` sind in Phase 21 dokumentiert; Gerätenachtests bleiben offen.
