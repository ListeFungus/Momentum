# Momentum – Phase 14: Zielbewertung

Stand: 15. September 2026  
Status: Phase 14a umgesetzt und extern geprueft

## Zweck dieses Dokuments

Dieses Dokument ist die kurze Arbeitskarte für Phase 14. Der ausführliche
Verlauf steht in [`goal_evaluation_history.md`](goal_evaluation_history.md).

Wichtig: Diese Phase wurde bewusst nach hinten verschoben, bis vollständige
Status-Auswertungen, erweiterte Erfassungsarten und Wert-Auswertungen
fertiggestellt sind. Dieser Punkt ist nach Abschluss von Phase 13 erreicht.
Ziele werden jetzt auf diese Auswertungen gelegt.

## Ziel von Phase 14

Phase 14 soll aus den vorhandenen Auswertungen eine klare Zielbewertung
ableiten.

Wichtig: Zielbewertung ist nicht dasselbe wie Instanz-Auswertung.

Beispiel:

- Aufgabe wird täglich angezeigt.
- Ziel ist aber nur: 2 Erfolge pro Woche.
- Die strenge Erfolgsquote kann niedrig wirken, obwohl das eigentliche Ziel
  erreicht ist.

Darum soll bei Aufgaben mit Ziel später die Zielerreichung die führende Aussage
sein. Die Instanz-Auswertung bleibt sichtbar, erklärt aber nur die Rohdaten.

## Fachliche Leitplanken

| Regel | Bedeutung |
|---|---|
| Ziele nutzen Grundauswertungen | Keine zweite, abweichende Rechenlogik aufbauen. |
| Zielbewertung bleibt dynamisch | Die Bewertung wird aus dem gewählten Zeitraum und den vorhandenen Instanzen berechnet. |
| Kein Eintrag ist niemals Erfolg | `no_entry` darf ein Ziel nicht künstlich verbessern. |
| Offene Einträge zählen nicht in Erfolgsquoten | `pending` wird separat als offen angezeigt. |
| Zieldefinition bleibt positiv | Release-Ziele beschreiben, was erreicht werden soll, nicht wie viele Fehler erlaubt sind. |
| Historische Definitionen beachten | Bei später geänderten Zielen muss die damals gültige Aufgaben-/Zieldefinition auswertbar bleiben. |
| Wertziele vorbereiten | Zahleneingaben kommen vor Firebase; Zielbewertung darf deshalb nicht so eng gebaut werden, dass später nur Ja/Nein-Ziele möglich sind. |
| Schreibsparsam bleiben | Zielanzeige, Zielbewertung und Historie werden aus Rohdaten berechnet und erzeugen keine gespeicherten Live-Stände oder Aggregate. |

## Bereits fachlich beschlossen

- Aufgaben und Ziele werden positiv formuliert.
- `Ja` ist Erfolg; `Nein` ist Misserfolg.
- Automatischer Erfolg ist ausgeschlossen.
- Ziele setzen eine verbindliche Verarbeitung voraus: Eine wiederkehrende
  Aufgabe mit Status- oder Wertziel darf in der ersten Version nicht
  `MissedPolicy.none` verwenden.
- Die Kombination aus aktivem Ziel und `MissedPolicy.none` ist ein
  Validierungsfehler und sperrt das Speichern. Die UI erklaert, dass Ziele eine
  Regel fuer verpasste Eintraege brauchen.
- Automatisches `no_entry` ist bei Zielaufgaben erlaubt und als weiche
  Konsequenz empfohlen, aber nicht verpflichtend. Es schliesst alte Eintraege
  neutral ab, damit Zielbloecke historisch auswertbar werden.
- Wenn ein Nutzer ein Ziel aktiviert und bisher `MissedPolicy.none`
  gewaehlt war, empfiehlt die UI als einfachen Vorschlag:
  direkte Konsequenz + `no_entry`. Diese Einstellung darf nicht stillschweigend
  gespeichert werden; der Nutzer muss sie bestaetigen oder eine andere
  zulaessige Missed Policy waehlen.
- Auswertung wurde vor Zielbewertung definiert.
- Instanz-Auswertung und Ziel-Auswertung werden getrennt.
- Bei Aufgaben mit Ziel soll Zielerreichung führend sein.
- Neutrale Einträge (`no_entry`) bleiben separat sichtbar.
- Offene Einträge (`pending`) werden nicht in Erfolgsquoten eingerechnet.
- Eine Gesamtauswertung darf mehrere Definitionsversionen verbinden, muss
  Zielzeiträume aber zuerst nach der damals gültigen Zieldefinition bewerten.
- Erweiterte Erfassungsarten wie Zahl, Dauer und Uhrzeit sollen vor Firebase
  kommen. Zielbewertung folgt erst danach und muss Statusziele sowie Wertziele
  sauber unterstützen können.
- Release-Ziele werden nicht mehr primär als Woche/Monat modelliert, sondern
  über eine feste Zielspanne in Tagen, z. B. 7, 14 oder 30 Tage.
- Statusziele haben in der ersten Version einen positiven Grundtyp:
  mindestens Erfolg in X Tagen. Die Erstellung und Ansicht dürfen zwischen
  Anzahl und Prozent wechseln. Intern soll die Zielbewertung aber mit einer
  ganzen Erfolgsanzahl arbeiten.
- Eine freie Prozent-Eingabe ist erlaubt, wird aber sichtbar auf ganze Erfolge
  aufgerundet. Beispiel: `mindestens 80 %` bei 7 Tagen entspricht technisch
  `6 von 7`, also tatsächlich `86 %`.
- Die Live-Anzeige eines Ziels darf rollierend dieselbe Zielspanne nutzen:
  ein 7-Tage-Ziel schaut also auf die letzten 7 Tage. In der ersten Version
  gibt es kein getrenntes Anzeige-Fenster wie „Ziel 7 Tage, Anzeige 10 Tage“.
- Die rollierende Live-Anzeige schaut nur rueckwaerts auf die letzten
  `goalWindowDays` inklusive heute. Sie plant keine zukuenftigen Tage und
  prognostiziert nicht, ob der Rest eines festen Blocks noch erreichbar ist.
- Statusziele zaehlen fuer die rollierende Live-Anzeige nur existierende
  Eintraege im rueckwaertigen Fenster. Nicht erzeugte Zukunftstage werden nie
  betrachtet. Virtuelle Tracking-Luecken gehoeren spaeter zu Wertzielen, nicht
  zur Statusziel-Ampel.
- Die rollierende Live-Anzeige nutzt eine einfache Ampel:
  - gruen: Ziel im rueckwaertigen Fenster bereits erreicht
  - gelb: Ziel im rueckwaertigen Fenster noch erreichbar, aber noch nicht
    erreicht
  - rot: Ziel im rueckwaertigen Fenster nicht mehr erreichbar
  - neutral/grau: noch keine sinnvolle Datengrundlage
- Historische Zielbewertung nutzt feste abgeschlossene Zielblöcke derselben
  Länge. Standardanker ist das Startdatum der Aufgabe.
- Historische Zielanalyse bewertet nur vollstaendig abgeschlossene Zielbloecke.
  Laufende Tage, Wochen oder andere Zielspannen koennen Roh-Auswertung anzeigen
  (z. B. wie oft etwas geschafft wurde), bekommen aber keine historische
  Zielbewertung.
- Ein vollstaendig vergangener Zielblock mit `pending` sollte bei Zielaufgaben
  wegen der Missed-Policy-Pflicht normalerweise nicht vorkommen. Falls doch,
  wird er als unvollstaendig/offen markiert und aus der Zielerreichungsquote
  ausgeschlossen. Spaeter kann daraus eine Diagnose- oder Teammeldung entstehen.
