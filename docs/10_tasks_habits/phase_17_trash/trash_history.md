# Momentum - Papierkorb und Wiederherstellung: Verlauf

Stand: 4. Oktober 2026  
Status: Phase 17 abgeschlossen

## Zweck

Dieses Dokument trennt fachliche Planung und spätere Umsetzung. Maßgeblich
für die aktuellen Regeln ist der [Arbeitsplan](trash_plan.md).

## Planung vom 23. September bis 4. Oktober 2026

- P17-01 bis P17-18 sind im Arbeitsplan bestätigt: Papierkorb und
  Wiederherstellung, Pausieren/Fortsetzen, Auswertungsfolgen, Löschvorschau,
  automatische Bereinigung, Vormerkungen und freiwillige Eingaben.
- Phase 17 umfasst außerdem mehrere Bündel pro eigenständigem Tracking.
  Der vorgeschlagene Sonderfall einer Wiederherstellung als historisches
  Bündel bei belegten Quellen wurde zugunsten dieser einfachen Grundregel
  verworfen.
- Die Bedienung nutzt Zugänge für „Pausierte“ und „Papierkorb“ aus der
  bestehenden Übersicht. Konkrete Platzierung bleibt Implementierungsdetail.
- P17-18 ergänzt, dass wiederhergestellte Bündel alle vorhandenen Quelldaten
  ihrer gültigen Zeiträume verwenden, auch aus ihrer eigenen Papierkorbzeit.

## Technischer Abgleich am 4. Oktober 2026

- Der Nutzer hat den größeren gezielten Abgleich ausdrücklich beauftragt.
- Ausgangsschema 19 bestätigt; Tabellenreferenzen, Scheduler, Lebenszyklus-
  Hooks, relevante Repository-/Projektleser, Eingaben, Korrekturen/Undo,
  Vormerkungen, Mehrfachbündel und Auswertungswege geprüft.
- Technischen Vertrag, konkrete Änderungsstellen, Pakete 17a–17f und
  Abnahmematrix in den Arbeitsplan aufgenommen. Keine vollständige allgemeine
  Codeprüfung behaupten; untersucht wurden die für Phase 17 relevanten Wege.
- Technische Ableitungen: eigene Unterbrechungsintervalle, minimale
  Löschmarker statt versteckter gelöschter Aufgaben, Herkunft freiwilliger
  Pauseneingaben, fehlertolerante Bündelquellen und gemeinsame Zustandsprüfung.
- Nur Dokumentation geändert. Keine Migration ausgeführt, keine App-Daten
  verändert und keine Tests ausgeführt. Umsetzung und echte Verifikation
  erfolgen anhand der Arbeitspakete im nächsten Chat.

## Umsetzung und Abschluss am 4. Oktober 2026

- 17a: Schema 20 mit Lebenszyklusfeldern, Unterbrechungsintervallen,
  Löschmarkern und `planningOrigin` eingeführt. Die Bündelquellen-IDs bleiben
  historisch erhalten, sind aber keine sperrenden Aufgaben-Fremdschlüssel mehr.
- 17b: zentrale Vorschau-, Papierkorb-, Restore-, Purge-, Gesamtleeren-,
  Pause- und Fortsetzen-Operationen mit Revisionen und Schreibschutz ergänzt.
- 17c: Scheduler, Definitionsvormerkungen und Projektzuordnungen berücksichtigen
  ausgesparte Tage; vorhandene Pflichtinstanzen laufen in Pausen weiter und
  freiwillige Eingaben bleiben von Pflichtplanung getrennt.
- 17d: reguläre Leser und Analytics schließen Papierkorbobjekte aus;
  Zielzeiträume mit Unterbrechung sind neutral. Mehrere Bündel je Tracking sind
  erlaubt, fehlende Quellen werden über Marker erklärt statt als Null gerechnet.
- 17e: Aufgaben-/Bündelkarten nutzen konkrete Löschvorschauen. Die gemeinsame
  Übersicht bietet Pausierte, freiwillige Eingabe, Aufgaben- und Bündelzugang,
  Restore, endgültige Einzellöschung und bestätigtes vollständiges Leeren.
- 17f: echte Migration 19→20, DST-Tageswechsel, Fristbereinigung, Restore,
  fehlende Quellen, Zielneutralität und Mehrfachbündel automatisiert geprüft.

Prüfung:

- `dart run build_runner build`: erfolgreich, generierter Drift-Code aktuell.
- `flutter analyze`: `No issues found`.
- `flutter test --no-pub`: **129 Tests bestanden**.
- Gezielter gemeinsamer Lebenszyklus-/Migrationstest: **11 Tests bestanden**
  (Teilmenge des vollständigen Laufs).

Nicht vorgezogen wurden Projekt-Papierkorb/Unterprojekte aus Phase 18 und ein
Cloud-/Outbox-Konfliktmodell aus Phase 19. Ein manueller Gerätetest bleibt als
Praxiskontrolle empfohlen.
