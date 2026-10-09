# Momentum – Phase 15: Kennzahl auf Aufgaben-/Habit-Karten

Stand: 17. September 2026  
Status: 15a bis 15d abgeschlossen und extern bestätigt

## 1. Auftrag, Umfang und Entscheidungsstand

Dieser Chat plant ausschließlich. Die Umsetzung erfolgt in einem anderen Chat.
Der Nutzer hat kleinere, leicht änderbare Entscheidungen an den planenden Agenten
delegiert; Rückfragen sollen sich auf grundlegende Produkt- und Datenentscheidungen
beschränken. Dokumentänderungen werden gebündelt.

**Vom Nutzer bestätigt:**

- Die tägliche Übersicht enthält Eingabefelder und eine kompakte Ergebnisanzeige.
- Die ausführliche Analyse gehört auf eine eigene Seite je Aufgabe.
- Angezeigte Kennzahlen sind bereits in Phase 15 frei wählbar.
- Ein gesetztes Ziel liefert zunächst die passende Kennzahl: etwa den tatsächlichen
  Durchschnitt der letzten sieben Tage bei einem entsprechenden Kalorienziel.
- Langfristig ein bis maximal zwei Werte; die genaue Anzahl ist für den ersten
  Testlauf nachrangig und soll später leicht erweiterbar sein.
- Vergangene Tagesansichten betrachten den damals endenden Zeitraum aus dem
  heute gespeicherten, gegebenenfalls korrigierten Datenbestand. Keine eingefrorenen
  Momentaufnahmen. Nachträgliche Korrekturen dürfen die Auswertung verändern.
- Lokal rechnen, unnötige Reads und insbesondere Cloud-Zugriffe vermeiden.
  Schnelle Nutzbarkeit hat Vorrang vor UI-Feinschliff.

**Im delegierten Rahmen für diesen Umsetzungsschnitt festgelegt:**

- Zunächst ein frei wählbarer Kennzahlplatz; Speicherung als geordnete Liste,
  sodass ein zweiter Platz später keine neue Grundstruktur verlangt.
- Auswahl gilt pro Aufgabe/Habit bzw. pro Bündel, nicht pro Tagesinstanz.
  Auch alte Tagesansichten verwenden die aktuell gewählte Anzeigeeinstellung.
- Anzeigeänderungen erzeugen keine fachliche Definitionsversion.
- „Passend zum Ziel“ folgt dem am Stichtag gültigen Ziel; eine ausdrücklich
  gewählte Statistik samt Zeitraum bleibt von Zieländerungen unabhängig.
- „Keine Kennzahl“ ist erlaubt, auch bei gesetztem Ziel. Eingabefeld und
  Detailanalyse bleiben zugänglich.
- Eine kleine Auswahl vorhandener Berechnungen genügt. Keine neuen Zieltypen,
  keine Diagramme, Streaks, globale Defaults oder frei zusammenstellbaren Dashboards.

Diese Regeln ersetzen den eigenmächtig verengten Release-Schnitt vom
15. September. Dessen Umsetzung und damalige Testberichte bleiben im
[Verlauf](card_metric_history.md) dokumentiert; sie sind keine Abnahme dieses Plans.

## 2. Bestand und Wiederverwendung

| Bereich | Nachgewiesener Stand / Konsequenz |
|---|---|
| Detailanalyse | `TaskDetailScreen`: Status-/Wertauswertung, Zeitraumwahl, Wertliste und Zielabschnitte; `TaskValueBundleDetailScreen`: Bündelauswertung und Teilaufgaben. Grundlagen aus Phase 7/11, 13 und 14 wiederverwenden. |
| Kartenmodell | `TaskCardMetric` enthält Label, Wert, Detail und Tonalität. Es ist ein berechnetes Ergebnis, keine gespeicherte Auswahl. |
| Listen | `AufgabenRepository.watchTaskListForDate`, `watchTasksByUrgency`, `watchCompletedOneTimeTasks` reichern Karten an. |
| Prototyp | `_taskCardMetricFor` / `_bundleCardMetricFor`: Ziel vor Instanzwert/Status bzw. Bündelergebnis. Keine Statistik-Auswahl oder entsprechende Persistenz. |
| UI | `TaskCard` und `TaskValueBundleCard` nutzen `CardMetricChip`; Einbaupunkte behalten. |
| Berechnungen | Status-, Wert-, Bündel- und Ziel-Summaries existieren. `TaskAnalyticsPeriod`: letzte 7/20/30 Tage, seit Beginn. |
| Datenbank | Drift/SQLite, Schema 17 beim Planungsstand. Aufgaben-, Ziel- und Bündelversionen vorhanden. |
| Bisherige Tests | Drei explizite Kartenkennzahl-Repositorytests: Ziel vor Wert, Einzelwert ohne Ziel, Bündelergebnis ohne Ziel. Im Planungs-Chat gelesen, nicht erneut ausgeführt. |

