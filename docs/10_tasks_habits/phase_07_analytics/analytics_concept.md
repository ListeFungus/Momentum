# Momentum – Auswertungskonzept und Verlauf

Stand: 14. Juli 2026  
Status: Phase 7 – erste Version umgesetzt, Konzept wird weiter gepflegt

## Zweck

Dieses Dokument erklärt langfristig, wie Auswertungen in Momentum verstanden
werden. Es soll später zusammenhängend zeigen:

- welche Kennzahlen es gibt,
- warum diese Kennzahlen so definiert wurden,
- welche Auswertungen zu welchen Aufgaben passen,
- wie Ziele, Kartenkennzahlen und Detailansichten darauf aufbauen.

Der laufende Arbeitsplan steht in
[`analytics_plan.md`](analytics_plan.md).
Der technische Umsetzungsverlauf steht in
[`analytics_history.md`](analytics_history.md).

Pflegeprinzip:

- Der Auswertungsplan bleibt kurz und zeigt aktuelle Phase, nächste Schritte und
  offene Fragen.
- Dieses Dokument wächst und sammelt die dauerhafte fachliche Erklärung.
- Sobald Begriffe und Entscheidungen stabil sind, werden ausführliche
  Erklärungen aus dem Plan hierher übernommen.

## Grundidee

Auswertung soll ehrlich sein. Momentum soll nicht nur zählen, was gut lief,
sondern auch sichtbar machen:

- was erfolgreich war,
- was nicht erfolgreich war,
- wo kein Eintrag vorliegt,
- was noch offen ist,
- wie vollständig ein Zeitraum bereits verarbeitet wurde.

Jede Auswertung in der UI soll erklärbar sein. Deshalb bekommt jede
Analyse-Anzeige später einen kleinen Info-Button. Dieser erklärt kurz:

- welche Einträge gezählt werden,
- welche Formel verwendet wird,
- ob offene oder `no_entry`-Einträge enthalten sind,
- wann die Aussage der Kennzahl eingeschränkt sein kann.

Die erste Auswertung soll nicht direkt auf Aufgaben- oder Habit-Karten
erscheinen. Stattdessen wird sie zuerst in der Detailansicht einer Aufgabe oder
eines Habits gezeigt. Dort können mehrere Kennzahlen nebeneinander erklärt
werden, ohne die tägliche Übersicht zu überladen.

Eine einzelne Standardkennzahl wird deshalb für die erste Detailansicht nicht
benötigt. Falls später eine Kennzahl direkt auf Karten angezeigt wird, muss sie
zur Aufgabenart und zum Ziel passen. Bei Aufgaben ohne Ziel ist die strenge
Erfolgsquote (`strictSuccessRate`) ein ehrlicher Kandidat. Bei Aufgaben mit Ziel
soll dagegen die Zielerreichung führend sein, weil eine täglich angezeigte
Aufgabe trotzdem nur ein Ziel wie „2x pro Woche“ haben kann.

## Phasenergebnisse im Überblick

| Phase | Ergebnis | Einordnung |
|---|---|---|
| A1 / Phase 7 | Grundbegriffe und Kennzahlen definiert | Fachliche Basis für Auswertung und spätere Ziele |
| A2 / Phase 7 | Erste technische Auswertung und Detailansicht umgesetzt | Erste nutzbare Version; grob geprüft, spätere Erweiterungen dokumentiert |
| A3 / Phase 14 | Zielbewertung | geplant; bewusst nach vollständiger Status- und Wert-Auswertung |
| A4 / Phase 15 | auswählbare Kartenkennzahl | abgeschlossen und extern bestätigt |
| A5 / Phase 12 | erweiterte Auswertung | später |
| A6 | Langzeitauswertung über geänderte Definitionen | später |

## Beschlossene Grundregeln

