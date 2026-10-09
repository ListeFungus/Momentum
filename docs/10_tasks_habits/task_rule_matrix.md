# Momentum – Fachliche Regelmatrix für Aufgaben

> Übergangsquelle: Dieses Dokument enthält weiterhin viele Detailregeln, wird
> aber schrittweise in [`task_phase_history.md`](task_phase_history.md)
> integriert. Führend für Planung und aktuelle Fragen ist
> [`task_structure_plan.md`](task_structure_plan.md).

Stand: 8. Juli 2026  
Status: Fachlich abgeschlossene Regelmatrix – Version 1.1

## Zweck

Diese Datei beschreibt, welche Einstellungen einer Aufgabe sichtbar, auswählbar,
verpflichtend oder unzulässig sind. Sie ist die fachliche Grundlage für:

- Aufgabenerstellung und -bearbeitung
- zentrale Validierung vor dem Speichern
- automatische Korrektur ungültiger Kombinationen
- spätere Missed-Policy- und Auswertungslogik

Die Matrix beschreibt Fachregeln, nicht den aktuellen Implementierungsstand.
Mit Stand dieser Version enthält sie alle bisher bestätigten fachlichen Regeln
für Aufgaben, Instanzen, Status, Ziele, Missed Policies, Korrekturen und
Papierkorb. Reine Umsetzungsreihenfolgen, Firebase-Kostenregeln und andere
technische Leitplanken stehen im Aufgabenplan beziehungsweise Masterplan.

## Legende

| Zeichen | Bedeutung | Verhalten in der UI |
|---|---|---|
| `P` | Pflichtfeld | Sichtbar und auswählbar; Speichern ohne gültigen Wert gesperrt |
| `O` | Optional | Sichtbar und auswählbar |
| `A` | Automatisch | Sichtbar; Wert wird automatisch gesetzt |
| `G` | Gesperrt | Hauptfeld sichtbar und nicht bedienbar; abhängiges Folgefeld ausgeblendet |
| `B` | Bedingt | Regel wird in einer nachfolgenden Matrix genauer beschrieben |

## Verbindlich bestätigte Grundregeln

1. Aufgaben und Fragen werden positiv formuliert.
2. Bei der Ja-/Nein-Erfassung ist `Ja` immer die positive Antwort.
3. `Nein` ist eine aktive negative Antwort.
4. Keine Auswahl bedeutet `pending`, also offen beziehungsweise noch nicht beantwortet.
5. `Kein Eintrag` ist eine eigene nicht wertende Kategorie und niemals ein Erfolg.
6. Eine Missed Policy darf niemals automatisch `Ja` eintragen.
7. Es gibt kein Ziel, bei dem `Nein` als Erfolg definiert wird.
8. Das technische Feld `successValue` bleibt erhalten, wird derzeit aber immer
   auf `true` gesetzt.
9. Fachliche Hauptfelder bleiben bei einer Sperre sichtbar, sind vollständig
   gesperrt und zeigen eine kurze Begründung. Rein abhängige Folgefelder werden
   erst eingeblendet, wenn die vorherige Auswahl sie benötigt.
10. Wird ein gespeicherter oder ausgewählter Wert durch eine andere Einstellung
   ungültig, wird er automatisch auf einen gültigen Wert zurückgesetzt.
11. Eine fachlich ungültige Aufgabe darf nicht gespeichert werden.

## Erfassungsmodi

| Technischer Wert | Deutsche Bezeichnung | Mögliche Eingaben | Erfolg | Fehlschlag | Fehlende Daten |
|---|---|---|---|---|---|
| `checkbox` | Erledigt / Offen | erledigt, offen | erledigt | nach Missed Policy nicht erledigt | offener Eintrag |
| `three_state` | Ja / Nein | Ja, Nein, keine Auswahl | Ja | Nein | offener Eintrag |

### Konsequenzen nach Erfassungsmodus

| Erfassungsmodus | Als nicht erledigt / Nein markieren | Als Kein Eintrag werten | Als Ja markieren |
|---|---:|---:|---:|
| Erledigt / Offen | O | O | G |
| Ja / Nein | O | O | G |

Hinweis: `Kein Eintrag` ist keine prominente Standardantwort in der normalen
Ja-/Nein-Erfassung, kann aber als Ablauf-Konsequenz gewählt werden. Dann wird
eine nicht beantwortete, abgelaufene Instanz als `no_entry` abgeschlossen.
Wiederkehrende, aufstauende Aufgaben bleiben dagegen offen, solange das
Aufstau-Limit nicht überschritten ist.

## Instanzstatus

Jede geplante Instanz besitzt genau einen fachlichen Status. Eingabewert,
Status und Zielwertung bleiben getrennte Begriffe.

