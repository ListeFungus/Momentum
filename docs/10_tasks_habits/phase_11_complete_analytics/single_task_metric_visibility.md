# Momentum – Phase 11: Sichtbarkeit einzelner einmaliger Aufgaben

Stand: 21. Juli 2026  
Status: Arbeitsdokument

## Zweck

Dieses Dokument legt fest, welche Informationen und Auswertungen bei einer
einzelnen einmaligen Aufgabe angezeigt werden sollen.

Einmalige Aufgaben unterscheiden sich deutlich von wiederkehrenden Aufgaben und
Habits:

- Es gibt keine Serie von Instanzen.
- Eine Erfolgsquote ist für eine einzelne Aufgabe nicht sinnvoll.
- Die Detailansicht soll vor allem erklären, was mit dieser einen Aufgabe
  passiert ist.

Deshalb trennen wir hier zwischen:

| Kategorie | Bedeutung |
|---|---|
| Detailfeld | Faktische Information zur Aufgabe, z. B. Fälligkeit oder Projekt. |
| Auswertungswert | Berechneter Wert, z. B. Dauer bis Abschluss oder Abweichung vom Fälligkeitstag. |

## Grundprinzip

Eine einzelne einmalige Aufgabe bekommt keine Habit-Auswertung. Sie bekommt eine
verständliche Aufgabenakte.

Die App soll zeigen:

- was die Aufgabe ist,
- seit wann sie zählt,
- ob und wann sie fällig war,
- ob sie abgeschlossen wurde,
- wie sie abgeschlossen wurde,
- wie lange sie bis zum Abschluss gebraucht hat,
- ob sie vor, am oder nach dem Fälligkeitstag abgeschlossen wurde.

## Sichtbarkeit einzelner Felder

| Feld / Auswertung | Kategorie | Standard | Anzeigen, wenn … | Ausblenden, wenn … | Leerer Zustand / Bedeutung | Hinweis |
|---|---|---|---|---|---|---|
| Status | Detailfeld | anzeigen | immer. | nie. | Nicht leer; mindestens `pending`, `success`, `failure` oder `no_entry`. | Zentrale Information der Aufgabe. |
| Erstellt am | Detailfeld | anzeigen | `createdAt` vorhanden ist. | praktisch nie. | Wenn technisch fehlend, als Migrations-/Altdatenhinweis behandeln. | Wichtig, wenn kein Startdatum gesetzt wurde. |
| Zählt ab | Detailfeld | anzeigen | immer. | nie. | Nutzt Startdatum, sonst Erstellungsdatum. | Fachlicher Startpunkt für Dauerberechnung. |
| Projekt | Detailfeld | anzeigen | immer. | nie. | „Ohne Projekt“, wenn keine Projektzuordnung existiert. | Projektname und Farbe aus Projektzuordnung ableiten. |
| Fällig am | Detailfeld | anzeigen | immer. | nie. | „Kein Fälligkeitsdatum“, wenn keine Fälligkeit gesetzt ist. | Aufgaben ohne Fälligkeit gehören eher in „Ohne Zeitdruck“. |
| Abgeschlossen am | Detailfeld | bedingt anzeigen | Aufgabe finalisiert wurde. | Aufgabe noch offen ist. | „Noch nicht abgeschlossen“. | Bei `success`, `failure` und `no_entry` relevant. |
| Abschlussart | Detailfeld | bedingt anzeigen | Aufgabe finalisiert wurde oder eine automatische Verarbeitung möglich ist. | Aufgabe offen ist und keine Automatik relevant ist. | „Noch offen“. | Unterscheidet manuell, automatisch oder migriert. |
| Dauer bis Abschluss | Auswertungswert | anzeigen | immer. | nie. | Ausgegraut „Nicht verfügbar“, solange die Aufgabe offen ist. | Start ist Startdatum, sonst Erstellungsdatum. Ende ist `finalizedAt`/`effectiveAt`. |
| Aktuelle Laufzeit | Auswertungswert | anzeigen | immer. | nie. | Ausgegraut „Nicht verfügbar“, wenn die Aufgabe abgeschlossen ist. | Hilft bei offenen Aufgaben ohne Abschluss. |
| Abweichung vom Fälligkeitstag | Auswertungswert | anzeigen | immer. | nie. | Ausgegraut „Nicht verfügbar“, wenn Fälligkeit oder Abschluss fehlt. | Zeigt vorzeitig, pünktlich oder verspätet. |
| Aktuelle Überfälligkeit | Auswertungswert | anzeigen | immer. | nie. | Ausgegraut „Nicht verfügbar“, wenn keine offene Überfälligkeit besteht. | Anzeige z. B. `−3 Tage`. |
| Rechtzeitig erledigt | Auswertungswert | anzeigen | immer. | nie. | Ausgegraut „Nicht verfügbar“, wenn Fälligkeit oder Abschluss fehlt. | Eher als Text: „rechtzeitig“, „zu spät“, „vorzeitig“. |
| Notizen | Detailfeld | anzeigen | immer. | nie. | „Keine Notiz“. | Später auch sichtbar in Antwort-/Eintragslisten. |

