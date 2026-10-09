# Momentum – Phase 14: Zielbewertung – Verlauf und aktueller Stand

Stand: 15. September 2026  
Status: Phase 14a umgesetzt und extern geprueft

## Zweck dieses Dokuments

Dieses Dokument hält fest, was in Phase 14 geprüft, entschieden und umgesetzt
wurde.

Abgrenzung:

- [`goal_evaluation_plan.md`](goal_evaluation_plan.md): kurze Arbeitskarte mit
  Ablauf und offenen Punkten.
- Dieses Dokument: Verlauf, Entscheidungen, betroffene Dateien und spätere
  Prüfergebnisse.

## Ausgangslage vor Phase 14

Bereits vorhanden:

- Grundauswertung aus Phase 7:
  - `strictSuccessRate`
  - `valuedSuccessRate`
  - Erfolge
  - Misserfolge
  - `no_entry`
  - offene Einträge
  - Fortschritt/Verarbeitung
- klare Statuswerte aus Phase 6:
  - `pending`
  - `success`
  - `failure`
  - `no_entry`
- automatische Verarbeitung aus Phase 8 bis 10:
  - direkte Konsequenz
  - Puffer
  - Carryover
- gespeicherte Zielfelder:
  - `goalType`
  - `goalValue`
  - `goalWindowDays`
  - `goalPeriod`
  - `goalPeriodAlignment`
- Aufgaben-Definitionsversionen, damit spätere Zieländerungen historische
  Instanzen nicht unbemerkt umdeuten.
- Neue Release-Entscheidung: Erweiterte Erfassungsarten wie Zahl, Dauer und
  Uhrzeit sollen vor Firebase kommen. Zielbewertung soll deshalb nicht so eng
  geplant werden, dass Ziele nur Ja/Nein-Status auswerten können.

## Kurskorrektur am 21. Juli 2026

Phase 14 war ursprünglich als Phase 11 geplant. Sie wurde bewusst nach hinten
verschoben.

Grund:

- Erst müssen die Auswertungen vollständig und verständlich sein.
- Ziele sollen keine eigene versteckte Rechenlogik erhalten.
- Zahleneingaben, Dauer und Uhrzeit verändern später ebenfalls, welche Ziele
  sinnvoll sind.

Neue Reihenfolge:

1. Phase 11: vollständige Status-Auswertung
2. Phase 12: erweiterte Erfassungsarten
3. Phase 13: Auswertung erweiterter Eingaben
4. Phase 14: Zielbewertung

## Start am 30. August 2026

Phase 13 ist abgeschlossen. Damit ist die fachliche Voraussetzung fuer Phase 14
erfuellt:

- Status-Auswertungen sind vorhanden.
- Wert-Auswertungen fuer Zahl, Dauer, Uhrzeit und Buendel sind vorhanden.
- Reine Tracking-Luecken, `pending`, `failure`, `no_entry` und `recorded` sind
  getrennt auswertbar.
- Buendelwerte werden aus Rohdaten abgeleitet und nicht doppelt gespeichert.

Phase 14 kann deshalb mit der Zielbewertung beginnen. Wichtig bleibt: Ziele
sollen keine eigene parallele Rechenlogik aufbauen, sondern die vorhandenen
Status- und Wert-Auswertungen verwenden.

## Fachlicher Startstand

Zielbewertung beantwortet nicht nur:

> Wie viele Instanzen waren erfolgreich?

Sondern:

> Wurde das gesetzte Ziel im relevanten Zeitraum erreicht?

Das ist wichtig, weil Rhythmus und Ziel absichtlich unterschiedlich sein dürfen.

Beispiel:

- Rhythmus: täglich anzeigen
- Ziel: 2 Erfolge pro Woche
- Ergebnis: 2 Erfolge, 3 Misserfolge, 2 Kein-Eintrag-Fälle

Die reine Erfolgsquote wäre nicht besonders hoch. Das Ziel „2 pro Woche“ kann
trotzdem erreicht sein. Deshalb soll bei Aufgaben mit Ziel die Zielbewertung
führend sein und die Instanz-Auswertung erklärend danebenstehen.

## Bereits getroffene Entscheidungen aus früheren Phasen

- Ziele werden dynamisch bewertet.
- Auswertung wird vor Zielbewertung entwickelt.
- Ziele nutzen dieselben Rohdaten wie die Auswertung.
- `success` ist der einzige positive Erfolgsstatus.
- `failure` zählt nicht als Erfolg.
- `no_entry` zählt nicht als Erfolg und bleibt separat sichtbar.
- `pending` ist offen und noch nicht endgültig bewertbar.
- Zieländerungen sollen später über Definitionsversionen nachvollziehbar
  bleiben.
- Statusziele und Wertziele werden erst umgesetzt, wenn die zugrunde liegenden
  Auswertungen vorhanden sind.

## Erwartete betroffene Dateien

| Datei/Bereich | Erwartete Rolle |
|---|---|
| `lib/features/aufgaben/data/task_goal.dart` | vorhandene Zieltypen und technische Konstanten prüfen |
| `lib/features/aufgaben/data/task_analytics_service.dart` oder vergleichbarer Bereich | Zielbewertung auf Basis der Grundauswertung ergänzen |
| `lib/features/aufgaben/data/aufgaben_repository.dart` | Daten für Zielbewertung bereitstellen oder vorhandene Streams nutzen |
| `lib/features/aufgaben/presentation/task_detail_screen.dart` oder Detailansicht | Zielstatus, Verhältnis und Info-Texte anzeigen |
| `lib/features/aufgaben/presentation/widgets/task_goal_field.dart` | Wording und Erstellungslogik ggf. mit Zielbewertung abgleichen |
| `test/features/aufgaben/data/...` | gezielte Tests je Zielart |

## Bisher umgesetzt

- Ursprünglich als Ordner `phase_11_goal_evaluation` angelegt und später nach
  `phase_14_goal_evaluation` verschoben.

## 15. September 2026 - Phase 14a umgesetzt: rollierende Statuszielbewertung

Der erste Umsetzungsschnitt von Phase 14 wurde bewusst klein gehalten, damit die
Zielbewertung nicht sofort Statusziele, Wertziele, historische Zielbloecke,
Zielaenderungen und Kartenkennzahlen vermischt.

Fachliche Entscheidung fuer diesen Schnitt:

- Zuerst werden Statusziele bewertet.
- Fuehrende Form ist `X Erfolge in X Tagen`.
- Bewertet wird rollierend rueckwaerts inklusive heute.
- `success` zaehlt als Erfolg.
- `failure` und `no_entry` zaehlen nicht als Erfolg.
- `pending` zaehlt nicht als Erfolg, kann aber ein Ziel noch erreichbar machen.
- Wenn `success + pending` kleiner als die benoetigte Erfolgsanzahl ist, ist das
  Ziel im aktuellen Fenster nicht mehr erreichbar.
- `max_failures` wird nicht als positives Release-Ziel bewertet und bleibt fuer
  diesen Schnitt nicht unterstuetzt.

Technisch umgesetzt:

- `TaskGoalEvaluationSummary`
  - berechnet Zielzeitraum, benoetigte Erfolge, erreichte Erfolge,
    offene Eintraege und Ampelstatus
  - Statuswerte: `no_goal`, `unsupported`, `no_data`, `achieved`,
    `reachable`, `missed`
- `TaskGoalEvaluationDisplay`
  - bereitet die Zielbewertung als bestehende Metric-Cards auf
  - zeigt Zielstatus, Zielfortschritt, Zielzeitraum, offene Eintraege und
    Datenhinweis
- `AufgabenRepository`
  - `getTaskGoalEvaluationSummary(...)`
  - `watchTaskGoalEvaluationSummary(...)`
  - nutzt intern die vorhandene `TaskAnalyticsSummary`, statt eine zweite
    Rohdatenlogik aufzubauen