- Für 7-Tage-Ziele soll zusätzlich ein Wochenanker ab Montag möglich sein.
  Eine angefangene erste Woche vor dem ersten vollen Wochenblock wird in der
  ersten Version nicht anteilig in die Zielerreichungsquote eingerechnet.
- Monatsauswertungen, Monatsvergleiche und spätere Jahres-/Kalender-
  Blockansichten gehören zur Auswertung, nicht zum Zielmodell selbst. Ziele
  bleiben bei festen Tagesfenstern beziehungsweise 7-Tage-Wochenblöcken.
- Typische Streaks wie aktuelle Serie, längste Serie und Unterbrechungen bleiben
  ein späterer Auswertungs- oder Motivationsausbau. Ein einfacher
  Nicht-Unterbrechen-Fall kann im Release über ein Ziel wie `7 von 7` abgedeckt
  werden.
- Mehrere Ziele pro Aufgabe bleiben später: z. B. gleichzeitig `5 von 7` in den
  letzten 7 Tagen und durchschnittlich mindestens 80 % in den letzten 30 Tagen.
- Historische Abschnitte heissen in der UI immer Zielbloecke, z. B.
  `7-Tage-Block`, `14-Tage-Block` oder `30-Tage-Block`. Auch bei einem
  Montag-Anker soll nicht pauschal von „Wochen“ gesprochen werden.
- Zielbloecke muessen ihre Datumsspanne anzeigen koennen, z. B.
  `02.09.2026 bis 08.09.2026`.
- Die fachliche Wahrheit eines Statusziels ist `X Erfolge in Y Tagen`.
  Prozent-Eingabe ist UI-Komfort und wird in ganze benoetigte Erfolge
  umgerechnet. Ein optional gespeicherter Eingabemodus darf nur die Bearbeitungs-
  UI wiederherstellen, aber nicht die Bewertung veraendern.
- Wird die Zielspanne spaeter geaendert, soll die UI aus der bisherigen
  Zielstrenge einen sinnvollen neuen Vorschlag berechnen koennen, z. B. `5 von
  7` als rund 71 % und damit `10 von 14`. Gespeichert wird erst, wenn der Nutzer
  die Aenderung bestaetigt.
- Bei einer Zielspannen-Aenderung gilt als Vorschlagsformel:
  `ceil(alte benoetigte Erfolge / alte Zielspanne * neue Zielspanne)`. Dadurch
  wird das Ziel nicht unbemerkt leichter.
- Erlaubte Zielspannen fuer Statusziele in der ersten Version:
  - Presets: `1`, `7`, `14`, `30` Tage
  - eigene Anzahl: `1` bis `365` Tage
  - Standard: `7` Tage
- Reine Anzeigevorgaenge, rollierende Live-Bewertung, Historienberechnung und
  Wechsel zwischen Detailansichten duerfen keine Schreibvorgaenge ausloesen.
  Geschrieben werden nur echte Rohdaten- oder Konfigurationsaenderungen.
- `pending` blockiert historische Zielbewertung, weil der Eintrag noch
  nachtraeglich beantwortet werden kann. `no_entry` blockiert nicht: Es ist
  abgeschlossen, neutral sichtbar und kann spaeter bewusst korrigiert werden.

## Auswertungsgrundlage

Die vollständige Liste der möglichen Auswertungen liegt jetzt in
[`../phase_11_complete_analytics/complete_analytics_plan.md`](../phase_11_complete_analytics/complete_analytics_plan.md).

Phase 14 nutzt diese Auswertungen später als Grundlage. Hier werden nur noch die
Ziel-spezifischen Aussagen ergänzt, zum Beispiel Zielerreichung, Auf Kurs und
Zielerreichungsquote.

## Aktueller Stand

Phase 14 ist abgeschlossen. Die Umsetzung wurde bewusst kleiner geschnitten als
die alte Paketplanung weiter unten:

- **14a ist abgeschlossen:** rollierende Statusziel-Livebewertung.
- **14b ist abgeschlossen:** historische Zielbloecke fuer Statusziele.
- **14c ist abgeschlossen:** Zielaenderungen / Wirksamkeitsstart; extern
  geprueft.
- **14d ist abgeschlossen:** Wertziele fuer einzelne Zahl-/Dauer-Aufgaben und
  Buendel sind umgesetzt und extern geprueft.
- Danach folgt der UI-Abschluss.

Die alte Tabelle mit `14a.1`, `14a.2` usw. bleibt weiter unten als
**alte Umsetzungspaket-Planung / Vorplanung** erhalten. Sie ist kein zweiter
aktueller Ablaufplan mehr, sondern eine Detailquelle fuer Entscheidungen,
Akzeptanzkriterien und spaetere technische Arbeit.

## Aktueller Ablauf Phase 14

| Phase | Inhalt | Status | Warum dieser Schnitt? |
|---:|---|---|---|
| 14a | Rollierende Statusziel-Livebewertung | abgeschlossen und extern geprueft | Kleinstes stabiles Zielsystem: `X Erfolge in X Tagen`, direkt nutzbar in der Detailansicht. |
| 14b | Historische Zielbloecke fuer Statusziele | abgeschlossen und extern geprueft | Baut direkt auf 14a auf und macht sichtbar, welche abgeschlossenen Zielzeitraeume erreicht wurden. |
| 14c | Zielaenderungen / Wirksamkeitsstart | abgeschlossen und extern geprueft | Verhindert Mischbloecke, wenn Ziele mitten in einem Zielblock geaendert werden. |
| 14d | Wertziele fuer Zahl, Dauer und Buendel | abgeschlossen und extern geprueft | Nutzt die Phase-13-Wertauswertungen, ohne Status- und Wertziele zu vermischen. |
| 14e | UI-Vereinfachung, Begriffe, Abschluss und Tests | abgeschlossen und extern geprueft | Macht die Zielerstellung ruhig, verstaendlich und release-tauglich. |

## 14a - Erster umgesetzter Schnitt: rollierende Statuszielbewertung

Am 15. September 2026 wurde der erste bewusst kleine Umsetzungsschnitt fuer
Phase 14 gebaut.

Umgesetzt:

- eigenes Modell `TaskGoalEvaluationSummary`
- eigene Anzeigeaufbereitung `TaskGoalEvaluationDisplay`
- Repository-Methoden:
  - `getTaskGoalEvaluationSummary(...)`
  - `watchTaskGoalEvaluationSummary(...)`
- Detailansicht zeigt bei Aufgaben mit Ziel einen Abschnitt `Ziel`
- Validator verhindert bei wiederkehrenden Aufgaben die Kombination aus aktivem
  Ziel und `MissedPolicy.none`
- Zielkarten:
  - Zielstatus
  - Zielfortschritt
  - Zielzeitraum
  - noch offene Eintraege
  - Datenhinweis
- gezielte Repository-Tests fuer:
  - Ziel erreicht
  - Ziel auf Kurs
  - Ziel nicht mehr erreichbar
- gezielter Validator-Test fuer:
  - aktives Ziel + `MissedPolicy.none` wird gesperrt

Bewusste fachliche Begrenzung:

- Bewertet werden zuerst Statusziele auf Basis von Erfolgen.
- Der sauberste Release-Typ bleibt `X Erfolge in X Tagen`
  (`rolling_success_count`).
- Alte vorhandene Zieltypen `count_per_period` und `percentage` koennen
  kompatibel in eine benoetigte Erfolgsanzahl uebersetzt werden.
- `max_failures` wird nicht als positives Release-Ziel bewertet und erscheint
  als noch nicht unterstuetzt.
