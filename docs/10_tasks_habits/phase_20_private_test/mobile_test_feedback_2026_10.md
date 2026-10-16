# Momentum – Praxistest: Beobachtungen und Ideen

Stand: 16. Oktober 2026  
Status: #001, #007 und #014 umgesetzt; 149 Tests grün, Android-Version 1.0.0+2 bereit, Gerätenachtest offen
Quelle: fortlaufender Nutzertest im Chat. Die ursprünglichen Einträge sind Beobachtungen und Vorschläge. Spätere Entscheidungen und Umsetzungsstände sind ausdrücklich gekennzeichnet.

## Arbeitsweise und Einordnung

Jeder Eintrag hat **zwei unabhängige Kategorien**:

- **Umsetzungsgruppe:** Quick Fix (kleiner Eingriff, vorläufig), Prüfen & Anpassen (Abhängigkeiten/Bestandsdaten prüfen), Ideen & Erweiterungen (größerer Ausbau).
- **Art:** Fehler, Design/UI, Verbesserung, neue Funktion, Prüfen. Mehrfachzuordnungen sind möglich.

Die Aufwandseinschätzung ist vorläufig, bis Code und Auswirkungen geprüft sind. Ursprüngliche Nutzerbeobachtung, Vorschlag, technische Prüfung und spätere Entscheidung nicht vermischen. **Keine Änderungen ohne anschließende Planung**. Die Nummern bleiben stabil; verwandte Punkte werden verlinkt statt gelöscht. Die private Testphase läuft inzwischen auf dem Android-Handy; der frühere Dokumentationsstand vom 8.10. bestätigte den Start noch nicht.

## Übersicht

| ID | Thema | Umsetzungsgruppe | Art |
|---|---|---|---|
| 001 | Datum durch Date Picker auswählen | Quick Fix | Design/UI, Verbesserung |
| 002 | Startdatum nachträglich ändern (eingeschränkt) | Prüfen & Anpassen | Verbesserung, Prüfen |
| 003 | Große Karten/zu viel Scrollen | Prüfen & Anpassen | Design/UI, Verbesserung |
| 004 | Routinen mit gemeinsamem Abschluss | Ideen & Erweiterungen | Neue Funktion |
| 005 | Trackingwerte gemeinsam diagrammatisch anzeigen | Ideen & Erweiterungen | Neue Funktion |
| 006 | Individuelle Projekt-Dashboards | Ideen & Erweiterungen | Neue Funktion, Design/UI |
| 007 | Aufgabenanzahl pro Tag sichtbar machen | Quick Fix (vorläufig) | Design/UI, Verbesserung |
| 008 | Warnung bei selbst gewähltem Tageslimit | Ideen & Erweiterungen | Neue Funktion, Verbesserung |
| 009 | Spielerisches Vergleichen/Priorisieren | Ideen & Erweiterungen | Neue Funktion |
| 010 | Unteraufgaben und Bearbeitungsstatus | Ideen & Erweiterungen | Neue Funktion, Verbesserung |
| 011 | Tracker und Habits in der Anzeige trennen | Ideen & Erweiterungen | Design/UI, Verbesserung, Neue Funktion |
| 012 | Zeitlich begrenzte Projektphasen | Ideen & Erweiterungen | Neue Funktion |
| 013 | Aufgabenart nachträglich wechseln | Prüfen & Anpassen | Verbesserung, Prüfen |
| 014 | Backup, Wiederherstellung und Export | Prüfen & Anpassen | Neue Funktion, Verbesserung |
| 015 | Karten einzeln einklappen | Prüfen & Anpassen | Design/UI, Verbesserung |
| 016 | Zeit-Tracking per Timer oder Hand | Ideen & Erweiterungen | Neue Funktion |
| 017 | Geschätzte Aufgabendauer | Ideen & Erweiterungen | Neue Funktion |
| 018 | Kalender-/Wochenübersicht mit Status | Ideen & Erweiterungen | Design/UI, Neue Funktion |
| 019 | Externe Kalenderanbindung | Ideen & Erweiterungen | Neue Funktion |
| 020 | Sortierbare Anzeigegruppen | Ideen & Erweiterungen | Design/UI, Neue Funktion |

