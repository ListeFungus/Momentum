# Momentum – Phase 18: Projekte

Stand: 6. Oktober 2026  
Status: Phase 18 umgesetzt und automatisiert abgenommen

## Umsetzungsabschluss

Die Pakete 18a bis 18e sind abgeschlossen:

- Schema 21 ergänzt Projekt-Lebenszyklus, unabhängige Bündelzuordnung sowie
  revisionsgebundene Löschvorgänge und -mitglieder. Eine echte Schema-20-
  Fixture und der ältere Schema-19-Pfad migrieren mit leerem
  `foreign_key_check`.
- Der gemeinsame Zuordnungsdienst unterstützt Aufgaben und Bündel mit
  Stichtag, Historienverschiebung, Vormerkung, Abbruch und geschütztem Undo.
- Archiv, beide Papierkorbvarianten, Restore nur des Projekts oder des
  unveränderten Lösch-Batches, 168-Stunden-Frist und anonymer endgültiger
  Identitätsverweis sind umgesetzt.
- Projektübersicht trennt Aufgaben, Habits und Bündel. Die Analyse bietet
  7/20/30 Tage sowie „Seit Beginn“ und getrennte Statusbereiche ohne
  fachlich falsche Projektsumme oder Erfolgsquote.
- Metadaten- und Zuordnungsbearbeitung sind getrennt. Projektvorauswahl bei
  Aufgaben- und Bündelerstellung, Archiv, gemeinsamer Papierkorb und
  konkrete Lösch-/Restore-Vorschauen sind angebunden.

Automatisierte Abnahme: Drift-Codegenerierung erfolgreich, vollständige
Analyse ohne Befund, echte Migration 19/20 → 21 sowie Projekt-/Zuordnungs-/
Lebenszyklusregressionen grün. Der gemeinsame Abschlusslauf
`flutter test --no-pub test\features\aufgaben test\features\projekte
test\widget_test.dart` endete mit **138 bestandenen Tests**.

## Planungsauftrag und Arbeitsweise (historischer Planungsrahmen)

- Dieser Abschnitt beschreibt den Rahmen, in dem Phase 18 vor der inzwischen
  abgeschlossenen Umsetzung vorbereitet wurde.
- Bestätigte Entscheidungen, offene Fragen und Vorschläge werden getrennt gehalten.
- Zuerst Zweck und grundlegende Regeln klären, danach Umsetzungspakete,
  betroffene Schnittstellen und gezielte Abnahmekriterien festhalten.
- Bestehende Code- und Dokumentationsfakten selbst prüfen; Produktentscheidungen
  mit dem Nutzer klären. Grundsatzfragen einzeln, leicht änderbare Details später
  als kompakte Sammelliste behandeln.
- Aufwand und Kontingent schonen: Dokumentation und Code zunächst überblicken,
  relevante Abhängigkeiten gezielt vertiefen. Aufwendige Zusatzuntersuchungen
  vorher abstimmen. Keine vorsorgliche Implementierung späterer Module.
- Präzisierung vom 6. Oktober 2026: Die kleinste schlüssige, schnell umsetzbare
  Lösung bevorzugen. Erweiterbarkeit durch stabile Identitäten, klare
  Zuständigkeiten und zentrale Regeln erhalten; keine vorsorglichen Frameworks,
  zusätzlichen Modi oder Datenfelder für lediglich denkbare Erweiterungen.
  Leicht nachrüstbare Details bündeln. Grundsatzfragen nur vertiefen, wenn sie
  Datenbestand, Nutzerverständnis oder spätere Schnittstellen beeinflussen.

## Erster Abgleich am 4. Oktober 2026

Der ursprüngliche Entwurf stammte aus Juli. Die folgenden Befunde waren der
Ausgangspunkt der Planung; ihre Konsequenzen sind in den Verträgen T18-01 bis
T18-05 und den Arbeitspaketen berücksichtigt:

- `task_project_assignment_service.dart` besitzt bereits datumsbezogene
  Zuordnungen, Vormerkungen, Verschieben der gesamten Historie und Undo.
  Phase 18 muss diese Regeln aus Phase 16 übernehmen und darf keine zweite
  Zuordnungslogik einführen.
- `ProjectRepository.watchProjectDetail` berücksichtigt historische
  Definitionen und die datumsbezogene Projektzuordnung; Aufgaben im Papierkorb
  werden ausgeschlossen. Aktuelle Mitgliedschaft und historische Beiträge
  müssen für die künftige Oberfläche dennoch ausdrücklich getrennt definiert werden.
- Die bisherige Projektkennzahl `completionRate` zählt ausschließlich
  `success` als abgeschlossene Einträge. Das entspricht nicht dem im
  Wurzelglossar definierten Anteil aller verarbeiteten/abgeschlossenen Instanzen.
  Vorhandene Anzeige daher nicht ungeprüft als fachlichen Standard übernehmen.
- `ProjectRepository.deleteProject` enthält bereits eine physische Löschung
  des Projekts mit vorheriger Abzuordnung aktuell zugeordneter Aufgaben außerhalb
  des Papierkorbs. Das ist keine bestätigte Löschregel für Phase 18; historische,
  vorgemerkte und Papierkorb-Zuordnungen werden in T18-03 behandelt.
- Phase 17 sieht wiederverwendbare Lebenszyklusoperationen für eine später
  bestätigte Aufgabenmenge vor. Projekt-Papierkorb und Gruppierung gemeinsamer
  Löschungen bleiben ausdrücklich Phase 18 überlassen.
- Die Projekttabelle enthält bislang keine eigenen Lebenszyklusfelder.
  Phase 19 bleibt für die eigentliche Sync-Vorbereitung zuständig.

## Bestätigte Produktentscheidungen

### P18-01 – Flexibler Ordnungsrahmen

Bestätigt am 4. Oktober 2026: Nutzer können Projekte sowohl für dauerhafte
Bereiche (z. B. Gesundheit) als auch für abschließbare Vorhaben (z. B. Umzug)
verwenden. Die App schreibt keinen Verwendungszweck oder verpflichtenden
Projekttyp vor. Leitprinzip: flexibel für den Nutzer, ohne unnötige Komplexität.

Erledigte Aufgaben ergeben keinen automatischen Projektabschluss. Ein
gemeinsames Projektmodell genügt; keine getrennten Modelle für Bereiche und
Vorhaben einführen. Das manuelle Herausnehmen aus der aktiven Projektübersicht
ist durch die Archivierung in P18-02 geregelt.

### P18-02 – Reversible Projektarchivierung

Bestätigt am 6. Oktober 2026: Phase 18 erhält eine einfache Archivierung.

- Ein archiviertes Projekt verschwindet aus der aktiven Projektübersicht und
  bleibt über eine Archivansicht erreichbar. Es kann wieder aktiviert werden.
- Projektidentität, Zuordnungen, Historie und Auswertbarkeit bleiben erhalten.
- Archivieren verändert ausschließlich die Sichtbarkeit des Projekts. Aufgaben
  und Habits werden weder pausiert noch abgeschlossen, gelöscht oder abzugeordnet.
  Ihre Planung, Tagesanzeige und Auswertung laufen unverändert weiter.
- Entsprechend beendet das Zurückholen aus dem Archiv keine unabhängig
  gesetzte Aufgabenpause und verändert keine Aufgaben-Lebenszyklen.
- Kein zusätzlicher Status „abgeschlossen“ in Phase 18. Archivierung bedeutet
  weder Zielerreichung noch einen eingefrorenen Auswertungsstand.
- Die Bedienung muss erklären, dass zugeordnete Aufgaben weiterlaufen.

Umsetzungsfolgen: Archivzustand am Projekt speichern, aktive Projektliste und
Archivzugang unterscheiden; Aufgaben-Scheduler und Zuordnungshistorie dafür
nicht verändern. Abnahmefälle: Archivieren/Zurückholen erhält IDs und Daten;
laufende Habits bleiben in der Tagesansicht; unabhängig pausierte Aufgaben
bleiben pausiert. Die Auswahl archivierter Projekte regelt P18-11.

### P18-03 – Zwei Löschoptionen mit Projekt-Papierkorb

Bestätigt am 6. Oktober 2026: Beide Optionen gehören zu Phase 18:

| Aktion | Wirkung |
|---|---|
| Nur Projekt löschen | Projekt kommt in den Papierkorb. Aufgaben und Habits bleiben erhalten und werden aktuell projektlos. |
| Projekt samt zugeordneten Aufgaben löschen | Projekt und aktuell zugeordnete Aufgaben/Habits kommen gemeinsam in den Papierkorb. Früher zugehörige, inzwischen verschobene Aufgaben bleiben unberührt. |

Es erfolgt keine sofortige endgültige Löschung. Die bestehende Standardfrist
von sieben Tagen gilt auch für Projekte. Archivierung bewahrt ein Projekt
dauerhaft auf; der Papierkorb ist die zeitlich begrenzte Rückholmöglichkeit.
Die bestehende Aufgaben-Lebenszykluslogik aus Phase 17 wird wiederverwendet.

Umsetzungsfolgen: Der bisherige direkte `deleteProject`-Pfad darf die neue
Papierkorblogik nicht umgehen. Die bestätigte betroffene Aufgabenmenge und das
Projekt müssen transaktional verarbeitet werden. Historische Beiträge allein
sind kein Kriterium für die Auswahl gemeinsam zu löschender Aufgaben.

Bereits einzeln gelöschte Inhalte, Vormerkungen und Quellenabhängigkeiten
werden durch P18-04/P18-09 und die technischen Verträge weiter unten geregelt.

### P18-04 – Wiederherstellung einer gemeinsamen Löschung

Bestätigt am 6. Oktober 2026: Beim Wiederherstellen kann der Nutzer zwischen
„Nur Projekt“ und „Projekt samt gemeinsam gelöschten Aufgaben“ wählen.

