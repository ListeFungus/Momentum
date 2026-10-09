# Momentum - Phase 13: Auswertung erweiterter Eingaben

Stand: 30. August 2026  
Status: Phase 13 abgeschlossen; Phase 14 vorbereitet

## Zweck dieses Dokuments

Dieses Dokument ist die Arbeitskarte fuer die Umsetzung von Phase 13 in einem
anderen Chat. Es soll so konkret sein, dass die Umsetzung in kleinen Paketen
abgearbeitet werden kann, ohne fachliche Grundfragen erneut zu klaeren.

Die beschriebenen Dateien, Klassen und Tests sind bewusst als
Umsetzungsvorschlag zu verstehen. Der Umsetzungs-Chat soll zuerst den aktuellen
Code lesen und vorhandene passende Logik erweitern. Bestehende Logik darf nicht
blind ersetzt werden.

Das fachliche Startkonzept steht in
[`value_analytics_concept.md`](value_analytics_concept.md). Die uebergeordnete
Matrix steht in [`../task_analytics_matrix.md`](../task_analytics_matrix.md).

## Ziel

Nachdem Phase 12 Zahl, Dauer, Uhrzeit, reines Tracking, verbindliche
Wert-Eingaben und Zwei-Werte-Buendel umgesetzt hat, liefert Phase 13 die
passenden Wert-Auswertungen dafuer.

Phase 13 beantwortet fuer einen gewaehlten Zeitraum zum Beispiel:

- Wie viele Werte wurden erfasst?
- Wie viele Werte fehlen?
- Welche Werte waren offen, neutral abgeschlossen oder verpasst?
- Was ist Summe, Durchschnitt, Minimum und Maximum?
- Was ist der abgeleitete Wert eines Buendels, z. B. Schlafdauer?
- Welche Buendel sind vollstaendig, teilweise, fehlend oder nicht berechenbar?

Phase 13 bewertet noch keine Ziele und legt noch keine Kartenkennzahl fest.

## Begriffe fuer die Umsetzung

| Begriff | Bedeutung in Phase 13 |
|---|---|
| Rohdaten | Gespeicherte echte Daten wie `TaskEntry`, `TaskEntryValue`, Aufgaben- und Buendeldefinitionen. |
| Abgeleitete Kennzahl | Rechenergebnis aus Rohdaten, z. B. Summe, Durchschnitt oder fehlende Werte. |
| Aggregat / Rollup | Dauerhaft gespeicherte Statistik, z. B. eine gespeicherte Wochensumme. Wird in Phase 13 nicht eingefuehrt. |
| Gemeinsame Wert-Auswertung | Zentrale Berechnung, die gespeicherte Eintraege und Wertdaten eines Zeitraums liest und daraus die Anzeigezahlen erzeugt. |
| Virtuell fehlender Tracking-Tag | Ein erwartbarer Tag eines reinen Trackings ohne gespeicherten Entry. Er wird fuer die Auswertung abgeleitet, aber nicht gespeichert. |

## Verbindliche Leitplanken

- Wert-Auswertungen bauen auf denselben Instanzen auf wie Status-Auswertungen.
- Es entsteht keine parallele Aufgabenlogik.
- Der gemeinsame gespeicherte Kern bleibt:
  `TaskEntry` fuer Instanz, Status, Zeitpunkte, Herkunft und Notiz;
  `TaskEntryValue` fuer Zahl, Dauer, Uhrzeit, Einheit und Normalisierung.
- Phase 13 fuehrt keine gespeicherten Summen, Rollups, Materialized Views oder
  Verlaufspunkte ein.
- Abgeleitete Kennzahlen werden deterministisch aus Rohdaten berechnet.
- Es gibt keine neuen Tabellen oder Schemaaenderungen, solange beim Umsetzen
  kein echtes Rohdatenloch gefunden wird.
- Ein echtes Rohdatenloch ist nur eine Information, die spaeter nicht mehr
  rekonstruierbar waere. Reine Anzeige- oder Rechenergebnisse sind kein
  Rohdatenloch.
- `recorded` ist der zentrale Rohstatus fuer erfasste Wertdaten.
- Nur echte `recorded` Werte fliessen in Summe, Durchschnitt, Minimum und
  Maximum ein.
- `pending` bleibt offen und wird nicht als gemessener Wert behandelt.
- `no_entry` bleibt fehlender/ausgenommener Eintrag und darf Durchschnittswerte
  nicht kuenstlich verbessern.
- `failure` bedeutet bei verbindlichen Wert-Eingaben: Pflichtwert verpasst,
  aber nicht automatisch "schlechter Wert".
- Reine Tracking-Tage ohne gespeicherten Entry koennen virtuell als fehlende
  Werte erscheinen und duerfen keine lokalen oder spaeteren Cloud-Schreibvorgaenge
  ausloesen.
- Zwei-Werte-Buendel speichern keine eigenen Rohwerte. Sie berechnen den
  abgeleiteten Wert aus zwei normalen Teil-Trackings.
- Die Ergebnisse muessen spaeter von Zielbewertung und Kartenkennzahlen genutzt
  werden koennen.
- Alle Kennzahlen sind immer zeitraumbezogen.

## Bestaetigte fachliche Entscheidungen

