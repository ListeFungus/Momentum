# Momentum – Testergebnisse und Verbesserungen: Verlauf

Stand: 16. Oktober 2026

Status: Kartenpaket umgesetzt und automatisiert geprüft; Gerätenachtest und weitere Konzepte offen

## 16. Oktober 2026 – Kartenpaket bestätigt und umgesetzt

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