Konkrete Korrekturen am Prototyp:

- `_metricFromValueGoalSummary` nennt `reachable` pauschal „Auf Kurs“.
  Bei Wertzielen bedeutet es aber „Erreicht mit Datenlücke“. Die bestehenden
  zielartspezifischen Display-Regeln verwenden.
- Zielchip zeigt bisher keinen Zeitraum und keine Datenbasis. Beides ergänzen.
- `CardMetricChip` verwendet eine unflexible Row: schmale Karten und große
  Schrift brauchen Umbruch; Warntexte nicht abschneiden.
- Listen laden Kennzahlen derzeit nacheinander pro Karte; wiederholte Instanzen
  derselben Aufgabe dürfen nicht identische Analysen erneut laden.
- Aufgabenlisten beobachten Definitions-/Bündeltabellen nicht durchgehend.
  Neue Einstellungen und wirksame Zieländerungen müssen ohne Neustart ankommen.

Lesestand: Dokumentstruktur und Querverweise, zentrale Regeln, Phase-13/14/15/19-
Schnittstellen und betroffene Karten-, Repository-, Schema-, Versionsschreiber-
und Teststellen geprüft. Kein vollständiger Audit aller Module oder sämtlicher
historischer Dokumentabschnitte. Veraltete Phasennummern in alten Texten sind
keine zweite Spezifikation.

## 3. Auswahl und Defaults

Stabile technische Kennzahlschlüssel verwenden, keine übersetzten Labels speichern.
Nur fachlich passende Optionen anbieten; fehlende Messdaten allein sperren die
Auswahl nicht. Vorläufiger kleiner Katalog:

| Schlüssel | Verfügbar für | Berechnungsquelle |
|---|---|---|
| `goal` | Wiederkehrende Status-/Wertaufgabe oder Bündel mit unterstütztem Ziel | Bestehende Status-/Wertziel-Summary; Wertziel: tatsächliche Summe/Durchschnitt, Statusziel: Erfolge gegenüber Soll |
| `strict_success_rate` | Wiederkehrende Statusaufgabe | `TaskAnalyticsSummary.strictSuccessRate`, mit Zähler/Nenner |
| `success_count` | Wiederkehrende Statusaufgabe | `successCount` |
| `average` | Wiederkehrende Zahl/Dauer/Uhrzeit; berechenbares Bündel | `average` der jeweiligen Wert-/Bündel-Summary |
| `sum` | Wiederkehrende Zahl/Dauer; Summen-/Differenzbündel | `sum`; keine Uhrzeitsumme, keine Summe von Zeitintervallbündeln |
| `entry_value` | Wertaufgabe, auch einmalig | Wert der dargestellten Instanz, keine Suche nach einem älteren „letzten Wert“ |
| `entry_status` | Status-/Wertaufgabe, auch einmalig | Status der dargestellten Instanz |
| `bundle_result` | Gemeinsame Bündelkarte | Ergebnis dieses Bündeltages; keine Zusammenrechnung unvollständiger Paare |

Weitere bereits existierende Kennzahlen bleiben in der Detailanalyse und können
später in diesen Katalog aufgenommen werden, ohne die gespeicherten IDs zu ändern.

Defaults für neue und bestehende Aufgaben ohne gespeicherte Auswahl:

1. Unterstütztes Ziel am Stichtag: `goal`.
2. Wiederkehrende Statusaufgabe ohne Ziel: strenge Erfolgsquote, 7 Tage.
3. Wiederkehrende Wertaufgabe ohne Ziel: Durchschnitt, 7 Tage.
4. Gemeinsames Bündel ohne Ziel: Durchschnitt, 7 Tage.
5. Einmalige Statusaufgabe: Instanzstatus; einmalige Wertaufgabe: Instanzwert.

„Standard“ ist eine ausdrückliche Rücksetzoption. Eine manuelle Auswahl wird durch
Hinzufügen/Ändern eines Ziels niemals überschrieben. Explizit gewähltes `goal`
ohne gültiges Ziel zeigt „Kein Ziel für diesen Tag“ und bleibt gespeichert.
Eine inzwischen unpassende Auswahl zeigt „Kennzahl hier nicht verfügbar“ mit
Änderungsweg; kein stiller Wechsel zu einer anderen Statistik.

Bündel:

- Gemeinsame Karte verwendet die Einstellung der stabilen Bündel-ID.
- Verknüpfte Einzelkarten verwenden jeweils ihre eigene Aufgabeneinstellung.
  Ihre bisherigen Bündelhinweise bleiben; kein zusätzlicher Statistikplatz.
- Verborgene Teilaufgaben behalten ihre Einstellung. Auflösen des Bündels lässt
  ihre ursprüngliche Auswahl wieder sichtbar werden.
- Bündel-Auswahl ist über die Bündeldetailseite erreichbar, auch wenn derzeit
  verknüpfte Einzelkarten dargestellt werden. Keine historisch vollständige
  Rekonstruktion aufgelöster Bündel in Phase 15.

## 4. Zeitraum, Stichtag und Datenwahrheit

Drei getrennte Begriffe verwenden:

- **Anzeigekonfiguration:** welche Kennzahl mit welchem Zeitraum gewünscht ist.
- **Stichtag:** bis zu welchem Tag gerechnet wird.
- **Datenbestand:** aktuell gespeicherte Rohdaten; kein „damals bekannter“ Stand.

Für frei gewählte Zeitraumstatistiken zunächst die vorhandenen Optionen
7/20/30 Tage und seit Beginn anbieten. `goal` verwendet ausschließlich die
gültige Zielspanne, auch wenn diese z. B. 14 Tage beträgt. Instanzwert/-status
und Bündeltagesergebnis haben keinen Statistikzeitraum.

- Tagesliste: Stichtag = ausgewählter Tag.
- Dringlichkeitsliste: Stichtag = heute; die ursprüngliche Fälligkeit eines
  Carryover-Eintrags verschiebt den Statistikzeitraum nicht.
- Instanzwert/-status bezieht sich immer auf genau die dargestellte Instanz.
  Unterschied zwischen Fälligkeit und Statistikstichtag nicht verwischen.
- Zukunfts-Tagesansicht: keine Prognose; Zeitraumstatistik bis heute rechnen
  und sichtbar „Stand heute“ kennzeichnen. Noch nicht gestartete Aufgaben
  liefern keine Daten. Instanzstatus/-wert bleibt der dargestellten Instanz zugeordnet.
- Abgeschlossene einmalige Aufgaben: Einzelwert/-status, keine Zeitreihenstatistik.
- Rückblick 10. September mit 7 Tagen: 4.–10. September einschließlich.
  Korrektur eines Eintrags am 7. September verändert diese Auswertung.
- Auswertungsansicht und Kartenkonfiguration unabhängig halten:
  bloßes Umschalten des Zeitraums auf der Detailseite ändert die Karte nicht.
- Lokal-normalisierte Kalendertage und vorhandene Tageszuordnung verwenden;
  keine neue UTC-/Zeitzonenlogik. Bei Bündeln bestehende Quelltags-Offsets beachten.

Vorhandene Datenregeln bleiben verbindlich:

- Nur `success` ist Status-Erfolg. Quoten aus bestehender Summary übernehmen;
  `pending` nicht zusätzlich in den Nenner aufnehmen.
- Nur echte `recorded` Werte aggregieren. Keine Ersatznull für offene, verpasste,
  fehlende oder nicht berechenbare Werte.
