# Momentum – App-Masterplan

Stand: 16. Oktober 2026

Status: Lebendes Konzept- und Orientierungsdokument

## Zweck dieses Dokuments

Dieses Dokument ist die zentrale Übersicht für die langfristige Planung von
Momentum. Es hält Vision, Produktbereiche, Zusammenhänge, Architekturprinzipien,
Roadmap, Ideen, Entscheidungen und offene Fragen fest.

Andere Chats dürfen einzelne Themen vertiefen und umsetzen. Ihre Ergebnisse
werden anschließend hier zusammengefasst oder in einem verlinkten Detaildokument
festgehalten. Dieses Dokument ersetzt keine fachlichen Spezifikationen einzelner
Module, sondern verbindet sie zu einem konsistenten Gesamtbild.

## Dokumentationsregeln

- **Bestätigt** bedeutet: fachlich entschieden und als Grundlage verwendbar.
- **Arbeitshypothese** bedeutet: sinnvolle aktuelle Richtung, noch änderbar.
- **Idee** bedeutet: erwägenswert, aber weder priorisiert noch beschlossen.
- **Offen** bedeutet: vor Umsetzung des betroffenen Bereichs zu entscheiden.
- Neue Ideen kommen zuerst in den Ideenpool oder zu den offenen Fragen.
- Jede wichtige Entscheidung erhält einen Eintrag im Entscheidungsprotokoll.
- Detailregeln werden nicht doppelt gepflegt, sondern in eigenen Dokumenten
  beschrieben und von hier aus verlinkt.
- Kein Teilprojekt soll eine offene Produktfrage stillschweigend durch eine
  technische Implementierung entscheiden.

## Produktvision

Momentum soll Menschen dabei helfen, ihren Alltag, ihre Gewohnheiten, ihr
Training und langfristig auch ihre körperliche Leistungsfähigkeit sowie
Rehabilitation strukturiert zu steuern.

Die App entwickelt sich dabei in Stufen:

1. Alltag und Verhalten verlässlich organisieren.
2. Training detailliert erfassen und verstehen.
3. Diagnostische Daten sinnvoll einordnen.
4. Aus den verbundenen Daten hilfreiche Vorschläge ableiten.
5. Zusammenarbeit zwischen Trainern und Klienten ermöglichen.
6. Langfristig Prävention, Rehabilitation und Therapie unterstützen.

Der Kern ist nicht möglichst viel Tracking, sondern ein verständlicher Kreislauf:

> Planen → Handeln → Erfassen → Analysieren → Anpassen

## Produktversprechen

Momentum bringt Ordnung in unterschiedliche Lebens- und Leistungsbereiche,
ohne den Nutzer mit Daten oder Entscheidungen zu überfordern. Die App soll
ruhig, nachvollziehbar und vertrauenswürdig wirken und aus den erfassten Daten
schrittweise echten Nutzen erzeugen.

## Zielgruppen

### Primär zum Start

- Einzelpersonen, die Aufgaben und Gewohnheiten strukturieren möchten
- sportlich aktive Menschen, die Training detailliert dokumentieren möchten

### Spätere Zielgruppen

- ambitionierte Athleten
- Personal Trainer und Coaches
- Trainer mit mehreren Klienten
- Physiotherapeuten und Reha-Fachkräfte
- Klienten in Prävention, Reha oder Return-to-Sport

## Leitprinzipien

### Produkt

1. **Erst erfassen, dann beraten:** Vorschläge benötigen eine belastbare
   Datengrundlage und dürfen fehlende Daten nicht als Gewissheit behandeln.
2. **Ein System, mehrere Module:** Aufgaben, Habits, Workouts und Diagnostik sind
   eigenständige Bereiche, können aber bewusst miteinander verbunden werden.
3. **Nutzerkontrolle:** Automatische Vorschläge bleiben erklärbar, prüfbar und
   übersteuerbar.