- `TaskDetailScreen`
  - zeigt bei normalen wiederkehrenden Aufgaben mit Ziel einen neuen Abschnitt
    `Ziel`
  - Wertziele werden noch nicht bewertet; fuer Wertaufgaben bleibt nach der
    bereinigten Struktur Phase 14d offen
- `TaskConfigurationValidator`
  - sperrt bei wiederkehrenden Aufgaben die Kombination aus aktivem Ziel und
    `MissedPolicy.none`
  - Grund: Zielbloecke brauchen eine Abschlussregel fuer verpasste Eintraege,
    damit alte Zeitraeume historisch auswertbar bleiben
- Repository-Tests wurden fuer drei Kernfaelle ergaenzt:
  - Ziel erreicht
  - Ziel auf Kurs
  - Ziel nicht mehr erreichbar
- Validator-Test wurde fuer die Missed-Policy-Pflicht bei aktiven Zielen
  ergaenzt.

Pruefung:

- `dart format` lief fuer die betroffenen Dateien erfolgreich.
- `flutter analyze` und der gezielte Flutter-Test haengen in der Codex-
  Umgebung ohne Ausgabe. Das entspricht dem bereits bekannten lokalen
  Toolingproblem.
- Externe PowerShell-Pruefung ist deshalb massgeblich.
- Bestaetigt:
  - gezielte Analyse: `No issues found`
  - Validator-Test: `+1 All tests passed`
  - Zielbewertungs-Tests `rollierendes Statusziel`: `+3 All tests passed`

Genutzte PowerShell-Befehle:

```powershell
cd "C:\Users\maxkr\Documents\Flutter Apps\Upgear\momentum"
flutter test --no-pub test\features\aufgaben\data\aufgaben_repository_test.dart --plain-name "rollierendes Statusziel"
```

```powershell
cd "C:\Users\maxkr\Documents\Flutter Apps\Upgear\momentum"
flutter test --no-pub test\features\aufgaben\data\task_configuration_validator_test.dart --plain-name "requires missed policy"
```

```powershell
cd "C:\Users\maxkr\Documents\Flutter Apps\Upgear\momentum"
flutter analyze lib\features\aufgaben\data\task_goal_evaluation_summary.dart lib\features\aufgaben\data\task_goal_evaluation_display.dart lib\features\aufgaben\data\aufgaben_repository.dart lib\features\aufgaben\data\task_configuration_validator.dart lib\features\aufgaben\presentation\task_detail_screen.dart test\features\aufgaben\data\aufgaben_repository_test.dart test\features\aufgaben\data\task_configuration_validator_test.dart
```

Bewusst offen fuer die naechsten Phase-14-Schritte:

- 14b: historische abgeschlossene Zielbloecke fuer Statusziele.
- 14c: Wirksamkeitsstart spaeterer Zielaenderungen.
- 14d: Wertziele fuer Zahl, Dauer und Buendel.
- UI-Erstellung der Ziele weiter vereinfachen und alte Zieltypen in die neue
  Sprache `X Erfolge in X Tagen` ueberfuehren.
- Arbeitskarte `goal_evaluation_plan.md` angelegt.
- Verlauf/Nachschlagewerk `goal_evaluation_history.md` angelegt.
- Hauptübersicht auf Phase 11 umgestellt.

## 15. September 2026 - Phase-14-Plan bereinigt

Die Phase-14-Planung wurde nach der Umsetzung von 14a neu geordnet, damit keine
zwei konkurrierenden Nummerierungen nebeneinanderstehen.

Aktuelle Struktur:

| Phase | Bedeutung | Stand |
|---:|---|---|
| 14a | Rollierende Statusziel-Livebewertung | abgeschlossen |
| 14b | Historische Zielbloecke fuer Statusziele | abgeschlossen |
| 14c | Zielaenderungen / Wirksamkeitsstart | abgeschlossen und extern geprueft |
| 14d | Wertziele fuer Zahl, Dauer und Buendel | abgeschlossen und extern geprueft |
| 14e | UI-Vereinfachung und Abschluss | abgeschlossen und extern geprueft |

Die aelteren Paketnummern `14a.1`, `14a.2`, `14b.1` usw. wurden nicht geloescht.
Sie bleiben im Plan als `Alte Umsetzungspaket-Planung / Vorplanung` erhalten.
Diese alte Paketliste ist damit eine Detailquelle fuer Entscheidungen,
Akzeptanzkriterien und technische Hinweise, aber nicht mehr der aktuelle
Hauptablauf von Phase 14.

## 15. September 2026 - Phase 14b umgesetzt: historische Zielbloecke

Phase 14b wurde als direkter Ausbau von 14a umgesetzt. Die Zielhistorie bleibt
rein berechnet und speichert keine eigenen Zielbewertungen.

Umgesetzt:

- `TaskGoalHistorySummary` als Zusammenfassung historischer Zielbloecke.
- `TaskGoalHistoryBlock` fuer einzelne abgeschlossene Zielzeitraeume.
- Repository-Methoden:
  - `getTaskGoalHistorySummary(...)`
  - `watchTaskGoalHistorySummary(...)`
- Detailansicht:
  - aufklappbarer Bereich `Zielhistorie` unter der Live-Zielkarte;
  - Zielquote als zusammenfassende Kennzahl;
  - einzelne Zielbloecke mit Zeitraum, Status, Fortschritt und Hinweistext.

Fachliche Regeln:

- Historische Zielbloecke werden aus `goalWindowDays` ab Aufgabenstart
  gebildet.
- Nur vollstaendig abgeschlossene Zielbloecke werden gelistet.
- Der laufende Zielblock bleibt Teil der Livebewertung und erscheint nicht als
  abgeschlossener Historienblock.
- Bloecke ohne Eintraege werden als `Keine Daten` gezeigt und nicht in die
  Zielquote gerechnet.
- Bloecke mit offenen `pending`-Eintraegen werden als `Nicht gewertet`
  angezeigt und nicht in die Zielquote gerechnet.
- Bewertbare Bloecke sind erreicht, wenn `successCount >= requiredSuccessCount`
  gilt; andernfalls nicht erreicht.

Pruefung:

- `dart format` lief fuer die betroffenen Dart-Dateien erfolgreich.
- Gezielte Analyse der betroffenen Dateien ist gruen: `No issues found`.
- Externe PowerShell-Pruefung ist gruen:
  - gezielte Analyse: `No issues found`
  - Zielhistorien-Tests `historische Statusziel`: `+3 All tests passed`

Empfohlener externer PowerShell-Test:

```powershell
cd "C:\Users\maxkr\Documents\Flutter Apps\Upgear\momentum"
flutter test --no-pub test\features\aufgaben\data\aufgaben_repository_test.dart --plain-name "historische Statusziel"
```

Empfohlene externe PowerShell-Analyse:

```powershell
cd "C:\Users\maxkr\Documents\Flutter Apps\Upgear\momentum"
flutter analyze lib\features\aufgaben\data\task_goal_evaluation_summary.dart lib\features\aufgaben\data\task_goal_evaluation_display.dart lib\features\aufgaben\data\aufgaben_repository.dart lib\features\aufgaben\presentation\task_detail_screen.dart test\features\aufgaben\data\aufgaben_repository_test.dart
```

Naechster Schritt nach 14b:

- 14c: Zielaenderungen / Wirksamkeitsstart, damit Zielhistorie bei spaeter
  geaenderten Zielregeln nicht unbemerkt Mischbloecke erzeugt.

## 15. September 2026 - Phase 14c umgesetzt: Zielaenderungen / Wirksamkeitsstart

Phase 14c wurde so umgesetzt, dass reine Zielaenderungen mitten in einem
Zielblock nicht stillschweigend die laufende oder spaetere Historie verfaelschen.

Umgesetzt:

- Reine Zielaenderungen koennen ab dem naechsten Zielblock vorgemerkt werden.
- Die aktive `aufgaben`-Zeile bleibt bei dieser Variante bis zum
  Wirksamkeitsdatum unveraendert.