- Die App merkt sich, welche Aufgaben bei genau dieser Projektlöschung
  mitgelöscht wurden. Eine aktuelle oder historische Projektzuordnung allein
  reicht nicht zur Ermittlung der wiederherzustellenden Aufgaben.
- Bereits vorher separat gelöschte Aufgaben werden nicht mit zurückgeholt.
- Zwischenzeitlich wiederhergestellte oder neu zugeordnete Aufgaben werden
  nicht überschrieben. Eine später erneut gelöschte Aufgabe gehört zu einem
  neuen Löschvorgang und darf nicht durch die alte Sammelaktion zurückkehren.
- „Nur Projekt“ stellt keine mitgelöschten Aufgaben wieder her.
- Die bestehende Wiederherstellungsfrist und die Aufgabenregeln aus Phase 17
  gelten weiterhin; insbesondere keine nachträglichen Pflichtinstanzen für
  die Papierkorbzeit erzeugen.

Umsetzungsfolgen: Zusammengehörigen Löschvorgang mit betroffenen IDs und einer
prüfbaren Zuordnung zum jeweiligen Löschzustand speichern. Ein dauerhaftes
Projekt-ID-Feld an der Aufgabe genügt dafür nicht. Die aktuelle
`lifecycleRevision` ist bei der technischen Ausarbeitung als vorhandener
Baustein zu prüfen. Wiederherstellung transaktional ausführen; bereits endgültig
gelöschte Daten nicht rekonstruieren.

Gezielte Abnahme: gemeinsame Wiederherstellung; nur Projekt zurückholen;
vorher separat gelöschte Aufgabe; zwischenzeitlich wiederhergestellte und
verschobene Aufgabe; erneut gelöschte Aufgabe; abgelaufene Frist.

Die Wiederherstellung nach „Nur Projekt löschen“ regelt P18-06.

### P18-05 – Historische Bezüge nach Projektlöschung

Bestätigt am 6. Oktober 2026: Ältere Einträge behalten ihre damalige Projektidentität;
das Löschen eines Projekts verschiebt sie nicht rückwirkend nach „ohne Projekt“.
Im Papierkorb kann die Darstellung den erhaltenen Projektnamen mit Löschhinweis
verwenden. Nach endgültiger Löschung bleibt nur ein minimaler technischer
Identitäts-/Löschverweis; Anzeige „Gelöschtes Projekt“, ohne erhaltenen Namen,
Beschreibung oder Farbe. Einzelaufgaben behalten ihre Einträge und Auswertungen.

Prüfbefund: `Aufgaben.projectId` und die beiden Projektverweise in
`TaskProjectAssignmentChanges` verwenden aktuell `ON DELETE SET NULL`, während
`TaskDefinitionVersions.projectId` ein freier Textverweis ist. Vor endgültiger
Projektlöschung muss der Referenzvertrag daher gezielt abgesichert werden;
bloßes Löschen der Projektzeile genügt nicht. Die einfachste tragfähige
Speicherung des minimalen Löschverweises ist bei der technischen Planung zu
wählen; eine eigene neue Tabelle oder ein allgemeines Historienframework
ist dafür nicht vorgegeben.

Abnahme: „Nur Projekt löschen“ erhält alle Aufgabeneinträge und deren
Auswertungen; ältere Zuordnungen bleiben vor und nach endgültiger Bereinigung
derselben ehemaligen Projekt-ID zugeordnet. Nach der Bereinigung sind Name,
Beschreibung und Farbe entfernt. Archivierung bleibt der Weg zum dauerhaft
benannten und einsehbaren Projektverlauf.

### P18-06 – Keine automatische Neuzuordnung beim Zurückholen des Projekts

Bestätigt am 6. Oktober 2026: Nach „Nur Projekt löschen“ bleiben die erhaltenen
Aufgaben beim Wiederherstellen des Projekts projektlos, sofern der Nutzer sie
inzwischen nicht anderweitig zugeordnet hat. Solche neueren Zuordnungen bleiben
unverändert. Das Projekt wird mit seiner historischen Identität zurückgeholt;
aktuelle Aufgaben können über die normale Zuordnung wieder hinzugefügt werden.

Keine zusätzliche Rücksetzlogik für die damalige Mitgliedschaft implementieren.
Die gemeinsame Wiederherstellung tatsächlich mitgelöschter Aufgaben nach
P18-04 bleibt davon unberührt. Abnahme: nur Projekt löschen, Aufgabe weiter
nutzen oder anderweitig zuordnen, Projekt wiederherstellen; aktuelle Zuordnung
und Einträge bleiben unverändert, historische Projektbezüge bleiben erhalten.

### P18-07 – Einfache Aktivitätsauswertung zum Start

Bestätigt am 6. Oktober 2026: Phase 18 erhält eine einfache Projektübersicht
und grundlegende Aktivitätsauswertung. Genauere Auswertungen können später folgen.

- Übersicht zeigt aktuell zugeordnete Aufgaben/Habits; Analyse zeigt Einträge
  gemäß der historischen Zuordnung im gewählten Zeitraum. Das sind getrennte
  Datenmengen, auch wenn sie auf derselben Detailseite angeboten werden.
- Vorhandene Zeiträume wiederverwenden: letzte 7, 20, 30 Tage und seit Beginn.
- Zum Start verständliche Anzahlen statt eines pauschalen Projektfortschritts:
  offene, erfolgreiche, erfasste, nicht erfolgreiche und ohne Antwort
  abgeschlossene Einträge nach bestehenden Statusregeln.
- Kein gemeinsamer Zielerreichungswert, keine Summe unterschiedlicher Einheiten,
  keine neue Projektbewertung und kein pauschaler Projektfortschritt in Prozent.
  Die bisherige Projekt-Completion-Rate gehört nicht zum Startumfang.
  Einzelwerte und Ziele bleiben in der jeweiligen
  Aufgaben-/Habit-Auswertung erreichbar. Erweiterte Analysen später ergänzen.

Prüfbefunde: `ProjectDetailScreen` bietet bereits Übersicht/Analyse, aber keine
Zeitraumauswahl. Seine Filter interpretieren fehlende offene Instanzen bereits
als abgeschlossene Aufgabe; das darf bei fortlaufenden Habits nicht als deren
dauerhafter Abschluss übernommen werden. `TaskAnalyticsSummary` trennt bereits
`success`, `recorded`, `failure`, `no_entry` und `pending`; seine Completion Rate
enthält alle abgeschlossenen Status. Diese vorhandenen Begriffe wiederverwenden.
T18-04 definiert die Zählgrundlage bei reinem Tracking, Pausen und Bündeln,
damit keine virtuellen Pflichteinträge oder doppelten Beiträge entstehen.

### P18-08 – Bündelergebnisse als eigenständig nutzbare Projektinhalte

Nutzeranforderung vom 6. Oktober 2026: Ein Bündel ergibt einen eigenen Wert,
etwa Schlafdauer aus Einschlaf- und Aufstehzeit. Dieser muss eigenständig
auswertbar und nutzbar sein und in einem Projekt vorhanden sein können.
Der zuvor vorgeschlagene Ausschluss eigener Bündel-Projektinhalte ist verworfen.
Die unabhängige Projektzuordnung ist bestätigt; Darstellung und Integration
sind durch P18-09 bis P18-11 und die technischen Verträge konkretisiert.

Gezielter Codeabgleich: Die vorhandene `TaskValueBundleAnalyticsSummary`
enthält bereits Zeitreihenpunkte, Summe, Durchschnitt, Minimum, Maximum sowie
vollständige, teilweise, fehlende und nicht berechenbare Ergebnisse.
`TaskValueBundleDetailScreen` bietet Zeiträume und eine eigene Zielauswertung.
Diese Fähigkeiten wiederverwenden; keine neue Berechnungs-/Analyselogik allein
für die Aufnahme in Projekte bauen. Bündel und Bündelversionen besitzen bisher
keine `projectId`; Projektzuordnung und Einbindung in die Projektansicht fehlen.

Bestätigt am 6. Oktober 2026: Bündel erhalten eine optionale eigene Zuordnung
zu höchstens einem Projekt, unabhängig von den Projektzuordnungen ihrer Quellen.
Das Projekt zeigt das Bündel als eigenen Inhalt mit Zugang zur vorhandenen
Bündelauswertung. Die berechneten Werte bleiben aus den ursprünglichen
Quell-Einträgen abgeleitet; keine Kopie als zusätzliche manuell erfassbare
Aufgabe erzeugen. Das erhält die bestehende Aktualisierung bei Quellkorrekturen.

Zuordnungswechsel und Projekt-Lebenszyklus sind durch P18-09 geregelt,
die Projektanalyse durch P18-10. Quell-Einträge dürfen durch mehrere
Bündelverknüpfungen weiterhin nicht mehrfach zählen.

Aufwandseinordnung: Zusätzlicher Umfang liegt in Zuordnung, Projektanzeige und
Lebenszyklus-/Historienintegration. Eigenständige Bündelauswertung existiert
bereits. Die Arbeitspakete unten begrenzen diesen Umfang; keine zusätzliche
Berechnungsplattform oder kopierte Rohwerte einführen.

### P18-09 – Einheitliche Projektregeln für Bündel

Bestätigt am 6. Oktober 2026: P18-02 bis P18-06 werden sinngemäß auf direkt
zugeordnete Bündel erweitert. „Projekt samt Inhalten löschen“ umfasst Aufgaben,
Habits und Bündel, die selbst zum bestätigten Löschumfang gehören.

- Zuordnung ab Stichtag oder gesamte Historie verschieben; dieselben
  Datumsgrenzen und Regeln für Vormerkungen wie bei Aufgaben verwenden.
  Für historische Bündelergebnisse ist der Bündel-Auswertungstag maßgeblich,
  nicht der ggf. versetzte Tag einer Quelle. Die Zuordnung der Quellen bleibt
  davon unabhängig.
