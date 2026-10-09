# Momentum – Phase 11: Vollständige Auswertung

Stand: 22. Juli 2026  
Status: Abgeschlossen in erster Ausbaustufe

## Ziel

Die App soll vor dem Release nicht nur Aufgaben und Habits erfassen, sondern sie
auch vollständig genug auswerten, damit die erste Version sinnvoll nutzbar ist.

Diese Phase kommt bewusst vor der Zielbewertung. Erst werden alle sinnvollen
Status-Auswertungen für Aufgaben und Habits fertiggestellt, danach können Ziele
relativ klar darauf aufbauen.

## Einordnung

Phase 7 hat die Grundauswertung geliefert. Phase 11 erweitert daraus die
release-relevante Status-Auswertung. Phase 12 ergänzt später neue
Erfassungsarten; Phase 13 wertet diese Wert-Eingaben aus. Zielbewertung folgt
erst danach in Phase 14.

Mögliche Themen, die im Auswertungs-Chat konkretisiert werden:

- Trends und Verläufe
- Aussagekraft-Hinweise
- freie oder erweiterte Zeiträume
- Detailansichten einzelner Einträge
- Raster oder Kalenderdarstellungen
- Sammelauswertung einmaliger Aufgaben
- Überfälligkeit, Puffer- und Carryover-Auswertung
- klare Abgrenzung zu Projekt-, Gesamt- und späteren Spezialauswertungen

Die Zuordnung von Aufgabenarten zu passenden Auswertungen wird zusätzlich in
[`../task_analytics_matrix.md`](../task_analytics_matrix.md) gepflegt. Dort gibt
es getrennte Tabellen für Status-Aufgaben und spätere Wert-/Eingabe-Aufgaben.
Die konkrete Sichtbarkeit einzelner Status-Kennzahlen steht in
[`status_metric_visibility.md`](status_metric_visibility.md), damit dieser Plan
übersichtlich bleibt.
Die Detailfelder und Auswertungen einzelner einmaliger Aufgaben stehen in
[`single_task_metric_visibility.md`](single_task_metric_visibility.md).

## Mögliche Auswertungen

Diese Liste sammelt die aktuell bekannten Auswertungen. Nicht jede Auswertung
passt zu jeder Aufgabe. Die App soll später nur die Werte anzeigen, die zur
Aufgabenart, zum Rhythmus und zur Zieldefinition sinnvoll sind.

### Wiederkehrende Aufgaben und Habits

| Auswertung | Kurze Erklärung | Beispiel |
|---|---|---|
| Strenge Erfolgsquote | Anteil erfolgreicher fälliger Instanzen im Zeitraum. `no_entry` und `failure` zählen nicht als Erfolg; offene Einträge zählen nicht mit. | 8 Erfolge von 37 fälligen Einträgen = 21,6 %. |
| Wertende Erfolgsquote | Erfolgsanteil nur unter aktiven Ja-/Nein-Antworten. `no_entry` und offene Einträge werden ignoriert. | 8 Erfolge und 3 Misserfolge = 8 von 11 = 72,7 %. |
| Erfolge | Anzahl aller erfolgreichen Einträge im gewählten Zeitraum. | In den letzten 30 Tagen 8x Wasser getrunken. |
| Misserfolge | Anzahl aller aktiven negativen Einträge im gewählten Zeitraum. | 3x bewusst mit „Nein“ beantwortet oder automatisch als Misserfolg gespeichert. |
| Kein Eintrag | Anzahl abgeschlossener Einträge ohne wertende Antwort. Diese Auswertung ist nur relevant, wenn die Aufgabe `no_entry` erzeugen kann. | 5 Tage waren wegen Krankheit als „Kein Eintrag“ gespeichert. |
| Offen | Anzahl noch nicht beantworteter und noch nicht automatisch abgeschlossener Einträge. | Heute und gestern sind noch offen = 2 offene Einträge. |
| Beantwortete Instanzen | Anzahl aktiver Ja-/Nein-Antworten. | 8 Erfolge + 3 Misserfolge = 11 beantwortete Instanzen. |
| Abgeschlossene Instanzen | Anzahl aller nicht mehr offenen Instanzen. Dazu zählen `success`, `failure` und `no_entry`. | 8 Erfolge + 3 Misserfolge + 5 Kein Eintrag = 16 abgeschlossen. |
| Fortschritt / Verarbeitung | Anteil bereits abgeschlossener Instanzen an allen erzeugten Instanzen im Zeitraum. | 37 von 38 Instanzen sind verarbeitet = 97,4 %. |
| Fällige Instanzen | Anzahl vergangener oder fälliger Instanzen im Zeitraum. Grundlage für viele Quoten. | In 30 Tagen gab es 30 fällige Tagesinstanzen. |
| Alle Instanzen | Alle Instanzen im Zeitraum, inklusive offener Einträge. Hilfreich für Fortschritt und offene Arbeit. | 30 vergangene Instanzen + 1 heutige offene Instanz = 31 insgesamt. |
| Überfällige Einträge | Anzahl offener Einträge, deren regulärer Tag vorbei ist. Besonders relevant bei Carryover. | 3 aufgestaute Instanzen sind überfällig. |
| Überfälligkeitstage | Wie viele Tage Einträge überfällig waren oder sind. Motiviert zu schneller Erledigung. | Eine Instanz wurde 2 Tage nach Fälligkeit erledigt. |
| Durchschnittliche Überfälligkeit | Durchschnittliche Verspätung bei erledigten oder noch offenen überfälligen Einträgen. | Im Schnitt 1,4 Tage zu spät. |
| Puffer-Nutzung | Zeigt, wie oft Aufgaben im Puffer erledigt wurden. | 4 Einträge wurden noch im Puffer abgeschlossen. |
| Manuell vs. automatisch abgeschlossen | Anteil der Einträge, die durch Nutzeraktion oder durch Missed Policy abgeschlossen wurden. | 20 manuell, 6 automatisch verarbeitet. |