- Bündelstatistik nur aus vollständigen, berechenbaren Paaren.
- Keine Daten ist nicht Null. Echte Zählwerte von Null dürfen angezeigt werden.
- Zielbewertung nutzt am Stichtag wirksame Zieldefinition; zukünftige geplante
  Änderungen dürfen weder zu früh erscheinen noch den alten Zieltyp verwenden.
  Im Prototyp wird vor dem Versionsladen auf `task.goalType` verzweigt:
  diese Entscheidung hinter die Auflösung der gültigen Definition verlegen.
- Bereits vorhandene Vergleichsoperatoren beibehalten: „Höchstens-Durchschnitt“
  bedeutet inklusive Grenzwert. Das umgangssprachliche Kalorienbeispiel führt
  keinen neuen strikt-kleiner-Zieltyp ein.

### Schutz bei fachlichen Änderungen / Grenze zu Phase 16

Reine Kartenänderungen sind nicht historisiert. Rohdaten und fachliche
Definitionsversionen bleiben dagegen erhalten.

Befund: `_analyticsValueFor` liest Zahlen derzeit direkt aus `numberValue`
anhand der übergebenen aktuellen Aufgabe; es prüft nicht durchgehend historische
Einheiten. Die Bearbeitungsseite erlaubt Änderungen an Wertart/Einheit.
Daraus darf die Karte keine scheinbar korrekte Mischstatistik erzeugen.

Minimaler Schutz für Phase 15:

- Vor Anzeige einer Wertaggregation einschließlich Wertziel prüfen, ob Daten
  und relevante Definitionen hinsichtlich Wertart/Einheit zusammenpassen.
- Bei gemischten oder zur Berechnungskonfiguration unpassenden Typen/Einheiten
  keine Zahl ausgeben; neutral „Auswertung nach Änderung nicht verfügbar“.
  Keine stillschweigende Umrechnung, Teilmengenauswahl oder Ersatznull.
- Für reine Tracking-Lücken zusätzlich auf Änderungen des erwarteten Rhythmus
  im Fenster achten: keine ungesicherte Aussage „vollständig“. Im unklaren
  Änderungsfall ebenfalls den neutralen Schutzpfad verwenden.
- Vergleich anhand fachlicher Felder, nicht allein unterschiedlicher
  Versionsnummern; Name, Projekt oder reine Zieländerung sperren normale
  Wertstatistik nicht.
- Den Schutz auf bereits geladene Rohdaten/Definitionen stützen. Bestehende
  Rechenformeln nicht als zweite Karten-Analytics implementieren.
- Verfügbare normale Fälle bleiben nutzbar. Vollständige Auswertung über
  solche fachlichen Änderungen, Einheitenkonvertierung und Rekonstruktion
  aufgelöster Bündel bleiben Phase 16. Die vorhandene Detailanalyse wird durch
  diesen Kartenschutz nicht rückwirkend als vollständig korrigiert behauptet.

## 5. Speicherung und klare technische Grenze

Eine kleine separate Drift-Tabelle `TaskCardMetricPreferences` verwenden:

- `id`: stabile abgeleitete ID, z. B. `task:<id>` oder `bundle:<id>`.
- `taskId` bzw. `bundleId`: genau eines gesetzt; Fremdschlüssel auf die
  bestehende Stammtabelle, jeweils eindeutig. Physisches Löschen kaskadiert;
  Deaktivieren erhält die Einstellung.
- `configJson`: versionierte, typisiert gelesene Konfiguration.
- `updatedAt`: nur bei echter Änderung, als Ansatzpunkt für späteres Sync.
- Keine Zeile bedeutet Default; „Standard“ entfernt eine vorhandene Zeile.
  Tombstones/Konfliktregeln hierfür gehören zur späteren Sync-Implementierung.

Beispiele für `configJson`:

```json
{"version":1,"items":[{"metric":"average","period":"last7Days"}]}
{"version":1,"items":[{"metric":"goal"}]}
{"version":1,"items":[]}
```

Leere Liste = bewusst keine Kennzahl. Instanzkennzahlen und `goal` tragen keinen
frei gewählten Zeitraum. Phase-15-UI schreibt maximal ein Element.
Parser und Anzeigeschnittstelle nutzen bereits Listen; spätere weitere Elemente
nicht bei normalen Aufgabenänderungen abschneiden. Keine zwei festen Spalten
„Kennzahl 1/2“ und keine Labeltexte als Kennzahl-ID.

