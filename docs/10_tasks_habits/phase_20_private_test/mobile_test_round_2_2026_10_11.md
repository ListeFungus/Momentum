# Momentum – Android-Praxistest, neuer Durchlauf: N01–N11

Stand der Sammlung: 10. November 2026  
Status: **Nutzerbeobachtungen und neue Ideen gesammelt – keine Fehlerbehebung oder Feature-Umsetzung beauftragt**  
Testkontext: Nach Installation einer neueren App-Version auf einem Android-Handy; konkrete installierte Buildnummer **nicht verifiziert**. Die Beobachtungen stammen aus der Alltagsnutzung. Die zeitliche Reihenfolge ist N01–N05 (30.10.), N06 (04.11.), N07–N09 (danach), N10 (09.11.) und N11 (10.11.).

## Zweck und Arbeitsweise

Dieses Dokument ist das **vollständige, eigenständige Übergabedokument** des zweiten praktischen Testdurchlaufs. Es soll in einem späteren Chat zur Diagnose, Priorisierung, fachlichen Klärung und Umsetzung dienen. Es ersetzt weder bestehende Regelwerke noch frühere Testprotokolle. **Keiner der elf Punkte ist allein durch die Aufnahme in dieses Dokument umgesetzt oder technisch bestätigt.**

Zwei Achsen pro Eintrag:
- **Umsetzungsgruppe:** Quick Fix (vorläufig geringer Aufwand), Prüfen & Anpassen (Wechselwirkungen und/oder mögliche Datenfolgen), Ideen & Erweiterungen (neue/größere Funktionen).
- **Art:** 🐛 Fehler, 🎨 Design/UI, 🔧 Verbesserung, 💡 neue Funktion, ❓ prüfen. Mehrfachzuordnung möglich.
- **Priorität** ist eine separate Einschätzung; sie ist **keine** technische Machbarkeitszusage.

Grundsatz: ursprüngliche Beobachtungen von Hypothesen, Entscheidungen und späteren Implementierungen unterscheiden. Vor dem Code-Ändern aktuelle Dateien/Domain-Regeln und Teststand lesen; nicht auf alte Statuszeilen vertrauen.

## Kompaktübersicht

| Nr. | Thema | Umsetzungsgruppe | Art | Priorität |
|---|---|---|---|---|
| N01 | Aufgaben in Projektansicht abhaken | Quick Fix (vorläufig) | 🔧 🎨 | Normal |
| N02 | Links in Beschreibung antippbar | Quick Fix (vorläufig) | 🐛 🔧 | Normal |
| N03 | Beschreibung direkt kopierbar | Quick Fix (vorläufig) | 🔧 🎨 | Normal |
| N04 | Kalenderblock per Kurzmenü erledigen | Prüfen & Anpassen | 🔧 🎨 | Normal |
| N05 | Wechsel Tag → Monat aktualisiert Anzeige erst nach Monatsnavigation | Quick Fix (vorläufig) | 🐛 | Hoch |
| N06 | Massive App-Verlangsamung (Laden, Antwort, Tagwechsel) | Prüfen & Anpassen | 🐛 ❓ | **Sehr hoch / zuerst untersuchen** |
| N07 | Fasten-Bündel zeigt nur „ein Teil eingetragen“ | Prüfen & Anpassen | 🐛 ❓ | Hoch |
| N08 | Bündel-Rollen / Reihenfolge frei bestimmen | Prüfen & Anpassen | 🔧 🎨 | Normal |
| N09 | Tagesbezug als „Gestern / Heute / Morgen“ | Quick Fix (vorläufig) | 🎨 🔧 | Normal |
| N10 | Aktuelle Projekte → Kategorien; neue Projekte/Ziele | Ideen & Erweiterungen | 💡 🔧 | Konzept, später |
| N11 | Nächste Wiederholung erst beim Abschließen schnell festlegen | Ideen & Erweiterungen | 💡 🔧 | Konzept, später |

