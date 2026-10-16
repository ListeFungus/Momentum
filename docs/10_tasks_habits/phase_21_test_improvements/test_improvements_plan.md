# Momentum – Phase 21: Arbeitsplan für Testergebnisse und Verbesserungen

Stand: 16. Oktober 2026

Status: Aktiv; #003/#015 implementiert, Gerätenachtest offen; #002 zur Umsetzung vorbereitet

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
- Vor jeder neuen Konzeptfrage Originalmeldung und spätere Nutzerentscheidungen
  abgleichen. Zunächst den beschriebenen Wunsch zugrunde legen, dann nur echte
  Lücken erfragen. Eigene Alternativen ausdrücklich kennzeichnen; ohne Zustimmung
  weder Titel noch Umfang auf die bevorzugte Lösung verengen. Die verbindliche
  Arbeitsregel steht zusätzlich in der root `AGENTS.md`.

### Abgleich der Anforderungen am 16. Oktober 2026

Nach Nutzerhinweis alle Originalmeldungen #001–#020, A01/A02 und T20-01 mit
Themenübersicht, bisherigem Gespräch und Paketdokumentation abgeglichen.
Dies ist ein Quellen-/Entscheidungsabgleich, kein erneuter Codeaudit.

| Punkt | Befund und Korrektur |
|---|---|
| #002 | Unzulässige Verengung auf Nachtragen statt ausdrücklich früher/später änderbarem Startdatum. Titel, Übersicht und Pakettext korrigiert; separate Nachtragsfunktion bleibt unbestätigte Alternative. |
| #003/#015 | Agent schlug zunächst feste Standards ohne Einstellungsseite vor; die Originalmeldung enthielt bereits die Wahl zwischen einer und mehreren offenen Karten. Nutzer konkretisierte Optionen und dauerhafte Speicherung vor Umsetzung. Implementiert wurde der anschließend bestätigte Umfang. |
| #013 | Gewünscht ist Konvertierung statt Neuanlage. Die vorhandene Kopie ist nur heutiger Ausweichweg, keine bestätigte Erfüllung dieses Wunsches. Übersicht präzisiert. |
| A02 | Titel genügt und einmalig/heute/offen sind bereits Teil der beschriebenen Quick-Task-Idee. Diese Regeln nicht erneut als Grundsatzfragen stellen; größere Schnellaktionen bleiben separate offene Ideen. |
| #020 | Frei benannte Gruppen, gewünschte Reihenfolge und unabhängige Aufgaben im zusammengefassten Paket ausdrücklich erhalten; Zusammenfassung mit Navigation ersetzt den Gruppenwunsch nicht. |
| #009/#019 | Zurückstellung war nur vorläufige Priorisierung, keine hier bestätigte Nutzerentscheidung. Statusformulierungen entsprechend präzisiert. |
| #001/#007/#014 | Abweichungen vom ersten Wunsch sind im Testprotokoll als spätere Nutzerentscheidungen dokumentiert: vorläufige Zukunftssperre, Erledigungsdiagramm und zunächst vollständiges Backup. Lesbarer Export bleibt als Rest von #014 offen. Kein Beleg für eine weitere eigenmächtige Umdeutung. |
| Übrige Punkte | Bei #004–#006, #008, #010–#012, #016–#018, A01 und T20-01 keine weitere ersetzende Umdeutung im geprüften Plan gefunden; Vorschläge und noch offene Ausgestaltung bleiben als solche gekennzeichnet. |

Keine neue Produktentscheidung aus diesem Abgleich. Technische Ausführungsdetails
im Kartenpaket sind unter dem technischen Vertrag eingeordnet, nicht unter
ausdrücklich bestätigten Nutzerregeln. Historische Zwischenstände im Verlauf
sind keine aktuell offenen Fragen; maßgeblich ist dieser Arbeitsplan.

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