1. Auswertung basiert auf einzelnen Instanzen, nicht nur auf Zählern.
2. `success` ist ein Erfolg.
3. `failure` ist ein Misserfolg.
4. `pending` ist offen und wird nicht in Erfolgsquoten eingerechnet.
5. `no_entry` ist abgeschlossen, aber keine wertende Antwort.
6. `no_entry` darf die Erfolgsquote nicht verbessern.
7. Die erste Auswertung erscheint in der Detailansicht, nicht direkt auf der
   Aufgabenkarte.
8. Jede sichtbare Kennzahl braucht eine kurze Erklärung.
9. Prozentwerte werden mit einer Nachkommastelle angezeigt.
10. Quoten zeigen zusätzlich das Verhältnis, z. B. `2 von 3`.
11. Die Detailansicht aktualisiert live, wenn sich Einträge ändern.
12. Instanz-Auswertung und Ziel-Auswertung werden getrennt: Die
    Instanz-Auswertung zeigt ehrlich, was mit allen erzeugten Einträgen passiert
    ist; die Ziel-Auswertung bewertet, ob das fachliche Ziel erreicht wurde.
13. Bei Aufgaben mit Ziel soll später die Zielerreichung die führende Aussage
    sein. Die Instanzwerte bleiben darunter als Erklärung und Rohdaten sichtbar.

## Erste Grundkennzahlen

| Kennzahl | Bedeutung |
|---|---|
| `dueCount` | bereits fällige/vergangene Instanzen im Auswertungszeitraum |
| `totalInstanceCount` | alle Instanzen im Zeitraum, inklusive noch offener Instanzen |
| `successCount` | erfolgreiche Instanzen |
| `failureCount` | nicht erfolgreiche Instanzen |
| `noEntryCount` | ohne wertende Antwort abgeschlossene Instanzen |
| `pendingCount` | noch offene Instanzen |
| `answeredCount` | `successCount + failureCount` |
| `resolvedCount` | `successCount + failureCount + noEntryCount` |
| `strictSuccessRate` | `successCount / dueCount` |
| `valuedSuccessRate` | `successCount / answeredCount` |
| `completionRate` | `resolvedCount / totalInstanceCount` |

Die erste technische Umsetzung bündelt diese Werte in einer gemeinsamen
Summary. Das ist bewusst klein gehalten: Die Summary berechnet nur Grundwerte
aus vorhandenen Instanzen und entscheidet noch nicht, wie sie später in der UI
angezeigt, gewichtet oder als Ziel bewertet werden.

Wichtig: Diese Grundwerte sind Rohdaten. Sie beantworten nicht automatisch, ob
eine Aufgabe fachlich „gut gelaufen“ ist. Dafür muss später die Zielbewertung
hinzukommen.

Beispiel:

- Aufgabe wird täglich angezeigt.
- Ziel ist aber nur „2x pro Woche“.
- Dann entstehen viele Instanzen, von denen einige `no_entry` bleiben können.
- Die strenge Instanz-Erfolgsquote kann dadurch niedrig wirken.
- Fachlich kann das Ziel trotzdem erfüllt sein, wenn im Wochenzeitraum genug
  Erfolge erreicht wurden.

Technischer Stand der ersten Version:

- `TaskAnalyticsSummary` enthält die Rohkennzahlen und berechneten Quoten.
- `TaskAnalyticsPeriod` modelliert die ersten festen Zeiträume.
- `TaskAnalyticsDisplay` bereitet Labels, Werte, Verhältnisse und Info-Texte für
  die UI vor.
- `AufgabenRepository` stellt Future- und Stream-Methoden für die Auswertung
  bereit.
- `TaskDetailScreen` zeigt die erste live aktualisierte Detailansicht.

## Zeitbegriffe für Aufgaben und Instanzen

Für Auswertungen werden bewusst mehrere Zeitpunkte unterschieden. Das wirkt
zunächst etwas technisch, verhindert aber spätere Fehlinterpretationen.