### Einzelne einmalige Aufgaben

| Auswertung | Kurze Erklärung | Beispiel |
|---|---|---|
| Status | Aktueller Zustand der Aufgabe. | Offen, erledigt, Misserfolg oder Kein Eintrag. |
| Erstellt am | Zeitpunkt, an dem die Aufgabe erstellt wurde. | Erstellt am 15.07.2026 um 08:22 Uhr. |
| Zählt ab | Fachlicher Startpunkt der Aufgabe. Wenn ein Startdatum gesetzt ist, zählt dieses; sonst das Erstellungsdatum. | Startdatum 16.07.2026. |
| Projekt | Projektzuordnung der Aufgabe, inklusive Farbe. | Projekt „Haushalt“, blau markiert. |
| Fällig am | Fälligkeitstag, falls vorhanden. | Fällig am 20.07.2026. |
| Abgeschlossen am | Zeitpunkt, zu dem die Aufgabe endgültig abgeschlossen wurde. | Erledigt am 21.07.2026 um 10:15 Uhr. |
| Abschlussart | Ob die Aufgabe manuell oder automatisch abgeschlossen wurde. | Manuell erledigt oder automatisch als Misserfolg gespeichert. |
| Dauer bis Abschluss | Zeit vom fachlichen Start bis zum Abschluss. | Start 16.07., erledigt 20.07. = 4 Tage. |
| Abweichung vom Fälligkeitstag | Differenz zwischen Abschluss und Fälligkeit. Nur möglich, wenn ein Fälligkeitsdatum existiert. | 1 Tag zu spät oder 2 Tage früher. |
| Notizen | Sichtbare Notizen zur Aufgabe oder zum Eintrag. | „Erledigt, aber Rechnung noch prüfen.“ |

### Sammelauswertung für einmalige Aufgaben

| Auswertung | Kurze Erklärung | Beispiel |
|---|---|---|
| Anzahl aller einmaligen Aufgaben | Gesamtzahl der einmaligen Aufgaben im gewählten Zeitraum oder Projekt. | 42 einmalige Aufgaben im Juli. |
| Anzahl erledigt | Wie viele einmalige Aufgaben erfolgreich abgeschlossen wurden. | 30 erledigt. |
| Anzahl Misserfolge | Wie viele einmalige Aufgaben als nicht erfolgreich abgeschlossen wurden. | 4 nicht erledigt. |
| Anzahl offen | Wie viele einmalige Aufgaben noch offen sind. | 8 offen. |
| Rechtzeitig erledigt | Anteil oder Anzahl der Aufgaben, die spätestens am Fälligkeitstag erledigt wurden. | 24 von 30 erledigten Aufgaben waren rechtzeitig. |
| Vor / am / nach Fälligkeit erledigt | Gruppiert erledigte Aufgaben nach zeitlicher Abweichung. | 10 vorher, 14 am Fälligkeitstag, 6 danach. |
| Durchschnittliche Zeit bis Erledigung | Durchschnittliche Dauer vom Start/Erstellungsdatum bis Abschluss. | Im Schnitt nach 3,2 Tagen erledigt. |
| Durchschnittliche Abweichung vom Fälligkeitstag | Durchschnittliche Verspätung oder Verfrühung bei Aufgaben mit Fälligkeitsdatum. | Im Schnitt 0,8 Tage zu spät. |
| Durchschnittliche überfällige Tage aktuell offener Aufgaben | Zeigt, wie stark offene Aufgaben aktuell überfällig sind. | Offene überfällige Aufgaben sind im Schnitt 2,5 Tage drüber. |
| Manuell vs. automatisch abgeschlossen | Anteil manueller Abschlüsse gegenüber Missed-Policy-Abschlüssen. | 28 manuell, 6 automatisch. |