- Die zukuenftige Zielregel wird als neue `task_definition_versions`-Version
  mit passendem `validFrom` gespeichert.
- Live-Zielbewertung nutzt die fuer das betrachtete Datum gueltige
  Zieldefinition.
- Historische Zielbloecke nutzen die am Blockstart gueltige Zieldefinition.
- Sofortige Zielaenderungen mitten in einem Zielblock fuehren spaeter dazu,
  dass dieser Mischblock als `Nicht gewertet` angezeigt wird.
- Die Detailansicht zeigt eine geplante Zielaenderung als Hinweis.
- Die Bearbeitungs-UI bietet bei reiner Zielaenderung mitten im Block einen
  Dialog mit:
  - `Ab naechstem Zielblock`;
  - `Sofort anwenden`.

Bewusste Grenze:

- 14c baut keine allgemeine Queue fuer beliebige zukuenftige Aufgabenprofile.
- Nur reine Zielaenderungen werden als zukuenftige Zielversion vorgemerkt.
- Wenn Ziel und andere Aufgabenregeln gleichzeitig geaendert werden, wird die
  Aufgabe wie bisher sofort gespeichert.

Pruefung:

- `dart format` lief fuer die betroffenen Dateien erfolgreich.
- Gezielte Analyse der betroffenen Dateien ist gruen: `No issues found`.
- Externe PowerShell-Pruefung ist gruen:
  - gezielte Analyse: `No issues found`
  - Zielaenderungs-Tests `Zielaenderung`: `+4 All tests passed`

Empfohlener externer PowerShell-Test:

```powershell
cd "C:\Users\maxkr\Documents\Flutter Apps\Upgear\momentum"
flutter test --no-pub test\features\aufgaben\data\aufgaben_repository_test.dart --plain-name "Zielaenderung"
```

Naechster Schritt:

- 14d: Wertziele fuer Zahl, Dauer und Buendel.

## 15. September 2026 - Phase 14d.1 umgesetzt: Wertziele fuer einzelne Werte

Der erste 14d-Schnitt setzt Wertziele fuer einzelne Zahl- und Dauer-Aufgaben um.

Umgesetzt:

- neue Zieltypen:
  - `value_sum_min`
  - `value_average_min`
  - `value_average_max`
- Wertziele sind bei wiederkehrenden Zahl- und Dauer-Aufgaben auswählbar.
- Uhrzeit bleibt Tracking-only und bekommt keine Wertzielauswahl.
- `goalValue` wird fuer diesen Release-Schnitt als Zielwert genutzt:
  - Zahlen direkt;
  - Dauer als Minuten in der UI, intern als Sekunden.
- `goalWindowDays` gilt auch fuer Wertziele.
- Die Wert-Detailansicht zeigt einen Zielbereich mit Status, Ergebnis,
  Zielzeitraum und Datenbasis.
- Fehlende, offene, verpasste oder neutrale Eintraege werden nie als `0`
  gewertet.
- Ist das Wertziel rechnerisch erreicht, aber die Datenbasis unvollstaendig,
  zeigt die Bewertung einen Warnstatus statt sauberem Gruen.

Bewusst offen:

- Buendel-Wertziele sind noch nicht sauber abschliessbar, weil Buendel-Versionen
  derzeit keine eigenen Zielfelder haben. Ein Buendel-Ziel an eine Teilaufgabe
  zu haengen waere fachlich falsch.
- Naechster 14d-Schnitt muss deshalb entweder Zielfelder an
  `task_value_bundle_versions` ergaenzen oder ein eigenes kleines
  Buendel-Zielmodell einfuehren.

Pruefung:

- `dart format` lief erfolgreich.
- Gezielte Analyse der betroffenen Dateien: `No issues found`.
- Gezielte Flutter-Tests hingen in der Codex-Umgebung ohne Ausgabe und muessen
  extern per PowerShell bestaetigt werden.

## 15. September 2026 - Phase 14d.2 abgeschlossen: Buendel-Wertziele

Der Anschluss-Schnitt fuer Buendel-Wertziele wurde umgesetzt und extern
geprueft.

Umgesetzt:

- Buendel-Versionen bekommen eigene Zielfelder:
  - `goalType`
  - `goalValue`
  - `goalWindowDays`
- Schema-Version wurde auf 17 angehoben.
- `createValueBundle` kann Buendel-Ziele speichern.
- Buendel-Ziele werden aus `TaskValueBundleAnalyticsSummary` bewertet.
- Buendel-Erstellung bietet reine Wertziel-Optionen an.
- Buendel-Detailansicht zeigt die Zielbewertung direkt am Buendel.
- Tests fuer Zahl-Buendel, Zeitintervall-Buendel und ungueltige
  Zeitintervall-Summenziele wurden ergaenzt.

Pruefung:

- Drift-Codegenerierung wurde extern erfolgreich ausgefuehrt:
  `Built with build_runner/aot in 8s; wrote 101 outputs.`
- Gezielte Analyse wurde extern bestaetigt: `No issues found`.
- Gezielte Buendel-Wertziel-Tests wurden extern bestaetigt:
  `+3 All tests passed`.

Empfohlene PowerShell-Tests:

```powershell
cd "C:\Users\maxkr\Documents\Flutter Apps\Upgear\momentum"
flutter test --no-pub test\features\aufgaben\data\aufgaben_repository_test.dart --plain-name "Wertziel"
```

## 15. September 2026 - Phase 14e abgeschlossen: UI-Vereinfachung

Phase 14e wurde als Release-Cleanup der Zielauswahl umgesetzt und extern
geprueft.

Umgesetzt:

- Die Zielauswahl zeigt kontextabhaengig nur passende Zieltypen.
- Statusaufgaben zeigen keine Wertziele.
- Buendel zeigen keine Statusziele.
- Zeitintervall-Buendel zeigen keine Summenziele.
- Kurze Kontext-Hinweise erklaeren die verfuegbaren Zielarten.
- Ungueltige Alt-/Randfall-Auswahlen fallen im Widget sicher auf `Kein Ziel`
  zurueck.
- Die Buendel-Erstellung wurde um einen doppelten Ziel-Hinweis bereinigt.
- Ein Widget-Test fuer die Zielauswahl wurde ergaenzt.

Pruefung:

- `dart format` lief erfolgreich.
- Gezielte Analyse wurde in der Codex-Umgebung bestaetigt: `No issues found`.
- Gezielte Analyse wurde extern bestaetigt: `No issues found`.
- Der gezielte Widget-Test wurde extern bestaetigt: `+3 All tests passed`.

Empfohlener externer PowerShell-Test:

```powershell
cd "C:\Users\maxkr\Documents\Flutter Apps\Upgear\momentum"
flutter test --no-pub test\features\aufgaben\presentation\widgets\task_goal_field_test.dart --plain-name "Zielauswahl"
```

```powershell
cd "C:\Users\maxkr\Documents\Flutter Apps\Upgear\momentum"
flutter test --no-pub test\features\aufgaben\data\task_configuration_validator_test.dart --plain-name "value goal"
```

## Bestandsaufnahme 11.1

Geprüft wurden Zieltypen, gespeicherte Zielfelder, Validierung,
Auswertungskennzahlen, Detailansicht und Tests.

### Vorhandene Zieltypen

In `lib/features/aufgaben/data/task_goal.dart` sind aktuell diese Zieltypen
definiert:

| Zieltyp | Bedeutung | Aktueller Stand |
|---|---|---|
| `none` | kein Ziel, nur Verlauf/Auswertung | vorhanden |
| `count_per_period` | X Erfolge pro Woche oder Monat | konfigurierbar, noch nicht bewertet |
| `percentage` | Prozentziel über fällige Einträge | konfigurierbar, noch nicht bewertet |
| `max_failures` | maximal erlaubte Fehlschläge im Zeitraum | konfigurierbar, noch nicht bewertet |
| `rolling_success_count` | X Erfolge in den letzten X Tagen | konfigurierbar, noch nicht bewertet |