| Thema | Entscheidung |
|---|---|
| Speicherung | Echte Eingaben, echte Abschluesse und automatische Konsequenzen werden gespeichert. Abgeleitete Statistikwerte werden nicht gespeichert. |
| Firebase-Vorbereitung | Nur Rohdaten sollen spaeter synchronisiert werden muessen. Berechnete Werte entstehen lokal nach dem Laden. Ein nicht synchronisierter lokaler Cache kann spaeter geprueft werden, ist aber nicht Teil von Phase 13. |
| Fehlende reine Tracking-Tage | Nur pro einzelner Wert-Aufgabe bzw. einzelnem Habit virtuell ableiten. Keine globale Sammelauswertung in Phase 13. |
| Verbindliche Wert-Eingaben | Echte `pending`, `failure`, `no_entry` und `recorded` Entries zaehlen. Keine zusaetzlichen virtuellen Pflicht-Tage erfinden. |
| Zeitraeume | Bestehende Perioden verwenden: letzte 7 Tage, letzte 20 Tage, letzte 30 Tage, seit Beginn. Basis ist `scheduledDate`. |
| Zahl | Zahleneingaben sind grundsaetzlich summierbar. Die App bevormundet nicht, ob die Summe fachlich sinnvoll ist. |
| Dauer | Dauerwerte sind grundsaetzlich summierbar. |
| Uhrzeit | Uhrzeiten sind nicht summierbar. Sie bekommen Anzahl, fehlende Werte, Durchschnitt, frueheste und spaeteste Uhrzeit. |
| Uhrzeit-Kontext | Einzelne Uhrzeiten werden in Phase 13 nicht als "frueh" oder "spaet" bewertet. Kontext wie Schlaf entsteht ueber Buendel und spaetere Ziel-/Interpretationslogik. |
| `dayOffset` | Uhrzeit-Auswertung nutzt `timeMinutes + dayOffset * 24 * 60`. Die UI soll bei Folgetag-Werten klar anzeigen, dass die Uhrzeit am Folgetag liegt. Beispiel: Eintrag fuer den 12.8. mit 00:30 Uhr und Folgetag-Zusatz meint fachlich den 13.8. 00:30 Uhr. |
| Uhrzeit-Datumszuordnung | Einzelne Uhrzeit-Eingaben bekommen eine sichtbare Datumszuordnung mit `dayOffset = -1`, `0` oder `+1`. Fuer Auswertung und Buendel zaehlt weiterhin der angezeigte/geplante Tag (`scheduledDate`); das reale Kalenderdatum der Uhrzeit wird ueber `dayOffset` erklaert. |
| Einheiten | Eine Aufgabe verwendet in Phase 13 ihre konfigurierte Einheit. Bekannte Einheiten koennen normalisiert werden; Freitext-Einheiten bleiben erlaubt und werden nicht umgerechnet. |
| Buendel | Buendel sind Anzeige- und Rechenvorlagen ueber zwei normale Wert-Aufgaben. Die Teil-Trackings bleiben eigenstaendig auswertbar. |
| Teilweise Buendel | Nur vollstaendige und berechenbare Buendel gehen in Wertaggregate ein. Teilweise, fehlende und nicht berechenbare Buendel werden separat gezaehlt. |
| Historische Buendel | Phase 13 wertet zuerst aktive Buendel aus. Historisch datumsscharfe Auswertung aufgeloester Buendel bleibt spaeter offen. |
| Buendel-Startdatum | Buendel bekommen in der Erstellung ein `Gilt ab`-Datum. Standard ist heute; zusaetzlich sollen Startdatum des ersten Trackings, Startdatum des zweiten Trackings, spaeteres Startdatum beider Trackings und eigenes Datum waehlen moeglich sein. |
| Differenzrichtung | Differenz-Buendel muessen in der UI die Rechenrichtung waehlen koennen. Technisch bleiben `first_minus_second` und `second_minus_first` die Grundlage. |
| Buendel-Anzeigeart | Buendel koennen als gemeinsame Buendelkarte oder als verknuepfte Einzelkarten dargestellt werden. Same-Day-Buendel duerfen frei waehlen; Cross-Day-Buendel muessen verknuepfte Einzelkarten nutzen. |
| Cross-Day-Zeitintervall | Zeitintervall-Buendel koennen beide Werte am selben angezeigten Tag verwenden oder den ersten Wert vom Vortag mit dem zweiten Wert am angezeigten Tag verbinden. Fuer Schlaf ist der angezeigte Tag standardmaessig der End-/Aufstehtag. |
| Einmalige Wert-Aufgaben | In Phase 13 nur einfache Einzelwertdetails, keine Sammelauswertung oder Logbuchansicht. |
| Messwert-/Profilthemen | Gewicht, Puls, Blutdruck, Schmerzskalen usw. koennen vorerst als Wert-Aufgaben existieren. Ob sie langfristig in Profil, Diagnostik oder Logbuch gehoeren, wird spaeter entschieden. |
| UI-Umfang | Detailansicht mit Verarbeitung und Werten. Keine Diagramme, keine frei konfigurierbare Kartenkennzahl, kein Wochen-/Monatsvergleich. |

## Aktueller technischer Ausgangspunkt

Diese Liste dient nur zur Orientierung. Der Umsetzungs-Chat soll den aktuellen
Code erneut pruefen.

| Bereich | Aktueller Stand |
|---|---|
| Status-Auswertung | `TaskAnalyticsSummary`, `TaskAnalyticsDisplay` und Repository-Methoden in `AufgabenRepository` zaehlen Statuswerte. |
| Zeitraeume | `TaskAnalyticsPeriod` existiert mit `last7Days`, `last20Days`, `last30Days`, `sinceStart`. |
| Wertdaten | `TaskEntryValues` speichert `valueType`, `numberValue`, `normalizedNumberValue`, `unitKey`, `unitLabel`, `durationSeconds`, `timeMinutes`, `dayOffset`. |
| Wertstatus | `TaskEntryStatus.recorded` ist vorhanden und gilt als abgeschlossen/resolved/positive completion. |
| Tagesanzeige | `TaskForDate` enthaelt optional `entryValue`. |
| Buendel | `TaskValueBundle`, `TaskValueBundleVersion`, `TaskValueBundleForDate` und `TaskValueBundleCalculation` existieren. |
| Detailansicht | `TaskDetailScreen` zeigt bisher Status-/Einzelaufgabendetails, aber noch keine vollstaendige Wert-Auswertung. |

Voraussichtlich betroffene Dateien:

- `lib/features/aufgaben/data/aufgaben_repository.dart`
- `lib/features/aufgaben/data/task_analytics_period.dart`
- `lib/features/aufgaben/data/task_analytics_summary.dart`
- `lib/features/aufgaben/data/task_analytics_display.dart`
- `lib/features/aufgaben/data/task_value_bundle_calculation.dart`
- `lib/features/aufgaben/presentation/task_detail_screen.dart`
- `test/features/aufgaben/data/aufgaben_repository_test.dart`

Voraussichtlich neue Dateien, falls keine bessere bestehende Stelle existiert:

- `lib/features/aufgaben/data/task_value_analytics_summary.dart`
- `lib/features/aufgaben/data/task_value_analytics_display.dart`
- `lib/features/aufgaben/presentation/task_value_bundle_detail_screen.dart`
- optional:
  `test/features/aufgaben/data/task_value_analytics_test.dart`

Diese Dateinamen sind Vorschlaege. Wenn vorhandene Strukturen besser passen,
sollen sie erweitert werden.

## Kennzahlen fuer einzelne Wert-Aufgaben und Habits

Alle Kennzahlen beziehen sich auf den gewaehlten Zeitraum.

### Verarbeitung

| Kennzahl | Bedeutung |
|---|---|
| Erfasst | Anzahl `recorded` Entries mit echtem Wert. |
| Fehlende Tracking-Tage | Virtuell abgeleitete erwartbare Tage ohne Entry, nur bei reinem Tracking. |
| Offen | `pending` Entries bei verbindlichen Wert-Eingaben. |
| Kein Eintrag | `no_entry` Entries. |
| Verpasst | `failure` Entries bei verbindlichen Wert-Eingaben. |

### Werte

| Wertart | Summe | Durchschnitt | Minimum / Maximum | Hinweise |
|---|---:|---:|---:|---|
| Zahl | ja | ja | ja | Summe immer verfuegbar; Nutzer entscheidet spaeter, ob sie sinnvoll angezeigt wird. |
| Dauer | ja | ja | ja | Anzeige als Dauer formatieren. |
| Uhrzeit | nein | ja | ja | Mit `dayOffset` berechnen; keine qualitative Bewertung. |

Regeln:

- Nur `recorded` Werte werden aggregiert.
- Fehlende Werte, `pending`, `no_entry` und `failure` werden separat gezaehlt.
- Fehlende Werte zaehlen nicht als 0.
- Durchschnitt wird nur aus vorhandenen echten Werten berechnet.
- Bei leerer Bezugsmenge zeigt die UI einen freundlichen Leerwert statt
  irrefuehrender 0.

## Einmalige Wert-Aufgaben

Einmalige Wert-Aufgaben erhalten in Phase 13 eine einfache Einzelwertansicht.
Sie bekommen keine klassische Zeitraum-Auswertung als Hauptaussage.

Anzeigen:

- Status: offen, erfasst, verpasst oder kein Eintrag
- gespeicherter Wert mit Einheit
- geplanter bzw. faelliger Tag
- erfasst am bzw. abgeschlossen am
- Abweichung vom Faelligkeitstag, wenn sinnvoll
- Notiz, wenn vorhanden

Bewusst spaeter:

- Logbuch
- Messwert-Historie
- Sammelansicht einzelner Messungen
- Profil-/Diagnostikbereich fuer Werte wie Gewicht, Puls, Blutdruck oder
  Schmerzskalen

Die Phase-13-Umsetzung darf diese spaeteren Ansichten nicht erschweren, muss sie
aber nicht bauen.

## Buendel-Auswertung

Buendel bleiben Huellen ueber zwei normale Wert-Aufgaben. Die Rohdaten bleiben
in den beiden Teil-Trackings.

### Navigation und Anzeige

- In Feed-/Tages-/Habit-Ansichten ersetzt die Buendelkarte die zwei
  Einzelkarten nur visuell.
- Klick auf die Buendelkarte oeffnet eine Buendel-Detailansicht.
- Die Buendel-Detailansicht zeigt die Auswertung des abgeleiteten
  Buendelwerts.
- Zusaetzlich bietet sie zwei klare Wege zu den Detailansichten der
  Teil-Trackings, z. B. `Bettgehzeit` und `Aufstehzeit`.
- Die Teil-Trackings zeigen dort ihre normale Einzel-Auswertung.

### Buendelstatus im Zeitraum

| Status | Bedeutung |
|---|---|
| Vollstaendig | Beide Teilwerte vorhanden und abgeleiteter Wert berechenbar. |
| Teilweise | Genau ein Teilwert vorhanden. |
| Fehlend | Kein Teilwert vorhanden; bei reinem Tracking ggf. virtuell ableitbar. |
| Nicht berechenbar | Beide Teilwerte vorhanden, aber abgeleiteter Wert kann nicht berechnet werden. |

### Aggregation

| Buendeltyp | Abgeleiteter Wert | Summe | Durchschnitt | Minimum / Maximum |
|---|---|---:|---:|---:|
| Zeitintervall | Dauer | nein | ja | ja |
| Differenz | Zahl oder Dauer | ja | ja | ja |
| Summe | Zahl oder Dauer | ja | ja | ja |

Regeln:

- Nur vollstaendige und berechenbare Buendel gehen in Summe, Durchschnitt,
  Minimum und Maximum ein.
- Teilweise, fehlende und nicht berechenbare Buendel werden separat gezaehlt.
- Die Buendel-Detailansicht erklaert, dass abgeleitete Werte nur aus
  vollstaendigen Buendeln berechnet werden.

## Umsetzungspakete

Die Pakete sind so geschnitten, dass der Umsetzungs-Chat bei knappem Kontingent
nach einem Paket sauber stoppen und den Stand berichten kann.

## Paketstatus waehrend der Umsetzung

Diese Tabelle soll im Umsetzungs-Chat aktuell gehalten werden. Sie ist bewusst
kurz, damit nach jedem Arbeitspaket schnell sichtbar ist, was erledigt,
angefangen, blockiert oder noch offen ist.

Statuswerte:

- `offen`: noch nicht begonnen
- `in Arbeit`: begonnen, aber noch nicht abgeschlossen
- `blockiert`: fachliche Frage, technisches Hindernis oder Testproblem
- `umgesetzt`: Code/Doku fuer das Paket ist fertig
- `geprueft`: Paket ist umgesetzt und sinnvoll automatisch oder manuell
  geprueft

| Paket | Inhalt | Status | Letzte Aktualisierung | Notiz |
|---|---|---|---|---|
| 13a | Gemeinsame Wert-Auswertung fuer Einzelwerte | geprueft | 2026-08-14 | Repository-Summary fuer Zahl, Dauer, Uhrzeit, Statuszaehlungen und virtuelle reine-Tracking-Luecken ist umgesetzt. Statische Analyse ist gruen; externer PowerShell-Test `--plain-name "Wert-Auswertung"` lief mit `+3 All tests passed`. |
| 13b | Einzelwert-Auswertung in der Detailansicht | geprueft | 2026-08-16 | Wiederkehrende Wert-Aufgaben zeigen Verarbeitung, Werte und einfache Wertliste. Einmalige Wert-Aufgaben zeigen ihren Einzelwert. Statische Analyse ist gruen; App-Pruefung und Regression fuer einmalige reine Wert-Aufgaben sind bestaetigt. |
| 13c | Buendel-Auswertung, Erstellung und Buendel-Detailansicht | geprueft | 2026-08-19 | Buendel-Summary, Display-Helfer, Detailseite, Navigation aus der Buendelkarte und UI-Zugang ueber Aufgabenoption `Buendeln` sind umgesetzt. Externe PowerShell-Tests fuer Buendel-Auswertung und Kandidatenliste liefen mit `+1 All tests passed`. UX-Details der Buendel-Erstellung koennen spaeter separat verfeinert werden. |
| 13c.1 | Buendel-Erstellung, Anzeigeart und Tageszuordnung nachschaerfen | geprueft | 2026-08-19 | `Gilt ab`, Differenzrichtung, Anzeigeart, Cross-Day-Zuordnung, Uhrzeit-Datumszuordnung, verknuepfte Karten und gezielte Tests sind umgesetzt. Extern bestaetigt: `build_runner` schrieb 81 Outputs, `--plain-name "Bündel"` lief mit `+9 All tests passed`, gezielte Analyse lief mit `No issues found`. |
| 13d | Abschluss, Pruefung und Doku | geprueft | 2026-08-30 | Cleanup erledigt: ungenutzter Import in `task_value_bundle_versions_table.dart` entfernt. Gezielte Analyse dieser Datei ist gruen. Phase 13 ist fachlich abgeschlossen; offene UX-/Folgepunkte sind fuer spaeter gesammelt. Phase 14 ist der naechste aktive Schritt. |

Pflegehinweise:

- Nach jedem Paket mindestens `Status`, `Letzte Aktualisierung` und `Notiz`
  aktualisieren.
- Bei blockierten Tests nicht automatisch das Paket als gescheitert werten,
  sondern kurz notieren, welcher Test/Check haengt und welche manuelle Pruefung
  stattdessen sinnvoll ist.
- Wenn ein Paket nur teilweise fertig ist, `in Arbeit` lassen und in `Notiz`
  den naechsten konkreten Schritt festhalten.
- Erst `geprueft` setzen, wenn automatische Tests, gezielte manuelle App-Pruefung
  oder eine klar dokumentierte Ersatzpruefung erfolgt ist.

### 13a - Gemeinsame Wert-Auswertung fuer Einzelwerte

Ziel:

- Eine zentrale Berechnung fuer einzelne Wert-Aufgaben/Habits einfuehren.
- Zahl, Dauer und Uhrzeit fuer die bestehenden Zeitraeume auswerten.
- Fehlende reine Tracking-Tage virtuell ableiten.

Vorschlag:

- Neue Ergebnisstruktur wie `TaskValueAnalyticsSummary` pruefen/einfuehren.
- Optional neue Anzeige-Struktur wie `TaskValueAnalyticsDisplay` pruefen/einfuehren.
- Repository-Methoden in `AufgabenRepository` ergaenzen, z. B.:
  - `getTaskValueAnalyticsSummaryForPeriod`
  - `watchTaskValueAnalyticsSummaryForPeriod`
- Bestehende `TaskAnalyticsPeriod` wiederverwenden.

Umsetzungsschritte:

1. Aktuelle Wert- und Statusmodelle lesen.
2. Pruefen, ob eine bestehende Klasse sinnvoll erweitert werden kann.
3. Ergebnisfelder fuer Verarbeitung und Werte definieren.
4. Entries und `TaskEntryValue` fuer Aufgabe + Zeitraum laden.
5. Nur `recorded` Werte aggregieren.
6. `pending`, `no_entry`, `failure` separat zaehlen.
7. Fuer reine Trackings erwartbare Tage aus Startdatum, Rhythmus und Zeitraum
   ableiten und fehlende Tage virtuell zaehlen.
8. Sicherstellen, dass die Auswertung keine Entries schreibt.
9. Formatierungslogik fuer Zahl, Dauer und Uhrzeit vorbereiten oder sauber
   abgrenzen.

Stop-Kriterium:

- Einzelne Wert-Aufgaben liefern fuer alle bestehenden Zeitraeume plausible
  Verarbeitungs- und Wertkennzahlen.
- Es werden keine neuen Datenbankeintraege durch reine Auswertung erzeugt.

Umsetzungsstand 2026-08-14:

- `TaskValueAnalyticsSummary` und `TaskValueAnalyticsPoint` wurden eingefuehrt.
- `AufgabenRepository` liefert `getTaskValueAnalyticsSummaryForPeriod` und
  `watchTaskValueAnalyticsSummaryForPeriod`.
- Zahl-Werte werden in der eingegebenen Aufgaben-Einheit aggregiert.
- Dauer-Werte werden in Sekunden aggregiert.
- Uhrzeit-Werte nutzen `timeMinutes + dayOffset * 24 * 60`; Summe bleibt bei
  Uhrzeit bewusst leer.
- Nur `recorded` Werte fliessen in Summe, Durchschnitt, Minimum und Maximum ein.
- `pending`, `no_entry`, `failure` und nicht berechenbare `recorded` Entries
  werden separat gezaehlt.
- Reine Tracking-Luecken werden fuer faellige Tage im Zeitraum virtuell
  abgeleitet und nicht gespeichert.
- Die gezielte statische Analyse der betroffenen Dart-Dateien ist gruen.
- Der gezielte Flutter-Testlauf hing lokal in der Codex-Umgebung, wurde aber
  anschliessend extern in PowerShell bestaetigt:
  `+3 All tests passed`.

### 13b - Einzelwert-Auswertung in der Detailansicht

Ziel:

- Wert-Aufgaben/Habits in der Detailansicht sichtbar auswerten.
- Status-/Verarbeitungswerte und Wertkennzahlen getrennt anzeigen.

Vorschlag:

- `TaskDetailScreen` erweitern, ohne die bestehende Status-Detailansicht blind
  umzubauen.
- Bei Wert-Aufgaben zwei Abschnitte anzeigen:
  - `Verarbeitung`
  - `Werte`

Umsetzungsschritte:

1. Bestehende Detailansicht und Routing pruefen.
2. Fuer Wert-Aufgaben die neue Wert-Auswertung laden.
3. Zeitraum-Auswahl wie bestehende Status-Auswertung verwenden.
4. Abschnitt `Verarbeitung` anzeigen:
   erfasst, offen, kein Eintrag, verpasst, fehlende Tracking-Tage.
5. Abschnitt `Werte` anzeigen:
   Summe bei Zahl/Dauer, Durchschnitt, Minimum, Maximum.
6. Verlauf in Phase 13 als einfache Wertliste im Zeitraum vorbereiten, nicht als
   Diagramm oder Trendanalyse.
7. Einmalige Wert-Aufgaben als einfache Einzelwertdetails behandeln.
8. Info-Texte kurz und verstaendlich halten.
9. Bei nicht verfuegbaren Kennzahlen lieber erklaeren statt irrefuehrend 0
   zeigen.

Stop-Kriterium:

- Eine wiederkehrende Wert-Aufgabe zeigt zeitraumbezogene Verarbeitung und
  Wertkennzahlen.
- Eine einmalige Wert-Aufgabe zeigt ihren Einzelwert und konkrete Details.

Umsetzungsstand 2026-08-14:

- `TaskDetailScreen` unterscheidet nun zwischen normalen Status-Aufgaben und
  Wert-Aufgaben.
- Wiederkehrende Wert-Aufgaben/Habits zeigen:
  - Zeitraum-Auswahl
  - Abschnitt `Verarbeitung`
  - Abschnitt `Werte`
  - einfache `Wertliste` mit echten erfassten Werten
- Einmalige Wert-Aufgaben zeigen in den Aufgabendetails den gespeicherten
  Einzelwert.
- Die UI verwendet die bestehende ruhige Metric-Card-Darstellung weiter.
- Es wurde ein kleiner Repository-Stream fuer den letzten Entry inklusive
  `TaskEntryValue` ergaenzt.
- Die gezielte statische Analyse der betroffenen Dart-Dateien ist gruen.
- Noch offen ist eine kurze manuelle App-Pruefung mit Zahl-, Dauer- und
  Uhrzeit-Aufgaben.

### 13c - Buendel-Auswertung und Buendel-Detailansicht

Ziel:

- Buendel als eigene Auswertungsansicht verfuegbar machen.
- Teil-Trackings bleiben erreichbar und eigenstaendig auswertbar.

Vorschlag:

- Neue Detailseite wie `TaskValueBundleDetailScreen` pruefen/einfuehren.
- Bestehende Buendelberechnung aus `TaskValueBundleCalculation` wiederverwenden.
- Repository-Methode fuer Buendel + Zeitraum ergaenzen, falls noetig.

Umsetzungsschritte:

1. Bestehende Buendelmodelle und Feed-Navigation lesen.
2. Fuer jeden relevanten Tag im Zeitraum den Buendelstatus aktiver Buendel
   bestimmen.
3. Vollstaendige berechenbare Buendel aggregieren.
4. Teilweise, fehlende und nicht berechenbare Buendel separat zaehlen.
5. Buendel-Detailansicht mit Zeitraum-Auswahl bauen.
6. Zwei Navigationsoptionen zu den Teil-Trackings anzeigen.
7. Sicherstellen, dass die Teil-Trackings ihre normale Detailansicht nutzen.
8. Keine eigenen Buendel-Rohwerte speichern.

Stop-Kriterium:

- Klick auf eine Buendelkarte fuehrt zur Buendel-Auswertung.
- Die Buendel-Auswertung zeigt abgeleitete Kennzahlen und Statuszaehlungen.
- Beide Teil-Trackings sind von dort erreichbar.

Umsetzungsstand 2026-08-16:

- `TaskValueBundleAnalyticsSummary` und `TaskValueBundleAnalyticsPoint` wurden
  eingefuehrt.
- `TaskValueBundleAnalyticsDisplay` bereitet die Kennzahlen fuer Metric Cards
  auf.
- `AufgabenRepository` liefert:
  - `getTaskValueBundleAnalyticsSummaryForPeriod`
  - `watchTaskValueBundleAnalyticsSummaryForPeriod`
- Die Auswertung nutzt pro Tag die bestehende
  `calculateTaskValueBundle`-Logik.
- Gezaehlt werden:
  - vollstaendige Buendel
  - teilweise Buendel
  - fehlende Buendel
  - nicht berechenbare Buendel
- Nur vollstaendige und berechenbare Buendel gehen in Summe, Durchschnitt,
  Minimum und Maximum ein.
- Zeitintervall-Buendel erhalten keine Summe.
- `TaskValueBundleDetailScreen` zeigt Zeitraum, Verarbeitung, Werte,
  Tagesliste und Links zu beiden Teil-Trackings.