| Begriff | Ebene | Bedeutung |
|---|---|---|
| `task.createdAt` | Aufgabe | Zeitpunkt, an dem die Aufgabendefinition angelegt wurde. |
| `task.startDate` | Aufgabe | Datum, ab dem die Aufgabe fachlich zählt oder sichtbar werden darf. |
| `entry.createdAt` | Instanz | Zeitpunkt, an dem die konkrete Instanz gespeichert/erzeugt wurde. |
| `entry.scheduledDate` | Instanz | Kalendertag, zu dem die Instanz fachlich gehört. |
| `entry.updatedAt` | Instanz | Zeitpunkt der letzten technischen Änderung an der Instanz. |
| `entry.respondedAt` | Instanz | Zeitpunkt, an dem eine Person eine Antwort eingetragen hat. |
| `entry.finalizedAt` | Instanz | Zeitpunkt, an dem die Instanz endgültig abgeschlossen wurde. |
| `entry.effectiveAt` | Instanz | Fachlich wirksamer Abschlusszeitpunkt für Auswertung und Rückrechnung. |
| `entry.resolutionOrigin` | Instanz | Herkunft des Status: manuell, automatisch oder Migration. |

Beispiel:

- Eine Aufgabe wird am 10. März erstellt.
- Sie soll aber erst ab dem 15. März zählen.
- Dann ist `task.createdAt` der 10. März und `task.startDate` der 15. März.

Bei Aufgaben, die nach Abschluss eine neue Instanz erzeugen, gilt:

- Die neue Instanz bekommt ein eigenes `entry.createdAt`, wenn sie erzeugt
  wird.
- Ihr `entry.scheduledDate` bleibt der fachliche Tag, zu dem sie gehört.
- Die ursprüngliche Aufgabe behält ihr `task.createdAt`.

Für die Dauer bis zum Abschluss gilt zunächst:

- Wenn ein Startdatum vorhanden ist, zählt die Dauer ab `task.startDate`.
- Falls später eine Aufgabe ohne fachlichen Start modelliert wird, dient
  `task.createdAt` als Ersatz.
- Der Abschluss wird über `effectiveAt`, ersatzweise `finalizedAt` oder
  `respondedAt`, bestimmt.

## Erste Zeiträume

Für die erste Auswertung werden einfache feste Zeiträume verwendet:

- letzte 7 Tage
- letzte 20 Tage
- letzte 30 Tage
- seit Beginn der Aufgabe

Technisch werden diese Zeiträume als feste Auswahl modelliert. Die rollierenden
Zeiträume zählen inklusive des heutigen Tages. „Letzte 7 Tage“ bedeutet also:
heute plus die sechs vorherigen Tage. Wenn die Aufgabe später begonnen hat,
beginnt der Zeitraum erst am Startdatum der Aufgabe.

Später können weitere Zeiträume ergänzt werden, zum Beispiel:

- frei gewählte Anzahl an Tagen
- Start- und Enddatum über Kalenderauswahl
- Projektzeitraum
- Woche, Monat oder Jahr
- rollierende Zeiträume für spezielle Ziele

## Erste Detailansicht

Die erste Aufgaben-/Habit-Auswertung erscheint in einer Detailansicht, nicht auf
der Aufgabenkarte. Die Karte bleibt dadurch ruhig und handlungsorientiert. Die
Detailansicht darf mehr erklären und mehrere Werte nebeneinander zeigen.

Wichtig: Diese erste Detailauswertung passt fachlich vor allem zu
wiederkehrenden Aufgaben und Habits. Eine einzelne einmalige Aufgabe erzeugt
normalerweise nur eine relevante Instanz. Dafür ist eine Erfolgsquote über 7,
20 oder 30 Tage meist nicht sinnvoll.

Die Detailansicht aktualisiert sich live aus den gespeicherten Einträgen. Wenn
sich ein Eintrag im gewählten Zeitraum ändert, wird die Auswertung automatisch
neu berechnet.