4. **Progressive Komplexität:** Einsteiger sehen nur das Nötige; Detailtiefe wird
   bei Bedarf zugänglich.
5. **Rohdaten bleiben erhalten:** Neue Auswertungen sollen historische Daten neu
   interpretieren können, ohne sie zu verfälschen.
6. **Keine medizinische Scheinsicherheit:** Therapie- und Reha-Funktionen werden
   klar von allgemeinem Fitness-Coaching abgegrenzt.

### Technik

1. Jedes Fachmodul besitzt klar abgegrenzte Daten-, Logik- und UI-Schichten.
2. Module greifen nicht direkt auf interne Tabellen oder UI-Komponenten anderer
   Module zu.
3. Verbindungen laufen über stabile IDs, definierte Schnittstellen und
   gemeinsame Kernbegriffe.
4. Analyse- und Empfehlungssysteme lesen normalisierte Daten, verändern aber
   keine historischen Rohdaten.
5. Fachregeln liegen zentral in der Domain-Logik und nicht verteilt in Screens.
6. Synchronisierung, Mehrbenutzerfähigkeit und Datenschutz werden im Datenmodell
   früh mitgedacht, auch wenn sie erst später umgesetzt werden.
7. Lokale Verarbeitung und spätere Cloud-Synchronisierung sind idempotent und
   schreiben nur tatsächliche Zustandsänderungen. Wiederholte Abgleiche,
   Lesevorgänge und Ansichtswechsel erzeugen keine unnötigen Cloud-Schreibkosten.

## Produktbereiche

| Bereich | Zweck | Kurzfristige Rolle | Langfristige Rolle |
|---|---|---|---|
| Aufgaben & Habits | Alltag, Verhalten und Routinen organisieren | erstes Kernmodul | verbindet Routinen mit Training, Diagnostik und Reha |
| Workout Tracker | Training planen und detailliert protokollieren | nächstes großes Modul | Grundlage für Belastungsanalyse und Empfehlungen |
| Diagnostik | Tests, Fragebögen und Messungen erfassen | später | objektive und subjektive Leistungs-/Erholungsdaten |
| Analyse | Daten verständlich auswerten | schrittweise je Modul | modulübergreifende Trends, Belastung und Zusammenhänge |
| Trainer | Vorschläge und Plananpassungen erzeugen | zunächst nicht aktiv | erklärbares Assistenzsystem |
| Therapie / Reha | Verletzungen, Prehab und Reha begleiten | Zukunftsmodul | fachlich kontrollierte Verläufe und Maßnahmen |
| Coaching | Trainer-Klienten-Zusammenarbeit | Zukunftsmodul | Planung, Kommunikation und Datenauswertung |

## 1. Aufgaben und Habits

Status: **In Entwicklung**

### Zielbild

Der Bereich bringt Ruhe und Ordnung in den Alltag. Aufgaben und Habits sollen
leicht planbar, eindeutig beantwortbar und später sinnvoll auswertbar sein.

### Bereits angelegte Themen

- einmalige und wiederkehrende Aufgaben
- unterschiedliche Erfassungsmodi
- Rhythmen und Fälligkeiten
- Verhalten bei verpassten Aufgaben
- Ziele und spätere Auswertungen
- erweiterte Erfassungsarten vor dem ersten größeren Release:
  Zahleneingaben, Dauer, Uhrzeit und später Skalen
- Projekte zur Strukturierung
- historische Korrekturen und Papierkorb
- kontrollierte Projektlöschung: nur das Projekt oder Projekt samt zugeordneten
  Aufgaben und Habits

### Verbindung zu anderen Modulen

- Ein geplantes Workout kann als Habit oder Aufgabe erscheinen.
- Eine Reha-Übung kann mit einem Habit verknüpft werden.
- Diagnostik- oder Check-in-Termine können geplant werden.
- Eine Verknüpfung darf keine doppelten, widersprüchlichen Wahrheiten erzeugen:
  Das Workout speichert die Trainingsleistung; die Aufgabe speichert Planung und
  Erledigungsstatus.

