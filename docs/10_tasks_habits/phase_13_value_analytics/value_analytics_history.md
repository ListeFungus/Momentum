# Momentum - Phase 13: Verlauf und aktueller Stand

Stand: 30. August 2026  
Status: Phase 13 abgeschlossen; Phase 14 vorbereitet

## Zweck dieses Dokuments

Dieses Dokument haelt fest, was in Phase 13 geprueft, entschieden und umgesetzt
wurde.

## Ausgangslage

Phase 13 wurde eingefuehrt, weil Zielbewertung erst sinnvoll ist, wenn die
Auswertungen vollstaendig genug sind. Nach Phase 12 koennen nicht nur Ja/Nein-
Status, sondern auch Zahl-, Dauer-, Uhrzeit- und Buendelwerte erfasst werden.

## 2026-08-10 - Phase 12 abgeschlossen, Phase 13 vorbereitet

Phase 12 wurde abgeschlossen und extern bestaetigt:

- Zahl, Dauer und Uhrzeit koennen erfasst werden.
- `recorded` ist als Wertstatus vorhanden.
- Reines Tracking schreibt keine leeren Tage.
- Verbindliche Wert-Eingaben nutzen direkte Konsequenz, Puffer und Carryover.
- Zwei-Werte-Buendel verbinden zwei Teil-Trackings und berechnen
  Zeitintervall, Differenz oder Summe.
- Der gezielte Buendeltest lief extern mit `+5 All tests passed`.

Damit kann Phase 13 starten.

Vorbereitet wurde:

- `value_analytics_plan.md` als aktueller Arbeitsplan.
- `value_analytics_concept.md` als fachliches Startkonzept.
- Die Hauptplanung wurde auf Phase 13 als aktiven Arbeitsbereich umgestellt.

## 2026-08-13 - Phase 13 fachlich gegrillt und Umsetzung vorbereitet

Die Planung fuer Phase 13 wurde in einem eigenen Planungs-Chat detailliert
geschaerft. Ziel war, die spaetere Umsetzung moeglichst reibungslos und
kontingentschonend vorzubereiten.

Bestaetigt wurde:

- Phase 13 speichert keine abgeleiteten Statistikwerte, Aggregate, Rollups oder
  Verlaufspunkte.
- Echte Rohdaten bleiben die Grundlage: `TaskEntry`, `TaskEntryValue` und
  Buendeldefinitionen.
- Wertkennzahlen werden bei Abruf aus Rohdaten fuer einen Zeitraum berechnet.
- Fehlende reine Tracking-Tage werden nur virtuell pro einzelner Wert-Aufgabe
  bzw. einzelnem Habit abgeleitet und nicht gespeichert.
- Verbindliche Wert-Eingaben nutzen echte `pending`, `recorded`, `failure` und
  `no_entry` Entries.
- Zahl und Dauer sind grundsaetzlich summierbar; Uhrzeit ist nicht summierbar.
- Einzelne Uhrzeiten werden nicht als "frueh" oder "spaet" bewertet.
- Uhrzeit-Auswertungen nutzen `timeMinutes` plus `dayOffset`.
- Buendel bleiben Anzeige- und Rechenhuellen ueber zwei normale Teil-Trackings.
- Buendel erhalten eine eigene Detailansicht mit Navigation zu beiden
  Teil-Trackings.
- Nur vollstaendige und berechenbare Buendel gehen in Wertaggregate ein.
- Einmalige Wert-Aufgaben erhalten einfache Einzelwertdetails; Logbuch,
  Profiling und Diagnostik bleiben spaetere Themen.
- Die Umsetzung wird in Pakete 13a bis 13d geschnitten.
- Tests sind als empfohlene Pruefstrategie dokumentiert, nicht als starre
  Pflichtbefehle, weil lokale Testlaeufe in VS Code teils problematisch waren.

Aktualisiert wurde:

- `value_analytics_plan.md` als detaillierte Arbeitskarte fuer den
  Umsetzungs-Chat.