**Aktuelles Planungsthema:** #013, Aufgabenart Aufgabe ↔ Habit ändern.
#002 ist fachlich geklärt und technisch zur Umsetzung vorbereitet; auf Wunsch
des Nutzers wird zunächst mit der Planung weiterer Punkte fortgefahren.
#003/#015 einschließlich Optionsseite ist implementiert und automatisiert
geprüft; der kurze Gerätenachtest für Version `1.0.0+3` bleibt separat offen.

## Phasenschritte

| Schritt | Inhalt | Status |
|---|---|---|
| 21.1 | Testergebnisse übernehmen, priorisieren, bereits Erledigtes abgrenzen | erfolgt; fortlaufend ergänzen |
| 21.2 | Konzept und Grenzen des nächsten ausgewählten Themas klären | für #003/#015 geklärt; #002 fachlich geklärt und technisch vorbereitet |
| 21.3 | Umsetzungsauftrag mit Datenregeln, Abnahmekriterien und Nicht-Zielen festhalten | erstes Paket und #003/#015 dokumentiert |
| 21.4 | Bestätigte Pakete umsetzen und angemessen automatisiert prüfen | #001/#007, Backup-Anteil #014 und #003/#015 umgesetzt und geprüft; lesbarer Export #014 offen |
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
| Startdatum nach Erstellung bearbeiten | #002 | Fachlich geklärt, Umsetzung vorbereitet | Sichere reine Tracker früher/später beginnen lassen; Werte und Korrekturen erhalten, Auswertungsgrenzen anpassen; echte Terminserien bleiben gesperrt. Umsetzung und Prüffälle im Paketabschnitt |
| Aufgabenart Aufgabe ↔ Habit ändern | #013 | Konvertierung statt Neuanlage gewünscht; derzeit gesperrt | Sicheren Wechsel mit/ohne Historie, Rhythmus und Auswertung ausarbeiten. Vorhandene Kopie erfüllt den Wechselwunsch nicht; als Ersatz nur nach ausdrücklicher Zustimmung. Nicht automatisch mit #002 lösen |
| Tagesansicht, Tracker und Anzeigegruppen | #011 + #020 + A01 | Eigenes Konzeptpaket; Originalwünsche bleiben erhalten | Kompakte Trackerzeilen; frei benannte Anzeigegruppen mit festlegbarer Reihenfolge und optionalem Einklappen; Aufgaben bleiben unabhängig. Navigation/Monitoring ohne doppelte Datenerfassung. Datenart und übergreifende Darstellung noch klären |
| Schnelle Aufgabenanlage | A02, nur Quick Task | Beschriebener erster Anwendungsfall; Priorität/Umsetzung noch offen | Bereits beschrieben: Titel genügt, normale einmalige heute fällige offene Aufgabe. Nur unbeschriebene Bedien-/Bearbeitungsfolgen klären. Allgemeine Vorlagen, Widgets, Quick Habit und Quick Note separat behandeln |
| Routinen und Unteraufgaben | #004 + #010 | Eigenes Konzeptpaket | Gemeinsamer/teilweiser Abschluss, eigenständige Unteraufgaben versus Checkliste; Bearbeitungs-/Wartestatus getrennt vom wertenden Abschluss |
| Kombinierte Messdiagramme | #005 | Spätere Erweiterung | Bereits vorhandene Bündel weiterverwenden; unterschiedliche Skalen und Zeitebenen, fehlende Werte, klare Aussagegrenzen |
| Projekt-Dashboards | #006 | Eigener Ausbau nach Bedarf | Welche Anzeigen auswählbar, Reihenfolge/Speicherung, vorhandene Diagramme verwenden; nicht zwingend alle Dashboardfunktionen gemeinsam bauen |
| Projektphasen | #012 | Eigener Fachentwurf | Nur zeitliche Markierung oder Steuerung von Trackern? Beginn/Ende, historische Zuordnung und Vergleich ohne Datenverlust |
| Geschätzte Dauer und Tageslimit | #017 + #008 | Später, gemeinsam abstimmen | Freiwillige Dauer; Anzahl versus Zeitbudget; Hinweis statt harter Sperre; unbekannten Aufwand nicht als null werten |
| Zeit-Tracking | #016 | Eigenes Erweiterungspaket | Originalidee: Timer starten/pausieren/stoppen, manuelle Dauer oder beides. Auswahl des Umfangs noch offen; danach App-Unterbrechung, mehrere Sitzungen und gegebenenfalls manuelle Ergänzung ohne Doppelzählung klären |
| Kalender/Wochenplanung | #018 | Größerer Ausbau; #007 bereits als Erledigungsübersicht vorhanden | Planung und Erledigungen unterscheiden; Verschieben mit Historie; Zukunftsvorschau T20-01 vor schreibender Planung lösen |
| Spielerische Priorisierung | #009 | Vorläufige Empfehlung: später bearbeiten; keine bestätigte Zurückstellung | Gewünschte Prioritätenliste durch spielerische Paarvergleiche erhalten; Nutzen und effizientes Verfahren prüfen |
| Externe Kalender | #019 | Langfristige Idee; keine Phase-20-Pflicht, konkrete Einplanung offen | Termine aus externen Kalendern neben Aufgaben anzeigen; Lesen oder bidirektional, Quellen, Berechtigungen, Konflikte und doppelte Termine klären |
| Weitere Sicherungs-/Exportfunktionen | Rest #014 | Nicht Teil des umgesetzten Mindestumfangs | Lesbarer Export, automatische Sicherungen und Zusammenführen getrennt priorisieren; bei künftiger Schemaänderung Backup-Migration verpflichtend mitplanen |

