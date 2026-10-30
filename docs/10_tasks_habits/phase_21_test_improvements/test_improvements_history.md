# Momentum – Testergebnisse und Verbesserungen: Verlauf

Stand: 28. Oktober 2026

Status: #013, #002, Kartenpaket und Kalender umgesetzt und automatisiert geprüft; Gerätenachtests und weitere Konzepte offen

## 28. Oktober 2026 – Zeitumstellungskorrektur umgesetzt und geprüft

- Auf ausdrücklichen Folgeauftrag Zielzeiträume auf Kalenderarithmetik umgestellt;
  Status-/Wert-/Bündelfenster, nächste Zielvormerkung und Mehrjahresblöcke geprüft.
- Fünf neue feste Regressionstests zuerst rot, danach grün. Zusätzlich alten
  Karten-Widgettest an Parser/Entwurfszustand angepasst und Verlust der
  Fehlermarkierung beim Klappen korrigiert; entsprechende Widgettests grün.
- Abschließende vollständige Suite: **229 bestanden, 0 fehlgeschlagen**, 95 s.
  Gezielte Analyse acht Dateien ohne Befunde; Diff-Whitespaceprüfung sauber.
- Keine Schema-/Datenmigration, kein Eingriff in persönlichen Bestand oder
  bestehende Zielvormerkungen. Kein APK-Build; Gerätenachtest offen.
  Details in `goal_calendar_fix.md`. Frühere Laufbefunde unten bleiben Historie.

## 28. Oktober 2026 – Zwei Zielblockfehler gezielt reproduziert

- Auf Nachfrage beide gemeldeten Repositorytests separat mit `flutter test
  --no-pub test/features/aufgaben/data/aufgaben_repository_test.dart --name
  'historische Statuszielbloecke listen laufenden Block nicht|plant reine
  Zielaenderung ab naechstem Zielblock ohne aktive Aufgabe zu aendern'
  --reporter=expanded` ausgeführt: 0 bestanden, 2 fehlgeschlagen.
- Laufender Block erscheint verfrüht in der Historie; Zielvormerkung am
  28. statt 29. Oktober. Befund und Korrekturempfehlung im Arbeitsplan ergänzt.
- Keine Produktcode-/Nutzerdatenänderung und kein vollständiger Testlauf.
  Persönlicher Langzeitbestand nicht geprüft; kein Nachweis von Messwertverlust.

## 27. Oktober 2026 – Gruppen-/Trackerpaket implementiert

#011/#020/#004 gemäß G0–G6 umgesetzt: Gruppentab, kompakte Zahlenfelder,
Entwürfe, atomarer Voll-/expliziter Teilabschluss, Schema 26 und Backup 22–26.
Neue Tests und Analyse grün. Zwei bestehende Zielblock-/Zeitumstellungsfehler
bleiben sichtbar offen; keine uneingeschränkte Gesamtfreigabe. Gerätenachtest
offen, keine APK. [Nachweise](daily_overview_groups_plan.md).

## 25. Oktober 2026 – Gruppen konkretisiert, Monitoring verschoben

- Eigener Gruppentab; zugeordnete Aufgaben/Habits nicht zusätzlich in ihren
  bisherigen Tabs anzeigen. Die übrige Navigation bleibt erhalten.
- Gemeinsamer Abschluss aus #004 jetzt Teil von #020. Vollständig erledigt nur
  bei vollständigen Eingaben und Abschlüssen; fehlende Felder markieren und
  ausdrücklich eine Teilaktion für einfache abhakbare Einträge anbieten.
- Einzelbearbeitung ergibt automatisch den Gruppenstatus. Bewusste Nein-Antworten
  zählen als bearbeitet, individuelle Bewertungen und Messwerte bleiben erhalten.
- Nutzer verschiebt den eigenen Monitoringbereich aus A01 ausdrücklich auf
  später. Gruppentab, Abschlusslogik und kompakte Tracker #011 bleiben im Paket.