- Wertziele fuer Zahl, Dauer und Buendel folgen in einem eigenen naechsten
  Schritt, damit Statusziele und Wertziele nicht unuebersichtlich vermischt
  werden.

Aktuelle Prueflage:

- `dart format` lief fuer die betroffenen Dart-Dateien erfolgreich.
- Gezielte Analyse wurde extern bestaetigt: `No issues found`.
- Validator-Test wurde extern bestaetigt: `+1 All tests passed`.
- Zielbewertungs-Tests wurden extern bestaetigt:
  `rollierendes Statusziel` mit `+3 All tests passed`.
- Die Codex-Umgebung hing bei eigenen Testlaeufen ohne Ausgabe; die externe
  PowerShell-Pruefung gilt deshalb als massgeblicher Nachweis.

Empfohlener PowerShell-Test:

```powershell
cd "C:\Users\maxkr\Documents\Flutter Apps\Upgear\momentum"
flutter test --no-pub test\features\aufgaben\data\aufgaben_repository_test.dart --plain-name "rollierendes Statusziel"
```

```powershell
cd "C:\Users\maxkr\Documents\Flutter Apps\Upgear\momentum"
flutter test --no-pub test\features\aufgaben\data\task_configuration_validator_test.dart --plain-name "requires missed policy"
```

Empfohlene PowerShell-Analyse:

```powershell
cd "C:\Users\maxkr\Documents\Flutter Apps\Upgear\momentum"
flutter analyze lib\features\aufgaben\data\task_goal_evaluation_summary.dart lib\features\aufgaben\data\task_goal_evaluation_display.dart lib\features\aufgaben\data\aufgaben_repository.dart lib\features\aufgaben\data\task_configuration_validator.dart lib\features\aufgaben\presentation\task_detail_screen.dart test\features\aufgaben\data\aufgaben_repository_test.dart test\features\aufgaben\data\task_configuration_validator_test.dart
```

## 14b - Historische Zielbloecke fuer Statusziele

14b wurde am 15. September 2026 umgesetzt. Ziel war, abgeschlossene
Zielzeitraeume sichtbar zu machen, ohne neue Zieltypen oder Wertziele
einzufuehren.

Umgesetzt:

- eigenes Historienmodell `TaskGoalHistorySummary`
- einzelne Bloecke als `TaskGoalHistoryBlock`
- Repository-Methoden:
  - `getTaskGoalHistorySummary(...)`
  - `watchTaskGoalHistorySummary(...)`
- Detailansicht zeigt unter der Zielkarte einen aufklappbaren Bereich
  `Zielhistorie`
- Zielquote zaehlt nur bewertbare abgeschlossene Bloecke
- laufender Zielblock wird nicht in der Historie angezeigt
- abgeschlossene Bloecke mit offenen Eintraegen werden als `Nicht gewertet`
  gelistet und nicht in die Quote gerechnet
- fokussierte Repository-Tests fuer:
  - erreicht/nicht erreicht
  - laufenden Zielblock ausgeschlossen
  - offene historische Eintraege nicht gewertet

Fachliche Zielrichtung:

- Die Detailansicht zeigt zusaetzlich zur Live-Zielkarte eine Historie
  abgeschlossener Statuszielbloecke.
- Bewertet werden nur vollstaendig abgeschlossene Zielbloecke.
- Der laufende Zielblock bleibt in der Livebewertung und wird nicht als
  abgeschlossener Historienblock gezählt.
- Jeder Block zeigt Zeitraum, Ziel, erreichte Erfolge, offene/problematische
  Datenlage und Ergebnis.
- Unbewertbare Schutzfall-Bloecke werden sichtbar gelistet, aber nicht in die
  Zielquote gerechnet.
- Die Zielquote zaehlt nur bewertbare abgeschlossene Bloecke.

Geplante minimale UI:

- In der Zielkarte oder direkt darunter gibt es einen Button/Aufklapper fuer
  die Zielhistorie.
- Die Hauptansicht bleibt ruhig: Live-Status oben, historische Bloecke erst auf
  Wunsch sichtbar.
- Jeder historische Block braucht eine kurze, verstaendliche Aussage, z. B.
  `Erreicht - 5 von 7` oder `Nicht erreicht - 3 von 7`.
- Schutzfaelle bekommen einen Hinweis, z. B. `Nicht gewertet, weil noch offene
  Eintraege im alten Zeitraum existieren`.

Technische Zielrichtung:

- Die Berechnung soll auf der in 14a eingefuehrten Zielbewertungslogik
  aufbauen.
- Fuer Statusziele wird der Zielzeitraum aus `goalWindowDays` und dem
  Aufgaben-/Zielanker gebildet.
- Fuer v1 reichen feste, abgeschlossene Bloecke rueckwaerts ausgehend vom
  aktuellen Datum bzw. vom Aufgabenstart.
- Die Bewertung nutzt dieselben Tagesstatusdaten wie die Livebewertung.
- Es werden keine Zielbewertungen gespeichert; die Historie wird aus
  vorhandenen Eintraegen berechnet.

Akzeptanz fuer 14b:

- Abgeschlossene Zielbloecke werden korrekt in erreicht/nicht erreicht/nicht
  bewertbar eingeteilt: umgesetzt.
- Die Zielquote ignoriert nicht bewertbare Bloecke: umgesetzt.
- Der aktuelle laufende Block erscheint nicht als abgeschlossener
  Historienblock: umgesetzt.
- Die UI bietet einen einfachen Zugang zur Historie, ohne die Detailansicht zu
  ueberladen: umgesetzt.
- Fokussierte Tests decken erreicht, nicht erreicht, laufender Block
  ausgeschlossen und unbewertbarer Schutzfall ab: umgesetzt und extern
  bestaetigt.

Aktuelle Prueflage:

- `dart format` lief fuer die betroffenen Dart-Dateien erfolgreich.
- Gezielte Analyse der betroffenen Dateien ist gruen: `No issues found`.
- Externe PowerShell-Pruefung ist gruen:
  - gezielte Analyse: `No issues found`
  - Zielhistorien-Tests `historische Statusziel`: `+3 All tests passed`

Empfohlener PowerShell-Test:

```powershell
cd "C:\Users\maxkr\Documents\Flutter Apps\Upgear\momentum"
flutter test --no-pub test\features\aufgaben\data\aufgaben_repository_test.dart --plain-name "historische Statusziel"
```

Empfohlene PowerShell-Analyse:

```powershell
cd "C:\Users\maxkr\Documents\Flutter Apps\Upgear\momentum"
flutter analyze lib\features\aufgaben\data\task_goal_evaluation_summary.dart lib\features\aufgaben\data\task_goal_evaluation_display.dart lib\features\aufgaben\data\aufgaben_repository.dart lib\features\aufgaben\presentation\task_detail_screen.dart test\features\aufgaben\data\aufgaben_repository_test.dart
```

## 14c - Zielaenderungen und Wirksamkeitsstart

14c wurde am 15. September 2026 umgesetzt.

Umgesetzt:

- `TaskDefinitionVersionWriter.createVersionIfChanged(...)` kann jetzt ein
  optionales `validFrom` weiterreichen.
- Reine Zielaenderungen koennen als neue Zielversion fuer den naechsten
  Zielblock vorgemerkt werden, ohne die aktive `aufgaben`-Zeile sofort zu
  veraendern.
- `AufgabenRepository.scheduleTaskGoalChangeForNextBlock(...)` schreibt diese
  zukuenftige Zielversion.
- Live-Zielbewertung liest die fuer `today` gueltige Zieldefinition.
- Historische Zielbloecke lesen die am jeweiligen Blockstart gueltige
  Zieldefinition.