## Paket #003/#015 – Kompakte und einklappbare Karten

**Status:** Konzept bestätigt, implementiert und automatisiert geprüft;
Gerätenachtest für Version `1.0.0+3` offen.
Ziel ist weniger Scrollen bei weiterhin unmittelbar bedienbaren Aufgaben, Habits
und Messwerten. Die Auswahl des Pakets bestätigt noch keine Detailregeln.

### Gezielter Codebefund vor der Kartenimplementierung (historischer Ausgangspunkt)

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
  damals noch festzulegende Speicherung. Der umgesetzte Speicherweg steht unten.

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
  bei fehlender Reihenfolge gelten die unten dokumentierten technischen Regeln.
- Einstellungen und gemerkte Zustände sollen Teil der Sicherung sein.
  Bestehende Sicherungen ohne diese Einstellungen bleiben importierbar und
  erhalten die Standardwerte.

### Technischer Umsetzungsvertrag

- Technische Ausführungsentscheidung zur bestätigten Einzelkartenregel:
  Mehrere sichtbare Instanzen derselben Aufgabe dürfen nicht gleichzeitig offen
  sein. Die angeklickte Instanz hat in der aktuellen Ansicht Vorrang; beim erneuten
  Anzeigen ohne Instanzauswahl entscheidet die stabile Instanzkennung (bei gleicher
  Aufgabe das früheste angezeigte Datum). Gespeichert wird der fachliche Kartenbezug.
  Dies ist eine Umsetzung der bestätigten Regel, keine separat abgefragte Nutzerwahl.

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

## Paket #002 – Startdatum nach Erstellung bearbeiten

**Status:** Fachliche Regeln bestätigt; begrenzter technischer Umsetzungsplan
ausgearbeitet. Noch nicht implementiert. Keine weitere Grundsatzfrage offen.
Der Karten-Gerätenachtest ist dadurch nicht als bestanden bestätigt.

### Ausgangspunkt und begrenzter Codebefund

- Originalwunsch: alte Gewichtsmessungen einfacher ergänzen; als Lösungsansatz
  Startdatum früher oder später ändern. Bisheriger Umfang nur sichere reine
  Trackingfälle, keine allgemeine Freigabe für terminbasierte Aufgaben.
- Phase 16 P16-12 sperrt das ursprüngliche Startdatum bewusst. Diese Sperre
  steht sowohl im Bearbeitungsformular als auch in `AufgabenRepository.updateTask`.
