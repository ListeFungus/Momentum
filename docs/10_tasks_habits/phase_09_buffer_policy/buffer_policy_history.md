# Momentum – Phase 9: Verlauf und aktueller Stand

Stand: 17. Juli 2026  
Status: Abgeschlossen

## Zweck dieses Dokuments

Dieses Dokument hält fest, was in Phase 9 geprüft, entschieden und umgesetzt
wurde.

Abgrenzung:

- [`buffer_policy_plan.md`](buffer_policy_plan.md): kurze Arbeitskarte mit
  Ablauf und offenen Punkten.
- Dieses Dokument: Verlauf, Entscheidungen, betroffene Dateien und spätere
  Prüfergebnisse.

## Ausgangslage vor Phase 9

Bereits vorhanden:

- Statusmodell aus Phase 6:
  - `pending`
  - `success`
  - `failure`
  - `no_entry`
- automatische Herkunft und Policy-Metadaten
- `TaskInstanceScheduler`
- direkte Missed-Konsequenz aus Phase 8
- gespeicherte Felder für Puffer:
  - `missedBufferDays`
  - `postBufferBehavior`

Noch nicht umgesetzt:

- automatische Pufferverarbeitung im Scheduler
- vollständige Validierung des Puffer-Maximums
- UI-Hinweise für Pufferüberschneidung und Carryover-Umleitung

## Geklärte Regeln zum Start

### Pufferbeginn

Der Puffer beginnt nach Ablauf des letzten regulären Tages. Das ist dieselbe
Tageswechsel-Logik wie bei direkter Konsequenz.

Beispiel:

- Fälligkeit: 16.
- Am 17. um 00:00 Uhr ist der reguläre Tag vorbei.
- Der 17. ist Puffertag 1.

### Pufferende

Nach der gewählten Anzahl voller Puffertage greift die Folgeregel.

Beispiel mit drei Puffertagen:

- 17.: Puffertag 1
- 18.: Puffertag 2
- 19.: Puffertag 3
- 20. um 00:00 Uhr: Folgeregel

### Folgeregel ist Pflicht

Bei Puffer muss bei der Erstellung angegeben werden, was nach dem Puffer
passiert.

Automatischer Erfolg ist nicht erlaubt.

Erlaubte automatische Folgeregeln nach dem Puffer:

- als Misserfolg abschließen (`failure`)
- als Kein Eintrag abschließen (`no_entry`)

`no_entry` ist erlaubt, muss in der UI aber mit einem Hinweis versehen werden,
weil es die Auswertung neutralisiert beziehungsweise die Aussage verändern kann.

### Puffer ist Spielraum

Puffer bedeutet nicht, dass die Aufgabe egal ist. Die App erinnert weiterhin an
die Fälligkeit, gibt aber noch eine definierte Kulanzzeit.

Innerhalb des Puffers soll die UI verständlich anzeigen, dass die Aufgabe zwar
fällig war, aber noch im erlaubten Spielraum liegt.

Beispiel:

```text
Puffer Tag 2/5
```

### Puffer-Maximum

Für kalendergebundene Rhythmen wird der Puffer begrenzt:

```text
maximaler Puffer = 200 % des regulären Abstands
```

Damit darf der Puffer maximal bis zur übernächsten regulären Erstellung reichen.

Beispiele:

- täglich: maximal 2 Tage Puffer
- alle 3 Tage: maximal 6 Tage Puffer
- wöchentlich: maximal 14 Tage Puffer

Grund: Nutzer sollen genug Spielraum haben, aber die Übersicht darf nicht durch
sehr viele offene Instanzen unbenutzbar werden.

### Kalendergebundener Puffer und neue Instanzen

Bei festen Rhythmen können neue Instanzen entstehen, während eine ältere Instanz
noch im Puffer ist.

Das ist erlaubt, aber erklärungsbedürftig.

Die UI soll warnen, wenn der Puffer bis in die nächste Aufgabenerstellung
hineinreicht.

### „Weiter offen lassen“ / `keep_open`

`keep_open` bedeutet nicht `no_entry`.

- `keep_open`: Instanz bleibt offen (`pending`).
- `no_entry`: Instanz wird abgeschlossen, aber ohne wertende Ja-/Nein-Antwort.

Für Phase 9 gilt:

- `keep_open` soll nicht als Puffer-Sonderlogik gespeichert werden.
- Wenn eine kalendergebundene Instanz nach Ablauf offen bleiben soll, ist das
  fachlich Carryover.