### Projekt-, Gesamt- und spätere Spezialauswertungen

| Auswertung | Kurze Erklärung | Beispiel |
|---|---|---|
| Projektauswertung | Fasst Aufgaben und Habits eines Projekts zusammen. | Projekt „Gesundheit“: 68 % Zielerreichung in diesem Monat. |
| Gesamtübersicht | Aggregiert mehrere Aufgabenarten, ohne Details einzelner Aufgaben zu verstecken. | Heute 12 offene Einträge, 7 erledigt, 2 überfällig. |
| Detailansicht einzelner Antworten | Liste der konkreten Instanzen mit Status, Datum und Notiz. | 16.07. Erfolg, 17.07. Kein Eintrag mit Notiz „krank“. |
| Rasteransicht | Visuelle Darstellung vieler Instanzen als Symbole oder Kästchen mit Statusfarbe. | Kalenderähnliches Raster: grün Erfolg, rot Misserfolg, grau Kein Eintrag. |
| Serien / Streaks | Zählt aufeinanderfolgende erfolgreiche oder eingeloggte Zeiträume. | 5 erfolgreiche Tage in Folge oder 12 Tage App-Check-in. |
| Log-in-Streak | Spätere Motivationsauswertung, die App-Nutzung statt Zielerfolg betrachtet. | 14 Tage hintereinander mindestens einen Eintrag gepflegt. |
| Aussagekraft-Hinweis | Hinweis, wenn eine Kennzahl leicht missverstanden werden kann oder viele Daten fehlen. | „Viele Einträge sind Kein Eintrag; prüfe die Detailansicht.“ |

### Einordnung dieser Spezialauswertungen

Diese Gruppe wird bewusst getrennt behandelt, damit Phase 11 nicht zu groß wird.

| Thema | Einordnung | Warum |
|---|---|---|
| Projektauswertung | später, vor allem Phase 18 | Projektauswertungen brauchen vorher klare Regeln zu Projektzuordnung, historischen Projektwechseln, gelöschten Projekten und Projektzeiträumen. |
| Gesamtübersicht | später oder eigener kleiner Ausbau | Eine einfache Tagesübersicht ist okay, aber echte Gesamtstatistiken über alle Aufgaben brauchen klare Aggregationsregeln. |
| Rasteransicht | mögliche Darstellung in Phase 11, falls klein genug | Raster nutzt vorhandene Instanzdaten und braucht meistens keine neuen gespeicherten Rohdaten. |
| Detailansicht einzelner Antworten | Phase 11-relevant | Nutzer sollen konkrete Einträge, Status und Notizen nachvollziehen können. |
| Serien / Streaks | später | Serien brauchen zusätzliche Regeln, z. B. ob `no_entry`, Puffer oder Carryover eine Serie brechen. |
| Log-in-Streak | später | Das bewertet App-Nutzung, nicht direkt Aufgabenerfolg. |
| Aussagekraft-Hinweis | Phase 11-relevant | Hinweise helfen, Kennzahlen wie `no_entry` oder wertende Quote nicht falsch zu verstehen. |

## Spätere Darstellungsform: Auswertungstabelle

Für die Detailansicht ist langfristig eine Tabelle sinnvoll, besonders wenn die
App später auch im Browser laufen soll.

Möglicher Aufbau:

| Auswertung | Kurze Erklärung | Wert im gewählten Zeitraum |
|---|---|---|
| Strenge Erfolgsquote | Info-Text direkt sichtbar oder per Info-Button. | `21,6 %`, zusätzlich `8 von 37`. |
| Erfolge | Anzahl erfolgreicher Einträge im Zeitraum. | `8`. |
| Kein Eintrag | Nur sichtbar, wenn die Aufgabe `no_entry` erzeugen kann. | `5`. |