Unbekannte Konfigurationsversion oder beschädigte Daten: keine Exception in der
Liste, neutral „Anzeigeeinstellung nicht verfügbar“, Konfiguration unverändert
lassen; Nutzer kann neu wählen oder zurücksetzen. Kein Schreibvorgang beim Lesen.

Migration: beim aktuellen Stand 17 → 18, nur neue Tabelle, keine Änderung
historischer Einträge und kein Backfill von Statistikwerten. Falls ein anderer
Chat das Schema erhöht hat, nächste freie Version benutzen und Migration ergänzen.
Drift-Code regenerieren, nicht von Hand anpassen.

Repository bekommt getrennte Lese-/Schreibmethoden für Anzeigeeinstellungen.
Nicht über `updateTask`/`createVersionIfChanged` speichern. Identische
Konfiguration erneut speichern ist ein No-op. Einstellung einer Aufgabe und
eines Bündels bleiben unabhängig. Ganze Konfiguration zunächst als eine
Änderung behandeln; keinen künftigen Mehrgeräte-Konfliktalgorithmus vorwegnehmen.

## 6. Lokale Berechnung, Aktualisierung und spätere Cloud

**Kennzahlberechnung hat keine Firebase-Abhängigkeit.**
Anzeige, Datumsauswahl und Statistikberechnung lesen lokale Daten und erzeugen
weder Cloud-Reads noch Cloud-Writes. Das ist eine Architekturvorgabe, keine
Zusicherung über die noch nicht implementierte Synchronisierung.

- Auswahl und fachliche Verfügbarkeit zuerst auflösen, nur benötigte
  Summary-Familie für sichtbare Karten/benötigte Zeiträume laden.
- „Keine Kennzahl“ verursacht keine Analytics-Abfragen.
- Innerhalb eines Listenladevorgangs pro Besitzer, wirksamer Definition,
  Stichtag und Zeitraum dieselbe Summary/Future wiederverwenden.
  Mehrere Carryover-Karten dürfen keine gleichen Zeitraumabfragen vervielfachen.
- Instanzkennzahlen verwenden vorhandene Listenwerte. Kein Analytics-Aufruf.
- Keine Abfrage pro Kennzahl, wenn eine Summary mehrere Werte liefern kann.
- Keine prozessweit unbegrenzt wachsenden oder dauerhaft gespeicherten Aggregate.
  Erst bei gemessenem Bedarf einen zusätzlichen lokalen Cache ergänzen.
- Vorhandene Bündelberechnung arbeitet teilweise tageweise; keinen umfassenden
  Scheduler-/Analytics-Umbau vorziehen. Lokale Laufzeit bei realistischen Listen
  prüfen; tatsächliche Engpässe gezielt beheben.
- Reaktivität muss Einstellungen, relevante Einträge/Werte, Aufgaben- und
  Bündeldefinitionen einschließlich geplanter Zielversionen abdecken.
  Definitionstabelle allein zu ändern muss für neue Anzeige genügen.
- Datumswechsel, App-Rückkehr und Rückkehr aus Auswahl/Details berücksichtigen.
  Ein beim Streamstart eingefrorenes `DateTime.now()` reicht über Mitternacht nicht.
- Bestehende Instanzerzeugung/Missed-Policy-Verarbeitung der Liste bleibt
  getrennt: Kartenberechnung erzeugt selbst keine Einträge oder Abschlüsse.

Phase 19 muss separat klären, welche Historie lokal vorhanden bleibt, wie Deltas
und Löschungen übertragen und wann fehlende Rohdaten geladen werden. Später nicht
lokal verfügbare Historie darf nicht als „keine Daten“/Null erscheinen; dafür
ist ein eigener Lade-/Verfügbarkeitszustand nötig. Phase 15 benötigt noch keine
Firebase-Implementierung oder künstlichen Cloud-Platzhalter.

## 7. Bedienung und kompakte Darstellung

