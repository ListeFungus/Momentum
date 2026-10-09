# Momentum - Phase 12: Erweiterte Erfassungsarten

Stand: 10. August 2026  
Status: Phase 12 abgeschlossen und extern bestaetigt

## Ziel

Aufgaben und Habits sollen neben `Ja`, `Nein`, `pending` und `no_entry` auch
Werte erfassen koennen. Die Erweiterung nutzt weiterhin dieselbe
Aufgaben-/Habit- und Instanzstruktur.

Das detaillierte Fachkonzept steht in
[`extended_capture_concept.md`](extended_capture_concept.md).

## Ergebnis der Planung

Phase 12 umfasst:

- Einzelwerte: Zahl, Dauer und Uhrzeit.
- Einen neuen neutralen Wertstatus `recorded`.
- Reines taegliches Tracking ohne Missed Policy und ohne automatische leere
  Entries.
- Verbindliche Wert-Eingaben mit den bisherigen Missed-Policy-Moeglichkeiten.
- Feste Einheit pro Tracking.
- Bekannte Einheiten mit Familien/Umrechnung und Freitext-Einheiten ohne
  Umrechnung.
- Uhrzeiten mit klarem Tagesbezug, inklusive Folgetag fuer Schlaf/Fasten.
- Zwei-Werte-Buendel mit eigener ID, aber ohne eigene Entries.
- Buendeltypen fuer Zeitintervall, Differenz und Summe.
- Virtuelle leere Tracking-Tage fuer Auswertung und Monatsmatrix.
- Vorbereitung fuer Phase 13 Wert-Auswertung, Phase 14 Zielbewertung, Phase 15
  Kartenkennzahl und Phase 19 Firebase-Synchronisierung.

## Leitplanken

- Es entsteht keine parallele Aufgabenlogik.
- Instanzen bleiben die Grundlage.
- Wertstatus und Zielbewertung bleiben getrennt.
- `recorded` ersetzt bei Wert-Eingaben `success`, wirkt fuer Abschlusslogik aber
  wie ein positiver Abschluss.
- `failure` bei Wert-Eingaben bedeutet: verbindliche Eingabe verpasst.
- Reines Tracking erzeugt keine automatischen Schreibvorgaenge fuer leere Tage.
- Gespeichert wird nur, wenn ein Wert, eine bewusste Ausnahme, eine Notiz, eine
  Korrektur oder eine verbindliche Policy-Konsequenz vorliegt.
- Historische Definitionen duerfen nicht stillschweigend umgedeutet werden.
- Buendel duerfen Rohwerte nicht doppelt speichern.

## Geplanter Ablauf

Phase 12 wird in kleinere Teilabschnitte zerlegt. Dadurch bleibt die Umsetzung
kontrollierbar, obwohl Phase 12 fachlich ein zusammenhaengender Block bleibt.

| Schritt | Inhalt | Status |
|---:|---|---|
| 12a | Grundlage: vorhandenes Datenmodell einordnen, `recorded` technisch einfuehren, zentrale Begriffe fuer Werttyp, Verbindlichkeit, Einheiten und Buendel anlegen | abgeschlossen |
| 12b | Einzelwerte: Zahl, Dauer und Uhrzeit speichern, bearbeiten und in der Tages-/Habit-Ansicht erfassen | abgeschlossen |
| 12c | Reines Tracking: keine automatischen leeren Entries, virtuelle leere Tage, Tracking-Gruppe und klare Anzeige | abgeschlossen |
| 12d | Verbindliche Wert-Eingaben: direkte Konsequenz, Puffer und Carryover mit `recorded`, `failure` und `no_entry` verbinden | abgeschlossen |
| 12e | Zwei-Werte-Buendel: Buendeldefinitionen, Teil-Trackings, Teilwerte, abgeleitete Anzeige und Aufloesen umsetzen | abgeschlossen |
| 12f | Abschluss: gezielte Tests, Dokumentation, Auswertungsmatrix und Vorbereitung fuer Phase 13 aktualisieren | abgeschlossen |

## Abgeschlossener Teilabschnitt: 12c - Reines Tracking

Phase 12c sorgt dafuer, dass reines Tracking nicht nur gespeichert werden kann,
sondern sich in der App fachlich richtig anfuehlt.

Reines Tracking bedeutet:

- Es gibt keine Pflicht zur Eingabe.
- Leere Tage erzeugen keine automatischen Datenbank-Eintraege.
- Eine echte Eingabe erzeugt einen Entry mit `recorded`.
- Missed Policy, Puffer und Carryover sind gesperrt.
- Die Anzeige darf leere Tage zeigen, ohne sie als Fehler zu speichern.

### In 12c geklaert und umgesetzt

| Thema | Warum wichtig? | Vorschlag / aktueller Stand |
|---|---|---|
| Virtueller Status heute | Heute ohne Eingabe soll sichtbar sein, aber nicht gespeichert werden. | Heute ohne Wert wird nur fuer die Anzeige als offen/leer betrachtet. |
| Virtueller Status vergangener Tage | Fuer spaetere Auswertung und Matrix muss erkennbar sein, dass kein Wert existiert. | Vergangene Tage ohne Wert bleiben ohne Entry; Auswertungen zaehlen sie separat nur virtuell. |
| Habits-Ansicht | Reine Trackings sollen nicht zwischen verpflichtenden Habits untergehen. | Eigene Gruppe im Habits-Tab, z. B. `Tracking` oder `Werte erfassen`. |
| Tagesansicht | Reine Trackings sollen am passenden Tag eingetragen werden koennen. | Heute und gewaehlte Tage zeigen das leere Eingabefeld, wenn noch kein Wert vorhanden ist. |
| Speichern und Aendern | Pro Aufgabe und Tag soll genau ein Wert gelten. | Bestehende Entry-Wert-Logik wird weiterverwendet. |
| Kein automatisches Schreiben | Wichtig fuer spaetere Firebase-Kosten und Datenmenge. | Leere Tracking-Tage werden nur berechnet/angezeigt, nicht gespeichert. |
| Wording | Nutzer sollen verstehen, dass leer nicht gleich verpasst ist. | Kurze UI-Texte: `Keine Pflicht`, `Nur echte Eingaben werden gespeichert`. |

### Abschlusskriterien fuer 12c

12c ist fertig, wenn:

1. reine Trackings ohne gespeicherten Entry in Tages-/Habits-Ansichten korrekt
   erscheinen,
2. gespeicherte Werte pro Datum wieder angezeigt werden,
3. leere Tage keine Datenbankeintraege erzeugen,
4. Missed Policy bei reinem Tracking dauerhaft gesperrt bleibt,
5. die Habits-Ansicht reine Trackings verstaendlich gruppiert,
6. gezielte Tests oder Praxischecks die wichtigsten Faelle bestaetigen.

## Abgeschlossener Teilabschnitt: 12d - Verbindliche Wert-Eingaben

Phase 12d verbindet Pflichtwerte mit der bestehenden Missed-Policy-Logik.

Verbindliche Wert-Eingaben bedeuten:

- Eine Instanz wird wie bei normalen Aufgaben geplant.
- Solange kein Wert eingetragen wurde, bleibt sie `pending`.
- Wird ein Wert gespeichert, wird die Instanz `recorded`.
- `recorded` ist ein abgeschlossener Rohstatus, aber noch keine Zielwertung.
- Wenn die Frist ablaeuft, greifen direkte Konsequenz, Puffer oder Carryover
  wie bei anderen Aufgaben.
- Automatischer Erfolg bleibt ausgeschlossen.

### In 12d geklaert und umgesetzt

| Thema | Regel / Umsetzung |
|---|---|
| Direkte Konsequenz | Verpasste Pflichtwerte werden je nach Konfiguration zu `failure` oder `no_entry`. |
| Puffer | Pflichtwerte koennen im Puffer weiter bearbeitet werden; nach Ablauf speichert die Folgeregel `failure` oder `no_entry`. |
| Carryover | Pflichtwert-Instanzen koennen aufstauen; bei Ueberschreiten des Maximums wird die aelteste Instanz abgeschlossen. |
| Rechtzeitig erfasster Wert | Ein gespeicherter Wert bleibt `recorded` und wird nicht spaeter automatisch ueberschrieben. |
| Auswertung | `failure` bedeutet bei Wert-Eingaben: Pflicht-Eingabe verpasst, nicht: Wert fachlich schlecht. |

### Abschlusskriterien fuer 12d

12d ist fertig, wenn:

1. verbindliche Wert-Eingaben normale Instanzen erzeugen,
2. gespeicherte Werte `recorded` bleiben,
3. direkte Konsequenz `failure`/`no_entry` korrekt erzeugt,
4. Puffer-Folgeregeln fuer Pflichtwerte funktionieren,
5. Carryover-Maximum fuer Pflichtwerte greift,
6. gezielte Tests diese Faelle abdecken.

## Technische Detail-Schritte

Diese feinere Liste bleibt als Arbeitscheckliste erhalten.

| Schritt | Inhalt | Zugeordnet zu |
|---:|---|---|
| 12.1 | vorhandene Erfassungsmodi, `TaskEntry`, Scheduler, Analytics und Definitionsversionen gegen das Konzept pruefen | 12a |
| 12.2 | Konstanten und Begriffe einfuehren: Werttypen, Verbindlichkeit, `recorded`, Einheitenfamilien, Buendeltypen | 12a |
| 12.3 | Datenmodell entwerfen: Wertfelder, Einheiten, Uhrzeitbezug, virtuelle Tracking-Tage, Buendeldefinitionen | 12a/12b/12e |
| 12.4 | Migration planen: bestehendes `numberValue`, Statuswerte, Definitionsversionen und alte Daten | 12a/12b |
| 12.5 | Validierung erweitern: reines Tracking sperrt Missed Policy; verbindliche Werte erlauben passende Policies | 12c/12d |
| 12.6 | Repository- und Scheduler-Regeln umsetzen: Wert speichern, `recorded`, virtuelle leere Tracking-Tage, Pflicht-Konsequenzen | 12b/12c/12d |
| 12.7 | Erstellung/Bearbeitung erweitern: fruehe Verbindlichkeitsauswahl, Wertfelder, Einheit, Uhrzeitbezug, Buendelquellen | 12b/12c/12e |
| 12.8 | Tages-/Habits-Ansicht erweitern: Tracking-Gruppe unter offenen Habits, Buendelkarten, teilweise erfasste Buendel | 12b/12c/12e |
| 12.9 | Detail-/Analyse-Einstieg vorbereiten: Einzelwert, Teilwerte und abgeleiteter Buendelwert unterscheidbar machen | 12b/12e |
| 12.10 | Tests planen und ergaenzen: Status, virtuelle Tage, Pflicht-Policies, Einheiten, Uhrzeiten, Buendel, Versionierung | 12f |
| 12.11 | Dokumentation und Auswertungsmatrix nach Umsetzung aktualisieren | 12f |

## Abgeschlossener Teilabschnitt: 12e - Zwei-Werte-Buendel

Phase 12e setzt Zwei-Werte-Buendel als ersten technischen Kern um. Ein Buendel
ist kein eigener Entry und keine zweite Aufgabenlogik. Es verbindet zwei
eigenstaendige Wert-Trackings, zeigt sie gemeinsam an und berechnet daraus einen
abgeleiteten Wert.

### Was bereits feststeht

| Thema | Beschluss |
|---|---|
| Grundmodell | Ein Buendel verbindet zwei eigenstaendige Teil-Trackings. |
| Rohdaten | Rohwerte werden nur in den Teil-Entries gespeichert, nicht doppelt im Buendel. |
| Buendel-ID | Das Buendel braucht eine eigene stabile Text-ID. |
| Versionierung | Quellentausch oder Formelwechsel gilt ab Datum; alte Zeitraeume bleiben stabil. |
| Anzeige | In Tages-/Habit-Ansichten ersetzt die Buendelkarte die zwei Einzelkarten. |
| Teilweise Eingabe | Ein teilweise erfasstes Buendel bleibt sichtbar und wartet auf den zweiten Wert. |
| Aufloesen | Beim Aufloesen bleiben beide Teil-Trackings erhalten und erscheinen wieder einzeln. |
| Phase-12-Typen | Zeitintervall, Differenz und Summe. |

### 12e.1/12e.2 - festgelegtes Schema

Fuer Zwei-Werte-Buendel werden zwei Tabellen verwendet.

#### `task_value_bundles`

Diese Tabelle ist die stabile Buendel-Huelle.

| Feld | Bedeutung |
|---|---|
| `id` | stabile Text-ID fuer lokale Datenbank und spaetere Firebase-Synchronisierung |
| `createdAt` | technischer Erstellungszeitpunkt |
| `updatedAt` | letzte technische Aenderung |
| `isActive` | ob das Buendel aktuell aktiv ist |