- Die Buendelkarte oeffnet die Detailansicht.
- Wert-Aufgaben/Habits zeigen in den Kartenoptionen `Buendeln`.
- Die Buendel-Erstellung startet aus einer bestehenden Wert-Aufgabe heraus,
  waehlt einen Buendeltyp und bietet nur passende zweite Wert-Trackings an.
- Es werden keine eigenen Buendel-Rohwerte gespeichert.
- Die gezielte statische Analyse der betroffenen Dateien ist gruen.
- Ein gezielter Repository-Test fuer Buendel-Auswertung ist ergaenzt; der
  lokale Testlauf hing in der Codex-Umgebung und soll extern in PowerShell
  bestaetigt werden.
- Ein gezielter Repository-Test fuer die Kandidatenliste der Buendel-Erstellung
  ist ergaenzt; der lokale Testlauf hing ebenfalls in der Codex-Umgebung und
  soll extern in PowerShell bestaetigt werden.

### 13c.1 - Buendel-Erstellung und Tageszuordnung nachschaerfen

Ausloeser:

Nach der ersten 13c-Umsetzung wurden in der App mehrere fachliche Luecken
sichtbar:

- Buendel koennen in der UI nicht bewusst rueckwirkend erstellt werden, obwohl
  `validFrom` technisch existiert.
- Differenz-Buendel haben technisch eine Richtung, aber die Erstellung bietet
  keine Auswahl.
- Zeitintervall-Buendel werden aktuell wie Same-Day-Buendel behandelt. Schlaf
  braucht aber oft den ersten Wert vom Vortag und den zweiten Wert am
  angezeigten Tag.
- Uhrzeit-Eingaben speichern zwar `dayOffset`, aber die UI macht die
  Datumszuordnung noch nicht sichtbar.
- Eine gemeinsame Buendelkarte passt nicht fuer alle Buendel. Cross-Day-Buendel
  wie Schlaf sollen als verknuepfte Einzelkarten erscheinen.

Ziel:

- Die bestehende Buendel-Logik gezielt nachschaerfen, ohne die bereits
  umgesetzte Wert-Auswertung breit zu ersetzen.
- Einzelne Uhrzeit-Aufgaben auch ohne Buendel verstaendlich machen.
- Buendel so erweitern, dass Same-Day- und Cross-Day-Faelle klar modelliert
  und angezeigt werden koennen.

#### Fachliche Regeln

##### Uhrzeit-Eingaben

- Jede Uhrzeit-Eingabe gehoert weiterhin zu genau einem angezeigten/geplanten
  Tag (`scheduledDate`).
- Die Uhrzeit selbst bekommt eine sichtbare Datumszuordnung:
  - Vortag: `dayOffset = -1`
  - gleicher Tag: `dayOffset = 0`
  - Folgetag: `dayOffset = 1`
- Standard ist `dayOffset = 0`.
- Die UI zeigt nicht nur `00:30`, sondern z. B. `00:30 am 13.08.`.
- Bei Bettgehzeit gilt als empfohlene Nutzung:
  - Die Bettgehzeit wird bei dem Tag gespeichert, den sie mit Schlaf beendet.
  - Beispiel: Bettgehzeit fuer den 12.08. kann `00:30 am 13.08.` sein.
- Mehrere Werte pro Aufgabe und `scheduledDate` bleiben nicht Teil von Phase
  13c.1. Der Fall wird spaeter ueber mehrere Sessions, Logbuch oder
  Messwert-Historie geloest.

##### Buendel-Startdatum

- Die Buendel-Erstellung bekommt ein Feld `Gilt ab`.
- Standard ist heute.
- Zusaetzliche Schnelloptionen:
  - Startdatum des ersten Trackings
  - Startdatum des zweiten Trackings
  - spaeteres Startdatum beider Trackings
  - eigenes Datum waehlen
- Die Kandidatenliste fuer das zweite Tracking muss gegen das ausgewaehlte
  `Gilt ab`-Datum geprueft werden.
- Rueckwirkendes Erstellen erzeugt keine neuen Entries. Es interpretiert nur
  vorhandene und zukuenftige Rohwerte ab `validFrom` als Buendel.

##### Differenzrichtung

- Nur Differenz-Buendel zeigen eine Rechenrichtungs-Auswahl.
- Optionen:
  - erster Wert minus zweiter Wert
  - zweiter Wert minus erster Wert
- Wenn Rollen oder Namen bereits gesetzt sind, soll die UI die Optionen
  verstaendlich mit Namen anzeigen, z. B. `Aufnahme - Verbrauch`.
- Standard bleibt `first_minus_second`, weil das der aktuelle technische
  Default ist.

##### Tageszuordnung bei Buendeln

- Summe- und Differenz-Buendel bleiben in Phase 13c.1 Same-Day-Buendel:
  erster und zweiter Wert gehoeren zum angezeigten Tag.
- Zeitintervall-Buendel bekommen eine Auswahl `Zuordnung der Teilwerte`:
  - beide Werte gehoeren zum selben angezeigten Tag
  - erster Wert gehoert zum Vortag, zweiter Wert zum angezeigten Tag
- Fuer Schlaf ist der angezeigte Tag standardmaessig der End-/Aufstehtag.
  Beispiel:
  - Buendeltag: 13.08.
  - Bettgehzeit: 12.08. abends oder 13.08. nachts
  - Aufstehzeit: 13.08. morgens

##### Anzeigeart

- Buendel bekommen eine Anzeigeart:
  - gemeinsame Buendelkarte
  - verknuepfte Einzelkarten
- Same-Day-Buendel duerfen die Anzeigeart frei waehlen.
- Cross-Day-Zeitintervall-Buendel muessen verknuepfte Einzelkarten nutzen.
- Bei verknuepften Einzelkarten bleiben beide Teil-Trackings im Feed sichtbar.
- Jede beteiligte Karte zeigt einen kleinen Buendel-Hinweis, z. B.
  `Teil von Schlafdauer`.
- Das Kartenmenue bietet eine Option, die Buendel-Auswertung zu oeffnen.
- Die genaue spaetere UI darf verfeinert werden; wichtig ist zunaechst die
  eindeutige Erreichbarkeit der Buendel-Auswertung.

##### Nutzerhinweise

- Bei Uhrzeit-Eingaben:
  `Das Datum zeigt, auf welchen Kalendertag sich die Uhrzeit bezieht.`
- Bei Cross-Day-Zeitintervall-Buendeln in der Erstellung:
  `Dieses Buendel verbindet den ersten Wert vom Vortag mit dem zweiten Wert am
  angezeigten Tag. Es wird als verknuepfte Einzelkarten angezeigt.`
- In der Detailauswertung reicht ein Info-Button oder kurzer Hinweis; kein
  langer Dauertext.

#### Technischer Vorschlag

Die bestehende Buendelversion sollte minimal erweitert werden. Voraussichtliche
neue Felder in `TaskValueBundleVersions`:

| Feld | Beispielwerte | Bedeutung |
|---|---|---|
| `displayMode` | `combined_card`, `linked_cards` | Wie die Teil-Trackings im Feed angezeigt werden. |
| `firstTaskDayOffset` | `-1`, `0` | Welcher relative Tag fuer den ersten Teilwert genutzt wird. |
| `secondTaskDayOffset` | `0` | Welcher relative Tag fuer den zweiten Teilwert genutzt wird. |

Migration fuer bestehende Buendel:

- `displayMode = combined_card`
- `firstTaskDayOffset = 0`
- `secondTaskDayOffset = 0`

