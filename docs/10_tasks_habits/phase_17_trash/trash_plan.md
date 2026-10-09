# Momentum – Phase 17: Papierkorb und Wiederherstellung

Stand: 4. Oktober 2026  
Status: Phase 17 vollständig umgesetzt und automatisiert geprüft

## Aktueller Umsetzungsstand

Die Pakete 17a–17f sind abgeschlossen. Maßgeblich umgesetzt sind Schema 20,
Unterbrechungsintervalle, Papierkorb und Wiederherstellung für Aufgaben sowie
Bündel, endgültige Löschmarker, Pausieren/Fortsetzen, freiwillige
Pauseneingaben, neutrale Zielzeiträume, Mehrfachbündel und die zugehörigen
Bedienwege. Der Abschnitt „Arbeitsauftrag und Vorgehen“ dokumentiert den
historischen Planungsauftrag; er beschreibt nicht mehr den aktuellen Codezustand.

**Einstieg für den Umsetzungs-Chat:** Zuerst [Umfang und Quellen](#umfang-und-quellen),
danach den [technischen Vertrag](#technischer-umsetzungsvertrag) und die
[Arbeitspakete](#umsetzungspakete-und-reihenfolge) lesen. P17-01 bis P17-18 sind
bestätigte Produktentscheidungen; der technische Vertrag konkretisiert sie.

## Ziel

Löschen soll nicht versehentlich historische Daten zerstören. Aufgaben und Habits
sollen zunächst in einen Papierkorb wandern und dort wiederhergestellt oder
endgültig gelöscht werden können.
Zusätzlich kann die weitere Planung pausiert und später fortgesetzt werden,
während die bisherige Historie erhalten und auswertbar bleibt.

## Arbeitsauftrag und Vorgehen (historische Planung)

Dieser Chat plant Phase 17 für die Umsetzung in einem anderen Chat. Es wird
kein Anwendungscode geändert. Entscheidungen mit Auswirkungen auf Datenmodell,
Historie und spätere Erweiterungen werden einzeln geklärt. Leicht veränderbare
Details werden gebündelt; größere Untersuchungen vorher mit dem Nutzer
abgestimmt. Bestätigte Regeln, Vorschläge und offene Fragen bleiben getrennt.

Der fertige Plan soll Umsetzungsreihenfolge, betroffene Codebereiche,
Abhängigkeiten und gezielte Abnahmefälle enthalten. Ziel ist eine verlässliche,
kontingentschonende Übergabe, keine vollständige Vorabimplementierung.

Präzisierung des Nutzers vom 2. Oktober 2026: So einfach wie möglich, ohne
nutzerunfreundlich zu werden. Einheitliche Standardregeln und verständliche
Hinweise bevorzugen. Keine zusätzlichen Zustände, Einstellmöglichkeiten oder
Assistenten für seltene Randfälle einführen, wenn eine einfache Regel genügt.
Kleine Entscheidungen gebündelt abstimmen; grundlegende Daten- und
Wiederherstellungsregeln trotzdem eindeutig festhalten.

## Bereits dokumentierte Grundlage

- Papierkorb auf Ebene der gesamten Aufgabenkette
- Standard-Aufbewahrung sieben Tage
- Wiederherstellung ohne Nachplanung während der Papierkorbzeit
- automatische Bereinigung später zum Tageswechsel

Die Regelmatrix, Abschnitt „Löschen und Papierkorb“, enthält bereits bestätigte
Leitplanken: ganze Aufgabenketten einschließlich vorhandener Einträge,
eingefrorener Zustand und Unsichtbarkeit in regulären Ansichten,
Wiederherstellen, endgültiges Löschen und Papierkorb leeren. Sieben Tage sind
Standard; eine spätere globale Einstellung darf 1–30 Tage erlauben.
Wiederherstellung behält vorhandene Einträge und ursprüngliche Fälligkeiten;
Papierkorbzeiten erzeugen keine zusätzlichen Instanzen. Diese Grundlagen werden
nicht ohne konkreten Konflikt erneut zur Entscheidung gestellt.

Die ältere pauschale Sperre für das Entfernen einzelner Instanzen ist zusammen
mit P16-20 zu lesen: Entfernbare freiwillige Tracking-Eingaben sind eine eigene
Korrekturfunktion und nicht Gegenstand der Löschung einer ganzen Aufgabe.

## Erste Bestandsaufnahme vom 23. September 2026

Die folgenden Befunde dokumentieren den Einstieg. Der gezielte technische
Abgleich vom 4. Oktober steht im Vertrag und in der Änderungsstellen-Tabelle.

- Datenbankschema derzeit Version 19 (`lib/core/database/app_database.dart`).
- `AufgabenRepository.deleteTask` löscht aktuell physisch. Aktive und historisch
  referenzierte Bündel-Quellen sind durch ausdrückliche Sperren geschützt.
- `Aufgaben` besitzt `isActive` und `endDate`, aber keinen Papierkorbstatus.
  Der Scheduler verwendet `isActive` für Planung und automatische Konsequenzen.
  Ein einzelner Aktiv-Schalter genügt daher nicht als vollständiges Konzept für
  wiederholtes Löschen/Wiederherstellen und dauerhaft ausgesparte Zeiträume.
- Phase 16 ist laut Abschlussdokument umgesetzt. Endgültige Löschung muss auch
  Definitionsversionen, Vormerkungen, Korrektur-/Undo-Daten, Projektzuordnungen
  und Kartenpräferenzen berücksichtigen.
- Bündel besitzen eigene historische Referenzen auf ihre Teil-Trackings.
  Ihre Löschung und Auswertung bei fehlenden Quellen sind grundlegend zu klären.
- Projektlöschung ist in der Oberfläche noch nicht ausführbar; im Repository
  existiert bereits eine physische Löschmethode. Phase 18 darf deshalb weder
  als vollständig umgesetzt noch als technisch unvorbereitet gelten.
- Der Workspace enthält umfangreiche bestehende Änderungen und unversionierte
  Dateien. Vor Umsetzung erneut prüfen und keine fremden Änderungen zurücksetzen.
- Ältere Dokumentübersichten und Schrittnummern enthalten veraltete
  Phasenzuordnungen. Maßgeblich sind hier Phase 17 Papierkorb, Phase 18 Projekte
  und Phase 19 Sync-Vorbereitung.

## Umfang und Quellen

Der technische Abgleich wurde am 4. Oktober 2026 ausdrücklich beauftragt und
gezielt durchgeführt. Geprüft wurden Schema/Referenzen, Scheduler, relevante
Repository-Leser und -Schreiber, Definitionen/Vormerkungen, Korrektur-/Undo-Wege,
Projektleser, App-Lifecycle, Bündelkarten und bestehende Testansätze. Dies ist
keine vollständige Qualitätsprüfung aller App-Funktionen und kein Testlauf.

| Quelle | Bedeutung für die Umsetzung |
|---|---|
| Dieser Plan | Maßgeblich für Phase 17; bestätigte Regeln nicht erneut abfragen. |
| `task_rule_matrix.md`, Abschnitt Papierkorb | Grundregeln; dieser Plan präzisiert Fristen, Pausen, Bündel und Wiederherstellung. |
| Phase 12/13: Wert-Erfassung und -Auswertung | Eigenständige Quellen, virtuelle Tracking-Tage und Tagesversätze beibehalten. Frühere Exklusivität einer Bündelquelle wird durch P17-11 ersetzt. |
| Phase 14: Zielbewertung | Bestehende Fenster/Blockanker behalten; ausgeschlossene Tage neutral behandeln, keine Zielskalierung. |
| Phase 15: Kartenkennzahlen | Bestehende Präferenzen erhalten; Filter und Datenänderungen müssen auch Kennzahlen aktualisieren. |
| Phase 16: Historisierung | Schema 19, stabile Entry-IDs, Definitionsversionen, Korrekturen, Undo und Zuordnungshistorie bleiben Grundlage. P17-11 ersetzt nur die Exklusivität zwischen unterschiedlichen Bündeln, nicht die Versionierung eines Bündels. |
| Phase 18/19 | Projektlöschung und Sync bleiben dort; Anschlussvertrag unten beachten. |

Ältere Verlaufsdokumente können frühere Planungsstände enthalten. Insbesondere
bezeichnen dortige Nummern 16/17/18 teilweise die heutigen Phasen 17/18/19.
Keine überholte Bündelsperre oder nicht mehr gültige Phasennummer übernehmen.

Umfang: Aufgaben-/Habit-Papierkorb, Bündel-Papierkorb, Pausieren/Fortsetzen,
Mehrfachbündel, zugehörige Anzeige/Auswertung und lokale Bereinigung. Keine
Projekt-Papierkorboberfläche, Cloud-Synchronisierung, frei terminierten Pausen,
neue Streak-Auswertung oder umfassende Archivverwaltung ergänzen.

## Bestätigte Entscheidungen

### P17-01 – Gelöschte Aufgaben tragen nicht zu regulären Auswertungen bei

Bestätigt am 23. September 2026: Beim Verschieben in den Papierkorb verschwinden
auch die bisherigen Ergebnisse der Aufgabe aus regulären Auswertungen,
einschließlich historischer Gesamt- und Projektauswertungen. Bei
Wiederherstellung werden die erhaltenen Ergebnisse wieder berücksichtigt.
Nach endgültiger Löschung bleiben diese Beiträge entfernt.

Der Papierkorb bewahrt Daten zur Wiederherstellung auf; er ist keine dauerhafte
Aufbewahrung beendeter Aufgaben. Wer nur die weitere Planung beenden und die
Historie in Auswertungen behalten möchte, benötigt einen getrennten Vorgang.
Dieser Vorgang wird gemäß P17-02 in Phase 17 aufgenommen.
Bündelabhängigkeiten werden separat geklärt; aus P17-01 allein folgt keine
automatische Löschung weiterer Aufgaben oder Bündel.

### P17-02 – Planung beenden und später wieder aufnehmen

Bestätigt am 23. September 2026: „Planung beenden“ gehört zu Phase 17.
Der Nutzer möchte ein Habit anschließend wieder aufnehmen können. Eine
unwiderrufliche Beendigung ist daher nicht das gewünschte Verhalten.

Beenden und Pausieren benötigen dafür keine getrennten technischen Zustände:
Die Planung ist auf unbestimmte Zeit gestoppt und kann später fortgesetzt
werden. Historie und Identität der Aufgabe bleiben erhalten; ihre bisherigen
Ergebnisse zählen weiterhin zu regulären Auswertungen. Ein eigener Zustand
für endgültiges Beenden ist bisher nicht beauftragt.

Die UI-Bezeichnungen „Pausieren“ und „Fortsetzen“ sind durch P17-17 bestätigt.
Auch dauerhaft nicht fortgesetzte Habits können in diesem Zustand verbleiben.
„Planung beenden“ bezeichnet im Plan denselben fachlichen Umfang.

Stichtage, Fortsetzung, ausgesparte Zielzeiträume und Vormerkungen sind in
P17-03 bis P17-05 sowie P17-15 konkretisiert. Für die Unterbrechung werden
keine Verpflichtungen nachträglich erzeugt.
Automatisch terminierte Pausen oder eine umfangreiche Archivverwaltung sind
bisher nicht beauftragt.

#### Technische Ausgangslage

Phase 16 dokumentiert ausdrücklich, dass eine vollständige Beenden-/Archivfunktion
noch fehlt. Im ursprünglichen Phase-17-Umfang war sie nicht ausdrücklich enthalten.
`endDate` ist technisch vorhanden und wird bei der Terminplanung berücksichtigt;
das ersetzt noch keinen vollständigen fachlichen Vertrag und Bedienweg.

Wiederholtes Stoppen und Fortsetzen muss dauerhaft nachvollziehbare
Unterbrechungszeiträume hinterlassen, damit spätere Scheduler-Läufe und
Auswertungen keine künstlichen Verpflichtungen für diese Zeit erzeugen.
Ein einzelnes überschriebenes Enddatum ist dafür als alleinige Information
nicht ausreichend. Das konkrete Datenmodell wird nach den Fachregeln festgelegt.

### P17-03 – Pausieren verändert vorhandene Einträge nicht

Bestätigt am 23. September 2026: Alles, was vor der Pause offen war, bleibt
offen. Pausieren ändert nichts an der Vergangenheit und schließt vorhandene
Einträge weder automatisch ab noch entfernt es sie.

- Die Pause verhindert neue Planung; vorhandene Einträge bleiben beantwortbar.
- Ihre ursprünglichen Fristen und automatischen Konsequenzen gelten weiter.
  „Bleibt offen“ bedeutet keine zusätzliche Sperre gegen eine später regulär
  fällige automatische Konsequenz.
- Bestehende Ergebnisse und historische Einträge werden durch die Pause nicht
  umgeschrieben. Auch ein Abschluss eines alten Eintrags während der Pause darf
  die pausierte Planung nicht eigenständig wieder starten.
- Der Bedienweg erklärt knapp, dass bereits offene Einträge bestehen bleiben.

Technische Konsequenz: Erzeugung neuer Instanzen und Verarbeitung vorhandener
Instanzen müssen den Pausenstatus unterschiedlich behandeln. Der heutige
gemeinsame Filter auf `isActive` genügt dafür nicht.

Gezielte Abnahmefälle: offener Eintrag bleibt beantwortbar; Fristkonsequenz
greift auch während der Pause; abgeschlossene Historie bleibt unverändert;
Abschluss eines Alt-Eintrags erzeugt während der Pause keine Folgeinstanz.

### P17-04 – Zielblöcke mit einer Pause werden nicht bewertet

Phase 14 bewertet historische Ziele in festen Blöcken. Bereits dort werden
unvollständige Anfangsblöcke und Mischblöcke bei sofortigen Zieländerungen nicht
anteilig bewertet.

Bestätigt am 23. September 2026: Ein Zielblock, dessen Planungszeitraum durch eine
Pause verkürzt wird, bleibt mit Hinweis „Pausiert – nicht bewertet“ sichtbar
und wird aus der Zielerreichungsquote ausgeschlossen. Rohdaten und einzelne
Ergebnisse bleiben auswertbar. Keine automatische Umrechnung etwa von
„3-mal in 7 Tagen“ auf eine kleinere Zielzahl; abgeschlossene Blöcke vor der
Pause bleiben unverändert. Live-Zielanzeige und genaue Tagesgrenzen konkretisiert
der technische Vertrag. Ein solcher Block wird weder
als erreicht noch als verfehlt gezählt, auch wenn vor der Pause bereits
genügend Erfolge vorlagen. Die einzelnen Ergebnisse bleiben erhalten.

### P17-05 – Tagesgrenzen und Fortsetzen

Als zusammenhängendes Regelpaket bestätigt am 23. September 2026:

- Pausieren stoppt die Planung ab morgen. Der heutige Tag einschließlich
  bereits entstandener Verpflichtungen bleibt unverändert. Vor dem Speichern
  muss der reguläre Abgleich bis einschließlich heute erfolgt sein, damit
  das Ergebnis nicht davon abhängt, ob eine Tageskarte bereits geladen wurde.
- Fortsetzen gilt ab heute. Bei kalendergebundenen Rhythmen erscheint heute
  genau dann eine neue Instanz, wenn heute regulär ein Termin wäre; sonst am
  nächsten passenden Tag. Für ausgesparte Tage wird nichts nachgeplant.
- Bei „X Tage nach Erledigung“ bleibt eine bestehende offene Instanz maßgeblich.
  Ohne blockierende Altinstanz bleibt ein noch zukünftiger Folgetermin erhalten.
  Wäre der nächste Termin während der Pause fällig gewesen, erscheint beim
  Fortsetzen eine Instanz für heute, ohne rückwirkende Überfälligkeit.
- Fortsetzen verschiebt keine schon vorhandene offene Instanz und erzeugt
  keine zweite Instanz desselben Tages. Eine am selben Tag begonnene und
  wieder aufgehobene Pause spart keinen Planungstag aus.

`no_entry` bei Abschlussrhythmen und Live-Zielanzeigen konkretisiert der
technische Vertrag. Freiwillige Eingaben regelt P17-16, vorgemerkte
Definitions-/Projektänderungen P17-15.

### P17-06 – Bündelquellen bleiben durchgehend eigenständig

Code- und Dokumentbefund: Ein Bündel hat keine eigenen Rohwerte. Seine zwei
Quellen sind eigenständige Aufgaben. Quellenreferenzen in Bündelversionen sind
derzeit Pflichtfelder mit `ON DELETE RESTRICT`; das Repository sperrt deshalb
auch die physische Löschung nur historisch referenzierter Quellen. Phase 16
erlaubt unvollständige Bündelergebnisse nach dem Entfernen einzelner Messwerte;
die Löschung einer gesamten Quelle wird durch P17-10 ergänzt.

Bestätigt am 23. September 2026: Die Teil-Trackings bleiben durchgehend
eigenständig. Ein Bündel verbindet ihre Anzeige und bildet eine zusätzliche
Anzeige-/Auswertungseinheit. „Zusätzliche Instanz“ im Nutzerfeedback bezeichnet
hier diese Einheit, keine geplante Aufgabeninstanz mit eigenen Messwerten.
Rohwerte bleiben ausschließlich in den Teil-Trackings; kein Kopieren oder
Übertragen der Dateneigentümerschaft an das Bündel.

Pausieren oder Löschen einer Quelle verändert
nicht automatisch den Lebenszyklus der anderen Quelle. Eine gemeinsame Aktion
auf beide Quellen müsste ausdrücklich als solche angeboten und bestätigt
werden. Das Bündel darf fehlende Werte nicht durch Null ersetzen. Solange
eine gelöschte Quelle nicht verfügbar ist, dürfen auch ihre im Papierkorb
aufbewahrten Rohwerte nicht indirekt in reguläre Bündelauswertungen eingehen.

Die fehlenden Quellen regelt P17-10, Mehrfachzugehörigkeit P17-11 und die
Werteingabe P17-12. Gemeinsame Aktionen auf beide Quellen sind nicht beauftragt.
Historische Referenzen
müssen die bestätigte Eigenständigkeit respektieren; die bisherige Löschsperre
ist keine dauerhafte Produktregel.

### P17-07 – Bündel selbst löschen oder auflösen

Bestätigt am 23. September 2026: Auch ein Bündel kann als eigene Einheit in den
Papierkorb verschoben werden. Das entfernt seine gemeinsame Anzeige und
abgeleitete Auswertung aus regulären Ansichten. Beide Quellen einschließlich
Rohwerten, Planung und eigenen Auswertungen bleiben unverändert erhalten und
sind eigenständig zugänglich. Wiederherstellung betrifft nur das Bündel;
endgültige Bündellöschung entfernt niemals die Quellen.

Die bereits bestehende Aktion „Bündel auflösen“ bleibt fachlich davon getrennt:
Sie beendet die Verbindung gemäß Phase 16 ab dem heutigen Auswertungstag und
erhält die Bündelauswertung früherer Tage. Bündel-Löschen betrifft dagegen die
gesamte Bündeleinheit einschließlich ihrer historischen Auswertung betreffen.
Mehrfach verwendete Quellen verhindern nach P17-11 keine Wiederherstellung.
Fehlende Quellen behandelt P17-10, vorhandene Quelldaten während der
Bündel-Papierkorbzeit P17-18.

### P17-08 – Löschumfang vor der Bestätigung erklären

Bestätigt am 23. September 2026: Vor dem Löschen muss eine Anzeige erklären,
was nach der Bestätigung genau gelöscht wird. Eine bloße allgemeine Nachfrage
wie „Wirklich löschen?“ genügt nicht.

Für jeden manuell ausgelösten Löschvorgang ist eine konkrete Vorschau Pflicht:

- Verschieben in den Papierkorb: betroffene Aufgabe bzw. Bündel mit Namen,
  Umfang einschließlich Historie, Auswirkungen auf reguläre Auswertungen,
  Wiederherstellbarkeit und geplantes endgültiges Löschdatum nennen.
- Bei einer Aufgabe mit Bündelbezug die Folgen für betroffene Bündel erklären;
  andere eigenständige Trackings werden nicht mitgelöscht.
- Bei einem Bündel ausdrücklich erklären, dass seine Verbindung und
  Bündelauswertung betroffen sind, beide Teil-Trackings samt Rohwerten aber
  erhalten bleiben und einzeln weiter nutzbar sind.
- Endgültiges Löschen: dauerhaft betroffene Daten und fehlende
  Wiederherstellbarkeit ausdrücklich nennen.
- Papierkorb leeren: gesamten betroffenen Umfang verständlich ausweisen.
  Keine unerklärte Sammelaktion oder stillschweigende zusätzliche Löschung.
- Abbrechen verändert keine Daten. Bestätigungsaktion eindeutig benennen,
  etwa „In Papierkorb verschieben“ bzw. „Endgültig löschen“.

Der Umfang muss aus den tatsächlichen Abhängigkeiten ermittelt werden;
Dialog und Löschvorgang dürfen keine widersprüchlichen Aussagen liefern.
Die fachlichen Folgen fehlender Quellen regelt P17-10; ihre technische
Repräsentation bleibt zu planen. Keine weiteren Löschfolgen daraus ableiten.

### P17-09 – Automatische endgültige Löschung ohne zweite Nachfrage

Bestätigt am 23. September 2026: Beim Verschieben in den Papierkorb kündigt
der Bestätigungsdialog das konkrete Ende der Wiederherstellbarkeit und die
anschließende automatische endgültige Löschung an. Die Bestätigung umfasst
diesen Ablauf. Bei Fristende ist keine weitere Nachfrage erforderlich.

Manuelles endgültiges Löschen und Papierkorb leeren benötigen weiterhin die
eigene Bestätigung gemäß P17-08. Exakte Fristberechnung, Bereinigungszeitpunkt
bei geschlossener App und Reihenfolge gegenüber Wiederherstellung bleiben
technisch/fachlich zu präzisieren.

### P17-10 – Endgültig fehlende Bündelquelle

Die Eigenständigkeit nach P17-06 erlaubt keine stillschweigende Löschung des
anderen Teil-Trackings. Die bisherige dauerhafte Löschsperre für historisch
referenzierte Quellen muss trotzdem durch einen benutzbaren Vertrag ersetzt
werden.

Bestätigt am 23. September 2026: Wird eine Quelle endgültig gelöscht, bleibt die
Bündeldefinition einschließlich eigener Historie erhalten und kennzeichnet
die Quelle als „Endgültig gelöscht“. Die verbleibende Quelle bleibt regulär
nutzbar. Betroffene abgeleitete Ergebnisse sind nicht mehr berechenbar; keine
Nullwerte und keine versteckt aufbewahrten Rohwerte oder Ergebnis-Kopien der
gelöschten Quelle. Die Löschvorschau erklärt diesen dauerhaften Verlust der
Berechenbarkeit. Das Bündel kann separat aufgelöst oder gelöscht werden.

Die technische Darstellung einer fehlenden Referenz und Bedienung
unvollständiger Bündel stehen im Vertrag unten. Ein Ersatz-Tracking nicht unter derselben
Bündelidentität einsetzen; Phase 16 sieht Quellenwechsel innerhalb einer
Bündel-ID bisher nicht vor.

### P17-11 – Mehrere Bündel pro Tracking

Nutzerfeedback vom 2. Oktober 2026: Die vorgeschlagene Wiederherstellung nur
als historisches/aufgelöstes Bündel ist für diesen Randfall zu kompliziert.
Diesen unbestätigten Sonderweg nicht umsetzen.

Bestätigt am 2. Oktober 2026: Ein Tracking darf gleichzeitig mehreren Bündeln
angehören. Diese Erweiterung gehört zu Phase 17. Sie ersetzt die bisherige
Exklusivität einer Quelle über unterschiedliche Bündel hinweg, einschließlich
der entsprechenden historischen Überlappungssperre. Die zeitliche Eindeutigkeit
von Definitionsversionen innerhalb desselben Bündels bleibt erforderlich.

- Alle Bündel referenzieren dieselben ursprünglichen Tracking-Einträge.
  Keine eigenen Kopien von Messwerten oder zusätzlichen Verpflichtungen.
- Eine Änderung eines Quellwerts wirkt auf alle Berechnungen, die genau diesen
  Eintrag verwenden; die jeweiligen Tagesversätze bleiben maßgeblich.
- Erstellen oder Wiederherstellen eines Bündels verdrängt kein anderes Bündel.
  Eine bereits verwendete Quelle ist kein Wiederherstellungskonflikt mehr.
- Auflösen/Löschen eines Bündels verändert keine Quelle und kein anderes
  Bündel. Löschen einer Quelle betrifft die Berechenbarkeit sämtlicher darauf
  beruhender Bündel gemäß P17-06/P17-10; die Vorschau muss sie berücksichtigen.
- Auswertungen der ursprünglichen Trackings dürfen Einträge durch zusätzliche
  Bündelreferenzen nicht mehrfach zählen.

Gezielter Codebefund vom 2. Oktober 2026:

- Die Bündeltabellen speichern Referenzen auf zwei eigenständige Quellen;
  es gibt dort keine globale Eindeutigkeitsbedingung pro Quelle. Mehrere
  Bündel benötigen grundsätzlich keine Kopien der Tracking-Einträge.
- `createValueBundle` sperrt Mehrfachverwendung über
  `_hasOverlappingBundleSource`. Auswahlwege und zugehörige Tests sind
  gemeinsam anzupassen.
- `_attachLinkedValueBundles` verwendet eine Map mit genau einem Bündel pro
  Tracking. `TaskForDate.linkedValueBundle` sowie die Navigation in der
  Aufgabenansicht erwarten ebenfalls höchstens ein verknüpftes Bündel.
  Nur die Erstellungssperre zu entfernen wäre daher unvollständig.
- Die Tagesansicht blendet Quellen kombinierter Bündelkarten als Einzelkarten
  aus. Bei Mehrfachverwendung ist eine einfache einheitliche Anzeigeregel
  festzulegen; insbesondere dürfen verknüpfte Bündel nicht gegenseitig
  unsichtbar werden. Gemeinsame Eingaben müssen dieselben Rohdaten ändern.

Gezielte Abnahmefälle: A+B und A+C gleichzeitig anlegen; Änderung von A
aktualisiert beide Berechnungen; Wiederherstellung von A+B trotz vorhandenem
A+C; Auflösen/Löschen eines Bündels erhält das andere und alle Quellen;
endgültiges Löschen von A kennzeichnet beide Bündel als nicht berechenbar;
verknüpfte Bündel bleiben vollständig erreichbar; Tagesversätze und
historische Versionsauswahl funktionieren ohne doppelte Tracking-Zählung.

### P17-12 – Gemeinsame Werteingabe über bestehende Bündelkarten

Bestätigt am 2. Oktober 2026: Bestehende Bündelkarten und deren Werteingabe
beibehalten. Ein geteilter Wert kann in jeder passenden Bündelkarte eingegeben
oder geändert werden und erscheint anschließend in allen betroffenen Karten.
Er muss nicht pro Bündel erneut erfasst werden. Den Namen des Quell-Trackings
bei der Eingabe erkennbar machen. Keine automatische Auswahl eines führenden
Bündels und kein neuer Umschalter zwischen exklusiver und geteilter Verwendung.

Bei verknüpften Einzelkarten alle zugehörigen Bündel zugänglich machen,
beispielsweise über eine einfache Auswahlliste statt nur eines Detailziels.
Die genaue Platzierung ist eine leicht veränderbare Umsetzungsentscheidung.

### P17-13 – Alte Fristen gelten nach Wiederherstellung unmittelbar

Im Papierkorb ist die Aufgabe eingefroren; dort werden auch vorhandene offene
Einträge nicht durch automatische Fristkonsequenzen verändert. Die bisherige
Regelmatrix fordert Wiederherstellung vorhandener Einträge mit ursprünglichen
Fälligkeiten.

Bestätigt am 2. Oktober 2026: Nach Wiederherstellung gelten die ursprünglichen
Fristen ohne zusätzliche Schonfrist. Eine inzwischen fällige automatische
Konsequenz kann daher unmittelbar beim Wiederanlauf greifen. Ohne entsprechende
Automatik bleibt der alte Eintrag offen und gegebenenfalls überfällig.
Keine künstlichen Termine für die Papierkorbzeit erzeugen. Vor Wiederherstellung
kurz auf tatsächlich betroffene alte Einträge und ihre Konsequenzen hinweisen.

Gezielte Abnahmefälle: Während der Papierkorbzeit keine Statusänderung;
Wiederherstellung nach Fristablauf wendet die konfigurierte Konsequenz an;
ohne Automatik bleibt der Eintrag offen; keine zusätzliche Schonfrist oder
neuen Verpflichtungen für ausgesparte Tage. Bei Abschlussrhythmen darf eine
nachgeholte Konsequenz keine Folgetermine in der Papierkorbzeit nacherzeugen.

### P17-14 – Planungszustand und einfache lokale Bereinigung

Als Regelpaket bestätigt am 2. Oktober 2026:

- Wiederherstellung übernimmt den vorherigen Planungszustand: zuvor pausiert
  bleibt pausiert, zuvor aktiv läuft gemäß Wiederherstellungsregeln weiter.
  Vorhandene Einträge unterliegen in beiden Fällen P17-13.
- Für die erste Version bleibt die Aufbewahrung fest bei sieben Tagen.
  Die bereits vorgesehene Einstellung von 1–30 Tagen kommt später; dafür jetzt
  keine zusätzliche Einstellungsoberfläche bauen.
- Abgelaufene Papierkorbeinträge werden beim App-Start, bei Rückkehr in die
  App und beim Tageswechsel in der geöffneten App bereinigt. Kein eigener
  Hintergrunddienst allein für die lokale Papierkorbbereinigung. Bei
  geschlossener App kann die physische Löschung deshalb später stattfinden;
  der angezeigte Ablaufzeitpunkt begrenzt trotzdem die Wiederherstellbarkeit.

Exakte Fristberechnung und atomare Prüfung von Frist/Wiederherstellung stehen
im technischen Vertrag; keine Ausführung minutengenauer Hintergrundlöschung
versprechen, die die lokale App ohne Laufzeit nicht leisten kann.

### P17-15 – Vorgemerkte Änderungen behalten ihren Stichtag

Codebefund: Rhythmus-/Planungsänderungen und Zieländerungen besitzen bereits
Vormerkungen mit `effectiveDate`; Projektwechsel verwenden eine eigene
Zuordnungshistorie mit ebenfalls datierten Vormerkungen. Der Scheduler und
weitere Leser wenden fällige Änderungen heute automatisch an. Diese Wege
müssen Papierkorb und Pause ausdrücklich berücksichtigen.

Bestätigt am 2. Oktober 2026:

- Eine Pause löscht oder verschiebt keine bereits gespeicherte Vormerkung.
  Rhythmus, Ziel und Projektzuordnung wechseln am vorgesehenen Stichtag,
  ohne die Pause zu beenden oder neue Instanzen in der Pause zu erzeugen.
- Im Papierkorb bleiben die Vormerkungen erhalten und werden nicht angewandt.
  Bei Wiederherstellung werden inzwischen fällige Änderungen mit ihrem
  ursprünglichen fachlichen Stichtag berücksichtigt; zukünftige bleiben
  vorgemerkt. Für die Papierkorbzeit entstehen trotzdem keine Instanzen.
- Wiederherstellung erklärt kurz, falls dadurch inzwischen eine andere
  Einstellung gilt. Keine zusätzliche Auswahl zum Verwerfen, Verschieben oder
  Umdeuten der früher ausdrücklich gespeicherten Änderungen einführen.

Ein zwischenzeitlich endgültig gelöschtes Zielprojekt bleibt ein gesonderter
Abhängigkeitsfall für den Vertrag mit Phase 18; nicht automatisch neu anlegen.

### P17-16 – Freiwillige Eingaben während einer Pause

Bestätigt am 4. Oktober 2026: Die Pause unterbricht die automatische Planung,
ist aber keine Eingabesperre. Über die Detailansicht darf der Nutzer weiterhin
freiwillig einen Wert oder eine Antwort für einen Pausentag erfassen, soweit
der jeweilige Aufgabentyp diese Erfassung unterstützt. Bestehende historische
Einträge bleiben über die vorhandenen Korrekturfunktionen bearbeitbar.

Eine solche Eingabe beendet die Pause nicht, erzeugt keine zusätzlichen
Folgetermine und füllt keine anderen Pausentage auf. Sie zählt als tatsächlich
erfasster Eintrag zur passenden Roh-/Einzelauswertung. Der betroffene
Zielzeitraum bleibt gemäß P17-04 von der Zielbewertung ausgeschlossen.
Fehlende Eingaben an anderen Pausentagen sind keine verpassten Verpflichtungen.

Für die Umsetzung gezielt prüfen, welche bestehenden Eingabewege das bereits
unterstützen; keine neue allgemeine Sondererfassung oder Voraberzeugung leerer
Pauseneinträge daraus ableiten. Abnahme: freiwilliger Eintrag wird gespeichert
und ausgewertet, Pause bleibt bestehen, andere Pausentage bleiben ausgespart,
historische Korrektur bleibt möglich, Zielblock bleibt ohne Zielbewertung.

### P17-17 – Auffindbarkeit und Bedienung

Als Regelpaket bestätigt am 4. Oktober 2026:

- Die sichtbaren Aktionen heißen „Pausieren“ und „Fortsetzen“. Kein zusätzlicher
  „Beenden“-Zustand. Pausieren betrifft wiederkehrende Habits/Trackings; eine
  einmalige offene Aufgabe bleibt nach den bisherigen Regeln offen und braucht
  keine zusätzliche Pause, die nach P17-03 weder ihren Eintrag noch ihre Frist
  verändern würde.
- Pausierte Habits/Trackings sind gesammelt über „Pausierte“ in der Aufgaben-
  bzw. Habitübersicht erreichbar, mit Zugriff auf Details, Eingaben und
  Fortsetzen. Vorhandene offene Einträge bleiben zusätzlich in den regulären
  Tages-/Rückstandsansichten sichtbar; vergangene Tage bleiben zugänglich.
- Der Papierkorb ist über dieselbe Übersicht erreichbar. Ein gemeinsamer
  Bereich für Aufgaben/Trackings und Bündel genügt; dort Wiederherstellen,
  endgültiges Löschen und Leeren anbieten. Keine neue Hauptnavigation nötig.

Die konkrete Anordnung der Menüpunkte und Wiederverwendung bestehender
Listenbausteine kann der Umsetzungs-Chat entscheiden.

### P17-18 – Wiederhergestellte Bündel verwenden vorhandene Quelldaten

Bestätigt am 4. Oktober 2026: Liegt nur ein Bündel im Papierkorb, laufen seine
Quellen unabhängig weiter. Nach Wiederherstellung berechnet es auch die in
dieser Zeit tatsächlich erfassten Quelldaten gemäß seinen Definitionsversionen.
Keine eigenen Bundle-Entries, Wertkopien oder künstliche Berechnungslücke für
die Zeit im Papierkorb. War eine Quelle selbst pausiert oder im Papierkorb,
bleiben deren Lücken bestehen. Ein zuvor aufgelöstes Bündel bleibt aufgelöst;
Wiederherstellung verlängert seine gespeicherten Gültigkeitszeiträume nicht.

## Technischer Umsetzungsvertrag

Die folgenden Festlegungen sind aus P17-01 bis P17-18 und dem Code abgeleitete
Implementierungsvorgaben. Klassennamen dürfen zum vorhandenen Stil passen;
fachliche Invarianten und Transaktionsgrenzen nicht verändern.

### A. Datenmodell: Zustand, Unterbrechungen und endgültige Löschung

Ausgangsschema ist weiterhin **19**. Nächste freie Version zum Umsetzungsbeginn
prüfen (derzeit 20). Die neuen Tabellen zentral in `AppDatabase` registrieren.

| Änderung | Vertrag |
|---|---|
| `Aufgaben` und `TaskValueBundles` | `trashedAt`, `purgeAt` nullable sowie `lifecycleRevision` (Default 0) und `lifecycleUpdatedAt` ergänzen. Beide Papierkorbzeitpunkte gemeinsam gesetzt oder gemeinsam leer. |
| Neue `TaskPlanningInterruptions` | UUID, `taskId` mit Cascade, `reason` = `pause` oder `trash`, `fromDay`, `untilDayExclusive` nullable, `createdAt`, `updatedAt`, `revision`. Pro Aufgabe/Grund höchstens ein offenes Intervall. |
| Neue `EntityDeletionMarkers` | Primärschlüssel aus `entityType` (`task`/`bundle`) und ursprünglicher `entityId`, `deletedAt`. Nur dauerhafte Löschidentität; keine Namen, Notizen, Definitionen oder Rohwerte. |
| `TaskValueBundleVersions` | `firstTaskId`/`secondTaskId` bleiben stabile, nicht leere Quell-IDs; ihre beiden `RESTRICT`-Fremdschlüssel entfallen. Fehlende Quellen werden bewusst aufgelöst, siehe C. Andere Constraints, insbesondere verschiedene Quellen und korrekte Versionsintervalle, bleiben. |
| `TaskEntries` | `planningOrigin` mit Default `planned`; zusätzlicher Wert `voluntary_pause` für erstmals freiwillig an einem ausgeschlossenen Pausentag erzeugte Einträge. Herkunft beim Bearbeiten erhalten. |

`isActive` und `endDate` nicht als Papierkorb- oder Pausenspeicher umdeuten.
Insbesondere bedeutet `TaskValueBundles.isActive = false` bereits „aufgelöst“.
Migration erhält diese Zustände. Pause wird aus einem offenen Pauseintervall
abgeleitet, Papierkorb aus `trashedAt`; beide können gleichzeitig bestehen.

Intervalltage als kalenderbezogene Datumsschlüssel `YYYY-MM-DD` speichern.
Ein gemeinsamer Helper übersetzt die bestehenden lokalen Entry-Datumswerte in
solche Schlüssel. Tagesgrenzen mit Kalenderarithmetik bilden, nicht durch
Addition von 24 Stunden; DST darf keine doppelten oder fehlenden Tage erzeugen.
Intervalle sind `[fromDay, untilDayExclusive)`. Leere geschlossene Intervalle
mit gleichem Anfang/Ende sind zulässig und ohne fachliche Wirkung. Die Vereinigung
mehrerer Pause-/Papierkorbintervalle bestimmt ausgeschlossene Planungstage.
Lebenszykluszeitpunkte dagegen sind echte UTC-Zeitpunkte.

Warum die zusätzliche Entry-Herkunft: Eine freiwillige Eingabe an einem Pausentag
darf nach Entfernen, Wiederöffnen oder einem späteren Scheduler-Lauf nicht zu
einer automatisch sanktionierten Pflichtinstanz werden. Bestehende Einträge
bekommen durch die Migration keine neue Bedeutung. Neue normale Einträge und
Eingaben in vorhandene Pflichtinstanzen behalten `planned`.
Die Herkunft ist keine neue Statusantwort und ändert weder Wertart noch
Definitionsversion. Korrektur-/Undo-Snapshots berücksichtigen sie; alte
gespeicherte JSON-Payloads ohne dieses Feld bleiben lesbar und dürfen die
Herkunft eines inzwischen vorhandenen Eintrags nicht überschreiben.

### B. Gemeinsame Zustandsprüfung statt verteilter Sonderregeln

Ein kleines Modul unter `lib/features/aufgaben/data/`, z. B.
`task_lifecycle_service.dart` mit Tabellen in `task_lifecycle_tables.dart`,
verwaltet die Mutationen. Eine daraus nutzbare reine Zustands-/Intervallprüfung
wird von Scheduler, Repository und Auswertung geteilt. Keine Abhängigkeit vom
UI und keine zyklischen Repository-Abhängigkeiten einführen.

Vier Fragen getrennt beantworten:

1. Ist die Aufgabe/das Bündel jetzt regulär lesbar und bearbeitbar?
2. Darf für den konkreten Tag automatisch eine neue Instanz entstehen?
3. Darf eine bestehende Instanz verarbeitet werden? Pause ja, Papierkorb nein.
4. Ist ein Tag/Zeitraum von der regulären Planung bzw. Zielbewertung ausgenommen?

Lebenszyklusdaten in Definitionen nicht zurückversionieren: Ein historischer
`TaskDefinitionResolver.taskForEntry/taskForDate` darf heutigen Papierkorbstatus
nicht rückgängig machen. Definitionsänderungen ändern umgekehrt keine
Pausen-/Papierkorbintervalle. Intervalle und Quellzustände für eine Liste oder
Auswertung gesammelt laden; keine neue DB-Abfrage pro Tag und Kennzahl.

Öffentliche Repository-Funktionen für Vorschau, Verschieben, Wiederherstellen,
endgültiges Löschen, Leeren, Pausieren und Fortsetzen anbieten; Aufrufer nutzen
weiter das Repository. Uhr (`now`) für Service und beteiligten Scheduler
injizierbar machen. Keine zweite, konkurrierende Instanzplanung implementieren.

### C. Fehlende Quellen und echtes Entfernen

Ein gelöschter Task bleibt **nicht** als versteckte Aufgabe mit Rohdaten bestehen.
Vor endgültigem Löschen wird in derselben Transaktion der minimale Löschmarker
geschrieben. Quell-IDs in alten Bündelversionen bleiben unverändert. Die
Bündelversion mit ihrem Namen/Formel/Rollen gehört weiterhin zum Bündel; es
wird keine zusätzliche Kopie von Name oder Messkonfiguration der Quelle angelegt.

Quellauflösung unterscheidet `available`, `trashed`, `deleted` und unerwartet
`missing`. Bei `deleted` ist der Marker vorhanden; unbekannt fehlende Quellen
als nicht verfügbar behandeln und diagnostizieren, nicht still eine Aufgabe
erfinden. Erstellen eines Bündels validiert beide existierenden, nicht im
Papierkorb befindlichen Quellen innerhalb seiner Transaktion.

`TaskValueBundleForDate.firstTask/secondTask` können heute nicht fehlen.
Dafür eine explizite Quellrepräsentation mit optionalem `TaskForDate` und
Verfügbarkeitsgrund einführen, statt Dummy-Aufgaben zu erzeugen. Calculation,
Detailansicht, Karten und Analytics müssen diese Zustände gemeinsam verstehen:
keine Berechnung/kein Wert 0 bei fehlender Quelle, kein Eingabefeld für sie,
vorhandene Quelle weiterhin erreichbar. Wiederherstellung einer Quelle stellt
ihre Verfügbarkeit in allen Bündeln automatisch wieder her.

**Cascade-Vertrag bei endgültiger Aufgabenlöschung:** Entries samt
`TaskEntryValues`, Definitionsversionen, Vormerkungen, Projektzuordnungsänderungen,
Korrekturvorgänge samt Before-/After-JSON und Items, Kartenpräferenzen und neue
Unterbrechungsintervalle entfernen. Projekte, andere Aufgaben und referenzierende
Bündel bleiben bestehen. Bei Bündellöschung nur Bündelversionen und zugehörige
Kartenpräferenzen entfernen. Löschmarker bleiben unabhängig von Cascades.

Die Marker sind ein kleiner Anschluss für Phase 19, kein fertiges Sync-Protokoll.
Sie verhindern Informationsverlust über endgültige Löschungen; Aufbewahrung,
Gerätebestätigung und Cloud-Löschabgleich klärt Phase 19. Keine Markerbereinigung
oder Wiederbelebung derselben UUID in Phase 17.

### D. Tagesgrenzen und atomare Abläufe

**Frist:** `purgeAt = trashedAt + 168 Stunden` als UTC-Zeitpunkt; in der UI
lokales Datum **und Uhrzeit** anzeigen. Wiederherstellung nur bei `now < purgeAt`.
Bereinigung bei `now >= purgeAt`. Kein gleitender Fristneustart durch erneutes
Drücken von Löschen. Nach echter Wiederherstellung und späterer neuer Löschung
beginnt eine neue Sieben-Tage-Frist. App-Start/Resume/Tageswechsel führen die
Bereinigung aus; bei geöffnetem Papierkorb auch vor Aktionen Frist neu prüfen.

**Pausieren:** reguläre Planung/Verarbeitung bis heute abgleichen, danach ein
offenes Pauseintervall **ab morgen** speichern. Statusanzeige schon heute
„Pausiert ab morgen“. Bestehende Einträge nicht verändern. Doppeltes Pausieren
ist ein No-op. Kein `isActive = false` und kein neues Definitionssnapshot nötig.

**Fortsetzen:** offenes Pauseintervall mit heute als exklusiver Endgrenze
schließen; liegt sein Anfang noch morgen, auf diesen Anfang begrenzen (leeres
Intervall). Anschließend regulärer Abgleich bis heute unter Beachtung aller
alten Intervalle. Eine weiterhin im Papierkorb befindliche Aufgabe kann nicht
über diesen Weg fortgesetzt werden. Doppeltes Fortsetzen ist ein No-op.

**In Papierkorb:** Vorschau ist lesend. Bei Bestätigung aktuellen Zustand und
angekündigten Umfang prüfen. Aufgabe bis heute regulär abgleichen, dann
Zeitpunkte setzen und ein `trash`-Intervall ab morgen öffnen. Pauseintervall
bleibt unverändert. Das schützt bereits vorhandene/heutige Verpflichtungen und
verhindert spätere Nachplanung ganzer Papierkorbtage. Bündel erhalten nur
Papierkorbzeitpunkte, keine Planungsintervalle und keine Versionsauflösung.

**Wiederherstellen einer Aufgabe:** In einer Transaktion Frist prüfen,
Papierkorbstatus aufheben, `trash`-Intervall bis heute schließen (leeres
Intervall wie oben zulässig), fällige Vormerkungen nach P17-15 anwenden,
vorhandene fällige Konsequenzen und erlaubte Planung bis heute abgleichen.
Bestehendes Pauseintervall bleibt bestehen. P17-05 gilt auch für den neuen
zulässigen Folgetermin nach Papierkorb; vorhandene offene Termine behalten ihr
Datum. Für ausgesparte Tage entstehen auch beim Nachholen alter Konsequenzen
keine Instanzen. Ein Wiederherstellen darf keine vorherige gesetzte `endDate`
oder einen bestehenden alten Aktivitätszustand eigenmächtig aufheben.

**Wiederherstellen eines Bündels:** Frist prüfen, Papierkorbzeitpunkte löschen,
sonstige Identität, `isActive` und Versionszeiträume unverändert lassen.
Andere Bündel und Quellen nicht verändern. Fehlende Quellen erlauben eine
Wiederherstellung mit verständlicher unvollständiger Anzeige. P17-18 anwenden.

**Endgültig löschen/leeren:** Nur im Papierkorb befindliche Ziele verwenden,
Löschumfang prüfen, Marker und Cascade gemeinsam committen. Manuelle einzelne
Löschung darf vor Fristende erfolgen; automatische Bereinigung nur ab Fristende.
Beim Leeren Quelle und abhängiges Bündel in beliebiger Reihenfolge sicher
entfernen. Keine zweite Implementierung der Purge-Logik für Automatik/Leeren.

Jede echte Lebenszyklusmutation erhöht Revision und Änderungszeit einmal;
No-ops nicht. Lesen einer Vorschau verändert keine Daten. Abbruch führt keine
angefragte Löschung/Pause aus. Vor Bestätigung geänderter Umfang (z. B. neues
betroffenes Bündel) erfordert aktualisierte Vorschau; veraltete UI-Objekte sind
keine Schreibberechtigung. Parallel ausgelöste Bereinigung/Wiederherstellung
serialisieren und innerhalb der Transaktion die Frist erneut prüfen.

### E. Scheduler, vorhandene Einträge und freiwillige Eingaben

`TaskInstanceScheduler` weiterverwenden. Seine heutigen `isActive`-Filter
reichen nicht. Automatische Instanzerzeugung prüft zusätzlich Papierkorbstatus
und ausgeschlossenen Planungstag. Bestehende echte Pflichtinstanzen dürfen
während einer Pause weiter fällig werden; im Papierkorb nicht.

Beim Wiederabspielen früherer Tage keine Konsequenzen innerhalb gespeicherter
Papierkorbtage anwenden; am Wiederherstellungstag dürfen inzwischen fällige
Konsequenzen nachgeholt werden. Ihre bisherigen fachlichen `effectiveAt`-Werte
beibehalten, tatsächliches `finalizedAt/updatedAt` ist die Ausführung. Die
Intervallsperre verhindert, dass daraus rückwirkende Folgetermine entstehen.
Carryover-Limits anhand tatsächlich vorhandener Pflichtinstanzen prüfen;
Pausentage erhöhen keinen Rückstand.

Abschlussrhythmen behalten die bisherigen Regeln: Eine vorhandene geplante
`pending`- oder `no_entry`-Instanz bleibt der bisherige Blocker; Wiederherstellung
wandelt `no_entry` nicht in Erfolg/Misserfolg um. Ohne solchen Blocker gilt der
bestehende Abstand ab dem maßgeblichen Abschluss. Fällt dessen nächster Termin
in die Unterbrechung, entsteht frühestens am Fortsetzungs-/Wiederherstellungstag
eine Instanz. Kein Neustart des vollen Abstands allein durch Fortsetzen.

Für freiwillige Pauseneingaben bestehende Wert-/Statusdialoge mit Datumsauswahl
aus der Detailansicht wiederverwenden. Kein leerer Eintrag allein durch Öffnen
oder Abbrechen. Bei Neuanlage `planningOrigin = voluntary_pause`, vorhandene
Eintragsidentität/Herkunft behalten. Solche Einträge sind keine Pflichtinstanzen
für Missed Policy, Carryover oder die Suche nach einem verpflichtenden offenen
Intervallblocker. Erfasste Antworten/Werte bleiben normale auswertbare Daten;
Entfernen/Wiederöffnen behält die freiwillige Herkunft. Kein neues Tracking-System.

Alle Schreibwege, auch Notizen, Sammelkorrekturen, Undo, Projektwechsel,
Definitionsänderungen und Kartenpräferenzen, prüfen den **aktuellen**
Papierkorbstatus. Dasselbe gilt für Werteingabe aus einer schon geöffneten
Bündelkarte. Vor dem Schreiben deren tatsächliche Quell-ID und Quelltag prüfen.
Zustandsprüfung und Schreibvorgang gemeinsam transaktional ausführen, damit
zwischen Prüfung und Schreiben kein Verschieben in den Papierkorb dazwischenkommt.

### F. Anzeige und Auswertung

| Zustand | Reguläre Leser | Neue Planung/virtuelle Fehlstellen | Alte Einträge |
|---|---|---|---|
| Aktiv | sichtbar | nach Rhythmus | bestehende Regeln |
| Pausiert | in „Pausierte“, alte offene Einträge weiterhin regulär | keine für ausgeschlossene Tage | sichtbar, bearbeitbar, Konsequenzen aktiv |
| Im Papierkorb | nur Papierkorbliste/-vorschau | keine | eingefroren und nicht regulär auswertbar |
| Wiederhergestellt | wie vorher aktiv/pausiert | keine rückwirkenden Unterbrechungstage | wieder auswertbar, P17-13 |
| Endgültig gelöscht | nur fehlende Referenz in erhaltenem Bündel | keine | physisch entfernt |

Papierkorbfilter an **allen** regulären Lesern anwenden, nicht nur in der
Tagesliste: Einzel-/Sammelanalysen, abgeschlossene Einmalaufgaben, Projekte,
Zuordnungsauswahl, Bündelquellen, Rohdaten-/Korrekturlisten und Kartenkennzahlen.
Direkt geöffnete Details reagieren auf Statusänderungen, statt einen alten
Snapshot weiter bearbeiten zu lassen. Leere Aggregate sind „keine Daten“, nicht 0 %.

Pausenintervalle dürfen bestehende Einträge nicht aus der Historie filtern.
`_isTaskVisibleOnDate` muss zwischen vorhandener Instanz und neu zu erzeugender
virtueller Karte unterscheiden. `_buildTaskValueAnalyticsSummary` darf für
ausgesparte Tage keine `virtualMissing`-Punkte erzeugen. Tatsächlich erfasste
freiwillige Werte/Antworten bleiben in der Roh-/Einzelauswertung; ein fehlender
oder wieder entfernter freiwilliger Wert wird dadurch keine neue Pflicht.

Zielblöcke behalten ihre bisherigen Anker und Grenzen. Schneidet ein Block
einen wirksamen Pause-/Aufgaben-Papierkorbtag, ist er `notEvaluated`, außerhalb
der Quote. Das gilt auch für vollständig ausgesparte Blöcke. Live-Zielanzeigen
nutzen dieselbe Regel für ihr rückwärtiges Fenster: neutrale Anzeige mit Grund,
keine rote/grüne Ampel oder anteilige Zielzahl. Rohfortschritt bleibt lesbar.
Die Pause **ab morgen** neutralisiert heute noch keine vergangene Zeitspanne.

Bei Bündeln die Quelltage mit `firstTaskDayOffset/secondTaskDayOffset` prüfen.
Ein Bündel-Zielfenster, das Unterbrechungstage einer erforderlichen Quelle
enthält, wird ebenfalls neutral bewertet. Vorhandene Werte bleiben berechenbar,
solange beide Quellen verfügbar sind. Liegt eine Quelle im Papierkorb oder
fehlt endgültig, keine indirekten historischen Ergebnisse aus ihr erzeugen;
fehlende Berechenbarkeit erklären. Ein eigenes Bündel-Papierkorbintervall gibt
es wegen P17-18 nicht.

`TaskForDate.linkedValueBundle` und die Map in `_attachLinkedValueBundles`
auf mehrere Verknüpfungen erweitern. Stabile Schlüssel aus Bündel-ID und
Auswertungstag verwenden (eine Quelle kann durch Tagesversatz zwei verschiedene
Bündeltage berühren). Auswahlfilter und Erstellungssperre entfernen, alle
anderen Kompatibilitätsregeln behalten. Keine neue globale Quellen-Exklusivität.

Kombinierte Karten behalten die gemeinsame Werteingabe. Einzelkarten weiter
ausblenden, wenn eine vollständige Eingabekarte sie ersetzt; bei gemischten
`combined_card`/`linked_cards`-Verbindungen die Zugänge zu **allen** Bündeln auch
am geteilten Quellbereich anbieten. Kein verknüpftes Bündel darf durch diesen
Filter unerreichbar werden. Offene Rückstandsinstanzen nicht nur anhand ihrer
Task-ID verstecken, wenn die Bündelkarte einen anderen Tag repräsentiert.
Fehlende/unvollständige Bündel und aufgelöste Historien müssen aus der Übersicht
erreichbar bleiben, bei Bedarf über eine einfache Bündelliste im bestehenden Menü.

Streams/`readsFrom` und Kennzahl-Caches um Aufgabenstatus, Unterbrechungen,
Löschmarker und beteiligte Quellen erweitern. Wertänderung in A+B aktualisiert
auch A+C; reine Lebenszyklusänderung aktualisiert eine bereits geöffnete Statistik.
Nicht allein `TaskEntries` beobachten. Die tatsächlichen Werte nur einmal zählen.

### G. Konkrete Änderungsstellen im geprüften Code

Alle folgenden Pfade sind relativ zum Repository; Methoden dienen als Suchanker.

| Dateien/Bereich | Änderungsschwerpunkt |
|---|---|
| `lib/core/database/app_database.dart`, Tabellen unter `lib/features/aufgaben/data/` | Schema/Migration, FK-Umbau, neue Tabellen/Herkunft; `.g.dart` generieren. |
| `task_instance_scheduler.dart` | `ensureEntriesInRange`, `isDueOnDate`, `_ensureEntriesForSingleDate`, alle Konsequenzpfade und `_isAfterCompletionDue`. |
| `task_definition_resolver.dart`, `task_project_assignment_service.dart` | `applyDueChanges` aktuell ohne Papierkorbschutz; auch Preview-/Undo-/direkte Schreibwege absichern. |
| `aufgaben_repository.dart`: Tages-/Einmalaufgabenleser | `watchTaskListForDate`, `watchTasksByUrgency`, `watchCompletedOneTimeTasks`, `watchOneTimeTaskAnalyticsSummaryForPeriod`, `_isTaskVisibleOnDate`. |
| Dasselbe Repository: Historie/Analytics | `_taskById`, `watchStoredTaskEntries`, neueste Einträge, `_buildTaskValueAnalyticsSummary`, `_buildTaskGoalHistorySummary`, alle Stream-/Kennzahlabhängigkeiten. |
| Dasselbe Repository: Bündel | `_valueBundlesForTasks` überspringt fehlende Quellen bisher; `_buildTaskValueBundleAnalyticsSummary` lädt sie zwingend. Beide umbauen; dazu `_taskForDateById`, `_attachLinkedValueBundles`, `compatibleTasksForValueBundle`, `createValueBundle`. |
| `task_entry_correction_service.dart`, sämtliche Entry-Schreiber | Papierkorbschutz, freiwillige Herkunft in Snapshots/Undo, keine Wiedererzeugung gelöschter Daten. |
| `task_for_date.dart`, `task_value_bundle_for_date.dart`, Calculation-/Analytics-/Goal-Modelle | Mehrfachverknüpfungen, optionale Quellen mit Gründen, neutrale Unterbrechungen. |
| `lib/features/projekte/data/project_repository.dart` | `watchProjectDetail`, `watchAssignableTasks`, Zuordnungsschreiber: Papierkorb ausschließen; pausierte Historie erhalten. |
| `lib/main.dart` | Vorhandene Start-/Resume-/Tageswechsel-Hooks um zentrale Bereinigung ergänzen; keine zweite Timer-Infrastruktur. Nächsten Kalendertag DST-sicher bestimmen. |
| `lib/features/aufgaben/presentation/aufgaben_screen.dart`, `completed_one_time_tasks_screen.dart` | Bisherige Hard-Delete-Dialoge ersetzen, Zugänge „Pausierte“/„Papierkorb“, veraltete Ansichten aktualisieren. |
| Task-/Bündel-Details, Erstellen/Bearbeiten/Korrekturen; `widgets/task_card.dart`, `task_value_bundle_card.dart`, `task_modes/value_task_input.dart` | Lebenszyklusaktionen, freiwillige Eingabe, Quellenhinweise, mehrere Bündelziele; gemeinsam genutzte Eingaben synchron anzeigen. |

### H. Migration und Grenzen zu Folgephasen

- Neue DB und echtes Upgrade **19 → nächste Version** prüfen. Bestehende IDs,
  Daten, Präferenzen, Definitionszeiträume und aufgelöste Bündel erhalten.
  Keine Intervalle aus alten `endDate`/`isActive`-Werten erfinden. Lebenszyklus-
  Spalten starten leer, Herkunft bestehender Entries mit dem Legacy-Default.
- `TaskValueBundleVersions` muss wegen der zwei entfernten Fremdschlüssel
  kontrolliert umgebaut werden. Restliche Constraints/Indizes und
  Versionsketten erhalten; anschließend `foreign_key_check` plus eigene
  Quellintegritätsprüfung (Quelle existiert **oder** passender Löschmarker).
- Die bisherigen Migrationen erstellen teilweise Tabellen aus dem aktuellen
  Schema. Upgrade von älteren Versionen darf deshalb neue Spalten/Tabellen
  nicht doppelt anlegen. Neue Migration nach tatsächlich vorhandenen
  Schemaelementen bzw. geeigneten Versionspfaden ausführen, keine historischen
  Datenmigrationen pauschal überspringen.
- Migrationsfixture aus dem echten Schema 19 erstellen, bevor der Code geändert
  wird. Eine neue DB nur per `PRAGMA user_version = 19` zurückzustufen ist kein
  gültiger Migrationsnachweis. Bestehende Tests mit künstlichem Downgrade darauf
  prüfen, dass sie weiterhin das behauptete Altschema abbilden.
- Phase 18 kann dieselben Lebenszyklusoperationen für eine ausdrücklich
  bestätigte Menge von Aufgaben in einer äußeren Transaktion verwenden.
  Keine UI-Dialoge oder Transaktions-Commits in niedrige Hilfsfunktionen binden.
  Projektlöschung selbst bleibt deaktiviert/ungeändert; Projekt-Papierkorb,
  Unterprojekte und Gruppierung solcher Löschungen sind dort zu entscheiden.
- Fehlendes Projekt nach Wiederherstellung: keinen Ersatz anlegen. Bestehende
  Zuordnungshistorie erhalten, aktuelle nicht mehr existierende Zuordnung als
  projektlos behandeln/erklären. Keine fremde Projektzuordnung überschreiben.
- UUIDs, Löschmarker und echte Revisions-/Zeitänderungen bereiten Phase 19 vor.
  Kein Firebase-Code, Outbox-System oder Mehrgeräte-Konfliktmodell in Phase 17.

## Umsetzungspakete und Reihenfolge

Alle Pakete sind umgesetzt. Die ursprüngliche Reihenfolge bleibt als
nachvollziehbare Umsetzungsgliederung erhalten.

| Paket | Status | Ergebnis und Prüfung |
|---|---|---|
| 17a – Schema und gemeinsame Zustandsprüfung | abgeschlossen | Schema 20, Intervalle, Marker und Entry-Herkunft; echte Schema-19-Fixture migriert verlustfrei, Fremdschlüssel geprüft, Kalendertage inklusive DST abgesichert. |
| 17b – Lebenszyklus und Schutz | abgeschlossen | Vorschau, Papierkorb, Restore, Purge, Gesamtleeren, Pause/Resume und Schreibschutz umgesetzt; Lebenszyklusrevision schützt veraltete Vorschauen. |
| 17c – Planung und Vormerkungen | abgeschlossen | Scheduler trennt neue Planung von Altinstanzen; Unterbrechungstage werden nicht nachgeplant, fällige Vormerkungen erst nach Restore angewandt, freiwillige Herkunft bleibt erhalten. |
| 17d – Leser, Ziele und Mehrfachbündel | abgeschlossen | Reguläre Leser filtern Papierkorb, Zielzeiträume werden neutral, fehlende Quellen bleiben erklärt erreichbar und ein Tracking darf mehreren Bündeln angehören. |
| 17e – Bedienung und App-Lifecycle | abgeschlossen | Konkrete Löschdialoge, Übersicht für Pausierte/Aufgaben/Bündel, freiwillige Eingabe, Wiederherstellung, endgültiges Löschen und Bereinigung bei Start/Resume/Tageswechsel umgesetzt. |
| 17f – Abschluss und Übergabe | abgeschlossen | Drift-Code generiert; Aufgaben-/Projekt-/Widgettests und vollständige Analyse grün; Dokumente aktualisiert. Phase 18/19 nicht vorgezogen. |

## Abnahmematrix

Neue Tests möglichst in `test/features/aufgaben/data/task_lifecycle_test.dart`,
`task_lifecycle_migration_test.dart` und passenden Widgettests bündeln.
Bestehende Repository-/Historisierungstests weiterverwenden; keine Tests schreiben,
die lediglich neue Tabellenfelder oder private Hilfsmethoden spiegeln.

| Fall | Erwartetes Ergebnis |
|---|---|
| Aufgabe mit Werten, Versionen, Vormerkungen, Undo und Präferenz in Papierkorb | Daten bleiben vorhanden, verschwinden aus allen regulären Lesern einschließlich Projekt-/Sammelauswertung; keine Schreiber mehr möglich. |
| Abbruch/Vorschau/alter Dialog | Vorschau lesend; Abbruch ohne angefragte Mutation; veränderter Löschumfang erfordert neue Vorschau. |
| Aktive bzw. pausierte Aufgabe wiederherstellen | Vorheriger Zustand, IDs und Daten erhalten; nur zulässige heutige Planung, keine Papierkorb-/Pausenrückstände. |
| Pause und Fortsetzen am selben Tag; mehrere Pausen; Pause über Papierkorb hinweg | Leere Intervalle erzeugen keine Lücke; alle echten Unterbrechungen bleiben dauerhaft ausgespart. |
| Alter offener Eintrag mit Direct/Buffer/Carryover | Während Pause normale Regeln; während Papierkorb eingefroren; nach Restore fällige Folgen; keine zusätzlichen Pflichtinstanzen. |
| Täglich, feste Wochen-/Monatstage, X Tage nach Abschluss | Heute/nächster passender Termin, ursprünglicher zukünftiger Abstand bleibt; vorhandenes geplantes `no_entry` wird nicht in einen Abschluss verwandelt. |
| Freiwilliger Pauseneintrag, danach Entfernen/Wiederöffnen/Undo | Herkunft bleibt; keine automatische Sanktion oder neue Pflichtplanung; echte Werte/Antworten bleiben auswertbar. |
| Pause/Trash schneiden Rohdaten-/Live-/Blockauswertung | Keine virtuellen Fehlstellen; echte Altwerte bleiben; betroffene Zielzeiträume neutral, keine Skalierung. |
| Vorgemerkte Planung/Ziel/Projektänderung wird während Pause/Trash fällig | Termin bleibt; Pause endet nicht; im Papierkorb keine Anwendung, bei Restore korrekte Nachholung ohne neue Lückeneinträge. |
| A+B und A+C; gemischte Karten und Tagesversatz | Eingabe A aktualisiert alle passenden Quelltag-Berechnungen, alle Details erreichbar, keine doppelten Tracking-Entries/Zählung. |
| Nur Bündel löschen/aufgelöstes Bündel wiederherstellen | Quellen unverändert; Wiederherstellung benutzt vorhandene Werte auch aus Papierkorbzeit, alte Versionsgrenzen bleiben. |
| Eine Quelle im Papierkorb bzw. endgültig gelöscht | Alle betroffenen Bündel erklären Nichtverfügbarkeit; andere Quelle bleibt nutzbar; Restore der Quelle stellt Berechnung wieder her. |
| Purge einer Quelle und/oder Bündel; Papierkorb leeren | Vollständige Cascades inkl. Undo-JSON, Marker bleiben; keine andere Quelle gelöscht, kein FK-Fehler. |
| Eine Sekunde vor, genau am und nach Ablauf; doppelte Aktionen; App länger geschlossen | Eindeutige Frist, keine verspätete Wiederherstellung; idempotente Bereinigung beim Öffnen, vollständiger Rollback bei Fehler. |
| Bereits geöffnete Detailansicht und Statistik | Papierkorbstatus stoppt Schreiben, Werte und Kennzahlen aktualisieren sich durch Streams ohne Neuöffnung. |
| Echte v19-DB und Neuinstallation | Daten/IDs erhalten; Migration reproduzierbar; Fremdschlüssel-/Quellintegrität korrekt. |

Zeitabhängige Tests mit fester Uhr ausführen, keine echten Wartezeiten. DST-Fälle
für lokale Tagesarithmetik prüfen; Aufbewahrung separat als 168-Stunden-Frist.
Mindestens ein Lösch-/Restore-Test muss alle realen Repository-Leser einschließen,
statt nur eine isolierte SQL-Abfrage zu prüfen.

Nach Schemaänderung `dart run build_runner build --delete-conflicting-outputs`,
betroffene Dart-Dateien formatieren, gezielte Tests je Paket ausführen. Am Ende
ein gemeinsamer Lauf der Aufgaben-/Projekt- und Widgettests sowie `flutter analyze`.
Bestehende Fehler von neuen unterscheiden; Ergebnisse ehrlich dokumentieren.
Keine Änderung an vorhandenen lokalen Seed-/SQLite-Dateien als Testfixture.

Manuelle Abnahme kurz halten: Habit mit Altinstanz pausieren/fortsetzen;
freiwilligen Wert in Pause erfassen; Quelle A in zwei Bündeln bearbeiten;
Aufgabe/Bündel löschen und wiederherstellen; Löschvorschau und fehlende Quelle
prüfen. Lange Fristen und Purge-Grenzen gehören in die automatisierten Tests.

## Umsetzungsabschluss am 4. Oktober 2026

- `AppDatabase` wurde von Schema 19 auf 20 erweitert. Eine eigenständige
  Schema-19-Fixture beweist Daten-/ID-Erhalt, neue Defaults, entfernte
  Quellen-Fremdschlüssel und einen leeren `foreign_key_check`.
- Aufgaben und Bündel besitzen eine feste 168-Stunden-Frist. Automatische
  Bereinigung läuft über die vorhandenen App-Start-, Resume- und
  Tageswechsel-Hooks; die Tagesberechnung ist kalenderbasiert.
- Pausen beginnen morgen, Fortsetzen gilt heute. Bereits vorhandene Einträge
  bleiben bearbeitbar; freiwillige heutige Pauseneingaben sind über die
  Lebenszyklusübersicht möglich und werden als `voluntary_pause` gespeichert.
- Papierkorbobjekte sind aus Tages-, Einzel-, Sammel-, Projekt- und
  Analytics-Lesern ausgeschlossen. Wiederherstellung reaktiviert erhaltene
  Daten ohne rückwirkliche Pflichtinstanzen.
- Bündelquellen bleiben eigenständig. Mehrere Bündel pro Tracking sind erlaubt;
  fehlende, im Papierkorb liegende oder endgültig gelöschte Quellen werden in
  Analytics und Bündelübersicht ohne Null-Ersatz erklärt.
- Der Papierkorb kann einzeln oder nach einer konkreten Gesamtvorschau geleert
  werden. Endgültige Löschungen hinterlassen ausschließlich minimale Marker.
- Verifikation: `flutter analyze` ohne Befund; vollständiger Flutter-Testlauf
  mit **129 bestandenen Tests**. Darin sind **11** gezielte
  Lebenszyklus-/Migrationstests enthalten.

Ein kurzer manueller Gerätetest der Dialoge und Navigation bleibt als übliche
Praxiskontrolle sinnvoll, ist aber kein offener Implementierungsblocker.

## Abschluss des Planungs-Chats (historisch)

Der technische Plan ist ausgearbeitet; Anwendungscode wurde nicht geändert und
Tests wurden nicht ausgeführt. Produktentscheidungen P17-01 bis P17-18 sind
bestätigt. Die technische Ausgestaltung oben ist die daraus abgeleitete Übergabe.
Vor Umsetzung Workspace/Schema erneut prüfen, da Dateien überwiegend noch
unversioniert sind. Keine dieser bestehenden Änderungen zurücksetzen.

Keine bekannte grundlegende Produktfrage blockiert den Start. Falls beim Coden
ein echter Widerspruch zu den bestätigten Regeln auftaucht, konkret benennen;
keine neue Grundsatzbefragung und keine stillschweigende Umfangserweiterung.

### Startauftrag für den nächsten Chat

> Setze Phase 17 anhand von
> `docs/10_tasks_habits/phase_17_trash/trash_plan.md` um. Lies zuerst den Umfang,
> den technischen Vertrag und die Pakete 17a–17f. Die Produktentscheidungen
> P17-01 bis P17-18 sind bestätigt. Prüfe den aktuellen Workspace und die
> Schema-Version, erhalte vorhandene Änderungen und beginne mit 17a.
> Arbeite die Pakete mit ihren gezielten Prüfungen ab. Stelle nur bei echten
> Widersprüchen Rückfragen; bleibe beim dokumentierten Umfang.