- `TaskInstanceScheduler.isDueOnDate` berücksichtigt die Startgrenze.
  Die Wertauswertung ergänzt bei reinem Tracking virtuelle fehlende Messungen
  für fällige Tage. Ein früherer Beginn kann deshalb die Vollständigkeitsanzeige
  ändern, auch wenn keine echten Termininstanzen erzeugt werden.
- Definitionsversionen enthalten ihr eigenes Startdatum. Eingaben werden über
  `setTaskEntryValue` einer Instanz und Definitionsversion zugeordnet; der
  explizite Durchführungstag wird gegen das Startdatum validiert.
- Folglich nicht nur das Datumsfeld freischalten. Vor Umsetzung gezielt
  historische Zuordnung, Werteauswertung und Korrekturen abgleichen; noch kein
  vollständiger Audit dieser Pfade.

### Maßgeblicher Wunsch und weiteres Vorgehen

Maßgeblich bleibt die Originalmeldung #002: Startdatum eines bereits angelegten
Trackings früher oder später setzen können, ohne es neu anzulegen. Konkreter
Anlass ist das Nachtragen älterer Gewichtsmessungen. Die gewünschte Änderung
des Startdatums ist somit bereits beschrieben und nicht erneut grundsätzlich
beim Nutzer abzufragen.

Der zwischenzeitliche Vorschlag des Agenten, stattdessen ausschließlich einen
separaten Nachtragsweg bei unverändertem Startdatum anzubieten, wurde nicht
bestätigt. Er ersetzt den Originalwunsch nicht. Nutzer weist ausdrücklich darauf
hin, dass seine Beschreibung bereits vorliegt.

### Bestätigte Regeln am 16. Oktober 2026

- Ein späteres Startdatum darf auch hinter bereits vorhandene Messwerte gelegt
  werden. Beispiel: Beginn vom 1. September auf den 1. Oktober verschieben;
  Septemberwerte bleiben gespeichert, sichtbar und in den jeweiligen
  Auswertungszeiträumen berücksichtigt. Keine automatische Löschung.
- Das neue Startdatum bestimmt, ab wann reguläre Messungen erwartet werden.
  Vorher vorhandene Werte bleiben echte Messungen; Tage davor werden nicht
  allein durch deren Vorhandensein zu erwarteten Messtagen.
- Wiederkehrende Aufgaben bleiben vorerst für diese Änderung gesperrt,
  damit keine Terminserie neu berechnet werden muss. Dies ist eine bewusste
  Begrenzung dieser ersten Umsetzung, keine endgültige Produktsperre.

### Technischer Befund

- Reines Tracking wird in `TaskInstanceScheduler._ensureEntriesForSingleDate`
  ausdrücklich von automatisch erzeugten Instanzen ausgenommen. Ein täglich
  angezeigter Gewichtstracker ist daher nicht allein wegen seines Rhythmus als
  gesperrte Terminserie zu behandeln. Die Freigabe muss wie in der Originalmeldung
  nach tatsächlichen Wirkungen geprüft werden: reines Tracking ohne erzeugte
  Terminserie/Abstandssteuerung und ohne Missed-Policy. Historische oder bereits
  geplante Konfigurationsänderungen bei dieser Prüfung berücksichtigen.
- `TaskAnalyticsPeriod.rangeStart` begrenzt derzeit auch feste Zeitfenster auf
  das Startdatum. Diese Grenze würde nach Verschieben auf Oktober vorhandene
  Septemberwerte ausblenden. Für freigegebene Tracker tatsächliche Messhistorie
  und Beginn der erwarteten Messungen getrennt behandeln: Gesamtverlauf enthält
  auch ältere Werte; feste Zeitfenster behalten ihre normale Datumsgrenze.
- Bestehende Messwerte samt Datum, Einheit und Definitionszuordnung erhalten.
  Die Änderung darf Korrekturen älterer Werte nicht durch die bisherige
  Durchführungstag-Prüfung gegen das aktuelle Startdatum verhindern.
