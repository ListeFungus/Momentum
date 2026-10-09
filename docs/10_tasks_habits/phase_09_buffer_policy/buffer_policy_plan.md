# Momentum – Phase 9: Puffer-Missed-Policy

Stand: 17. Juli 2026  
Status: Abgeschlossen

Aktueller technischer Stand: Kernlogik, Validierung und Randfalltests sind
ergänzt. Die sichtbare Listenanzeige `Puffer Tag X/Y` wird bewusst mit Phase 10
Carryover umgesetzt.

## Zweck dieses Dokuments

Dieses Dokument ist die kurze Arbeitskarte für Phase 9. Der ausführliche Verlauf
steht in [`buffer_policy_history.md`](buffer_policy_history.md).

## Ziel von Phase 9

Die Puffer-Missed-Policy wird technisch umgesetzt.

Eine Instanz ist am regulären Fälligkeitstag sichtbar und fällig, wird aber nach
Ablauf dieses Tages nicht sofort automatisch abgeschlossen. Stattdessen bleibt
sie für eine festgelegte Anzahl von Puffertagen offen. Erst danach greift die
konfigurierte Folgeregel.

Puffer ist damit eine verzögerte Konsequenz und gibt Nutzenden bewusst Spielraum.

## Fachliche Leitplanken

| Regel | Bedeutung |
|---|---|
| Kein automatischer Erfolg | Auch nach einem Puffer darf nie automatisch Erfolg entstehen. |
| Puffer beginnt nach dem regulären Tag | Der erste Puffertag ist der Tag nach dem eigentlichen Fälligkeitstag. |
| Puffer endet nach X vollen Puffertagen | Danach greift beim Tageswechsel die konfigurierte Folgeregel. |
| Folgeregel ist Pflicht | Bei Puffer muss bei der Erstellung klar sein, was nach dem Puffer passiert. |
| Anzeige bleibt verständlich | Während des Puffers soll nicht einfach `−X Tage`, sondern z. B. `Puffer Tag 2/5` angezeigt werden. |
| Chaos verhindern | Puffer darf nicht unbegrenzt viele offene Instanzen erzeugen. |

## Beschlossene Regeln

### Beginn und Ende

Beispiel mit Fälligkeit am 16. und drei Tagen Puffer:

- 16.: regulärer Tag
- 17.: Puffertag 1
- 18.: Puffertag 2
- 19.: Puffertag 3
- 20. um 00:00 Uhr: Folgeregel greift

### Zulässige Folgeregeln nach dem Puffer

| Aufgabenart / Rhythmus | Zulässiges Verhalten |
|---|---|
| Kalendergebundene Rhythmen | Nach Puffer als `failure` oder `no_entry` abschließen. `keep_open` wird nicht als Pufferverhalten gespeichert, sondern entspricht Carryover. |
| Abschlussgebundene Rhythmen | Nach Puffer als `failure` oder `no_entry` abschließen. Wenn die Instanz unbegrenzt offen bleiben soll, wird keine automatische Abschlussregel verwendet. |
| Einmalige Aufgaben mit Fälligkeit | Nach Puffer als `failure` oder `no_entry` abschließen; ohne automatische Policy dürfen sie aber auch dauerhaft überfällig bleiben. |

Automatischer Erfolg bleibt ausgeschlossen.

`no_entry` ist erlaubt, muss aber mit einem klaren Hinweis angezeigt werden:

> Kein Eintrag zählt nicht als Erfolg und kann die Aussage der Auswertung
> verändern. Nutze diese Option nur, wenn fehlende Antworten neutral behandelt
> werden sollen.

### Puffer-Maximum

Für kalendergebundene Rhythmen darf der Puffer maximal bis zur übernächsten
Erstellung reichen.

Faustregel:

```text
maximaler Puffer = 200 % des regulären Abstands
```

Beispiele:

| Rhythmus | Abstand | Maximaler Puffer |
|---|---:|---:|
| täglich | 1 Tag | 2 Tage |
| alle 3 Tage | 3 Tage | 6 Tage |
| wöchentlich | 7 Tage | 14 Tage |

Ziel: Genug Kulanz, aber keine unkontrollierte Überfüllung der Übersicht.

### Überschneidung mit neuer Instanz

Wenn der Puffer bis in die nächste reguläre Instanz hineinreicht, ist das nicht
automatisch ungültig. Die UI muss aber klar warnen:

> Während die alte Instanz noch im Puffer ist, kann bereits eine neue Instanz
> entstehen.

### „Weiter offen lassen“ / `keep_open`

`keep_open` bedeutet: Die Instanz bleibt `pending` und ist weiterhin offen. Es
ist nicht dasselbe wie `no_entry`.

Für Phase 9 soll `keep_open` nicht als eigenes Pufferverhalten gespeichert
werden. Das spart Scheduler-Sonderlogik und hält die Fachregeln klar.

UI-Vorschlag:

- Wenn jemand „weiter offen lassen“ auswählt, erklärt die UI:
  „Das entspricht Aufstauen/Carryover.“
- Die App führt dann zur Carryover-Option oder verlangt, dass die Missed Policy
  auf Carryover geändert wird.
- Speichern als Puffer mit „weiter offen lassen“ ist nicht erlaubt.
- Wenn eine abschlussgebundene Aufgabe unbegrenzt offen bleiben soll, wird statt
  Puffer eine Konfiguration ohne automatische Abschlussregel verwendet.