Die erste Version der Detailansicht ist bewusst schlicht: Sie zeigt die
wichtigsten Kennzahlen und hält Zusatzwerte wie die wertende Erfolgsquote
weiter unten. Diese Zusatzwerte sind für Detailanalyse und spätere
Kartenanzeigen vorbereitet, aber nicht die Hauptbewertung.

Vorgeschlagene Reihenfolge:

1. Zeitraum-Auswahl
2. Zusammenfassung mit Erfolgsquote und optional Fortschritt
3. Zählwerte für Erfolg, Misserfolg, Kein Eintrag und Offen
4. kurze Hinweise, wenn Werte fehlen oder eine Kennzahl leicht missverstanden
   werden kann
5. Info-Button pro Kennzahl

Wenn es im Zeitraum noch keine fälligen Einträge gibt, wird keine Prozentzahl
angezeigt. Stattdessen erscheint ein Hinweis wie:

> Noch keine fälligen Einträge in diesem Zeitraum.

In der Kennzahl selbst kann dafür ein freundlicher Leertext wie
„Noch keine fälligen Einträge“ erscheinen.

## Unterschiedliche Auswertung je Aufgabenart

Nicht jede Aufgabe soll dieselbe Auswertung bekommen.

### Wiederkehrende Aufgaben und Habits

Für wiederkehrende Aufgaben und Habits sind zeitbezogene Kennzahlen sinnvoll:

| Anzeige | Kurze Erklärung |
|---|---|
| Erfolgsquote | Anteil der erfolgreichen fälligen Einträge im gewählten Zeitraum. Beispiel: 2 Erfolge von 3 fälligen Einträgen = 66,7 %. |
| Erfolge | Anzahl aller Einträge im gewählten Zeitraum, die erfolgreich abgeschlossen wurden. |
| Misserfolge | Anzahl aller Einträge im gewählten Zeitraum, die aktiv oder automatisch als nicht erfolgreich abgeschlossen wurden. |
| Kein Eintrag | Anzahl aller Einträge im gewählten Zeitraum, die abgeschlossen wurden, aber ohne wertende Ja-/Nein-Antwort. Diese Kennzahl muss nicht angezeigt werden, wenn die Aufgaben-Konfiguration `Kein Eintrag` fachlich nie erzeugen kann. |
| Offen | Anzahl aller Einträge im gewählten Zeitraum, die noch nicht beantwortet und noch nicht durch eine Missed Policy abgeschlossen wurden. Offen entsteht nicht automatisch als Endstatus, sondern ist der laufende Zustand (`pending`). |
| Fortschritt/Verarbeitung | Anteil aller Einträge im gewählten Zeitraum, die nicht mehr offen sind. |
| Zeiträume | Erste Auswahl: letzte 7 Tage, letzte 20 Tage, letzte 30 Tage und seit Beginn. |
| Spätere Erweiterungen | Serien, Rasteransichten, Zielbewertung und frei wählbare Zeiträume. |

Diese Aufgaben erzeugen mehrere Instanzen. Deshalb kann die App Muster über
Zeit sichtbar machen.

Wenn eine wiederkehrende Aufgabe ein Ziel besitzt, dürfen diese Kennzahlen nicht
mit der Zielbewertung verwechselt werden.

Beispiel:

- Anzeige/Rhythmus: täglich
- Ziel: 2 Erfolge pro Woche

In diesem Fall ist es nicht automatisch problematisch, wenn nicht jeder Tag ein
Erfolg ist. Die Instanz-Auswertung zeigt weiterhin Erfolge, Misserfolge, Kein
Eintrag und Offen. Die führende Bewertung sollte später aber lauten, ob das
Wochenziel erreicht wurde.

Dadurch bleibt die Auswertung ehrlich, ohne Nutzende unnötig zu demotivieren.

### Einzelne einmalige Aufgabe

Eine einzelne einmalige Aufgabe braucht in der Regel keine Habit-artige
Auswertung. Wenn es nur eine Instanz gibt, sind Quoten wie „letzte 7 Tage“ oder
„Erfolgsquote seit Beginn“ kaum aussagekräftig.