### Detaildokumente

- [Planung und offene Themen der Aufgabenstruktur](../10_tasks_habits/task_structure_plan.md)
- [Fachliche Regelmatrix für Aufgaben](../10_tasks_habits/task_rule_matrix.md)
- [Release-Ideen vor der ersten Aufgaben-/Habit-Version](../10_tasks_habits/release_ideas.md)
- [Phase 11: Vollständige Auswertung](../10_tasks_habits/phase_11_complete_analytics/README.md)
- [Phase 18: Projekte](../10_tasks_habits/phase_18_projects/README.md)
- [Phase 20: Private Nutzung/Test](../10_tasks_habits/phase_20_private_test/README.md)
- [Phase 21: Testergebnisse ausarbeiten und umsetzen](../10_tasks_habits/phase_21_test_improvements/README.md)
- [Phase 22: Store-Release vorbereiten](../10_tasks_habits/phase_22_store_release/README.md)

### Projektlöschung

Status: **Fachlich geplant in Phase 18; Umsetzung ausstehend**

Beim Löschen eines Projekts soll der Nutzer wählen können, ob nur das Projekt
entfernt wird und seine Aufgaben projektlos erhalten bleiben oder ob Projekt,
Aufgaben, Habits und direkt zugeordnete Bündel gemeinsam in den Papierkorb
kommen. Sieben Tage Aufbewahrung, gemeinsame Wiederherstellung mit Schutz
späterer Änderungen und unbenannte historische Projektverweise sind festgelegt.
Archivierung bleibt eine separate, reversible Aktion ohne Planungseingriff.
Der [Phase-18-Plan](../10_tasks_habits/phase_18_projects/projects_plan.md)
enthält die verbindlichen Regeln und Umsetzungspakete; die UI ist noch nicht
entsprechend umgesetzt. Unterprojekte gehören nicht zum Startumfang.

## 2. Workout Tracker

Status: **Konzeptidee; noch nicht fachlich spezifiziert**

### Erste Ausbaustufe: detaillierter Tracker

Der Startpunkt ist eine präzise, flexible Trainingserfassung – noch kein
automatischer Trainer.

Mögliche Bestandteile:

- Trainingspläne, Einheiten und freie Workouts
- Übungen mit Varianten und eigener Übungsbibliothek
- Sätze, Wiederholungen, Gewicht, Distanz, Zeit und Pausen
- RPE/RIR sowie subjektive Schwierigkeit
- Tempo, Bewegungsumfang und ein-/beidseitige Ausführung
- Aufwärm-, Haupt- und Ergänzungsübungen
- Notizen, Schmerzen, Technikgefühl und Tagesform
- Supersätze, Zirkel und komplexere Trainingsblöcke
- Ausdauer-, Kraft-, Sprung-, Sprint- und Mobility-Training

### Spätere Analyse

- Volumen, Intensität, Dichte und Häufigkeit
- Belastung einzelner Muskeln, Muskelgruppen oder Bewegungssysteme
- Belastung nach Bewegungsmuster und Gelenk
- interne und externe Trainingslast
- akute und längerfristige Belastungstrends
- persönliche Bestleistungen und Leistungsentwicklung
- Ermüdungs- und Erholungsindikatoren

### Spätere Vorschläge

Aus Belastung, Trainingsziel, Verlauf, Diagnostik und subjektivem Feedback kann
das System mögliche nächste Einheiten oder Anpassungen vorschlagen. Vorher muss
definiert werden, wie sicher, erklärbar und konservativ diese Vorschläge sind.

## 3. Diagnostik

Status: **Ideenpool**

### Mögliche Diagnosearten

- Bildschirm-Tapping und Reaktionsaufgaben
- ZNS-/Readiness-nahe Tests
- standardisierte Fragebögen
- subjektive Check-ins zu Schlaf, Stress, Erholung, Motivation und Schmerz
- Sprungtests per Video mit einer MyJump-ähnlichen Auswertung
- Leistungs- und Beweglichkeitstests
- wiederholbare Testbatterien mit Vergleichswerten