- `taskForDate` und `taskForEntry` liefern historische Startdaten aus den
  Definitionsversionen. Nur das aktuelle Aufgabenfeld zu ändern genügt daher
  nicht. Bestehende Messdefinitionen dürfen trotzdem nicht überschrieben werden.
- `_valueBundlesForTasks` und `_buildTaskValueBundleAnalyticsSummary` überspringen
  derzeit Tage, wenn beide Quellen nicht fällig sind. Nach einer Startänderung
  könnte dies bereits vorhandene Messpaare ausblenden.
- Wertziele verwenden in `watchTaskValueGoalEvaluationSummary` einen expliziten,
  gleitenden Zeitraum bis zum Auswertungstag. Dafür wird keine Aufgabenserie
  erzeugt. Kein pauschaler Ausschluss von Trackern mit Wertzielen erforderlich;
  deren Auswertungsfenster und Zieldefinition bleiben bestehen.
- Gezielte Abnahmefälle: früherer Beginn ermöglicht alte Eingaben; späterer
  Beginn erhält frühere Werte in Verlauf/Auswertung und deren Korrigierbarkeit;
  fehlende Messungen folgen der neuen Startgrenze; echte wiederkehrende Aufgaben
  bleiben unverändert gesperrt. Sicherung/Wiederherstellung erhält das Ergebnis.

### Umsetzung in einem begrenzten Paket

Die folgenden Details sind aus den bestätigten Regeln abgeleitete technische
Festlegungen. Sie sind keine zusätzlichen, ausdrücklich vom Nutzer gewählten
Produktfunktionen. Kein allgemeiner Umbau der Historienverwaltung.

1. **Gemeinsame Freigabeprüfung:** Eine wiederverwendbare Prüfung für Formular
   und Repository liefert Freigabe oder verständlichen Sperrgrund. Voraussetzung:
   Werterfassung mit `pureTracking`, keine Missed-Policy, keine vom Abschluss
   abhängigen Abstände. Kalendergebundene Anzeige allein ist kein Sperrgrund.
   Auch vorhandene Definitionsversionen, tatsächlich gespeicherte Instanzen
   und vorgemerkte Planungsänderungen prüfen: echte Terminserien oder frühere
   verpflichtende Konfigurationen bleiben gesperrt. Echte Messungen einschließlich
   ihrer Korrekturhistorie sind kein Sperrgrund. Eine gleichzeitige Formularänderung
   darf die Prüfung nicht umgehen. Papierkorb-/Schreibschutz bleibt gültig.

2. **Start speichern:** In `AufgabenRepository.updateTask` die Startdatumsprüfung
   von den unverändert gesperrten Feldern trennen. `startDateChanged` in
   Änderungserkennung, Aufgaben-Update und Versionsanlage aufnehmen. Startdatum
   lokal auf einen Kalendertag normalisieren; vorhandene End-/Fälligkeitsgrenzen
   auf Widerspruch prüfen. Aufgabenzeile und neue Definitionsversion atomar
   speichern, gültig ab Änderung; keine Einträge erzeugen, verschieben, löschen
   oder neu zuordnen. Unverändertes Datum bleibt ohne zusätzliche Version.

3. **Erwartungsbeginn von Messhistorie trennen:** Das aktuelle `Aufgabe.startDate`
   bleibt die gespeicherte Quelle für den Beginn erwarteter reiner Messungen.
   Historische Versionen bleiben unverändert und erklären weiterhin bestehende
   Einträge. Im Fälligkeitspfad für reines Tracking die aktuelle Startgrenze
   ausdrücklich verwenden, auch wenn der Aufrufer bereits eine historische
   Aufgabe übergibt. Rhythmus, Pause, Ende und sonstige historische Einstellungen
   weiter datumsbezogen auflösen. Auch den frühen Sonderpfad für einmalige
   Aufgaben mit Fälligkeit beachten; er darf die Tracking-Startgrenze nicht
   umgehen. Keine globale Änderung der Startsemantik verpflichtender Aufgaben.
   Aktuelle Aufgabe/Definitionen pro Auswertung laden bzw. wiederverwenden,
   keine zusätzliche vollständige Historienprüfung für jeden einzelnen Tag.