- Entscheidungen und gezielte Codebefunde im `daily_overview_groups_plan.md`;
  anschließend technische Vorbereitung auf Nutzerfrage vervollständigt: Auftrag
  G0–G6 mit einfacher Gruppenzuordnung, Daten-/Transaktionsregeln, V1-Sperren,
  Schema-/Backup-Migration und Abnahmetests. Umsetzungsbereit, nicht implementiert.
  Bündelzuordnung zunächst gesperrt, ältere Vorkommen einzeln bearbeiten;
  abgeleitete Grenzen getrennt von ausdrücklichen Nutzerentscheidungen markiert.
  Nur Dokumentation geändert, keine App-Tests/Builds ausgeführt.

## 22. Oktober 2026 – #013 A0–A5 umgesetzt

- Separater Artenwechsel mit zwei expliziten Historienumfängen, gemeinsamer
  Sperrprüfung, Fingerprint, Versions-Pinning und atomarem Schema-25-Protokoll.
- Historische Listen-/Schedulerfilter, aktueller Editor auch bei alten Karten,
  Detailhinweis und Projektbestandskorrektur. Kalender und #002 erhalten.
- Vollständige Suite: 212 Tests grün (65 Sekunden); Analyse 17 Dateien ohne Befunde.
  Migration/Restore 22–25, Korrektur/Undo, Formular und Sperren geprüft.
- Dokumentation aktualisiert; Gerätenachtest separat offen. Keine APK,
  keine anderen Pakete, keine Veröffentlichung. Frühere Planungsstände unten bleiben erhalten.

## 22. Oktober 2026 – #013 zur Umsetzung vorbereitet

- Auf Nutzerauftrag technische Vorbereitung abgeschlossen und eigenen Auftrag
  `task_type_change_implementation_plan.md` mit Paketen A0–A5 erstellt.
- Aktuellen Kalender und inzwischen implementiertes #002 berücksichtigt.
  Keine neue fachliche Fragerunde; bestehende Nutzerentscheidungen erhalten.
- Freigaben/Sperren für Rückstände, Vormerkungen, Bündel und historische
  Konfigurationen konkretisiert. Bestehende Versionen tragen die Artzuordnung;
  ausdrücklich rückwirkende Option korrigiert nur dieses Metadatum und wird
  einschließlich vorheriger Zuordnung protokolliert.
- Notwendige Filterkorrekturen in Tagesansicht/Scheduler/Kalender, separaten
  Wechsel-Command/Dialog, Migration/Backup und konkrete Abnahmetests festgehalten.
- Arbeitsplan und README auf umsetzungsbereit aktualisiert. Nur Dokumentation
  geändert, keine App-Implementierung, Migration, Tests oder APK für #013.

## 22. Oktober 2026 – Ausschließlich #002 umgesetzt

- Vorbereitete Regeln mit aktuellem Kalender-/Historiencode abgeglichen; keine
  neue Produktentscheidung erforderlich. Fremde lokale Änderungen erhalten.
- Startdatum für sichere reine Tracker editierbar; Erwartungsbeginn getrennt
  von Messhistorie, Kalender/Bündel/Korrekturen/Auswertungen angepasst.
- Automatisierte Abnahmefälle für Daten, Kalender, Tagversatz, Wertziele,
  Backup/Restore, Formular und laufende Streams ergänzt. Alle 184 Tests bestanden,
  gezielte Analyse ohne Befunde. Ein bestehendes Testdatum auf lokale Kalendertage
  statt 24-Stunden-Abstände umgestellt (Zeitumstellung); keine Statuszielregel geändert.
- Schema unverändert, keine APK, kein #013 und kein anderes Paket umgesetzt.
  Gerätenachtest im Änderungsdokument bleibt ausdrücklich offen.

## 21. Oktober 2026 – Kalender K0–K7 umgesetzt