Für die Detailansicht einer einmaligen Aufgabe ist eher sinnvoll:

- Status: offen, erledigt, nicht erledigt oder ohne Eintrag
- Erstellungsdatum
- Datum, ab dem sie zählt
- Projektzuordnung
- Fälligkeitsdatum
- wie viele Tage bis zur Fälligkeit verbleiben oder wie viele Tage überfällig
  sie ist
- Erledigungsdatum
- Dauer bis zum Abschluss
- Abweichung vom Fälligkeitstag, falls ein Fälligkeitsdatum vorhanden ist
- Abschlussart: manuell, automatisch oder Migration
- Notiz

Die Habit-artige Auswertung wird bei einzelnen einmaligen Aufgaben deshalb
nicht als Hauptansicht verwendet. Stattdessen zeigt die Detailansicht die
konkreten Daten dieser Aufgabe.

Später können auch Abhängigkeiten zwischen Aufgaben relevant werden, zum
Beispiel: Aufgabe B kann erst sinnvoll begonnen werden, wenn Aufgabe A erledigt
ist. Das sollte nicht jetzt umgesetzt werden, aber die Struktur soll dafür offen
bleiben. Fachlich wäre dafür eher eine eigene Beziehung zwischen Aufgaben
sinnvoll als ein einzelnes Textfeld.

### Sammelauswertung für einmalige Aufgaben

Einmalige Aufgaben können trotzdem ausgewertet werden, aber eher gesammelt über
mehrere Aufgaben hinweg.

Mögliche Kennzahlen:

- Anzahl aller einmaligen Aufgaben
- wie viele einmalige Aufgaben erledigt wurden
- wie viele als Misserfolg abgeschlossen wurden
- wie viele offen sind
- wie viele aktuell überfällig sind
- durchschnittliche überfällige Tage über alle betrachteten Aufgaben
- durchschnittliche überfällige Tage der aktuell offenen Aufgaben
- durchschnittliche Zeit bis zur Erledigung
- durchschnittliche Abweichung vom Fälligkeitstag
- wie viele Aufgaben vor, am oder nach dem Fälligkeitstag erledigt wurden
- Anteil der Aufgaben, die rechtzeitig erledigt wurden
- Anteil manuell abgeschlossener Aufgaben
- Anteil automatisch durch Regeln abgeschlossener Aufgaben

Diese Auswertung gehört eher in eine Aufgaben-/Projekt-/Gesamtanalyse als in
die Detailauswertung einer einzelnen einmaligen Aufgabe.

### Überfälligkeitsauswertung bei wiederkehrenden Aufgaben

Auch wiederkehrende Aufgaben können eine eigene Überfälligkeitsauswertung
brauchen, besonders wenn Puffer, Carryover/Aufstauen oder dauerhaft offene
Instanzen möglich sind.

Ziel dieser Auswertung: Nutzende sollen motiviert werden, Aufgaben nicht nur
irgendwann, sondern möglichst zeitnah zu erledigen. Die App kann dadurch
statistisch sichtbar machen, ob Aufgaben direkt, im Puffer oder erst deutlich
später erledigt werden.

Mögliche Kennzahlen:

- durchschnittliche Tage bis zur Erledigung nach Fälligkeit
- Anteil rechtzeitig erledigter Instanzen
- Anteil im Puffer erledigter Instanzen
- Anteil nach dem Puffer erledigter Instanzen
- Anzahl und Alter offener Carryover-Instanzen
- ältester aktueller Rückstand
- durchschnittliche Rückstandstage aktuell offener Instanzen

Diese Werte sind nicht Ersatz für die Erfolgsquote. Sie ergänzen sie um die
Frage: „Wie schnell und rechtzeitig wird erledigt?“

## Erste Info-Button-Texte