4. **Frühere Eingaben zuordnen:** Für neu freigegebene Tage vor der ersten
   Definitionsversion die früheste nicht ersetzte Definition des Trackers als
   Ausgangskonfiguration verwenden, statt spätere Änderungen in die Vergangenheit
   zu übertragen. Anzeigeauflösung und Versions-ID beim Anlegen müssen dieselbe
   Auswahl verwenden (`TaskDefinitionResolver`, `TaskDefinitionVersionWriter`).
   Diese gezielte Rückfallregel gilt für reine Tracker; bestehende Einträge
   behalten ihre Versions-ID. Fehlende Legacy-Versionen über den vorhandenen
   Initialisierungspfad behandeln. Keine rückwirkende Projektzuordnung erfinden.

5. **Verlauf, Eingabe und Korrekturen:** Vorhandene Werte bleiben an ihrem
   ursprünglichen Tag sichtbar; `_isTaskVisibleOnDate` berücksichtigt bestehende
   Einträge bereits. Neue Tage ohne Eintrag folgen dem geänderten Beginn.
   Beim Ändern eines alten Messwerts darf dessen bisheriges Messdatum vor dem
   neuen Beginn erhalten bleiben. In `setTaskEntryValue` zuerst den bestehenden
   Eintrag feststellen und diese eng begrenzte Ausnahme von der Startprüfung
   unterscheiden; keine pauschale Freigabe beliebiger neuer Werte vor dem Beginn.
   Explizite und automatisch verwendete Datumsangaben konsistent prüfen.
   Zukunftssperre, Korrekturprotokoll und Undo erhalten.

6. **Auswertung:** Für reines Tracking bedeutet Gesamtverlauf: ab dem früheren
   Datum aus aktuellem Erwartungsbeginn und frühestem vorhandenen Messwert.
   Ein erklärender Text bzw. die Beschriftung „Gesamter Verlauf“ verhindert,
   dass „Seit Beginn“ ältere enthaltene Werte widersprüchlich erscheinen lässt.
   Feste Zeitfenster bleiben echte 7/20/30-Tage-Fenster; Messwerte darin nicht
   am neuen Start abschneiden. Fehlende Tage nur ab aktuellem Erwartungsbeginn
   und gemäß Rhythmus/Pausen zählen. Keine künstlichen fehlenden Tage zwischen
   einem älteren Messwert und dem neuen Start. Explizite Zeiträume für Wertziele
   beibehalten. `TaskAnalyticsPeriod` nicht global für andere Aufgaben umdeuten;
   Wertauswertung gezielt anpassen. Lese- und Streampfade müssen dasselbe liefern
   und nach Startänderung/Neustart/Restore den aktuellen Stand verwenden.

7. **Bündel erhalten:** Innerhalb der bestehenden Bündel-Gültigkeit einen Tag
   auch bei vorhandenen Quellmessungen berücksichtigen, wenn keine Quelle mehr
   fällig ist. Tagesanzeige und Auswertung gemeinsam korrigieren; Tagversatz
   berücksichtigen. Teilmessungen bleiben sichtbar, vollständige Paare behalten
   ihr Ergebnis. Bündeldefinition, zweite Quelle und Bündelbeginn nicht automatisch
   verschieben. Außerhalb seiner Gültigkeit kein Bündel rückwirkend erzeugen.

8. **Bearbeitungsformular:** `StartDateField` nur bei Freigabe aktivieren, sonst
   konkreten Sperrgrund zeigen. Kurzer Hinweis: „Vorhandene Messwerte bleiben
   erhalten. Das Startdatum bestimmt, ab wann Messungen erwartet werden.“
   Aufgabenart bleibt gesperrt; bisherigen gemeinsamen Sperrtext ersetzen.
   Abbrechen speichert nichts. Bei kombinierten Änderungen auch die vorhandenen
   Zweige für geplante Zieländerungen und Projektwechsel beachten: die
   Startänderung darf nicht stillschweigend übergangen werden.