Der Name liegt bewusst nicht in dieser Tabelle, sondern in der Version. Dadurch
koennen alte Zeitraeume spaeter den damals gueltigen Namen behalten.

#### `task_value_bundle_versions`

Diese Tabelle beschreibt, wie ein Buendel in einem Zeitraum fachlich gemeint
ist.

| Feld | Bedeutung |
|---|---|
| `id` | stabile Text-ID der Version |
| `bundleId` | Verknuepfung zur Buendel-Huelle |
| `versionNumber` | laufende Versionsnummer pro Buendel |
| `previousVersionId` | optionale vorherige Version |
| `validFrom` | ab wann diese Version gilt |
| `validTo` | bis wann diese Version gilt; leer bedeutet aktuell offen |
| `createdAt` | technischer Erstellungszeitpunkt dieser Version |
| `name` | sichtbarer Name, z. B. `Schlafdauer` |
| `description` | optionale Beschreibung |
| `bundleType` | `time_interval`, `difference` oder `sum` |
| `firstTaskId` | erstes Teil-Tracking |
| `secondTaskId` | zweites Teil-Tracking |
| `firstRoleLabel` | Rolle des ersten Werts, z. B. `Aufnahme` |
| `secondRoleLabel` | Rolle des zweiten Werts, z. B. `Verbrauch` |
| `resultLabel` | Name des abgeleiteten Werts, z. B. `Bilanz` |
| `direction` | Formelrichtung, z. B. `first_minus_second` |

Technische Regeln:

- `firstTaskId` und `secondTaskId` duerfen nicht identisch sein.
- `validTo` muss leer oder spaeter als `validFrom` sein.
- `bundleType` ist auf die Phase-12-Typen begrenzt.
- `direction` ist auf bekannte Richtungen begrenzt.
- Teil-Trackings werden per Fremdschluessel geschuetzt; aktive Buendel sollen
  nicht durch hartes Loeschen eines Teil-Trackings kaputtgehen.

### 12e.2 - aktueller technischer Stand

Umgesetzt im Source-Code:

- `TaskValueBundles` Tabelle angelegt.
- `TaskValueBundleVersions` Tabelle angelegt.
- `AppDatabase` um beide Tabellen erweitert.
- `schemaVersion` von 14 auf 15 erhoeht.
- Migration `_migrateTaskValueBundles` ergaenzt.

Extern abgeschlossen:

- `app_database.g.dart` wurde durch `build_runner` warnungsfrei aktualisiert.
- Die generierte Datei enthaelt `TaskValueBundles`,
  `TaskValueBundleVersions`, `taskValueBundles` und
  `taskValueBundleVersions`.
- `task_value_foundation_test.dart` lief extern mit `+5 All tests passed`.

### Umgesetzte technische Bausteine

| Baustein | Ergebnis |
|---|---|
| Buendel-Tabelle | Speichert ID, aktiven Zustand und Synchronisationsgrundlage. |
| Buendel-Versionstabelle | Speichert Typ/Formel, Quelle A, Quelle B, Rollen, Richtung und Gueltigkeit. |
| Repository-Methoden | Erstellen, Laden, Anzeigen und Aufloesen von Buendeln. |
| Berechnungslogik | Leitet z. B. Schlafdauer, Differenz oder Summe aus zwei Teilwerten ab. |
| Tages-/Habit-Integration | Verhindert doppelte Anzeige der Teil-Trackings und zeigt stattdessen eine gemeinsame Karte. |
| Aufloesen | Deaktiviert das Buendel, ohne Rohdaten oder Teil-Trackings zu loeschen. |
| Tests | Testfaelle fuer Berechnung, Sichtbarkeit, Mehrfachbuendel-Sperre, Aufloesen und Loeschschutz wurden ergaenzt. |

### Pruefhinweis

Die Drift-Generierung wurde extern abgeschlossen. Die Codex-Toolchain haengt
bei Flutter-/Dart-Pruefungen in diesem Projekt gelegentlich; deshalb wurden die
gezielten Tests fuer 12e extern in PowerShell gegengeprueft und erfolgreich
bestaetigt.

### Was mit "technisch beginnen" gemeint ist

"Technisch beginnen" bedeutet hier nicht, sofort eine sichtbare Buendel-UI zu
bauen. Gemeint ist: zuerst die dauerhafte Struktur so festlegen und umsetzen,
dass spaetere UI, Auswertung, Ziele und Firebase darauf aufbauen koennen, ohne
dass Rohdaten spaeter umgezogen oder doppelt gespeichert werden muessen.