**Zählung:** 11 Punkte, davon 4 Quick Fixes (N01, N02, N03, N05) **plus N09 = insgesamt 5**, 4 Prüfen & Anpassen (N04, N06, N07, N08) und 2 Ideen & Erweiterungen (N10, N11). Die absichtlich ausgeschriebene Zählung dient der Nachvollziehbarkeit. Kein gesicherter Aufwand ohne Codeprüfung.

## A. Quick Fixes (vorläufig)

### N01 – Aufgaben innerhalb der Projektansicht abhaken

**Nutzerbeobachtung:** Aufgaben werden in der Projektansicht angezeigt, können dort aber nicht direkt als erledigt abgehakt werden.  
**Wunsch:** Direkt in der Projektansicht abschließen, ohne zur Tagesübersicht zu wechseln. Vorhandene Regeln zu einmaligen Aufgaben, wiederkehrenden Instanzen und Eingabearten nutzen.  
**Sollverhalten:** Nach Antippen einer geeigneten Erledigungsaktion aktualisieren sich alle davon abhängigen Ansichten und Auswertungen konsistent. Keine zweite Erledigungslogik.

**Offene Fragen / Prüfungen:**
- Gibt es in der Projektansicht vollständige Aufgaben oder auch mehrere fällige Instanzen derselben Definition? Welche soll abgeschlossen werden?
- Bei Habits, Werteingaben und Bündeln ist ggf. eine Wert-/Ja-Nein-Eingabe erforderlich statt einfachem Check.
- Wie mit noch nicht fälligen, archivierten, gesperrten oder wiederkehrenden Einträgen umgehen?
- Bestehende Undo-/Historienlogik und Projektübersicht verwenden.

**Abnahmebeispiel:** Einmalige offene Projektaufgabe im Projekt erledigen → in Tagesübersicht/Projekt/Auswertung übereinstimmend erledigt, kein Duplikat.

### N02 – Hyperlinks in Aufgabenbeschreibungen öffnen

**Nutzerbeobachtung:** In einer Aufgabenbeschreibung gespeicherte Internetadressen sind in der normalen Ansicht nicht anklickbar.  
**Wunsch:** Link ohne Umweg über „Bearbeiten“ direkt antippen und im geeigneten Browser öffnen.

**Offene Fragen / Prüfungen:**
- Erkennung von http/https, üblichen www-URLs und Satzzeichen; andere Schemes nicht unkontrolliert öffnen.
- Links in langen Beschreibungen, mehrere Links, Zeilenumbrüche, bestehende Textformatierung.
- Tippen auf Link darf nicht ungewollt auch die gesamte Kartenaktion auslösen.
- Externe URL-Öffnung nur sicher, Fehlerfälle sinnvoll anzeigen.

**Abnahmebeispiel:** Beschreibung enthält einen https-Link → Link ist antippbar; kein Bearbeitungsmodus nötig.

### N03 – Beschreibungstext ohne Bearbeiten markieren/kopieren

**Nutzerbeobachtung:** Beschreibungstext lässt sich nur im Bearbeitungsmodus kopieren.  
**Wunsch:** In der Detail-/Leseansicht Text markieren und (teilweise oder vollständig) kopieren, idealerweise Android-konform über Auswahlmenü.

**Offene Fragen / Prüfungen:**
- Kombination mit anklickbaren Links (N02), Scrollen und Karten-Gesten.
- Auswahl über Long-Press, vollständige Kopieraktion, Formatierungs-/Zeilenumbrucherhalt.

**Abnahmebeispiel:** Textfragment direkt aus der Beschreibung kopierbar; Aufgabe bleibt unverändert.

### N05 – Monatsansicht beim Wechsel aus Tagesansicht nicht aktualisiert

**Nutzerbeobachtung / Repro:** Im Kalender von Tag auf Monat umschalten → zunächst nicht korrekt aktualisiert; erst nach einem Klick auf nächsten/vorigen Monat wird die Monatsdarstellung richtig angezeigt.  
**Soll:** Beim Umschalten sofort passende Monatsdaten und richtige Beschriftung für das aktuell gewählte Datum, ohne zusätzliche Navigation.