- Wenn eine abschlussgebundene Instanz unbegrenzt offen bleiben soll, wird keine
  automatische Abschlussregel verwendet.

Entscheidung:

- Puffer speichert diesen Fall nicht als eigene Sonderlogik.
- Die UI soll erklären, dass „weiter offen lassen“ bei kalendergebundenen
  Rhythmen Aufstauen/Carryover bedeutet.
- Die Aufgabe muss dann als Carryover konfiguriert werden, oder die Auswahl ist
  nicht speicherbar.

### Abschlussgebundene Rhythmen

Bei Rhythmen nach Abschluss entsteht keine Massenbildung, weil keine neue
Instanz erzeugt wird, bevor die alte durch Erfolg oder Misserfolg abgeschlossen
ist.

Puffer ist hier trotzdem sinnvoll, wenn nach dem Puffer automatisch entschieden
werden soll:

- Innerhalb des Puffers gilt die Bearbeitung nicht als verspätet.
- Die UI zeigt Pufferstatus statt `−X Tage`.
- Nach dem Puffer greift eine Abschlussregel: `failure` oder `no_entry`.
- Wenn die Instanz unbegrenzt offen bleiben soll, wird statt Puffer eine
  Konfiguration ohne automatische Abschlussregel verwendet.

## Risiken und Abgrenzungen

### Risiko: Monatsrhythmen

Das 200-%-Limit darf bei Monatsrhythmen nicht naiv mit 30 Tagen berechnet
werden. Der tatsächliche nächste und übernächste Termin muss anhand des Rhythmus
berechnet werden.

### Risiko: Begriffe in der UI

Nutzende sollen nicht alle Fachbegriffe kennen müssen. Deshalb sollte die UI bei
„weiter offen lassen“ verständlich erklären:

> Das ist Aufstauen/Carryover.

Die technische Speicherung darf trotzdem eindeutig bleiben.

## Bisher umgesetzt

Noch nichts im Code. Diese Phase ist angelegt und fachlich vorbereitet.

## Bestandsaufnahme 9.1

Geprüft wurden Datenmodell, Validator, UI-Feld und Scheduler.

### Bereits vorhanden

- `missedBufferDays` ist in Aufgaben und Definitionsversionen gespeichert.
- `postBufferBehavior` ist in Aufgaben und Definitionsversionen gespeichert.
- `PostBufferBehavior` kennt aktuell:
  - `mark_as_failure`
  - `keep_open`
- Der Validator prüft bereits:
  - Puffer muss mindestens einen Tag haben.
  - Bei `MissedPolicy.buffer` muss ein `postBufferBehavior` vorhanden sein.
  - Puffer-Folgefelder werden nur bei `MissedPolicy.buffer` angezeigt.
  - Kalendergebundene Puffer erhalten bereits einen Hinweis auf mögliche
    Überschneidung mit späteren Instanzen.
- Die UI zeigt bereits:
  - Feld „Puffer in Tagen“
  - Feld „Verhalten nach dem Puffer“
  - Optionen „Sofort als Misserfolg abschließen“ und
    „Bis zur manuellen Antwort offen lassen“
- Der Scheduler verarbeitet direkte Konsequenz, aber noch keine Pufferlogik.

### Noch fehlend

- Keine Scheduler-Verarbeitung für `MissedPolicy.buffer`.
- Kein technisches Puffermaximum.
- Keine Sperre/Umleitung von `keep_open` bei kalendergebundenen Rhythmen.
- Keine Anzeige `Puffer Tag X/Y` in Tages- oder Dringlichkeitsansichten.
- Kein eigener technischer Wert für „nach Puffer als Kein Eintrag abschließen“.

### Geklärte fachliche Präzisierung vor Scheduler-Code

`no_entry` soll als Folgeregel nach Puffer erlaubt sein.

Aktuell kann „nach Puffer als Kein Eintrag abschließen“ aber nicht direkt über
`postBufferBehavior` gespeichert werden. Dafür braucht Phase 9 eine kleine
Enum-/Schema-Erweiterung oder eine eindeutige Abbildung auf bestehende
Konsequenzfelder.

`keep_open` soll dagegen nicht als gültiges Pufferverhalten gespeichert werden.

Damit werden Scheduler und Auswertung einfacher:

- Puffer endet immer in einem Abschluss: `failure` oder `no_entry`.
- Offen bleiben wird über Carryover oder über keine automatische Abschlussregel
  modelliert, nicht über Puffer.