- Archivieren des Projekts verändert weder Bündel noch Quellen.
- „Nur Projekt löschen“ macht direkt zugeordnete Bündel aktuell projektlos;
  Zurückholen des Projekts stellt keine aktuelle Zuordnung automatisch wieder her.
- Gemeinsames Löschen erfasst direkt zugeordnete Bündel; gemeinsame
  Wiederherstellung berücksichtigt denselben Löschvorgang und schützt spätere
  Änderungen. Historische Projektidentität bleibt gemäß P18-05 erhalten.
- Quellen werden nur mitgelöscht, wenn sie selbst zum bestätigten
  Projekt-Löschumfang gehören. Eine Bündelverknüpfung zieht keine Quelle und
  kein anderes Bündel automatisch mit.
- Betroffene Bündel außerhalb des Löschumfangs bleiben erhalten. Fehlende
  Quellen und die Folgen für Berechenbarkeit/Auswertung nach Phase 17 behandeln
  und in der Löschvorschau erklären.

Abnahmebeispiel: Nur Bündel „Schlafdauer“ gehört zu „Gesundheit“, beide
Uhrzeit-Quellen sind projektlos. Projekt samt Inhalten löschen verschiebt das
Bündel in den Papierkorb und lässt beide Quellen unverändert. Gehört eine
Quelle ausdrücklich ebenfalls zum Projekt, umfasst die bestätigte Aktion auch
diese Quelle; weitere davon abhängige Bündel bleiben als eigene Objekte bestehen.

### P18-10 – Getrennte Statusbereiche in der Projektanalyse

Bestätigt am 6. Oktober 2026: Zum Start zwei klar bezeichnete Bereiche im
selben Analyse-Tab:

- Aufgaben-/Habit-Einträge mit den bestätigten Statusanzahlen aus P18-07.
- Ergebnisse zugeordneter Bündel mit den vorhandenen Begriffen „vollständig“,
  „teilweise“, „fehlend“ und „nicht berechenbar“. Werte und Ziele je Bündel über
  dessen vorhandene Detailauswertung öffnen; keine neue gemeinsame Messwertsumme.

Keine Addition beider Bereiche zu einer vermeintlichen Zahl erledigter Aufgaben.
Ein Quell-Eintrag zählt unter Aufgaben genau einmal; ein abgeleitetes Ergebnis
zählt unter Bündelergebnissen einmal pro Bündel und Auswertungstag. Zwei
Uhrzeitwerte plus eine Schlafdauer können damit zwei erfasste Quellwerte und
ein vollständiges Bündelergebnis ergeben, ohne drei manuelle Erfassungen oder
drei Erfolge zu behaupten. Es zählen nur die jeweils selbst historisch dem
Projekt zugeordneten Objekte, nicht automatisch deren Quellen/Verknüpfungen.

### P18-11 – Einfaches Bedienpaket

Bestätigt am 6. Oktober 2026:

1. Projektübersicht zeigt standardmäßig alle aktuell zugeordneten Inhalte,
   gegliedert in Aufgaben, Habits und Bündel. Pausierte bzw. abgeschlossene
   Inhalte sind entsprechend gekennzeichnet. Keine zusätzlichen Spezialfilter
   für den Start; frühere Mitgliedschaft gehört in die Analyse, nicht in die
   aktuelle Inhaltsliste.
2. Neue Aufgaben/Habits können direkt aus einem aktiven Projekt über die
   vorhandene Erstellung angelegt werden; das Projekt ist vorausgewählt.
   Bestehende Aufgaben/Habits/Bündel lassen sich zuordnen. Neue Bündel entstehen
   weiterhin über die vorhandene Bündelerstellung bei ihren Quellen, ergänzt
   um die eigene Projektauswahl; kein zweiter Bündel-Erstellungsassistent.
3. Archivierte Projekte bleiben über einen Archivzugang erreichbar und bei
   vorhandenen Zuordnungen sichtbar gekennzeichnet. Für neue Zuordnungen werden
   aktive Projekte angeboten; ein archiviertes Projekt wird dafür zuerst
   zurückgeholt. Bestehende Zuordnungen und bereits vereinbarte Planung bleiben
   durch Archivierung unverändert.
4. Analyse startet mit „Letzte 7 Tage“, entsprechend der vorhandenen
   Bündelauswertung. Die übrigen bestätigten Zeiträume bleiben auswählbar.

## Technischer Abgleich – fortlaufende Arbeitsgrundlage

Keine Umsetzung in diesem Chat. Gesicherte Befunde für die Paketplanung:

| Bereich | Ist-Stand | Folge für Phase 18 |
|---|---|---|
| Datenbank | `AppDatabase.schemaVersion` ist 20. | Nächste Migration auf dem tatsächlichen Schema 20 aufbauen; vor Umsetzung Versionsstand erneut prüfen. |
| Zuordnung im Projekteditor | `TaskAssignmentSection` und Create/Edit verwenden ausschließlich Aufgaben-IDs. | Bündel mit Typ und ID aufnehmen; Projektmetadaten und tatsächliche Mitgliedschaftsänderungen getrennt verarbeiten. |
| Projektleser | `watchProjectDetail` verbindet Aufgaben und alle Einträge; historisch passende Einträge bestimmen die Aufgabenliste. | Aktuelle Inhaltsliste und zeitbezogene Analyse getrennt lesen; frühere Mitglieder dürfen die aktuelle Liste nicht füllen. |
| Bündeldetails | Eigene Analyseseite und Metadatenbearbeitung vorhanden. | Projektauswahl/-wechsel dort anschließen; vorhandene Analyseseite aus dem Projekt öffnen. |
| Bereinigung | `AufgabenRepository.ensureTaskInstancesUpToDate` bereinigt abgelaufene Papierkorbobjekte und wendet fällige Zuordnungen an. | Projektbereinigung und Bündelzuordnungen in den bestehenden Abgleich integrieren, keine zusätzlichen Timer. |
| Löschung | `TaskLifecycleService` besitzt Vorschau, Transaktionen, sieben Tage Frist und Revisionsprüfung. | Gemeinsame Projektaktion orchestriert vorhandene Aufgaben-/Bündeloperationen; keine zweite Pause-/Papierkorbsemantik. |

## Bereits geltende Grundlagen aus Phase 16

Diese bestätigten Regeln werden übernommen, nicht erneut zur Entscheidung
gestellt (siehe `history_editing_plan.md`, P16-10, P16-11 und P16-18):

- Projektidentität bleibt stabil; Name, Beschreibung und Farbe gelten auch in
  historischen Ansichten in ihrer aktuellen Fassung. Keine eigene
  Versionshistorie dieser Projektangaben für Release 1.
- Zuordnung ab heute oder einem zukünftigen Stichtag erhält die vorherige
  Zuordnung älterer Instanztage. Maßgeblich ist der geplante Instanztag.
- „Gesamte Historie verschieben“ ist eine ausdrückliche andere Aktion und
  verschiebt sämtliche bisherigen Zuordnungen samt aktueller Mitgliedschaft.
- Höchstens ein vorgemerkter Projektwechsel je Aufgabe; die vollständige
  Historienverschiebung entfernt eine bestehende Projektvormerkung.
- Dieselben Regeln gelten aus Aufgabenbearbeitung und Projektansicht.
  Die konkrete Bedienung in Phase 18 muss diesen Vertrag einhalten.

## Ziel von Phase 18

Projekte sollen für den ersten Release so weit ausgearbeitet sein, dass Nutzer
Aufgaben und Habits verständlich Projekten zuordnen, dort betrachten und
grundlegend auswerten können.

Die Phase soll nicht schon alle langfristigen Projektideen umsetzen. Sie legt
aber die Fachregeln so an, dass später Unteraufgaben, Unterprojekte,
Projektverläufe und tiefere Projektauswertungen sauber anschließen können.

## Aktueller Code-Stand

Im Code bereits vorhanden:

- Projekttabelle mit `id`, `name`, `description`, `colorHex` und `sortOrder`
- Aufgaben speichern `projectId`
- Aufgaben-Definitionsversionen enthalten die Projektzuordnung
- Projekte können erstellt, bearbeitet, sortiert und geöffnet werden
- Aufgaben können beim Erstellen und Bearbeiten einem Projekt zugeordnet werden
- Projekt-Detailansicht zeigt zugeordnete Aufgaben und Habits
- Projekt-Analyse-Tab zeigt erste einfache Summaries
- Löschdialog ist vorbereitet, führt die Löschvarianten aber noch nicht aus

## Release-Zielbild

Für den ersten Release soll gelten:

- Projekte sind optional; Aufgaben, Habits und Bündel dürfen ohne Projekt existieren.
- Eine Aufgabe, ein Habit oder ein Bündel gehört höchstens zu einem Projekt.
- Bündel können unabhängig von ihren Quellen zugeordnet werden (P18-08).
- Projektname, Beschreibung und Farbe sind in Listen und Details sichtbar.
- Projektzuordnung ist in Erstellung und Bearbeitung änderbar.
- Projekte können reversibel archiviert werden; Aufgaben und Habits laufen
  dabei unverändert weiter (P18-02).
- Projektansicht zeigt aktuell zugeordnete Inhalte nach Art gegliedert (P18-11).
- Projektauswertung nutzt dieselben Grundbegriffe wie die Aufgaben-Auswertung.
- Beide Projektlöschoptionen sind mit Papierkorb, Wiederherstellung und
  historischen Referenzen gemäß P18-03 bis P18-06/P18-09 umzusetzen.

## Technische Verträge für die Umsetzung

Die folgenden Festlegungen sind technische Ableitungen der bestätigten
Produktentscheidungen. Sie vermeiden zusätzliche Produktoptionen. Interne
Datei-/Methodennamen dürfen angepasst werden; Verhalten und Abnahme bleiben bindend.

### T18-01 – Datenmodell und Migration

