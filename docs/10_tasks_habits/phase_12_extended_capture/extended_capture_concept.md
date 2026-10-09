# Momentum - Phase 12: Konzept fuer erweiterte Erfassungsarten

Stand: 4. August 2026  
Status: Fachlich geklaert; Einzelwerte, reines Tracking und Pflichtwerte umgesetzt

## Zweck

Dieses Dokument fasst die Phase-12-Planung fuer Wert-Eingaben zusammen. Es ist
die fachliche Grundlage fuer Umsetzung, Tests, spaetere Wert-Auswertung,
Zielbewertung, Kartenkennzahlen und Firebase-Vorbereitung.

Phase 12 erweitert das bestehende Aufgaben-/Habit-System. Es entsteht keine
zweite Aufgabenlogik. Aufgaben, Habits, Instanzen, Definitionsversionen,
Missed Policies und Auswertungen bleiben die tragende Struktur.

## Grundentscheidung

Wert-Eingaben werden als normale Aufgaben-/Habit-Instanzen modelliert.

- Eine Aufgabe oder ein Habit definiert, was erfasst werden soll.
- Eine Instanz beschreibt einen konkreten fachlichen Tag.
- Ein gespeicherter Entry enthaelt den Wert, Status, Zeitpunkte, Herkunft und
  Notiz.
- Ziele bewerten spaeter die vorhandenen Rohdaten. Der Rohstatus wird nicht
  durch ein Ziel umgedeutet.

## Neue Eingabearten

Phase 12 umfasst diese Eingabearten:

| Eingabeart | Bedeutung | Beispiele |
|---|---|---|
| `number` | Zahl mit fester Einheit oder Freitext-Einheit | Gewicht, Kilometer, Liter, Seiten, Glaeser |
| `duration` | Dauerwert, kanonisch gespeichert | Sportdauer, Meditation, Schlafdauer |
| `time_of_day` | einzelne Uhrzeit mit Bezug zum fachlichen Tag | Bettgehzeit, Aufstehzeit, Medikament um 08:00 |
| Zwei-Werte-Buendel | zwei eigenstaendige Trackings gemeinsam anzeigen und auswerten | Schlafdauer, Kalorienbilanz |

Skalen bleiben vorbereitet, aber nicht Teil von Phase 12.

## Verbindlichkeit

Nach der Auswahl der Eingabeart wird frueh in der Erstellung die
Verbindlichkeit festgelegt.

| Verbindlichkeit | Bedeutung | Folgen |
|---|---|---|
| Reines Tracking | Wert erfassen, wenn er vorhanden ist; keine Pflicht und keine Fristlogik | taeglich, habit-artig, keine Missed Policy, virtuelle leere Tage |
| Verbindliche Eingabe | Die Eingabe soll nachgehalten werden und darf eine Konsequenz haben | Rhythmus, Missed Policy, Puffer, Carryover und `failure` moeglich |

Die genaue UI-Bezeichnung wird spaeter festgelegt. Inhaltlich ist die
Konfiguration jedoch ein echtes Feld und kein reiner UI-Text.

### Reines Tracking

Reines Tracking ist immer habit-artig und taeglich.

- Es erscheint im Habits-Tab.
- Es wird unter offenen/verbindlichen Habits und ueber erledigten Habits
  gruppiert.
- Es hat keine Missed Policy.
- Es hat keinen Puffer.
- Es hat kein Carryover.
- Es hat keinen frei waehlbaren Rhythmus.
- Es bleibt in der Tracking-Gruppe sichtbar, auch wenn der heutige Wert bereits
  eingetragen wurde.
- Pro Tracking und Tag gibt es genau einen Wert.

Leere Tage werden nicht automatisch gespeichert. Stattdessen gilt:

| Situation | Anzeige/Auswertung | Speicherung |
|---|---|---|
| Heute ohne Wert | virtuell `pending` | kein Entry |
| Vergangener leerer Tracking-Tag | virtuell `no_entry` | kein Entry |
| Wert eingetragen | `recorded` | echter Entry |
| Nutzer setzt bewusst Kein Eintrag oder Notiz | `no_entry` | echter Entry |
| Spaetere Korrektur | gewaehlter Status/Wert | echter Entry |

Diese virtuelle Behandlung spart spaetere Firebase-Schreibvorgaenge. Die
Monatsmatrix kann trotzdem jeden Tag anzeigen, weil sie geplante Tracking-Tage
aus Startdatum, Versionsdaten und vorhandenen Entries ableitet.