## Naechster Schritt

Phase 13 kann in einem Umsetzungs-Chat anhand von
[`value_analytics_plan.md`](value_analytics_plan.md) umgesetzt werden. Der
Umsetzungs-Chat soll zuerst vorhandene Logik pruefen, dann die Pakete 13a bis
13d abarbeiten und bei fachlicher Unsicherheit stoppen und fragen.

## 2026-08-14 - Letzte Klaerpunkte vor Umsetzung entschieden

Vor der Umsetzung wurden vier Punkte final festgelegt:

1. Zahlen sind in Phase 13 grundsaetzlich summierbar. Weil Nutzende aktuell
   eigene Einheiten frei eingeben koennen, entscheidet die App nicht hart, ob
   eine Summe fachlich sinnvoll ist. Spaeter kann eine Einheitenverwaltung oder
   Kennzahl-Auswahl die Anzeige verbessern.
2. Uhrzeiten muessen mit Tagesbezug ausgewertet werden. Beispiel: Ein Wert
   `00:30 Uhr` kann bei einer Auswertung fuer den 12.8. durch Folgetag-Bezug
   fachlich den 13.8. 00:30 Uhr meinen.
3. Verlauf/Trend bedeutet im ersten Phase-13-Ausbau eine einfache Wertliste im
   Zeitraum. Diagramme, Trendpfeile und echte Trendanalyse bleiben spaeter.
4. Buendel-Auswertung behandelt im ersten Ausbau aktive Buendel. Historisch
   datumsscharfe Auswertung aufgeloester Buendel bleibt spaeter offen.

Damit sind keine fachlichen Blocker fuer den Start von 13a sichtbar.

## 2026-08-14 - Phase 13a umgesetzt: zentrale Wert-Auswertung

Phase 13a wurde als Daten-/Repository-Schritt umgesetzt. Es wurde noch keine
Detail-UI gebaut; diese folgt in Phase 13b.

Umgesetzt wurde:

- Neue Ergebnisstruktur
  `lib/features/aufgaben/data/task_value_analytics_summary.dart`.
- Neue Repository-Methoden:
  - `getTaskValueAnalyticsSummaryForPeriod`
  - `watchTaskValueAnalyticsSummaryForPeriod`
- Die Auswertung liest `TaskEntry` und `TaskEntryValue` fuer eine Aufgabe und
  einen bestehenden `TaskAnalyticsPeriod`.
- Zahl, Dauer und Uhrzeit werden zentral verarbeitet.
- Nur `recorded` Entries mit echtem Wert gehen in Summe, Durchschnitt, Minimum
  und Maximum ein.
- `pending`, `no_entry`, `failure` und nicht berechenbare `recorded` Entries
  werden separat gezaehlt.
- Reine Tracking-Tage ohne Entry werden virtuell als fehlend abgeleitet, aber
  nicht gespeichert.
- Die virtuellen fehlenden Tage nutzen dieselbe Faelligkeitslogik wie die
  Aufgabenanzeige. Dadurch erzeugt ein woechentliches reines Tracking nicht
  faelschlich taegliche Luecken.
- Uhrzeiten werden mit Tagesbezug ausgewertet:
  `timeMinutes + dayOffset * 24 * 60`.
- Uhrzeiten bekommen Durchschnitt, Minimum und Maximum; keine Summe.
- Zahlwerte werden in der eingegebenen Aufgaben-Einheit ausgewertet. Das passt
  zur aktuellen Freitext-Einheiten-Entscheidung und vermeidet eine fuer Nutzer
  ueberraschende Anzeige in Basiseinheiten.

Tests/Pruefung:

- Drei gezielte Repository-Tests wurden ergaenzt:
  - Zahl-Auswertung mit virtuellen reinen-Tracking-Luecken
  - getrennte Statuszaehlung bei verbindlichen Wert-Eingaben
  - Uhrzeit-Auswertung mit Folgetag-Bezug