Ausgangspunkt ist Schema 20. Phase 18 plant eine zusammenhängende Migration auf
21; hat ein anderer Chat das Schema inzwischen verändert, die nächste freie
Version verwenden und das dokumentieren.

| Tabelle | Geplante Änderung |
|---|---|
| `Projects` | Nullable `archivedAt`, `trashedAt`, `purgeAt`, `deletedAt`; `revision` mit Default 0 und `updatedAt` für tatsächliche Änderungen. Bestehende UUID/Metadaten/Sortierung bleiben. |
| `TaskValueBundles` | Nullable `projectId` als aktuell wirksame Zuordnung mit Projekt-Fremdschlüssel. Bestehende Bündel starten projektlos. |
| `TaskProjectAssignmentChanges` | Für Aufgaben **und** Bündel verwendbar machen: `taskId` nullable, `bundleId` nullable mit FK/Cascade, CHECK genau eine Objekt-ID; Herkunft `user`/`project_deletion` mit Legacy-Default `user`. Bisherige Ereignisse unverändert übernehmen. Keine zweite fachlich abweichende Zuordnungshistorie. |
| Neue `ProjectDeletionBatches` | UUID, `projectId`, Löschmodus, Löschzeitpunkt und zugehörige Projektrevision. Ein Vorgang je tatsächlicher Projektlöschung. |
| Neue `ProjectDeletionBatchItems` | Zusammengesetzter Schlüssel aus Vorgang, Objekttyp (`task`/`bundle`) und Objekt-ID; beim Löschen gespeicherte `lifecycleRevision` und `trashedAt`. Keine Kopien von Rohwerten oder Namen. |

Für Zuordnungen Indizes pro Objekt/Sequenz sowie für fällige Vormerkungen
vorsehen; je Objekt eindeutige Sequenz und höchstens eine pending-Vormerkung
absichern (partielle Indizes nach Typ). Vorhandene Datensätze und Sequenzen
erhalten. Die Zuordnungstabelle
muss für die nullable Aufgaben-ID kontrolliert neu aufgebaut werden. Der
bisherige SQL-Tabellenname kann erhalten bleiben, auch wenn Dart-Namen präzisiert
werden. Bündelversionen brauchen keine zusätzliche Projektspalte.

Projektzustände werden eindeutig gelesen: `deletedAt != null` ist endgültig
gelöscht; sonst Papierkorb bei `trashedAt != null`; sonst Archiv bei
`archivedAt != null`; sonst aktiv. `trashedAt`/`purgeAt` müssen gemeinsam gesetzt
sein. Archivzustand im Papierkorb behalten, sodass Restore zum vorherigen
Zustand zurückkehrt. Endgültige Löschung ist nicht wiederherstellbar.

**Minimaler Identitätsverweis:** Projektzeile bei endgültiger Löschung nicht
physisch entfernen. Stattdessen Name/Beschreibung/Farbe leeren, Sortierung
neutralisieren, Archiv-/Papierkorbfelder leeren und `deletedAt` setzen.
Die verbleibende Zeile ist nur ein technischer Löschverweis; keine Auswahl,
Projektkarte, Bearbeitung oder Projektanalyse dafür anbieten. Alle bestehenden
Projekt-FKs bleiben dadurch historisch intakt. Anzeige „Gelöschtes Projekt“
zentral ableiten, nicht als alten Projektnamen speichern. Für Projekte ist
dieser Verweis der Löschmarker; die bisherigen Marker für Aufgaben/Bündel
bleiben unverändert. Keine neue allgemeine Löschmarkerplattform bauen.

Migration: echte Schema-20-Testfixture vor Änderung erzeugen; nicht die neue
Datenbank nur mit `user_version = 20` versehen. Neue DB und Upgrade prüfen,
inklusive `foreign_key_check`. Ältere Upgradepfade berücksichtigen: vorhandene
Migrationen erzeugen teilweise Tabellen aus dem aktuellen Schema, daher
Spalten-/Tabellenexistenz kontrollieren, damit nichts doppelt angelegt wird.
Altdaten erhalten keine erfundenen Erstellungs-/Archivzeitpunkte; `updatedAt`
für den Migrationsstand darf gesetzt werden. Keine Seed-/Nutzerdaten ändern.

### T18-02 – Ein Zuordnungsdienst, zwei Inhaltstypen

`TaskProjectAssignmentService` gezielt zu einem gemeinsamen Projektzuordnungs-
dienst erweitern. Eine kleine typisierte Referenz (`task` oder `bundle`, ID)
genügt. Bestehende Aufgaben-Aufrufe können dünne kompatible Wrapper behalten.
Kein generisches Framework für zukünftige Module.

- Aufgaben behalten ihre bisherigen Definition-Snapshots als Ausgangsbasis.
  Bündel lesen ihre Zuordnung aus Ereignissen; ohne Ereignis sind sie projektlos.
- Bei Neuerstellung eines Bündels mit vorausgewähltem Projekt ein initiales
  Zuordnungsereignis ab `min(erster validFrom, heute)` speichern und die aktuelle
  `projectId` setzen. Ein künftig beginnendes Bündel ist damit bereits heute
  ein sichtbarer Projektinhalt; seine Messwertauswertung beginnt erst mit
  `validFrom`. Bei rückwirkend neu angelegten Bündeln deckt die initiale
  Zuordnung deren Beginn ab. Es betrifft nur das gerade neu angelegte Bündel.
  Spätere Änderungen unterliegen den bestehenden Regeln
  „ab heute/zukünftig“ oder „gesamte Historie“. Neue Aufgaben behalten ihre
  vorhandene Erstellungssemantik. Eine Änderung der Bündelversion ändert die
  Projektzuordnung nicht automatisch.
- Für Bündel ebenfalls höchstens eine Vormerkung, Ersetzen/Abbrechen und Undo
  des letzten zulässigen Zuordnungsereignisses unterstützen. Im Papierkorb
  keine benutzergesteuerte Zuordnungsänderung. Quellen nie mit verändern.
- Nur tatsächlich hinzugefügte/entfernte Inhalte schreiben. Umbenennen,
  Umfärben oder unverändertes Speichern darf keine Zuordnungen, Historien-
  ereignisse oder Vormerkungen ändern. Bestehende `_updateProjectAssignmentsWithVersions`
  schreibt derzeit alle betroffenen Aufgaben erneut: diesen Pfad ersetzen.
- Alle neuen Benutzerzuordnungen prüfen das Zielprojekt auf aktiv/nicht
  gelöscht. Eine unverändert bestehende Zuordnung zu einem Archivprojekt darf
  beim Bearbeiten anderer Felder erhalten bleiben. Schon vor Archivierung
  vorgemerkte Wechsel bleiben gültig.
- Historische Auflösung und heutige Mitgliedschaft unterscheiden. Vorschau
  zukünftiger Tage darf vorgemerkte Zuordnung zeigen, sie aber nicht vorzeitig
  in das aktuelle `projectId` schreiben. `applyDueChanges` höchstens bis zum
  tatsächlichen heutigen Tag anwenden, nicht bis zu einem UI-Auswahldatum.
- Wiederholte gleiche Aufträge ohne Zustandsänderung sind schreibfrei. Uhr als
  injizierbare Abhängigkeit nutzen; reale UTC-Zeitpunkte und lokale Kalendertage
  auseinanderhalten.

Projekt-Metadatenbearbeitung und Zuordnen/Entfernen als getrennte Befehle
behandeln. Der Metadateneditor speichert ausschließlich Name/Beschreibung/Farbe;
kein vollständiges Mitgliedschaftsset mitsenden. Die vorhandenen Checkboxen
können im separaten Zuordnungsdialog wiederverwendet werden; vor Speichern
werden nur echte Differenzen mit Umfang/Stichtag erklärt. Gemeinsame Auswahl
mehrerer Inhalte darf denselben expliziten Stichtag verwenden. Historien-
verschiebung bleibt eine ausdrücklich benannte Aktion. Bereits anderswo
zugeordnete Inhalte dürfen ausgewählt werden; bisheriges Projekt anzeigen und
Wechsel transparent machen. Keine implizite Überschreibung durch einen alten
Editorzustand: vor dem Schreiben die betroffenen Zuordnungen erneut prüfen.

### T18-03 – Projekt-Lebenszyklus und Sonderfälle

Ein kleiner `ProjectLifecycleService` im Projektfeature orchestriert die
bestehenden `TaskLifecycleService`-Operationen und den Zuordnungsdienst.
Vorschau/Bestätigung sind getrennt. Ein gemeinsamer injizierter Zeitpunkt sorgt
für dieselbe Sieben-Tage-Frist bei allen in einem Vorgang gelöschten Objekten.
Keine neue Transaktionsebene mit unabhängigen Commits innerhalb der Sammelaktion.