| Status | Bedeutung | Wertende Antwort | Endgültiger Abschluss | Folgetermin bei Rhythmus nach Abschluss |
|---|---|---:|---:|---:|
| `pending` | noch offen und ohne gespeicherte Interaktion | nein | nein | nein |
| `success` | erfolgreich erledigt beziehungsweise mit Ja beantwortet | ja, positiv | ja | ja |
| `failure` | nicht erledigt beziehungsweise mit Nein beantwortet | ja, negativ | ja | ja |
| `no_entry` | ohne wertende Antwort abgeschlossen; optional mit Grund oder Notiz | nein | nein | nein |

Keine Auswahl wird als `pending` gespeichert beziehungsweise belassen. Ein
bewusster oder automatisch entstandener `Kein Eintrag` wird dagegen als
`no_entry` gespeichert. Der Nutzer kann solche Einträge nachträglich mit Grund
oder Notiz ergänzen und bei Bedarf korrigieren. In der normalen Erfassung soll
dieser Weg nicht prominent neben `Ja` und `Nein` angeboten werden, sondern über
eine Zusatzaktion wie langes Drücken, Wischen oder ein Menü erreichbar sein.

Eine Notizänderung verändert den fachlichen Status nicht. `updatedAt` darf
deshalb nicht als Antwort- oder Abschlusszeitpunkt interpretiert werden.

## Rhythmusmatrix

| Rhythmus | Startdatum | Separates Fälligkeitsdatum | Rhythmus-Auswahl | Einzelne Instanzen | Zeitraumziele | Missed Policy |
|---|---:|---:|---:|---:|---:|---:|
| Einmalig | B | O | A | P | G | B |
| Täglich | P | G | A | P | O | B |
| Bestimmte Wochentage | P | G | P | P | O | B |
| Alle 7 Tage nach Erledigung | P | G | A | P | O | B |
| Bestimmte Monatstage | P | G | P | P | O | B |
| X Tage nach Erledigung | P | G | P | P | O | B |

### Rhythmusabhängige Pflichtangaben

| Rhythmus | Erforderliche Zusatzangabe | Gültige Werte | Standard |
|---|---|---|---|
| Einmalig | keine | – | – |
| Täglich | keine | – | – |
| Bestimmte Wochentage | mindestens ein Wochentag | Montag bis Sonntag | alle Wochentage |
| Alle 7 Tage nach Erledigung | keine | fest 7 Tage | 7 |
| Bestimmte Monatstage | mindestens ein Monatstag | 1 bis 28 und letzter Monatstag | 1 |
| X Tage nach Erledigung | Abstand | ganze Zahl ab 1 | 7 |

Der letzte Monatstag ist ein eigener Wert. Er darf nicht als fester 29., 30. oder
31. Tag modelliert werden.

## Datumsmatrix

| Situation | Startdatum | Fälligkeitsdatum | Anzeige vor Start | Tagesansicht |
|---|---:|---:|---:|---|
| Einmalig ohne Fälligkeit | A | O | G | nur in „Ohne Zeitdruck“ |
| Einmalig mit Fälligkeit | A | O | G | ab Fälligkeit bis zur Erledigung |
| Wiederkehrend | P | G | G | an jeder rhythmisch fälligen Instanz |

Standard für das Startdatum ist heute. Eine Abweichung kann auf „Heute“
zurückgesetzt werden. Der Tageswechsel bleibt fest bei 00:00 Uhr in der lokalen
Zeitzone. Zu diesem Zeitpunkt werden fällige automatische Konsequenzen und neue
Tagesinstanzen verarbeitet. Eine individuell verschiebbare Reset-Zeit ist nicht
vorgesehen.

Später kann stattdessen in den allgemeinen Einstellungen ein globales
Nachtragefenster gewählt werden, beispielsweise vier Stunden. Eine innerhalb
dieses Fensters nach Mitternacht nachgetragene Antwort kann in der Auswertung
noch als rechtzeitig für den Vortag gelten. Das Nachtragefenster verschiebt
weder den Kalendertag einer Instanz noch Scheduler, Missed Policy oder Puffer.

Am Tageswechsel werden zuerst abgelaufene Fristen und daraus folgende
Konsequenzen verarbeitet. Anschließend werden die Instanzen des neuen Tages
erzeugt. So bleibt eindeutig, welche Instanz zu welchem Auswertungstag gehört.

### Zentrale Instanzerzeugung

Fällige Instanzen dürfen nicht davon abhängen, ob der Nutzer eine bestimmte
Tagesansicht öffnet. Ein zentraler `TaskInstanceScheduler` gleicht beim
App-Start, bei Rückkehr aus dem Hintergrund und beim Tageswechsel alle seit dem
letzten erfolgreichen Lauf fälligen Zeitpunkte chronologisch ab.