Bei Zwei-Werte-Buendeln ist das besonders wichtig, weil ein Buendel gleichzeitig
drei Dinge betrifft:

1. zwei eigenstaendige Teil-Trackings,
2. eine eigene Buendeldefinition,
3. einen abgeleiteten Wert, der aus den Teilwerten berechnet wird.

### Teilschritte fuer Phase 12e

| Schritt | Inhalt | Was wird konkret getan? | Vorher zu klaeren |
|---:|---|---|---|
| 12e.1 | Datenmodell final festlegen | Entscheiden, welche Tabellen und Felder fuer Buendel und Buendelversionen gebraucht werden. Ergebnis ist ein konkreter Schema-Entwurf. | Keine offene Grundsatzfrage mehr: Buendel hat eigene ID, eigene Versionen, aber keine eigenen Entries. |
| 12e.2 | Drift-Schema und Migration vorbereiten | Neue Tabellen fuer Buendel und Buendelversionen anlegen, `schemaVersion` erhoehen, Migration ergaenzen. | abgeschlossen |
| 12e.3 | Generatorlauf extern durchfuehren | `app_database.g.dart` ueber `build_runner` aktualisieren. Wegen bisheriger Haenger bevorzugt in PowerShell ausserhalb von Codex. | extern abgeschlossen |
| 12e.4 | Repository-Grundfunktionen | Buendel erstellen, laden, aktive Version bestimmen, Quellen ermitteln, Buendel aufloesen. | abgeschlossen |
| 12e.5 | Berechnungslogik | Zeitintervall, Zahlen-Differenz und Summe aus zwei Teilwerten berechnen. | abgeschlossen |
| 12e.6 | Anzeige-Modell | Ein gemeinsames ViewModel bauen: Teilwert A, Teilwert B, abgeleiteter Wert, Teilstatus und Hinweise. | abgeschlossen |
| 12e.7 | Tages-/Habit-UI | Buendelkarte anzeigen und die zwei Teil-Tracking-Karten ausblenden, solange das Buendel aktiv ist. Eingaben schreiben weiterhin auf die Teil-Entries. | abgeschlossen |
| 12e.8 | Aufloesen und Tests | Buendel deaktivieren/aufloesen, Teil-Trackings wieder einzeln anzeigen, Tests fuer Erstellen, Berechnen, teilweise Eingabe und Aufloesen. | abgeschlossen und extern bestaetigt |

### Fuer 12e getroffene Entscheidungen

Die vorher offenen Punkte sind fuer den ersten technischen Ausbau entschieden:

| Frage | Entscheidung |
|---|---|
| Werden zuerst vorhandene Trackings verknuepft oder direkt neue Teil-Trackings erzeugt? | Phase 12e verbindet zuerst vorhandene Wert-Trackings. Ein Komfort-Flow, der beide Teil-Trackings automatisch anlegt, bleibt spaeter moeglich. |
| Wie wird Schlaf ueber Mitternacht berechnet? | Wenn die zweite Uhrzeit kleiner/gleich der ersten Uhrzeit ist, wird sie automatisch als Folgetag gewertet. Beispiel: 23:30 bis 07:15 = 7 h 45 min. |
| Wie wird ein teilweise erfasstes Buendel angezeigt? | Das Buendel bleibt sichtbar und zeigt `Teilweise erfasst`, bis beide Teilwerte vorhanden sind. |
| Was passiert beim Aufloesen? | Das Buendel wird deaktiviert; Teil-Trackings und Entries bleiben erhalten und erscheinen wieder einzeln. |
| Darf ein Teil-Tracking in mehreren Buendeln sein? | In Phase 12 nein. Ein Teil-Tracking darf maximal zu einem aktiven Eingabe-Buendel gehoeren. |
| Welche Buendeltypen sind umgesetzt? | Zeitintervall, Differenz und Summe. |
| Wie werden Einheiten in Zahlenbuendeln behandelt? | Bekannte Einheiten muessen innerhalb einer Einheitenfamilie kompatibel sein. Freitext-Zahleneinheiten sind in Phase 12 bewusst permissiv: Freitext + Freitext ist erlaubt, auch wenn die Labels unterschiedlich sind. |
| Duerfen Aufgabe und Habit in einem Buendel gemischt werden? | Nein. Beide Teil-Trackings muessen in Phase 12 denselben Aufgabenbereich haben, damit die Buendelkarte eindeutig in Tages-/Habit-Ansichten erscheint. |
| Wie werden Buendel mit Firebase gedacht? | Buendeldefinitionen sind eigene synchronisierbare Datensaetze; Teilwerte bleiben normale Entry-Werte. Abgeleitete Werte werden berechnet und nicht doppelt synchronisiert. |