### Grundanforderungen

- Testprotokoll und Bedingungen werden mitgespeichert.
- Rohmessung und daraus berechnete Kennzahl bleiben unterscheidbar.
- Messqualität, Fehlerquellen und Vergleichbarkeit werden sichtbar gemacht.
- Tests werden nicht ohne ausreichende Grundlage medizinisch interpretiert.
- Geräte-, Kamera- und manuelle Eingaben erhalten eine nachvollziehbare Herkunft.

### Offene Kernfrage

Der Begriff „ZNS-Analyse“ muss vor einer Umsetzung fachlich präzisiert werden:
Welche Messung wird durchgeführt, welche Aussage ist wissenschaftlich tragfähig
und welche Aussage darf die App ausdrücklich nicht daraus ableiten?

## 4. Analyseplattform

Status: **Querschnittsthema**

Analyse ist kein einzelner Screen und sollte nicht mehrfach pro Modul neu gebaut
werden. Jedes Modul liefert fachlich saubere Daten an eine gemeinsame
Auswertungsschicht.

### Analyseebenen

1. **Deskriptiv:** Was wurde geplant und durchgeführt?
2. **Verlauf:** Was verändert sich über die Zeit?
3. **Zusammenhang:** Welche Werte treten gemeinsam auf?
4. **Hinweis:** Wo gibt es auffällige Abweichungen oder Datenlücken?
5. **Vorschlag:** Welche nächste Handlung könnte sinnvoll sein?

Korrelationen werden nicht automatisch als Ursachen dargestellt. Jede Kennzahl
benötigt eine fachliche Definition, Datenvoraussetzungen und Hinweise zur
Aussagekraft.

## 5. Digitaler Trainer

Status: **Langfristige Vision**

Der Trainer kann aus Zielsetzung, Trainingshistorie, aktueller Belastung,
Diagnostik und Nutzerfeedback Vorschläge erzeugen.

Mögliche Fähigkeiten:

- nächste Einheit oder Wochenstruktur vorschlagen
- Belastung erhöhen, halten oder reduzieren
- Übungen anhand verfügbarer Ausstattung ersetzen
- Erholungstage oder Diagnostik-Checks empfehlen
- Abweichungen vom Plan verständlich erklären
- nach Nutzerentscheidung einen Plan anpassen

Der Trainer soll zunächst assistieren und nicht autonom weitreichende
Entscheidungen treffen. Jeder Vorschlag zeigt seine wichtigsten Gründe und die
zugrunde liegenden Daten.

## 6. Therapie, Reha und Prehab

Status: **Zukunftsvision mit erhöhten fachlichen und rechtlichen Anforderungen**

Mögliche Bestandteile:

- Verletzungs- und Beschwerdeverlauf
- Schmerz, Funktion und Belastbarkeit
- Reha-Phasen und Kriterien für Progression
- Prehab-Routinen
- Übungsprogramme und Adhärenz
- Return-to-Sport-Tests
- Zusammenarbeit mit behandelnden Fachpersonen

Vor der Entwicklung sind medizinische Verantwortung, Haftung, Datenschutz,
regionale regulatorische Anforderungen und fachliche Validierung gesondert zu
klären. Dieses Modul darf nicht lediglich als Erweiterung des Workout Trackers
behandelt werden.

## 7. Trainer- und Klientenbereich

Status: **Zukunftsmodul**

### Mögliche Fähigkeiten

- Trainerkonto und Klientenbeziehungen
- Rollen und fein abgestufte Zugriffsrechte
- Trainingspläne erstellen, zuweisen und versionieren
- Aufgaben, Habits oder Diagnostik-Checks zuweisen
- Durchführung und Daten auswerten
- Kommentare, Feedback und Kommunikation
- Planänderungen mit Verlauf und Begründung
- Benachrichtigungen und offene Rückfragen
- Einwilligung zur Freigabe sensibler Daten