Der Abgleich ist idempotent: Eine erneute Verarbeitung desselben Zeitraums darf
weder doppelte Instanzen noch veränderte Fachzustände erzeugen. Bei
kalendergebundenen Rhythmen wird jede tatsächlich fällige Instanz erzeugt. Bei
abschlussgebundenen Rhythmen bleibt dagegen höchstens eine Instanz offen und
ein Folgetermin entsteht erst nach Erfolg oder Misserfolg.

Die genaue automatische Verarbeitung von direkter Konsequenz, Puffer und
Aufstauen wird gemeinsam mit den jeweiligen Policies umgesetzt. Ein optionaler
Betriebssystem-Hintergrunddienst darf den Abgleich später ergänzen, ist aber
nicht Voraussetzung für einen korrekten Zustand nach längerer Nichtnutzung.

Die technische Umsetzung der **direkten Konsequenz** wird in Phase 8 geplant
und dokumentiert:
[`phase_08_direct_missed_policy/direct_missed_policy_plan.md`](phase_08_direct_missed_policy/direct_missed_policy_plan.md).

## Missed-Policy-Matrix

| Aufgabensituation | Keine | Direkte Konsequenz | Puffer | Aufstauen |
|---|---:|---:|---:|---:|
| Einmalig ohne Fälligkeitsdatum | P | G | G | G |
| Einmalig mit Fälligkeitsdatum | O | O | O | G |
| Täglich | O | O | O | O |
| Feste Wochentage | O | O | O | O |
| Alle 7 Tage nach Erledigung | O | O | O | G |
| Feste Monatstage | O | O | O | O |
| X Tage nach Erledigung | O | O | O | G |

Bei einer einmaligen Aufgabe ohne Missed Policy bleibt die Aufgabe nach dem
Fälligkeitsdatum offen. Sie wird weiterhin angezeigt, erhält die Kennzeichnung
`−X Tage` und steigt mit zunehmender Verspätung in der Priorität.

Bei einer wiederkehrenden Aufgabe ohne Missed Policy werden alte Instanzen
nicht automatisch abgeschlossen oder bewertet. Sie bleiben offen, während neue
Instanzen entstehen. Das entspricht einem unbegrenzten, nicht automatisch
begrenzten Offenbleiben. Die Policy `Aufstauen` unterscheidet sich davon durch
ein ausdrückliches Maximum und eine verpflichtende Konsequenz beim Überschreiten.

Wird für eine wiederkehrende Aufgabe `Keine Missed Policy` gewählt, zeigt die
Erstellung direkt unter dem Feld folgenden Hinweis:

> Nicht erledigte Einträge bleiben dauerhaft offen. Dadurch kann mit der Zeit
> ein großer Rückstand mit mehreren Karten derselben Aufgabe entstehen.

Der Hinweis blockiert das Speichern nicht.

Es gibt dafür keine automatische Obergrenze, Zusammenfassung oder Löschung.
Bei kalendergebundenen Rhythmen bleibt jede verpasste Instanz als eigene Karte
mit ihrem jeweiligen `−X Tage`-Wert sichtbar. Bei einer täglichen Aufgabe können
nach vier Wochen Nichtnutzung daher bis zu 28 offene Karten derselben Definition
vorhanden sein. Das ist beabsichtigt, weil jede Instanz unabhängig beantwortet
werden können muss.

### Abhängige Felder der Missed Policy

| Gewählte Policy | Direkte Konsequenz | Puffertage | Verhalten nach Puffer | Carryover-Maximum | Konsequenz bei Maximum |
|---|---:|---:|---:|---:|---:|
| Keine | G | G | G | G | G |
| Direkte Konsequenz | P | G | G | G | G |
| Puffer | G | P | P | G | G |
| Aufstauen | G | G | G | P | P |

Beim Aufstauen greift die Konsequenz erst, wenn das Maximum überschritten
wird. Deshalb ist die `Konsequenz bei Maximum` eine Pflichtangabe. Alle aufgestauten Instanzen
bleiben als eigenständige Aufgaben sichtbar und einzeln bearbeitbar. Der älteste
Eintrag wird besonders gekennzeichnet und besitzt die höchste Dringlichkeit.

Tägliches Aufstauen ist erlaubt. Die UI weist darauf hin, dass bei mehreren
verpassten Tagen schnell viele gleichartige Karten in der Übersicht entstehen.

### Zeitliche Bedeutung des Puffers

Beispiel: Fälligkeit am 16., Puffer drei Tage.

- 17.: erster Puffertag
- 18.: zweiter Puffertag
- 19.: dritter Puffertag
- 20. um 00:00 Uhr: Puffer ist abgelaufen; die ausgewählte Folgeregel greift

Der Puffer selbst ist keine Konsequenz und kein automatischer Abschluss. Er
gewährt zunächst zeitlichen Spielraum, insbesondere für die spätere Auswertung.
Bei der Erstellung muss deshalb zusätzlich festgelegt werden, was nach dem
Puffer geschieht:

| Verhalten nach Puffer | Ergebnis |
|---|---|
| Sofort als Misserfolg abschließen | Am Ende des Puffers wird ein negativer Abschluss gespeichert. |
| Bis zur manuellen Antwort offen lassen | Die Instanz bleibt mit `−X Tage` sichtbar, bis der Nutzer Erfolg oder Misserfolg einträgt. |

Ein automatischer Erfolg ist ausgeschlossen. `Kein Eintrag` beziehungsweise der
technische Status `no_entry` ist bei den Rhythmen `X Tage nach Erledigung` und
`7 Tage nach Erledigung` kein endgültiger Erfolg oder Misserfolg und startet
deshalb keinen neuen Abstand.

Bei kalendergebundenen Rhythmen darf ein Puffer über den nächsten regulären Termin
hinausreichen. In diesem Fall bleiben mehrere Instanzen gleichzeitig offen und
erscheinen mehrfach in der Übersicht. Sobald Puffer und nächster Termin zeitlich
überlappen, zeigt die UI vor dem Speichern einen entsprechenden Hinweis. Das ist
zulässig und kein Validierungsfehler.

Direkte Konsequenz und Puffer sind bei allen kalendergebundenen Rhythmen erlaubt:
täglich, an festen Wochentagen und an festen Monatstagen. Die Regel wird immer auf jede
einzelne Instanz angewendet. Ein neuer regulärer Termin verändert weder den
Puffer noch den Status einer älteren Instanz. Besonders bei täglichen Aufgaben
können dadurch mehrere Karten gleichzeitig offen sein; die Erstellung weist
darauf hin, sobald der Puffer den Abstand bis zur nächsten Instanz erreicht oder
überschreitet.

Bei `X Tage nach Erledigung` und `7 Tage nach Erledigung` entsteht erst nach
einem endgültigen Ergebnis ein neuer Termin. Ohne Erfolg oder Misserfolg gibt es
keinen Folgetermin, mit dem sich der Puffer überschneiden könnte. Bleibt die
Instanz nach dem Puffer offen, wird sie mit `−X Tage` gekennzeichnet.

Auch bei langer Nichtnutzung der App bleibt genau diese eine Instanz offen. Es
werden für den verstrichenen Zeitraum keine zusätzlichen Instanzen erzeugt.
Beispiel: Wird die App vier Wochen nicht verwendet, ist danach weiterhin nur
die ursprüngliche Instanz offen. Wird sie dann manuell als Misserfolg markiert,
beginnt an diesem Eingabezeitpunkt der Abstand bis zur nächsten Instanz.

Der neue Abstand beginnt am Zeitpunkt des endgültigen Abschlusses: bei einer
manuellen Antwort an deren Eingabezeitpunkt, bei einem automatischen Misserfolg
am dafür ausgewählten Stichtag. Fachlich handelt es sich damit genauer um einen
Rhythmus `X Tage nach Abschluss`; die bisherige Bezeichnung `nach Erledigung`
kann in der UI weiterhin verständlich formuliert werden.

Dieser Rhythmus besitzt zwar einen festen Tagesabstand, ist aber nicht
kalendergebunden. Er wird deshalb als **abschlussgebundener Intervallrhythmus**
bezeichnet. Der Zeitpunkt des nächsten Termins hängt vom tatsächlichen Abschluss
der aktuellen Instanz ab.

Für die Erstellung sind zwei verständliche Verhaltensweisen vorgesehen:

1. **Bis zum Abschluss offen lassen:** keine automatische Konsequenz; die
   Instanz bleibt mit `−X Tage` bestehen und blockiert den Folgetermin.
2. **Am Stichtag als Misserfolg abschließen:** direkte Konsequenz oder Puffer
   mit der Folgeregel `Sofort als Misserfolg abschließen`.

Diese Verhaltensweisen werden durch Rhythmus und Missed Policy abgebildet und
sollen nicht als unabhängige, doppelte Speichereinstellung entstehen.

## Zielmatrix

| Zieltyp | Einmalige Aufgabe | Wiederkehrende Aufgabe | Wert | Zeitraum | Ausrichtung |
|---|---:|---:|---|---:|---:|
| Kein Ziel, nur Tracking | P | O | G | G | G |
| Anzahl pro Zeitraum | G | O | ganze Zahl ab 1 | P | P |
| Prozentziel | G | O | 1 bis 100 Prozent | P | P |
| Maximale Fehlschläge | G | O | ganze Zahl ab 0 | P | P |
| X Erfolge in letzten X Tagen | G | O | zwei ganze Zahlen ab 1 | rollierend | G |

`Wiederkehrend` beschreibt hier die Aufgabe beziehungsweise ihre geplanten
Instanzen. Es bedeutet nicht, dass ein Ziel nach dem Erreichen neu erstellt oder
„wieder ausgeschrieben“ wird. Ziele sind dynamische Regeln, die fortlaufend auf
der aktuellen Auswertung der relevanten Einträge geprüft werden.