- Bestätigten Kalenderauftrag gegen Konzept, Bestand und Sperren abgeglichen;
  keine neuen fachlichen Rückfragen erforderlich. Fremde lokale Planänderungen
  erhalten, keine anderen Phase-21-Themen umgesetzt.
- Schema 24, Zeitplanung/Snapshots, Serienvormerkung, Backup-Kompatibilität,
  separate reine Projektion und atomare Änderungsbefehle ergänzt.
- Vier Ansichten, Filter, separate Sonderlisten, Details, Zeitachsen mit
  Überlappungen, Drag/Resize und alternative Dialogbedienung implementiert.
- 174 Tests im finalen Gesamtlauf bestanden, Analyse ohne Befunde. Historische
  Migrationsfälle und ein DST-abhängiger Alt-Test während Prüfung berichtigt.
- Release-APK `1.0.0+4` gebaut, Manifest und Signatur geprüft; Geräteinstallation
  nicht durchgeführt. Nachweis/Hash/Nachtest in [calendar_retest.md](calendar_retest.md).
- Keine automatische Veröffentlichung, kein anderer Chat angelegt.

## 21. Oktober 2026 – Kalenderauftrag K0–K7 für anderen Chat vorbereitet

- Nutzer beauftragt explizite Arbeitsschritte in der aktuellen Phase, um einen
  anderen Chat mit der Umsetzung beauftragen zu können. Vorhandenen Kalenderplan
  erweitert statt ein konkurrierendes zweites Planungsdokument anzulegen.
- Datenhaltung für Planungszeiten/Snapshots, Vormerkung regelmäßiger Zeitänderungen,
  Migration und Schema-22/23-Backup-Kompatibilität konkretisiert. Neue technische
  Festlegungen als abgeleitet gekennzeichnet; bestätigte Produktregeln erhalten.
- Lesende Projektion, Abschlussabhängigkeiten, Filter/Zählung, atomare Commands,
  vier Ansichten und Sperrfälle beschrieben. K0–K7 mit Abhängigkeiten,
  Codebereichen und überprüfbaren Abnahmekriterien angelegt.
- Kopierbaren Auftrag sowie Paket-/Fortschrittsregeln ergänzt. README und
  Themenübersicht verweisen auf den Auftrag. Alle Umsetzungspakete stehen offen.
- Nur Dokumentation; kein App-Code, keine Migration, kein Testlauf oder Build
  ausgeführt. Kein anderer Chat angelegt und keine GitHub-Veröffentlichung erfolgt.

## 21. Oktober 2026 – Kalenderfilter: Standard nur Aufgaben

- Nutzer präzisiert: Alle Kategorien zuschaltbar, standardmäßig nur Aufgaben.
  Habits und reine Tracker sind optional; vorheriger Vorschlag mit standardmäßig
  sichtbaren Habits ersetzt. Tageszahlen folgen der Filterauswahl.
- Gemeinsamen Filter für alle Ansichten und überschneidungsfreie Einordnung
  reiner Tracker als abgeleitete Ausführungsdetails dokumentiert.
- Erste Fallmatrix ergänzt: einfache freie Termine bearbeitbar, Serien,
  Abschlüsse, Abhängigkeiten und komplexe Zeitfälle geschützt. Zusätzlichen
  Codebefund zur abschlussabhängigen Projektion festgehalten: „ab Datum fällig“
  darf nicht als tägliches neues Vorkommen interpretiert werden.
- Nur Planung geändert, keine Kalenderfunktion implementiert.

## 21. Oktober 2026 – Kalender: Kalendertag entspricht Fälligkeit

- Nutzer bestätigt für V1: Eine freie Aufgabe auf einen anderen Kalendertag
  verschieben ändert zugleich ihre Fälligkeit. Keine zusätzliche unabhängige
  Deadline neben dem Planungstag. Im Kalender-Umsetzungsplan festgehalten.