### Zentrale Architekturfolge

Daten dürfen nicht pauschal „dem Trainer“ gehören. Nutzer, Urheber, betreute
Person, Freigaben und Bearbeitungsrechte müssen getrennt modelliert werden.

## Modulübergreifende Verbindungen

| Ausgang | Verbindung | Ziel | Verantwortliche Datenquelle |
|---|---|---|---|
| Habit/Aufgabe | „Workout durchführen“ | Workout | Workout enthält Leistungsdaten; Aufgabe den Plan-/Erledigungsstatus |
| Habit/Aufgabe | „Check-in durchführen“ | Diagnostik | Diagnostik enthält Testergebnis |
| Workout | erzeugt Belastungsdaten | Analyse | Workout bleibt Quelle der Trainingsrohdaten |
| Diagnostik | erzeugt Mess-/Fragebogendaten | Analyse | Diagnostik bleibt Quelle der Rohmessung |
| Analyse | begründet Empfehlung | Trainer | Empfehlung speichert verwendete Datenbasis/Version |
| Reha-Plan | plant Übungen | Workout/Habits | Reha definiert Zweck und Freigabe; Durchführung wird im Zielmodul erfasst |
| Coach | weist Plan zu | Klient | Zuweisung und Planversion bleiben nachvollziehbar |

## Vorgeschlagene Code- und Modulstruktur

Status: **Arbeitshypothese**

Die bestehende Feature-Struktur wird beibehalten und schrittweise klarer
geschichtet:

```text
lib/
  app/                         # Navigation, App-Shell, globale Konfiguration
  core/                        # rein technische, fachneutrale Bausteine
    database/
    sync/
    auth/
    privacy/
    design_system/
  features/
    tasks_habits/
      domain/                  # Entitäten, Regeln, Anwendungsfälle
      data/                    # Tabellen, DTOs, Repository-Implementierungen
      presentation/            # Screens, State, Widgets
    workouts/
      domain/
      data/
      presentation/
    diagnostics/
      domain/
      data/
      presentation/
    analytics/
      domain/
      data/
      presentation/
    coaching/
    trainer_assistant/
    rehab/
  shared/                      # wenige bewusst geteilte Fachkonzepte
```

### Abgrenzungsregeln

- `core` enthält keine Workout-, Aufgaben- oder Reha-Fachlogik.
- Feature-interne Modelle werden nicht aus Bequemlichkeit global geteilt.
- Gemeinsame Konzepte wie Nutzer-ID, Zeitbereich, Einheitensystem oder
  Datenherkunft bekommen kleine, stabile Verträge.
- UI-Widgets mit Fachverhalten bleiben im jeweiligen Feature.
- Datenbanktabellen dürfen technisch gemeinsam registriert sein; Zugriff und
  Interpretation bleiben beim verantwortlichen Feature.
- Verknüpfungen verwenden eigene Link-Entitäten statt Fremdtabellen direkt zu
  manipulieren.
- Empfehlungen werden als eigene, versionierte Ergebnisse gespeichert und sind
  keine stillen Änderungen historischer Pläne.

## Gemeinsame Datenkonzepte, die früh mitgedacht werden sollten

Status: **Arbeitshypothese**

- stabile UUIDs statt nur lokaler fortlaufender IDs
- Erstellungs-, Änderungs- und gegebenenfalls Löschzeitpunkt
- Zeitzone und lokale Bedeutung von Kalendertagen
- Quelle/Herkunft: Nutzer, Trainer, Automatik, Import oder Gerät
- Eigentümer, betroffene Person und Zugriffsrechte
- Versionierung fachlich relevanter Definitionen und Pläne
- Einheiten mit eindeutigem Einheitensystem
- Rohwert, berechneter Wert und Algorithmusversion
- Soft Delete beziehungsweise Archivierung, wo Verlauf wichtig ist
- Sync-Status und Konfliktinformationen als spätere Erweiterungsmöglichkeit

