# Momentum – Phase 11: Sichtbarkeit von Status-Auswertungen

Stand: 21. Juli 2026  
Status: Arbeitsdokument

## Zweck

Dieses Dokument legt fest, welche Status-Auswertungen bei wiederkehrenden
Aufgaben und Habits angezeigt werden sollen.

Die Grundidee:

- Eine Auswertung wird nicht nur berechnet, sondern vorher fachlich geprüft.
- Die App soll nicht überall `0` anzeigen, wenn eine Auswertung bei dieser
  Aufgabe gar nicht entstehen kann.
- `0` soll nur dann sichtbar sein, wenn es eine echte Aussage ist.

Beispiel:

- Eine Aufgabe kann `no_entry` erzeugen und hat im Zeitraum 0 Kein-Eintrag-Fälle.
  Dann ist `0` eine sinnvolle Information.
- Eine Aufgabe kann `no_entry` nie erzeugen. Dann soll „Kein Eintrag: 0“ nicht
  angezeigt werden, weil es keine echte Auswertung dieser Aufgabe ist.

## Grundprinzip

Jede Kennzahl bekommt zwei Entscheidungen:

1. Ist diese Kennzahl für diese Aufgabe fachlich verfügbar?
2. Wenn ja: Welcher Wert wird im gewählten Zeitraum berechnet?

Dadurch unterscheidet die App sauber zwischen:

| Fall | Bedeutung | UI-Verhalten |
|---|---|---|
| verfügbar, Wert `0` | Die Auswertung passt, aber es gab keinen entsprechenden Fall. | Anzeigen. |
| nicht verfügbar | Die Auswertung passt zu dieser Aufgabe nicht. | Ausgegraut anzeigen und kurz erklären. |
| verfügbar, aber erklärungsbedürftig | Die Auswertung passt, kann aber missverstanden werden. | Anzeigen mit Info-Hinweis. |

## Sichtbarkeitsmatrix für wiederkehrende Aufgaben und Habits

| Auswertung | Standard | Anzeigen, wenn … | Ausblenden, wenn … | Was bedeutet `0`? | Hinweis |
|---|---|---|---|---|---|
| Strenge Erfolgsquote | anzeigen | die Aufgabe wiederkehrende Status-Instanzen erzeugt. | keine fälligen abgeschlossenen Instanzen im Zeitraum vorhanden sind. | Keine Erfolge in der relevanten Grundmenge. | Standardquote. Wenn `no_entry` nicht möglich ist, ist sie besonders eindeutig. |
| Wertende Erfolgsquote | anzeigen | mindestens Erfolg/Misserfolg als aktive Antworten möglich sind. | es keine aktiven Ja-/Nein-Antworten im Zeitraum gibt. | Keine Erfolge unter aktiven Antworten. | Ergänzungswert zur strengen Quote; ignoriert `no_entry`. |
| Erfolge | anzeigen | Erfolg als Status möglich ist. | praktisch nie bei wiederkehrenden Status-Aufgaben. | Kein erfolgreicher Eintrag im Zeitraum. | Zählt nur `success`. |
| Misserfolge | anzeigen | Misserfolg als manuelle Antwort oder automatische Konsequenz möglich ist. | Misserfolg fachlich nie entstehen kann. | Kein Misserfolg im Zeitraum. | Zählt `failure`, egal ob manuell oder automatisch. |
| Kein Eintrag | bedingt anzeigen | die Aufgabe `no_entry` erzeugen kann, z. B. durch Missed Policy oder spätere Sondererfassung. | `no_entry` bei dieser Aufgabe nicht möglich ist. | Es gab keinen Kein-Eintrag-Fall, obwohl er möglich wäre. | Nicht als normale Null anzeigen, wenn `no_entry` gar nicht erlaubt ist. |
| Offen | anzeigen | es Instanzen geben kann, die noch `pending` sind. | praktisch nie bei wiederkehrenden Status-Aufgaben. | Keine offenen Instanzen im Zeitraum. | Laufende heutige Aufgaben zählen hier, aber nicht in Erfolgsquoten. |
| Beantwortete Instanzen | anzeigen | Erfolg oder Misserfolg als aktive Antwort möglich ist. | es fachlich keine aktiven Antworten gibt. | Keine aktive Ja-/Nein-Antwort im Zeitraum. | `no_entry` zählt hier bewusst nicht mit. |
| Abgeschlossene Instanzen | anzeigen | Instanzen finalisiert werden können. | keine Instanzen im Zeitraum vorhanden sind. | Keine abgeschlossene Instanz im Zeitraum. | Zählt `success`, `failure` und `no_entry`. |
| Fortschritt / Verarbeitung | anzeigen | erzeugte Instanzen im Zeitraum existieren. | keine Instanzen im Zeitraum existieren. | Keine Instanz wurde verarbeitet. | Verhältnis aus abgeschlossenen zu allen erzeugten Instanzen. |
| Fällige Instanzen | anzeigen | die Aufgabe eine terminierte oder fällige Wiederholung hat. | keine Instanzen im Zeitraum fällig werden können. | Keine fällige Instanz im Zeitraum. | Grundlage für Quoten. |
| Alle Instanzen | anzeigen | Instanzen im Zeitraum existieren können. | keine Instanzen im Zeitraum existieren. | Keine Instanz im Zeitraum. | Enthält auch offene Instanzen. |
| Überfällige Einträge | bedingt anzeigen | Überfälligkeit entstehen kann, z. B. bei Carryover, Puffer oder offenen abgelaufenen Instanzen. | die Aufgabe niemals überfällig bleiben kann. | Keine aktuell überfälligen Einträge. | Motivationswert, keine Erfolgsquote. |
| Überfälligkeitstage | bedingt anzeigen | Einträge überfällig werden oder zu spät abgeschlossen werden können. | Überfälligkeit bei der Aufgabe fachlich nicht entstehen kann. | Keine überfälligen Tage. | Kann für erledigte und aktuell offene Einträge relevant sein. |
| Durchschnittliche Überfälligkeit | bedingt anzeigen | mindestens ein überfälliger oder verspätet abgeschlossener Eintrag existiert. | Überfälligkeit nicht entstehen kann oder keine Daten vorhanden sind. | Nicht sinnvoll als `0`, wenn es keine überfälligen Fälle gab. | Eher ausblenden oder als „Keine überfälligen Fälle“ anzeigen. |
| Puffer-Nutzung | bedingt anzeigen | die Aufgabe eine Puffer-Policy hat. | kein Puffer konfiguriert ist. | Kein Eintrag wurde im Puffer abgeschlossen. | Zeigt, ob der Spielraum genutzt wurde. |
| Manuell vs. automatisch abgeschlossen | bedingt anzeigen | automatische Abschlüsse durch Missed Policy möglich sind oder bereits vorkamen. | nur manuelle Abschlüsse möglich sind. | Keine automatischen Abschlüsse oder keine manuellen Abschlüsse, abhängig vom Verhältnis. | Später hilfreich, um App-Nutzung und Automatik zu verstehen. |