- Die gezielte statische Analyse der betroffenen Dateien lief gruen:
  `flutter analyze lib\features\aufgaben\data\aufgaben_repository.dart
  lib\features\aufgaben\data\task_value_analytics_summary.dart
  test\features\aufgaben\data\aufgaben_repository_test.dart`
- Der gezielte Flutter-Testlauf mit `--plain-name "Wert-Auswertung"` hing in
  der Codex-Umgebung nach 60 Sekunden ohne Ergebnis. Die hängenden
  Dart-Prozesse wurden beendet. Da solche Haenger lokal bereits mehrfach
  auftraten, gilt das nicht automatisch als fachlicher Fehler der Umsetzung.
  Der Test sollte bei Bedarf extern in PowerShell wiederholt werden.

Naechster Schritt:

- Phase 13b: Die neue Wert-Auswertung in der Detailansicht anzeigen.

## 2026-08-14 - Externe Pruefung Phase 13a bestaetigt

Der gezielte Test fuer Phase 13a wurde extern in PowerShell ausgefuehrt:

```powershell
cd "C:\Users\maxkr\Documents\Flutter Apps\Upgear\momentum"
flutter test --no-pub test\features\aufgaben\data\aufgaben_repository_test.dart --plain-name "Wert-Auswertung"
```

Ergebnis:

```text
00:03 +3: All tests passed!
```

Damit ist Phase 13a nicht nur statisch analysiert, sondern auch durch die
gezielten Repository-Tests bestaetigt.

## 2026-08-14 - Phase 13b technisch umgesetzt: Wert-Auswertung in der Detailansicht

Die zentrale Wert-Auswertung aus Phase 13a wurde in der Detailansicht sichtbar
gemacht.

Umgesetzt wurde:

- `TaskDetailScreen` unterscheidet nun zwischen einmaligen Aufgaben,
  wiederkehrenden normalen Status-Aufgaben und wiederkehrenden Wert-Aufgaben.
- Wiederkehrende Wert-Aufgaben/Habits zeigen eine Zeitraum-Auswahl und danach
  drei Bereiche:
  - `Verarbeitung`
  - `Werte`
  - `Wertliste`
- `Verarbeitung` zeigt erfasste Werte, fehlende reine-Tracking-Tage, offene
  Pflichtwerte, Kein-Eintrag-Faelle und verpasste Pflichtwerte.
- `Werte` zeigt Summe, Durchschnitt, Minimum bzw. frueheste Uhrzeit und Maximum
  bzw. spaeteste Uhrzeit.
- Uhrzeiten zeigen keine Summe, weil Uhrzeiten nicht addiert werden.
- Die einfache `Wertliste` zeigt echte erfasste Werte im Zeitraum. Sie ist noch
  keine Diagramm- oder Trendansicht.
- Einmalige Wert-Aufgaben zeigen nun in den Aufgabendetails ihren gespeicherten
  Einzelwert.
- Fuer einmalige Wert-Aufgaben wurde ein kleiner Repository-Stream ergaenzt,
  der den letzten `TaskEntry` zusammen mit optionalem `TaskEntryValue` liefert.
- Die Darstellung nutzt die vorhandenen Metric Cards weiter, damit die Seite
  ruhig und konsistent bleibt.

Pruefung:

- `dart format` lief fuer die betroffenen Dart-Dateien.
- Die gezielte statische Analyse der betroffenen Dateien lief gruen:
  `flutter analyze lib\features\aufgaben\data\aufgaben_repository.dart
  lib\features\aufgaben\data\task_entry_with_value.dart
  lib\features\aufgaben\data\task_value_analytics_display.dart
  lib\features\aufgaben\data\task_value_analytics_summary.dart
  lib\features\aufgaben\presentation\task_detail_screen.dart`

Noch sinnvoll vor Phase 13c:

- kurze manuelle App-Pruefung:
  - wiederkehrende Zahl-Aufgabe oeffnen
  - wiederkehrende Dauer-Aufgabe oeffnen
  - wiederkehrende Uhrzeit-Aufgabe mit Folgetag-Bezug oeffnen
  - einmalige Wert-Aufgabe oeffnen
  - Zeitraum wechseln und Plausibilitaet pruefen