Beispiel: Bei einem rollierenden Prozentziel von 60 Prozent für die letzten zehn
Tage ist das Ziel aktuell nicht erreicht, wenn die Auswertung momentan 50 Prozent
ergibt. Mit jedem neuen oder korrigierten Eintrag wird der Status neu berechnet.

### Zielzeiträume

| Zeitraum | Kalenderausrichtung | Alternative Ausrichtung |
|---|---|---|
| Woche | Wochenbeginn, derzeit Montag | ab Startdatum |
| Monat | Monatsbeginn, der Erste | ab Startdatum |

Ein Ziel von 100 Prozent entspricht „jeden fälligen Tag“. Dafür wird kein
eigener Zieltyp benötigt.

### Kein Eintrag in Auswertungen

- `Kein Eintrag` ist die UI-Bezeichnung für den technischen Status `no_entry`.
- `no_entry`-Einträge zählen weder als Erfolg noch als aktiver Fehlschlag.
- Bei einem absoluten Ziel können genügend Erfolge das Ziel erfüllen, auch wenn
  weitere Einträge mit `Kein Eintrag` existieren.
- `no_entry`-Einträge werden getrennt ausgewiesen.
- Eine Erfolgsquote muss offene Einträge und `Kein Eintrag` sichtbar machen.
- Bei vielen offenen Einträgen oder vielen Einträgen mit `Kein Eintrag` weist
  die Analyse später auf eingeschränkte Aussagekraft hin.

## Auswertung als Grundlage der Ziele

Die Auswertungslogik wird fachlich vor der Zielbewertung definiert und
implementiert. Ziele verwenden anschließend dieselben berechneten Kennzahlen und
führen keine parallele Berechnung ein.

### Geplante Grundkennzahlen

| Kennzahl | Bedeutung |
|---|---|
| Geplante Instanzen | alle im Zeitraum fälligen Einträge |
| Beantwortete Instanzen | wertende Antworten, also Erfolge und Misserfolge |
| Erfolge | erledigt beziehungsweise Ja |
| Misserfolge | nicht erledigt beziehungsweise Nein |
| Kein Eintrag | abgelaufene oder bewusst gesetzte `no_entry`-Instanzen |
| Noch offene Einträge | Instanzen mit `pending`, also ohne gespeicherte Antwort |
| Erfolgsquote | Erfolge im Verhältnis zur fachlich festgelegten Bezugsmenge |
| Vollständigkeitsquote | beantwortete Einträge im Verhältnis zu fälligen Einträgen |
| Gesamtentwicklung | zeitlicher Verlauf der Kennzahlen |

Die genaue Bezugsmenge von Prozentwerten und spätere Warnschwellen bei vielen
offenen Einträgen oder vielen Einträgen mit `Kein Eintrag` werden im
Auswertungskonzept festgelegt.

### Kennzahl auf der Aufgabenkarte

Seit Phase 15 kann pro Aufgabe/Habit beziehungsweise Bündel ausgewählt werden,
welche kompakte Kennzahl direkt in der Übersicht erscheint. Der erste Katalog
enthält beispielsweise:

- strenge Erfolgsquote oder Erfolgsanzahl im gewählten Zeitraum
- Durchschnitt oder Summe bei passenden Wertarten
- Wert beziehungsweise Status der dargestellten Instanz
- Bündelergebnis des dargestellten Tages
- passend zum am Stichtag gültigen Ziel
- keine Kennzahl

Diese Auswahl ist reine Darstellung. Sie verändert weder Rohdaten noch Ziel- und
Auswertungslogik und erzeugt keine fachliche Definitionsversion. Eine
ausführliche Analyse bleibt davon getrennt. Die erste UI zeigt einen Wert; die
gespeicherte Listenstruktur kann später einen zweiten Wert aufnehmen.

## UI-Verhalten bei ungültigen Kombinationen

Eine Kombination wird gesperrt, wenn das Feld für die gewählte Konfiguration
keine fachliche Bedeutung besitzt oder kein eindeutiges, konsistentes Speicher-
und Auswertungsverhalten definiert werden kann. Eine fachlich gültige, aber
möglicherweise unpraktische Kombination bleibt auswählbar und erhält nur einen
Hinweis.

Beispiele für Sperren sind ein automatischer Erfolg als Missed-Konsequenz, ein
separates Fälligkeitsdatum bei wiederkehrenden Instanzen oder Aufstauen bei einem
abschlussgebundenen Intervallrhythmus. Beispiele für reine Hinweise sind ein
langer Puffer mit überlappenden Instanzen und ein unbegrenzter Rückstand ohne
Missed Policy.

