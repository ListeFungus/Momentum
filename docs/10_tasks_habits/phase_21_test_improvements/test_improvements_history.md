# Momentum – Testergebnisse und Verbesserungen: Verlauf

Stand: 16. Oktober 2026

Status: Kartenpaket umgesetzt und automatisiert geprüft; Gerätenachtest und weitere Konzepte offen

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