Naechster technischer Schritt nach dieser Sichtpruefung:

- Phase 13c: Buendel-Auswertung und Buendel-Detailansicht.

## 2026-08-16 - Phase 13b geprueft und Regression bestaetigt

Die Sichtpruefung in der App wurde durchgefuehrt:

- Uhrzeit-Tracking funktioniert in der App.
- Einmalige reine Wert-Aufgaben werden wieder angezeigt.
- Der konkrete Fall `Geld zur Seite legen` bzw. `Geld anlegen` ist sichtbar.

Zusaetzlich wurde eine Regression geschlossen:

- Offene einmalige reine Wert-Aufgaben ohne Fälligkeitsdatum erzeugen weiterhin
  keinen leeren Entry.
- Sie erscheinen jetzt in der Dringlichkeitsansicht unter `Ohne Zeitdruck`.
- Nach einer Wert-Eingabe verschwinden sie dort und erscheinen in
  `Abgeschlossene Aufgaben`.

Der gezielte Test wurde extern in PowerShell bestaetigt:

```powershell
cd "C:\Users\maxkr\Documents\Flutter Apps\Upgear\momentum"
flutter test --no-pub test\features\aufgaben\data\aufgaben_repository_test.dart --plain-name "zeigt offene einmalige reine Wert-Aufgabe in Dringlichkeit"
```

Ergebnis:

```text
00:11 +1: All tests passed!
```

Damit gilt Phase 13b als geprueft.

## 2026-08-16 - Phase 13c technisch umgesetzt: Buendel-Auswertung und Detailansicht

Phase 13c wurde als erster technischer Ausbaustand umgesetzt.

Umgesetzt wurde:

- Neue Ergebnisstruktur
  `lib/features/aufgaben/data/task_value_bundle_analytics_summary.dart`.
- Neue Display-Hilfe
  `lib/features/aufgaben/data/task_value_bundle_analytics_display.dart`.
- Neue Detailseite
  `lib/features/aufgaben/presentation/task_value_bundle_detail_screen.dart`.
- Repository-Methoden:
  - `getTaskValueBundleAnalyticsSummaryForPeriod`
  - `watchTaskValueBundleAnalyticsSummaryForPeriod`
- Die Auswertung nutzt pro relevantem Tag die bestehende
  `calculateTaskValueBundle`-Logik.
- Gezaehlt werden:
  - vollstaendige Buendel
  - teilweise Buendel
  - fehlende Buendel
  - nicht berechenbare Buendel
- Nur vollstaendige und berechenbare Buendel gehen in Summe, Durchschnitt,
  Minimum und Maximum ein.
- Zeitintervall-Buendel bekommen keine Summe, aber Durchschnitt, Minimum und
  Maximum.
- Die Buendelkarte oeffnet jetzt die Buendel-Detailansicht.
- Die Buendel-Detailansicht zeigt:
  - Zeitraum-Auswahl
  - Verarbeitung
  - Werte
  - einfache Tagesliste
  - zwei Links zu den Detailansichten der Teil-Trackings
- Es werden keine eigenen Buendel-Rohwerte gespeichert.

Pruefung:

- `dart format` lief fuer die betroffenen Dart-Dateien.
- Die gezielte statische Analyse der betroffenen Dateien lief gruen:
  `flutter analyze lib\features\aufgaben\data\aufgaben_repository.dart
  lib\features\aufgaben\data\task_value_bundle_analytics_summary.dart
  lib\features\aufgaben\data\task_value_bundle_analytics_display.dart
  lib\features\aufgaben\presentation\task_value_bundle_detail_screen.dart
  lib\features\aufgaben\presentation\widgets\task_value_bundle_card.dart
  lib\features\aufgaben\presentation\aufgaben_screen.dart
  test\features\aufgaben\data\aufgaben_repository_test.dart`