| Fall | Verhalten |
|---|---|
| Fachliches Hauptfeld ist nicht anwendbar | Feld sichtbar, deaktiviert und kurz begründet |
| Abhängiges Folgefeld wird nicht benötigt | Feld vollständig ausblenden |
| Keine Option ist zulässig | Wertanzeige „Keine Auswahl möglich“ |
| Gesperrtes Dropdown wird angetippt | Liste wird nicht geöffnet |
| Erklärung erforderlich | Kurzer Hilfetext direkt unter dem Feld |
| Vorherige Auswahl wird ungültig | Sofort auf gültigen Standard zurücksetzen |
| Pflichtwert fehlt | Speichern deaktivieren und Feldhinweis anzeigen |
| Ungültiger Wert erreicht Repository | Speichern mit fachlichem Fehler ablehnen |

## Abschluss und rückwirkende Korrekturen

### Herkunft und Zeitpunkt eines Abschlusses

Bei jedem endgültigen Erfolg oder Misserfolg werden mindestens folgende
Rohinformationen gespeichert:

- endgültiger Status: Erfolg oder Misserfolg
- Zeitpunkt, zu dem der Status wirksam wurde
- Herkunft: manuelle Eingabe oder automatische Missed Policy
- tatsächlicher Eingabe-/Verarbeitungszeitpunkt
- bei Automatik: angewendete Policy und Konsequenz

Damit können spätere Auswertungen zwischen Nutzerinteraktionen und automatischen
Abschlüssen unterscheiden. Ein `no_entry`-Eintrag ist eine gespeicherte
nicht wertende Antwort, optional mit Grund, aber keine positive oder negative
Antwort und kein endgültiger Erfolg oder Misserfolg. Bei einem
abschlussgebundenen Intervallrhythmus darf er deshalb keine neue Instanz
auslösen.

### Nachträgliche Statusänderung

Vergangene Instanzen bleiben nachträglich bearbeitbar, beispielsweise wenn die
App zum ursprünglichen Zeitpunkt nicht geöffnet werden konnte.

Sobald aus einem Eintrag eine Folgeinstanz entstanden ist, wird deren Termin
eingefroren. Eine spätere Korrektur des alten Eintrags verändert nur dessen
Status und spätere Auswertung. Bereits erzeugte Folgeinstanzen und deren Termine
werden weder verschoben, neu berechnet noch gelöscht.

Existiert noch keine Folgeinstanz, darf der korrigierte endgültige Abschluss
weiterhin als Ausgangspunkt für den nächsten Termin dienen. Kalendergebundene
Instanzen verschieben sich durch eine Statuskorrektur grundsätzlich nicht.

### Sammelkorrekturen nach geänderter Aufgabenlogik

Neben der Korrektur einzelner Instanzen soll es später eine bewusste
Sammelkorrektur geben. Sie wird benötigt, wenn Nutzende nach längerer Nutzung
merken, dass bisherige neutrale Einträge fachlich doch als Misserfolg gewertet
werden sollen.

Beispiel:

- Eine Aufgabe erzeugte bisher viele `no_entry`-Einträge.
- Später wird klar, dass diese Aufgabe eigentlich immer nur `success` oder
  `failure` haben sollte.
- Der Nutzer soll dann alle oder ausgewählte `no_entry`-Einträge nachträglich
  zu `failure` ändern können.

Mögliche Auswahlarten:

- einzelne vergangene Antworten
- mehrere manuell ausgewählte Antworten
- alle Antworten in einem Zeitraum
- alle Antworten mit einem bestimmten Status, z. B. alle `no_entry`-Einträge
  einer Aufgabe

Wird eine Aufgabendefinition so geändert, dass künftig kein `no_entry` mehr
entstehen soll, während historische `no_entry`-Einträge existieren, soll die UI
darauf hinweisen. Die App soll dann fragen, ob die alten Einträge unverändert
bleiben oder gesammelt in einen passenden Status, zum Beispiel `failure`,
überführt werden sollen.

Solche Sammelkorrekturen dürfen nicht stillschweigend durch die Änderung der
Aufgabendefinition passieren. Sie sind eine eigene, bewusste Nutzeraktion und
müssen für spätere Auswertungen nachvollziehbar bleiben.

## Versionierte Aufgabendefinitionen

Änderungen überschreiben die frühere Aufgabendefinition nicht. Sie erzeugen eine
vollständige neue Definitionsversion mit eigener stabiler Text-ID,
Versionsnummer, `previousVersionId` und Gültigkeitsbeginn. Die dauerhafte
`taskId` bleibt gleich und verbindet alle Versionen derselben Aufgabe. Jede neue
Instanz verweist auf die Version, die bei ihrer Erzeugung gültig war. Bereits
vorhandene Instanzen behalten ihre bisherige Versions-ID.

Der vollständige Snapshot enthält insbesondere:

- Name, Beschreibung und Fragetext
- damalige Projektzuordnung als Projekt-ID
- Aufgabentyp und Erfassungsmodus
- Erfolgsdefinition
- Rhythmus, aktive Wochen-/Monatstage sowie Start-, End- und Fälligkeitsdatum
- Missed Policy, Konsequenz, Pufferverhalten und Carryover-Grenze
- Zieltyp, Zielwert, rollierendes Fenster, Zielzeitraum und Ausrichtung

Jede tatsächliche Änderung eines dieser Werte erzeugt genau eine neue Version.
Unverändertes Speichern erzeugt keine Version. Projektzuweisungen über die
Projektverwaltung werden erst nach Abschluss der gesamten Transaktion
versioniert, damit keine künstliche Zwischenversion entsteht.

Die Projekt-ID friert die damalige Zuordnung ein. Ob später zusätzlich der
damalige Projektname und die damalige Projektfarbe angezeigt werden sollen,
gehört zur gesonderten Versionierung von Projekten.

### Auswertung über mehrere Versionen

Eine Aufgabe behält trotz mehrerer Definitionen eine zusammenhängende
Gesamtauswertung. Gemeinsame Rohkennzahlen wie geplante Instanzen, Erfolge,
Misserfolge, `Kein Eintrag` und Vollständigkeit dürfen über alle Versionen
zusammengeführt werden.

Zielerreichung wird zweistufig berechnet:

1. Jeder Zielzeitraum wird anhand der damals gültigen Definitionsversion
   bewertet.
2. Anschließend dürfen die Ergebnisse als Anteil erreichter Zielzeiträume
   zusammengeführt werden.

Beispiel: Unter Version 1 wurden 8 von 10 Wochen mit dem Ziel `3 Erfolge`
erreicht, unter Version 2 wurden 6 von 10 Wochen mit dem Ziel `5 Erfolge`
erreicht. Die gemeinsame Zielerreichung beträgt 14 von 20 Zeiträumen
beziehungsweise 70 Prozent. Es wird kein künstliches gemeinsames Ziel von vier
Erfolgen gebildet, weil dieses Ziel nie gegolten hat.

Versionswechsel werden im Verlauf markiert. Optional kann die Auswertung nach
Version gefiltert werden. Sind Kennzahlen fachlich nicht vergleichbar, zeigt die
App getrennte Abschnitte oder einen verständlichen Hinweis statt einer
irreführenden Gesamtsumme.

## Löschen und Papierkorb

Gelöschte Aufgaben werden zunächst nicht physisch entfernt, sondern in den
Papierkorb verschoben. Der Begriff `Archiv` wird dafür nicht verwendet, weil ein
Archiv langfristige Aufbewahrung bedeutet und der Papierkorb eine spätere
endgültige Löschung vorsieht.

Gelöscht wird immer die gesamte Aufgabendefinition. Bei einer wiederkehrenden
Aufgabe umfasst das die komplette Kette mit allen bereits vorhandenen
Instanzen. Eine einzelne Instanz innerhalb einer wiederkehrenden Aufgabe kann
nicht gelöscht werden. Sie kann nur beantwortet oder über die vorgesehenen
Korrekturfunktionen geändert werden.

| Aktion | Verhalten |
|---|---|
| Aufgabe löschen | Gesamte Aufgabendefinition beziehungsweise Kette und alle vorhandenen Einträge werden als gemeinsamer Snapshot in den Papierkorb verschoben. |
| Einzelne wiederkehrende Instanz löschen | Nicht möglich; stattdessen Status beantworten oder korrigieren. |
| Aufgabe im Papierkorb | Eingefrorener Snapshot; in regulären Ansichten unsichtbar und ohne neue Instanzen. |
| Wiederherstellen | Aufgabe und zugehörige Einträge werden wieder aktiviert. |
| Endgültig einzeln löschen | Ausgewählte Aufgabe wird nach Bestätigung dauerhaft entfernt. |
| Papierkorb leeren | Alle enthaltenen Aufgaben werden nach deutlicher Bestätigung dauerhaft entfernt. |
| Frist abgelaufen | Aufgabe wird beim regulären Bereinigungszeitpunkt dauerhaft entfernt. |

Die Standard-Aufbewahrungszeit beträgt sieben Tage. Sie kann später in den
allgemeinen Einstellungen global auf einen Wert von 1 bis maximal 30 Tagen
angepasst werden. Eine Option `Nie automatisch löschen` gibt es nicht; dafür ist
ein Papierkorb nicht vorgesehen. Im Papierkorb werden das geplante endgültige
Löschdatum und die verbleibende Zeit angezeigt.

Eine endgültige Löschung ist nicht durch Undo rückgängig zu machen und benötigt
deshalb immer eine ausdrückliche Bestätigung. Der Papierkorb ist über einen
eigenen Bereich erreichbar und erlaubt Wiederherstellung, einzelne endgültige
Löschung und vollständiges Leeren.

### Terminplan nach Wiederherstellung