### Technischer Abschluss 12e

Umgesetzt sind:

- Repository-Methoden zum Erstellen, Laden und Aufloesen von Buendeln.
- Aktive Buendelversionen werden datumssensibel geladen.
- Teil-Trackings aktiver Buendel werden aus der normalen Tages-/Habit-Liste
  ausgeblendet und stattdessen gemeinsam als Buendel angezeigt.
- Die Buendelkarte speichert weiterhin auf die normalen Teil-Entries.
- Der abgeleitete Wert wird nur berechnet und nicht als eigener Entry
  gespeichert.
- Beim Aufloesen erscheinen die Teil-Trackings wieder einzeln.
- Ein Teil-Tracking in einem aktiven Buendel ist gegen direktes Loeschen
  geschuetzt.
- Auch nach dem Aufloesen wird ein historisch referenziertes Teil-Tracking
  vor hartem Loeschen geschuetzt, bis Papierkorb/Archiv und historisches
  Loeschverhalten sauber umgesetzt sind.
- Gezielt vorbereitete Tests decken Zeitintervall, Zahlen-Differenz,
  Mehrfachbuendel-Sperre, Aufloesen und Loeschschutz ab.

Noch bewusst fuer spaeter offen:

- Historisch datumsscharfes Aufloesen: Der erste Phase-12e-Ausbau deaktiviert
  ein Buendel praktisch ab Aufloesung. Fuer spaetere Auswertungen soll noch
  geprueft werden, ob alte Zeitraeume vor dem Aufloesedatum weiterhin als
  Buendel rekonstruiert werden sollen.
- Komfort-Erstellung: In Phase 12e werden vorhandene Teil-Trackings verknuepft.
  Ein UI-Flow, der ein Buendel erstellt und die zwei Teil-Trackings direkt
  mitanlegt, bleibt spaeter moeglich.

## Fachliche Entscheidungen

| Entscheidung | Regel |
|---|---|
| Wert-Eingaben nutzen bestehende Instanzen | Keine zweite Aufgabenstruktur. |
| Reines Tracking | Immer taeglich, habit-artig, keine Missed Policy, eigene Gruppe im Habits-Tab. |
| Leere Tracking-Tage | Vergangen virtuell `no_entry`, heute virtuell `pending`, nicht automatisch speichern. |
| Verbindliche Wert-Eingaben | Nutzen Missed Policy, Puffer und Carryover wie bisher. |
| `recorded` | Neuer Status fuer erfasste Wertdaten; Abschlusslogik wie `success`, semantisch neutral. |
| Ziele | Nutzen spaeter Auswertungen; schreiben keine Zielwertung in den Rohstatus. |
| Einheit | Eine feste Eingabeeinheit pro Tracking. |
| Bekannte Einheiten | Liter/ml, km/m/cm, Uhrzeit und Zeitdauer in Stunden/Minuten/Sekunden erhalten Einheitenfamilien und Umrechnung innerhalb der Familie. |
| Freitext-Einheiten | In Phase 12 permissive Zahlen-Labels ohne Umrechnung. Sie duerfen fuer Differenz/Summe kombiniert werden, auch wenn die Labels unterschiedlich sind. Beispiele: Schritte, Seiten, Wiederholungen, Kalorien oder eigene Beschriftungen. Spaeter soll eine Einheitenverwaltung strengere Kompatibilitaet ermoeglichen. |
| Dauer | Eigener Werttyp; Timer spaeter moeglich, Phase 12 manuell. |
| Uhrzeit | Eigener Werttyp mit Tagesbezug und optionalem Folgetag. |
| Buendel | Eigene ID, eigene Versionierung, zwei eigenstaendige Teil-Trackings, keine eigenen Entries. |
| Buendeloperationen | Zeitintervall, Differenz in beide Richtungen, Summe. |
| Buendelversionierung | Quellentausch gilt ab Datum; alte Zeitraeume bleiben nach alter Version. |
| Buendel aufloesen | Verbindung loesen, Teil-Trackings behalten und wieder getrennt anzeigen. |