### Verbindliche Wert-Eingabe

Verbindliche Wert-Eingaben verwenden dieselben Ablaufmoeglichkeiten wie
bisherige Status-Aufgaben:

- keine Missed Policy, falls offen bleiben fachlich erlaubt ist
- direkte Konsequenz
- Puffer mit Folgeregel
- Carryover mit Maximum und Konsequenz, wenn der Rhythmus es erlaubt

Ein fehlender Wert kann durch manuelle oder automatische Entscheidung zu
`failure` oder `no_entry` werden. `failure` bedeutet bei Wert-Eingaben:
Pflicht-Eingabe verpasst. Es bedeutet nicht, dass der eingegebene Wert schlecht
war.

## Neuer Status `recorded`

Fuer Wert-Eingaben wird ein neuer Status eingefuehrt:

| Status | Bedeutung bei Wert-Eingaben |
|---|---|
| `pending` | heute oder waehrend einer Frist noch offen |
| `recorded` | Wert wurde erfasst |
| `failure` | verbindliche Eingabe wurde verpasst |
| `no_entry` | neutral kein Wert vorhanden |

`recorded` ersetzt bei Wert-Eingaben den positiven Abschluss `success`.

- Bei Abhaken und Ja/Nein bleibt `success` erhalten.
- Bei Zahl, Dauer und Uhrzeit bedeutet Wert vorhanden: `recorded`.
- `recorded` wirkt fuer Abschlusslogik wie ein positiver Abschluss.
- `recorded` loest bei abschlussgebundenen Rhythmen eine Folgeinstanz aus.
- `recorded` zaehlt fuer Vollstaendigkeit als abgeschlossen.
- Zielauswertungen duerfen spaeter aus `recorded` Zielerfolg oder
  Zielverfehlung ableiten, schreiben diese Bewertung aber nicht in den
  Rohstatus.

Eine manuelle `failure`-Option soll bei verbindlichen Wert-Eingaben vorhanden
sein, aber nicht prominent. Bei reinem Tracking wird `failure` nicht angeboten.

## Werte und Einheiten

Jedes Einzeltracking hat eine feste Eingabeeinheit.

### Bekannte Einheiten

Bekannte Einheiten besitzen eine Einheitenfamilie und koennen innerhalb dieser
Familie normalisiert werden.

Beispiele:

- Laenge: `mm`, `cm`, `m`, `km`
- Masse: `g`, `kg`
- Volumen: `ml`, `l`
- Dauer: Sekunden, Minuten, Stunden
- Energie: `kcal`

Bekannte Einheiten duerfen innerhalb ihrer Familie fuer Auswertungen umgerechnet
werden.

### Freitext-Einheiten

Freitext-Einheiten sind reine Labels ohne Umrechnung.

Beispiele:

- Seiten
- Glaeser
- Wiederholungen
- Portionen
- Kaffee

Freitext-Einheiten sind in Phase 12 permissiv. Sie werden als einfache
Zahlentrackings behandelt und duerfen fuer Differenz oder Summe kombiniert
werden, auch wenn die Labels unterschiedlich sind. Beispiel: `3000 kcal -
200 Schritte` ist technisch erlaubt, auch wenn es fachlich selten sinnvoll ist.

Der Grund: Solange eigene Einheiten frei getippt werden, waere eine strenge
Textgleichheit zu fehleranfaellig. Tippfehler oder unterschiedliche
Schreibweisen duerfen keine Datenmodell-Blocker erzeugen.

Spaeter soll es eine eigene Einheitenverwaltung geben. Dann koennen Nutzende
eigene Einheiten anlegen und beim Erstellen auswaehlen. Ab diesem Zeitpunkt
kann die App wieder strenger pruefen, ob zwei Einheiten wirklich kompatibel
sind.

### Uhrzeit und Dauer

Uhrzeit ist ein eigener Werttyp und keine normale Einheit. `60 + 60` hat bei
Zeitangaben eine andere Bedeutung als bei Laengen oder Zaehleinheiten.

Dauer ist ebenfalls ein eigener Werttyp. Sie wird kanonisch gespeichert,
zunaechst manuell eingegeben und spaeter optional durch einen Timer befuellt.
Timer-Metadaten wie Start, Stop, Pausen oder manuelle Korrekturen sind nicht
Teil von Phase 12.