| Fall | Verbindliche Ableitung |
|---|---|
| Löschvorschau | Projekt, tatsächliche aktuelle Inhalte, bereits separat im Papierkorb liegende Inhalte und Auswirkungen auf weitere Bündel unterscheiden. Anzahl/Namen, Varianten und konkretes Fristende anzeigen. Vorschau ist lesend. |
| Veralteter Dialog | Projektzustand, Zuordnungsstand, Objekt-Lebenszyklusrevisionen und betroffene Quellenabhängigkeiten vor Ausführung erneut vergleichen. Bei Änderung neue Vorschau, keine Teilaktion. |
| „Nur Projekt löschen“ | Erhaltene aktuelle Inhalte ab dem heutigen lokalen Tag abzuordnen; historische Tage davor behalten ihre Projekt-ID. Einträge, Planung und Ziele unverändert. Gleiche Tagesgrenze wie Phase 16, kein neuer untertägiger Zuordnungsmodus. |
| Ausgehender vorgemerkter Wechsel | Wechsel von diesem Projekt zu einem anderen weiterhin existierenden Projekt erhalten. Die Abzuordnung wegen Projektlöschung darf ihn nicht beiläufig abbrechen. |
| Eingehender vorgemerkter Wechsel | Vormerkung zum gelöschten Projekt abbrechen; aktuelle andere Zuordnung bleibt bestehen. Projekt-Restore aktiviert abgebrochene Vormerkungen nicht erneut. In der Löschvorschau nennen. |
| Gemeinsames Löschen | Nur heute tatsächlich zugeordnete, noch nicht im Papierkorb liegende Aufgaben/Habits/Bündel aufnehmen; pausierte oder bereits abgeschlossene Inhalte zählen als Mitglieder. Projekt und Inhalte atomar in den Papierkorb verschieben. Zugehörigkeit der mitgelöschten Inhalte für Restore erhalten. |
| Bereits separat gelöschtes Objekt | Nicht in den neuen Vorgang aufnehmen, Frist nicht neu starten. Seine aktuelle Zugehörigkeit zum gerade gelöschten Projekt bereits jetzt per datiertem Systemereignis beenden; sonst könnte ein späteres Projekt-Restore die alte Zuordnung unbeabsichtigt wieder aktivieren. Frühere historische Bezüge erhalten. Diese eng begrenzte Referenzbereinigung verändert keine Rohdaten, Planung, Lebenszyklusrevision oder Frist und ist keine freigegebene normale Bearbeitung im Papierkorb. |
| Projekt allein zurückholen | Archivzustand vor Löschung wiederherstellen. Nach reiner Projektlöschung keine aktuellen Zuordnungen zurücksetzen. Nach Sammellöschung bleiben nicht mit restaurierte Inhalte im Papierkorb. |
| Gemeinsam zurückholen | Nach bestätigter Restore-Vorschau Projekt zuerst, dann passende Aufgaben, danach Bündel in derselben Transaktion restaurieren. Nur identischer Löschvorgang/Revision, Objekt vorhanden, noch im Papierkorb und Frist offen. Bereits anderweitig behandelte Objekte gemäß Vorschau auslassen. Bestehende Restore-Regeln/pausierter Zustand bleiben. |
| Einzelnes Mitglied vor Projekt zurückholen | Inhalt bleibt nutzbar, aktuelles gelöschtes Projekt wird projektlos behandelt und per systemseitiger datierter Abzuordnung bereinigt. Ein späteres Projekt-Restore darf diese Entscheidung nicht zurückdrehen. Historie erhalten. |
| Fällige Vormerkung nach Restore | Nach Wiederherstellung nur noch gültige, fällige Wechsel anwenden. Ein seit Löschung fällig gewordener Wechsel zu einem anderen Projekt hat Vorrang vor einer pauschalen Rückzuordnung. |
| Undo mit gelöschtem Projekt | Darf weder technische Löschmarker als aktive Projekte verwenden noch die systemseitige Abzuordnung rückgängig machen. Historische Referenzen bleiben lesbar; kein Wiederbeleben durch Undo. |
| Frist und endgültige Löschung | Wie Phase 17: sieben mal 24 Stunden ab UTC-Löschzeitpunkt; bei `now >= purgeAt` kein Restore. Abgelaufene Objekte bei Start/Resume/Tageswechsel bzw. nächstem Öffnen bereinigen. Manuell endgültig löschen nur mit bestehender Bestätigungslogik. |
| Projekt endgültig löschen | Nur Projekt zum Identitätsverweis reduzieren. Noch bestehende aktuelle Zuordnungen zum Projekt, auch bei nicht restaurierten Sammelmitgliedern, datiert beenden; gültige ausgehende Vormerkungen erhalten. Bereits eigenständig restaurierte Inhalte nicht löschen; übrige Papierkorbobjekte behalten ihre eigene Frist. Vorgangsmetadaten nach Projekt-Restore oder endgültiger Projektlöschung entfernen. |
| Archivierung | Kein Scheduler-/Quellen-/Ziel-Eingriff. Wiederholte Archivierung ohne Änderung schreibt nichts; neue Zuordnungen erst nach Zurückholen. |

Für systemseitige Abzuordnung einen eigenen, eng begrenzten Dienstbefehl
verwenden: historische Zuordnung ab heute beenden, gültige ausgehende Vormerkung
erhalten, Operation nicht als normales Nutzer-Undo anbieten. Erforderliche
Ereignisherkunft (`user`/`project_deletion`) an Zuordnungsereignissen speichern.
Da die bisherige Auflösung Ereignisse nach Sequenz verarbeitet, eine ausgehende
Vormerkung bei Bedarf nach der neuen Abzuordnung mit unverändertem Ziel/Stichtag
neu vormerken und das alte pending-Ereignis abbrechen. Sonst würde die spätere
Abzuordnungssequenz auch zukünftige Tage überdecken. Dieser Ablauf ist atomar
und erhält die Nutzerabsicht; neue Vormerkung hat die nun projektlose Basis.
Bei schon zuvor im Papierkorb liegenden Inhalten die Bereinigung bereits in
der Projektlöschtransaktion speichern, mit deren lokalem Stichtag. Nicht bis
zum Objekt-Restore warten: Das Projekt könnte bis dahin wiederhergestellt sein.
Nur die in **diesem** Vorgang frisch mitgelöschten Mitglieder behalten ihre
aktuelle Zuordnung für die mögliche gemeinsame Wiederherstellung. Aktuelle
Leser dürfen währenddessen keine gelöschten Projekte als aktive Mitgliedschaft
behandeln. Eingehende Vormerkungen auch für Papierkorbobjekte eindeutig
abbrechen, ohne Frist/Rohdaten zu verändern.

Gemeinsames Restore ist ebenfalls vorab zu berechnen und zu bestätigen:
Anzahl der noch passenden Mitglieder und Gründe für ausgelassene Inhalte
anzeigen. Ändert sich dieser Umfang zwischen Anzeige und Ausführung, neue
Vorschau verlangen; nicht erst nach einem unerwarteten Teil-Restore erklären.
Fachlich unverfügbare Mitglieder dürfen nach erklärter Vorschau ausgelassen
werden; ein technischer Fehler innerhalb des bestätigten Vorgangs rollt
dagegen die gesamte Transaktion zurück.

Nach normalem Undo heutige Zuordnung aus der verbleibenden Ereigniskette neu
ermitteln; nicht blind `previousProjectId` übernehmen. Insbesondere darf Undo
eines späteren Nutzerwechsels keine Projektlöschungs-Abzuordnung umgehen.
Ist das letzte wirksame Ereignis eine System-Abzuordnung, dafür kein Nutzer-Undo
anbieten; keinen älteren Nutzerwechsel stellvertretend rückgängig machen.

Restore setzt außerdem eine heute gültige Definition voraus: vorhandene
Aufgaben-Restore-Nachbearbeitung (Definitionsvormerkungen, Zuordnungen und
Scheduler) weiterverwenden; Bündel-Restore um den gemeinsamen Zuordnungsabgleich
ergänzen. Ein reiner Aufruf von `TaskLifecycleService.restoreTask` ohne diese
Nachbearbeitung reicht nicht. Alles auf derselben Datenbank ausführen.

Abhängigkeiten konkret halten: `AufgabenRepository` kennt den gemeinsamen
Zuordnungsdienst, aber kein `ProjectRepository` und keinen Projekt-Lebenszyklus-
dienst. Projektleser/-Lifecycle dürfen die benötigten Aufgaben-Leser und
Restore-Befehle injiziert bekommen. So entsteht kein gegenseitiger Repository-
Aufruf. Projektbereinigung vor dem vorhandenen Aufgabenabgleich in den Start-/
Resume-/Tageswechsel-Runner in `main.dart` aufnehmen; auch beim Öffnen des
gemeinsamen Papierkorbs fällige Bereinigung durchführen. Reine Löschvorschauen
selbst bleiben lesend. Den aktuellen Tag für Vormerkungen vor Ermittlung eines
Löschumfangs abgleichen, damit eine heute fällige Zuordnung berücksichtigt wird.

### T18-04 – Lesen, Zählen und Reaktivität

**Übersicht:** heute wirksame Mitgliedschaft, ohne Papierkorb/gelöschte Inhalte,
unabhängig davon, ob bereits Einträge existieren. Pro Objekt genau ein Eintrag.
Aufgaben/Habits nach vorhandenem `taskType` gliedern, Bündel eigener Abschnitt.
Einmalige Aufgaben nur anhand ihrer tatsächlichen Instanz als abgeschlossen
kennzeichnen. Laufendes Habit ohne offene Instanz ist nicht dauerhaft fertig.
Pausen bzw. aufgelöste Bündel explizit kennzeichnen; diese bleiben als aktuelle
Mitglieder mit Zugang zu vorhandener Historie sichtbar, bis sie entfernt werden.
Stabile Sortierung nach Name innerhalb der Gruppen genügt; Projektkarten behalten
ihre vorhandene manuelle Sortierung.

Die Inhaltsliste **nicht** aus der vorhandenen Tagesliste ableiten: Diese hängt
von Fälligkeit, Bündeldarstellung und gültiger Tagesversion ab. Stattdessen
Objekte über ID und aktuelle Zuordnung laden. Das gilt auch für ein Bündel,
das erst künftig beginnt, bereits aufgelöst ist oder eine nicht verfügbare
Quelle hat. Es bleibt als Projektinhalt mit passendem Zustand sichtbar.

**Analyse:** bis einschließlich heute; Datum immer normalisiert als lokaler
Kalendertag, Grenzen exklusiv am nächsten lokalen Tagesbeginn bilden. Letzte
N Tage umfassen heute und N-1 vorangegangene Kalendertage. „Seit Beginn“ umfasst
alle erhaltenen Beiträge dieser Projekt-ID einschließlich ausdrücklich
verschobener Historie; nicht auf heute noch zugeordnete Mitglieder begrenzen.