Oberhalb der Tabelle wird der Zeitraum gewählt, zum Beispiel:

- letzte 7 Tage
- letzte 30 Tage
- seit Beginn
- später: eigener Zeitraum

Diese Tabellenansicht kann später als erweiterte Detailansicht oder Premium-
Darstellung ausgebaut werden. Die fachlichen Kennzahlen selbst bleiben aber die
Grundlage der App und dürfen nicht durch Premium-Logik anders berechnet werden.

### Bewusst nach hinten geschoben

| Auswertung | Warum nicht in Phase 11? | Spätere Phase |
|---|---|---|
| Zielerreichung | Ziele sollen auf fertigen Auswertungen aufbauen und keine eigene Rechenlogik bekommen. | Phase 14 |
| Auf Kurs | Gehört fachlich zur Zielbewertung laufender Zielzeiträume. | Phase 14 |
| Zielerreichungsquote | Bewertet, wie oft Zielzeiträume erfüllt wurden, und braucht fertige Zielbewertung. | Phase 14 |
| Summe, Durchschnitt, Minimum/Maximum von Zahlenwerten | Braucht zuerst Zahl-/Dauer-/Uhrzeit-Eingaben. | Phase 13 |
| Projektauswertung | Braucht Projektregeln, Projekt-Historisierung und Lösch-/Archivregeln. | Phase 18 |
| Echte Gesamtstatistiken über alle Aufgaben | Brauchen klare Aggregationsregeln über unterschiedliche Aufgabenarten hinweg. | später/eigene Unterphase |
| Serien / Streaks | Brauchen eigene Regeln zu Unterbrechungen, `no_entry`, Puffer und Carryover. | später |
| Log-in-Streak | Bewertet App-Nutzung statt Aufgabenerfolg. | später |

## Umgesetzter Ablauf

| Schritt | Inhalt | Status |
|---:|---|---|
| 11.1 | Vorhandene Grundauswertung und Detailansicht prüfen | erledigt |
| 11.2 | Status-Auswertungen für wiederkehrende Aufgaben/Habits finalisieren und Sichtbarkeit dokumentieren | erledigt |
| 11.3 | Auswertungen für einzelne einmalige Aufgaben finalisieren | erledigt |
| 11.4 | Sammelauswertung für einmalige Aufgaben planen und einfachen UI-Zugang schaffen | erledigt |
| 11.5 | Detailansicht einzelner Antworten, Notizen und einfache Raster/visuelle Ansicht planen | teilweise; Antwortliste/Raster später |
| 11.6 | Pflicht, optional, Premium-taugliche Darstellung und später trennen | erledigt |
| 11.7 | notwendige Kennzahlen, UI-Orte und Info-Texte dokumentieren | erledigt |
| 11.8 | Umsetzungsschritte und gezielte Tests ableiten | erledigt; Analyse grün, Tests extern empfohlen |

## Ergebnis

| Bereich | Stand |
|---|---|
| Wiederkehrende Aufgaben/Habits | Alle Kennzahlen aus der Tabelle werden in der Detailansicht als Auswertungsbereich angezeigt. Nicht verfügbare Werte werden ausgegraut erklärt. |
| Einzelne einmalige Aufgaben | Alle Felder/Auswertungen aus der Tabelle werden in der Aufgabenakte angezeigt. Nicht verfügbare Werte werden ausgegraut erklärt. |
| Sammelauswertung einmaliger Aufgaben | Eigene einfache Seite ist über den Header der Aufgabenansicht erreichbar. |
| Antwortliste/Raster | Fachlich notiert, aber nicht Teil dieser ersten Phase-11-Umsetzung. |
| Projekt-/Gesamt-/Spezialauswertungen | Nach hinten gestellt, vor allem Phase 18 oder eigene spätere Unterphase. |

## Offen für später

| Thema | Einordnung |
|---|---|
| Antwortliste einzelner Einträge mit Notizen | Spätere Erweiterung der Detailansicht. |
| Raster-/Kalenderansicht | Spätere visuelle Darstellung vorhandener Instanzen. |
| Projekt-Auswertung | Phase 18. |
| Gesamtstatistiken über alle Aufgabenarten | Später/eigene Unterphase. |
| Zielbewertung | Phase 14, nach erweiterten Eingaben und Wert-Auswertung. |