Zusätzlich vorhanden:

| Feld | Werte | Bedeutung |
|---|---|---|
| `goalPeriod` | `week`, `month` | Zeitraum für periodische Ziele |
| `goalPeriodAlignment` | `calendar`, `from_start_date` | Ausrichtung am Kalender oder ab Startdatum |
| `goalWindowDays` | Zahl | Fenster für rollierende Ziele |

### Speicherung und Historisierung

Die Zielfelder sind in der aktiven Aufgabe gespeichert und zusätzlich Teil der
Definitionsversionen:

- `goalType`
- `goalValue`
- `goalWindowDays`
- `goalPeriod`
- `goalPeriodAlignment`

Damit sind Zieländerungen grundsätzlich historisierbar. Das ist wichtig, weil
später alte Instanzen nach der damals gültigen Zieldefinition bewertet werden
sollen.

### Erstellung, Bearbeitung und Validierung

Die Erstellungs- und Bearbeitungs-UI nutzen bereits `TaskGoalField`.

Vorhanden ist:

- Auswahl „Kein Ziel“
- „Anzahl pro Zeitraum“
- „Prozentziel“
- „Maximal X Fehlschläge“
- „X Erfolge in den letzten X Tagen“
- Eingabe für Zielwert
- Eingabe für rollierendes Fenster
- Auswahl Woche/Monat
- Auswahl Kalenderzeitraum oder ab Startdatum

Der Validator lässt Zieltypen nur bei wiederkehrenden Aufgaben zu. Einmalige
Aufgaben werden auf `none` normalisiert beziehungsweise dürfen kein Zeitraumziel
speichern. Das passt zur bisherigen fachlichen Entscheidung, dass einzelne
einmalige Aufgaben keine Habit-artige Zielauswertung bekommen.

### Vorhandene Auswertungsbasis

Die technische Grundauswertung besteht aus `TaskAnalyticsSummary`:

| Kennzahl/Feld | Bedeutung |
|---|---|
| `dueCount` | fällige/abgeschlossene Instanzen, die als Basis für die strenge Erfolgsquote dienen |
| `totalInstanceCount` | alle Instanzen im Zeitraum |
| `successCount` | Erfolge |
| `failureCount` | Misserfolge |
| `noEntryCount` | Kein-Eintrag-Fälle |
| `pendingCount` | offene Einträge |
| `answeredCount` | `success + failure` |
| `resolvedCount` | `success + failure + no_entry` |
| `strictSuccessRate` | `successCount / dueCount` |
| `valuedSuccessRate` | `successCount / answeredCount` |
| `completionRate` | `resolvedCount / totalInstanceCount` |

Diese Werte werden im Repository aus `taskEntries` berechnet und als Future und
Stream angeboten. Die Detailansicht aktualisiert dadurch live, wenn sich
Einträge ändern.

### Vorhandene Zeiträume

Für die erste Detailauswertung existieren:

- letzte 7 Tage
- letzte 20 Tage
- letzte 30 Tage
- seit Beginn

Diese Zeiträume reichen für die aktuelle Instanz-Auswertung, sind aber nicht
immer identisch mit Zielzeiträumen. Für Ziele brauchen wir zusätzlich:

- aktuelle Kalenderwoche
- aktueller Kalendermonat
- Zeitraum ab Startdatum
- rollierendes Fenster aus `goalWindowDays`

### Detailansicht

Die Detailansicht unterscheidet bereits:

- einzelne einmalige Aufgabe
- wiederkehrende Aufgabe/Habit

Einmalige Aufgaben zeigen konkrete Aufgabendetails statt Habit-Quoten.
Wiederkehrende Aufgaben zeigen aktuell:

- Erfolgsquote
- Fortschritt
- Erfolge
- Misserfolge
- Kein Eintrag
- Offen
- Wertende Erfolgsquote
- Info-Buttons mit kurzen Erklärungen

Noch nicht vorhanden:

- eigene Zielkarte
- Zielstatus wie `Erreicht`, `Nicht erreicht`, `Auf Kurs`
- Ziel-Fortschritt wie `2 von 3`
- Hinweis, wenn Ziel und Rhythmus absichtlich unterschiedlich sind

### Tests

Vorhandene Tests decken ab:

- Speichern von Ziel-Feldern
- Normalisierung/Validierung von Ziel-Feldern
- Grundauswertung
- Anzeigeformatierung für Auswertungskennzahlen

Noch nicht vorhanden:

- Tests für Zielbewertung je Zieltyp
- Tests für laufende Zielzeiträume
- Tests für Zieländerungen/Definitionsversionen
- Tests für Aufgaben mit Ziel, deren Rhythmus häufiger ist als das Ziel

### Fazit der Bestandsaufnahme

Phase 11 kann ohne Schema-Erweiterung für Statusziele starten.

Die wichtigste Architekturentscheidung ist, Zielbewertung nicht direkt in die
bestehende Roh-Auswertung zu vermischen. Sinnvoll ist ein eigenes kleines
Zielbewertungsmodell, das aus Aufgabe, Zieldefinition und vorhandenen
Analytics-/Entry-Daten eine Zielaussage ableitet.

Vorschlag für die technische Richtung:

- `TaskAnalyticsSummary` bleibt Rohdaten-/Instanz-Auswertung.
- Ein neues Zielbewertungsmodell beschreibt Ergebnis, Verhältnis und Info-Text.
- Die Zielbewertung nutzt dieselben Einträge und Zählwerte, aber eigene
  Zeiträume je Zielart.
- Die Detailansicht zeigt bei Aufgaben mit Ziel zuerst die Zielkarte und
  darunter die Rohdaten.
- Begriffe und Schnittstellen bleiben offen genug, damit Phase 12 später
  Wertziele für Zahl, Dauer und Uhrzeit ergänzen kann.

## Nächster Schritt

Fachliche Regeln für Schritt 11.2 und 11.3 klären:

1. Welche vorhandenen Zieltypen werden in der ersten Version wirklich bewertet?
2. Wie lautet die Rechenregel je Zieltyp?
3. Welche Zielstatus brauchen wir für laufende Zeiträume?
4. Wie beeinflussen `no_entry` und `pending` je Zieltyp die Aussage?
5. Wie wird die Zielkarte in der Detailansicht formuliert?

## Planungsentscheidung am 1. September 2026: Zielspanne statt Monatsziel

Die vorhandenen Zieltypen waren als grobes Brainstorming angelegt und gelten
nicht als final gesetzt. Für Phase 14 wurde deshalb die Zielmodellierung neu
ausgerichtet.

Bestätigt:

- Ziele werden für den Release in zwei Familien geplant:
  - Statusziele in Phase 14a.
  - Wertziele in der damaligen Vorplanung als Phase 14b; nach der
    Planbereinigung vom 15. September 2026 als Phase 14d.
- Wertziele dürfen nicht nur „später irgendwann“ vorbereitet werden, weil beide
  Zielfamilien vor dem ersten Release nutzbar sein sollen.
- Status- und Wertziele nutzen ein gemeinsames Prinzip: Eine Zieldefinition
  beschreibt eine feste Zielspanne in Tagen, z. B. 7, 14 oder 30 Tage.
- Status- und Wertziele setzen in der ersten Version verbindliche Verarbeitung
  voraus: Eine wiederkehrende Aufgabe mit aktivem Ziel darf nicht
  `MissedPolicy.none` verwenden. Ohne Missed Policy ist eine Aufgabe eher
  Tracking oder Beobachtung ohne Zielbewertung.
- Die Kombination Ziel + `MissedPolicy.none` ist ein Validierungsfehler:
  Speichern wird gesperrt. Die UI muss erklaeren, dass Ziele eine Regel fuer
  verpasste Eintraege brauchen.