- Nächste offene fachliche Frage ist die Sichtbarkeit/Zählung reiner Tracker;
  der Kalenderumfang für Aufgaben und Habits wird nicht erneut abgefragt.

## 21. Oktober 2026 – #013 fachlich abgeschlossen, Kalender priorisiert

- Auf Nutzerwunsch #013 als für ihn fachlich abgeschlossen markiert. Technische
  Vorbereitung bleibt Agentenarbeit; keine Umsetzung oder Umsetzungsreife behauptet.
- Neuer Auftrag: aktuelle Kalenderbeschreibung prüfen, umsetzungsbereit planen
  und anschließend in diesem Chat umsetzen.
- Lokaler Kalenderstand war älter. Über den Chat „Momentum Testprotokoll“ und
  GitHub das Kalenderkonzept V0.4 vom 21. Oktober gefunden. Quelldatei von GitHub
  lokal übernommen; eigener Phase-21-Umsetzungsplan verlinkt. Kein Pull/Merge und
  keine Überschreibung bestehender Planungsänderungen.
- Vorprüfung: sichere Zukunftsprojektion fehlt; Zeitplanung muss getrennt von
  gemessenen Werten ergänzt werden. Vorhandener Verschiebepfad unterstützt nur
  offene einmalige Aufgaben, keine bereits abgeschlossenen oder Terminserien.
- Erste offene Produktentscheidung betrifft Planungstag gegenüber Fälligkeit;
  bereits im Konzept enthaltene Ansichten, Sperren und Bedienwünsche nicht erneut
  zur Wahl gestellt. Kein App-Code geändert, kein intensiver Gesamtumbau begonnen.

## 21. Oktober 2026 – Seltene Konvertierung ausgeschlossen, Planung begrenzt

- Nutzer präzisiert: Alle Fälle bedenken, komplexe Fälle jedoch zunächst sperren
  statt auszuarbeiten. Arbeitsregel und Plan um Fallübersicht, Sperrgrund,
  Nutzerhinweis und Absicherung beim Speichern ergänzt. Kein Auftrag, Randfälle
  zu ignorieren; vorläufige Sperren selbst ableiten, Kernanforderungen bewahren.
- Nutzer schließt einmalige Aufgabe → Habit ausdrücklich aus. Einen neuen Habit
  anzulegen ist für diesen seltenen Fall ausreichend. Frühere Frage nach einer
  speziellen Rhythmusauswahl war unnötige Ausweitung; Vorschlag verworfen.
- Beide bestätigten Optionen zur historischen Artzuordnung bleiben erhalten.
  Rhythmuserhalt beim begrenzten Artenwechsel als abgeleitete Umsetzung notiert.
- Arbeitsregel in AGENTS.md und Plan ergänzt: Alltagsnutzen und Aufwand abwägen,
  seltene Komfortfälle mit einfachem Ausweg nicht perfektionieren; Fragen auf
  relevante Folgen beschränken. Nur Dokumentation geändert.

## 16. Oktober 2026 – Beide Umfänge des Artenwechsels bestätigt

- Nutzer verlangt bei #013 beide Optionen zur Auswahl: Artenwechsel ab dem
  Wechsel sowie Umordnung einschließlich bisheriger Einträge.
- Im Plan als feste Anforderung übernommen; die vorherige Empfehlung nur für
  künftige Zuordnung ist damit keine Einschränkung des Umfangs.
- Nächste offene Regel: bestehenden Rhythmus erhalten und bei einmaliger
  Aufgabe → Habit einen Rhythmus ausdrücklich wählen. Noch unbestätigter Vorschlag.

## 16. Oktober 2026 – Planung mit #013 fortgesetzt

- Nutzer möchte nach Vorbereitung von #002 zunächst weiter planen. Keine
  Implementierung von #002 begonnen; nächstes konkretes Thema ist #013.
