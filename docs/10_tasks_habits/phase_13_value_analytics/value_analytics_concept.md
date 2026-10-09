# Momentum - Phase 13: Konzept fuer Wert-Auswertungen

Stand: 30. August 2026  
Status: Phase 13 abgeschlossenes Konzept

## Zweck

Phase 13 wertet die in Phase 12 erfassten Werte aus. Sie bewertet noch keine
Ziele und legt noch keine Kartenkennzahl fest. Sie berechnet nur sauber und
erklaerbar, was aus den Rohdaten ablesbar ist.

Die Grundidee bleibt:

- Rohdaten bleiben in normalen `TaskEntry`- und `TaskEntryValue`-Datensaetzen.
- `recorded` bedeutet: ein Wert wurde erfasst.
- `failure` bedeutet bei verbindlichen Wert-Eingaben: Pflichtwert verpasst.
- `no_entry` bedeutet: kein verwertbarer Wert, neutral abgeschlossen.
- Reine Tracking-Tage ohne gespeicherten Wert werden fuer Auswertungen virtuell
  als fehlende Werte ableitbar, aber nicht in die Datenbank geschrieben.
- Buendelwerte werden aus zwei Teilwerten berechnet und nicht doppelt
  gespeichert.

## Wertarten

| Wertart | Quelle | Beispiel |
|---|---|---|
| Zahl | `TaskEntryValue.numberValue` und optional `normalizedNumberValue` | 2,5 Liter, 10 Seiten, 3000 kcal |
| Dauer | `TaskEntryValue.durationSeconds` | 35 Minuten Sport |
| Uhrzeit | `TaskEntryValue.timeMinutes` plus `dayOffset` | 23:30 Uhr, ggf. Folgetag |
| Buendel-Zeitintervall | zwei Uhrzeiten aus zwei Teil-Trackings | Schlafdauer |
| Buendel-Differenz | zwei kompatible Zahlen oder Dauern | Aufnahme minus Verbrauch |
| Buendel-Summe | zwei kompatible Zahlen oder Dauern | Dauer A plus Dauer B |

## Grundregeln fuer Kennzahlen

| Regel | Bedeutung |
|---|---|
| Nur echte Werte werden aggregiert | Summe, Durchschnitt, Min/Max und Trends verwenden nur `recorded` Werte. |
| Fehlende Werte bleiben sichtbar | `pending`, `no_entry`, `failure` und virtuelle fehlende Tracking-Tage koennen separat gezaehlt werden. |
| Durchschnitt wird nicht kuenstlich verbessert | Fehlende Tage zaehlen nicht als Wert 0, sondern als fehlend. |
| Status und Wert bleiben getrennt | Ein hoher Wert ist nicht automatisch Erfolg. Zielbewertung folgt in Phase 14. |
| Zahlen sind summierbar | Alle Zahlenwerte sind in Phase 13 technisch summierbar. Weil eigene Einheiten frei beschriftet werden koennen, entscheidet die App zunaechst nicht hart, ob eine Summe fachlich sinnvoll ist. |
| Einheiten muessen erklaerbar bleiben | Bekannte Einheiten koennen innerhalb ihrer Familie umgerechnet werden; Freitext-Einheiten bleiben in Phase 13 beschriftete Zahlen ohne echte Umrechnung. |
| Buendelwerte sind abgeleitet | Sie duerfen fuer Auswertungen genutzt werden, werden aber nicht als eigener Roh-Entry gespeichert. |

## Erste release-relevante Kennzahlen

Diese Kennzahlen sollen zuerst fachlich und technisch vorbereitet werden.

| Kennzahl | Geeignet fuer | Kurz erklaert | Beispiel |
|---|---|---|---|
| Anzahl erfasster Werte | Zahl, Dauer, Uhrzeit, Buendel | Wie viele echte Werte im Zeitraum vorhanden sind. | 18 Schlafdauer-Werte in 30 Tagen |
| Anzahl fehlender Werte | alle Wertarten | Wie viele relevante Tage keinen Wert haben. | 7 Tage ohne Gewichtseintrag |
| Anzahl `no_entry` | verbindliche Werte / Ausnahmen | Wie oft neutral kein Wert vorliegt. | 2 Krankheitstage |
| Anzahl `failure` | verbindliche Werte | Wie oft ein Pflichtwert verpasst wurde. | 3 verpasste Blutzuckerwerte |
| Summe | summierbare Zahlen, Dauer, Buendel-Summe/Differenz | Gesamtwert im Zeitraum. | 42 km gelaufen |
| Durchschnitt | Zahl, Dauer, Uhrzeit, Buendel | Mittelwert aus vorhandenen Werten. | durchschnittlich 7,4 h Schlaf |
| Minimum / Maximum | Zahl, Dauer, Uhrzeit, Buendel | kleinster und groesster vorhandener Wert. | kuerzeste Schlafdauer 5 h 20 min |
| Verlauf / Trend | Zahl, Dauer, Uhrzeit, Buendel | In Phase 13 zuerst einfache Wertliste im Zeitraum, noch kein Diagramm und keine echte Trendanalyse. | Gewichtswerte der letzten 30 Tage |
| Wochen-/Monatsvergleich | Zahl, Dauer, Uhrzeit, Buendel | aggregierte Zeitraeume vergleichen. | diese Woche mehr Sportdauer als letzte |
| Rechtzeitigkeits-/Verarbeitungsquote | verbindliche Wert-Eingaben | Anteil erledigter/verarbeiteter Pflichtwerte. | 27 von 30 Pflichtwerten verarbeitet |