**Offene Fragen / Prüfungen:**
- UI-State zwischen ausgewähltem Tag, sichtbarem Monat, Datenladevorgang und View-Modus.
- Testen auch Woche → Monat, Liste → Monat, Monat → Tag und Tageswechsel über Monatsgrenze.
- Keine Neuberechnung oder Änderung von echten Termindaten allein wegen Ansichtswechsel.

**Abnahme:** Mehrfach zwischen Ansichten umschalten; aktueller Monat wird jedes Mal sofort korrekt dargestellt.

### N09 – Tagesbezug der Uhrzeit-Eingaben verständlich benennen

**Nutzerbeobachtung:** Bei der Zuordnung einer Eingabe zu diesem, vorherigen oder nächsten Tag sind die derzeitigen Texte umständlich.  
**Wunsch:** Im entsprechenden Dialog schlicht **„Gestern / Heute / Morgen“** anzeigen. Nur Beschriftung ändern, sofern die Bedeutung identisch ist.

**Offene Fragen / Prüfungen:**
- Worauf beziehen sich die relativen Begriffe, wenn Nutzer einen **historischen Erfassungstag** öffnet? „Gestern“ relativ zum gerade bearbeiteten Datum oder zur Systemuhr? Dies muss eindeutig bleiben.
- Bei Fasten-Bündeln sind Bezugstag der Auswertung und Datum des Rohwerts zu unterscheiden (N07).
- Für andere als den aktuellen Tag könnte eine explizite Datumsanzeige sicherer sein.

**Abnahme:** Nutzer erkennt ohne Vorwissen, zu welchem Datum ein Eintrag gespeichert wird; Speichersemantik ist korrekt.

## B. Prüfen & Anpassen

### N04 – Kalenderaufgaben direkt abschließen / Kontextmenü

**Nutzerbeobachtung:** Kalenderblöcke mit Startzeit/Dauer lassen sich anklicken und bearbeiten oder in der Größe ändern; nicht direkt abschließen.  
**Wunsch:** Einfacher Tap öffnet ein kleines Menü mit z. B. **„Erledigt“, „Bearbeiten“, „Löschen“**. Der Wunsch ist ein **schneller Abschluss** im Kalender ohne umständlichen Bearbeitungsweg. Der vorhandene Drag-/Resize-Mechanismus soll erhalten bleiben.

**Offene Fragen / Prüfungen:**
- Ein Tap darf Drag, Long-Press, Resize und die Schlossregeln aus dem [Kalenderkonzept](calendar_concept.md) nicht stören.
- „Erledigt“ nur, wenn die Erfassungsart das erlaubt; sonst Eingabedialog für Ja/Nein, Zeit, Messwert etc.
- Bei Serien ist die **konkrete Instanz**, nicht die gesamte Serie, zu bearbeiten/abzuschließen; Löschen mit vorhandenen Papierkorb-/Historienregeln abgleichen.
- Soll das Kontextmenü auch aus „Ohne Uhrzeit“ und der Listen-/Monatsansicht erreichbar sein? Plausibel, noch nicht explizit entschieden.
- Nach Abschluss muss Projektion/wiederholungsabhängiger Folgetermin aktualisieren.

**Abnahmebeispiel:** Freie einmalige Aufgabe als 2-Stunden-Block antippen → Erledigen → übereinstimmender Status in Kalender/Tagesübersicht; Block weiterhin bei einer anderen freien Aufgabe per Long-Press verschieb- und resizebar.

### N06 – App insgesamt sehr langsam

**Nutzerbeobachtung:** Nach Installation einer neueren Version wirkt die ganze App plötzlich sehr träge. Das Laden von Aufgaben/Ansichten dauert **mehrere Sekunden**; Ja-/Nein-Antworten und andere Eingaben werden erst mit deutlicher Verzögerung übernommen; auch Tageswechsel brauchen lange. Nicht als einzelner Bildschirmfehler zu behandeln.

**Priorität: sehr hoch.** Vor größeren Features diagnostizieren. Nicht unbewiesen behaupten, die Kalenderfunktion oder die Datenbank sei Ursache.