- Bei Zielaufgaben bleibt automatische Missed-Konsequenz zu `no_entry` erlaubt
  und empfohlen, aber nicht verpflichtend. Wer keine harte automatische
  Niederlage moechte, kann alte offene Eintraege neutral abschliessen lassen.
  Wer strengere Zielhistorie will, kann `failure` als Konsequenz waehlen.
- Aktiviert der Nutzer ein Ziel bei bisheriger `MissedPolicy.none`,
  empfiehlt die UI direkte Konsequenz + `no_entry`. Diese Empfehlung ist kein
  stilles Auto-Setzen: Der Nutzer muss bestaetigen oder bewusst Puffer,
  Carryover oder eine strengere Konsequenz waehlen.
- Die Live-Anzeige darf rollierend auf genau dieselbe Zielspanne schauen.
  Beispiel: Ein Ziel „5 Erfolge in 7 Tagen“ zeigt live den Stand der letzten
  7 Tage. Ein separates Anzeige-Fenster wie „Ziel 7 Tage, Anzeige 10 Tage“ ist
  in der ersten Version ausgeschlossen.
- Die rollierende Live-Anzeige schaut ausschliesslich rueckwaerts:
  `heute - goalWindowDays + 1` bis `heute`. Sie betrachtet keine zukuenftigen
  Tage und ist keine Prognose fuer den Rest eines festen Zielblocks.
- Die Historie bewertet abgeschlossene feste Zielblöcke derselben Länge.
  Standardanker ist das Startdatum der Aufgabe.
- Historische Zielanalyse bewertet nur vollstaendig abgeschlossene Zielbloecke.
  Ein laufender Block kann weiterhin normale Roh-Auswertung zeigen, z. B.
  `3 Erfolge bisher`, bekommt aber noch keine historische Zielbewertung wie
  `erreicht` oder `nicht erreicht`.
- Die UI soll historische Abschnitte immer als Zielbloecke benennen, nicht als
  Wochen. Auch ein 7-Tage-Ziel mit Montag-Anker ist ein `7-Tage-Block`; der
  Anker erklaert nur, wo der Block beginnt.
- Zielbloecke brauchen fuer Nachvollziehbarkeit immer eine Datumsspanne.
  Beispiel: `02.09.2026 bis 08.09.2026`.
- Ein vollstaendig vergangener Zielblock mit `pending` sollte durch die
  Missed-Policy-Pflicht bei Zielaufgaben nicht regulaer entstehen. Er bleibt
  trotzdem als Schutzfall geplant: Der Block wird als unvollstaendig/offen
  markiert und aus der Zielerreichungsquote ausgeschlossen.
- Ein solcher Schutzfall soll in der UI oder Diagnose klar erkennbar sein.
  Spaeter kann daraus eine Meldung an den Entwickler beziehungsweise das Team
  entstehen, weil es auf alte Daten, Migrationen, Bugs oder Regelinkonsistenzen
  hinweisen kann.
- Für 7-Tage-Ziele soll zusätzlich ein Wochenanker ab Montag möglich sein.
  Wer lieber in Kalenderwochen denkt, kann damit Mo-So-Blöcke auswerten.
- Eine angefangene erste Woche vor dem ersten vollen Montag-Sonntag-Block wird
  in der ersten Version nicht anteilig in die Zielerreichungsquote aufgenommen.
  Anteiliges Werten bleibt bewusst später, weil Rundung und Skalierung sofort
  neue Fachfragen erzeugen.
- 30 Tage bedeutet im Zielmodell wirklich 30 Tage, nicht „Monat“.
- Statusziele werden fuer die erste Version auf einen positiven Grundtyp
  reduziert: mindestens Erfolg in X Tagen.
- Anzahl und Prozent sind dabei keine zwei getrennten fachlichen Zieltypen,
  sondern zwei Eingabe- und Anzeigeformen desselben positiven Zielprinzips.
  Die Zielbewertung arbeitet intern mit einer ganzen Erfolgsanzahl.
- Freie Prozent-Eingaben sind erlaubt, muessen aber sichtbar auf ganze Erfolge
  aufgerundet werden. Beispiel: `mindestens 80 %` bei einer 7-Tage-Zielspanne
  ergibt `ceil(0,8 * 7) = 6` benoetigte Erfolge. Die UI muss anzeigen, dass das
  technisch `6 von 7` beziehungsweise tatsaechlich `86 %` bedeutet.
- Bei laengeren Zielspannen werden Prozentziele feiner, weil die ganzen
  Erfolgsstufen kleiner werden.
- `max_failures` beziehungsweise Ziele nach dem Muster „hoechstens X
  Misserfolge“ werden fuer die erste Version gestrichen. Misserfolge bleiben
  in der Auswertung sichtbar, aber das Ziel selbst soll positiv formuliert
  bleiben.
- Einfache Nicht-Unterbrechen-Ziele koennen im Release ueber Anzahlziele wie
  `7 von 7` abgebildet werden. Typische Streak-Auswertungen wie aktuelle Serie,
  laengste Serie und Unterbrechungslogik bleiben spaeter, weil sie eigene
  Regeln fuer `no_entry`, Puffer, Carryover, Nachtraege und Wert-Trackings
  brauchen.
- Regelmaessigkeit wie „mindestens alle 3 Tage“ soll fuer die erste Version
  vorzugsweise ueber den Wiederholungsrhythmus modelliert werden, nicht ueber
  einen eigenen Zieltyp.
- Mehrere Ziele pro Aufgabe bleiben ein spaeterer Ausbau. Beispiel: Eine
  Aufgabe kann spaeter gleichzeitig ein kurzfristiges Ziel `5 von 7` in den
  letzten 7 Tagen und ein laengeres Ziel von durchschnittlich mindestens 80 %
  in den letzten 30 Tagen anzeigen. Phase 14 v1 plant nur ein aktives Ziel pro
  Aufgabe.
- Die Detailansicht soll fuer v1 eine ruhige Zusammenfassung zeigen und eine
  einzelne Zielblockliste hinter Button oder aufklappbarem Bereich anbieten.
  Die Blockliste ist keine Jahres-/Kalenderansicht, sondern eine einfache
  Nachvollziehbarkeitsansicht.
- Jeder Zielblock in der Liste soll mindestens zeigen:
  - Datum von/bis.
  - Status `erreicht`, `nicht erreicht` oder `unvollstaendig/offen`.
  - Verhaeltnis, z. B. `5 von 7`.
  - Optional erklaerende Zaehler wie `Kein Eintrag`, `Misserfolge` und `Offen`.
- Unvollstaendige/offene Schutzfall-Bloecke sollen in der Blockliste sichtbar
  bleiben, obwohl sie nicht in die Zielerreichungsquote eingehen.
- Die Zusammenfassung soll kenntlich machen, wie viele Bloecke nicht in die
  Wertung eingeflossen sind und warum, z. B. `1 Block nicht gewertet, weil noch
  Eintraege offen sind`.
- Die UI soll erklaeren, dass offene Eintraege nachtraeglich beantwortet oder
  korrigiert werden koennen und sich die Zielbewertung danach neu berechnet.
- UI und gespeicherte Daten werden getrennt betrachtet. Die UI darf Anzahl und
  Prozent anbieten; die Bewertung selbst soll kanonisch auf `X Erfolge in Y
  Tagen` beruhen.
- Ein optionaler gespeicherter Eingabemodus wie `count` oder `percentage` ist
  nur UI-Komfort fuer spaeteres Bearbeiten. Er darf nicht zu einer zweiten
  fachlichen Wahrheit neben der benoetigten Erfolgsanzahl werden.
- Wenn die Zielspanne geaendert wird, soll die UI aus der bisherigen Strenge
  einen Vorschlag ableiten koennen, z. B. `5 von 7` entspricht etwa 71 % und
  wird bei 14 Tagen zu `10 von 14`. Diese Umrechnung ist eine Bearbeitungshilfe;
  gespeichert wird erst nach bestaetigter Konfigurationsaenderung.