Erlaubte Kombinationen in Phase 13c.1:

| Fall | `firstTaskDayOffset` | `secondTaskDayOffset` | `displayMode` |
|---|---:|---:|---|
| Same-Day gemeinsame Karte | 0 | 0 | `combined_card` |
| Same-Day verknuepfte Einzelkarten | 0 | 0 | `linked_cards` |
| Cross-Day Zeitintervall | -1 | 0 | `linked_cards` |

Nicht Teil von 13c.1:

- beliebige Offsets ausser `-1/0` fuer Buendelquellen
- Cross-Day-Summe oder Cross-Day-Differenz
- mehrere Werte pro Aufgabe und `scheduledDate`
- historisch datumsscharfe Rekonstruktion aufgeloester Buendel
- mehr als zwei Teil-Trackings

#### Voraussichtlich betroffene Dateien

Vorschlag, nicht starre Vorgabe:

- `lib/core/database/app_database.dart`
- `lib/core/database/app_database.g.dart`
- `lib/features/aufgaben/data/task_value_bundle_versions_table.dart`
- `lib/features/aufgaben/data/task_value_bundle.dart`
- `lib/features/aufgaben/data/task_value_bundle_calculation.dart`
- `lib/features/aufgaben/data/task_value_bundle_for_date.dart`
- `lib/features/aufgaben/data/task_value_bundle_analytics_summary.dart`
- `lib/features/aufgaben/data/task_value_bundle_analytics_display.dart`
- `lib/features/aufgaben/data/aufgaben_repository.dart`
- `lib/features/aufgaben/presentation/task_value_bundle_create_screen.dart`
- `lib/features/aufgaben/presentation/task_value_bundle_detail_screen.dart`
- `lib/features/aufgaben/presentation/widgets/task_value_bundle_card.dart`
- `lib/features/aufgaben/presentation/widgets/task_modes/value_task_input.dart`
- `lib/features/aufgaben/presentation/widgets/task_card.dart`
- `lib/features/aufgaben/presentation/aufgaben_screen.dart`
- `test/features/aufgaben/data/aufgaben_repository_test.dart`

#### Umsetzungsschritte

1. Bestehende Buendel- und Uhrzeit-Logik erneut kurz lesen. - umgesetzt
2. Konstanten fuer Anzeigeart und ggf. Tageszuordnung anlegen. - umgesetzt
3. Buendelversionstabelle um Anzeigeart und Tagesoffsets erweitern. - umgesetzt
4. Migration fuer bestehende Buendel ergaenzen. - umgesetzt
5. `TaskValueBundleCreateScreen` erweitern: - umgesetzt
   - `Gilt ab`
   - Differenzrichtung
   - Tageszuordnung fuer Zeitintervall
   - Anzeigeart
   - Hinweise fuer Cross-Day
6. Kandidatenliste bei Erstellung mit dem gewaehlen `Gilt ab`-Datum laden. - umgesetzt
7. Repository-Buendellogik so anpassen, dass pro angezeigtem Buendeltag die
   korrekten Teil-Entry-Daten gelesen werden:
   - Same-Day: beide Teilwerte am angezeigten Tag
   - Cross-Day: erster Teilwert am Vortag, zweiter Teilwert am angezeigten Tag
   - umgesetzt
8. Feed-Logik anpassen: - umgesetzt
   - `combined_card`: Teilkarten ausblenden, Buendelkarte anzeigen
   - `linked_cards`: Teilkarten sichtbar lassen, Buendel-Hinweis und
     Menueaktion anbieten
9. Uhrzeit-Eingabe-UI um sichtbare Datumszuordnung erweitern. - umgesetzt
10. Buendel-Detailansicht und Tagesliste auf die neue Tageszuordnung pruefen. - geprueft durch gezielte Tests und Analyse; kurze App-Sichtpruefung bleibt als manuelle Empfehlung
11. Gezielte Tests ergaenzen. - umgesetzt und extern bestaetigt
12. Doku/Status aktualisieren. - umgesetzt

Aktueller technischer Stand:

- Schema-Version wurde auf 16 vorbereitet.
- Bestehende Buendel werden per Migration als Same-Day + gemeinsame Karte
  weitergefuehrt.
- `TaskValueBundleVersions` bekommt:
  - `displayMode`
  - `firstTaskDayOffset`
  - `secondTaskDayOffset`
- `createValueBundle` validiert die erlaubten Kombinationen.
- Same-Day-Buendel koennen als gemeinsame Karte oder verknuepfte Einzelkarten
  erstellt werden.
- Cross-Day-Buendel sind in Phase 13c.1 nur fuer Zeitintervalle erlaubt und
  erzwingen verknuepfte Einzelkarten.
- Die Buendel-Auswertung liest fuer Cross-Day den ersten Teilwert vom Vortag
  und den zweiten Teilwert vom angezeigten Tag.
- Uhrzeit-Eingaben zeigen Vortag / gleicher Tag / Folgetag und speichern
  weiterhin `dayOffset = -1/0/+1`.
- Lokale `dart format`-Pruefung lief durch.
- Externe PowerShell-Bestaetigung:
  - `dart run build_runner build`: erfolgreich, 81 Outputs geschrieben
  - `flutter test --no-pub test\features\aufgaben\data\aufgaben_repository_test.dart --plain-name "Bündel"`: `+9 All tests passed`
  - gezielte `flutter analyze`-Pruefung der betroffenen Dateien: `No issues found`

#### Stop-Kriterium

- Buendel koennen mit bewusstem `Gilt ab`-Datum erstellt werden.
- Differenzrichtung ist in der UI waehlbar und wird korrekt gespeichert.
- Same-Day-Buendel koennen gemeinsame Karte oder verknuepfte Einzelkarten
  nutzen.
- Cross-Day-Zeitintervall-Buendel nutzen verknuepfte Einzelkarten.
- Uhrzeit-Eingaben zeigen und speichern Vortag/gleicher Tag/Folgetag.
- Schlaf-Beispiel ist fachlich moeglich:
  Bettgehzeit fuer 12.08. = `00:30 am 13.08.`;
  Aufstehzeit fuer 13.08. = `07:30 am 13.08.`;
  Buendel am 13.08. verbindet Bettgehzeit vom Vortag mit Aufstehzeit am
  angezeigten Tag.

#### Empfohlene Tests

Automatisiert bevorzugt:

- Migration setzt bestehende Buendel auf Same-Day + gemeinsame Karte.
- Buendel-Erstellung speichert `validFrom` aus dem gewaehlen `Gilt ab`.
- Kandidatenliste nutzt das gewaehlt Startdatum.
- Differenzrichtung `first_minus_second` und `second_minus_first` liefert
  unterschiedliche korrekte Ergebnisse.
- Same-Day-Buendel bleibt kompatibel zur bisherigen Berechnung.
- Same-Day-Buendel mit `linked_cards` blendet Teilkarten nicht aus.
- Cross-Day-Zeitintervall liest ersten Teilwert vom Vortag und zweiten Teilwert
  vom angezeigten Tag.
- Cross-Day-Zeitintervall darf keine gemeinsame Buendelkarte anzeigen.
- Uhrzeit-Eingabe speichert `dayOffset = -1/0/+1`.
- Buendel-Auswertung aggregiert Cross-Day-Punkte anhand des angezeigten Tages.

Manuell sinnvoll:

- Uhrzeit am Folgetag eingeben und Anzeige `am DATUM` pruefen.
- Rueckwirkendes Buendel erstellen und alte vorhandene Werte in der Auswertung
  sehen.
- Differenzrichtung in der Erstellung wechseln und Ergebnis pruefen.
- Same-Day-Buendel als gemeinsame Karte pruefen.
- Same-Day-Buendel als verknuepfte Einzelkarten pruefen.
- Cross-Day-Schlafbuendel erstellen und pruefen, dass keine gemeinsame
  Buendelkarte erscheint.
- Ueber das Menue einer verknuepften Einzelkarte die Buendel-Auswertung oeffnen.

### 13d - Abschluss, Pruefung und Doku

Ziel:

- Phase 13 als umgesetzten, geprueften Ausbaustand abschliessen.

Aktueller Stand vor 13d:

- 13a, 13b, 13c und 13c.1 sind laut Doku umgesetzt und geprueft.
- 13c.1 wurde extern bestaetigt:
  - `dart run build_runner build`: erfolgreich; 81 Outputs geschrieben.
  - `flutter test --no-pub test\features\aufgaben\data\aufgaben_repository_test.dart --plain-name "Bündel"`: `+9 All tests passed`.
  - gezielte Analyse der damals betroffenen Dateien: `No issues found`.
- Eine erneute gezielte Analyse am 30.08.2026 fand noch eine kleine Warnung:
  - `lib\features\aufgaben\data\task_value_bundle_versions_table.dart`: ungenutzter Import `task_value_bundle.dart`.
- Dieser Befund ist kein fachlicher 13c-Blocker, sollte aber als erster
  13d-Cleanup erledigt werden, damit Phase 13 sauber abgeschlossen werden kann.

Offene fachliche Fragen vor 13d:

- Keine blockierende Fachfrage sichtbar.
- Die groesseren Entscheidungen zu Rohdaten, berechneten Auswertungen,
  `scheduledDate`, `dayOffset`, Cross-Day-Buendeln, Anzeigeart und
  Differenzrichtung sind getroffen und im Code erkennbar umgesetzt.

Offene technische/UX-Punkte fuer 13d:

- Kleinen Analyze-Cleanup erledigen:
  - ungenutzten Import in `task_value_bundle_versions_table.dart` entfernen.
- Pruefen, ob die Buendel-Erstellung fuer Nutzende verstaendlich genug ist:
  - `Gilt ab`
  - Startdatum-Schnelloptionen
  - zweites Tracking
  - Differenzrichtung
  - Tageszuordnung bei Zeitintervall
  - Anzeigeart
- Speziell beachten: Die Schnelloption `Start zweites Tracking` kann erst
  erscheinen, wenn ein zweites Tracking gewaehlt wurde. Das ist technisch
  nachvollziehbar, sollte aber in der manuellen Sichtpruefung bewertet werden.
  Wenn es verwirrt, als UX-Feinschliff fuer spaeter notieren statt Phase 13
  erneut auszuweiten.
- Pruefen, ob die Uhrzeit-Datumszuordnung fuer Nutzende klar genug ist:
  - Vortag
  - gleicher Tag
  - Folgetag
  - sichtbares Datum neben der Auswahl
- Pruefen, ob verknuepfte Einzelkarten den Buendelzusammenhang ausreichend
  sichtbar machen und die Buendel-Auswertung erreichbar ist.
- Keine weiteren Schemaaenderungen fuer 13d planen, ausser ein echter
  Code-/Migrationsfehler wird gefunden.

Umsetzungsschritte:

1. Aktuellen Code kurz lesen, aber nicht breit refactoren.
2. Unused-Import-Warnung in
   `lib\features\aufgaben\data\task_value_bundle_versions_table.dart`
   entfernen.
3. `dart format` nur fuer geaenderte Dart-Dateien ausfuehren.
4. Gezielte Analyse der Phase-13-Dateien ausfuehren. Wenn die Umgebung haengt,
   Ergebnis dokumentieren und PowerShell-Pruefung vorbereiten.
5. Keine breiten Testlaeufe erzwingen, wenn sie in Codex/VS Code wieder haengen.
   Stattdessen bevorzugt:
   - vorhandene externe `Bündel`-Bestaetigung anerkennen
   - gezielte Tests nur wiederholen, wenn Code geaendert wurde oder Zweifel
     bestehen
   - manuelle App-Pruefung nutzen
6. Manuelle Pruefcheckliste vorbereiten oder mit dem Nutzer abarbeiten.
7. `value_analytics_history.md` mit Abschluss, Code-Cleanup, Pruefung und
   verbleibenden Folgepunkten aktualisieren.
8. `value_analytics_plan.md` Paketstatus fuer 13d aktualisieren:
   - `umgesetzt`, wenn Doku/Cleanup erledigt ist, aber Sichtpruefung fehlt
   - `geprueft`, wenn automatische oder manuelle Pruefung nachvollziehbar
     dokumentiert ist
   - `blockiert`, wenn ein Test-/App-Problem nicht geklaert werden kann
9. Erst wenn Phase 13 wirklich abgeschlossen ist, `task_structure_plan.md`
   minimal auf Phase 14 als naechsten aktiven Schritt umstellen.
10. Phase 14/15 nicht in Phase 13 implementieren. Nur sauber uebergeben.

Empfohlene automatische Pruefung fuer 13d:

- Minimal nach Cleanup:
  - `flutter analyze lib\core\database\app_database.dart lib\features\aufgaben\data\aufgaben_repository.dart lib\features\aufgaben\data\task_value_bundle_versions_table.dart lib\features\aufgaben\data\task_value_bundle.dart lib\features\aufgaben\data\task_value_bundle_calculation.dart lib\features\aufgaben\data\task_value_bundle_for_date.dart lib\features\aufgaben\data\task_value_bundle_analytics_summary.dart lib\features\aufgaben\data\task_value_bundle_analytics_display.dart lib\features\aufgaben\presentation\task_value_bundle_create_screen.dart lib\features\aufgaben\presentation\task_value_bundle_detail_screen.dart lib\features\aufgaben\presentation\widgets\task_value_bundle_card.dart lib\features\aufgaben\presentation\widgets\task_modes\value_task_input.dart lib\features\aufgaben\presentation\widgets\task_card.dart lib\features\aufgaben\presentation\aufgaben_screen.dart test\features\aufgaben\data\aufgaben_repository_test.dart`
- Optional, wenn stabil:
  - `flutter test --no-pub test\features\aufgaben\data\aufgaben_repository_test.dart --plain-name "Bündel"`
- Wenn Tests haengen:
  - nicht lange debuggen, solange kein fachlicher Fehler sichtbar ist
  - stattdessen PowerShell-Befehl fuer den Nutzer dokumentieren

Empfohlene manuelle Sichtpruefung fuer 13d:

- Uhrzeit-Wert mit `Folgetag` speichern und pruefen, ob das angezeigte Datum
  plausibel ist.
- Rueckwirkendes Buendel erstellen:
  - `Gilt ab` auf ein vergangenes Datum setzen
  - pruefen, ob vorhandene alte Werte in der Buendel-Auswertung erscheinen
- Differenz-Buendel erstellen:
  - beide Rechenrichtungen vergleichen
  - Ergebnis plausibel pruefen
- Same-Day-Buendel als gemeinsame Buendelkarte pruefen:
  - Teilkarten werden ausgeblendet
  - Buendelkarte zeigt beide Eingaben und Ergebnis
  - Buendel-Detailansicht oeffnet