Die Texte sollen kurz und verständlich sein. Sie erklären nicht die komplette
Fachlogik, sondern genau genug, damit Nutzende der Zahl vertrauen können.

| Anzeige | Kurzer Erklärungstext |
|---|---|
| Erfolgsquote | „Zeigt, wie viele fällige Einträge in diesem Zeitraum erfolgreich waren. Misserfolge und Kein Eintrag zählen nicht als Erfolg. Offene Einträge werden separat angezeigt.“ |
| Erfolge | „Alle Einträge, die in diesem Zeitraum erfolgreich abgeschlossen wurden.“ |
| Misserfolge | „Alle Einträge, die aktiv mit Nein oder automatisch als nicht erfolgreich abgeschlossen wurden.“ |
| Kein Eintrag | „Einträge, die abgeschlossen wurden, aber ohne Ja-/Nein-Antwort. Sie zählen nicht als Erfolg, bleiben aber sichtbar.“ |
| Offen | „Einträge, die noch nicht beantwortet und noch nicht durch eine Regel abgeschlossen wurden. Sie fließen noch nicht in die Erfolgsquote ein.“ |
| Beantwortet | „Alle Einträge mit einer wertenden Antwort: Erfolg oder Misserfolg.“ |
| Verarbeitet | „Alle Einträge, die nicht mehr offen sind: Erfolg, Misserfolg oder Kein Eintrag.“ |
| Fortschritt | „Zeigt, welcher Anteil aller Einträge im gewählten Zeitraum bereits verarbeitet wurde.“ |
| Wertende Erfolgsquote | „Zeigt den Erfolgsanteil nur unter den Ja-/Nein-Antworten. Kein Eintrag und offene Einträge werden hierbei nicht mitgezählt.“ |

Für die erste UI sollten vor allem Erfolgsquote, Erfolge, Misserfolge,
Kein Eintrag und Offen sichtbar sein. `Beantwortet`, `Verarbeitet`,
`Fortschritt` und `Wertende Erfolgsquote` können zunächst als Detailwerte oder
später in einer erweiterten Analyse erscheinen.

## Darstellung von Quoten

Quoten werden mit einer Nachkommastelle angezeigt, zum Beispiel:

```text
66,7 %
```

Zusätzlich wird das konkrete Verhältnis angezeigt, zum Beispiel:

```text
2 von 3
```

Beide Darstellungen sind wichtig:

- Die Prozentzahl ist schnell erfassbar.
- Das Verhältnis zeigt, wie viele Einträge tatsächlich dahinterstehen.

Später kann in der Aufgaben- oder Habit-Detailansicht ausgewählt werden, welche
Darstellung auf der Aufgabenkarte erscheinen soll.

## Einzelantworten und Notizen

Die Detailansicht soll später nicht nur zusammenfassen, sondern auch einzelne
Einträge nachvollziehbar machen.

Geplant ist eine Ansicht der einzelnen Antworten im gewählten Zeitraum. Dort
soll sichtbar sein:

- Datum der Instanz
- Status: Erfolg, Misserfolg, Kein Eintrag oder Offen
- ob eine Notiz vorhanden ist
- die Notiz selbst, wenn der Eintrag geöffnet oder aufgeklappt wird
- optional die Herkunft: manuell, automatisch oder Migration

Warum das wichtig ist:

- Nutzende können nachvollziehen, welche konkreten Tage in eine Auswertung
  eingeflossen sind.
- Notizen erklären Ausreißer, Sonderfälle oder `no_entry`-Einträge.
- Spätere Korrekturen vergangener Antworten werden leichter auffindbar.

## Visuelle Rasteransicht

Zusätzlich ist eine kompakte visuelle Darstellung geplant. Jeder Eintrag kann
dabei als kleines Symbol oder eine Form dargestellt werden.

Mögliche Darstellung:

- ein Punkt, Kreis oder Quadrat pro Instanz
- Farbe nach Status:
  - Erfolg: positiv/grün
  - Misserfolg: negativ/rot oder warm
  - Kein Eintrag: neutral/grau oder blau-grau
  - Offen: hell/umrandet