- Sofortige Zielaenderungen mitten in einem Zielblock markieren den betroffenen
  spaeteren Mischblock als `Nicht gewertet`.
- Die Detailansicht zeigt einen Hinweis, wenn eine zukuenftige Zielregel
  vorgemerkt ist.
- Der Bearbeitungsdialog bietet bei reiner Zielaenderung mitten im Block:
  - `Ab naechstem Zielblock` als sauberen Standard;
  - `Sofort anwenden` als bewusste Alternative.

Aktuelle Prueflage:

- `dart format` lief fuer die betroffenen Dart-Dateien erfolgreich.
- Gezielte Analyse der betroffenen Dateien ist gruen: `No issues found`.
- Externe PowerShell-Pruefung ist gruen:
  - gezielte Analyse: `No issues found`
  - Zielaenderungs-Tests `Zielaenderung`: `+4 All tests passed`

Empfohlener PowerShell-Test:

```powershell
cd "C:\Users\maxkr\Documents\Flutter Apps\Upgear\momentum"
flutter test --no-pub test\features\aufgaben\data\aufgaben_repository_test.dart --plain-name "Zielaenderung"
```

Empfohlene PowerShell-Analyse:

```powershell
cd "C:\Users\maxkr\Documents\Flutter Apps\Upgear\momentum"
flutter analyze lib\features\aufgaben\data\task_goal_evaluation_summary.dart lib\features\aufgaben\data\task_definition_version_writer.dart lib\features\aufgaben\data\aufgaben_repository.dart lib\features\aufgaben\presentation\task_detail_screen.dart lib\features\aufgaben\presentation\task_edit_screen.dart test\features\aufgaben\data\aufgaben_repository_test.dart
```

Zielaenderungen mitten in einem Zielblock duerfen nicht stillschweigend zu
Mischbloecken fuehren.

Beispiel:

- Zielblock: `01.09.2026 bis 07.09.2026`
- bisheriges Ziel: `5 von 7`
- Aenderung am `04.09.2026`
- sauberer Standardvorschlag: neue Zielregel ab `08.09.2026`

Beschlossene UI-Regel:

- Wenn eine Zielaenderung mitten in einem laufenden Zielblock passiert,
  empfiehlt die App: `Neue Zielregel ab naechstem Zielblock starten`.
- Alternative bleibt erlaubt: `Sofort anwenden`.
- Bei `Sofort anwenden` wird der betroffene Mischblock in der historischen
  Zielanalyse nicht gewertet und klar erklaert.
- Bei `Ab naechstem Zielblock` bleibt der laufende Block mit der bisherigen
  Zieldefinition bewertbar; die neue Zieldefinition gilt erst ab dem naechsten
  Blockstart.

Technische Zielrichtung fuer v1:

- Diese Regel wird zuerst nur fuer reine Zielaenderungen geplant:
  Zielwert, Zielspanne, Zielanker und spaeter Wertziel-Konfiguration.
- Werden gleichzeitig Rhythmus, Startdatum, Erfassungsmodus, Missed Policy oder
  andere Aufgabenregeln geaendert, soll die App fuer v1 keine komplexe
  zukuenftige Gesamtversion anbieten. Solche Aenderungen gelten sofort oder
  muessen separat bestaetigt werden.
- Das bestehende Schema passt grundsaetzlich, weil
  `TaskDefinitionVersions.validFrom` bereits existiert und Entries eine
  `taskDefinitionVersionId` speichern.
- `TaskDefinitionVersionWriter.createVersion(..., validFrom: ...)` kann bereits
  ein Wirksamkeitsdatum annehmen.
- Was fehlt:
  - `AufgabenRepository.updateTask(...)` braucht fuer Zielaenderungen einen
    optionalen Wirksamkeitsstart.
  - `TaskDefinitionVersionWriter.createVersionIfChanged(...)` muss optional
    `validFrom` weiterreichen koennen.
  - Die Zielbewertung darf fuer Live-Anzeige und Historie nicht blind die
    Zielwerte aus der aktiven `aufgaben`-Zeile verwenden, sondern muss die fuer
    das betrachtete Datum oder den Zielblock gueltige Definitionsversion nutzen.

Wichtige Abgrenzung:

- Keine allgemeine Queue fuer beliebige zukuenftige Aufgabenprofile bauen,
  solange sie nicht zwingend gebraucht wird.
- Keine gespeicherten Zielbewertungen, Zielperioden oder Fortschritts-Caches.
- Eine zukuenftige Zielversion ist Konfiguration und darf genau einmal beim
  Speichern der Zielaenderung geschrieben werden. Reine Anzeige und Bewertung
  bleiben lese- und rechenbasiert.

Empfohlene technische Umsetzung:

1. Einen Helfer einfuehren, der prueft, ob sich nur Ziel-relevante Felder
   geaendert haben.
2. Fuer reine Zielaenderungen mitten im Block den naechsten Blockstart
   berechnen und in der UI als Standard anbieten.
3. Bei Auswahl `ab naechstem Zielblock` eine neue Definitionsversion mit
   `validFrom = naechsterBlockstart` erzeugen.
4. Bestehende Entries vor diesem Datum behalten ihre alte
   `taskDefinitionVersionId`; neue oder spaeter erzeugte Entries ab diesem
   Datum bekommen ueber `versionIdForScheduledDate(...)` die neue Version.
5. Zielauswertung liest fuer jeden historischen Block die gueltige
   Definitionsversion am Blockstart.
6. Rollierende Live-Anzeige liest die aktuell gueltige Zieldefinition fuer
   `today`, nicht zwingend die neueste gespeicherte Version.
7. Falls eine zukuenftige Zielversion existiert, darf die Detailansicht einen
   kurzen Hinweis anzeigen, z. B. `Neue Zielregel gilt ab 08.09.2026`.

Technische Zielentscheidung:

- Die aktive `aufgaben`-Zeile speichert derzeit den zuletzt geschriebenen
  Aufgabenstand. Wenn sie bei einer zukuenftigen Zielaenderung sofort auf die
  neue Zieldefinition gesetzt wird, duerfen Zielanzeige und Zielbewertung
  trotzdem nicht zu frueh wechseln.
- Fuer v1 gilt Variante A als Zielentscheidung: Die aktive `aufgaben`-Zeile
  bleibt bis zum Wirksamkeitsdatum auf der aktuell gueltigen Zieldefinition.
  Die zukuenftige Zieldefinition wird nur in `task_definition_versions`
  vorgemerkt.
- Dafuer braucht der Umsetzungs-Chat eine Repository-/Writer-Methode fuer reine
  zukuenftige Zielaenderungen, die eine neue Definitionsversion mit
  `validFrom = naechsterBlockstart` schreibt, ohne die aktive `aufgaben`-Zeile
  sofort auf diese Zielwerte umzustellen.
- Falls Variante A beim Implementieren unerwartet technisch blockiert, ist
  Variante B nur ein dokumentierter Fallback: aktive `aufgaben`-Zeile bekommt
  die neueste konfigurierte Zieldefinition, aber alle zielbezogenen Anzeigen
  laden strikt die fuer das jeweilige Datum gueltige Version. Dieser Fallback
  braucht besonders sorgfaeltige Tests gegen zu fruehe Anzeigewechsel.

Empfohlene Tests fuer diesen Punkt:

- Bearbeitung ohne Zielaenderung erzeugt keine neue Zielversion.
- Sofortige reine Zielaenderung erzeugt eine neue Definitionsversion mit
  `validFrom` heute/jetzt und markiert den betroffenen Mischblock spaeter als
  nicht gewertet, falls die Aenderung mitten im Block liegt.
