# Momentum – Phase 10: Carryover/Aufstauen

Stand: 20. Juli 2026  
Status: Abgeschlossen

## Zweck dieses Dokuments

Dieses Dokument ist die kurze Arbeitskarte für Phase 10. Der ausführliche
Verlauf steht in [`carryover_history.md`](carryover_history.md).

## Ziel von Phase 10

Carryover sorgt dafür, dass verpasste kalendergebundene Instanzen nicht
automatisch verschwinden. Jede verpasste Instanz bleibt als eigener offener
Eintrag sichtbar. Neue Instanzen entstehen trotzdem weiter.

Beispiel:

- Aufgabe: täglich Wasser trinken
- Montag nicht beantwortet
- Dienstag neue Instanz
- Anzeige am Dienstag:
  - Montag: `−1`
  - Dienstag: heute offen

Wichtig: Carryover ist nicht nur ein Zähler. Es sind echte einzelne Instanzen,
die unabhängig beantwortet, kommentiert und später ausgewertet werden können.

## Fachliche Leitplanken

| Regel | Bedeutung |
|---|---|
| Jede Instanz bleibt eigenständig | Aufgestaute Einträge dürfen nicht zu einem Sammelzähler verschmelzen. |
| Älteste Instanz ist am dringendsten | Die älteste offene Instanz wird zuerst angezeigt oder klar markiert. |
| Anzeige eher `−X` | Carryover nutzt dieselbe überfällig wirkende Anzeige wie einmalige Aufgaben. |
| Maximum ist Pflicht | Carryover darf nicht unbegrenzt viele offene Karten erzeugen. |
| Konsequenz bei überschrittenem Maximum ist Pflicht | Wenn das Maximum überschritten wird, muss die älteste Instanz automatisch verarbeitet werden. |
| Kein automatischer Erfolg | Auch bei überschrittenem Maximum darf nie automatisch Erfolg entstehen. |
| Firebase später beachten | Nachholverarbeitung muss idempotent und schreibsparend bleiben. |

## Bereits fachlich beschlossen

- Tägliches Aufstauen ist erlaubt, aber braucht einen Hinweis auf mögliche
  Überfüllung.
- Begrenztes Aufstauen braucht:
  - maximale Anzahl aufgestauter Einträge
  - Konsequenz, wenn das Maximum überschritten wird
- Alle aufgestauten Einträge sind sichtbar.
- Der älteste Eintrag hat höchste Dringlichkeit.
- Carryover ist bei abschlussgebundenen Rhythmen nicht sinnvoll, weil dort
  keine neue Instanz entsteht, bevor die alte abgeschlossen ist.
- `keep_open` aus Puffer wird nicht als Sonderlogik gespeichert, sondern
  fachlich Carryover zugeordnet.
- Carryover-Anzeige später eher `−X`, nicht „seit X Tagen offen“.

## Geplanter Ablauf

| Schritt | Inhalt | Status |
|---:|---|---|
| 10.1 | Bestandsaufnahme: vorhandene Felder, Validator, UI, Scheduler und Listenlogik prüfen | erledigt |
| 10.2 | Fachliche Detailregeln finalisieren: Maximum, Konsequenz, Anzeige und Sortierung | erledigt |
| 10.3 | Validierung prüfen/ergänzen: Carryover nur bei sinnvollen Rhythmen, Maximum und Konsequenz Pflicht | erledigt; bereits ausreichend vorhanden |
| 10.4 | Scheduler erweitern: verpasste Instanzen erzeugen, Rückstau begrenzen, älteste Instanz verarbeiten | erledigt |
| 10.5 | Repository-/Listenlogik erweitern: alte offene Instanzen in Tages- und Dringlichkeitsansicht sichtbar machen | erledigt |
| 10.6 | UI-Hinweise ergänzen: Überfüllung, Maximum, Konsequenz und Anzeigen `−X` / `Puffer Tag X/Y` | teilweise erledigt; weitere Hinweise können später verfeinert werden |
| 10.7 | Gezielte Tests ergänzen: Nachholen, Maximum, Konsequenz, Idempotenz, Sortierung | erledigt und extern bestätigt |
| 10.8 | Dokumentation aktualisieren und Phase 10 abschließen | erledigt |

## Geklärte Fragen

| Frage | Warum wichtig? | Vorschlag / Stand |
|---|---|---|
| Welche Konsequenzen sind bei überschrittenem Maximum erlaubt? | Die älteste Instanz muss eindeutig verarbeitet werden. | `failure` oder `no_entry`, nie Erfolg. |
| Wann wird das Maximum geprüft? | Entscheidet, ob erst neue Instanzen erzeugt werden und dann gekappt wird oder umgekehrt. | Chronologisch im Scheduler: fehlende Instanz erzeugen, Rückstau prüfen, älteste überzählige Instanz verarbeiten. |
| Zählt die heutige Instanz zum Maximum? | Sonst wirkt die Grenze für Nutzer unklar. | Maximum betrifft alle offenen Carryover-Instanzen inklusive heutiger offener Instanz derselben Aufgabe. |
| Wie wird die Sortierung genau? | Nutzer sollen den dringendsten Eintrag zuerst sehen. | Älteste offene Instanz zuerst; innerhalb gleicher Instanzdatum nach Projekt-/Aufgabenlogik. |
| Wo erscheint Carryover? | Tagesansicht, Dringlichkeit und Habit-Ansicht könnten unterschiedlich wirken. | Offene aufgestaute Einträge erscheinen in der passenden Aufgaben-/Habit-Ansicht des aktuellen Tages und in Dringlichkeit. |
| Wie unterscheiden wir Puffer und Carryover sichtbar? | Sonst wirken zwei alte Instanzen gleich, obwohl sie fachlich unterschiedlich sind. | Puffer: `Puffer Tag X/Y`; Carryover/überfällig: `−X`. |

## Prüfergebnis

| Prüfung | Ergebnis |
|---|---|
| `Carryover` | extern in PowerShell grün: `+4 All tests passed` |
| `Tagesansicht zeigt alte offene Puffer-Instanzen im Puffer` | extern in PowerShell grün: `+1 All tests passed` |

UI-Texte und Hinweise können später weiter geschärft werden, sind aber kein
Blocker für Phase 10.

## Nicht Teil von Phase 10

- Zielbewertung
- erweiterte Auswertung
- Papierkorb
- Unteraufgaben
- Firebase-Synchronisierung selbst
- frei konfigurierbare Reset-Zeit

## Erfolgsbedingung

Phase 10 ist abgeschlossen, wenn:

1. Carryover-Instanzen als echte einzelne offene Einträge bestehen bleiben,
2. neue Instanzen weiterhin entstehen,
3. das Maximum eingehalten wird,
4. bei überschrittenem Maximum die älteste Instanz automatisch als `failure`
   oder `no_entry` verarbeitet wird,
5. ungültige Kombinationen nicht speicherbar sind,
6. Tages-/Dringlichkeitsansicht alte offene Einträge verständlich anzeigen,
7. `−X` und `Puffer Tag X/Y` fachlich sauber unterschieden werden,
8. gezielte Scheduler-/Repository-Tests grün sind.