## Uhrzeiten und Tagesbezug

Eine Uhrzeit allein reicht fuer Schlaf, Fasten und aehnliche Faelle nicht immer.
Deshalb braucht `time_of_day` einen fachlichen Bezug zur Instanz.

Eine Uhrzeit wird als Zeitpunkt relativ zum `scheduledDate` interpretiert:

- gleicher Kalendertag: `scheduledDate + Uhrzeit`
- Folgetag erlaubt: `scheduledDate + 1 Tag + Uhrzeit`

Beispiel:

- Instanz Mittwoch
- Schlafbeginn Mittwoch 23:00
- Schlafende Donnerstag 10:00
- Dauer: 11 Stunden

Phase 12 muss deshalb fuer passende Uhrzeit-Trackings erlauben, dass eine
Uhrzeit fachlich zum Folgetag der Instanz gehoert.

## Zwei-Werte-Buendel

Ein Buendel verbindet zwei eigenstaendige Trackings und zeigt sie in einer
gemeinsamen Karte. Die Teil-Trackings bleiben fachlich und technisch eigene
Aufgaben/Habits mit eigenen Entries.

Ein Buendel:

- besitzt eine eigene ID,
- besitzt eigene versionierte Definitionen,
- besitzt keine eigenen Entries,
- schreibt Eingaben auf die beiden Teil-Trackings,
- ersetzt die Teil-Tracking-Karten in der Tagesansicht,
- zeigt in der Detailansicht die Auswertungen fuer Teilwert A, Teilwert B und
  den abgeleiteten Wert,
- kann spaeter aufgeloest werden, ohne die Teil-Trackings zu loeschen.

Phase 12e verknuepft zuerst vorhandene Wert-Trackings. Ein spaeterer
Komfort-Flow darf direkt ein Buendel erstellen und dabei intern die zwei
Teil-Trackings mit anlegen. Auch dann bleiben die Teil-Trackings eigenstaendig,
damit ein Buendel wieder getrennt werden kann.

### Buendeltypen in Phase 12

| Buendeltyp | Teilwerte | Abgeleiteter Wert |
|---|---|---|
| Zeitintervall | Uhrzeit Start + Uhrzeit Ende | Ende minus Start = Dauer |
| Differenz | kompatibler Wert A + kompatibler Wert B | A - B oder B - A |
| Summe | kompatibler Wert A + kompatibler Wert B | A + B |

Beispiele:

- Schlafdauer: Bettgehzeit + Aufstehzeit -> Dauer
- Fastenfenster: Fastenbeginn + Fastenende -> Dauer
- Kalorienbilanz: kcal Aufnahme - kcal Verbrauch -> Differenz
- Gesamtzeit: Dauer A + Dauer B -> Summe

Wichtig fuer Phase 12e: Neben Uhrzeit-Intervallen sind auch Zahlen-Differenzen
frueh relevant. Beispiel: Zwei Zahlentrackings `Kalorienaufnahme` und
`Kalorienverbrauch` koennen als Buendel `Kalorienbilanz` angezeigt werden.
Der abgeleitete Tageswert ist dann z. B. `Aufnahme - Verbrauch = +250 kcal`
oder `Verbrauch - Aufnahme = -250 kcal`, je nach gewaehlter Richtung.

Durchschnitt, Minimum, Maximum, Wochen-/Monatsvergleich und Zielbewertung des
abgeleiteten Werts gehoeren zu Phase 13 und Phase 14. Phase 12 stellt den
Tageswert und die Struktur bereit.

### Buendelstatus

Der Buendelstatus wird aus den zwei Teil-Entries abgeleitet. Die Teil-Entries
bleiben die Quelle der Wahrheit.

| Teilzustand | Buendelanzeige |
|---|---|
| beide Werte fehlen | leer / virtuell `pending` oder `no_entry`, je nach Tag und Verbindlichkeit |
| ein Wert vorhanden | teilweise erfasst |
| beide Werte vorhanden | vollstaendig erfasst; abgeleiteter Wert berechenbar |
| ein Teilwert `failure` | Buendel zeigt den betroffenen Fehlerzustand |

Ein teilweise erfasstes Buendel bleibt sichtbar. Beim Schlaf kann abends die
Bettgehzeit eingetragen und morgens die Aufstehzeit ergaenzt werden.