- Reine Zielaenderung `ab naechstem Zielblock` erzeugt eine neue
  Definitionsversion mit `validFrom = naechsterBlockstart`.
- Entries vor `validFrom` behalten oder erhalten die alte
  `taskDefinitionVersionId`.
- Entries ab `validFrom` erhalten ueber `versionIdForScheduledDate(...)` die
  neue `taskDefinitionVersionId`.
- Historische Zielbloecke vor `validFrom` werden mit alter Zieldefinition
  bewertet.
- Historische Zielbloecke ab `validFrom` werden mit neuer Zieldefinition
  bewertet.
- Rollierende Live-Anzeige vor dem Wirksamkeitsdatum nutzt die alte
  Zieldefinition.
- Rollierende Live-Anzeige ab dem Wirksamkeitsdatum nutzt die neue
  Zieldefinition.
- Detailansicht zeigt eine zukuenftig geplante Zielaenderung als Hinweis, ohne
  die aktuelle Zielampel zu frueh umzustellen.
- Gleichzeitige Aenderung von Ziel und Nicht-Ziel-Feldern wird fuer v1 nicht
  still als zukuenftige Teilversion gespeichert; die UI muss sie sofort
  anwenden oder zur getrennten Bearbeitung auffordern.

## 14d - Wertziele fuer Release-Minimum

Wertziele muessen vor dem Release nutzbar sein, werden aber in der ersten
Version bewusst klein gehalten.

### 14d.1 Einzelne Zahl- und Dauer-Aufgaben

Am 15. September 2026 wurde der erste technische Schnitt fuer Wertziele
umgesetzt.

Umgesetzt:

- neue Zieltypen:
  - `value_sum_min`
  - `value_average_min`
  - `value_average_max`
- Wertziele sind in der UI fuer wiederkehrende Zahl- und Dauer-Aufgaben
  auswaehlbar.
- Uhrzeit-Aufgaben bekommen keine Wertziel-Auswahl und bleiben Tracking-only.
- Der vorhandene `goalValue` wird in diesem Release-Schnitt als Zielwert
  verwendet:
  - Zahl: direkter Zahlenwert;
  - Dauer: Minuten in der Eingabe, intern Sekunden fuer die Berechnung.
- `goalWindowDays` gilt auch fuer Wertziele.
- Live-Wertzielbewertung nutzt echte Wertauswertungen:
  - Summe;
  - Durchschnitt mindestens;
  - Durchschnitt hoechstens.
- Fehlende/offene/verpasste Eintraege werden nicht als `0` gerechnet.
- Wenn das Ziel rechnerisch erreicht ist, aber Eintraege fehlen/offen sind,
  zeigt die Zielbewertung einen Warnstatus statt sauberem Gruen.
- Die Wert-Detailansicht zeigt bei aktiven Wertzielen einen Abschnitt `Ziel`.

Aktuelle Prueflage:

- `dart format` lief fuer die betroffenen Dart-Dateien erfolgreich.
- Gezielte Analyse der betroffenen Dateien ist gruen: `No issues found`.
- Die gezielten Testlaeufe hingen in der Codex-Umgebung ohne Ausgabe und wurden
  nach 60 Sekunden abgebrochen. Externe PowerShell-Pruefung steht noch aus.

Empfohlene PowerShell-Tests:

```powershell
cd "C:\Users\maxkr\Documents\Flutter Apps\Upgear\momentum"
flutter test --no-pub test\features\aufgaben\data\aufgaben_repository_test.dart --plain-name "Wertziel"
```

```powershell
cd "C:\Users\maxkr\Documents\Flutter Apps\Upgear\momentum"
flutter test --no-pub test\features\aufgaben\data\task_configuration_validator_test.dart --plain-name "value goal"
```

Empfohlene PowerShell-Analyse:

```powershell
cd "C:\Users\maxkr\Documents\Flutter Apps\Upgear\momentum"
flutter analyze lib\features\aufgaben\data\task_goal.dart lib\features\aufgaben\data\task_goal_evaluation_summary.dart lib\features\aufgaben\data\task_goal_evaluation_display.dart lib\features\aufgaben\data\aufgaben_repository.dart lib\features\aufgaben\data\task_configuration_validator.dart lib\features\aufgaben\presentation\widgets\task_goal_field.dart lib\features\aufgaben\presentation\aufgabe_hinzufuegen_screen.dart lib\features\aufgaben\presentation\task_edit_screen.dart lib\features\aufgaben\presentation\task_detail_screen.dart test\features\aufgaben\data\aufgaben_repository_test.dart test\features\aufgaben\data\task_configuration_validator_test.dart
```

### 14d.2 Buendel-Wertziele

Abgeschlossen und extern geprueft.

Ausgangsproblem:

- Aufgaben haben bereits Zielfelder (`goalType`, `goalValue`,
  `goalWindowDays`).
- Buendel-Versionen haben aktuell noch keine eigenen Zielfelder.
- Ein Buendel-Ziel an eine der beiden Teilaufgaben zu haengen waere fachlich
  falsch, weil das Ziel zum abgeleiteten Buendelwert gehoert.

Gewaehlter Schnitt:

- Buendel-Zielfelder werden an `task_value_bundle_versions` ergaenzt:
  `goalType`, `goalValue`, `goalWindowDays`.
- Dadurch ist das Ziel versioniert und gehoert fachlich zum abgeleiteten
  Buendelwert, nicht zu einer der beiden Teilaufgaben.
- Dieselbe Wertzielbewertung wird auf `TaskValueBundleAnalyticsSummary`
  angewendet:
  - Zeitintervall: Durchschnitt;
  - Summe/Differenz: Summe und Durchschnitt.
- Buendel-Wertziele werden in der Buendel-Erstellung konfigurierbar und in der
  Buendel-Detailansicht angezeigt.

Umgesetzt:

- Tabellenmodell und Migration auf Schema-Version 17 vorbereitet.
- `createValueBundle` nimmt Buendel-Zielfelder entgegen.
- Repository bewertet Buendel-Wertziele ueber vorhandene Buendel-Analytics.
- Buendel-Erstellung zeigt nur Wertziel-Optionen.
- Buendel-Detailansicht zeigt den Zielbereich direkt am Buendel.
- Tests fuer Buendel-Wertziele wurden vorbereitet.
- Drift-Codegenerierung wurde extern erfolgreich ausgefuehrt.
- Gezielte Analyse wurde extern erfolgreich ausgefuehrt.
- Gezielte Buendel-Wertziel-Tests wurden extern erfolgreich ausgefuehrt.

Erlaubte Wertzielarten in 14d:

- `mindestens Summe in X Tagen`
- `mindestens Durchschnitt in X Tagen`
- `hoechstens Durchschnitt in X Tagen`

Auch Wertziele setzen eine Missed Policy voraus. Eine Aufgabe ohne Missed Policy
bleibt eine reine Tracking-Aufgabe und darf in der ersten Version kein aktives
Ziel speichern.

Nicht Teil der ersten Wertziel-Version:

- Zielkorridore, z. B. zwischen 7 und 8 Stunden
- Tagesgrenzwerte nach dem Muster `an mindestens X Tagen ueber Wert Y`
- Uhrzeit-Ziele; Uhrzeit bleibt in der ersten Version reines Tracking
- Trends, Ausreisser, Streaks oder Mehrfachziele
- mehrere Werte/Sessions pro Tag

Erlaubte Wertquellen in 14d:

| Wertquelle | Release-Regel |
|---|---|
| einzelne Zahl-Aufgabe | Summe und Durchschnitt moeglich |
| einzelne Dauer-Aufgabe | Summe und Durchschnitt moeglich |
| einzelne Uhrzeit-Aufgabe | in 14d nur Tracking; keine Zielauswahl |
| Buendel-Zeitintervall | Durchschnitt moeglich, z. B. Schlafdauer |
| Buendel-Summe | Summe und Durchschnitt moeglich |
| Buendel-Differenz | Summe und Durchschnitt moeglich, sofern die vorhandene Buendel-Auswertung den Wert sinnvoll liefert |
| reines Tracking | moeglich, aber nur echte erfasste Werte zaehlen |

UI-Regel fuer Uhrzeit:

- Wenn eine Aufgabe den Werttyp `Uhrzeit` verwendet und der Nutzer Ziele
  auswaehlt, darf in 14d kein Uhrzeit-Ziel angeboten werden.
- Die UI zeigt stattdessen einen kurzen Hinweis, z. B. `Uhrzeiten koennen in
  dieser Version nur getrackt werden. Ziele fuer Uhrzeiten folgen spaeter.`
- Diese Einschraenkung gilt nur fuer echte Uhrzeit-Werte. Dauerwerte, z. B.
  Schlafdauer aus einem Buendel-Zeitintervall, duerfen weiterhin Wertziele
  verwenden.

Harte Regel fuer fehlende Werte:

- Fehlende Tage, virtuelle Tracking-Luecken, `pending`, `failure` und
  `no_entry` duerfen nie als `0` oder als anderer Ersatzwert in Wertziele
  eingehen.
- Wertziele bewerten nur echte berechenbare Werte:
  - einzelne Wert-Aufgaben: `recorded` mit berechenbarem `TaskEntryValue`
  - Buendel: vollstaendige und berechenbare Buendelpunkte
- Fehlende, offene, neutrale, verpasste oder nicht berechenbare Punkte werden
  separat gezaehlt und in der UI erklaert.
- Die Zielbewertung muss transparent anzeigen, auf wie vielen echten Werten sie
  beruht, z. B. `Durchschnitt 7 h 20 min aus 5 Werten`.

Live- und Historienlogik:

- Wertziele verwenden dieselbe Zielspanne in Tagen wie Statusziele.
- Die rollierende Live-Anzeige schaut rueckwaerts auf die letzten
  `goalWindowDays` inklusive heute.
- Historische Zielanalyse bewertet nur vollstaendig abgeschlossene Zielbloecke.
- Ein Wertzielblock ist ab einem echten berechenbaren Wert bewertbar.
- Ein Wertzielblock mit null echten berechenbaren Werten wird als `keine Daten`
  angezeigt und nicht als erreicht oder verfehlt bewertet.
- Fehlende Eintraege senken den berechneten Wert nicht, muessen aber klar
  markiert werden, z. B. als `fehlende Eintraege` oder `unvollstaendige
  Datenbasis`.
- Wenn ein Ziel rechnerisch erreicht ist, aber Eintraege im Zielblock fehlen,
  darf die UI nicht wie ein uneingeschraenktes Gruen wirken. Die Anzeige braucht
  einen klaren Warnhinweis, optional mit roetlicher/auffaelliger Markierung fuer
  die Datenluecke.
- Die Wertziel-Ampel trennt Zielergebnis und Datenqualitaet:
  - gruen: Ziel rechnerisch erreicht und keine relevanten fehlenden Eintraege
  - gelb mit auffaelligem Warnhinweis: Ziel rechnerisch erreicht, aber
    Datenbasis unvollstaendig
  - rot: Ziel rechnerisch verfehlt
  - grau: keine echten berechenbaren Werte vorhanden

## 14e - UI-Vereinfachung, Begriffe und Abschluss

Umgesetzt am 15. September 2026.

Ziel von 14e ist kein neuer Zieltyp, sondern ein ruhigerer und klarerer
Release-Zustand der vorhandenen Zielauswahl.

Umgesetzt:

- Die Zielauswahl zeigt nur noch fachlich passende Optionen:
  - Statusaufgaben zeigen Statusziele.
  - Zahl- und Dauer-Aufgaben zeigen Statusziele plus Wertziele.
  - Buendel zeigen nur Wertziele.
  - Zeitintervall-Buendel zeigen Durchschnittsziele, aber keine Summenziele.
- Irrefuehrende ausgegraute Zieltypen werden nicht mehr als normale
  Dropdown-Optionen angezeigt.
- Ein kurzer Kontext-Hinweis erklaert, warum bestimmte Zielarten verfuegbar
  oder nicht verfuegbar sind.
- Falls ein gespeicherter Zieltyp im aktuellen Kontext nicht mehr passend ist,
  faellt das Dropdown sicher auf `Kein Ziel` zurueck.
- Ein redundanter Hinweis in der Buendel-Erstellung wurde entfernt, weil das
  gemeinsame Ziel-Widget den Kontext jetzt selbst erklaert.
- Ein gezielter Widget-Test prueft die bereinigte Zielauswahl.

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

Empfohlene PowerShell-Analyse:

```powershell
cd "C:\Users\maxkr\Documents\Flutter Apps\Upgear\momentum"
flutter analyze lib\features\aufgaben\presentation\widgets\task_goal_field.dart lib\features\aufgaben\presentation\task_value_bundle_create_screen.dart test\features\aufgaben\presentation\widgets\task_goal_field_test.dart
```

## Detailplanung: Datenmodell und Migration

Der aktuelle Code enthaelt noch Brainstorming-Zieltypen:

- `count_per_period`
- `percentage`
- `max_failures`
- `rolling_success_count`

Diese Typen sollen nicht als Release-API weitergefuehrt werden. Fuer Phase 14
wird stattdessen ein kleines explizites Zielmodell eingefuehrt.

Empfohlenes Release-Zielmodell:

| Feld/Begriff | Bedeutung |
|---|---|
| `goalType` | fachlicher Zieltyp, z. B. `status_success_count`, `value_sum_min`, `value_average_min`, `value_average_max` |
| `goalWindowDays` | feste Zielspanne in Tagen; bei aktivem Ziel Pflicht |
| `goalValue` | bei Statuszielen: erforderliche Erfolge als ganze Zahl |
| `goalTargetValue` | bei Wertzielen: Zielwert in normalisierter Basiseinheit als `double` |
| `goalTargetUnitKey` | Anzeige-/Eingabeeinheit des Zielwerts, z. B. `km`, `h`, `min`; optional, aber fuer UI-Bearbeitung empfohlen |
| `goalInputMode` | optionaler UI-Komfort fuer Statusziele: `count` oder `percentage`; darf die Bewertung nicht beeinflussen |
| `goalInputPercent` | optional: vom Nutzer eingegebene Prozentzahl, damit `80 % von 7 Tagen` spaeter wieder als Eingabe sichtbar bleibt, obwohl fachlich `6 von 7` bewertet wird |
| `goalPeriod` | Alt-Feld; fuer neue Bewertung nicht mehr als fachliche Wahrheit verwenden |
| `goalPeriodAlignment` | kann fuer v1 als Zielblock-Anker weitergenutzt werden: `calendar` nur fuer 7-Tage-Montagsbloecke, sonst `from_start_date` |

Validierungsregeln:

- `TaskGoalType.none` bedeutet keine Zielkarte und keine Zielbewertung.
- Aktive Ziele sind nur fuer wiederkehrende Aufgaben erlaubt.
- Bei jedem aktiven Ziel ist `goalWindowDays` Pflicht und liegt zwischen `1`
  und `365`.
- Jedes aktive Ziel setzt eine Missed Policy voraus; `MissedPolicy.none` sperrt
  das Speichern.
