# Momentum – Phase 21: Arbeitsplan für Testergebnisse und Verbesserungen

Stand: 16. Oktober 2026

Status: Aktiv; #003/#015 implementiert und automatisiert geprüft, Gerätenachtest offen

## Ziel und Quellen

Testergebnisse in nachvollziehbare, begrenzte Änderungen übersetzen. Nach der
aktuellen Nutzeranweisung werden die Themen in diesem Phase-21-Chat geklärt und
anschließend auch hier umgesetzt. Die frühere feste Aufteilung auf Planungs- und
Umsetzungschat entfällt; die Dokumentation soll eine spätere Übergabe weiterhin
ermöglichen. Maßgeblich ist der dokumentierte Stand, nicht die Erinnerung eines
Chats. Neue umfangreiche Untersuchungen vorher mit dem Nutzer abstimmen.

- [Originalmeldungen #001–#020 und technischer Befund T20-01](../phase_20_private_test/mobile_test_feedback_2026_10.md).
- [Übergreifende Ideen A01 und A02](../../00_overview/app_concept_ideas_2026_10.md).
- [Bestätigte Regeln und Umsetzung des ersten Pakets](implemented_changes.md).
- [Bisherige Bearbeitungsgrenzen, Phase 16 P16-12](../phase_16_history_editing/history_editing_plan.md).
- [App-Masterplan](../../00_overview/app_masterplan.md) und [Aufgaben-Arbeitskarte](../task_structure_plan.md).

Die IDs der Originalmeldungen bleiben stabil. App-weite Ideen behalten ihren
Ursprung im Masterplan; hier stehen ihre konkreten Änderungspakete und der Status.

## Aktueller Stand

| Bereich | Stand |
|---|---|
| Android-App | APK `1.0.0+3` am 16. Oktober gebaut; Gerätenachtest offen. Installierte Version `1.0.0+2` und externer Export zuvor bestätigt |
| Daten | Lokale Drift-Datenbank; Kartenpaket hebt Schema 22 auf 23 an. Keine aktive Cloud-Synchronisierung |
| Datensicherung #014 | Vollständiges Exportieren/Ersetzen; Format 1, maximal 50 MB. Schema 23 exportiert 18 Tabellen einschließlich Kartenpräferenzen; Import von Schema 22 und 23 möglich. Lesbarer Analyseexport offen |
| Datumsauswahl #001 | Umgesetzt; vorläufig heute/Vergangenheit. Zukunftsnavigation nach bestätigter Zwischenlösung gesperrt |
| Tagesdiagramm #007 | Umgesetzt: sieben Tage mit erledigten Aufgaben und Habits, ohne reine Tracker; keine Zählung geplanter Aufgaben |
| Abnahme | 156 Tests bestanden, Analyse ohne Befunde, Standards-/Spec-Review ohne relevante Findings. Nachtest von Version `1.0.0+3` offen; bisherige Gerätebestätigung betrifft Version `1.0.0+2` und Export nach Drive |
| Code-Referenz | Erstes Paket `7263ea9`; Kartenpaket als anschließende Änderung am 16. Oktober umgesetzt |
| Karten #003/#015 | Implementiert und automatisiert geprüft; Einstellungen unter Optionen → Kartenanzeige |
| Übrige Themen | Nicht umgesetzt beziehungsweise noch nicht entschieden; Einzelheiten unten |

## Arbeitsweise für die laufende Ausarbeitung

- Akute Nutzungsprobleme zuerst; neue Testergebnisse können die Reihenfolge ändern.
- Grundsatzfragen zu Daten, Historie und späteren Erweiterungen einzeln mit
  begründeter Empfehlung klären. Im Code beantwortbare Fakten selbst nachlesen.
- Kleine, leicht reversible Detailentscheidungen bei Bedarf als kurze Sammelliste
  abstimmen. Nicht sämtliche langfristigen Ideen vor dem nächsten Paket ausarbeiten.
- Pro Paket nur die notwendigen Quellen und Codepfade vertiefen; umfassende Audits,
  größere Untersuchungen und aufwendige Zusatzarbeiten vorher abstimmen.
- Bestätigte Entscheidungen unmittelbar hier festhalten. Konzeptvorschläge nicht
  als beschlossene Regeln darstellen; Umsetzung erst nach gemeinsamer Klärung.

### Eingangssichtung am 16. Oktober 2026

Phase-20- und Phase-21-Dokumente, A01/A02, Fachbegriffe und die Bearbeitungsgrenzen
P16-12 wurden gelesen. Dokumentations- und Codestruktur wurden erfasst; zentrale
Planungsdokumente zur Orientierung durchsucht. Gezielter Codeabgleich bestätigt
Commit `7263ea9`, App-Version `1.0.0+2`, Schema 22, vorhandenen Backup-Service,
die Zukunftssperre der Tagesnavigation und gesperrte Startdatum-/Artfelder.
Reines Tracking ist bereits im Datenmodell vorhanden (`pure_tracking`).
Dies ist kein vollständiger Code-/Dokumentenaudit und keine erneute Testabnahme.
Die 149 erfolgreichen Tests stammen aus der bisherigen Implementierungsabnahme.

Die vorhandene Kategorisierung nach Aufwand und Art bleibt bestehen. Ergänzend
gilt folgende **vorläufige Einordnung nach Handlungsbedarf**, noch keine vom
Nutzer bestätigte Reihenfolge oder Release-Auswahl:

| Einordnung | Themen | Konsequenz für die Klärung |
|---|---|---|
| Bereits umgesetzt, praktische Abnahme teilweise offen | #001, #007, Backup-Anteil #014 | Update und externe Sicherung bestätigt; übrige Nachtests getrennt verfolgen, keine erneute Implementierung planen |
| Technisches Risiko vorläufig abgesichert | T20-01, Bezug #018 | Zukunft gesperrt lassen; sichere Vorschau vor Freigabe künftiger Tage ausarbeiten, kein belegter Schaden an Handydaten |
| Konkrete Alltagsverbesserungen | #003/#015, #002, #013; Quick Task aus A02 | Tatsächliche Behinderung priorisieren; Karten kompakt darstellen ist voraussichtlich begrenzter als Eingriffe in bestehende Historie |
| Größere Konzepte und Erweiterungen | #004–#006, #008–#012, #016–#020, A01, Rest A02/#014 | Nur die Grundlagen vertiefen, die ein ausgewähltes Paket beeinflussen; übrige Details zurückstellen |

Wesentliche Verbindungen für spätere Pakete:

- #003/#015 berühren #011/#020: kompakte Eingaben und spätere Gruppen gemeinsam
  mitdenken, ohne dafür schon eine neue Navigation oder Aufgabenart vorauszusetzen.
- #002/#013 berühren Definitionsversionen, Instanzen und Auswertung. Bestehende
  Sperren sind bewusste Regeln; ihre Lockerung ist kein bloßes Freischalten im Formular.
- #004/#010/#020: Anzeigegruppe, gemeinsamer Abschluss und Unteraufgabe sind
  fachlich zu unterscheiden, bevor Beziehungen oder Abschlussregeln gespeichert werden.
- #005/#006/#012: vorhandene Messreihen und Bündel nutzen; Anzeige und zeitliche
  Steuerung nicht ungeklärt vermischen.
- #008/#017/#016: Schätzung, Zeitbudget und tatsächlich gemessene Dauer unterscheiden.
- Jede spätere Schemaänderung muss die Lesbarkeit vorhandener Sicherungen mitplanen.

**Bestätigter Sachstand:** Nutzer bestätigt das installierte Update und eine nach
Google Drive exportierte Sicherungsdatei. Keine Prüfung der Datei durch den Agenten
und keine bestätigte manuelle Wiederherstellung.

**Aktuelles Paket:** #003/#015 (kompakte/einklappbare Karten), einschließlich
Optionsseite und dauerhafter Speicherung. Alle unten als bestätigt bezeichneten
Bedienregeln wurden geklärt; Umsetzung und automatisierte Abschlussprüfung sind
erfolgreich. Nächster Schritt ist der kurze Gerätenachtest für Version `1.0.0+3`.

## Phasenschritte

| Schritt | Inhalt | Status |
|---|---|---|
| 21.1 | Testergebnisse übernehmen, priorisieren, bereits Erledigtes abgrenzen | erfolgt; fortlaufend ergänzen |
| 21.2 | Konzept und Grenzen des nächsten ausgewählten Themas klären | für #003/#015 geklärt |
| 21.3 | Umsetzungsauftrag mit Datenregeln, Abnahmekriterien und Nicht-Zielen festhalten | erstes Paket und #003/#015 dokumentiert |
| 21.4 | Bestätigte Pakete umsetzen und angemessen automatisiert prüfen | #001/#007/#014 und #003/#015 umgesetzt und geprüft |
| 21.5 | Auf dem Handy nachtesten, Restpunkte aktualisieren | Version `1.0.0+2` und Export nach Drive bestätigt; Kartenpaket `1.0.0+3` noch offen, Beobachtungen in Phase 20 |
| 21.6 | Release-Blocker beheben, andere Themen ausdrücklich zurückstellen und an Phase 22 übergeben | offen |

## Themenübersicht und vorläufige Reihenfolge

Datensicherung zuerst war vom Nutzer priorisiert und ist inzwischen implementiert.
Update und erste externe Sicherung in Google Drive sind inzwischen bestätigt.
Die Reihenfolge der weiteren Konzepte ist ein Vorschlag; sie ist kein Auftrag,
alle Ideen vor Veröffentlichung umzusetzen.

| Paket | Quellen | Stand / Vorschlag | Vor Umsetzung wesentlich zu klären |
|---|---|---|---|
| Abnahme des ersten Pakets | #014, #001, #007 | Implementiert; Update und Export nach Drive bestätigt | Bestandsprüfung und Datum/Diagramm noch nicht ausdrücklich bestätigt; manueller Restore-Test optional gemäß Nachtestanleitung |
| Sichere Zukunftsvorschau | T20-01, Bezug #018 | Offenes technisches Folgepaket; Schutzmaßnahme aktiv | Vorschau von Terminfortschreibung trennen: keine vorzeitigen Missed-Konsequenzen oder Definitionsänderungen; Umfang und Leistungsgrenzen festlegen |
| Kompakte/einklappbare Karten | #003 + #015 | Implementiert und geprüft; Gerätenachtest offen | Regeln, Datenhaltung und Abnahme im Paketabschnitt unten |
| Alte Messwerte nachtragen | #002 | Eigenes kleines Fachkonzept; nicht freigegeben | Reicht Nachtragen vor ursprünglichem Beginn? Folgen früherer/späterer Startdaten; nur sichere Trackingfälle; keine stille Löschung. Sperre P16-12 bewusst neu entscheiden |
| Aufgabenart wechseln | #013 | Eigenständiger Fachpunkt; gesperrt wie bisher | Fall ohne Einträge versus bestehende Historie, Rhythmus und Auswertung; Kopie als Alternative. Nicht automatisch mit #002 lösen |
| Tagesansicht, Tracker und Anzeigegruppen | #011 + #020 + A01 | Eigenes Konzeptpaket | Darstellung versus neue Datenart; Ziele bei Trackern behalten; gemeinsame Tagesübersicht ohne doppelte Datenerfassung; Gruppen sind kein gemeinsamer Abschluss |
| Schnelle Aufgabenanlage | A02, nur Quick Task | Kleiner Kandidat nach kurzer Bestätigung | Titel genügt, einmalig/heute/offen als bestehende normale Aufgabe. Allgemeine Vorlagen, Widgets, Quick Habit und Quick Note separat behandeln |
| Routinen und Unteraufgaben | #004 + #010 | Eigenes Konzeptpaket | Gemeinsamer/teilweiser Abschluss, eigenständige Unteraufgaben versus Checkliste; Bearbeitungs-/Wartestatus getrennt vom wertenden Abschluss |
| Kombinierte Messdiagramme | #005 | Spätere Erweiterung | Bereits vorhandene Bündel weiterverwenden; unterschiedliche Skalen und Zeitebenen, fehlende Werte, klare Aussagegrenzen |
| Projekt-Dashboards | #006 | Eigener Ausbau nach Bedarf | Welche Anzeigen auswählbar, Reihenfolge/Speicherung, vorhandene Diagramme verwenden; nicht zwingend alle Dashboardfunktionen gemeinsam bauen |
| Projektphasen | #012 | Eigener Fachentwurf | Nur zeitliche Markierung oder Steuerung von Trackern? Beginn/Ende, historische Zuordnung und Vergleich ohne Datenverlust |
| Geschätzte Dauer und Tageslimit | #017 + #008 | Später, gemeinsam abstimmen | Freiwillige Dauer; Anzahl versus Zeitbudget; Hinweis statt harter Sperre; unbekannten Aufwand nicht als null werten |
| Zeit-Tracking | #016 | Eigenes Erweiterungspaket | Start/Pause/Stop, App-Unterbrechung, mehrere Sitzungen und manuelle Ergänzung ohne Doppelzählung |
| Kalender/Wochenplanung | #018 | Größerer Ausbau; #007 bereits als Erledigungsübersicht vorhanden | Planung und Erledigungen unterscheiden; Verschieben mit Historie; Zukunftsvorschau T20-01 vor schreibender Planung lösen |
| Spielerische Priorisierung | #009 | Zurückgestellt | Nutzen und effiziente Paarvergleiche vor zusätzlichem System prüfen |
| Externe Kalender | #019 | Langfristig zurückgestellt | Lesen oder bidirektional; Quellen, Berechtigungen, Konflikte und doppelte Termine |
| Weitere Sicherungs-/Exportfunktionen | Rest #014 | Nicht Teil des umgesetzten Mindestumfangs | Lesbarer Export, automatische Sicherungen und Zusammenführen getrennt priorisieren; bei künftiger Schemaänderung Backup-Migration verpflichtend mitplanen |

## Paket #003/#015 – Kompakte und einklappbare Karten

**Status:** Konzept bestätigt, implementiert und automatisiert geprüft;
Gerätenachtest für Version `1.0.0+3` offen.
Ziel ist weniger Scrollen bei weiterhin unmittelbar bedienbaren Aufgaben, Habits
und Messwerten. Die Auswahl des Pakets bestätigt noch keine Detailregeln.

### Gezielter Codebefund

- `lib/features/aufgaben/presentation/widgets/task_card.dart` zeigt derzeit
  Titel, optionalen Termin-/Rückstandshinweis, Optionsmenü, Beschreibung,
  Fragetext, Bündelhinweis, ausgewählte Kennzahlen und Eingabe untereinander.
  Es gibt noch keinen einklappbaren Bereich.
- Die Eingaben unterscheiden sich: Checkbox, Ja/Nein einschließlich Notiz sowie
  Wert plus Speichern/Ändern. Uhrzeitwerte enthalten zusätzlich die Zuordnung
  zu Vortag, gleichem Tag oder Folgetag. Diese Bedeutung darf Komprimierung
  nicht verstecken oder ändern.
- Kartenkennzahlen sind bereits konfigurierbar, auch mehrere pro Karte.
- `task_value_bundle_card.dart` verwendet eine eigene Darstellung; Bündel müssen
  gesondert berücksichtigt werden. `TaskCard` wird in der Tagesansicht und in
  der Liste abgeschlossener einmaliger Aufgaben verwendet.
- `task_modes/value_task_input.dart` verwaltet ungespeicherte Eingabe und
  Validierungsfehler lokal. Ein-/Ausklappen darf keine Eingabe verlieren oder
  versehentlich speichern. Das reine Einklappen benötigt keine Änderung der
  Fachdaten; die inzwischen gewünschte dauerhafte Einstellung benötigt eine
  noch festzulegende Speicherung.

### Bestätigte Grunddarstellung

Nutzer bestätigt den Darstellungsvorschlag mit „passt“ am 16. Oktober 2026:

- Normale Aufgaben-/Habit-/Trackingkarten behalten kompakt Titel und direkte
  Bedienung (Checkbox, Ja/Nein oder Werteingabe) sowie nötigen Rückstandshinweis.
- Beschreibung und Zusatzinformationen werden beim Aufklappen sichtbar.
- Ausgewählte Kartenkennzahlen erscheinen ausschließlich aufgeklappt. Ihre
  gespeicherte Auswahl bleibt unverändert; Einklappen löscht keine Präferenz.

### Weitere bestätigte Anforderungen

- Seitenleiste erhält einen Button „Optionen“. Darin wird die Einstellung
  „Kartenanzeige“ angeboten (Arbeitsbezeichnung).
- Drei wählbare Anzeigemodi: immer klein, immer groß oder individuellen
  Aufklappzustand dauerhaft merken. Im Merken-Modus soll eine bewusst geöffnete
  Karte auch später geöffnet bleiben. Die frühere Empfehlung ohne dauerhafte
  Speicherung ist damit überholt.
- Zusätzlich wählbar: höchstens eine Karte gleichzeitig geöffnet oder mehrere
  unabhängig voneinander öffnen/schließen.
- Bündelkarten zeigen kompakt Name, Erfassungsstatus und berechnetes Ergebnis
  (bzw. fehlendes/nicht berechenbares Ergebnis). Die zwei beschrifteten Eingaben,
  Beschreibung und gewählten Kennzahlen werden aufgeklappt sichtbar. Das
  aktuelle Bündelergebnis ist fachlicher Karteninhalt, keine ausblendbare
  zusätzliche Kartenkennzahl. Nutzer bestätigt diese Ausnahme zur direkten
  Eingabe normaler Karten ausdrücklich.
- Derselbe Kartenstandard gilt in Tagesansicht und Liste abgeschlossener
  einmaliger Aufgaben. Vom Nutzer bestätigt; die neue Optionsseite gehört
  ausdrücklich zum Paket.

### Bestätigte Bedeutung der Anzeigemodi

Nutzer bestätigt die Präzisierung mit „passt“:

- Auswahl heißt „Kompakt starten“, „Aufgeklappt starten“ und „Letzten Zustand
  merken“. Klein/groß sind Startzustände, keine erzwungene Darstellung.
- In allen Modi können Karten manuell geöffnet und geschlossen werden.
  Beim erneuten Öffnen der Ansicht beziehungsweise Datumswechsel gilt in den
  ersten beiden Modi wieder der gewählte Startzustand. Normale Aktualisierungen
  innerhalb derselben Ansicht setzen die manuelle Auswahl nicht zurück.
- Nur „Letzten Zustand merken“ bewahrt die individuelle Auswahl dauerhaft.
- Bei „Aufgeklappt starten“ ist „nur eine offen“ sichtbar deaktiviert und nicht
  wirksam. Die Auswahl bleibt für die anderen Anzeigemodi gespeichert.

### Bestätigte Standards und Speicherung

Nutzer bestätigt auch diese Sammelliste mit „passt“.

- Standard nach Einführung: „Kompakt starten“ und mehrere Karten gleichzeitig
  erlaubt. Neue Karten ohne gemerkten Zustand beginnen im Merken-Modus kompakt.
- Dauerhaftes Merken gilt je Aufgabe/Habit/Tracking beziehungsweise Bündel,
  unabhängig vom Datum und über App-Neustarts hinweg. Eine geöffnete tägliche
  Gewichts-Karte bleibt damit auch morgen offen. Eingaben und Antworten bleiben
  selbstverständlich an ihre tatsächliche Instanz gebunden.
- Im Einzelkartenmodus schließt das Öffnen einer anderen Karte die bisherige.
  Im Merken-Modus wird auch dieses Schließen gespeichert. Beim Wechsel von
  mehreren offenen Karten zu einer bleibt die zuletzt geöffnete erhalten;
  bei fehlender Reihenfolge deterministische Auswahl ohne Datenänderung.
  Mehrere gleichzeitig sichtbare Instanzen derselben Aufgabe dürfen die
  Einzelkartenregel nicht umgehen. Die konkret angeklickte Instanz hat in der
  aktuellen Ansicht Vorrang; beim erneuten Anzeigen ohne Instanzauswahl wird
  deterministisch nach stabiler Instanzkennung ausgewählt (bei gleicher Aufgabe
  das früheste angezeigte Datum). Nur der fachliche Kartenbezug wird gespeichert.
- Einstellungen und gemerkte Zustände sollen Teil der Sicherung sein.
  Bestehende Sicherungen ohne diese Einstellungen bleiben importierbar und
  erhalten die Standardwerte.

### Technischer Umsetzungsvertrag

- Kompakt bleiben Titel, direkte Erledigung/Antwort/Werteingabe, notwendiger
  Termin-/Rückstandskontext, Aufklapppfeil und Optionszugang erreichbar.
- Beschreibung und zusätzliche Informationen erscheinen aufgeklappt.
  Ein zum Verständnis einer Antwort notwendiger Fragetext bleibt zugänglich,
  ohne dass der Nutzer die Bedeutung der Antwort erraten muss.
- Ein-/Ausklappen schreibt keine Fachdaten. Ungespeicherte Eingaben und
  Fehlermeldungen bleiben beim Ein-/Ausklappen derselben Karte erhalten.
- Stabile Identität pro Aufgabe/Instanz beziehungsweise Bündel und Anzeigedatum
  berücksichtigen, damit nach Sortierung oder Aktualisierung kein Zustand auf
  eine andere Karte übergeht. Ein-/Ausklappen selbst löst keine Speicherung
  einer Antwort aus; lediglich Anzeigepräferenzen werden gespeichert.
- Optionsseite über `lib/hauptseiten/hauptseite.dart` anbinden. Eine allgemeine
  Einstellungsablage wurde bei der gezielten Suche noch nicht gefunden;
  bestehende Kartenkennzahl-Präferenzen sind fachlich etwas anderes.
- `lib/core/settings/`: Repository, Tabellen, gemeinsame Ansichtssteuerung und
  Optionsseiten. Aufklappregeln einmal pro sichtbarer Liste koordinieren, über
  Projektabschnitte sowie Aufgaben und Bündel hinweg.
- Datenbankschema 23 ergänzt `card_display_settings` (ein globaler Datensatz)
  und `card_expansion_preferences` (geöffnete Aufgaben/Bündel mit Reihenfolge).
  Referenzen auf endgültig gelöschte Objekte werden per Fremdschlüssel entfernt.
  Papierkorb und Pausieren verändern diese Präferenzen nicht.
- Keine Änderungen an Aufgaben-Definitionen, Antworten, Terminlogik, Auswertung
  oder bereits konfigurierten Kartenkennzahlen. Keine neue Abhängigkeit nötig.
- Backup-Format 1 bleibt bestehen; Schema-23-Export enthält alle 18 Tabellen.
  Schema-22-Import validiert zunächst exakt die bisherigen 16 Tabellen und
  ergänzt beide Präferenztabellen leer (kompakt/mehrere). Fehlende alte Tabellen
  oder unbekannte Schemata werden weiterhin abgelehnt; Ersetzen bleibt atomar.
  Neue Schema-23-Sicherungen sind nicht rückwärts in der alten App importierbar.
- Startansicht wird bei Datums-/Ansichtswechsel und Rückkehr von einer anderen
  Seite zurückgesetzt; gewöhnliche Datenupdates und geschlossene Dialoge setzen
  sie nicht zurück. Der Modus „Merken“ liest stattdessen die dauerhaften Zustände.
- Speicherfehler sichtbar melden, keine erfolgreiche Speicherung vortäuschen.
- Spätere Anzeigegruppen und gesonderte Trackeransichten mitdenken, aber in
  diesem Paket noch keine Gruppen, neue Navigation oder Tracking-Datenart einführen.

### Abnahmekriterien und gezielte Prüfungen

1. Seitenleiste → Optionen → Kartenanzeige bietet die drei bestätigten Modi und
   den Schalter für eine offene Karte; bei aufgeklapptem Start ist er deaktiviert,
   seine gespeicherte Auswahl bleibt erhalten.
2. Kompakte normale Karten bleiben bedienbar, Kennzahlen/Beschreibung erscheinen
   erst aufgeklappt. Bündel zeigen kompakt Status/Ergebnis und aufgeklappt beide
   Eingaben. Lange Texte funktionieren auch auf schmalen Displays.
3. Eingabeentwurf und Fehlermeldung bleiben beim eigenen oder automatischen
   Einklappen erhalten. Kein Ein-/Ausklappen erzeugt einen Werte-Eintrag.
4. Ein-Karten-Regel gilt über Kartentypen/Abschnitte und bei mehreren sichtbaren
   Instanzen derselben Aufgabe. Reihenfolgeänderungen übertragen keinen Zustand
   auf eine andere Aufgabe. Datumswechsel und erneutes Öffnen beachten den Modus.
5. Gemerkte Zustände überleben App-Neustart. Umschalten auf Einzelkarte behält
   die zuletzt geöffnete; automatisches Schließen ist im Merken-Modus dauerhaft.
6. Migration 22 → 23 erhält vorhandene Daten. Vollständiger Export/Import mit
   Präferenzen, alter Schema-22-Import mit Standardwerten und Fehlerfälle werden
   automatisiert geprüft. Abschließend vollständige Testsuite und Analyse.
7. Android-Update über die bestehende Installation; manueller Nachtest von
   Optionen, mehreren Karten/Bündeln, Datumswechsel und Neustart bleibt beim Nutzer.

**Prüfstand am 16. Oktober:** 156 Tests erfolgreich, Analyse fehlerfrei,
Standards-Review 0 relevante Findings, Spec-Review 0 relevante Findings.
Release-APK erfolgreich gebaut; manueller Nachtest siehe
[umgesetzter Stand](implemented_changes.md). Vollständiger Testbericht lokal
unter `build/phase21-tests.json` (generiertes, nicht versioniertes Artefakt).

## Bereits verbindliche Grenzen

- Ein Import ersetzt vollständig; kein automatisches Zusammenführen.
- Die Tageszählung umfasst positive Abschlüsse von Aufgaben und Habits nach
  tatsächlichem Erledigungstag. Reine Tracker werden nicht mitgezählt.
- Zukunftsnavigation bleibt bis zu einer sicheren Vorschau gesperrt. Das ist
  eine bestätigte Zwischenlösung, keine endgültige Produktentscheidung.
- Anzeigegruppen #020, Routinen #004 und Projekte sind unterschiedliche
  Konzepte. Nicht allein aufgrund ähnlicher Darstellung zusammenlegen.
- Bisherige Sperren für Startdatum und Aufgabenart bleiben bis zu einer neuen
  ausdrücklichen Entscheidung bestehen. Historie nicht rückwirkend umdeuten.
- Keine dieser Ideen setzt eine neue Cloud-Synchronisierung, Paywall oder
  Store-Veröffentlichung voraus. Deren Zuständigkeiten bleiben getrennt.

## Übergabe zwischen Planung und Umsetzung

Pro ausgewähltem Thema hier einen kurzen Abschnitt pflegen. Erst bei tatsächlich
umfangreichem Konzept ein eigenes Themendokument in diesem Ordner anlegen und
verlinken; keine leeren Spezifikationen für alle Ideen erzeugen.

Ein umsetzungsbereiter Abschnitt enthält:

1. Problem, Nutzerziel und zwei bis drei konkrete Bedienbeispiele.
2. Bestätigten Umfang, Nicht-Ziele und Status; offene Fragen ausdrücklich nennen.
3. Auswirkungen auf vorhandene Einträge, Historie, Auswertung und Sicherungsformat.
4. Relevante vorhandene Codepfade und gegebenenfalls notwendige Migration.
5. Beobachtbare Abnahmekriterien und gezielte Tests, einschließlich Fehler-/Abbruchfall.

Danach wird dieses begrenzte Paket im aktuellen oder ausdrücklich gewählten
Umsetzungschat umgesetzt. Neue Grundsatzfragen
nicht während des Codens still entscheiden. Umsetzung, Prüfstand und verbleibende
Gerätetests im Plan/Verlauf aktualisieren; originale Testbeobachtungen in Phase 20
erhalten. Kein neues Chat-Erstellen oder Versenden von Nachrichten ohne Auftrag.

Statusfolge: **Idee → Konzept in Klärung → umsetzungsbereit → implementiert /
automatisiert geprüft → Gerätenachtest bestätigt**. Alternativ ausdrücklich
„zurückgestellt“ oder „verworfen“. Der letzte Status ist kein Synonym für einen
erfolgreichen Build.

## Übergang zu Phase 22

Vor der Store-Vorbereitung müssen für den vereinbarten Releaseumfang kritische
Daten-/Nutzungsprobleme geklärt, relevante Gerätenachtests bestätigt und offene
Punkte ausdrücklich als Blocker oder spätere Erweiterung eingeordnet sein.
Nicht alle hier gesammelten Ideen müssen umgesetzt werden. Die konkrete
Release-Auswahl ist noch offen; Phase 21 ist nicht abgeschlossen.