- Originalwunsch Konvertierung ohne Neuanlage übernommen. Gemeinsame Datenstruktur,
  getrennte Felder für Art/Rhythmus und historische Artzuordnung gezielt geprüft.
- Noch offene Entscheidung zur Zuordnung bisheriger Einträge im Plan festgehalten:
  Wechsel ab jetzt versus ausdrücklich rückwirkende Korrektur der Art. Empfehlung
  des Agenten bleibt als unbestätigter Vorschlag erkennbar.

## 16. Oktober 2026 – Technische Umsetzung von #002 vorbereitet

- Nach Bestätigung gezielt Startänderung, Definitionsauflösung, Werteingabe,
  Korrekturen, Tagesanzeige, Einzel-/Bündelauswertung und Wertziele geprüft.
- Umsetzung im Plan konkretisiert: aktuelle Startgrenze für erwartete reine
  Messungen von unveränderter Definitionszuordnung vorhandener Werte trennen;
  vorhandene Speicherfelder reichen nach dem vorgesehenen Ansatz aus.
- Zusätzliche Ausblendungsstelle in Bündel-Tagesanzeige und -Auswertung erkannt:
  vorhandene Messpaare dürfen nicht allein wegen fehlender Fälligkeit entfallen.
- Gemeinsame Freigabeprüfung, Speichervorgang, frühere Definitionszuordnung,
  Formular, Auswertungsgrenzen und gezielte Abnahmefälle dokumentiert. Technische
  Festlegungen ausdrücklich von Nutzerentscheidungen unterschieden.
- Keine weitere Grundsatzfrage festgestellt. Keine App-Codeänderung, kein
  Testlauf und kein neuer Build für diese Dokumentationsarbeit.

## 16. Oktober 2026 – Startdatum: Werte erhalten, Terminserien vorerst sperren

- Nutzer bestätigt für #002: Startdatum darf hinter vorhandene Messwerte
  verschoben werden. Diese bleiben sichtbar und in passenden Auswertungen
  enthalten; das neue Datum steuert den Beginn erwarteter Messungen.
- Nutzer schlägt zur Vereinfachung die vorläufige Sperre für wiederkehrende
  Aufgaben vor, um deren Neuberechnung zu verhindern; als Grenze festgehalten.
- Gezielter Codebefund: Reines Tracking erzeugt auch bei täglicher Anzeige keine
  automatische Terminserie. Die Sperre deshalb nicht pauschal anhand eines
  gesetzten Wiederholungsrhythmus auf den gewünschten Gewichtstracker ausweiten.
- Bisherige Auswertungsgrenze am Startdatum würde frühere Werte ausblenden.
  Erforderliche Trennung von Messhistorie und erwarteten Messtagen sowie
  Prüffälle im Plan ergänzt. Nur Dokumentation geändert; Umsetzung noch offen.

## 16. Oktober 2026 – Anforderungen und eigene Vorschläge abgeglichen

- Auf Nutzerauftrag Originalmeldungen #001–#020, A01/A02 und T20-01 gegen
  aktive Planung und bisherige Gesprächsentscheidungen geprüft.
- Restliche Verengung von #002 auch in Titel/Themenübersicht entfernt. Bei
  #003/#015 den zunächst zu engen Vorschlag ohne Optionen vom später durch den
  Nutzer bestätigten und umgesetzten Einstellungsumfang unterschieden.
- #013: Kopie nicht als Ersatz für gewünschte Konvertierung behandeln. A02:
  bereits beschriebene Quick-Task-Regeln nicht erneut zur Grundsatzfrage machen.
  #020: Gruppenbenennung und Reihenfolge ausdrücklich im Paket erhalten.
- Vorläufige Priorisierung nicht als bestätigte Zurückstellung kennzeichnen;
  Auswahl Timer/manuell/beides bei #016 weiterhin offen lassen. Technische
  Ausführungsdetails von ausdrücklich bestätigten Kartenregeln getrennt.