- Die Vorschlagsformel bei Zielspannen-Aenderung lautet:
  `ceil(alte benoetigte Erfolge / alte Zielspanne * neue Zielspanne)`. Dadurch
  wird ein Ziel beim Wechsel der Zielspanne nicht stillschweigend leichter.
  Beispiele:
  - `5 von 7` zu 14 Tagen ergibt `10 von 14`.
  - `5 von 7` zu 30 Tagen ergibt `22 von 30`.
  - `6 von 7` zu 30 Tagen ergibt `26 von 30`.
- Erlaubte Zielspannen fuer Statusziele in der ersten Version:
  - Presets `1`, `7`, `14`, `30` Tage.
  - Eigene Anzahl von `1` bis `365` Tagen.
  - Standard `7` Tage.
- Zielbewertung muss schreibsparsam bleiben. Rollierende Live-Anzeige,
  historische Auswertung, Ansichtwechsel und erneutes Oeffnen der Detailansicht
  duerfen keine neuen Datensaetze, Cachewerte, Aggregates oder Cloud-relevanten
  Schreibvorgaenge erzeugen.
- `pending` und `no_entry` werden klar getrennt:
  - `pending` ist offen, kann noch nachtraeglich beantwortet werden und blockiert
    historische Zielbewertung eines abgeschlossenen Blocks.
  - `no_entry` ist abgeschlossen, neutral und blockiert historische
    Zielbewertung nicht. Es kann spaeter bewusst rueckwirkend korrigiert werden.
- Die rollierende Live-Anzeige nutzt eine Ampel statt schwerer Textstatus:
  - gruen, wenn im rueckwaertigen Fenster bereits genug Erfolge gespeichert
    sind.
  - gelb, wenn das Ziel noch nicht erreicht ist, aber durch offene Eintraege im
    rueckwaertigen Fenster noch erreicht werden kann.
  - rot, wenn das Ziel im rueckwaertigen Fenster nicht mehr erreichbar ist.
  - neutral/grau, wenn noch keine sinnvolle Datengrundlage existiert.
- Formel fuer Statusziele:
  - gruen: `successCount >= requiredSuccesses`
  - gelb: `successCount < requiredSuccesses` und
    `successCount + pendingCount >= requiredSuccesses`
  - rot: `successCount + pendingCount < requiredSuccesses`
- Statuswirkung in der Live-Ampel:
  - `success` zaehlt als Erfolg.
  - `pending` zaehlt als offene Chance im rueckwaertigen Fenster.
  - `failure` ist ein abgeschlossener Nicht-Erfolg.
  - `no_entry` ist ebenfalls ein abgeschlossener Nicht-Erfolg fuer die
    Zielerreichbarkeit, wird in der UI aber neutral und separat erklaert.
  - `recorded` gehoert nicht zu Statuszielen und wird bei Wertzielen separat
    behandelt.
- Statusziele betrachten fuer die rollierende Live-Anzeige nur existierende
  Entries im rueckwaertigen Fenster. Nicht erzeugte Zukunftstage werden nie
  eingeplant. Virtuelle Luecken bei reinen Trackings gehoeren zu Wertzielen und
  Wert-Auswertung, nicht zur Statusziel-Ampel.
- Beispiele fuer Ziel `5 von 7`:
  - `5 Erfolge` ergibt gruen.
  - `4 Erfolge + 1 offen` ergibt gelb.
  - `2 Erfolge + 1 offen` ergibt rot, weil das Ziel heute im betrachteten
    7-Tage-Fenster nicht mehr erreichbar ist.

Begründung:

- Rollierende Live-Anzeigen sind handlungsleitend: Sie zeigen sofort, ob der
  aktuelle Spielraum noch reicht oder ob der Nutzer den Rest der Zielspanne
  konsequenter handeln muss.
- Feste historische Blöcke bleiben besser vergleichbar und leichter als
  Zielerreichungsquote zusammenzufassen.
- Die Trennung vermeidet halbe Zielurteile: Eine laufende Woche ist auswertbar,
  aber noch nicht endgueltig als Ziel erreicht oder verfehlt bewertet.
- Monatsauswertungen und spätere Jahres-/Kalender-Blockansichten bleiben
  trotzdem möglich, weil die Rohdaten pro `scheduledDate` dokumentiert und
  auswertbar sind. Sie gehören aber zur Auswertung, nicht zum Zielmodell.
- Eine verpflichtende Missed Policy fuer Statusziele verhindert dauerhaft
  offene historische Zielbloecke. Gleichzeitig bleibt `no_entry` als weiche
  automatische Konsequenz menschlich genug fuer Situationen, in denen ein
  verpasster Eintrag nicht sofort als aktiver Misserfolg beschriftet werden
  soll.

Beispiel:

- Ziel: 5 Erfolge in 7 Tagen.
- Woche 1: Montag bis Freitag erfolgreich, Samstag und Sonntag nicht.
- Live-Anzeige am folgenden Montag kann bereits „nicht im Rahmen“ zeigen, wenn
  durch den neuen Montag ein dritter Misserfolg im rollierenden 7-Tage-Fenster
  liegt.
- Historisch können Woche 1 und Woche 2 trotzdem jeweils als „5 von 7 erreicht“
  gelten, wenn die abgeschlossenen Wochenblöcke das Ziel erfüllen.

Nicht gemeint:

- Die Live-Anzeige soll nicht am Montagmorgen die kommenden Dienstag-Sonntag-
  Tage einplanen.
- Eine Anzeige wie „diese Kalenderwoche ist noch erreichbar“ ist eine spaetere
  Prognose-/Blockperspektive und nicht Teil von Phase 14 v1.

Konsequenz für die Umsetzung:

- `rolling_success_count` sollte nicht als eigener konkurrierender Zieltyp neben
  periodischen Zielen verstanden werden. Rollierend ist zuerst eine
  Live-Anzeigeperspektive auf die Zielspanne.
- Das bestehende Datenmodell muss in Phase 14 geprüft werden: `goalWindowDays`
  passt zur neuen Fachlichkeit, während `goalPeriod` und
  `goalPeriodAlignment` möglicherweise Legacy-/UI-Anker oder Migrationsfelder
  werden.
- `TaskConfigurationValidator` und `TaskGoalField` muessen an die neue Regel
  angepasst werden: Sobald ein Statusziel aktiv ist, muss eine zulaessige
  Missed Policy gewaehlt sein. `MissedPolicy.none` darf dann nicht speicherbar
  bleiben.
- Die bestehenden technischen Konstanten `count_per_period`, `percentage`,
  `max_failures` und `rolling_success_count` duerfen beim Umsetzen nicht
  unkritisch als finale Fachtypen uebernommen werden. Der Umsetzungs-Chat soll
  pruefen, ob neue Namen, eine Normalisierungsschicht oder eine kleine Migration
  die neue Fachlichkeit sauberer abbilden.
- Keine Ziel-Cache-Tabelle, gespeicherten Zielperioden, Materialized Views oder
  gespeicherten Live-Fortschritte einfuehren, solange kein echtes Rohdatenloch
  gefunden wird. Berechnete Zielaussagen entstehen aus `TaskEntry`,
  `TaskEntryValue`, Aufgabe und Definitionsversionen.
- Die genaue technische Migration oder Normalisierung wird erst geplant, wenn
  die Zielarten und Wertziel-Regeln vollständig geklärt sind.
- Spaeter in dieser Planungsrunde wurde diese offene Stelle geschlossen; siehe
  die Entscheidung `Datenmodell, Migration und Umsetzungsschnitt` weiter unten.

## Technischer Befund am 2. September 2026: Wirksamkeitsstart von Zielaenderungen

Gepruefte Dateien:

- `lib/features/aufgaben/data/task_definition_versions_table.dart`
- `lib/features/aufgaben/data/task_definition_version_writer.dart`
- `lib/features/aufgaben/data/aufgaben_repository.dart`
- `lib/features/aufgaben/presentation/task_edit_screen.dart`

Aktueller Stand:

- `TaskDefinitionVersions` besitzt bereits `validFrom`.
- `TaskDefinitionVersionWriter.createVersion(Aufgabe task, {DateTime?
  validFrom})` kann technisch eine Version mit frei gesetztem `validFrom`
  anlegen.
- Beim Erstellen einer Aufgabe wird `validFrom` bereits auf das Startdatum der
  Aufgabe gesetzt.
- Bei normaler Bearbeitung ruft `AufgabenRepository.updateTask(...)`
  `createVersionIfChanged(previousTask, updatedTask)` auf.
- `createVersionIfChanged(...)` reicht aktuell kein `validFrom` weiter. Dadurch
  bekommt eine durch Bearbeitung erzeugte neue Definitionsversion derzeit
  standardmaessig `DateTime.now()`.
- `TaskEditScreen` hat aktuell kein separates Feld fuer „Zielaenderung gilt
  ab“. Es bearbeitet die aktive Aufgabe direkt.

Bewertung:

- Das Fundament fuer Wirksamkeitsstarts existiert bereits.
- Fuer die Phase-14-Regel „Zielaenderung ab naechstem Zielblockstart anwenden“
  reicht der aktuelle Standardpfad aber noch nicht aus.
- Der Umsetzungs-Chat muss eine gezielte Erweiterung planen, z. B.:
  - `updateTask` optional um einen `definitionValidFrom`-/`changeValidFrom`-
    Parameter erweitern,
  - `createVersionIfChanged` optional mit `validFrom` aufrufen,
  - die Bearbeitungs-UI bei Zielaenderungen mitten im Zielblock den naechsten
    Blockstart vorschlagen lassen.

Wichtige Kante:

- Die aktive `aufgaben`-Zeile speichert immer den aktuellen sichtbaren
  Aufgabenstand. Wenn dort eine Zielaenderung sofort geschrieben wird, kann die
  Detailansicht die neue Zielregel schon vor ihrem geplanten `validFrom`
  anzeigen, obwohl historische Entries noch ueber die alte Definitionsversion
  laufen.
- Phase 14 soll deshalb Variante A umsetzen: zukuenftig geplante reine
  Zielaenderungen werden in `task_definition_versions` mit zukuenftigem
  `validFrom` vorgemerkt, waehrend die aktive `aufgaben`-Zeile bis zum
  Wirksamkeitsdatum die aktuell gueltige Zieldefinition behaelt.

Empfehlung fuer Phase 14 v1:

- Keine komplexe Queue fuer zukuenftige Aufgabenprofile einfuehren, solange sie
  nicht zwingend gebraucht wird.
- Bei Zielaenderungen mitten im Zielblock soll die UI vorschlagen, die Aenderung
  ab dem naechsten Zielblockstart gelten zu lassen.
- Der Umsetzungs-Chat soll dafuer eine kleine Repository-/Writer-Erweiterung
  bauen, die eine reine zukuenftige Zielversion anlegt, ohne die aktive Aufgabe
  sofort auf diese Zielwerte umzuschreiben.
- Nur wenn diese Variante beim Implementieren unerwartet blockiert, darf als
  Fallback die aktive `aufgaben`-Zeile sofort die neueste Zieldefinition
  erhalten. Dann muessen aber alle zielbezogenen Anzeigen strikt die zum Datum
  gueltige Definitionsversion laden und es braucht Tests gegen zu fruehe
  Anzeigewechsel.

Ergaenzte Entscheidung:

- Der Punkt soll in Phase 14 direkt geklaert und nicht auf spaeter verschoben
  werden, weil Phase 15 Kartenkennzahlen und Phase 16 Praxischeck der
  Historisierung sonst auf einer unsauberen Ziel-Zeitlogik aufbauen wuerden.
- Aufwandseinschaetzung: mittelgross, aber nicht grundlegend riskant. Das
  bestehende Schema und die Entry-Versionierung passen bereits gut. Der Aufwand
  liegt vor allem in Repository-API, Bearbeitungs-UI, zielbezogener
  Versionsauswahl und Tests.
- Es muss nicht die gesamte Scheduler- oder Aufgabenlogik neu gedacht werden,
  solange die Funktion in v1 auf reine Zielaenderungen beschraenkt bleibt.
- Nicht-Ziel-Aenderungen wie Rhythmus, Startdatum, Erfassungsmodus oder Missed
  Policy sollen nicht heimlich in eine zukuenftige Teilversion geschrieben
  werden. Wenn solche Felder zusammen mit einer Zielaenderung geaendert werden,
  soll die UI fuer v1 entweder sofortige Anwendung verlangen oder die
  Zielaenderung getrennt speichern lassen.

Praezisierte Zielentscheidung:

- Variante A ist der Standard fuer Phase 14 v1: Die aktive `aufgaben`-Zeile
  bleibt bis zum
  Wirksamkeitsdatum auf der aktuell gueltigen Zieldefinition; eine zukuenftige
  reine Zielaenderung wird als Definitionsversion mit zukuenftigem `validFrom`
  vorgemerkt.
- Variante B ist nur ein Fallback bei unerwarteter technischer Blockade:
  aktive `aufgaben`-Zeile enthaelt die neueste konfigurierte Zieldefinition,
  aber Zielanzeige und Zielbewertung muessen konsequent die fuer `today` oder
  den jeweiligen Blockstart gueltige Definitionsversion laden.
- Auch im Fallback duerfen Zielanzeige und Zielbewertung nicht die aktive
  `aufgaben`-Zeile als alleinige Quelle fuer historische oder datumsbezogene
  Zielregeln verwenden.

Umsetzungs-Checkliste fuer den spaeteren Chat:

1. Aktuelle Versionierungslogik erneut lesen:
   `task_definition_version_writer.dart`,
   `task_definition_versions_table.dart`, `aufgaben_repository.dart`,
   `task_edit_screen.dart`.
2. Kleine API-Erweiterung planen:
   - optionaler `validFrom` fuer `createVersionIfChanged(...)`;
   - optionaler Wirksamkeitsstart fuer reine Zielaenderungen in
     `AufgabenRepository.updateTask(...)` oder einer spezialisierten
     Zielaenderungs-Methode.
3. Helfer bauen, der reine Zielaenderungen erkennt. Ziel-relevant sind in Phase
   14 v1 mindestens Zieltyp, benoetigte Erfolge, Zielspanne, Zielanker und
   spaeter Wertziel-Konfiguration.
4. Helfer bauen, der den aktuellen Zielblock und den naechsten Blockstart aus
   Zielspanne, Startdatum und Anker berechnet.
5. Bearbeitungs-UI erweitern:
   - bei Zielaenderung mitten im Block Hinweis anzeigen;
   - Standard `ab naechstem Zielblock`;
   - Alternative `sofort anwenden`;
   - Auswirkung kurz erklaeren.
6. Zielbewertung so bauen, dass sie die gueltige Definitionsversion laedt:
   - Live-Ampel: gueltige Zieldefinition fuer `today`;
   - historische Bloecke: gueltige Zieldefinition am Blockstart.
7. Hinweis fuer geplante Zielaenderung anzeigen, wenn eine zukuenftige
   Zielversion existiert.
8. Keine Ziel-Cache-Tabelle und keine schreibenden Bewertungslaeufe einfuehren.

Empfohlene Tests:

- `createVersionIfChanged` kann ein explizites `validFrom` speichern.
- Eine reine Zielaenderung ab naechstem Blockstart erzeugt eine Version mit
  genau diesem Datum.