**Zählung:** 20 Beobachtungen; 2 Quick Fixes, 5 Prüfen & Anpassen, 13 Ideen & Erweiterungen. #003 und #015 sind eng verbunden, aber aus Gründen der Nachvollziehbarkeit separat nummeriert. Bisher keine vom Nutzer als reproduzierter technischer Defekt bestätigten Fehler. Am 16. Oktober hat der Nutzer Datensicherung (#014) als erste Priorität benannt. Der [Phase-21-Arbeitsplan](../phase_21_test_improvements/test_improvements_plan.md) enthält die vorgeschlagene Reihenfolge und Aufteilung auf kleine Änderungen in diesem Chat sowie größere separate Konzept-/Umsetzungspakete; weitere Prioritäten sind noch nicht beschlossen.

## 1 – Quick Fixes

### #001 Date Picker in der Tagesnavigation
- **Ist:** Nur tageweise vor/zurück.
- **Wunsch:** Tippen auf angezeigtes Datum öffnet Date Picker; direkt zu beliebigem Tag springen.
- **Prüfung:** Bestehende Datumsnavigation/Anzeigezustände beachten.
- **Umsetzung am 16. Oktober:** Datum ist antippbar; Kalenderauswahl mit deutschen Texten. Nutzer bestätigt vorläufige Begrenzung der Auswahl und Tagespfeile auf heute/vergangene Tage wegen technischem Befund T20-01 unten.

### #007 Anzahl geplanter Aufgaben pro Tag anzeigen
- **Ist:** Bei Planung nicht unmittelbar erkennbar, wie viele Einträge an einem Tag anstehen.
- **Wunsch:** Heute und nächste Tage zeigen Anzahl geplanter Aufgaben/Habits, gegebenenfalls erledigt/offen.
- **Prüfung:** Was zählt (Aufgaben, Habits, Tracking, Überträge)? Aufwandseinstufung vorläufig. Anschluss #018.
- **Präzisierung durch Nutzer am 16. Oktober:** Statt geplanter Anzahl nun erledigte Aufgaben **und Habits** anzeigen, einschließlich Wiederholungen, ohne reine Tracker. Kompaktes Sieben-Tage-Balkendiagramm oberhalb der bestehenden Sammelauswertung „Einmalige Aufgaben“; Erledigungstag maßgeblich, Tage antippbar und vergangene Zeiträume auswählbar.
- **Umsetzung:** Diagramm und Tagesauswahl ergänzt. Bisherige Kennzahlen der einmaligen Aufgaben bleiben getrennt. Ältere Abschlüsse ohne bekanntes Erledigungsdatum werden nicht einem erfundenen Tag zugeordnet.

## 2 – Prüfen & Anpassen

### #002 Startdatum nach Erstellung bearbeiten
- **Ist:** Startdatum gesperrt; beim Gewichtstracking sind alte Messwerte nur umständlich ergänzbar.
- **Wunsch:** Startdatum früher oder später setzen, ohne neu anzulegen.
- **Vorerst begrenzter Umfang:** Nur Aufgaben/Habits mit reinem Tracking **ohne erzeugte Terminserien/Abstände und ohne Missed-Policies**; genauer nach Wirkungen definieren, nicht nur anhand der Bezeichnung.
- Bestehende Werte bewahren; drohenden Datenverlust ausdrücklich anzeigen/bestätigen. Bei terminbasierten Aufgaben bleibt Sperre zunächst bestehen.
- **Hintergrund:** Phase 16 P16-12 sperrt das ursprüngliche Startdatum bewusst zum Schutz der Historie. Änderungen der Datumsgrenzen und Auswertungen im Code prüfen. Keine automatische Löschung als bereits beschlossene Regel annehmen.

### #003 Karten zu groß
- **Ist:** Viele Aufgaben/Habits erzeugen sehr lange scrollbare Ansichten.
- **Wunsch:** Kompaktere, übersichtlichere Kartendarstellung, wichtige Aktionen weiterhin unmittelbar erreichbar.
- **Verknüpft:** #015 konkreter Ansatz; #011 kompakte Trackingeingabe; #020 Gruppen.

### #013 Aufgabenart Aufgabe ↔ Habit ändern
- **Ist:** Nach Erstellung gesperrt.
- **Wunsch:** Später konvertieren statt neu erstellen.
- **Prüfen:** Einfacher Fall ohne vorhandene Einträge versus Historie, Rhythmen, Missed-Policies und Auswertungen. Phase 16 P16-12 enthält bewusste Sperre; zunächst nur sichere Fälle freigeben, keine stillschweigende Datenumdeutung.