- Statusziel:
  - `goalType = status_success_count`
  - `goalValue` liegt zwischen `1` und `goalWindowDays`.
  - Prozent-Eingabe wird vor dem Speichern auf ganze Erfolge aufgerundet:
    `ceil(percent / 100 * goalWindowDays)`.
- Wertziel:
  - `goalType` ist einer von `value_sum_min`, `value_average_min`,
    `value_average_max`.
  - `goalTargetValue` ist Pflicht.
  - Zahl- und Dauerwerte sind erlaubt; Uhrzeitwerte sind nicht erlaubt.
  - `goalValue` darf fuer Wertziele nicht ausgewertet werden.

Migration/Kompatibilitaet alter Zieltypen:

| Alter Typ | Behandlung |
|---|---|
| `none` | bleibt `none` |
| `count_per_period` | wenn moeglich zu `status_success_count` migrieren; `goalValue` bleibt erforderliche Erfolgsanzahl; `week` wird `goalWindowDays = 7`, `month` wird als `30 Tage` interpretiert, nicht als Kalendermonat |
| `percentage` | zu `status_success_count` migrieren; alte Prozentzahl wird mit `ceil(percent / 100 * goalWindowDays)` in Erfolge umgerechnet; `goalInputMode = percentage` und `goalInputPercent` nach Moeglichkeit beibehalten |
| `rolling_success_count` | zu `status_success_count` migrieren; `goalValue` bleibt erforderlich; `goalWindowDays` wird uebernommen oder auf `7` gesetzt |
| `max_failures` | nicht automatisch in ein positives Ziel umdeuten; als nicht mehr unterstuetztes Alt-Ziel behandeln und Zielbewertung deaktivieren, bis der Nutzer manuell ein neues positives Ziel waehlt |

Der Umsetzungs-Chat soll alte Werte nicht still loeschen, wenn eine
verlustfreie Migration nicht moeglich ist. Besonders `max_failures` braucht
einen sichtbaren Schutzpfad, weil eine scheinbar einfache Umrechnung in
`X Erfolge in Y Tagen` bei unterschiedlichen Wiederholungsrhythmen falsche
Historie erzeugen kann.

Endgueltige Regel fuer `max_failures`:

- Es gibt keine automatische Umrechnung in `status_success_count`.
- Die App darf ein altes `max_failures`-Ziel nicht als erreicht oder verfehlt
  bewerten.
- Die Aufgabe bleibt nutzbar, aber die Zielkarte zeigt einen klaren Hinweis,
  dass dieser alte Zieltyp nicht mehr unterstuetzt wird.
- Der Nutzer kann das Ziel manuell durch ein neues positives Statusziel
  ersetzen.
- Fuer Diagnose/Support soll der Schutzfall technisch erkennbar bleiben, z. B.
  ueber eine Warnung im Migrations-/Validatorpfad oder einen spaeteren
  Telemetrie-/Team-Hinweis.

## Alte Umsetzungspaket-Planung / Vorplanung

Dieser Abschnitt stammt aus der aelteren technischen Vorplanung. Er bleibt
absichtlich erhalten, damit Entscheidungen, Risiken und Akzeptanzkriterien nicht
verloren gehen.

Wichtig: Die hier genannten Paketnummern `14a.1`, `14a.2` usw. sind nicht mehr
die aktuelle Phasenstruktur. Die aktuelle Struktur steht oben unter
`Aktueller Ablauf Phase 14`.

Die Punkte koennen beim Umsetzen von 14b bis 14e als Detailquelle genutzt und
bei Bedarf in die neue Struktur ueberfuehrt werden.

| Paket | Inhalt | Ergebnis |
|---|---|---|
| 14a.1 Zielmodell und Migration | `TaskGoalType` auf Release-Typen umstellen, neue Wertziel-Felder in `aufgaben` und `task_definition_versions` ergaenzen, Drift-Migration und generierten Code aktualisieren | Datenmodell traegt Status- und Wertziele ohne alte Brainstorming-Typen |
| 14a.2 Validator und Normalisierung | `TaskConfigurationValidator`, Create/Edit-Inputs und Repository-Methoden anpassen | ungueltige Ziele koennen nicht gespeichert werden; Missed-Policy-Pflicht greift fuer alle Ziele |
| 14a.3 Statusziel-Service | Rechenlogik fuer rollierende Live-Anzeige und abgeschlossene Zielbloecke erstellen | Statusziele liefern gruen/gelb/rot/grau, Zaehler, Blockliste und Zielquote |
| 14a.4 Statusziel-UI | Zielauswahl fuer `X Erfolge in Y Tagen`, Prozent-Umschaltung, Zielkarte in Detailansicht und Blockliste hinter Button | Nutzer koennen Statusziele erstellen, sehen und nachvollziehen |
| 14a.5 Zielaenderungen | `validFrom` fuer reine Zielaenderungen unterstuetzen, Vorschlag `ab naechstem Zielblock` anzeigen, Sofort-Option mit Mischblock-Hinweis | Zielhistorie bleibt nachvollziehbar |
| 14b.1 Wertzielmodell im Validator/UI | Wertzieltypen fuer Zahl, Dauer und berechenbare Buendelwerte anbieten; Uhrzeit als Tracking-only mit Hinweis anzeigen | Nutzer koennen nur erlaubte Wertziele speichern |
| 14b.2 Wertziel-Service | vorhandene Wert-/Buendel-Analytics fuer Zielbewertung nutzen; fehlende Werte nie ersetzen | Wertziele liefern Ergebnis, Datenbasis und Warnstatus |
| 14b.3 Wertziel-UI | Wertzielkarte, Datenbasis-Hinweis, gelbe Warnung bei fehlenden Eintraegen, grauer Zustand bei `keine Daten` | Wertziele sind release-nutzbar und ehrlich erklaert |
| 14x.1 Tests und Abschluss | fokussierte Unit-/Widget-/Repository-Tests, `dart format`, `flutter analyze` | Umsetzung ist gegen die wichtigsten Regressionen abgesichert |

## Akzeptanzkriterien und Testliste

Akzeptanzkriterien Statusziele:

- Eine wiederkehrende Statusaufgabe kann `X Erfolge in Y Tagen` speichern.
- Prozent-Eingabe ist nur UI; gespeichert und bewertet werden ganze erforderliche
  Erfolge.
- `80 %` bei `7 Tagen` wird als `6 von 7` bewertet und in der UI als effektiv
  `86 %` erklaert.
- `MissedPolicy.none` sperrt das Speichern jedes aktiven Ziels.
- Rollierende Live-Anzeige betrachtet nur abgeschlossene/existierende Tage im
  rueckwaertigen Fenster inklusive heute, keine Zukunftstage.
- Status-Ampel:
  - gruen bei `successCount >= requiredSuccesses`
  - gelb bei noch erreichbarem Ziel durch offene Eintraege
  - rot, wenn das Ziel im betrachteten Fenster nicht mehr erreichbar ist
  - grau, wenn keine sinnvolle Datengrundlage existiert
- Historie bewertet nur vollstaendig abgeschlossene Zielbloecke.
- Unvollstaendige Schutzfall-Bloecke werden sichtbar gelistet, aber nicht in die
  Zielquote gerechnet.
- Zielaenderungen gelten standardmaessig ab naechstem Zielblockstart; bei
  Sofort-Option wird der betroffene Mischblock nicht bewertet und erklaert.

Akzeptanzkriterien Wertziele:

- Zahl- und Dauer-Aufgaben erlauben Mindest-Summe, Mindest-Durchschnitt und
  Hoechstens-Durchschnitt.
- Uhrzeit-Aufgaben bieten in 14d keine Zielauswahl und zeigen einen klaren
  Tracking-only-Hinweis.