Diese Punkte sind Leitplanken, keine Aufforderung, bereits jetzt ein maximales
generisches Datenmodell zu bauen.

## UX- und Designsprache

### Gesamtgefühl

Momentum soll kompetent, ruhig und aufgeräumt wirken. Die App darf leistungsnah
sein, soll aber nicht aggressiv oder überladen erscheinen. Informationen werden
hierarchisch gezeigt: zuerst die nächste sinnvolle Handlung, dann Details.

### Aufgaben und Habits

Status: **Bestätigte Richtung**

- clean, übersichtlich und entspannt
- eine wohlfühlende, ordnende Wirkung
- wenig visuelles Rauschen
- klare Prioritäten und verständliche Rückstände
- unterstützende statt strafende Sprache

### Workout

Status: **Bestätigte Richtung**

- dunkles Lila als prägende Bereichsfarbe
- fokussierter und leistungsorientierter als Aufgaben/Habits
- gute Lesbarkeit während des Trainings
- schnelle Eingaben mit wenig Tipparbeit

### Übergreifende Designfrage

Die Module dürfen unterschiedliche Stimmungen besitzen, müssen aber als eine
App erkennbar bleiben. Dafür braucht es ein gemeinsames Designsystem mit
bereichsspezifischen Akzentfarben statt voneinander unabhängiger Themes.

## Datenschutz, Sicherheit und Vertrauen

- lokale Nutzung soll möglichst früh ohne Cloud-Zwang funktionieren
- Cloud-Synchronisierung benötigt transparente Einwilligung und Löschkonzepte
- Gesundheits- und Diagnostikdaten erhalten besondere Schutzmaßnahmen
- Trainer sehen nur ausdrücklich freigegebene Daten
- Exporte und dauerhafte Löschung werden vorgesehen
- automatische Analysen dokumentieren Datenbasis und Algorithmusversion
- sensible Benachrichtigungen zeigen auf dem Sperrbildschirm keine unnötigen
  Gesundheitsdetails

## Grobe Produkt-Roadmap

Die Phasen beschreiben Abhängigkeiten, noch keine Termine.

| Phase | Schwerpunkt | Ergebnis | Status |
|---:|---|---|---|
| 0 | Fundament | Modulgrenzen, Navigation, Datenprinzipien, Designsystem | teilweise vorhanden |
| 1 | Aufgaben & Habits bis erster Release | verlässliches Planen, Erfassen, vollständiges Auswerten, Projekte, Sync-Vorbereitung, private Testphase und Store-Release-Vorbereitung | in Entwicklung |
| 2 | Workout-Tracking | detaillierte manuelle Trainingserfassung | geplant |
| 3 | Workout-Analyse | verständliche Belastungs- und Fortschrittsauswertung | geplant |
| 4 | Diagnostik-Basis | Fragebögen, Check-ins und einfache Tests | geplant |
| 5 | Erweiterte Diagnostik | Tapping, Video-/Sprunganalyse, Testbatterien | Idee |
| 6 | Modulübergreifende Analyse | Training, Habits und Diagnostik gemeinsam betrachten | Idee |
| 7 | Coaching | Trainer-Klienten-Pläne, Freigaben und Kommunikation | Idee |
| 8 | Trainer-Assistent | erklärbare datenbasierte Vorschläge | Vision |
| 9 | Reha / Prehab | fachlich validierte Therapieunterstützung | Vision |

## Unmittelbare Konzept-To-dos

- [ ] Aktuelle Aufgaben-/Habit-Implementierung gegen die bestehenden
      Detaildokumente fertigstellen
- [ ] vollständige Auswertung vor Zielbewertung abschließen
- [ ] Projekte als release-relevante Ordnungs- und Auswertungsebene abschließen
- [ ] private Nutzungs- und Testphase für die erste App-Version vorbereiten
- [ ] Paywall-/Monetarisierungsideen für den ersten Release einordnen
- [ ] Begriffe `Aufgabe`, `Habit`, `Eintrag`, `Instanz`, `Workout`, `Plan` und
      `Session` appweit eindeutig definieren