- Aufgabenstatus aus vorhandenen `TaskEntry`-Datensätzen, gefiltert nach
  `scheduledDate` und historisch aufgelöster Projekt-ID. Nicht nach Erfassungs-
  zeitpunkt filtern; verspätete Eingabe bleibt beim geplanten Tag/Projekt.
  Vor der Anzeige den vorhandenen heutigen Planungsabgleich verwenden.
- Reines Tracking erzeugt bei Nicht-Erfassung keine künstlichen `pending`-
  oder `no_entry`-Einträge für die Projektstatistik. Bestehende echte Einträge,
  einschließlich freiwilliger Pauseneingaben, bleiben auswertbar. Keine
  Wiedererzeugung von durch Pause/Papierkorb ausgesparten Pflichttagen.
- Aufgabe im Papierkorb aus regulärer Projektanalyse ausschließen; nach Restore
  erhaltene Historie erneut einschließen. Pausierte Aufgaben behalten ihre
  Historie. Eine archivierte Projektansicht berechnet weiterhin aktuelle Werte.
- Bündelstatus pro Bündel und Auswertungstag genau einmal. Gültige nicht
  stornierte Bündelversion für den Tag auswählen; Versionsgrenzen beachten,
  keine Addition derselben Tage aus mehreren Versionen.
- Vorhandene Range-Auswertung `getTaskValueBundleAnalyticsSummaryForPeriodRange`
  bzw. deren Punkte nutzen und um historische Projektfilterung ergänzen.
  Nicht einfach die vollständige Summary eines aktuell zugeordneten Bündels
  addieren: sie kann Beiträge aus anderen Projekten/Versionen enthalten.
- Quellwerte über beide jeweiligen Tagesversätze laden; Quell-Projektzuordnung
  schränkt eine gültige Bündelberechnung nicht ein. Benötigte Datumsbereiche
  aus **beiden** Quellen bestimmen. Vorhandener Helfer lädt bisher ab dem
  ersten Offset bis zum unveränderten Periodenende: für diesen Pfad korrigieren,
  falls dadurch benötigte Randwerte fehlen.
- Historische Quelldefinitionen/Rhythmen über den vorhandenen Resolver lesen.
  Die bisherige Bündelberechnung arbeitet stellenweise mit aktuellen Aufgaben;
  für die Projektanalyse keine historischen Ergebnisse dadurch umdeuten.
  Bestehende Berechnung gezielt gemeinsam nutzbar machen, nicht kopieren.
- Bei Pausen fehlende Werte nicht als zusätzliche Pflichten erzeugen. Echte
  vorhandene Werte können weiter berücksichtigt werden; Tagesrelevanz folgt
  den bestehenden Bündel-/Quellregeln. Quelle im Papierkorb/endgültig gelöscht:
  vorhandenen Nichtverfügbarkeitsgrund anzeigen, keine Nullwerte erfinden und
  keine Daten aus dem Papierkorb indirekt in reguläre Analysen einbeziehen.
- Vollständig/teilweise/fehlend/nicht berechenbar sind disjunkte Tagesstatus.
  Ein nicht verfügbarer Quellenbestand liefert den erklärenden Hinweis statt
  erfundener Tagesanzahlen. Keine Erfolgsbewertung aus „vollständig“ ableiten.
- Keine Projektsumme über verschiedene Messgrößen. Bündel- und Einzelwertdetails
  bleiben bestehende Auswertungen. Dort bedeutet der Zeitraum die jeweilige
  Objekt-Historie, nicht stillschweigend nur den Projektanteil.

In der Analyse unter den Summen eine einfache Liste „Inhalte im Zeitraum“
anbieten, aus den tatsächlich beitragenden Aufgaben/Bündeln. Dadurch bleiben
auch frühere Mitglieder über ihre Details erreichbar, obwohl sie nicht mehr
in der aktuellen Übersicht stehen. Nicht verfügbare Bündelauswertungen mit
Grund separat in dieser Liste nennen; kein verdecktes Weglassen oder eine
scheinbar vollständige Gesamtsumme. Bei solchen Auslassungen einen knappen
Hinweis „Nicht alle Bündel auswertbar“ am Bündelbereich zeigen. Kein Diagramm
oder neuer Filter notwendig.

Projektanalyse erhält ein eigenes kleines Read-Modell (`ProjectAnalyticsSummary`)
für beide Statusbereiche; keine neuen gespeicherten Ergebnis-/Summen-Tabellen.
Projektübersicht (`ProjectOverview`) davon trennen. Quelleinträge und Zuordnungs-
ereignisse pro Abfrage gebündelt laden, statt für jeden Eintrag zusätzliche
Abfragen auszuführen. Für den ersten Release genügen einfache In-Memory-Maps;
kein Cache-/Indexierungsdienst und keine Benchmarkkampagne.

Reaktive Leser müssen Änderungen an Projekten, Aufgaben, Entries/Werten,
Definitionen, Zuordnungen, Bündeln/Bündelversionen, Unterbrechungen und relevanten
Löschmarkern beobachten. Korrektur einer Quelle aktualisiert alle betroffenen
Bündelergebnisse. Tageswechsel aktualisiert Zeitraum und Mitgliedschaft.
Heute fällige Änderungen vor der Abfrage abgleichen, nicht bei jedem Stream-
Ereignis erneut schreiben. Anzeige ohne echten Zustandswechsel bleibt schreibfrei.

### T18-05 – Oberfläche und Navigation

- Bestehende Projektliste und die Tabs Übersicht/Analyse beibehalten.
  Projektmetadaten zeigen; aktuelle Inhalte öffnen ihre vorhandenen Details.
  Alte Fortschrittsbalken/Completion-Prozente und Offen/Alle/Abgeschlossen-
  Filter entfernen, soweit sie dem bestätigten Startumfang widersprechen.
- „Inhalt hinzufügen“ in aktiven Projekten: vorhandene Inhalte zuordnen oder
  Aufgabe/Habit erstellen. `AufgabeHinzufuegenScreen` um optionales
  `initialProjectId` ergänzen; normale Erstellung weiterhin projektlos.
  Neue Bündel nur über bestehenden Quellen-Flow mit Projektauswahl erzeugen.
- Ein gemeinsamer Zuordnungsdialog für beide Inhaltstypen: aktuelles Projekt,
  ggf. Vormerkung und Stichtag anzeigen; „Gesamte Historie verschieben“ separat
  benennen. Aus Objekt- und Projektansicht dieselben Dienste verwenden.
- Eindeutige Aktionen: „Aus Projekt entfernen“ ändert die Zuordnung auf
  „Ohne Projekt“ über denselben Stichtagdialog; „Löschen“ öffnet den Papierkorb-
  vorgang. Das sind niemals zwei Beschriftungen desselben Befehls.
  Standard im Zuordnungsdialog ist „Ab heute“; zukünftiges Datum und gesamte
  Historie stehen als explizite Alternativen bereit. Bei vorgemerkter Zuordnung
  nach Speichern „Gilt ab …“ anzeigen und Ersetzen/Abbrechen im selben Dialog
  erreichbar halten. Eine für später hinzugefügte Aufgabe ist noch kein
  aktueller Projektinhalt; bei einer sonst leeren Übersicht einen Hinweis auf
  vorgemerkte Zugänge mit Zugang zur Zuordnungsverwaltung zeigen.
- Archivzugang in Projektliste, Archivieren/Zurückholen im Projektmenü.
  Archivansicht bleibt lesbar; kein Hinzufügen zu archivierten Projekten.
  Name/Farbe/Beschreibung dort weiterhin bearbeitbar. Löschung aktiver und
  archivierter Projekte verwendet dieselbe Vorschau.
- Projektauswahl benötigt **aktive Ziele plus die unveränderte aktuelle
  Auswahl**. Ein schon zugeordnetes Archivprojekt genau einmal mit Zusatz
  „archiviert“ anzeigen und als neues Ziel sperren; ein normales Speichern
  anderer Felder darf es nicht entfernen. `ProjectDropdownField` setzt aktuell
  voraus, dass sein `value` in den Items vorkommt. Nur `watchProjects` auf
  aktive Projekte zu filtern würde hier einen ungültigen Dropdownwert erzeugen.
  Gelöschte Ziele zentral auflösen/bereinigen; kein stilles Leeren beim Build.
- Bestehenden „Planung & Papierkorb“-Screen um Projekte ergänzen und auch aus
  dem Projektbereich erreichbar machen. Keine konkurrierenden Papierkörbe.
  „Papierkorb leeren“ umfasst ausdrücklich alle angezeigten Objektarten mit
  Gesamtvorschau; untergeordnete endgültige Löschungen bleiben eigenständig.
  Gemeinsame Wiederherstellung nur anbieten, wenn passende Vorgangsmitglieder
  noch wiederherstellbar sind; ansonsten nur Projekt plus Erklärung.
- Leere Zustände: keine Inhalte, keine Einträge im Zeitraum, leeres Archiv,
  leerer Papierkorb. Null Anzahlen sind erlaubt, fehlende Messwerte erscheinen
  als nicht verfügbar. Keine Paywall-/Projektanzahlgrenze in Phase 18.
- Während Schreiboperationen Speichern sperren; Fehler anzeigen, Dialog nicht
  fälschlich als erfolgreich schließen. Wurde ein Projekt seit Öffnen gelöscht,
  keine Bearbeitung zulassen, zurück zur Liste mit verständlicher Meldung.

**Detailzugang über Identität:** `TaskValueBundleDetailScreen` verlangt bisher
ein `TaskValueBundleForDate` mit konkreten Quellen. Für Projektzugänge einen
ID-basierten Einstieg ergänzen (bestehende Aufrufe adaptieren): reales Bündel,
Metadaten/Zustand und verfügbare Versionen laden, ohne heutigen Quell-Eintrag
vorauszusetzen. Für ein künftig beginnendes Bündel die nächste Version mit
„Beginnt am …“, für ein aufgelöstes die letzte gültige Version mit „Aufgelöst“
zeigen; Details bleiben erreichbar. Fehlt eine Quelle, keine Fake-Aufgabe oder
Nullmessung erzeugen. Historische Versionen über die vorhandenen Grenzen
auswerten; fehlende Werte mit Grund erklären. Bei mehr als einer Version eine
kleine Versionsauswahl für bestehende versionsgebundene Details anbieten,
anstatt eine beliebige heutige Version als gesamte Historie auszugeben.