- Ein gezielter Repository-Test wurde ergaenzt:
  `Bündel-Auswertung zählt Status und aggregiert Ergebnisse`.
- Der Testlauf hing in der Codex-Umgebung ohne Fehlermeldung. Die
  haengenden Dart-Prozesse wurden beendet. Der Test sollte extern in
  PowerShell bestaetigt werden.

Naechster sinnvoller Schritt:

- externen PowerShell-Test fuer 13c ausfuehren
- kurze App-Sichtpruefung:
  - Buendelkarte antippen
  - Zeitraum wechseln
  - Werte/Verarbeitung plausibel pruefen
  - beide Teil-Tracking-Links oeffnen

## 2026-08-16 - Phase 13c ergaenzt: Buendel-Erstellung in der UI

Nach der Umsetzung der Buendel-Detailansicht fiel auf, dass Buendel technisch
erstellt werden konnten, aber in der normalen App kein sichtbarer Zugang zur
Erstellung vorhanden war.

Entschieden wurde:

- Buendel werden nicht ueber einen globalen Debug-Zugang erstellt.
- Stattdessen startet die Erstellung aus den Optionen einer bestehenden
  Wert-Aufgabe bzw. eines Wert-Habits.
- Dadurch ist der erste Teil des Buendels bereits klar.
- Die App muss nur noch einen passenden zweiten Wert anbieten.

Umgesetzt wurde:

- `TaskCard` hat eine optionale Aktion `Buendeln`.
- Die Aktion erscheint nur, wenn der jeweilige Aufruf eine
  Buendel-Erstellung erlaubt.
- In der Aufgaben-/Habit-Liste und in der Liste abgeschlossener einmaliger
  Aufgaben fuehrt `Buendeln` zu
  `TaskValueBundleCreateScreen`.
- `TaskValueBundleCreateScreen` bietet:
  - Buendeltyp
  - zweites passendes Tracking
  - Name des Buendels
  - Rollenbezeichnungen
  - Ergebnisbezeichnung
- Fuer Uhrzeiten wird `Zeitintervall` angeboten.
- Fuer Zahl und Dauer werden `Differenz` und `Summe` angeboten.
- Die Kandidatenliste zeigt nur fachlich passende zweite Wert-Trackings.
- Das Repository bietet dafuer
  `compatibleTasksForValueBundle`.
- Beim Speichern bleibt `createValueBundle` die letzte technische
  Sicherheitslinie.

Pruefung:

- `dart format` lief fuer die betroffenen Dart-Dateien.
- Die gezielte statische Analyse lief gruen:
  `flutter analyze lib\features\aufgaben\data\aufgaben_repository.dart
  lib\features\aufgaben\presentation\task_value_bundle_create_screen.dart
  lib\features\aufgaben\presentation\widgets\task_card.dart
  lib\features\aufgaben\presentation\aufgaben_screen.dart
  lib\features\aufgaben\presentation\completed_one_time_tasks_screen.dart
  test\features\aufgaben\data\aufgaben_repository_test.dart`
- Ein gezielter Repository-Test wurde ergaenzt:
  `Bündel-Erstellung listet nur passende zweite Trackings`.
- Der lokale Testlauf hing in der Codex-Umgebung ohne Fehlermeldung und soll
  extern in PowerShell bestaetigt werden.

## 2026-08-19 - Phase 13c.1 geplant: Buendel-Erstellung, Anzeigeart und Tageszuordnung

Nach der ersten App-Pruefung von Phase 13c wurden weitere fachliche Luecken
sichtbar. Die bestehende Umsetzung bleibt als erster Stand bestehen, benoetigt
aber eine gezielte Nachschaerfung.

Erkannte Probleme:

- Die Buendel-Erstellung nutzt technisch `validFrom`, bietet in der UI aber
  kein bewusstes Startdatum. Rueckwirkende Buendel sind dadurch fuer Nutzende
  nicht verstaendlich steuerbar.