- [ ] Minimalumfang der ersten Workout-Tracker-Version festlegen
- [ ] Übungs-, Workout-, Satz- und Messwertmodell fachlich entwerfen
- [ ] entscheiden, welche Trainingsarten Version 1 unterstützt
- [ ] Verbindung zwischen Aufgabe/Habit und Workout als Datenfluss spezifizieren
- [ ] gemeinsames Designsystem und Bereichsfarben festhalten
- [ ] Analyseprinzipien und Mindestanforderungen an Datenqualität definieren
- [ ] Rollen- und Eigentumsmodell vor jeder Cloud-/Coaching-Umsetzung entwerfen

## Offene strategische Fragen

### Produktfokus

1. Soll Momentum langfristig eine breite Self-Management-App oder primär eine
   Trainings- und Gesundheitsplattform mit integriertem Aufgabenmodul sein?
2. Welche eine Zielgruppe soll die erste Workout-Version hervorragend bedienen?
3. Welche Funktionen bleiben kostenlos, welche könnten später Teil eines
   Bezahlmodells sein?

### Workout

1. Startet Version 1 nur mit Krafttraining oder bereits multidisziplinär?
2. Wie frei dürfen Nutzer eigene Übungen und Messfelder definieren?
3. Wie detailliert wird Muskelbelastung modelliert, ohne falsche Präzision zu
   erzeugen?
4. Werden Trainingspläne vor oder nach dem freien Workout-Logging priorisiert?

### Diagnostik

1. Welche Tests besitzen ausreichenden Nutzen und reproduzierbare Bedingungen?
2. Soll die Videoanalyse vollständig auf dem Gerät erfolgen?
3. Welche Fragebögen dürfen lizenzfrei eingesetzt werden?
4. Wie werden Normwerte, persönliche Baselines und Messunsicherheit dargestellt?

### Coaching und Gesundheit

1. Wird Kommunikation ein eigener Chat oder kontextbezogen an Plänen/Einheiten?
2. Welche professionellen Rollen werden unterstützt?
3. Welche Datenfreigaben gelten pro Klient, Modul und Zeitraum?
4. In welchen Ländern und unter welchen regulatorischen Rahmenbedingungen soll
   ein Therapieangebot erscheinen?

## Ideenparkplatz

Noch nicht priorisiert:

- Wearables und Health-Plattformen
- automatische Satz-/Wiederholungserkennung
- Übungsvideos und Technikfeedback
- Kalenderintegration
- Templates und öffentliche Planbibliothek
- Teams, Gruppen und Vereine
- Challenges oder soziale Funktionen
- Export für Arzt, Physio oder Trainer
- Offline-first Synchronisierung über mehrere Geräte
- KI-gestützte Zusammenfassungen längerer Trainingszeiträume

## Entscheidungsprotokoll