**Diagnoseplan (für späteren Umsetzungschat):**
1. Installierte Buildnummer, Gerätezustand, Datenmenge und Auftreten seit dem Update erfassen; alte Version nur bei sicherer Datenbasis vergleichen, keine vorschnelle Deinstallation/Datenlöschung.
2. Messpunkte für Kalt-/Warmstart, Tageswechsel, Aufgabenlistenabruf, Klick bis visuelles Feedback, Datenbanktransaktion und Stream-Rebuilds.
3. Profiling auf echtem Android-Gerät im geeigneten Modus; SQL-Abfragen/Indizes, unnötige Recalculations, Scheduler, teure UI-Rebuilds, serielle Futures, Hintergrundvorgänge prüfen.
4. Unterschiede zwischen sofortigem Touch-Feedback und Persistierung feststellen: UI sollte nicht mehrere Sekunden unresponsiv wirken.
5. Ursache korrigieren, gleiche Nutzerpfade und Regressionstests vergleichen.

**Offene Fragen:** Sofort nach Update oder erst nach Tagen/mehr Daten? Nur manche Aufgaben oder überall? Nach Neustart kurz schneller? Debug-/Release-Build? Diese Fragen sind noch **nicht beantwortet** und dürfen nicht geraten werden.

**Abnahme:** Auf demselben Gerät und vergleichbaren Daten vor/nach Korrektur messbar bessere Reaktions- und Ladezeiten, keine verlorenen Antworten, korrekte Historie.

### N07 – Übernacht-Fasten-Bündel wird nicht ausgewertet

**Konkreter Testfall:**
- Tracking/Aufgabe „Letzte Mahlzeit gegessen“ mit Uhrzeit am Vortag.
- Tracking/Aufgabe „Erste Mahlzeit gegessen“ mit Uhrzeit am Folgetag.
- Gewünschtes Bündel „Fastendauer“ = Zeitpunkt erste Mahlzeit minus Zeitpunkt letzte Mahlzeit, **über Mitternacht**.
- Beide Werte nach Nutzerangabe **über mehrere Tage eingetragen**.
- **Ist:** kein eigenständiges Bündel in der Übersicht; beide Einzelaufgaben sind sichtbar. In beiden Einzelansichten existiert eine Bündelauswertung, die stets **„nur ein Teil eingetragen“** meldet; kein berechneter Wert.

**Wichtige Differenzierung:** Zwei möglicherweise getrennte Probleme:
1. **Berechnung/Zuordnung** findet zwei gespeicherte Uhrzeiten nicht im passenden Fastenintervall.
2. **Sichtbarkeit** eines angelegten Bündels als eigener Eintrag (ggf. ist das bestehende UI absichtlich anders). Zuerst Produktvertrag/Code prüfen.

**Beispiel einer erwarteten Rechnung:** Mo 19:30 → Di 11:30 = **16 Stunden**; Kalendertage und Zeitzone korrekt berücksichtigen, keine einfache negative Differenz aus Uhrzeiten.

**Diagnose-/Fachfragen:**
- Wie werden Bündel intern zugeordnet: gleiche Instanz/derselbe Tag, Auswertungstag, Offset -1/+1, IDs, Reihenfolge, Zeitstempel?
- Ist Bündel „Zeitdifferenz über zwei Tage“ überhaupt schon unterstützt, oder fehlen Regeln? Nicht automatisch als reiner Defekt klassifizieren, wenn gewünschter Fall nie implementiert wurde.
- Wie werden fehlende Partnerwerte, mehrere Mahlzeiten an einem Tag, Reihenfolge, identische Zeiten, DST/Zeitzonen, historische Änderungen behandelt?
- Was bedeutet „ein Teil eingetragen“ konkret; welche Seite fehlt nach internem Abgleich?
- Existiert ein Bündel, aber ist nur in Detail-/Analyseansichten sichtbar? Mit bestehender Phase-12/16/18-Bündellogik abgleichen.