- Ein gemeinsamer Auswahldialog/-sheet: Kennzahl, ggf. Zeitraum, Standard,
  Keine Kennzahl. Bestehende Erstellen-Formulare nicht mit einem weiteren
  Pflichtschritt belasten; Ziel erzeugt Default automatisch.
- Auswahl über „Kartenanzeige“ im Kartenmenü und auf der jeweiligen Detailseite.
  Beide Wege verwenden dieselbe Komponente und speichern erst bei Bestätigung.
- Damit ist Auswahl auch bei ausgeblendeter Kennzahl und ohne aktuelle Messwerte
  erreichbar. Änderungen erscheinen nach Rückkehr sofort.
- Auswahl aus vorhandenem kleinen Katalog; beliebige Analysefelder direkt anheften
  ist späterer Komfort, kein zweiter Auswahlmechanismus für Phase 15.
- Einmalige Aufgaben behalten ihren einfachen Einzelwert-/Statusumfang.
- Statistikformat und Einheiten aus vorhandenen Display-Regeln wiederverwenden.
  Uhrzeit mit Tagesoffset, Dauer ohne irreführenden Verlust kurzer Sekundenwerte.
- Label, Ergebnis und Zeitraum müssen erkennbar sein. Wertziel zeigt zuerst den
  gemessenen Durchschnitt/die Summe samt Zielgrenze; Statusziel z. B. „2 von 3“.
- Beispiel: „Ø 2380 kcal · 7 Tage“, darunter „Ziel: höchstens 2500 kcal · 5 Werte,
  2 fehlend/offen“. Das ist eine Kennzahl mit Kontext, nicht eine zweite Statistik.
- Datenbasis bei Wertaggregation sichtbar nennen; fehlende und nicht berechenbare
  Punkte nicht verstecken. Reiner Durchschnitt ohne Ziel bekommt kein Gut/Schlecht.
- Zielzustände unterscheiden Status-Erreichbarkeit und Wertziel-Datenlücke.
  Keine reine Farbcodierung, kein uneingeschränkt positives Signal bei Lücken.
- Rohstatus `no_entry` ist neutral; Datenlücke kann als Hinweis erscheinen.
  `recorded` bedeutet erfasst, nicht automatisch gutes Messergebnis.
- Flexible Breite/Umbruch; Eingabefelder bleiben bedienbar. Kein kompletter
  Kartenredesign oder Pixel-Feinschliff vor dem ersten Testlauf.

## 8. Umsetzungspakete für den anderen Chat

| Paket | Inhalt | Fertig, wenn … |
|---|---|---|
| 15a – Einstellung | Typisiertes Konfigurationsmodell, kleiner Katalog, neue Tabelle/Migration, getrennte Repositorymethoden | Auswahl/Default/Ausblenden eindeutig gespeichert; keine Definitionsversion oder Rohdatenänderung |
| 15b – Auflösung | Stichtag/Zeitraum, wirksames Ziel, bestehende Summaries, Schutz-/Leerzustände, Wiederverwendung pro Listenlauf | Kartenwerte fachlich korrekt und aus lokaler Datenbasis; keine zweite Rechenlogik |
| 15c – UI | Gemeinsamer Auswahldialog, Karten-/Detailzugang, Ergebnisliste zunächst ein Element, kontextsensitive Chips | Auswahl unmittelbar nutzbar, Wertziel statt bloßem Status sichtbar, schmale Karten funktionieren |
| 15d – Abschluss | Reaktivität, gezielte Regression, begrenzter Praxistest und Statusdokumentation | Akzeptanzfälle bestanden; bekannte Phase-16/19-Grenzen benannt |

### Umsetzungsstand 17. September 2026