| Datum | ID | Status | Entscheidung | Auswirkung |
|---|---|---|---|---|
| 2026-07-05 | M-001 | bestätigt | Momentum wird modular aufgebaut; Aufgaben/Habits, Workout, Diagnostik, Coaching und Reha bleiben fachlich abgegrenzt. | Neue Features erhalten eigene klare Verantwortungsbereiche. |
| 2026-07-05 | M-002 | bestätigt | Aufgaben/Habits sollen clean, ruhig, aufgeräumt und wohlfühlend wirken. | Leitlinie für UX und Designsystem. |
| 2026-07-05 | M-003 | bestätigt | Der Workout-Bereich erhält eine dunkellila geprägte Designsprache. | Bereichsakzent im gemeinsamen Designsystem. |
| 2026-07-05 | M-004 | bestätigt | Der Workout-Bereich startet als detaillierter Tracker; automatische Trainingsvorschläge folgen später. | Erfassung und Datenqualität werden vor Empfehlungen priorisiert. |
| 2026-07-05 | M-005 | bestätigt | Workouts können mit Aufgaben und Habits verbunden werden. | Es wird eine explizite, widerspruchsfreie Verknüpfung benötigt. |
| 2026-07-05 | M-006 | Arbeitshypothese | Analyse wird als gemeinsame Plattform mit fachlich getrennten Datenquellen aufgebaut. | Verhindert parallele, widersprüchliche Auswertungslogik. |
| 2026-07-06 | M-007 | bestätigt | Die Projektlöschung bietet die Wahl zwischen `nur Projekt` und `Projekt mit Aufgaben/Habits`; die Fachlogik bleibt bis zur Klärung der Folgewirkungen deaktiviert. | Die UI darf keine implizite Entscheidung über Papierkorb, Historie oder Unterprojekte treffen. |
| 2026-07-07 | M-008 | bestätigt | Zeitabhängige lokale Verarbeitung und spätere Firebase-Synchronisierung werden idempotent und delta-basiert entworfen. | Wiederholte Prüfungen erzeugen keine Duplikate oder unnötigen Cloud-Schreibvorgänge; notwendige Rohdaten bleiben erhalten. |
| 2026-07-08 | M-009 | bestätigt | Vollständige Aufgabendefinitionen werden als verkettete Snapshots versioniert; Instanzen verweisen auf die damals gültige Version. | Historische Texte, Projekt-ID und Fachregeln bleiben trotz Änderungen nachvollziehbar und können weiterhin gemeinsam ausgewertet werden. |
| 2026-07-21 | M-010 | Arbeitshypothese | Der Aufgaben-/Habit-Plan wird erst fachlich abgeschlossen; private Testphase und Store-Release-Vorbereitung folgen danach. | Release-Themen unterbrechen die Fachphasen nicht mehr. Die neue Reihenfolge setzt vollständige Auswertung vor Zielbewertung; danach folgen erweiterte Eingaben, Wert-Auswertung, Projekte, Sync-Vorbereitung und Release-Vorbereitung. |
| 2026-07-21 | M-011 | Arbeitshypothese | Projekte werden für den ersten Release als eigene Aufgaben-/Habit-Phase ausgearbeitet. | Projektzuordnung, Projektansicht, Projektauswertung und Löschregeln werden vor dem Release geklärt. |

## Übergabeformat für andere Chats

Wenn ein anderer Chat ein Teilthema bearbeitet, sollte sein Ergebnis mindestens
Folgendes liefern:

1. bearbeiteter Bereich und Ziel
2. bestätigte Entscheidungen
3. verworfene Alternativen mit kurzem Grund
4. neue offene Fragen
5. Auswirkungen auf andere Module oder Datenmodelle
6. angelegte oder geänderte Dateien
7. erforderliche Aktualisierung dieses Masterplans

So bleibt Detailarbeit anschlussfähig, ohne den großen Zusammenhang zu verlieren.


## Neuer Ideenstand aus der privaten Testphase (13. Oktober 2026)

Die übergreifenden Ideen **Navigation mit Tagesübersicht und Monitoring** (#A01) sowie **Quick Actions / Quick Task** (#A02) sind als noch unbeschlossene Vorschläge im [separaten Konzeptideen-Dokument](app_concept_ideas_2026_10.md) gesammelt. Sie erweitern die Gesamtvision, ohne den Phase-20-Umfang zu ändern. Die [20 konkreten Beobachtungen aus dem Android-Praxistest](../10_tasks_habits/phase_20_private_test/mobile_test_feedback_2026_10.md) bleiben im zugehörigen Testordner.

Seit dem 16. Oktober führt [Phase 21](../10_tasks_habits/phase_21_test_improvements/test_improvements_plan.md) die Ausarbeitung, Prioritäten und den Umsetzungsstand dieser Rückmeldungen. Die Store-Vorbereitung ist dadurch Phase 22.