- Differenz-Buendel speichern technisch eine Richtung, aber die UI bietet keine
  Auswahl wie `Aufnahme - Verbrauch` oder `Verbrauch - Aufnahme`.
- Zeitintervall-Buendel behandeln beide Teilwerte aktuell als Werte desselben
  angezeigten Tages. Schlaf benoetigt aber oft den ersten Wert vom Vortag und
  den zweiten Wert am angezeigten Aufstehtag.
- Uhrzeit-Eingaben koennen technisch `dayOffset` speichern, die UI zeigt die
  Datumszuordnung aber noch nicht an.
- Eine gemeinsame Buendelkarte passt nicht fuer alle Faelle. Cross-Day-Buendel
  wie Schlaf sollen als verknuepfte Einzelkarten dargestellt werden.

Bestaetigte Entscheidungen:

- Einzelne Uhrzeit-Eingaben bekommen eine sichtbare Datumszuordnung mit
  `dayOffset = -1`, `0` oder `+1`.
- Fuer Auswertung und Buendel zaehlt der angezeigte/geplante Tag
  (`scheduledDate`). Das reale Kalenderdatum der Uhrzeit wird ueber
  `dayOffset` erklaert.
- Bei Bettgehzeit gilt als empfohlene Nutzung: Die Bettgehzeit wird bei dem Tag
  gespeichert, den sie mit Schlaf beendet. Beispiel: Bettgehzeit fuer den
  12.08. kann `00:30 am 13.08.` sein.
- Mehrere Werte pro Aufgabe und `scheduledDate` bleiben spaeteres Thema.
- Buendel bekommen beim Erstellen ein `Gilt ab`-Datum. Standard ist heute;
  zusaetzlich sollen Startdatum des ersten Trackings, Startdatum des zweiten
  Trackings, spaeteres Startdatum beider Trackings und eigenes Datum moeglich
  sein.
- Differenz-Buendel bekommen eine UI-Auswahl fuer die Rechenrichtung.
- Buendel bekommen eine Anzeigeart: gemeinsame Buendelkarte oder verknuepfte
  Einzelkarten.
- Same-Day-Buendel duerfen die Anzeigeart frei waehlen.
- Cross-Day-Zeitintervall-Buendel muessen verknuepfte Einzelkarten nutzen.
- Fuer Schlaf ist der angezeigte Tag standardmaessig der End-/Aufstehtag.
- Verknuepfte Einzelkarten zeigen einen Buendel-Hinweis und eine Menueaktion
  zur Buendel-Auswertung.

Technische Planung:

- `value_analytics_plan.md` wurde um das Paket
  `13c.1 - Buendel-Erstellung und Tageszuordnung nachschaerfen` erweitert.
- Voraussichtlich braucht `TaskValueBundleVersions` eine kleine
  Schema-Erweiterung:
  - `displayMode`
  - `firstTaskDayOffset`
  - `secondTaskDayOffset`
- Bestehende Buendel sollen per Migration als Same-Day + gemeinsame Karte
  fortgefuehrt werden.

Naechster Schritt:

- 13c.1 in einem Umsetzungs-Chat gezielt bauen, ohne die bestehende
  Wert-Auswertung oder Statuslogik breit zu ersetzen.

## 2026-08-19 - Phase 13c geprueft und 13c.1 technisch vorbereitet

Phase 13c wurde nach externer PowerShell-Pruefung als geprueft eingeordnet.

Externe Tests:

- `Bündel-Auswertung zählt Status und aggregiert Ergebnisse`: `+1 All tests passed`
- `Bündel-Erstellung listet nur passende zweite Trackings`: `+1 All tests passed`

Danach wurde 13c.1 als Nachschaerfung technisch vorbereitet.

Umgesetzt:

- Buendelversionen wurden fachlich erweitert um:
  - `displayMode`
  - `firstTaskDayOffset`
  - `secondTaskDayOffset`
- Schema-Version 16 wurde vorbereitet.
- Bestehende Buendel werden per Migration als Same-Day + gemeinsame Karte
  weitergefuehrt.