## Geplante betroffene Dateien

| Datei | Erwartete Rolle |
|---|---|
| `lib/features/aufgaben/data/task_instance_scheduler.dart` | Pufferverarbeitung nach X Puffertagen. |
| `lib/features/aufgaben/data/task_configuration_validator.dart` | Puffergrenzen, Pflicht-Folgeregel und Carryover-Umleitung validieren. |
| `lib/features/aufgaben/data/post_buffer_behavior.dart` | Bestehende technische Werte prüfen und ggf. fachlich schärfen. |
| `lib/features/aufgaben/presentation/widgets/missed_policy_field.dart` | UI-Hinweise und erlaubte Auswahl. |
| `test/features/aufgaben/data/aufgaben_repository_test.dart` | Gezielte Scheduler-/Repository-Tests. |

## Prüfnachweise

Noch keine Phase-9-Tests innerhalb von Codex ausgeführt.

## Umsetzungsschritt 9.2 bis 9.5

Folgende technische Entscheidungen wurden umgesetzt:

- `PostBufferBehavior.markAsNoEntry` wurde ergänzt.
- `PostBufferBehavior.keepOpen` bleibt als Legacy-Wert lesbar, ist aber kein
  gültiges neues Pufferverhalten mehr.
- Neue Puffer-Konfigurationen erlauben nur:
  - `mark_as_failure`
  - `mark_as_no_entry`
- Die UI-Auswahl „Verhalten nach dem Puffer“ zeigt nur noch:
  - „Sofort als Misserfolg abschließen“
  - „Als Kein Eintrag abschließen“
- `no_entry` erhält einen Warnhinweis, weil neutrale Einträge die Auswertung
  anders wirken lassen können.
- Alte Migrationen, die früher `keep_neutral` nach Puffer auf `keep_open`
  abgebildet hätten, verwenden jetzt `mark_as_no_entry`.
- Der Scheduler verarbeitet `MissedPolicy.buffer`:
  - regulärer Tag läuft ab,
  - danach laufen X volle Puffertage,
  - am folgenden Tageswechsel wird die Instanz automatisch abgeschlossen.
- `failure` und `no_entry` werden dabei mit automatischer Herkunft,
  angewendeter Policy und angewendetem Pufferverhalten gespeichert.

### Puffer-Maximum

Für kalendergebundene Rhythmen wird der maximale Puffer technisch begrenzt.

Regel:

```text
maximaler Puffer = Abstand zur nächsten konkreten Instanz * 2
```

Dabei wird der nächste Termin wirklich berechnet. Monatsrhythmen verwenden also
nicht pauschal 30 Tage. Bei „letzter Tag im Monat“ kann der Abstand zum Beispiel
von Januar bis Februar 28 Tage betragen.

### Bewusste Abgrenzung

Die sichtbare Kartenanzeige `Puffer Tag X/Y` ist fachlich beschlossen, aber noch
nicht vollständig in die Tages-/Dringlichkeitslisten eingebaut. Grund: Die
Anzeige alter offener Instanzen, Carryover und Puffer überschneiden sich stark.
Die saubere Listenlogik wird daher mit Phase 10 zusammen betrachtet.

### Ergänzte gezielte Tests

Ergänzt wurden Tests für:

- Validator erlaubt Puffer mit `mark_as_no_entry`.
- Validator lehnt `keep_open` als Puffer-Folgeregel ab.
- täglicher Puffer darf maximal zwei Tage dauern.
- Monatsrhythmus „letzter Tag“ berechnet das Puffermaximum über echte Termine.
- Scheduler schließt nach Puffer als `failure`.
- Scheduler schließt nach Puffer als `no_entry`.
- Scheduler verarbeitet Puffer idempotent.
- Scheduler erlaubt eine neue Tagesinstanz, während eine ältere Instanz noch im
  Puffer liegt.
- Scheduler verarbeitet Puffer bei abschlussgebundenem Rhythmus, ohne sofort
  eine Folgeinstanz zu erzeugen.

Nach Phase 9 noch offen:

- Sichtbare Anzeige `Puffer Tag X/Y` in Tages-/Dringlichkeitslisten. Diese
  Umsetzung wird bewusst mit Phase 10 Carryover gekoppelt.

## Testnachweis

Extern in PowerShell ausgeführt:

```powershell
flutter test --no-pub test\features\aufgaben\data\aufgaben_repository_test.dart --plain-name "Puffer"
```

Ergebnis: `+5 All tests passed`.