- Same-Day-Buendel als verknuepfte Einzelkarten pruefen:
  - Teilkarten bleiben sichtbar
  - `Teil von ...` ist sichtbar
  - Menueaktion `Buendel-Auswertung` oeffnet die Detailansicht
- Cross-Day-Schlafbuendel pruefen:
  - erster Wert vom Vortag, zweiter Wert am angezeigten Tag
  - keine gemeinsame Buendelkarte
  - beide Einzelkarten zeigen den Buendel-Hinweis
  - Buendel-Auswertung rechnet die Schlafdauer am Aufstehtag
- Buendel aufloesen:
  - aktive Buendel verschwinden
  - Teiltrackings bleiben erhalten
  - keine Rohwerte werden geloescht

Folgepunkte, die 13d nur sammeln soll:

- UX der Startdatum-Schnelloptionen in der Buendel-Erstellung.
- Feinere Erklaertexte fuer Schlaf-/Cross-Day-Tracking.
- Mehrere Werte pro Aufgabe und Tag.
- Logbuch, Profiling oder Diagnostik fuer Messwerte.
- Custom-Zeitraeume, Charts, Trends und Wochen-/Monatsvergleiche.
- Historische Rekonstruktion alter aufgeloester Buendel.

Stop-Kriterium:

- Die gezielte Analyze-Warnung ist entfernt oder bewusst dokumentiert.
- Automatische oder manuelle Pruefung ist nachvollziehbar dokumentiert.
- Offene Punkte sind klar als Folgefragen notiert.
- `task_structure_plan.md` zeigt erst dann Phase 14 als aktiv, wenn Phase 13d
  abgeschlossen ist.

Umsetzungsstand 2026-08-30:

- Der ungenutzte Import
  `package:momentum/features/aufgaben/data/task_value_bundle.dart` wurde aus
  `task_value_bundle_versions_table.dart` entfernt.
- Die gezielte Analyse lief danach erfolgreich:
  `flutter analyze lib\features\aufgaben\data\task_value_bundle_versions_table.dart`
  mit `No issues found`.
- Es wurden keine neuen Fachregeln und keine neuen Datenbankfelder eingefuehrt.
- Die bereits extern bestaetigten Phase-13-Pruefungen bleiben Grundlage:
  - Buendel-Tests: `+9 All tests passed`
  - gezielte Phase-13-Analyse: `No issues found`
  - Build-Runner fuer generierte Drift-Dateien: erfolgreich
- Phase 13 gilt damit als abgeschlossen.
- Offene UX- und Ausbaustellen bleiben bewusst Folgepunkte und werden nicht mehr
  in Phase 13 erweitert.
- Der naechste fachliche Schritt ist Phase 14: Zielbewertung auf Basis der
  vorhandenen Status- und Wert-Auswertungen.

## Empfohlene Teststrategie

Diese Tests sind Empfehlungen, keine starre Pflichtliste. In bisherigen Chats
gab es teils Probleme mit Testlaeufen in VS Code. Der Umsetzungs-Chat soll
pragmatisch testen, Ergebnisse klar berichten und bei Umgebungshaengern gezielt
PowerShell- oder App-Pruefungen anfordern.

### Automatisiert bevorzugt

- Zahl: `recorded` Werte im Zeitraum zaehlen, Summe, Durchschnitt, Minimum und
  Maximum berechnen.
- Dauer: Summe, Durchschnitt, Minimum und Maximum berechnen.
- Uhrzeit: Durchschnitt, Minimum und Maximum mit `dayOffset` korrekt berechnen.
- Reines Tracking: virtuelle fehlende Tage im Zeitraum zaehlen, ohne Entries zu
  schreiben.
- Verbindliche Wert-Eingabe: `pending`, `failure`, `no_entry` und `recorded`
  getrennt zaehlen; nur `recorded` fliesst in Wertaggregate.
- Zeitraumfilter: letzte 7/20/30 Tage und seit Beginn verwenden
  `scheduledDate`.
- Buendel-Zeitintervall: nur vollstaendige berechenbare Buendel aggregieren.
- Buendel-Differenz und -Summe: abgeleitete Werte korrekt aggregieren.
- Teilweise, fehlende und nicht berechenbare Buendel separat zaehlen.
- Auswertung erzeugt keine kuenstlichen Entries.

### Manuell sinnvoll

- Detailansicht einer Zahl-Aufgabe oeffnen.
- Detailansicht einer Dauer-Aufgabe oeffnen.
- Detailansicht einer Uhrzeit-Aufgabe mit Folgetag-Anzeige pruefen.
- Zeitraum wechseln und Plausibilitaet der Werte pruefen.
- Buendelkarte oeffnen.
- Buendel-Detailansicht pruefen.
- Von der Buendel-Detailansicht zu beiden Teil-Trackings navigieren.
- Einen alten Wert aendern und pruefen, ob die Auswertung neu plausibel ist.

## Uebergabe an den Umsetzungs-Chat

Empfohlener Start:

1. Dieses Dokument lesen.
2. `value_analytics_concept.md`, `task_analytics_matrix.md` und die betroffenen
   Codepfade kurz gegen den aktuellen Stand pruefen.
3. Bestehende Logik bevorzugt erweitern.
4. Umsetzung in Paketen 13a bis 13d abarbeiten.
5. Nach jedem Paket kurz pruefen und berichten.

Wichtige Leitplanken fuer den Umsetzungs-Chat:

- Keine gespeicherten Aggregate, Rollups oder Verlaufspunkte einfuehren.
- Keine Schemaaenderung ohne klares Rohdatenloch.
- Keine Projekt-, Logbuch-, Profil- oder Diagnostikplattform aus Phase 13
  machen.
- Keine Zielbewertung oder Kartenkennzahl in Phase 13 bauen.
- Keine alte Logik blind ersetzen.
- Bei fachlicher Unsicherheit stoppen und fragen.
- Tests als Vorschlag behandeln und an die stabile lokale Umgebung anpassen.

## Bewusst nicht Teil von Phase 13

- neue Eingabearten erfinden
- Skalen technisch einfuehren
- Zielbewertung selbst
- Kartenkennzahl selbst
- Firebase-Synchronisierung
- gespeicherte Aggregate/Rollups/Materialized Views
- mehrere Sessions pro Tag
- eigene Einheitenverwaltung
- freie Custom-Zeitraeume
- Trendgrafiken oder Verlaufscharts
- Wochen-/Monatsvergleich
- Ausreisser-Erkennung
- Logbuch oder Messwert-Historie
- Profil- oder Diagnostikmodul
- Projekt-/Gesamtauswertung ueber mehrere Aufgaben hinweg
- globale Sammelauswertung fehlender Tracking-Tage

## Spaetere Notizen

- Bestehende Doku enthaelt teils kaputte Sonderzeichen. Das wird in Phase 13
  nicht bereinigt, sollte aber bei einer spaeteren Doku-Pflege separat
  aufgegriffen werden.
- Fuer Messwerte wie Gewicht, Puls, Blutdruck, Schmerz, Stimmung oder Profilwerte
  spaeter klaeren, ob sie langfristig in Aufgaben/Habits bleiben oder besser in
  Profil, Diagnostik, Logbuch oder einen eigenen Messwertbereich gehoeren.
- Fuer Vorlagen spaeter sinnvolle Defaults und fachlich strengere Empfehlungen
  definieren, ohne freie Nutzerkonfiguration unnoetig einzuschraenken.