### #014 Datensicherung, Wiederherstellung und Export
- **Ist-Beobachtung:** Keine für den Nutzer erkennbare manuelle Sicherungs-/Exportfunktion.
- **Wunsch:** Vollständiges lokales Backup für Wiederherstellung (auch neues Gerät) und separater lesbarer Export, z. B. CSV/JSON.
- **Wichtig:** Lokale Drift-Datenbank und noch keine aktive Cloud-Synchronisierung. Datensicherung vor längerer produktiver Testnutzung besonders wichtig; technische Integrität, Anhänge, Formatversion und Restore-Verhalten prüfen. Export ist nicht dasselbe wie verlustfreies Backup.
- **Entscheidung/Umsetzung am 16. Oktober:** Vollständige Sicherungsdatei über Seitenleiste → Import & Export. Import ersetzt nach Prüfung und Bestätigung den gesamten Bestand. Keine Zusammenführung. Lesbarer Analyseexport vertagt. Formatversion 1 für Schema 22; Einzelheiten und Grenzen im [umgesetzten Stand der Phase 21](../phase_21_test_improvements/implemented_changes.md).

### T20-01 – Zukunftsnavigation kann aktuelle Daten vorzeitig verändern

- **Technischer Prüfbefund am 16. Oktober:** Die bisherige Tagesnavigation gibt
  das ausgewählte Datum an die Terminverarbeitung und fällige Definitionsänderungen
  weiter. Bei zukünftigen Tagen können deshalb noch offene Einträge vorzeitig
  abgeschlossen und Änderungen zu früh angewendet werden. Keine Behauptung,
  dass dies bei den vorhandenen Handydaten bereits passiert ist.
- **Bestätigte Zwischenlösung:** Tagesnavigation einschließlich Pfeilen und
  Datumsauswahl auf heute/vergangene Tage begrenzen. Im aktuellen Paket umgesetzt.
- **Offener Folgepunkt:** Sichere Zukunftsvorschau getrennt planen: Vorschau darf
  weder heutige Abschlüsse noch geplante Änderungen vorzeitig ausführen. Bezug #018.

### #015 Einklappbare Karten
- **Wunsch:** Eingeklappt nur Titel und ggf. Erledigungs-/Eingabefeld; aufgeklappt vollständige Informationen/Beschreibung.
- Pro Karte Pfeil zum Öffnen/Schließen.
- Option: mehrere Karten parallel offen **oder** beim Öffnen einer Karte vorherige schließen; Standardverhalten offen.
- **Verknüpft:** konkrete Umsetzungsidee zu #003, keine zweite unabhängige UI-Baustelle.

## 3 – Ideen & Erweiterungen

### #004 Routinen, die mehrere Aufgaben gemeinsam abschließen
- Morgenroutine aus z. B. Zähneputzen, Duschen, Sonnenlicht, Toilettengang.
- Ein gemeinsamer Abschluss hakt zugehörige Unteraufgaben ab; Semantik bei teilweiser Erledigung später klären.
- **Nicht verwechseln mit #020:** Dort geht es nur um Gruppierung/Sichtbarkeit.

### #005 Kombinierte Trackingdiagramme
- Beispiel: Kalorienaufnahme + Verbrauch als Bündel/Kaloriendifferenz und gemeinsam mit Gewichtsverlauf darstellen.
- Unterschiedliche Messgrößen und Skalen, Zeitauflösung, gemeinsame Darstellung und Aussagegrenzen klären; Korrelation nicht Kausalität.
- Bündel existieren bereits konzeptionell/teilweise technisch: nicht pauschal als neue Bündel-Funktion einplanen.

### #006 Eigene Projekt-Dashboards
- Beispiel Projekt Gesundheit: auswählbare Anzeigecontainer (Gewicht, Kaloriendifferenz, andere Werte/Diagramme).
- Container in einer Liste/Ansicht; im Bearbeitungsmodus umsortieren.
- Verbindung #005 und #012.