| Paket | Stand | Technisches Ergebnis |
|---|---|---|
| 15a – Einstellung | umgesetzt und extern bestätigt | Versionierte Listen-Konfiguration, stabiler Kennzahlkatalog, separate Preference-Tabelle, Schema 18 sowie getrennte Aufgaben-/Bündelmethoden. Standard entfernt die Zeile, leere Liste blendet bewusst aus, beschädigte Konfiguration bleibt unverändert. Drift-Generierung, Parser- und Migrationstest sind grün. |
| 15b – Auflösung | umgesetzt und extern bestätigt | Ziel- und Zeitraumkennzahlen verwenden vorhandene Summaries, Stichtag und wirksame Definition. Instanzwerte bleiben instanzbezogen. Listenlauf-Caches vermeiden gleiche Summary-Abfragen; gemischte Wertarten/Einheiten/Rhythmen nutzen den neutralen Schutzpfad. Sechs gezielte Repositorytests sind grün. |
| 15c – UI | umgesetzt und extern bestätigt | Gemeinsames Bottom Sheet über Kartenmenü und Detailseite; Standard, Auswahl, Zeitraum und keine Kennzahl. Karten verwenden eine erweiterbare Ergebnisliste; Chips brechen lange Hinweise flexibel um. Auswahl- und Layouttests sind grün. |
| 15d – Abschluss | abgeschlossen und extern bestätigt | Reaktivität auf Preferences, Aufgaben-/Bündeldefinitionen und Bündelstamm sowie Tageswechsel/App-Rückkehr ergänzt. Drift-Codegenerierung und gezielte Analyse sind erfolgreich; alle vorgesehenen gezielten Tests und der begrenzte manuelle App-Durchgang sind bestätigt. |

Externe Prüfung am 17. September 2026:

- Drift-Codegenerierung erfolgreich: 103 Ausgaben geschrieben.
- Gezielte Analyse des Phase-15-Dateisatzes: `No issues found`.
- Preference-Parser: `+3 All tests passed`.
- Schema-17-zu-18-Migration: `+1 All tests passed`.
- Kartenkennzahl-Repositorytests: `+6 All tests passed`.
- Auswahloberfläche: `+2 All tests passed`.
- Kartenchip-Layout: `+1 All tests passed`.
- Ein während der Prüfung gefundener Tagesgrenzenfehler bei heutigen
  Definitionsänderungen wurde korrigiert und mit einem gezielten
  Einheitenwechsel-Test bestätigt: `+1 All tests passed`.

Der Flutter-Testprozess blieb nur innerhalb der Codex-Umgebung ohne Ausgabe;
die externen PowerShell-Läufe lieferten die maßgeblichen grünen Ergebnisse.
Der Nutzer bestätigte anschließend auch den manuellen Praxistest in der App.

Dateien/Ansatzpunkte:

- `lib/core/database/app_database.dart`, generierte `app_database.g.dart`.
- Neu im bestehenden Aufgaben-Datenordner: Preference-Tabelle,
  Konfigurationsmodell/Katalog und bei Bedarf kleiner Ergebnis-Resolver.
  Kein allgemeines Statistikframework.
- `aufgaben_repository.dart`: Einstellungen, effektive Definition, lokale
  Summary-Wiederverwendung und Stream-Abhängigkeiten.
- `task_card_metric.dart`, `task_for_date.dart`,
  `task_value_bundle_for_date.dart`: Ergebnisliste statt einzelner Pflichtkennzahl;
  sämtliche Kopier-/Anreicherungsstellen berücksichtigen.
- `task_card.dart`, `task_value_bundle_card.dart`, `card_metric_chip.dart`,
  gemeinsamer neuer Auswahldialog.
- `aufgaben_screen.dart`, `completed_one_time_tasks_screen.dart`,
  `task_detail_screen.dart`, `task_value_bundle_detail_screen.dart`:
  Auswahlzugang und frische Einstellungen, keine veraltete Konstruktor-Kopie.
- Aufrufer dieser Karten/Modelle per Referenzsuche prüfen; Projektansichten
  nicht pauschal umbauen.
- Bestehende Analytics-/Zieldateien bleiben Rechenquelle; nur kleine gemeinsam
  nutzbare Format-/Verfügbarkeitshelfer extrahieren, wenn nötig.

## 9. Risikobasierte Akzeptanzprüfung

Tests auf Verhalten und Erweiterungsgrenzen konzentrieren:

1. Migration eines Schema-17-Bestands: Daten unverändert, Defaultauflösung
   funktioniert, explizites Ausblenden unterscheidbar von fehlender Einstellung.
2. Auswahl bleibt nach erneutem Laden erhalten; Aufgabe/Bündel unabhängig;
   keine neue Definitionsversion, keine Eintragsänderung, identisches Speichern
   ohne zusätzliche Änderung.