### Buendelversionierung

Buendeldefinitionen werden versioniert. Eine Version enthaelt mindestens:

- Name
- Typ/Formel
- Quelle A
- Quelle B
- Rollen der Quellen, z. B. Start/Ende oder Aufnahme/Verbrauch
- Formelrichtung, z. B. A - B oder B - A
- Anzeige- und Sortierinformationen
- gueltig ab

Wenn eine Quelle getauscht wird, gilt die Aenderung ab einem gewaehlten Datum.
Alte Zeitraeume verwenden die alte Buendelversion. Es gibt keine rueckwirkende
stille Umdeutung alter Auswertungen.

### Buendel aufloesen und Teil-Trackings

Ein Buendel kann geloest werden, ohne die zwei Teil-Trackings zu loeschen. Nach
dem Aufloesen erscheinen die Teil-Trackings wieder als eigene Karten.

Wenn ein Teil-Tracking Teil eines aktiven Buendels ist:

- erscheint es nicht doppelt in der Tages-/Habit-Ansicht,
- wird es dort durch die gemeinsame Buendelkarte ersetzt,
- bleibt es in Details und Bearbeitung als eigenstaendige Information sichtbar.
- kann es nicht hart geloescht werden.

Auch nach dem Aufloesen bleibt eine historische Buendelversion als Referenz
bestehen. Deshalb werden solche Teil-Trackings vorerst ebenfalls nicht hart
geloescht. Das passt zur geplanten Historisierung; Papierkorb/Archiv und
spaetere Loeschregeln sollen daraus eine nutzerfreundliche Loesung machen.

Phase 12 erlaubt ein Teil-Tracking nur in einem sichtbaren Eingabe-Buendel.
Langfristig soll ein Tracking in mehreren Buendeln verwendet werden koennen.
Wenn das passiert, soll es wahrscheinlich wieder als eigenstaendige Eingabekarte
sichtbar sein und die Buendel nur mit seinem Wert befuellen.

### Kompatibilitaet

Phase 12 verbindet nur kompatible Werte.

- Zeitintervall: nur Uhrzeit + Uhrzeit
- Differenz: gleicher Werttyp und bei bekannten Einheiten kompatible Familie
- Summe: gleicher Werttyp und bei bekannten Einheiten kompatible Familie
- beide Teil-Trackings muessen in Phase 12 denselben Aufgabenbereich haben
  (z. B. beide Habit), damit die gemeinsame Karte in einer Ansicht eindeutig
  angezeigt werden kann
- bekannte Einheiten: gleiche Familie ist erlaubt
- Freitext-Einheiten: in Phase 12 permissiv kombinierbar, solange es
  Zahlentrackings sind
- keine Mischung aus Zahl und Dauer
- keine Mischung aus Uhrzeit und Zahl
- keine Mischung aus inkompatiblen bekannten Einheiten, z. B. Liter und kcal

## Auswertung und Ziele

Phase 12 erzeugt Rohdaten. Phase 13 wertet diese Rohdaten aus. Phase 14 legt
Ziele auf die Auswertungen.

Wert-Auswertungen muessen unterscheiden:

- echte Werte (`recorded`)
- virtuelle leere Tracking-Tage
- gespeicherte `no_entry`-Eintraege
- `failure` bei verbindlichen Wert-Eingaben
- heutige offene Eingaben
- teilweise erfasste Buendel

Moegliche Wert-Auswertungen:

- Summe
- Durchschnitt
- Minimum und Maximum
- Verlauf/Trend
- Haeufigkeit der Eingaben
- Differenz zwischen zwei Werten
- Dauer aus Zeitintervallen
- Startzeit, Endzeit und Dauer bei Intervallen

Ziele ziehen ihre Daten spaeter aus diesen Auswertungen. Beispiele:

- mindestens 2 Liter pro Tag
- durchschnittlich 7,5 Stunden Schlaf
- maximal 30 Minuten Social Media
- Kalorienbilanz im Wochendurchschnitt -300 kcal
- 3x pro Woche mindestens 20 Minuten Sport

Der Rohstatus `recorded` bleibt erhalten. Ob ein Wert das Ziel erreicht, ist
eine separate Zielbewertung.

## Virtuelle Instanzen und Monatsmatrix

Fuer reines Tracking soll die App leere Tage nicht automatisch speichern.
Trotzdem muessen Auswertungen und Raster jeden relevanten Tag anzeigen koennen.