- Die Buendel-Erstellung zeigt jetzt:
  - `Gilt ab`
  - Schnelloptionen fuer Startdaten
  - Differenzrichtung
  - Tageszuordnung fuer Zeitintervalle
  - Anzeigeart
  - Hinweis fuer Cross-Day-Zeitintervalle
- `createValueBundle` validiert:
  - erlaubte Buendeltypen
  - Differenzrichtung
  - Anzeigeart
  - erlaubte Tagesoffsets
  - Cross-Day nur fuer Zeitintervall + verknuepfte Einzelkarten
  - Summe und Differenz bleiben Same-Day
- Die Buendellogik liest pro angezeigtem Buendeltag die passenden Quelldaten:
  - Same-Day: beide Teilwerte am angezeigten Tag
  - Cross-Day: erster Teilwert vom Vortag, zweiter Teilwert am angezeigten Tag
- Verknuepfte Einzelkarten bleiben sichtbar, zeigen `Teil von ...` und bieten
  eine Menueaktion zur Buendel-Auswertung.
- Gemeinsame Buendelkarten blenden die Teilkarten wie bisher aus.
- Uhrzeit-Eingaben zeigen jetzt die Datumszuordnung Vortag / gleicher Tag /
  Folgetag und speichern `dayOffset`.
- Gezielte Repository-Tests fuer 13c.1 wurden vorbereitet:
  - Speicherung von `Gilt ab`, Richtung und Anzeigeart
  - Cross-Day-Schlafdauer ueber Vortag + Aufstehtag
  - Cross-Day-Zeitintervall ohne gemeinsame Buendelkarte

## 2026-08-19 - Phase 13c.1 extern geprueft

Externe Bestaetigung nach Umsetzung:

- `dart run build_runner build`: erfolgreich; `build_runner` schrieb 81 Outputs.
- `flutter test --no-pub test\features\aufgaben\data\aufgaben_repository_test.dart --plain-name "Bündel"`:
  `+9 All tests passed`.
- Gezielte Analyse der betroffenen Dateien:
  `No issues found`.

Damit ist 13c.1 technisch geprueft.

Empfohlene manuelle Sichtpruefung:

- Uhrzeit mit Folgetag speichern.
- Rueckwirkendes Buendel erstellen.
- Cross-Day-Schlafbuendel erstellen.
- Pruefen, dass verknuepfte Karten sichtbar bleiben und die Auswertung
  erreichbar ist.

Naechster Schritt:

- Phase 13d als Abschlussblock nutzen:
  - Dokumente final gegen den Code abgleichen
  - offene UX-Feinschliffe fuer spaeter sammeln
  - Phase 14/15 sauber vorbereiten

## 2026-08-30 - Phase 13d vorbereitet

Phase 13c und 13c.1 wurden erneut gegen Code, Tests und Doku quergeprueft.
Der Code zeigt die fuer 13c.1 geplanten Erweiterungen tatsaechlich:

- Buendelversionen speichern `displayMode`, `firstTaskDayOffset` und
  `secondTaskDayOffset`.
- `createValueBundle` validiert Startdatum, Richtung, Anzeigeart und erlaubte
  Cross-Day-Kombinationen.
- Die Buendel-Erstellung bietet `Gilt ab`, Startdatum-Schnelloptionen,
  Differenzrichtung, Tageszuordnung und Anzeigeart.
- Uhrzeit-Eingaben zeigen Vortag / gleicher Tag / Folgetag und speichern
  `dayOffset`.
- Verknuepfte Einzelkarten bleiben sichtbar, zeigen den Buendelhinweis und
  bieten den Zugang zur Buendel-Auswertung.
- Cross-Day-Auswertung liest den ersten Teilwert vom Vortag und den zweiten
  Teilwert vom angezeigten Tag.
- Die vorhandenen Repository-Tests decken Startdatum/Richtung/Anzeigeart,
  Cross-Day-Schlafdauer und verknuepfte Karten ab.

Gezielte Pruefung in diesem Planungs-Chat:

- Ein leichter `flutter analyze`-Lauf ueber die relevanten Phase-13-Dateien
  wurde gestartet.
- Ergebnis: eine Warnung, kein fachlicher Fehler.
- Warnung:
  `lib\features\aufgaben\data\task_value_bundle_versions_table.dart` enthaelt
  einen ungenutzten Import von `task_value_bundle.dart`.

Einschaetzung:

- 13c/13c.1 wirken fachlich und technisch abgeschlossen genug fuer Phase 13d.
- Vor 13d ist keine blockierende Fachfrage sichtbar.
- Der ungenutzte Import sollte in 13d als erster kleiner Cleanup erledigt
  werden.
- Danach sollte 13d keine neue Funktionalitaet bauen, sondern Abschluss,
  Pruefung, Doku und Uebergang zu Phase 14 vorbereiten.

Aktualisiert:

- `value_analytics_plan.md` beschreibt 13d jetzt als konkrete Abarbeitungskarte
  mit:
  - Cleanup-Schritt
  - empfohlener gezielter Analyse
  - optionalem Buendel-Test
  - manueller Sichtpruefliste
  - Folgepunkten, die nicht mehr in Phase 13 gehoeren
  - klaren Paketstatus-Regeln fuer `umgesetzt`, `geprueft` und `blockiert`

## 2026-08-30 - Phase 13d abgeschlossen

Phase 13d wurde als Abschluss- und Dokumentationsblock umgesetzt. Es wurde kein
neues Feature gebaut, sondern der bestehende Stand bereinigt und sauber fuer die
naechste Phase festgehalten.

Erledigt:

- Der in 13d dokumentierte Analyze-Cleanup wurde umgesetzt:
  - `lib\features\aufgaben\data\task_value_bundle_versions_table.dart`
    importiert `task_value_bundle.dart` nicht mehr ungenutzt.
- Die betroffene Datei wurde gezielt geprueft:
  - `flutter analyze lib\features\aufgaben\data\task_value_bundle_versions_table.dart`
  - Ergebnis: `No issues found`
- `value_analytics_plan.md` wurde auf `Phase 13 abgeschlossen` gestellt.
- Die uebergeordnete Planung wurde auf Phase 14 als naechsten aktiven
  Arbeitsbereich vorbereitet.

Abgeschlossener Phase-13-Stand:

- Einzelne Wert-Aufgaben und Wert-Habits koennen zeitraumbezogen ausgewertet
  werden.
- Zahl, Dauer und Uhrzeit werden getrennt und passend aggregiert.
- Reine Tracking-Luecken werden virtuell ausgewertet, aber nicht gespeichert.
- Verbindliche Wert-Eingaben zaehlen `recorded`, `pending`, `failure` und
  `no_entry` getrennt.
- Einmalige Wert-Aufgaben erhalten konkrete Einzelwertdetails.
- Zwei-Werte-Buendel koennen erstellt, berechnet, angezeigt, aufgeloest und
  ausgewertet werden.
- Buendel unterstuetzen Same-Day, Cross-Day-Zeitintervalle, Differenzrichtung,
  `Gilt ab` und zwei Anzeigearten.
- Uhrzeit-Eingaben speichern und zeigen den Tagesbezug ueber
  Vortag / gleicher Tag / Folgetag.

Bewusst nicht in Phase 13 geloest:

- Zielbewertung. Sie folgt in Phase 14.
- Auswahl einer Kartenkennzahl. Sie folgt in Phase 15.
- Diagramme, Trends, frei konfigurierbare Zeitraeume und Logbuchansichten.
- Eigene Einheitenverwaltung.
- Mehrere Werte pro Aufgabe und Tag.
- Historisch datumsscharfe Rekonstruktion aufgeloester Buendel.

Naechster Schritt:

- Phase 14: Ziele werden auf die vorhandenen Status- und Wert-Auswertungen
  gelegt. Wichtig bleibt: keine zweite, abweichende Rechenlogik fuer Ziele
  aufbauen.
