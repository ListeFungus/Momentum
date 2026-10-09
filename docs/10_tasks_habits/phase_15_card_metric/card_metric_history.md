# Momentum - Phase 15: Kartenkennzahl - Verlauf

Stand: 17. September 2026  
Status: Abgeschlossen und extern bestätigt

## 17. September 2026 - Neuplanung technisch umgesetzt

Die vier Pakete 15a bis 15d wurden auf Basis des ausgearbeiteten Plans
umgesetzt. Die automatische Vorimplementierung wurde dabei weiterverwendet,
aber nicht als Produktentscheidung konserviert.

Umgesetzt:

- versionierte, geordnete Kartenanzeige-Konfiguration mit stabilen Schlüsseln,
- separate Drift-Tabelle und Migration auf Schema 18,
- Default, freie Auswahl, explizites Ausblenden und sicherer Fehlerzustand,
- ein sichtbarer Kennzahlplatz bei bereits listenfähigem Datenmodell,
- Ziel-, Status-, Wert-, Instanz- und Bündelkennzahlen aus vorhandenen Summaries,
- Stichtagslogik für Rückblick, Zukunftsansicht und Dringlichkeitsliste,
- tatsächlicher Wert und Datenbasis bei Wertzielen statt pauschalem Zielstatus,
- Schutzpfad bei gemischter Wertart, Einheit oder relevantem Rhythmus,
- gemeinsame Auswahl über Kartenmenü und Detailseiten,
- flexible Chips für schmale Karten und größere Schrift,
- Reaktivität auf Preferences und fachliche Definitionen,
- Aktualisierung bei Tageswechsel und App-Rückkehr,
- gezielte Parser-, Migrations-, Repository-, Auswahl- und Layouttests.

Bewusst offen:

- vollständige historische Auswertung über fachliche Änderungen in Phase 16,
- Cloud-Datenabdeckung, Tombstones und Konflikte in Phase 19,
- zweiter sichtbarer Kennzahlplatz und größerer Kennzahlkatalog nach dem ersten
  Testlauf.

Prüfstand:

- `dart format` wurde auf den betroffenen Dateien ausgeführt.
- Drift-Codegenerierung wurde extern erfolgreich ausgeführt; 103 Ausgaben
  wurden geschrieben.
- Die gezielte Analyse des Phase-15-Dateisatzes wurde extern mit
  `No issues found` bestätigt.
- Extern grün: Preference-Parser `+3`, Migration `+1`, Repositorygruppe
  `Karten` `+6`, Auswahloberfläche `+2` und Kartenchip-Layout `+1`.
- Der Test zur geänderten Einheit deckte einen Tagesgrenzenfehler auf: Eine am
  aktuellen Tag mit Uhrzeit erzeugte Definitionsversion fiel aus einer
  Mitternachtsabfrage heraus. Aufgaben- und Bündelprüfung verwenden nun das
  exklusive Ende des Folgetags; der Regressionstest ist mit `+1` grün.
- Der begrenzte manuelle Praxistest in der App wurde vom Nutzer bestätigt.
  Damit sind 15a bis 15d vollständig abgeschlossen.

## 17. September 2026 - Neuplanung mit dem Nutzer

Die automatische Umsetzung wurde ohne ausreichende fachliche Abstimmung
erstellt. Die unten dokumentierte Entscheidung gegen Nutzerauswahl gilt nicht
mehr. Die damaligen Tests belegen nur den Prototyp.

Im Dialog bestätigt: direkt wählbare Kartenkennzahl, Ziel als passende
Voreinstellung, langfristig maximal zwei Werte und getrennte Detailanalyse.
Vergangene Tagesansichten berechnen den damaligen Zeitraum aus den aktuell
gespeicherten Rohdaten; Korrekturen werden berücksichtigt. Keine eingefrorenen
Ergebnisse und keine Cloud-Abfragen durch die Kennzahlberechnung.

Der Nutzer delegiert kleinere Entscheidungen für einen zügigen ersten Testlauf.
Der neue [Arbeitsplan](card_metric_plan.md) unterscheidet bestätigte Richtung
und daraus abgeleitete Festlegungen: zunächst ein Platz, erweiterbare Speicherung,
lokale Berechnung, Auswahl-UI, Migrations- und Testumfang. Grenzen zu Phase 16
und 19 sind ausdrücklich benannt.

In diesem Chat wurden nur Planungsdokumente geändert. Anwendungscode und
Datenbank blieben unverändert; Tests wurden nicht erneut ausgeführt.

## 15. September 2026 - Release-Minimum umgesetzt

Historischer Bericht des automatischen Prototyps, durch die Neuplanung oben
fachlich abgelöst:

Phase 15 wurde als automatische Kartenkennzahl umgesetzt und extern
geprueft.

Entscheidung:

- Fuer den ersten Release gibt es keine frei waehlbare Kennzahl pro Karte.
- Die App waehlt automatisch die fachlich sinnvollste kompakte Kennzahl.
- Ziele haben Vorrang vor Rohwerten.
- Wenn keine sinnvolle Kennzahl existiert, zeigt die Karte keine Kennzahl.

Umgesetzt:

- Neues Modell `TaskCardMetric` fuer Label, Wert, Detail und Tonalitaet.
- `TaskForDate` und `TaskValueBundleForDate` tragen optional eine berechnete
  Kartenkennzahl.
- `AufgabenRepository` erzeugt Kartenkennzahlen fuer:
  - Tages-/Habit-Listen,
  - Dringlichkeitsliste,
  - abgeschlossene einmalige Aufgaben,
  - gemeinsame Buendelkarten.
- `TaskCard` zeigt die Kennzahl als Chip.
- `TaskValueBundleCard` nutzt denselben Chip.
- Die Anzeige verwendet gute, warnende, kritische oder neutrale Tonalitaet.
- Tests pruefen:
  - Zielstatus hat Vorrang vor Rohwert.
  - Wert-Aufgaben ohne Ziel zeigen den aktuellen Wert.
  - Buendel ohne Ziel zeigen das berechnete Ergebnis.

Pruefung:

- `dart format` lief erfolgreich.
- Gezielte Analyse wurde in der Codex-Umgebung bestaetigt: `No issues found`.
- Gezielte Analyse wurde extern bestaetigt: `No issues found`.
- Der gezielte Flutter-Test wurde extern bestaetigt: `+3 All tests passed`.

Externer PowerShell-Test:

```powershell
cd "C:\Users\maxkr\Documents\Flutter Apps\Upgear\momentum"
flutter test --no-pub test\features\aufgaben\data\aufgaben_repository_test.dart --plain-name "Kartenkennzahl"
```