Dafuer braucht die Auswertung eine virtuelle Tageslogik:

1. Zeitraum bestimmen.
2. Gueltige Definitionen und Start-/Enddaten pruefen.
3. Fuer jeden geplanten Tracking-Tag den vorhandenen Entry suchen.
4. Wenn ein Entry existiert, dessen Status und Wert verwenden.
5. Wenn kein Entry existiert:
   - heute oder Zukunft: virtuell offen,
   - vergangener Tag: virtuell `no_entry`.

Echte Entries entstehen nur bei echter Nutzeraktion oder automatischer
Pflicht-Policy.

Virtuelle `no_entry`-Tage duerfen nicht mit bewusst gespeicherten Ausnahmen
verwechselt werden. Wenn ein Nutzer einen virtuellen Tag bearbeitet, wird ein
echter Entry angelegt.

## Auswirkungen auf bestehende Struktur

### TaskEntry

Das aktuelle Feld `numberValue` reicht langfristig nicht allein. Phase 12
braucht eine Wertstruktur fuer:

- Werttyp,
- numerischen kanonischen Wert,
- Uhrzeitbezug,
- Dauer,
- Einheit,
- optionalen zweiten Teilwert ueber Buendel,
- Status `recorded`.

Ob diese Struktur ueber weitere Spalten, eine Werttabelle oder JSON-nahe
Hilfsstruktur umgesetzt wird, ist technische Umsetzungsplanung. Wichtig ist,
dass die Struktur sync-faehig, versionierbar und auswertbar bleibt.

### Aufgabendefinition und Definitionsversion

Neue fachlich relevante Felder muessen in Aufgabe und Definitionsversion
gespeichert werden, insbesondere:

- Eingabeart,
- Verbindlichkeit,
- Einheit und Einheitenfamilie,
- Dezimal-/Formatregeln,
- Uhrzeit-Tagesbezug,
- bei Buendel: Quelle A, Quelle B, Typ/Formel und Richtung.

Bestehende Entries behalten ihre damalige Definition. Neue Definitionen gelten
ab dem gewaehlten Datum.

### Scheduler

Der Scheduler darf fuer reines Tracking keine leeren vergangenen Entries
materialisieren. Er muss aber weiterhin heutige/angezeigte virtuelle Tracking-
Karten bereitstellen koennen.

Fuer verbindliche Wert-Eingaben bleiben direkte Konsequenz, Puffer und
Carryover echte Zustandsaenderungen und erzeugen echte Entries.

### Historisierung und Korrektur

Virtuelle Tage sind nicht historisch gespeichert. Sobald ein virtueller Tag
bearbeitet, kommentiert oder umgewertet wird, wird er materialisiert.

Sammelkorrekturen muessen deshalb spaeter klar unterscheiden:

- gespeicherte Entries,
- virtuelle leere Tracking-Tage,
- bewusst gespeicherte `no_entry`-Ausnahmen,
- automatisch entstandene `no_entry`-Eintraege aus Pflicht-Policies.

### Papierkorb

Beim Papierkorb werden gespeicherte Daten eingefroren. Virtuelle leere
Tracking-Tage fuer die Papierkorbzeit sollen nicht nacherzeugt werden und
duerfen nach Wiederherstellung nicht als kuenstlicher Rueckstand entstehen.

### Firebase

Die Phase-12-Struktur soll Firebase-Kosten beruecksichtigen:

- Reine Anzeige erzeugt keine Schreibvorgaenge.
- Virtuelle leere Tracking-Tage werden nicht synchronisiert.
- Nur echte Werte, bewusste Ausnahmen, Notizen, Korrekturen und automatische
  Pflicht-Konsequenzen werden geschrieben.
- Buendel speichern Definitionen und Verknuepfungen, aber keine doppelten
  Tageswerte.

## UI-Struktur

Die Begriffe werden spaeter psychologisch und sprachlich finalisiert. Fachlich
ist die Erstellung so gedacht:

1. Aufgabe/Habit oder Tracking erstellen.
2. Eingabeart waehlen: Abhaken, Ja/Nein, Zahl, Dauer, Uhrzeit oder Buendel.
3. Bei Wert-Eingaben Verbindlichkeit waehlen.
4. Bei reinem Tracking: taeglich, habit-artig, keine weiteren Policy-Felder.
5. Bei verbindlicher Eingabe: Rhythmus, Missed Policy, Puffer, Carryover und
   Konsequenz wie bisher.