Task-/Bündel-Details müssen Metadaten, Projektzuordnung und Lebenszyklus anhand
der ID neu laden/aktualisieren. Die bisherigen beim Navigieren übergebenen
Objektsnapshots allein reichen nach Umbenennen, Zuordnen oder Löschen nicht.
Beim Öffnen aus der Projektanalyse einen knappen Hinweis auf die vollständige
Objektauswertung außerhalb des Projektfilters zeigen; Zeitraum übernehmen,
soweit die bestehende Ansicht ihn unterstützt. Rücknavigation behält den
Projekt-Tab und dessen Zeitraum. Keine weitere Analyseseite duplizieren.

**Projektverweise überall gleich behandeln:** aktive und archivierte Projekte
können normale Labels tragen (Archiv mit Zusatz); Papierkorbprojekt mit
Löschhinweis nur im historischen Kontext; endgültiger Verweis als „Gelöschtes
Projekt“, ohne aktive Navigation/Farbe. Ein gemeinsamer kleiner Display-/Lookup-
Helfer genügt. Aufgaben-Tagesgruppen, Karten, Details und Dropdowns berücksichtigen;
die direkten Projekt-Joins im Aufgabenrepository sonst nicht ungeprüft als
aktive Mitgliedschaft verwenden. Die bestehende getrennte Bündeldarstellung
in der Tagesansicht darf bleiben; ihr Projektlabel muss jedoch der eigenen
Bündelzuordnung folgen, nicht der Zuordnung einer Quelle.

**Bedienabnahme auf schmalem Display:** Listen scrollbar, Aktionsdialoge ohne
abgeschnittene Schaltflächen, lange Projekt-/Bündelnamen mehrzeilig oder
ellipsiert mit Detailzugang. Status zusätzlich als Text, nicht nur als Farbe.
Keine zweite unbeschriftete Gesamtsumme aus unterschiedlichen Statusbereichen.

## Umsetzungspakete und Reihenfolge

Die folgende Reihenfolge wurde umgesetzt. Tests wurden paketweise ergänzt;
der gemeinsame Abschlusslauf folgte nach dem Bedienpaket.

| Paket | Voraussetzung | Arbeit und betroffene Dateien | Fertig, wenn |
|---|---|---|---|
| 18a – Schema und gemeinsame Zuordnung | keine | `projects_table.dart`, `task_value_bundles_table.dart`, `task_project_assignment_changes_table.dart`, neue Vorgangstabellen, `app_database.dart`; Zuordnungsdienst erweitern. T18-01/02. | **Abgeschlossen:** Schema 21, Migration und unabhängige Zuordnungen geprüft. |
| 18b – Archiv/Papierkorb/Restore | 18a | Neuer Projekt-Lebenszyklusdienst, `task_lifecycle_service.dart` nur an notwendigen Integrationsstellen, Restore-Wrapper in `aufgaben_repository.dart`, Projektrepository und `main.dart`-Abgleich. T18-03. | **Abgeschlossen:** beide Löschmodi, Restore, Frist und Identitätsverweis umgesetzt. |
| 18c – Übersicht und Auswertung | 18a/18b | `project_repository.dart` entlasten, eigene Projekt-Read-Modelle; vorhandene Aufgaben-/Bündel-Range-Leser/Resolver gezielt zugänglich machen; ID-basierter Bündel-Detail-Leser und gemeinsamer Projekt-Display-Lookup. T18-04/05. | **Abgeschlossen:** aktuelle Inhalte und historische Statusanalyse getrennt. |
| 18d – Bedienung | 18a–18c | `projects_screen.dart`, `project_detail_screen.dart`, Create/Edit, `task_assignment_section.dart`, `project_dropdown_field.dart`, Aufgaben- und Bündelerstellung/-details, `task_lifecycle_screen.dart`, Repository-Weitergabe in Navigation. T18-05. | **Abgeschlossen:** Zuordnung, Archiv und gemeinsamer Papierkorb nutzbar. |
| 18e – Abnahme und Übergabe | 18d | Gezielte Regressionen, gemeinsamer Abschlusslauf, Dokumentation. | **Abgeschlossen:** Analyse und automatisierte Abschlussläufe grün; Übergabe an Phase 19 dokumentiert. |

Aufgabenmodul behält Verantwortung für Scheduler, Entry-Status, Ziele und
Bündelberechnung. Projektmodul verantwortet Zuordnung, Projekt-Lebenszyklus und
Zusammenstellung der Ansicht. Keine Projektregeln in Widgets verteilen, keine
zweite Datenbankverbindung und keine zyklischen Repository-Abhängigkeiten.
Kleine benötigte lesende Methoden bzw. Daten-Services bereitstellen; vorhandenes
großes Aufgabenrepository nicht im Rahmen dieser Phase vollständig umbauen.

## Gezielte Abnahme

Bestehende Tests unter `test/features/projekte/data/` erweitern. Zusätzliche
Tests für Migration, Zuordnung und Lebenszyklus sind wegen Daten-/Historienrisiko
erforderlich; keinen Test pro trivialem Getter oder Text hinzufügen.

| Prüfung | Wesentliche Fälle |
|---|---|
| Migration | Echtes Schema 20 → neue Version; neue DB; ältere vorhandene Upgrade-Regression; Tasks/Entries/Versions/Vormerkungen unverändert; Bündel initial projektlos; FK-Prüfung. |
| Zuordnung | Aufgabe und Bündel unabhängig; ab heute/zukünftig; gesamte Historie; Ersetzen/Abbrechen/Undo; Quellen bleiben; Zukunftsvorschau mutiert heutige Zuordnung nicht; Metadaten-/No-op-Speichern erhält Vormerkungen. |
| Archiv | Sichtbarkeit/Restore, weiterhin laufende Tagesplanung/Bündel; unabhängig pausierte Aufgabe bleibt pausiert; vorhandene archivierte Zuordnung bleibt bei Metadatenbearbeitung erhalten. |
| Projekt allein löschen | Aktuell projektlos ab heute, historische Tage und Rohdaten bleiben; ausgehende Vormerkung erhalten, eingehende aufgehoben; Projekt-Restore ordnet nichts neu zu. |
| Sammellöschung | Direkte aktuelle Mitglieder einschließlich Bündel, keine früheren/fremden Mitglieder oder impliziten Quellen; bereits separat gelöschte Inhalte und Fristen unverändert; Fehler mittendrin rollt alles zurück. |
| Wiederherstellung | Nur Projekt/gemeinsam; alte Archiv-/Pausenzustände; identischer Löschvorgang; separat restauriert, verschoben, erneut gelöscht, endgültig entfernt; abgelaufene Frist; keine Rückstände nachplanen. |
| Endgültige Löschung | Projekt wird unbenannter technischer Verweis, historische Auflösung bleibt; kein alter Name/Farbe/Beschreibung; kein Restore/Undo zum gelöschten Projekt; wiederholte Bereinigung schreibfrei. |
| Historische Analyse | Projektwechsel mitten im Zeitraum; historische Mitglieder heute anders zugeordnet; verspätete Antwort bleibt bei Instanztag; ganze Historie verschieben; Papierkorb entfernt Beiträge/Restore bringt sie zurück. |
| Bündel | Eigene Projektzuordnung bei fremden/projektlosen Quellen; mehrere Bündel pro Quelle; gültige Versionen/Quelloffsets an Zeitraumgrenzen; fehlende/teilweise/nicht berechenbare Ergebnisse; Quellkorrektur aktualisiert Anzeige; gelöschte Quelle erklärt. |
| Zählen/Datum | Jede Entry-ID bzw. Bündel-ID+Tag einmal; keine gemeinsame Erledigungszahl; keine künstlichen Tracking-Pflichten; freiwillige Pausenwerte; 7/20/30 Tage inklusive heute über Sommerzeitgrenze. |
| Bedienung | Typisierte Inhaltsauswahl, Öffnen der jeweiligen Details, Erstellung mit vorausgewähltem Projekt, Archive/Trash, Abbruch/Fehler/alter Dialog, keine Prozentanzeige oder dauerhafter Habit-Abschluss aus temporärem Status. |
| Archiv-Auswahl | Aufgabe behält ihr archiviertes Projekt beim Umbenennen, Dropdown hat genau einen gültigen aktuellen Wert; neue Zuordnung zu einem Archivprojekt bleibt gesperrt. |
| Separater Papierkorbfall | Aufgabe separat löschen → ihr Projekt löschen → Projekt zurückholen → Aufgabe zurückholen. Aufgabe bleibt aufgrund des gespeicherten Systemereignisses aktuell projektlos; historische Zuordnung vor Projektlöschung erhalten. |
| Bündel-Navigation | Bündel startet morgen, ist heute keiner Quelle fällig, aufgelöst oder Quelle fehlt: aktuelle Projektmitgliedschaft und Detailzugang funktionieren trotzdem. Kein künstliches Tagesobjekt/Quellwert nötig. |
| Historische Bedienung | Ausgewanderter Projektinhalt über „Inhalte im Zeitraum“ erreichbar; Detail erklärt Gesamtobjekt-Sicht; Zurück erhält Projektzeitraum/Tab. |
| Restore-Vorschau | Ein Mitglied vor Bestätigung separat restauriert oder Frist abgelaufen: neue Vorschau statt überraschender Teilausführung. Echter Fehler rollt auch das Projekt-Restore zurück. |
| Kleine Displays | Scrollbare lange Listen/Bestätigungen, erreichbare Schaltflächen bei großer Schrift, verständliche Textstatus und lange Namen; keine ungültigen Dropdownwerte. |