- Bereits dokumentierte Nutzeränderungen bei #001/#007/#014 bleiben gültig;
  keine weitere ersetzende Umdeutung in den übrigen geprüften Punkten gefunden.
- Verbindliche Regel gegen Anforderungsverschiebung in `AGENTS.md` und im
  Arbeitsplan ergänzt. Nur Dokumentation/Arbeitsregeln geändert, kein App-Code.

## 16. Oktober 2026 – Kartenpaket bestätigt und umgesetzt

Klarstellung zu #002: Der Nutzer verweist auf seine bereits konkrete Beschreibung.
Startdatum früher/später ändern bleibt der maßgebliche Wunsch. Der alternative
Vorschlag eines separaten Nachtragswegs wurde nicht bestätigt und ersetzt ihn
nicht. Weitere Fragen sollen sich auf tatsächlich offene Folgen beschränken.

Anschließend fordert der Nutzer „weiter“ an. #002 wird als nächstes Thema gezielt
vorgeprüft. Startgrenze, Definitionsversionen und virtuelle fehlende Messungen
begründen die erste Konzeptfrage: alte Messwerte ergänzen oder den aktiven
Trackingbeginn ändern? Empfehlung und Befunde im Arbeitsplan, noch keine
Entscheidung oder Implementierung. Karten-Gerätenachtest weiterhin offen.

- Nutzer bestätigt Standards kompakt/mehrere, dauerhaftes Merken je Aufgabe oder
  Bündel, gespeichertes automatisches Schließen und Aufnahme in die Sicherung.
  Damit sind die unten im früheren Gesprächsverlauf noch offenen Regeln geklärt.
- Optionsseiten, gemeinsame Aufklappsteuerung und kompakte Aufgaben-/Bündelkarten
  umgesetzt. Datenbankschema 23 mit zwei getrennten Präferenztabellen; Schema-22-
  Sicherungen erhalten beim Import die Standardwerte. Keine Änderung der Historie.
- Gezielte Tests für Speicherung/Migration, Backup, Optionen, Einzelkartenregel,
  mehrere Instanzen und Eingabeerhalt erfolgreich. Eine fehlerhafte Speicherung
  des globalen Einstellungsdatensatzes und ein schmaler Checkbox-Text wurden
  während der Tests korrigiert. Statische Analyse ohne Befunde.
- Begrenzter Standards- und Spec-Review gemäß Implementierungs-Skill: jeweils
  keine relevanten Findings. Kein zusätzlicher Refactoring-Umfang eröffnet.
- Erster vollständiger Testlauf traf alte Schema-22-Erwartungen in zwei
  Migrationstests sowie 30-Sekunden-Zeitüberschreitungen bei hoher Parallelität.
  Erwartungen auf 23 aktualisiert; Abschlusslauf mit zwei parallelen Tests und
  zwei Minuten Zeitlimit pro Test: **156 Tests erfolgreich**, keine offenen
  Fehler. Finale Analyse ohne Befunde. Bericht `build/phase21-tests.json`.
- Android-APK `1.0.0+3` erfolgreich gebaut. Geräteupdate/Nachtest offen; Anleitung
  im Dokument zum umgesetzten Stand. Phase 20 und die übrigen Themen laufen weiter.

## 16. Oktober 2026 – Einstieg in die gemeinsame Ausarbeitung

Anzeigemodi präzisiert und bestätigt: „Kompakt starten“, „Aufgeklappt starten“,
„Letzten Zustand merken“. Manuelle Umschaltung bleibt in allen Modi möglich;
Einzelkartenregel bei aufgeklapptem Start deaktiviert, ihre Auswahl bleibt für
andere Modi erhalten. Standards und dauerhafte Zuordnung/Sicherung noch offen.