**Abnahme:** Testdaten für mindestens mehrere aufeinanderfolgende Tage, davon ein Paar über Mitternacht, ergeben jeweils korrekt zugeordnete Fastendauer; fehlendes Paar klar bezeichnet; historische Änderung aktualisiert korrekte Bündelauswertung.

### N08 – Rolle und Reihenfolge beider Bündelwerte auswählen

**Nutzerbeobachtung:** Beim Erstellen eines Bündels ist nicht klar bzw. nicht unabhängig von der Ausgangsaufgabe auswählbar, welcher Teil die erste/zweite Uhrzeit darstellt.  
**Wunsch:** Egal ob man von „Letzte Mahlzeit“ oder „Erste Mahlzeit“ auf „Bündeln“ geht, man kann ausdrücklich **„Erster Zeitpunkt / Zweiter Zeitpunkt“** zuweisen oder Rollen vertauschen. Die Berechnungsreihenfolge bleibt sichtbar und eindeutig.

**Offene Fragen / Prüfungen:**
- Welche bestehenden Bundle-Typen sind richtungsabhängig und welche symmetrisch? Rollen dort nur anbieten, wo fachlich sinnvoll.
- Migrations-/Kompatibilitätsfrage für vorhandene Bündel.
- Verwechslung zwischen Rollenreihenfolge und **Tagesoffset** vermeiden; N07 erfordert ggf. beides.

**Abnahme:** Bündel von beliebigem der beiden Tracker starten, Anfangs-/Endrolle zuweisen, Ergebnis für denselben Zeitdatensatz identisch.

## C. Ideen & Erweiterungen

### N10 – „Projekte“ als Kategorien; neue Ebene „Projekt / Ziel“

**Kernidee:** Die bisherigen „Projekte“ dienen häufig als langlebige **Kategorien**, z. B. Ernährung, Gesundheit, Haushalt, Beruf. Ein echtes **Projekt/Ziel** ist ein zeitlich bzw. inhaltlich abgrenzbares, **abschließbares Vorhaben innerhalb einer Kategorie**. Keine sofortige Umbauentscheidung.

**Beispiele:**
- Kategorie **Ernährung** → Projekt/Ziel **„5 kg abnehmen“** → Habits/Tracking „Kalorien erfassen“, „Gewicht wiegen“ sowie einzelne Aufgabe „Donnerstag einkaufen“; Zielerreichung dokumentieren und beenden.
- Kategorie **Ernährung** → **„6 Wochen Keto“**: Start/Ende, Vorbereitung (Liste erstellen, einkaufen), danach Trackings (Makros/Gewicht) und wiederkehrende Aktivitäten; nach Ende abschließen.
- Nach einem Jahr dasselbe Keto-Vorhaben erneut nutzen, mit denselben Vorlagen/Aktivitäten, aber **alter Verlauf darf nicht verloren gehen**.

**Gewünschte Fähigkeiten:**
- Dauerhafte Kategorien, zu denen auch gewöhnliche Aufgaben/Habits ohne aktives Ziel gehören dürfen.
- Projekt/Ziel mit Name, Beschreibung, optional Start-/Enddatum, ggf. messbarem Zielwert und zugeordneten Aufgaben/Habits/Trackings.
- Fortschrittsübersicht; Status z. B. aktiv, Ziel erreicht, beendet/abgebrochen (Statusmodell offen).
- Projekt abschließen, ohne übergreifend genutzte Trackingdefinitionen oder historische Rohdaten zu löschen.
- Wiederverwenden bzw. erneut starten; unterscheiden zwischen **alte Durchführung wieder öffnen** und **neue Durchführung aus Vorlage beginnen**.