Die Wiederherstellung benötigt keine zusätzliche Auswahl:

- Aufgabendefinition und alle beim Löschen bereits vorhandenen Einträge werden
  in ihrem damaligen Zustand wiederhergestellt.
- Für die Zeit im Papierkorb werden keine verpassten Instanzen nachträglich
  erzeugt.
- Kalendergebundene Aufgaben setzen ihren Rhythmus ab dem
  Wiederherstellungszeitpunkt fort.
- Abschlussgebundene Intervallaufgaben erhalten ihre zuvor offene Instanz
  zurück. Ein neuer Abstand beginnt weiterhin erst nach deren endgültigem
  Abschluss.
- Eine einmalige Aufgabe behält ihr ursprüngliches Fälligkeitsdatum und wird
  gegebenenfalls direkt als überfällig angezeigt.

Bereits vor dem Löschen offene Instanzen werden mit wiederhergestellt und können
daher erneut als Rückstand erscheinen. Nur die Zeit innerhalb des Papierkorbs
erzeugt keinen zusätzlichen Rückstand.

### Pausieren und Fortsetzen

Pausieren ist vom Löschen getrennt. Es bewahrt Aufgabe, Historie und reguläre
Auswertungsbeiträge, verhindert aber neue Pflichtplanung ab dem folgenden
Kalendertag. Bereits vorhandene offene Einträge behalten Frist und Konsequenz.
Fortsetzen gilt ab dem aktuellen Tag; für Pausen- oder Papierkorbtage wird
nichts nachgeplant. Zielblöcke und Live-Zielfenster, die einen ausgesparten Tag
schneiden, werden neutral als „Pausiert – nicht bewertet“ behandelt.

Während einer Pause darf freiwillig ein echter Wert oder eine Antwort erfasst
werden. Dieser Eintrag bleibt auswertbar, beendet die Pause nicht und erzeugt
keine Pflicht, Missed Policy oder Nachplanung für andere Pausentage.

### Bündel im Lebenszyklus

Ein Tracking darf gleichzeitig in mehreren Bündeln verwendet werden. Aufgaben
und Bündel besitzen getrennte Papierkorbzustände: Das Löschen eines Bündels
ändert seine Quellen nicht; das Löschen einer Quelle löscht weder andere
Quellen noch referenzierende Bündel. Solange eine Quelle im Papierkorb liegt
oder endgültig fehlt, ist das Bündelergebnis nicht berechenbar und wird mit
einem Grund statt mit einem Nullwert angezeigt. Nach Wiederherstellung werden
vorhandene Quelldaten innerhalb der gespeicherten Bündelgültigkeit wieder
verwendet.

## Verbindliche automatische Rücksetzungen

| Auslösende Änderung | Ungültig gewordener Wert | Neuer Wert |
|---|---|---|
| Rhythmus wird einmalig | Zeitraumziel | kein Ziel |
| Rhythmus wird wiederkehrend | separates Fälligkeitsdatum | kein Fälligkeitsdatum |
| Missed Policy wird „keine“ | Konsequenz und Zahlenwerte | technisch auf Standard, UI gesperrt |
| Missed Policy wird „direkt“ | Puffer/Carryover-Werte | technisch auf Standard, UI gesperrt |
| Missed Policy wird „Puffer“ | Carryover-Maximum | technisch auf Standard, UI gesperrt; Verhalten nach Puffer wird Pflicht |
| Missed Policy wird „Aufstauen“ | Pufferdauer | technisch auf Standard, UI gesperrt |
| Erfassungsmodus oder Missed Policy ändert sich | ungültige Konsequenz | auf gültige Konsequenz zurücksetzen |
| Beliebiger Erfassungsmodus | Konsequenz „Ja“ | niemals zulassen |

Technische Standardwerte gesperrter Felder dürfen fachlich nicht ausgewertet
werden. Entscheidend ist immer die aktive Policy beziehungsweise der aktive
Zieltyp.

## Ausgelagerte Fragen und Themen

Offene Fragen, Auswertungsdetails, Versionierung und andere bewusst vertagte
Themen werden ausschließlich im
[`task_structure_plan.md`](task_structure_plan.md) gepflegt. Diese Regelmatrix
enthält nur bestätigte Fachregeln und unmittelbar benötigte Abhängigkeiten.

## Pflegehinweise

Bei einer neuen Funktion werden in dieser Reihenfolge aktualisiert:

1. Grundregel oder Begriff ergänzen.
2. Betroffene Matrixzeilen erweitern.
3. Automatische Rücksetzung definieren.
4. UI-Hinweis formulieren.
5. Offene Entscheidung im Planungsdokument dokumentieren; bestätigte Regel
   anschließend hier eintragen.
6. Erst nach fachlicher Freigabe die zentrale Validierungslogik anpassen.

Verbindliche Regeln und offene Empfehlungen dürfen nicht vermischt werden.
