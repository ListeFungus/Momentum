# Momentum – Auswertung: Arbeitsplan

Stand: 10. August 2026  
Status: Phase 7 abgeschlossen; vollstaendige Wert-Auswertung laeuft in Phase 13

## Zweck dieses Dokuments

Dieses Dokument ist bewusst kurz. Es zeigt nur:

- wo wir gerade stehen,
- was als Nächstes geprüft oder entschieden werden muss,
- welche Themen später kommen.

Bereits getroffene Entscheidungen stehen im
[`analytics_concept.md`](analytics_concept.md).  
Was technisch umgesetzt wurde, steht im
[`analytics_history.md`](analytics_history.md).

## Aktueller Stand

Phase 7 hat eine erste funktionsfähige Version:

- Grundkennzahlen werden berechnet.
- Feste Zeiträume sind vorhanden.
- Die Aufgaben-/Habit-Detailansicht zeigt die Auswertung.
- Die Detailansicht aktualisiert live.
- Info-Buttons erklären die Kennzahlen.
- Einmalige Aufgaben zeigen eine eigene, einfache Detailansicht statt
  Habit-Quoten.
- Instanz-Auswertung und spätere Zielbewertung sind fachlich getrennt: Bei
  Aufgaben mit Ziel soll später die Zielerreichung führend sein, nicht pauschal
  die strenge Instanz-Erfolgsquote.

Die Darstellung wurde im laufenden App-Betrieb grob geprüft und wirkt auf den
ersten Blick passend. Offene Erweiterungen blockierten Phase 8 nicht, gehören
aber je nach Umfang zur späteren Phase 13, wenn sie für die erste App-Version
nötig sind.

## Phasenübersicht

| Phase | Status | Kurz erklärt |
|---:|---|---|
| A1 / 7 | abgeschlossen | Grundkennzahlen und Begriffe definiert. |
| A2 / 7 | erste Version umgesetzt | Technische Summary, Zeiträume, Anzeigeformat und Detailansicht stehen. |
| A2.1 | abgeschlossen | Detailansicht grob visuell geprüft; Wirkung passt, Feinschliff später. |
| A2.2 | abgeschlossen | Einmalige Aufgaben zeigen Status, Erstellung, Start, Projekt, Fälligkeit und Abschlussdaten. |
| A3 / 11 | geplant | Ziele auf Basis der Grundkennzahlen bewerten. |
| A4 / 13 | aktiv; release-relevant | Vollständige Auswertung für die erste App-Version: Aussagekraft, Trends, Zeiträume, Einzelantworten, Raster und weitere nötige Werte. |
| A5 / Phase 15 | abgeschlossen und extern bestätigt; release-relevant | Nutzer kann eine Kennzahl für Aufgaben-/Habit- und Bündelkarten auswählen, auf einen zielbasierten Standard zurücksetzen oder ausblenden. |
| A6 / 15+ | geplant; release-relevant prüfen | Langzeitauswertung über geänderte Aufgabendefinitionen hinweg, soweit für Release 1 nötig. |

## Vor Phase 8 noch zu entscheiden

Aktuell blockiert aus Phase 7 nichts mehr den Start von Phase 8.

## Geklärte Punkte aus der visuellen Prüfung

| Punkt | Ergebnis |
|---|---|
| Wirkung der Detailansicht | Auf den ersten Blick passend; ruhig genug. |
| Info-Button-Texte | Kurz genug; Wording soll langfristig konsistent mit Erstellung und anderen Anzeigen bleiben. |
| `valuedSuccessRate` | Unten als Zusatzwert sinnvoll; Wording später glätten. |
| `Kein Eintrag` | Nur anzeigen, wenn die Aufgaben-Konfiguration `Kein Eintrag` fachlich ermöglichen kann. |
| Überfälligkeitswerte bei Puffer/Carryover | Sinnvoll, aber spätere Erweiterung. |
| Einmalige Aufgaben | Keine Habit-Quote; stattdessen einfache Detaildaten der konkreten Aufgabe. |
| Aufgaben mit Ziel | Instanzwerte bleiben als Rohdaten sichtbar; führend soll später die Zielerreichung sein. |

## In Phase 13 zu klären

- Aussagekraft-Schwellen
- frei wählbare Zeiträume
- Serien/Streaks
- Liste einzelner Antworten inklusive Notizen
- visuelle Raster-/Symbolansicht aller Einträge
- Sammelauswertung für einmalige Aufgaben
- Überfälligkeitsauswertung für wiederkehrende Aufgaben mit Puffer/Carryover
- Zielbewertung
- Priorisierung der Zielerreichung bei Aufgaben, deren Rhythmus häufiger ist
  als das Ziel, z. B. täglich anzeigen, aber nur 2x pro Woche erreichen
- Projekt- und Langzeitauswertung über geänderte Definitionen hinweg

## Bewusst später

- Aufgaben-Abhängigkeiten, z. B. Aufgabe B wartet auf Aufgabe A
- Auswertungen, die nach der Phase-13-Klärung nicht für die erste App-Version
  nötig sind

## Nächster sinnvoller Schritt

Auswertung fuer Release 1 wird jetzt in Phase 13 fachlich abgegrenzt. Details
stehen im Phase-13-Ordner:
[`../phase_13_value_analytics/value_analytics_plan.md`](../phase_13_value_analytics/value_analytics_plan.md).