## Was nicht automatisch aus Werten folgt

Ein Wert sagt noch nicht, ob ein Ziel erreicht wurde.

Beispiele:

- 2 Liter Wasser koennen Zielerfolg sein, 0,5 Liter nicht.
- 8 Stunden Schlaf koennen gut sein, 12 Stunden vielleicht nicht.
- 23:00 Uhr Bettgehzeit kann besser sein als 01:30 Uhr, aber das ist eine
  Zielregel, keine Roh-Auswertung.

Deshalb:

- Phase 13 berechnet Werte.
- Phase 14 bewertet Ziele auf Basis dieser Werte.
- Phase 15 waehlt daraus spaeter eine kompakte Kartenkennzahl.

## Auswertung nach Aufgabenart

| Aufgabenart | Auswertung |
|---|---|
| Reines Tracking | Werte, fehlende virtuelle Tage, Haeufigkeit der Eingaben, Verlauf. Keine Missed-Policy-Fehler. |
| Verbindliche Wert-Eingabe | Werte plus `failure`, `no_entry`, offene/pending Instanzen und Verarbeitung. |
| Einmaliger Wert | Einzelwert, Erfassungszeitpunkt, ggf. Dauer bis Erfassung und Abweichung vom Faelligkeitsdatum. Keine Zeitraumquote. |
| Zwei-Werte-Buendel | Teilwert A, Teilwert B und abgeleiteter Wert. Teilweise erfasste Buendel bleiben separat sichtbar. |

## Uhrzeit und Tagesbezug

Uhrzeitwerte werden immer mit ihrem fachlichen Tagesbezug betrachtet.

Beispiel:

- Auswertungstag: 12. August
- Eingabe: 00:30 Uhr
- Zusatz/Tagesbezug: Folgetag
- Fachliche Bedeutung: 13. August, 00:30 Uhr gehoert zur Auswertung des
  12. August, z. B. als spaete Bettgehzeit.

Technisch wird dafuer `timeMinutes + dayOffset * 24 * 60` verwendet. Die UI
soll klar anzeigen, wenn eine Uhrzeit als Folgetag gemeint ist.

Eine einzelne Uhrzeit wird in Phase 13 trotzdem nicht automatisch als "gut",
"frueh" oder "spaet" bewertet. Diese Interpretation gehoert zu Buendeln,
Zielen oder spaeteren spezialisierten Auswertungen.

## Historische Buendel

Phase 13 wertet im ersten Ausbau aktive Buendel aus. Aufgeloeste Buendel
historisch datumsscharf zu rekonstruieren bleibt spaeter offen, weil Phase 12
das datumsscharfe Aufloesen bewusst noch nicht vollstaendig geloest hat.

## Abschlussstand Phase 13

Phase 13 ist abgeschlossen, wenn die App Werte erklaerbar aus Rohdaten ableiten
kann, ohne bereits Ziele oder Kartenkennzahlen zu bewerten.

Der abgeschlossene Stand umfasst:

- Einzelwert-Auswertung fuer Zahl, Dauer und Uhrzeit.
- Zeitraum-Auswahl fuer letzte 7, 20, 30 Tage und seit Beginn.
- getrennte Zaehllogik fuer `recorded`, `pending`, `failure`, `no_entry` und
  virtuelle reine-Tracking-Luecken.
- Einzelwertdetails fuer einmalige Wert-Aufgaben.
- Zwei-Werte-Buendel fuer Zeitintervall, Differenz und Summe.
- Same-Day-Buendel als gemeinsame Karte oder verknuepfte Einzelkarten.
- Cross-Day-Zeitintervall-Buendel mit erstem Teilwert vom Vortag und zweitem
  Teilwert am angezeigten Tag.
- sichtbare Uhrzeit-Datumszuordnung ueber Vortag, gleicher Tag und Folgetag.

Damit ist die Grundlage fuer Phase 14 gelegt: Ziele koennen auf diese
Auswertungen zugreifen, ohne eigene parallele Rechenlogik aufzubauen.

## UI-Prinzip

Wert-Auswertungen sollen wie Status-Auswertungen erklaerbar sein.

- Jede Kennzahl bekommt spaeter einen Info-Button.
- Der Info-Text erklaert kurz, welche Eingaben in die Berechnung eingehen.
- Nicht verfuegbare Kennzahlen werden nicht still versteckt, sondern je nach
  Kontext ausgegraut oder mit Hinweis erklaert.
- Detailansichten duerfen umfangreicher sein als Karten. Kartenkennzahlen folgen
  erst in Phase 15.

## Bewusst spaeter

Nicht Teil des ersten Phase-13-Ausbaus:

- Zielbewertung,
- Kartenkennzahl,
- mehrere Sessions pro Tag,
- Ausreisser-Erkennung,
- komplexe Prognosen,
- Premium-/Paywall-Entscheidung,
- Projekt- und Gesamtwertauswertungen ueber mehrere Aufgaben hinweg,
- eigene Einheitenverwaltung.