Ergänzung zur Kartenanzeige: Nutzer verlangt Seitenleiste → Optionen →
Kartenanzeige mit Modi klein/groß/dauerhaft merken sowie einer separaten Wahl
zwischen einer oder mehreren offenen Karten. Frühere Empfehlung ohne
Einstellungsseite/dauerhafte Speicherung ersetzt. Bündel-Kompaktdarstellung
und einheitliches Verhalten bei abgeschlossenen Aufgaben bestätigt.
Zusammenspiel der Modi und Speicherung noch in Klärung.

Weitere Entscheidung zu #003/#015: Nutzer bestätigt kompakte Karten mit Titel
und direkter Bedienung; Beschreibung/Zusatzinformationen und ausgewählte
Kennzahlen erst aufgeklappt. Kennzahlenauswahl bleibt gespeichert. Vorschläge
zu Standardzustand, mehreren offenen Karten, Ansichtswechsel und Bündeln sind
noch nicht bestätigt.

Aktualisierung: Nutzer bestätigt das installierte Update und Sicherungsexport
nach Google Drive (Geräterückmeldung im Phase-20-Verlauf) und wählt anschließend
#003/#015 als nächstes Paket. Gezielte Sichtung der Karten und Eingaben im Plan
festgehalten; Darstellungsentscheidungen noch offen, keine App-Codeänderung.

- Nutzer präzisiert den früheren Planungsprompt: Testergebnisse hier ausarbeiten
  und geklärte Pakete anschließend auch hier umsetzen. Akute Punkte zuerst;
  intensive Arbeiten vorher abstimmen, leicht änderbare Details knapp bündeln.
- Bestehende Themenliste mit Originalmeldungen und ausgewählten Codepfaden
  abgeglichen. Ergänzende Einordnung nach Handlungsbedarf und wesentliche
  Abhängigkeiten im Arbeitsplan festgehalten; Priorisierung bleibt vorläufig.
- Bereits vorhandene Implementierung von noch ausstehenden Gerätenachtests
  getrennt. Installiertes Update und externe Sicherung als erste Sachfrage offen.
- Nur Phase-21-Dokumentation ergänzt; keine App-Änderung oder erneuten Tests.

## 16. Oktober 2026 – Eigene Verbesserungsphase eingefügt

- Nutzer wünscht eine eigene Phase nach der Testphase für Ausarbeitung,
  Änderungen, Erweiterungen und deren aktuellen Stand.
- Neue Phase 21 „Testergebnisse ausarbeiten und umsetzen“ angelegt. Bisherige
  Phase 21 „Store-Release“ wird Phase 22, einschließlich Ordner, Verweisen und
  Schrittnummern. Weitere spätere nummerierte Phasen sind nicht vorhanden.
- Originale Beobachtungen bleiben in Phase 20. Aktive Priorisierung, bestätigte
  Änderungsregeln und Umsetzungsstand werden ab jetzt in Phase 21 geführt.
- Alle #001–#020, A01/A02 und T20-01 im Arbeitsplan berücksichtigt. Noch offene
  Konzepte sind als solche markiert; keine zusätzlichen Features beauftragt.
- Erstes Paket aus Commit `7263ea9` übernommen: Backup/Wiederherstellung (#014),
  Datumsauswahl (#001) und Sieben-Tage-Erledigungsdiagramm (#007), einschließlich
  bestätigter vorläufiger Sperre der Zukunftsnavigation. APK `1.0.0+2`, Schema 22,
  149 Tests bestanden und Analyse fehlerfrei laut Implementierungsabnahme.
  Geräteupdate und Sicherung auf dem Handy noch nicht bestätigt.
- Der frühere Ausführungsverlauf verbleibt als historischer Nachweis im
  [Phase-20-Verlauf](../phase_20_private_test/private_test_history.md).
- Weitere Fachkonzepte sollen in einem neuen Chat ausgearbeitet und anschließend
  im bisherigen Chat umgesetzt werden. In dieser Runde nur Dokumentation
  neu geordnet; keine App-Änderung, neuer Build oder erneute Testsuite.