**Speicherung:** Nach diesem Ansatz kein neues Datenbankfeld, keine neue Tabelle
und keine Schemaerhöhung nötig. Vorhandene Sicherung umfasst Aufgabenstart,
Definitionsversionen, Einträge und Korrekturen bereits. Altsicherungen behalten
ihr bisheriges Verhalten, da ihre Startdaten nicht nachträglich verändert wurden.

### Gezielte Prüfung und Abschluss

- Repositorytest mit Tracker ab 1. Oktober: auf 1. September zurücksetzen,
  Septemberwert eingeben, korrekte Definitionszuordnung und Sichtbarkeit nach
  erneutem Laden prüfen; dazwischenliegende spätere Definitionsänderung mitprüfen.
- Anschließend Beginn auf 1. Oktober setzen: Septemberwert bleibt in Gesamtverlauf
  sowie passenden festen/benutzerdefinierten Zeitfenstern, ist korrigierbar und
  per Undo wiederherstellbar; davor keine virtuellen fehlenden Messtage.
- Wiederholtes früher/später Setzen verändert weder Zahl noch IDs der Messwerte
  und erzeugt keine Termininstanzen. Kalender- und Pausengrenzen mitprüfen.
- Echte wiederkehrende Aufgaben, abschlussabhängige Abstände und unzulässige
  historische/vorgemerkte Konfigurationen bleiben auch beim direkten Repository-
  Aufruf gesperrt. Abgewiesene Änderung hinterlässt keinen Teilstand.
- Ein Bündelfall mit vorhandenem Messpaar vor beiden neuen Starts plus Teilwert
  und Tagversatz; ein Tracker mit Wertziel: alte Werte bleiben fachlich korrekt
  berücksichtigt, bestehende Gültigkeits-/Zielfenster bleiben unverändert.
- Formularprüfung: freigegebener Tracker, Sperrgrund bei Terminserie, Abbrechen,
  Speichern und Aktualisierung der Auswertung. Sicherung nach Startänderung
  exportieren/importieren und Messhistorie sowie neuen Beginn vergleichen.
- Bestehende Tests in `task_value_foundation_test.dart`, `history_editing_test.dart`,
  `task_lifecycle_test.dart` und `backup_service_test.dart` gezielt erweitern bzw.
  nutzen; neue Fälle bei Bedarf in eigenem `tracking_start_date_test.dart` bündeln.
  Danach Analyse und vollständige Tests; dokumentiertes stabiles Testprofil:
  `flutter test --concurrency=2 --timeout=2m`. Keine Tests für reine Textänderungen.
- Nach Umsetzung Änderungsdokument/Verlauf ergänzen und Gerätecheck mit früherem
  Nachtrag, späterem Beginn und gesperrter Terminserie bereitstellen. Bekannter
  offener Gerätenachtest des Kartenpakets bleibt separat offen.

Die fachlichen Regeln sind geklärt. Die Umsetzung ist anhand dieses Pakets
vorbereitet; App-Code wurde dafür noch nicht geändert. Nur bei einem konkreten
Widerspruch zu diesen Regeln erneut nachfragen, nicht bereits bestätigte
Anforderungen nochmals zur Wahl stellen.

## Paket #013 – Aufgabenart Aufgabe ↔ Habit ändern

**Status:** Beide Varianten der historischen Artzuordnung bestätigt;
Rhythmus und Wechselgrenzen noch in Klärung. Keine Umsetzung.

### Originalwunsch und gezielter Codebefund

- Bestehende Aufgabe in einen Habit und umgekehrt umwandeln, ohne Neuanlage.
  Eine Kopie ersetzt diesen Wunsch nicht. Identität und bestehende Einträge
  erhalten; keine stillschweigende Umdeutung der Historie.
- Beide Arten verwenden dieselbe Aufgabenstruktur. `taskType` und `recurrence`
  sind getrennte Felder; ein Artenwechsel darf deshalb nicht ohne Entscheidung
  automatisch einen neuen Rhythmus setzen.