6. Werttyp-spezifische Felder zeigen: Einheit, Dezimalstellen, Uhrzeitbezug,
   Buendelquellen.

Im Habits-Tab gilt fuer Phase 12:

1. offene/verbindliche Habits
2. reine Trackings
3. erledigte/verarbeitete Habits

Tracking-Karten bleiben in der Tracking-Gruppe sichtbar, auch wenn der heutige
Wert eingetragen ist.

Buendelkarten zeigen zwei Eingabefelder und den abgeleiteten Wert, sobald er
berechenbar ist.

## Umsetzungsschnitt

Ein moeglicher abarbeitbarer Umsetzungsschnitt:

| Schritt | Inhalt |
|---:|---|
| 12.1 | Begriffe und Konstanten fuer Eingabeart, Verbindlichkeit, Wertstatus und Einheiten einfuehren |
| 12.2 | Datenmodell fuer Wertfelder, `recorded` und virtuelle Tracking-Tage planen |
| 12.3 | Aufgaben- und Definitionsversionen um Wert-/Tracking-Konfiguration erweitern |
| 12.4 | Repository-Methoden fuer Zahl, Dauer und Uhrzeit ergaenzen |
| 12.5 | Reines Tracking ohne automatische leere Entries implementieren |
| 12.6 | Habits-Tab um Tracking-Gruppe erweitern |
| 12.7 | Eingabewidgets fuer Zahl, Dauer und Uhrzeit bauen |
| 12.8 | Zwei-Werte-Buendel mit eigener Definition, zwei Quellen und gemeinsamer Karte modellieren |
| 12.9 | Buendelversionierung, Aufloesen und Quellentausch ab Datum planen/umsetzen |
| 12.10 | Analytics-Schnittstelle so vorbereiten, dass Phase 13 virtuelle Tage und Buendelwerte auswerten kann |
| 12.11 | Tests fuer Status, virtuelle Tage, Pflicht-Policies, Einheiten, Buendel und Historisierung ergaenzen |
| 12.12 | Dokumentation, Matrix und History aktualisieren |

## Spaetere Erweiterungen

Nicht Teil von Phase 12, aber bewusst offen halten:

- Skalen, z. B. Stimmung, Schmerz, Energie.
- Mehrere Werte oder Sessions pro Tracking und Tag, z. B. dreimal 10 Minuten
  Spazieren; Tageswert waere dann Summe oder Session-Auswertung.
- Timer fuer Dauerwerte; der Timer schreibt spaeter denselben Dauerwert.
- Timer-Metadaten wie Start, Stop, Pause, manuelle Korrektur.
- Logbuch-Ansicht fuer reine Trackings, falls die Tracking-Gruppe im Habits-Tab
  nicht reicht.
- Erinnerungen fuer Logbuch-/Tracking-Faelle, z. B. spaetestens alle 10 Tage
  wiegen.
- Ein Tracking in mehreren Buendeln verwenden.
- Buendel mit mehr als zwei Quellen.
- Weitere Buendeloperationen wie Verhaeltnis, Prozentdifferenz oder komplexere
  Formeln.
- Mehrere Einnahme-/Ausgabeposten oder mehrere Verbrauchsquellen pro Tag.
- Eine eigene Anzeige fuer alle Buendel oder zusammengesetzte Auswertungen.
- Kartenkennzahlen, die aus Teilwert A, Teilwert B oder dem abgeleiteten Wert
  gewaehlt werden.

## Offene Umsetzungsfragen

Diese Punkte sind keine fachlichen Blocker, muessen aber vor oder waehrend der
Umsetzung entschieden werden:

- Welche technische Struktur speichert Wertdaten am besten?
- Wie werden bekannte Einheiten und Freitext-Einheiten im Code modelliert?
- Wie wird der Uhrzeitbezug fuer Folgetag-Eingaben in der UI verstaendlich?
- Wie genau werden virtuelle Tracking-Tage in Streams und Live-Detailansichten
  berechnet?
- Wie werden virtuelle Tage in Sammelkorrekturen angezeigt?
- Welche Migrationsregel gilt fuer vorhandenes `numberValue`?
- Welche Teile der Wert-Auswertung muessen schon in Phase 12 sichtbar sein und
  welche starten erst in Phase 13?