Bestehender `project_repository_test.dart` erwartet nach `deleteProject` eine
leere Projekttabelle; diese Erwartung gezielt auf Papierkorb/Identitätsverweis
umstellen, nicht die neue Funktion nach dem alten Test verbiegen. Neue nullable
Bündelfelder in direkten `TaskValueBundle`-Konstruktoren/Testfixtures ergänzen.

Nach Schemaänderung einmal Drift generieren:
`dart run build_runner build --delete-conflicting-outputs`.
Betroffene Dart-Dateien mit `dart format` formatieren. Paketweise gezielt testen;
zum Abschluss ein gemeinsamer Lauf:
`flutter test test/features/aufgaben test/features/projekte test/widget_test.dart`
und `flutter analyze`. Fehler gegenüber Ausgangsstand unterscheiden. Manuell
ein Projekt mit Aufgabe, Habit und Schlafdauer-Bündel durch Erstellen, Wechsel,
Archiv, beide Löschwege und Restore führen. Ein Fehlerlauf rechtfertigt gezielte
Wiederholung; keine vorsorglichen Performance-/Golden-Testkampagnen.

## Nicht Teil von Phase 18

- Unterprojekte
- Projekte innerhalb von Projekten
- Unteraufgaben oder Checklisten
- Projekt-Vorlagen
- Projektrollen, Freigaben oder Zusammenarbeit
- tiefe Trend- und Vergleichsanalysen
- Verbindung zu Workouts, Diagnostik oder Coaching

Erweiterbarkeit: Stabile Projekt-, Aufgaben- und Bündel-IDs erhalten; aktuelle
Mitgliedschaft, historische Zuordnung und Messwerte getrennt halten. Spätere
Hierarchie oder weitere Inhaltstypen können daran anknüpfen, ohne Rohwerte neu
zu erzeugen. Jetzt keine leeren Unterprojekt-/Rollen-/Sync-Strukturen anlegen.
Phase 19 übernimmt Projekt-Löschverweise, neue Ereignisse und Revisionsfelder
als Sync-Grundlage; keine Firebase-Abhängigkeit oder Outbox in Phase 18.

## Erfolgsbedingung

### Abschluss dieser Planung und Übergabe

Die Planung ist fachlich und technisch ausgearbeitet. P18-01 bis P18-11 sind
im Dialog bestätigt; T18-01 bis T18-05 konkretisieren ihre Umsetzung.
Es gibt zum Abschluss keine bekannte offene Produktentscheidung für den
festgelegten Startumfang. Eine Codeausführung oder Implementierungsabnahme ist
damit nicht behauptet.

- [x] Bündelzuordnung einschließlich Historie und Lebenszyklus fertig festlegen.
- [x] Projektübersicht und einfache Analyse einschließlich Bündelstatus,
  reiner Trackings, Pausen und historischer Mitgliedschaft eindeutig definieren.
- [x] Verbleibende Bedienentscheidungen als kompakte Sammelliste abschließen:
  Zuordnung/Erstellung aus dem Projekt, Archivzugriff/-auswahl und Listenfilter.
- [x] Sonderfälle aus bestehenden Regeln ableiten und dokumentieren:
  vorgemerkte Zuordnungen, Papierkorbobjekte, Quellenabhängigkeiten und Restore.
- [x] Datenmodell und Migration mit dem tatsächlichen Schema abgleichen;
  historische Referenzen, Löschvorgänge und Archivzustand konkret planen.
- [x] Umsetzung in abhängige Arbeitspakete mit betroffenen Dateien,
  wiederverwendeten Schnittstellen und eindeutigen Ergebnissen zerlegen.
- [x] Gezielte automatisierte Abnahmefälle und wenige manuelle Bedienchecks
  den Paketen zuordnen; erforderliche Abschlussbefehle festhalten.
- [x] Relevante Dokumentation/Codepfade abschließend abgleichen, überholte
  Vorschläge entfernen und eine kurze Startanweisung für den Umsetzungs-Chat
  formulieren. Bestätigte Regeln dürfen dort nicht mehr als offene Fragen stehen.

Technische Ausarbeitung möglichst selbstständig aus vorhandenen Regeln ableiten;
nur echte verbleibende Produktentscheidungen zurückfragen. Aufwendige zusätzliche
Untersuchungen vorab abstimmen. Keine Implementierung in diesem Chat.

### Startanweisung für den Umsetzungs-Chat

> Setze Phase 18 nach `docs/10_tasks_habits/phase_18_projects/projects_plan.md`
> um. Lies zuerst AGENTS.md/CONTEXT.md, die bestätigten Regeln P18-01 bis P18-11,
> die technischen Verträge T18-01 bis T18-05 und die Arbeitspakete 18a bis 18e.
> Prüfe Arbeitsbaum und aktuellen Schema-Stand; erhalte fremde Änderungen.
> Beginne mit der echten Schema-20-Fixture, danach arbeite die Pakete in
> Reihenfolge ab. Nutze vorhandene Zuordnungs-, Lebenszyklus- und Bündellogik.
> Erfinde keine zusätzlichen Features. Bereits bestätigte Produktentscheidungen
> nicht erneut abfragen. Bei einem tatsächlichen Widerspruch zum inzwischen
> geänderten Code konkret berichten und nur die betroffene Frage klären.
> Aktualisiere Paketstatus und Phase-18-Verlauf nach jedem fertigen Paket.
> Führe gezielte Pakettests und zum Schluss die genannten gemeinsamen Prüfungen
> aus. Dokumentiere Ergebnisse ehrlich; plane keine zusätzlichen Großaudits.

Lesereihenfolge für Rückfragen zu Grundlagen: Phase 16 P16-10/P16-11/P16-18
(Projektidentität/-wechsel), Phase 17 P17-06/P17-07/P17-10/P17-11 und technische
Verträge (Quellen, Papierkorb, Restore), Phase 13 Konzept/Plan (Bündelauswertung),
Phase 19 Leitplanken. Masterplan, Regelmatrix und Glossar liefern die
übergeordneten Begriffe. Der Phase-18-Plan ist für die hier bestätigten
Projekterweiterungen führend; ältere Projektentwürfe nicht als offenen Auftrag
oder abweichende Freigabe behandeln.

Planungsprüfung: Projektcode, Zuordnungsdienst/-tabellen, Datenbankschema,
Projekt-Tests, relevante Aufgaben-/Bündel-/Lebenszyklusleser und Dokumentation
gezielt abgeglichen. Kein vollständiger Codeaudit aller App-Module, kein
Flutter-Testlauf und keine Migrationsausführung in diesem Planungschat.

### Zweite Prüfung am 6. Oktober 2026

Auf Nutzerwunsch den fertigen Plan nochmals anhand konkreter Codepfade und
Bedienfolgen geprüft. Die erste Fertigmeldung war hinsichtlich der folgenden
Randfälle zu optimistisch; sie sind jetzt in den technischen Verträgen ergänzt:

| Gefundene Lücke | Korrektur im Plan |
|---|---|
| Unveränderte Archivzuordnung verschwindet aus aktiver Dropdown-Liste. | Aktive Ziele plus genau eine sichtbare bestehende Auswahl; No-op-Speichern erhält sie. |
| Bündeldetails erfordern ein Tagesobjekt mit Quellen; Projektmitglieder existieren auch ohne heutige Fälligkeit. | ID-basierter Leser/Einstieg, Zustände und Versionen für zukünftige/aufgelöste/nicht verfügbare Bündel. |
| Initiales zukünftiges `validFrom` würde die neue Projektzuordnung bis dahin unsichtbar machen. | Initiale Mitgliedschaft ab dem früheren Tag von heute/Start; Auswertung weiterhin erst im gültigen Zeitraum. |
| Aufgeschobene Abzuordnung separat gelöschter Inhalte verliert den Anlass, wenn das Projekt vorher restauriert wurde. | Systemereignis bereits während Projektlöschung speichern, Rohdaten und Papierkorbfrist erhalten. |
| Metadatenspeichern mit kompletter Checkbox-Auswahl kann fremde/neuere Mitgliedschaft überschreiben. | Metadateneditor und typisierte Zuordnungsbefehle auch in der UI klar trennen. |
| Frühere Mitglieder fehlen in aktueller Übersicht und wären über Projektsummen nicht mehr erreichbar. | Einfache Beitragsliste im Analyse-Tab; Detailumfang und Rücknavigation eindeutig. |
| Alte Projekt-Joins/Navigation könnten leere Löschmarker oder veraltete Objektsnapshots anzeigen. | Gemeinsamer Zustands-Lookup und ID-basierte Aktualisierung an den betroffenen Zugriffspunkten. |
| Gemeinsames Restore könnte spät einen abweichenden Umfang entdecken oder Aufgaben-Nachbearbeitung auslassen. | Restore-Vorschau, atomare Reihenfolge und vorhandene Nachbearbeitung; konkrete einseitige Abhängigkeiten. |

Dies ist eine statische Prüfung des Plans und der UI-Codepfade mit
nachvollzogenen Beispielen, keine ausgeführte Bedien-/Widgetprüfung. Die
Abnahmematrix dient im Umsetzungschat zum Nachweis. Der Plan ist damit eine
konkrete Umsetzungsvorgabe, keine Garantie für fehlerfreie Implementierung.

### Abschluss der späteren Umsetzung

Phase 18 ist abgeschlossen, wenn:

1. Projekt-Minimalregeln für den ersten Release dokumentiert sind,
2. die vorhandenen Projektfunktionen gegen diese Regeln geprüft wurden,
3. Projektauswertung dieselben Grundbegriffe wie Aufgaben/Habits nutzt,
4. Projektlöschung nicht mehr als ungeklärter UI-Stub im Release steht,
5. spätere Unterprojekte und Unteraufgaben fachlich abgegrenzt sind,
6. gezielte Tests die wichtigsten Projektflüsse absichern.