### Abschlussgebundene Rhythmen

Bei `X Tage nach Abschluss` oder ähnlichen Rhythmen kann die bestehende Instanz
offen bleiben, weil ohnehin keine neue Instanz entsteht, bevor Erfolg oder
Misserfolg eingetragen wurde.

Hier ist Puffer vor allem für Auswertung und Anzeige sinnvoll:

- innerhalb des Puffers: `Puffer Tag 2/5`
- nach dem Puffer: je nach Folgeregel als `failure` oder `no_entry` abschließen
- innerhalb des Puffers zählt die Bearbeitung nicht als „zu spät“

## Geplanter Ablauf

| Schritt | Inhalt | Status |
|---:|---|---|
| 9.1 | Bestandsaufnahme: vorhandene Felder `missedBufferDays` und `postBufferBehavior` prüfen | erledigt |
| 9.2 | `no_entry` als erlaubte Folgeregel mit Warnhinweis festhalten; `keep_open` aus Puffer entfernen/umleiten | geklärt |
| 9.3 | Validierungsregeln für Puffer-Maximum und Folgeregel ergänzen | erledigt |
| 9.4 | UI-Hinweise für Puffer, Überschneidung und Carryover-Umleitung planen | erledigt; Listenanzeige folgt mit Phase 10 |
| 9.5 | Scheduler um Pufferverarbeitung erweitern | erledigt |
| 9.6 | Tests für Pufferende, Überschneidung, abschlussgebundene Rhythmen und Idempotenz ergänzen | erledigt und extern bestätigt |
| 9.7 | Dokumentation aktualisieren | erledigt |

## Aktueller Fortschritt

| Schritt | Stand |
|---|---|
| `mark_as_no_entry` als Puffer-Folgeregel | umgesetzt |
| `keep_open` aus neuen Puffer-Auswahlen entfernen | umgesetzt |
| Puffer-Maximum bei kalendergebundenen Rhythmen | umgesetzt: Abstand zur nächsten konkreten Instanz mal 2 |
| Monatsrhythmen | echte nächste Instanz wird berechnet, nicht pauschal 30 Tage |
| Scheduler-Verarbeitung | umgesetzt für `failure` und `no_entry` |
| UI-Auswahl nach Puffer | umgesetzt: nur Misserfolg oder Kein Eintrag |
| Anzeige `Puffer Tag X/Y` | fachlich beschlossen; vollständige Listenanzeige später mit Carryover/Phase 10 |
| Zusätzliche Randfalltests | ergänzt und extern bestätigt |

## Abschlussstand Phase 9

Phase 9 ist fachlich und technisch abgeschlossen, soweit es ohne die
vollständige Carryover-Listenlogik sinnvoll ist.

Erledigt:

- `no_entry` ist als Puffer-Folgeregel technisch vorhanden.
- `keep_open` ist kein gültiges neues Pufferverhalten mehr.
- Puffer-Folgeregeln sind nur `failure` oder `no_entry`.
- Das Puffermaximum wird bei kalendergebundenen Rhythmen aus dem echten Abstand
  zur nächsten Instanz berechnet und mal 2 genommen.
- Monatsrhythmen verwenden echte Folgetermine.
- Der Scheduler verarbeitet Puffer automatisch.
- Tests für Pufferende, Idempotenz, Überschneidung und abschlussgebundene
  Rhythmen sind ergänzt.

Bewusst verschoben:

- Die sichtbare Anzeige `Puffer Tag X/Y` in Tages- und Dringlichkeitslisten
  wird mit Phase 10 Carryover umgesetzt, weil dort ohnehin alte offene
  Instanzen, Sortierung und Mehrfachanzeigen sauber gelöst werden müssen.

## Nach Phase 9 noch zu beachten

| Frage | Warum wichtig? | Stand |
|---|---|---|
| Wie wird `Puffer Tag X/Y` sichtbar angezeigt? | Die Anzeige alter offener Instanzen, Puffer und Carryover hängt zusammen. | Fachlich geklärt; technische Umsetzung mit Phase 10. |

## Testnachweis

Extern in PowerShell ausgeführt:

```powershell
flutter test --no-pub test\features\aufgaben\data\aufgaben_repository_test.dart --plain-name "Puffer"
```

Ergebnis: `+5 All tests passed`.

## Nicht Teil von Phase 9

- Carryover/Aufstauen vollständig umsetzen
- Zielbewertung
- Papierkorb
- Unteraufgaben
- Firebase-Synchronisierung
- frei konfigurierbare Reset-Zeit

## Erfolgsbedingung

Phase 9 ist abgeschlossen, wenn:

1. Puffer nach dem regulären Tag korrekt startet,
2. die Folgeregel nach X vollen Puffertagen greift,
3. automatische Erfolge weiterhin ausgeschlossen sind,
4. ungültige Kombinationen nicht speicherbar sind,
5. `no_entry` als Puffer-Folgeregel erlaubt ist, aber mit Warnhinweis erscheint,
6. `keep_open` nicht als Puffer-Sonderlogik gespeichert wird,
7. Puffergrenzen die Übersicht vor zu vielen offenen Instanzen schützen,
8. gezielte Scheduler-/Repository-Tests grün sind.