## Normale Ansicht und erweiterte Ansicht

### Normale Ansicht

Die normale Detailansicht zeigt alle vorgesehenen Auswertungen der jeweiligen
Aufgabenart. Auswertungen, die für die konkrete Aufgabe nicht verfügbar sind,
werden ausgegraut und mit kurzem Grund erklärt.

Das ist etwas lehrreicher als vollständiges Ausblenden: Nutzende sehen, dass es
die Auswertung grundsätzlich gibt, aber warum sie bei dieser Aufgabe nicht
greift.

### Erweiterte Ansicht

Später kann es eine erweiterte oder Premium-taugliche Ansicht geben. Dort können
zusätzlich Filter, Tabellen, Sortierung oder längere Erklärungen ergänzt werden.

Beispiel:

| Auswertung | Status | Hinweis |
|---|---|---|
| Kein Eintrag | nicht verfügbar | Diese Aufgabe kann keine Kein-Eintrag-Fälle erzeugen. |
| Puffer-Nutzung | nicht verfügbar | Für diese Aufgabe ist kein Puffer eingestellt. |

Diese erweiterte Ansicht ist vor allem für Browser/Desktop sinnvoll, weil dort
mehr Platz für Tabellen und Erklärungen vorhanden ist.

## Technische Ableitung

Für die spätere Umsetzung sollte jede Kennzahl nicht nur einen Wert liefern,
sondern auch eine Sichtbarkeitsentscheidung.

Mögliche Struktur:

```text
MetricDefinition
- key
- title
- explanation
- isAvailable(taskDefinition)
- calculate(entries, period)
- emptyStateText
- infoText
```

Wichtig ist die Trennung:

- `isAvailable` entscheidet, ob die Kennzahl zur Aufgabe passt.
- `calculate` berechnet nur dann den Wert.
- `emptyStateText` erklärt Fälle, in denen die Kennzahl passt, aber keine Daten
  vorhanden sind.

## Noch zu klären

| Frage | Warum wichtig? | Vorschlag |
|---|---|---|
| Soll die normale Ansicht nicht verfügbare Auswertungen komplett ausblenden oder als „nicht verfügbar“ zeigen? | Ausblenden ist ruhiger, Anzeigen ist lehrreicher. | Geklärt: normal ausgegraut anzeigen und kurz erklären. |
| Wird „Durchschnittliche Überfälligkeit“ bei 0 überfälligen Fällen ausgeblendet oder als „Keine überfälligen Fälle“ angezeigt? | Eine echte `0,0 Tage` kann anders wirken als „nicht relevant“. | In der normalen Ansicht als positiver Hinweis anzeigen: „Keine überfälligen Fälle“. |
| Wann wird „Manuell vs. automatisch“ angezeigt? | Bei Aufgaben ohne Automatik ist die Kennzahl wenig hilfreich. | Nur anzeigen, wenn automatische Abschlüsse möglich sind oder bereits vorkamen. |