## Spaeter festhalten

Nicht Teil von Phase 12, aber im Konzept bewusst vorgesehen:

- Skalen.
- Mehrere Werte oder Sessions pro Tag.
- Timer fuer Dauerwerte.
- Eigene Logbuch-Ansicht.
- Erinnerungen fuer reine Trackings.
- Ein Tracking in mehreren Buendeln.
- Buendel mit mehr als zwei Quellen.
- Weitere Formeln wie Verhaeltnis oder Prozentdifferenz.
- Eigene Uebersicht fuer Buendel und zusammengesetzte Auswertungen.

## Erfolgsbedingung

Phase 12 ist fachlich und technisch abgeschlossen, weil:

1. Werttypen, Status und Verbindlichkeit im Datenmodell abbildbar sind.
2. Reines Tracking ohne automatische leere Entries funktioniert.
3. Verbindliche Wert-Eingaben die bestehenden Missed Policies korrekt nutzen.
4. `recorded` in Abschlusslogik und Auswertungsvorbereitung korrekt behandelt
   wird.
5. Zahl, Dauer und Uhrzeit inklusive Einheit/Tagesbezug gespeichert und
   bearbeitet werden koennen.
6. Zwei-Werte-Buendel aus zwei eigenstaendigen Teil-Trackings erstellt,
   angezeigt und aufgeloest werden koennen.
7. Virtuelle Tracking-Tage fuer Matrix und Wert-Auswertung eindeutig ableitbar
   sind.
8. Tests die wichtigsten Status-, Policy-, Einheiten-, Uhrzeit-, Buendel- und
   Historisierungsfaelle abdecken.

## Pruefstand

| Datum | Pruefung | Ergebnis |
|---|---|---|
| 2026-07-26 | `dart format` fuer Phase-12a-Dateien | erfolgreich |
| 2026-07-26 | gezielte Analyse der Phase-12a-Dateien | keine Probleme gefunden |
| 2026-07-26 | neuer Foundation-Test fuer `recorded`, Werttypen, Einheiten und Buendeltypen | extern in PowerShell bestaetigt: `+5 All tests passed` |
| 2026-07-26 | Phase-12b-Code fuer Einzelwerte vorbereitet | Generator extern erfolgreich; gezielte Analyse gruen; externe Wert-Tests bestaetigt: `+2 All tests passed` |
| 2026-08-04 | Phase 12b abgeschlossen | Einzelwerte funktionieren in Erstellung, Bearbeitung, Tageskarte und abgeschlossenen einmaligen Aufgaben; Praxisfixes dokumentiert |
| 2026-08-04 | Phase 12c abgeschlossen | Reine Trackings bleiben ohne Entry sichtbar, erzeugen keine leeren Entries und werden im Habits-Tab separat als `Tracking` gruppiert |
| 2026-08-04 | Phase 12d abgeschlossen | Pflichtwerte nutzen bestehende Missed Policies; Tests fuer `recorded`, direkte Konsequenz, Puffer und Carryover ergaenzt |
| 2026-08-04 | Phase 12d extern bestaetigt | Gezielter Repository-Test `reines Tracking` lief extern mit `+2 All tests passed`; danach liefen die Pflichtwert-/Wert-Tests extern mit `All tests passed`. |
| 2026-08-04 | Phase 12e abgegrenzt | Fachliche Buendelregeln sind dokumentiert; technische Umsetzung bleibt offen, weil sie eine Drift-Schema-Erweiterung und UI-Anbindung benoetigt. |
| 2026-08-08 | Phase 12e.1/12e.2 Source umgesetzt | Buendel- und Buendelversionstabellen im Source-Code angelegt, `schemaVersion` auf 15 erhoeht und Migration vorbereitet; Generatorlauf wurde als naechster externer Schritt vorgemerkt. |
| 2026-08-08 | Phase 12e.3 extern abgeschlossen | `build_runner` lief extern warnungsfrei erfolgreich; `app_database.g.dart` enthaelt die neuen Buendel-Tabellen; `task_value_foundation_test.dart` bestaetigt mit `+5 All tests passed`. |
| 2026-08-10 | Phase 12e/12f extern abgeschlossen | Gezielter Repository-Test `Buendel` lief extern mit `+5 All tests passed`. Phase 12 ist damit als erster Ausbaustand abgeschlossen. |