## Umgang mit offenen Aufgaben

Eine offene einmalige Aufgabe soll keine fertigen Abschlusswerte vortäuschen.

Beispiele:

| Fall | Anzeige |
|---|---|
| Aufgabe offen, ohne Fälligkeit | Status, Erstellt am, Zählt ab, Projekt, aktuelle Laufzeit. |
| Aufgabe offen, Fälligkeit in Zukunft | zusätzlich „Fällig am“. |
| Aufgabe offen, Fälligkeit überschritten | zusätzlich „−X Tage“ oder aktuelle Überfälligkeit. |
| Aufgabe abgeschlossen | Abschlussdatum, Abschlussart, Dauer bis Abschluss und ggf. Abweichung vom Fälligkeitstag. |

## Umgang mit Aufgaben ohne Fälligkeit

Aufgaben ohne Fälligkeit können keine Abweichung vom Fälligkeitstag haben.

Nicht anzeigen:

- Abweichung vom Fälligkeitstag
- rechtzeitig erledigt
- aktuelle Überfälligkeit

Stattdessen sinnvoll:

- Status
- Erstellt am
- Zählt ab
- Projekt
- aktuelle Laufzeit oder Dauer bis Abschluss
- Notizen

## Umgang mit automatischem Abschluss

Wenn eine einmalige Aufgabe automatisch durch eine Missed Policy abgeschlossen
wurde, soll das sichtbar bleiben.

Beispiel:

| Feld | Anzeige |
|---|---|
| Status | Misserfolg oder Kein Eintrag |
| Abgeschlossen am | Zeitpunkt der automatischen Verarbeitung |
| Abschlussart | Automatisch |
| Dauer bis Abschluss | Zeitraum vom Start bis zur automatischen Verarbeitung |
| Abweichung vom Fälligkeitstag | z. B. 1 Tag zu spät |

Das ist wichtig, damit spätere Auswertungen unterscheiden können, ob Nutzer eine
Aufgabe bewusst abgeschlossen haben oder ob die App sie verarbeitet hat.

## Technische Ableitung

Auch diese Felder sollten später wie Kennzahlen beschrieben werden.

Mögliche Struktur:

```text
SingleTaskDetailDefinition
- key
- title
- explanation
- type: detail | metric
- isAvailable(task, entry)
- resolveValue(task, entry)
- emptyStateText
```

Wichtig ist:

- Detailfelder und Auswertungswerte dürfen im UI ähnlich aussehen.
- Intern sollten sie aber unterschieden bleiben.
- Dadurch kann später leichter entschieden werden, welche Werte in
  Sammelauswertungen, Karten oder Zielsysteme einfließen.

## Noch zu klären

| Frage | Warum wichtig? | Vorschlag |
|---|---|---|
| Soll „Fällig am“ bei Aufgaben ohne Fälligkeit ausgeblendet oder als „Kein Fälligkeitsdatum“ angezeigt werden? | Ausblenden ist ruhiger, Anzeigen erklärt besser. | Geklärt: anzeigen als „Kein Fälligkeitsdatum“. |
| Soll bei offenen Aufgaben „Dauer bis Abschluss“ ausgeblendet oder als „läuft seit X Tagen“ ersetzt werden? | „Dauer bis Abschluss“ wäre fachlich falsch, solange kein Abschluss existiert. | Geklärt: „Dauer bis Abschluss“ ausgegraut, separates Feld „Aktuelle Laufzeit“. |
| Soll „Notizen“ immer sichtbar sein? | Wenn Notizen wichtig sind, sollte der Zugang nicht versteckt sein. | Geklärt: immer anzeigen, bei leerem Wert „Keine Notiz“. |