- Buendel-Zeitintervalle erlauben Durchschnittsziele, wenn ein vollstaendig
  berechenbarer Dauerwert vorliegt.
- Buendel-Summe und Buendel-Differenz erlauben Summe und Durchschnitt, sofern
  die vorhandene Buendel-Auswertung einen berechenbaren Wert liefert.
- Fehlende Tage, virtuelle Tracking-Luecken, `pending`, `failure`, `no_entry`
  und nicht berechenbare Punkte gehen nie als `0` oder Ersatzwert in die
  Wertzielrechnung ein.
- Ein Wertzielblock mit null echten Werten ist grau/`keine Daten` und wird nicht
  als erreicht oder verfehlt bewertet.
- Ein Wertzielblock ab einem echten Wert wird rechnerisch bewertet.
- Ist das Wertziel rechnerisch erreicht, aber die Datenbasis unvollstaendig,
  zeigt die UI gelb mit auffaelligem Warnhinweis statt uneingeschraenktem Gruen.
- Jede Wertzielaussage nennt die Datenbasis, z. B. `aus 5 Werten`.

Empfohlene Tests:

- Validator: neue Zieltypen gueltig/ungueltig, `goalWindowDays` Grenzen,
  Statusziel `goalValue` Grenzen, Wertziel ohne `goalTargetValue`, Uhrzeit mit
  Wertziel, Ziel mit `MissedPolicy.none`.
- Prozent-Normalisierung: mehrere Fenster, z. B. `80 % von 7`, `70 % von 7`,
  `80 % von 30`.
- Migration: alte Typen `count_per_period`, `percentage`,
  `rolling_success_count` deterministisch migrieren; `max_failures` Schutzpfad
  pruefen.
- Statusziel-Live: gruen/gelb/rot/grau mit `success`, `pending`, `failure`,
  `no_entry`.
- Statusziel-Historie: abgeschlossene Bloecke, laufender Block, Schutzfall mit
  altem `pending`, Zielquote ohne unbewertbare Bloecke.
- Zielaenderung: ab naechstem Blockstart, Sofort-Option, Definitionsversionen
  vor/nach `validFrom`.
- Wertziel-Einzelwerte: Summe, Durchschnitt mindestens, Durchschnitt
  hoechstens, fehlende Eintraege nicht als `0`.
- Wertziel-Buendel: vollstaendige, teilweise fehlende und nicht berechenbare
  Buendelpunkte.
- Detailansicht: Zielkarte nur bei aktivem Ziel, Blockliste hinter Button,
  Datenbasis-/Warnhinweise sichtbar.

## Entschiedene Leitfragen

| Frage | Warum wichtig? | Entscheidung fuer Phase 14 |
|---|---|---|
| Welche Zielarten kommen zuerst? | Je Zieltyp entstehen eigene Rechenregeln. | Statusziele: ein positiver Zieltyp „mindestens Erfolg in X Tagen“ mit Anzahl-/Prozent-Darstellung. Wertziele folgen in 14d als Release-Minimum. |
| Wie wird „Ziel erreicht“ angezeigt? | Nutzer brauchen eine klare Hauptaussage. | Kurzer Status plus Verhältnis, z. B. `Erreicht – 2 von 2` oder `Noch nicht erreicht – 1 von 2`. |
| Gibt es „auf Kurs“? | Bei laufenden rollierenden Fenstern ist ein Ziel noch nicht immer endgültig verfehlt. | Statusziele nutzen gruen/gelb/rot/grau; Wertziele trennen Zielergebnis und Datenqualitaet. |
| Wie gehen wir mit `no_entry` um? | Neutrale Einträge dürfen nicht als Erfolg zählen, können aber die Aussage erklären. | Statusziele: abgeschlossener Nicht-Erfolg fuer Erreichbarkeit, aber neutral erklaert. Wertziele: kein Ersatzwert, sondern Datenluecke. |
| Wie gehen wir mit `pending` um? | Offene Einträge sind noch nicht endgültig bewertbar. | Statusziele: offene Chance in der rollierenden Live-Anzeige; historische Schutzfall-Bloecke werden nicht gewertet. Wertziele: kein Wert, sondern Datenluecke/offen. |
| Brauchen Zielaufgaben eine Missed Policy? | Historische Zielbloecke duerfen nicht dauerhaft durch alte offene Eintraege haengen. | Ja: Status- und Wertziele mit `MissedPolicy.none` sind nicht speicherbar; `no_entry` als weiche Konsequenz empfehlen. |
| Muss es eine Blockliste geben? | Die Zielhistorie waere sonst schwer nachvollziehbar. | Ja, aber hinter Button oder aufklappbarem Bereich; die Hauptkarte zeigt nur die Zusammenfassung. |
| Wie werden unvollstaendige Zielbloecke gezeigt? | Sonst wirkt die Zielquote unerklaerlich. | In der Blockliste klar markieren, aus der Quote herausrechnen und erklaeren, dass offene Eintraege nachgetragen werden koennen. |
| Was passiert bei Aufgaben ohne Ziel? | Nicht jede Aufgabe braucht Zielbewertung. | Keine Zielkarte; normale Auswertung bleibt führend. |
| Was passiert bei einmaligen Aufgaben? | Eine einzelne Aufgabe hat meist kein Zeitraumziel. | Keine Zielbewertung, außer später Sammelziele für einmalige Aufgaben entstehen. |
| Wie wird mit Zieländerungen umgegangen? | Historische Auswertungen dürfen nicht verfälscht werden. | Instanzen über Definitionsversion bewerten; Gesamtauswertung verbindet bereits bewertete Teilzeiträume. |
| Welche Wertziele kommen in 14d? | Wertziele sollen release-nutzbar sein, aber klein bleiben. | Mindest-Summe, Mindest-Durchschnitt und Hoechstens-Durchschnitt fuer Zahl, Dauer und berechenbare Buendelwerte. Uhrzeit bleibt Tracking-only. |

## Nicht Teil von Phase 14

- weitere Zieltypen ausserhalb von `status_success_count`, `value_sum_min`,
  `value_average_min` und `value_average_max`
- konkrete Zahleneingabe, Dauer- oder Uhrzeit-UI
- Unteraufgaben
- Papierkorb
- Firebase-Synchronisierung selbst
- frei konfigurierbare Kartenkennzahl
- komplexe Motivations-/Belohnungssysteme
- maximale-Fehlschläge-Ziele als eigener Release-Zieltyp
- echte Streak-Auswertungen wie aktuelle Serie, längste Serie oder
  Unterbrechungslogik
- mehrere parallele Ziele pro Aufgabe
- Prognosen fuer zukuenftige Tage oder laufende feste Zielbloecke
- Monatsziele im Sinne eines echten Kalendermonats
- Monatsvergleiche und Jahres-/Kalender-Blockansichten; diese sollen später
  als Auswertungsansichten aus den dokumentierten Tagesdaten entstehen

## Erfolgsbedingung

Phase 14 ist abgeschlossen, wenn:

1. die erste Menge der Zielarten feststeht,
2. für jede Zielart eine verständliche Rechenregel dokumentiert ist,
3. die Zielbewertung dieselben Rohdaten nutzt wie die Auswertung,
4. `pending`, `failure` und `no_entry` fachlich korrekt behandelt werden,
5. Aufgaben ohne Ziel und einmalige Aufgaben sauber abgegrenzt sind,
6. die Detailansicht eine verständliche Zielaussage anzeigen kann,
7. wichtige Info-Texte kurz erklären, wie die Zielbewertung zustande kommt,
8. gezielte Tests die wichtigsten Zielarten abdecken.