- Entries vor dem Wirksamkeitsdatum verwenden die alte Version.
- Entries ab dem Wirksamkeitsdatum verwenden die neue Version.
- Zielhistorie bewertet Bloecke vor/nach `validFrom` mit der jeweils passenden
  Zieldefinition.
- Live-Ampel wechselt erst am Wirksamkeitsdatum auf das neue Ziel.
- Sofortige Zielaenderung mitten im Block markiert den Mischblock als nicht
  gewertet.
- Kombination aus Ziel- und Nicht-Ziel-Aenderung wird nicht versehentlich als
  zukuenftige reine Zielversion behandelt.

## Planungsentscheidung am 2. September 2026: Wertziele als Release-Minimum

Wertziele sollen fuer den ersten Release nutzbar sein, aber nicht als grosse
zweite Auswertungsplattform wachsen. In der damaligen Vorplanung wurde Phase 14
deshalb in 14a Statusziele und 14b Wertziele geteilt. Nach der
Planbereinigung vom 15. September 2026 liegen Wertziele im aktuellen Ablauf in
14d; die fachlichen Entscheidungen aus diesem Abschnitt bleiben gueltig.

Erlaubte Wertzielarten fuer die aktuelle Phase 14d:

- mindestens Summe in X Tagen
- mindestens Durchschnitt in X Tagen
- hoechstens Durchschnitt in X Tagen

Nicht Teil der ersten Wertziel-Version:

- Zielkorridore
- Tagesgrenzwerte wie `an mindestens X Tagen ueber Wert Y`
- Uhrzeit-Ziele; Uhrzeit bleibt vorerst reines Tracking
- Trends, Ausreisser, Streaks oder Mehrfachziele
- mehrere Werte oder Sessions pro Tag

Erlaubte Wertquellen:

- einzelne Zahl-Aufgaben
- einzelne Dauer-Aufgaben
- einzelne Uhrzeit-Aufgaben nur als Tracking, nicht als Zielquelle
- Buendel-Zeitintervalle, z. B. Schlafdauer, fuer Durchschnitt
- Buendel-Summe und Buendel-Differenz fuer Summe und Durchschnitt, sofern die
  vorhandene Buendel-Auswertung den Wert berechenbar liefert
- reine Trackings, aber nur auf Basis echter erfasster Werte

Wenn der Nutzer bei einer Uhrzeit-Aufgabe Ziele auswaehlt, soll die UI klar
anzeigen, dass Uhrzeiten in dieser Version nur getrackt werden koennen und
Uhrzeit-Ziele spaeter folgen. Dauerwerte, die aus Zeitintervallen berechnet
werden, bleiben davon unberuehrt.

Harte Regel:

- Fehlende Tage, virtuelle Tracking-Luecken, `pending`, `failure` und
  `no_entry` duerfen niemals als `0` oder als anderer Ersatzwert in Wertziele
  einfliessen.
- Einzelne Wertziele verwenden nur echte `recorded` Werte mit berechenbarem
  `TaskEntryValue`.
- Buendel-Wertziele verwenden nur vollstaendige und berechenbare
  Buendelpunkte.
- Fehlende, offene, neutrale, verpasste oder nicht berechenbare Punkte werden
  separat gezaehlt und in der UI erklaert.

Konsequenz fuer die Anzeige:

- Wertzielaussagen muessen immer zeigen, auf wie vielen echten Werten sie
  beruhen, z. B. `Durchschnitt 7 h 20 min aus 5 Werten`.
- Ein Wertzielblock ist ab einem echten berechenbaren Wert bewertbar.
- Bei null echten berechenbaren Werten wird `keine Daten` angezeigt; der Block
  wird nicht als erreicht oder verfehlt bewertet.
- Fehlende Eintraege duerfen den Wert nicht als `0` senken, muessen aber klar
  und auffaellig markiert werden. Auch wenn das Ziel rechnerisch erreicht ist,
  soll die Anzeige sichtbar machen, dass die Datenbasis unvollstaendig ist,
  optional mit roetlicher Warnmarkierung.
- Die Ampel trennt Ergebnis und Datenqualitaet: gruen bedeutet `Ziel erreicht
  und Datenbasis vollstaendig`, gelb mit auffaelligem Warnhinweis bedeutet
  `Ziel rechnerisch erreicht, aber Datenbasis unvollstaendig`, rot bedeutet
  `Ziel rechnerisch verfehlt`, grau bedeutet `keine echten berechenbaren Werte`.

## Planungsentscheidung am 2. September 2026: Datenmodell, Migration und Umsetzungsschnitt

Der Code enthaelt noch die Brainstorming-Zieltypen `count_per_period`,
`percentage`, `max_failures` und `rolling_success_count`. Diese Typen sollen
nicht als Release-API weitergefuehrt werden.

Beschlossenes Zielmodell fuer die Umsetzung:

- `status_success_count` fuer Statusziele nach dem Muster `X Erfolge in Y Tagen`.
- `value_sum_min` fuer Wertziele nach dem Muster `mindestens Summe in X Tagen`.
- `value_average_min` fuer Wertziele nach dem Muster `mindestens Durchschnitt
  in X Tagen`.
- `value_average_max` fuer Wertziele nach dem Muster `hoechstens Durchschnitt
  in X Tagen`.

`percentage` bleibt kein eigener Zieltyp. Prozent ist nur eine Eingabe- und
Anzeigeform fuer Statusziele und wird vor dem Speichern in ganze erforderliche
Erfolge uebersetzt.

Empfohlene Schema-Erweiterung:

- `goalWindowDays` bleibt Pflichtfeld fuer aktive Ziele.
- `goalValue` bleibt bei Statuszielen die erforderliche Erfolgsanzahl.
- Wertziele brauchen ein eigenes `goalTargetValue` als normalisierten
  Zielwert, damit sie nicht in `goalValue` hineingezwungen werden.
- Fuer die spaetere Bearbeitung sind `goalTargetUnitKey`, `goalInputMode` und
  optional `goalInputPercent` sinnvoll. Diese Felder duerfen die fachliche
  Bewertung nicht veraendern.
- `goalPeriod` bleibt ein Alt-Feld und soll fuer neue Zielbewertung nicht mehr
  fachliche Wahrheit sein. `goalPeriodAlignment` kann fuer v1 als Block-Anker
  weiterverwendet werden.

Migration alter Zieltypen:

- `none` bleibt `none`.
- `count_per_period` wird deterministisch zu `status_success_count` migriert.
  `week` wird `7 Tage`; `month` wird `30 Tage`, nicht Kalendermonat.
- `percentage` wird zu `status_success_count` migriert und mit
  `ceil(percent / 100 * goalWindowDays)` in ganze Erfolge uebersetzt.
- `rolling_success_count` wird zu `status_success_count` migriert und
  uebernimmt `goalWindowDays`, falls vorhanden.
- `max_failures` wird nicht automatisch in ein positives Ziel umgedeutet,
  weil die korrekte Umrechnung vom Wiederholungsrhythmus und den faelligen
  Tagen abhaengt. Die Zielbewertung wird fuer diesen alten Typ deaktiviert,
  bis der Nutzer manuell ein neues positives Ziel waehlt.
- Die Aufgabe selbst bleibt nutzbar. Die UI soll klar anzeigen, dass der alte
  Zieltyp nicht mehr unterstuetzt wird. Der Schutzfall soll technisch sichtbar
  bleiben, z. B. ueber eine Warnung im Migrations-/Validatorpfad oder einen
  spaeteren Telemetrie-/Team-Hinweis.

Umsetzungsschnitt fuer den naechsten Chat:

- Zuerst Zielmodell, Migration, Validator und Create/Edit-Inputs.
- Danach Statusziel-Service und Statusziel-UI.
- Danach Wirksamkeitsstart von Zielaenderungen mit `validFrom`.
- Danach Wertzielmodell, Wertziel-Service und Wertziel-UI.
- Zum Abschluss fokussierte Tests, `dart format` und `flutter analyze`.