- `TaskDefinitionVersions` speichert bereits die historische Aufgabenart.
  Allerdings filtert `watchTaskListForDate` die Aufgaben vor der historischen
  Auflösung anhand ihrer aktuellen Art. Nur `taskType` freizuschalten würde
  die historische Zuordnung in der Tagesansicht nicht zuverlässig abbilden.
- Einmalige Aufgaben besitzen eigene Terminlogik; Bündel verlangen derzeit
  dieselbe Aufgabenart ihrer Quellen. Nach Festlegung der Historienregel diese
  begrenzten Konfliktfälle prüfen, statt eine allgemeine Konvertierung zu versprechen.

### Bestätigt: Nutzer wählt den Umfang des Artenwechsels

Beim Umwandeln Aufgabe ↔ Habit werden beide Optionen angeboten; der Nutzer
entscheidet für den jeweiligen Wechsel:

- **Ab dem Wechsel:** Bisherige Einträge behalten ihre damalige Artzuordnung;
  neue Einträge folgen der neuen Art. Es bleibt dieselbe Aufgabe mit gemeinsamer
  Historie, keine Neuanlage/Kopie.
- **Auch bisherige Einträge umordnen:** Die neue Art gilt ebenfalls für die
  bisherigen Einträge, z. B. zur Korrektur einer ursprünglich falschen Auswahl.

Diese Auswahl betrifft die Artzuordnung. Daraus folgt keine Erlaubnis, Messwerte,
Erledigungen oder deren Datum zu löschen oder rückwirkend neue Solltermine zu
erzeugen. Die Umordnung muss in historischen Ansichten und nach Art getrennten
Auswertungen konsistent sichtbar werden. Technische Ablage und Behandlung
mehrfacher Wechsel im weiteren Plan konkretisieren; historische Rohdefinitionen
nicht unbesehen überschreiben. Keine der beiden Optionen stillschweigend wählen;
voreingestellte Auswahl und genaue Beschriftung sind noch nicht festgelegt.

### Nächste Entscheidung: Artenwechsel und Rhythmus

Vorschlag, noch nicht bestätigt: Bestehenden Rhythmus bei beiden Richtungen
erhalten. Aufgabe bedeutet nicht automatisch einmalig, Habit bedeutet nicht
automatisch täglich. Beim Wechsel einer einmaligen Aufgabe zu einem Habit
einen Wiederholungsrhythmus ausdrücklich auswählen lassen; diesen nicht
rückwirkend auf alte Einträge anwenden. Sonstige Rhythmusänderungen bleiben
eine getrennte, bewusste Bearbeitung. Anschließend Wechselgrenze und Umgang mit
bereits offenen Einträgen klären, soweit durch diese Regel noch nicht bestimmt.

## Bereits verbindliche Grenzen

- Ein Import ersetzt vollständig; kein automatisches Zusammenführen.
- Die Tageszählung umfasst positive Abschlüsse von Aufgaben und Habits nach
  tatsächlichem Erledigungstag. Reine Tracker werden nicht mitgezählt.
- Zukunftsnavigation bleibt bis zu einer sicheren Vorschau gesperrt. Das ist
  eine bestätigte Zwischenlösung, keine endgültige Produktentscheidung.
- Anzeigegruppen #020, Routinen #004 und Projekte sind unterschiedliche
  Konzepte. Nicht allein aufgrund ähnlicher Darstellung zusammenlegen.
- Startdatumsänderungen werden gemäß #002 für sichere reine Trackingfälle
  vorbereitet; wiederkehrende Aufgaben bleiben zunächst gesperrt. Für #013 sind
  Artenwechsel ab dem Wechsel oder einschließlich bisheriger Zuordnung als
  wählbare Optionen bestätigt; die technische Sperre besteht bis zur Umsetzung.
  Keine stillschweigende rückwirkende Umdeutung von Messungen oder Erledigungen.
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