### #008 Selbst gesetztes Tageslimit
- Optional z. B. 10 Aufgaben/Tag; bei elfter Aufgabe Hinweis auf Belastung und Verschieben, **keine harte Sperre**.
- Später nicht nur Anzahl, sondern Aufwand berücksichtigen (#017). Motivierende statt strafende Hinweise.

### #009 Spielerische Priorisierung
- Bei vielen Aufgaben Paarvergleiche „Was ist wichtiger?“; Ergebnis sortierte Prioritätenliste.
- Minigame-Charakter. Nicht zwingend alle Paare: 15 Einträge ergeben 105 einzigartige Paarungen; effizientere Verfahren später prüfen.

### #010 Kleine Unteraufgaben und frei gestaltbarer Bearbeitungsstatus
- Beispiel „Termin vereinbaren“: Nummer suchen, Anfrage senden, Bestätigung abwarten.
- Eigene Teilschritte und Status wie „Warte auf Antwort“, „Muss etwas tun“.
- **Unterscheidung:** Hauptstatus der Aufgabe (offen/erledigt etc.) versus interner Bearbeitungs-/Wartestatus. Nicht automatisch alles als erledigt werten.

### #011 Tracking und Habits stärker trennen
- Zahlen-Tracker (Gewicht, kcal Aufnahme/Verbrauch, Protein, Kohlenhydrate, Fett) sollen als kompakte Zeile Titel + Werteingabe möglich sein.
- Habits eher Durchführung/Erledigung, Tracking eher Messreihe; Ziele bei Trackern nicht ausschließen.
- Offen, ob separate Aufgabenart nötig oder dedizierte UI/Ansicht ausreicht. Fehlender Messwert nicht unbedacht als „missed“ behandeln.

### #012 Zeitlich begrenzte Phasen in Projekten
- Beispiel Projekt Ernährung, Phase Keto von/bis Datum; relevante Fett-/Kohlenhydrat-/andere Tracker und später Vergleich.
- Phase beenden, ohne Historie zu verlieren; nicht einfach tägliches „Keto abhaken“.
- Noch offen: reine zeitliche Markierung oder aktive Ein-/Ausblendung/Steuerung von Trackings.

### #016 Zeit-Tracking
- Timer starten/pausieren/stoppen, Dauer manuell eingeben oder beides kombiniert.
- Mehrere Einträge am Tag/Addition, Zeitformat, Bearbeitung prüfen.

### #017 Zeitaufwand schätzen
- Bei Aufgabenplanung freiwillig erwartete Dauer hinterlegen; später geplante Tagesstunden/Budget und Vergleich zum tatsächlichen Tracking.
- Verbindung #008 und #016.

### #018 Kalender- oder Wochenübersicht
- Je Wochentag Anzahl geplant, erledigt und offen erkennen, z. B. Mi fünf, Do null.
- Perspektivisch Aufgaben in einer eigenen Kalenderansicht zwischen Tagen verschieben.
- #007 kann als kleinste Vorstufe unabhängig umgesetzt werden.

### #019 Externe Kalendersynchronisierung
- Perspektivisch Termine aus externen Kalendern neben Aufgaben anzeigen.
- Offen: nur Lesen oder bidirektionale Synchronisierung; langfristig, keine Phase-20-Pflicht.

### #020 Anzeigegruppen mit Reihenfolge
- Aufgaben/Habits in frei benannte Gruppen (z. B. Morgenroutine: kalt duschen, Sonnenlicht), Gruppenreihenfolge festlegen (Morgenroutine zuerst).
- Optional Gruppen ein-/ausklappen, Aufgaben bleiben eigenständig.
- **Unterschied #004:** bloße Sortierung/Anzeige versus gemeinsames Abhaken.

## Weiteres Vorgehen

1. Sammlung im laufenden Praxistest ergänzen, Originalnummern beibehalten.
2. Konzepte, Entscheidungen und Umsetzungsstand im [Phase-21-Arbeitsplan](../phase_21_test_improvements/test_improvements_plan.md) führen. Größere Themen im neuen Chat ausarbeiten, anschließend im bisherigen Chat umsetzen. #001/#007/#014 sind implementiert; Gerätenachtest und erste externe Sicherung stehen noch aus.
3. Vor Veränderungen an Datenmodell, Historie oder Planung konkrete Entscheidungs- und Migrationstests vereinbaren.
4. Größere Zukunftsideen nicht automatisch als Scope der Phase 20 verstehen.
5. Übergeordnete App-Struktur (Navigation/Monitoring und Quick Actions) steht separat in [App-weiten Konzeptideen](../../00_overview/app_concept_ideas_2026_10.md).