**Offene Grundentscheidungen:**
1. Was wird aus bestehenden Projekt-IDs/Zuordnungen/Historien/Archiven und Löschregeln, wenn sie künftig Kategorien heißen? Ist Umbenennung ausreichend oder echte neue Hierarchie?
2. Können Einträge gleichzeitig mehreren Projekten/Zielen dienen, ohne Duplikate? Wie aggregiert man Fortschritt?
3. Wann ist ein Ziel automatisch erreicht (Gewichtsveränderung) versus manuell abgeschlossen? Wie trennt man „erreicht“ von „beendet“?
4. Was geschieht bei Projektende mit terminierten, wiederkehrenden, gemeinsam genutzten Trackings und Kalenderaufgaben?
5. Wie funktionieren Pause, Neustart, Vorlage, Zeitraum, Archiv/Papierkorb und Datenschutz?
6. Welche Unterscheidung zu früherer Idee **Projektphasen** (#012) ist nötig? Begriffe und Datenmodell abstimmen, bevor Migration.

**Abgrenzung:** Es geht **nicht** um die bisherigen kleinen Unteraufgaben N10 des alten Testprotokolls; N10 ist die Nummer **dieses** neuen Durchlaufs. Siehe [erster Feedback-Durchlauf](mobile_test_feedback_2026_10.md), dort #012 und #006.

### N11 – Wiederholungstermin beim Abschließen flexibel wählen

**Praxisbeispiel:** Aufgabe „Bei Patient nach Reha-Plan fragen“ wird zunächst für **in 5 Tagen** geplant. Nach der Rücksprache entscheidet der Nutzer beim Abschließen: nächstes Mal **in 2 Wochen**. Bei jeder späteren Erledigung kann ein neuer Abstand gewählt werden.

**Neue optionale Wiederholungsart:** **„Nächsten Termin bei Erledigung festlegen“** – nicht automatisch immer derselbe X-Tage-Rhythmus. Bestehende feste und ereignisabhängige Wiederholungen bleiben erhalten.

**Gewünschter Flow:**
1. Bei Aufgabenerstellung Wiederholungsmodus „Nächsten Termin nach Erledigung auswählen“ aktivieren; ersten Fälligkeitstermin normal festlegen.
2. Bei Erledigung öffnet sich kleines, schnelles Pop-up.
3. Schnellauswahl, z. B. morgen, in 5 Tagen, in 1 Woche, in 2 Wochen, **oder konkretes Datum per Date Picker**.
4. Optional **Uhrzeit und geplante Dauer** (für Kalenderblock); auch reine tagesgebundene Aufgabe ohne Uhrzeit erlauben.
5. Aktuelle Instanz wird korrekt abgeschlossen, nächster Termin anhand Auswahl eingeplant; beim nächsten Abschluss wieder neu entscheiden.

**Offene Fragen / Prüfungen:**
- Was, wenn Pop-up abgebrochen wird: bleibt Abschluss gültig, bleibt Folgetermin ausstehend oder wird Abschluss zurückgenommen?
- Kann „keine weitere Wiederholung“ gewählt werden? Wann endet die Serie?
- Zählt die Auswahl ab Erledigungszeitpunkt oder vom Kalendertag? Wie mit Vergangenheit, Uhrzeiten, Sommerzeit umgehen?
- Wie wird der Vorgang transaktionssicher, ohne Doppelinstanzen und bei Offline-Nutzung gespeichert?
- Kann der nächste Termin nachträglich geändert werden und was passiert bei Undo/Korrektur des Abschlusses?
- Muss ein noch unbestimmter Folgetermin im Kalender-**+1-Zähler** gemäß [Kalenderkonzept V0.4](calendar_concept.md) auftauchen? Wahrscheinlich nur, wenn tatsächlich eine offene Abhängigkeit existiert; fachlich festlegen.
- Schloss-/Bearbeitungsregeln im Kalender: einzelne manuell gesetzte nächste Instanz versus Seriengebundenheit; nicht ohne Prüfung Drag zulassen.
- Datenschutz: „Patient“ nur als allgemeines Anwendungsbeispiel; keine patientenbezogenen Echtinformationen in Dokumentation oder Tests übernehmen.

**Abnahmebeispiel:** Erste offene Aufgabe wird erledigt → Popup „in 14 Tagen, 14:00, 30 Min.“ → genau eine nächste Fälligkeit zur richtigen Zeit; Historie der ersten bleibt korrekt. Später bei dieser Aufgabe „in 5 Tagen“ auswählbar.

## D. Übergreifende technische/UX-Leitplanken

- **Bestehende Domain verwenden:** Aufgaben- und Instanzstatus, Missed-Policies, Puffer, Carryover, Versionshistorie, Undo, Projekt-/Bündelzuordnung sowie Papierkorb dürfen nicht durch neue UI-Abkürzungen umgangen werden.
- **Kalender:** [Kalenderkonzept](calendar_concept.md) und [Phase-21-Kalender-Umsetzungsplan](../phase_21_test_improvements/calendar_implementation_plan.md) berücksichtigen. N04 ergänzt die vorhandenen Kalenderinteraktionen; N05 ist ein beobachtetes Anzeigeproblem. N11 kann künftig neue unbestimmte/feste Termine erzeugen.
- **Daten schützen:** Vor Migrationen/Fehlerdiagnose Backupfunktion und Wiederherstellung prüfen; keine Testdaten durch Neuinstallation oder Datenbank-Reset opfern.
- **Status sauber trennen:** „Nutzer berichtet“ ≠ „Ursache bestätigt“ ≠ „behoben“ ≠ „auf Gerät nachgetestet“.
- **Performance:** N06 priorisiert, weil mehrere Flows betroffen sind; nicht isolierte UI-Fixes als Beleg für gelöste Gesamtperformance ansehen.
- **Kleine UI-Punkte können gekoppelt werden:** N02 und N03 gemeinsam für beschreibungsbasierte Textdarstellung; N07–N09 als Bündel-/Zeitzonenpaket; N04/N05 als Kalender-Praxiskorrekturen.

## E. Vorgeschlagene Bearbeitungsreihenfolge (noch nicht beschlossen)

1. **Diagnose/Absicherung:** Build/Backup, N06 messen und gemeinsame Ursache finden; Funktionstest N07.
2. **Gezielte Fehlerkorrekturen:** N05; N07 mit fachlich sauberer Zeitraumzuordnung.
3. **Schnelle UX-Punkte:** N01, N02+N03, N09; mit Regressionstests.
4. **Kalender-Bedienung:** N04, angepasst an vorhandene Interaktionen und Erfassungsarten.
5. **Fachliche Konzeptphase:** N10 (Kategorien/Ziele), N11 (flexible Wiederholung), jeweils gesondert entscheiden und umsetzen.

Keine dieser Stufen ist durch dieses Dokument als sofort auszuführender Codex-Auftrag freigegeben.

## F. Für den nächsten Chat – unverbindliche Übergabe

> Lies zuerst dieses Testprotokoll N01–N11 und die Phase-21-Übersicht. Prüfe den **aktuellen** Code und Umsetzungsstand, ohne frühere Implementierungsaussagen ungeprüft zu übernehmen. Erstelle eine aktualisierte Fehler-/Aufwandsanalyse, markiere bestätigte Defekte und noch offene Produktentscheidungen getrennt, priorisiere unter Berücksichtigung der Performance und des Datenverlust-Risikos. Frage nur bei echten fachlichen Konflikten nach. Bevor du Datenmodell, Wiederholungsregeln oder Projekte änderst, lege eine migrations- und abnahmefähige Lösung vor. Keine automatisch angenommene Umsetzung aller Zukunftsideen.

## Querverweise

- [Phase 20 – Einstieg](README.md)
- [Erster Praxistest: #001–#020](mobile_test_feedback_2026_10.md)
- [Kalenderkonzept V0.4](calendar_concept.md)
- [Phase 21 – Planung und Umsetzungsstatus](../phase_21_test_improvements/README.md)
- [Phase 16 – Historisierung und Bearbeitung](../phase_16_history_editing/history_editing_plan.md)
- [Phase 18 – Projekte](../phase_18_projects/projects_plan.md)
- [Masterplan](../../00_overview/app_masterplan.md)

**Nicht durchgeführt:** vollständiger Code-Audit, Performanceprofiling, reproduzierende Gerätetests, App-Codeänderung, Migration, APK-Build. Dies ist Dokumentation der Beobachtungen und offenen Fragen.