3. Statusquote und Wertdurchschnitt entsprechen bestehender Detailberechnung
   bei gleichem Zeitraum. `pending`/`no_entry`/fehlende Werte keine Ersatznull.
4. 7-Tage-Rückblick vs. heute, nachträgliche Korrektur, Carryover-Fälligkeit,
   Zukunftsansicht ohne Prognose; Instanzwert bleibt instanzbezogen.
5. Ziel-Default, explizite Statistik trotz Ziel und explizites Ausblenden;
   Zieltyp/-spanne ändern, entfernen und für nächsten Block planen:
   gültige Definition genau ab Wirksamkeit, freie Statistik unverändert.
6. Wertziel erreicht mit Datenlücke: tatsächliches Ergebnis, korrekter Hinweis,
   Datenbasis und Zeitraum; leerer Durchschnitt nicht Null.
7. Bündel vollständig/teilweise/nicht berechenbar; gemeinsames vs. verknüpftes
   Layout; Tagesoffset; unabhängige Teilaufgaben-Einstellung nach Auflösen.
8. Geänderte Wertart/Einheit: kein irreführendes Aggregat; Auswahl bleibt
   erhalten. Unbekannte Konfiguration wirft nicht und wird nicht überschrieben.
9. Reine Preference-/Definitionsänderung aktualisiert aktive Liste;
   zwei Instanzen derselben Aufgabe teilen eine benötigte Zeitraum-Summary.
   Ausblenden löst keine Summary-Abfrage aus.
10. Ein fokussierter UI-Test für Auswahl/Speichern/Ausblenden, ein Layoutfall
    mit schmaler Breite, großer Schrift und langem Datenhinweis.

Danach `dart format` für geänderte Dateien, `flutter analyze` und relevante
Aufgaben-Repository-/Analytics-/Widgettests. Schema mit einer echten Migration
prüfen, nicht nur frisch erzeugter In-Memory-Datenbank.
Ein manueller Durchgang: Kalorienziel, Statushabit, reines Tracking, Bündel,
einmalige Aufgabe; Datum wechseln, Wert korrigieren, Anzeige ändern.
Keine pauschalen zusätzlichen Tests oder wiederholten Komplettläufe ohne Anlass.

Alte drei Prototyp-Tests auf die neuen Defaults/Regeln umstellen; nicht alte
Erwartungen als Produktanforderung konservieren. Testberichte vom 15. September
nicht als Nachweis der neuen Implementierung ausgeben.

## 10. Übergabe und spätere Erweiterungen

Der nächste Chat soll diesen Plan und die lokalen Repo-Anweisungen lesen,
aktuellen Arbeitsbaum/Schema prüfen und 15a–15d umsetzen. Bestehende uncommittete
Arbeit erhalten; kein Reset oder pauschaler Rückbau des Prototyps.

Kein grundlegender Umbau nötig für:

- zweiten Anzeigeplatz: vorhandene Konfigurationsliste/UI erweitern;
- zusätzliche vorhandene Kennzahl: stabilen Schlüssel und Katalogeintrag ergänzen;
- weitere Zeiträume: Konfigurationsparser und gemeinsame Zeitraumauflösung ergänzen;
- feinere Beschriftung/Layout: Darstellung ändern, Rohdaten bleiben unberührt.

Bewusst offen für spätere Phasen, ohne Phase 15 zu blockieren:

- Phase 16: vollständige Historisierung über fachliche Änderungen, Bearbeitungs-
  und Korrekturregeln, historisch aufgelöste Bündel.
- Phase 19: Cloud-Sync, lokale Datenabdeckung, Lösch-/Konfliktregeln, Kostenmessung.
- Nach erstem Testlauf: zweiter sichtbarer Platz, mehr Kennzahlen, direkte
  Anheftaktionen, Diagramme, Trends und UI-Feinschliff.

Keine Architektur garantiert, dass jede künftige Funktion ohne Änderung möglich
ist. Dieser Schnitt hält die absehbaren Erweiterungen von Rohdaten, Zielrechnung
und Definitionshistorie getrennt.