- zusätzliche Markierung, wenn eine Notiz vorhanden ist

Diese Ansicht soll Muster schnell sichtbar machen, zum Beispiel:

- viele Erfolge hintereinander
- auffällig viele `no_entry`-Einträge
- Lücken oder unregelmäßige Nutzung
- Zeiträume mit vielen Misserfolgen

Die genaue Form wird später entschieden. Wichtig ist: Die Visualisierung darf
die Zahlen nicht ersetzen, sondern soll sie verständlicher machen.

## Warum zwei Bezugsgrößen?

Für Erfolgsquoten sind vergangene beziehungsweise fällige Instanzen wichtig.
Noch offene Aufgaben sollen die Quote nicht verzerren. Dafür gibt es
`dueCount`.

Für Fortschritt ist dagegen wichtig, wie viele Instanzen im gesamten Zeitraum
schon verarbeitet wurden. Dafür gibt es `totalInstanceCount` und
`completionRate`.

Beispiel:

- Ziel: 20 Mal Sport in den nächsten zwei Monaten
- 8 Instanzen liegen bereits in der Vergangenheit
- 5 davon waren erfolgreich
- 1 war nicht erfolgreich
- 2 wurden als `no_entry` abgeschlossen
- 12 Instanzen liegen noch offen oder in der Zukunft

Dann beschreibt `strictSuccessRate`, wie gut die bisherigen fälligen Instanzen
liefen. `completionRate` beschreibt dagegen, wie weit der gesamte Zeitraum
bereits verarbeitet ist.

## Strenge Erfolgsquote

Die strenge Erfolgsquote ist:

```text
strictSuccessRate = successCount / dueCount
```

Sie beantwortet: „Wie viel Prozent der fälligen Instanzen waren erfolgreich?“

`pending` wird nicht eingerechnet, sondern separat angezeigt.

Für die erste Detailansicht ist sie eine wichtige Kennzahl, aber nicht die
einzige Standardanzeige. Dort werden mehrere Werte gemeinsam gezeigt. Wenn
später genau eine Kennzahl auf Aufgaben- oder Habit-Karten angezeigt werden
soll, ist `strictSuccessRate` nur bei Aufgaben ohne konkretes Ziel der beste
Kandidat. Bei Aufgaben mit Ziel soll die Zielerreichung führend sein.

## Wertende Erfolgsquote

```text
valuedSuccessRate = successCount / answeredCount
```

Diese Quote betrachtet nur echte Ja-/Nein-Antworten. Sie kann nützlich sein,
ist aber nicht immer geeignet, weil sie `no_entry` ignoriert. Deshalb soll sie
nur angezeigt werden, wenn sie zur Aufgabe passt oder klar erklärt wird.

## Offene Punkte

- Welche Kennzahlen sind für welche Aufgabenkonfiguration sinnvoll?
- Welche Kennzahlen dürfen auf Karten angezeigt werden?
- Wie priorisiert die UI Zielerreichung gegenüber Instanz-Erfolgsquote, wenn
  Rhythmus und Ziel absichtlich unterschiedlich sind?
- Wann braucht eine Auswertung Hinweise zur Aussagekraft?
- Wie werden Serien fachlich definiert?
- Wie hängen Zielbewertungen später an diesen Kennzahlen?
- Wie werden einzelne Antworten und Notizen in der Detailansicht dargestellt?
- Welche Form eignet sich für die visuelle Rasteransicht?

## Abgrenzung: Log-in-Streak

Eine Log-in-Streak beziehungsweise App-Nutzungsserie kann motivierend sein, ist
aber keine fachliche Aufgaben-Auswertung. Sie gehört später in ein eigenes
Motivations- oder Nutzungsthema und darf nicht mit Erfolgsserien einzelner
Aufgaben verwechselt werden.
