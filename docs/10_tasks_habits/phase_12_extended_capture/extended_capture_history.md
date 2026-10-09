# Momentum - Erweiterte Erfassungsarten: Verlauf

Stand: 4. August 2026  
Status: Phase 12 abgeschlossen und extern bestaetigt

## Zweck

Dieses Dokument haelt fest, welche Entscheidungen fuer Phase 12 getroffen
wurden und warum. Die ausfuehrliche, abarbeitbare Fachplanung steht in
[`extended_capture_concept.md`](extended_capture_concept.md).

## Ausgangslage nach Phase 11

Phase 11 hat die Status-Auswertung in einer ersten Ausbaustufe abgeschlossen.
Phase 12 kann deshalb auf derselben Aufgaben-/Instanzstruktur aufbauen und muss
keine eigene Aufgabenlogik schaffen.

Wichtig fuer Phase 12:

- `TaskEntry` enthaelt bereits `numberValue`.
- Statuswerte bleiben relevant: `pending`, `success`, `failure`, `no_entry`.
- Fuer Wert-Eingaben kommt `recorded` hinzu.
- Fehlende Werte muessen sichtbar auswertbar bleiben.
- Firebase kommt erst nach den erweiterten Eingabearten, damit das Datenmodell
  vorher stabiler und schreibsparsam vorbereitet ist.

## Entscheidungsverlauf

### Aufgabenstruktur

Es wurde entschieden, dass Wert-Eingaben keine eigene parallele Aufgabenwelt
erhalten. Aufgaben/Habits, Instanzen, Scheduler, Definitionsversionen und
Auswertungen bleiben die gemeinsame Basis.

### Reines Tracking und verbindliche Eingabe

Nach der Eingabeart braucht die Aufgabe eine echte gespeicherte
Verbindlichkeits-Konfiguration.

- Reines Tracking: taeglich, habit-artig, keine Missed Policy, keine Fristen.
- Verbindliche Eingabe: Missed Policy, Puffer, Carryover und `failure`
  moeglich.

Diese Auswahl soll frueh im Erstellungsformular stehen, weil der Weg ueber
Missed Policy allein zu voraussetzungsreich waere.

### Reines Tracking im Habits-Tab

Reines Tracking bleibt im Habits-Tab und wird dort gruppiert:

1. offene/verbindliche Habits
2. reine Trackings
3. erledigte/verarbeitete Habits

Tracking-Karten bleiben in der Tracking-Gruppe sichtbar, auch wenn der heutige
Wert eingetragen wurde.

### Virtuelle leere Tracking-Tage

Fuer reines Tracking werden leere vergangene Tage nicht automatisch als Entries
gespeichert.

Grund:

- Die Monatsmatrix kann leere Tage aus Startdatum, Definition, Datum und
  vorhandenen Entries ableiten.
- Firebase-Schreibkosten werden reduziert.
- Reine Anzeige und Scheduler-Laeufe ohne echte Aenderung sollen keine
  Schreibvorgaenge erzeugen.

Regel:

- Heute ohne Wert: virtuell `pending`.
- Vergangener leerer Tracking-Tag: virtuell `no_entry`.
- Wert, Notiz, bewusster Kein-Eintrag oder Korrektur: echter Entry.

### Status `recorded`

Fuer Wert-Eingaben ersetzt `recorded` den Status `success`.

- Wert vorhanden: `recorded`.
- `recorded` wirkt fuer Abschlusslogik wie `success`.
- Bei abschlussgebundenen Rhythmen loest `recorded` den naechsten Termin aus.
- Zielerreichung bleibt eine eigene Auswertung und wird nicht in den Rohstatus
  geschrieben.

`failure` bleibt fuer verbindliche Wert-Eingaben moeglich und bedeutet:
Eingabepflicht verpasst.

### Werttypen

Phase 12 umfasst:

- Zahl
- Dauer
- Uhrzeit
- Zwei-Werte-Buendel

Skalen bleiben spaeter.

### Einheiten

Ein Tracking besitzt eine feste Eingabeeinheit. Bekannte Einheiten erhalten
Einheitenfamilien und Umrechnung. Freitext-Einheiten sind reine Labels ohne
Umrechnung.

Beschlossene bekannte Einheiten fuer die erste Umsetzung:

- Volumen: Liter und Milliliter.
- Strecke: Kilometer, Meter und Zentimeter.
- Uhrzeit: Tageszeit.
- Dauer: Stunden, Minuten und Sekunden.

Andere reine Zahlenwerte, zum Beispiel Schritte, Seiten, Wiederholungen oder
eigene Begriffe, werden zunaechst ueber eine eigene Beschriftung abgebildet.
Sie bleiben berechenbar, werden aber nur dann gemeinsam ausgewertet, wenn die
Beschriftung fachlich zusammenpasst.

### Uhrzeiten und Schlaftracking

Schlaftracking ist ein wichtiger Anwendungsfall. Deshalb muessen Uhrzeiten einen
Tagesbezug kennen.

Eine Uhrzeit kann zum `scheduledDate` oder zum Folgetag der Instanz gehoeren.
So kann Mittwoch 23:00 bis Donnerstag 10:00 korrekt als 11 Stunden ausgewertet
werden.

### Zwei-Werte-Buendel

Ein Buendel verbindet zwei eigenstaendige Trackings und zeigt sie in einer
gemeinsamen Karte.

Beschlossen:

- Buendel hat eigene ID.
- Buendel hat eigene versionierte Definitionen.
- Buendel hat keine eigenen Entries.
- Teil-Trackings bleiben eigenstaendig.
- Die Buendelkarte schreibt auf die Teil-Entries.
- Teil-Trackings werden in der Tagesansicht ausgeblendet, solange das Buendel
  aktiv ist.
- Beim Aufloesen bleiben die Teil-Trackings erhalten und werden wieder sichtbar.

Phase-12-Buendel:

- Zeitintervall: Startzeit + Endzeit -> Dauer.
- Differenz: A - B oder B - A.
- Summe: A + B.

### Teilweise erfasste Buendel

Ein Buendel kann teilweise erfasst sein.

Beispiel Schlaf:

- Bettgehzeit vorhanden, Aufstehzeit fehlt: teilweise erfasst.
- Beide Werte vorhanden: vollstaendig erfasst, Dauer berechenbar.

Start- und Endzeit koennen einzeln ausgewertet werden. Die Dauer nutzt nur
vollstaendige Paare.

### Buendelversionierung

Wenn eine Quelle eines Buendels getauscht wird, gilt die Aenderung ab einem
gewaehlten Datum. Alte Zeitraeume bleiben mit alter Quelle/Formel auswertbar.

Damit wird die bestehende Regel beibehalten, dass historische Daten nicht
unbemerkt durch spaetere Aenderungen umgedeutet werden.

## Spaeter notierte Ideen

Diese Punkte sind bewusst nicht Teil der ersten Phase-12-Umsetzung, sollen aber
nicht verloren gehen:

- Skalen fuer Stimmung, Schmerz, Energie.
- Mehrere Werte oder Sessions pro Tracking und Tag, z. B. dreimal 10 Minuten
  Spazieren; spaeter mit Tagesgesamtsumme und optional Uhrzeit/Notiz je Session.
- Timer fuer Dauerwerte; zunaechst nur manueller Dauerwert.
- Timer-Metadaten erst spaeter, falls echte Session-Logik gebraucht wird.
- Eigenes Logbuch-Tab oder Logbuchbereich fuer reine Trackings, falls die
  Tracking-Gruppe im Habits-Tab nicht reicht.
- Erinnerungen fuer reines Tracking, z. B. spaetestens alle 10 Tage wiegen.
- Ein Tracking in mehreren Buendeln verwenden; dann wahrscheinlich wieder als
  eigene Eingabekarte anzeigen und die Buendel daraus befuellen.
- Buendel mit mehr als zwei Quellen.
- Weitere Buendeloperationen wie Verhaeltnis, Prozentdifferenz oder komplexe
  Formeln.
- Separate Uebersicht fuer alle Buendel oder zusammengesetzte Aufgaben.
- Kartenkennzahlen aus Teilwert A, Teilwert B oder abgeleitetem Wert waehlen.

## Bekannte Umsetzungspruefungen

Vor oder waehrend der Umsetzung muessen geprueft werden:

- Wie `recorded` in vorhandene Status-Auswertungen integriert wird.
- Wie virtuelle Tracking-Tage in Analytics-Streams, Monatsmatrix und
  Einzelantwortlisten erscheinen.
- Wie virtuelle Tage bei Korrekturen materialisiert werden.
- Wie vorhandenes `numberValue` migriert oder in eine neue Wertstruktur
  ueberfuehrt wird.
- Wie Aufgabe und Definitionsversion um Werttyp, Verbindlichkeit, Einheit,
  Uhrzeitbezug und Buendeldefinition erweitert werden.
- Wie Buendeldefinitionen versioniert und bei Quellentausch ab Datum ausgewertet
  werden.
- Wie Papierkorbzeiten bei virtuellen Tracking-Tagen behandelt werden, damit
  keine kuenstlichen Luecken oder Rueckstaende entstehen.
- Wie Firebase-Synchronisierung nur echte Aenderungen schreibt.

## Umsetzung

### 2026-07-26 - Phase 12a gestartet

Phase 12 wurde in kleinere Teilabschnitte 12a bis 12f gegliedert, damit die
Umsetzung kontrollierbar bleibt:

- 12a: Grundlage und zentrale Begriffe.
- 12b: Einzelwerte Zahl, Dauer und Uhrzeit.
- 12c: reines Tracking und virtuelle leere Tage.
- 12d: verbindliche Wert-Eingaben mit Missed Policies.
- 12e: Zwei-Werte-Buendel.
- 12f: Abschluss, Tests und Dokumentation.

In 12a wurden die zentralen technischen Begriffe vorbereitet:

- Status `recorded` fuer erfasste Wertdaten.
- Werttypen `number`, `duration` und `time_of_day`.
- Verbindlichkeit `pure_tracking` und `required`.
- Einheitenfamilien fuer Volumen, Strecke, Dauer, Uhrzeit und eigene Zahlen.
- Buendeltypen fuer Zeitintervall, Differenz und Summe.

`recorded` gilt technisch als abgeschlossen und als positive
Abschlussausloesung, ist aber nicht dasselbe wie ein Zielerfolg. Ob ein Wert
gut oder schlecht ist, wird erst in Phase 13/14 ausgewertet.

Pruefung:

- `dart format` fuer die betroffenen Dateien erfolgreich.
- Gezielte Analyse der betroffenen Dateien erfolgreich.
- Ein kleiner Foundation-Test wurde angelegt. Der Testlauf hing in der
  Codex-/Flutter-Umgebung nach 45 Sekunden ohne Ergebnis; die Dart-Prozesse
  wurden danach beendet.
- Externe PowerShell-Pruefung durch den Nutzer:
  `flutter test --no-pub test\features\aufgaben\data\task_value_foundation_test.dart`
  mit `+5 All tests passed`.

### 2026-07-26 - Phase 12b begonnen

Phase 12b setzt die ersten echten Einzelwerte um. Begonnen wurde mit:

- eigener Tabelle fuer Wertdaten je Entry,
- Wert-Konfigurationsfeldern an Aufgabe und Definitionsversion,
- Schema-Version 14 vorbereitet,
- Repository-Methode zum Speichern von Zahl, Dauer und Uhrzeit als `recorded`,
- einfacher Wert-Konfiguration in Erstellung und Bearbeitung,
- einfacher Karten-Eingabe fuer Zahl, Dauer und Uhrzeit.

Wichtig: Wertdaten werden nicht nur weiter in `task_entries.numberValue`
ausgebaut, sondern in einer eigenen Struktur gespeichert. Das haelt die
Instanz-Tabelle schlanker und bereitet Dauer, Uhrzeit, Buendel und spaetere
Firebase-Synchronisierung sauberer vor.

Pruefstand:

- `dart format` fuer die betroffenen Dateien erfolgreich.
- `build_runner` hing in der Codex-/Flutter-Umgebung, lief aber extern in
  PowerShell erfolgreich durch und aktualisierte die generierte Drift-Datei.
- Eine Drift-Warnung wegen zusammengesetzter String-Konstanten in einer
  `CHECK`-Constraint wurde behoben.
- Gezielte Analyse der betroffenen Dateien inklusive Repository-Testdatei:
  keine Probleme gefunden.
- Der gezielte Wert-Testlauf haengt in der Codex-/Flutter-Umgebung nach
  60 Sekunden.
- Externe PowerShell-Pruefung durch den Nutzer:
  `flutter test --no-pub test\features\aufgaben\data\aufgaben_repository_test.dart --plain-name "Wert"`
  mit `+2 All tests passed`.

### 2026-07-28 - Praxisfehler beim Speichern von Wert-Aufgaben behoben

Beim Praxischeck war der Button `Eintrag speichern` deaktiviert, sobald in der
freien Erstellung `Wert erfassen` gewaehlt wurde.

Ursache:

- Die Erstellungsmaske zeigte Werttyp, Verbindlichkeit und Einheit korrekt an.
- Diese Werte wurden auch an das Repository zum Speichern weitergegeben.
- Sie wurden aber nicht in die zentrale Konfigurationsvalidierung uebernommen.
- Dadurch bewertete die Validierung die Aufgabe intern als `Wert erfassen`
  ohne gueltigen Werttyp und sperrte den Speicherbutton.

Korrektur:

- Die Erstellungsmaske uebergibt Werttyp, Verbindlichkeit, Einheit und
  Beschriftung jetzt auch an die `TaskConfiguration`.
- Die Normalisierung uebernimmt gueltige Wertfelder zurueck in den UI-Zustand.
- Ein Validator-Test fuer `value capture with known unit can be saved` wurde
  ergaenzt.

Pruefung:

- `dart format` erfolgreich.
- Gezielte Analyse der geaenderten Dateien inklusive Validator-Testdatei:
  keine Probleme gefunden.
- Der gezielte Flutter-Test haengte in der Codex-Umgebung.
- Externe PowerShell-Pruefung durch den Nutzer:
  `flutter test --no-pub test\features\aufgaben\data\task_configuration_validator_test.dart --plain-name "value capture"`
  mit `+1 All tests passed`.

### 2026-07-28 - Eigene Einheit in der Erstellung korrigiert

Beim Praxischeck funktionierten bekannte Einheiten wie `Liter`, aber eine eigene
Einheit liess sich nicht speichern.

Ursache:

- Die eigene Beschriftung wurde zwar im Textfeld angenommen.
- Die Erstellungs-/Bearbeitungsmaske hat beim Tippen aber keinen neuen
  UI-Zustand ausgelöst.
- Dadurch blieb die zentrale Validierung beim alten leeren Wert und der
  Speicherbutton blieb gesperrt.

Korrektur:

- Eingaben im Feld `Eigene Beschriftung` aktualisieren jetzt den UI-Zustand.
- Die Validierung bekommt den aktuellen Text sofort mit.
- Validator-Faelle fuer eigene Einheit ohne und mit Beschriftung wurden
  ergaenzt.

Pruefung:

- `dart format` erfolgreich.
- Gezielte Analyse der betroffenen Dateien: keine Probleme gefunden.

### 2026-07-28 - Ansicht fuer abgeschlossene einmalige Aufgaben ergaenzt

Beim Praxischeck fiel auf: Eine einmalige Wert-Aufgabe verschwindet nach der
Eingabe aus der Tagesansicht. Das ist technisch nachvollziehbar, weil sie danach
`recorded` und damit abgeschlossen ist. Fachlich braucht der Nutzer aber einen
Ort, an dem abgeschlossene einmalige Aufgaben wiedergefunden werden koennen.

Korrektur:

- Neue Ansicht `Abgeschlossene Aufgaben` fuer erledigte/abgeschlossene
  einmalige Aufgaben.
- Zugang ueber ein neues Icon in der Aufgaben-Uebersicht.
- Die Liste zeigt einmalige Aufgaben mit endgueltigem Status, also auch
  Wert-Aufgaben mit `recorded`.
- Werte, Notizen, Details, Bearbeiten und Loeschen bleiben ueber die Karte
  erreichbar.
- Repository-Methode `watchCompletedOneTimeTasks()` ergaenzt.
- Repository-Test fuer abgeschlossene einmalige Wert-Aufgaben ergaenzt.

Pruefung:

- `dart format` erfolgreich.
- Gezielte Analyse der betroffenen Dateien: keine Probleme gefunden.
- Der gezielte Repository-Test haengte in der Codex-Umgebung.
- Externe PowerShell-Pruefung durch den Nutzer: `All tests passed`.
- Praxischeck in der App durch den Nutzer bestaetigt.

### 2026-07-28 - Aufgabenart-Wechsel erhaelt vorhandene Eingaben

Beim Praxischeck fiel auf: Wenn in der freien Erstellung die Aufgabenart
gewechselt wurde, wurden vorherige Einstellungen wie Rhythmus und
Erfassungsmodus auf Standardwerte zurueckgesetzt. Dadurch konnte zum Beispiel
eine bereits konfigurierte Wert-Erfassung verloren gehen.

Korrektur:

- Der Wechsel der Aufgabenart setzt nicht mehr pauschal Rhythmus,
  Erfassungsmodus und Missed-Konsequenz zurueck.
- Beim Wechsel zu `Habit` wird weiterhin ein Fälligkeitsdatum entfernt, weil
  Habits kein klassisches Fälligkeitsdatum nutzen.
- Falls ein Habit noch auf `Kein / Einmalig` steht, wird nur dieser fachlich
  unpassende Rhythmus auf `Täglich` gehoben.
- Alle weiterhin gueltigen Eingaben, insbesondere Werttyp, Verbindlichkeit,
  Einheit, Name und Beschreibung, bleiben erhalten.

Pruefung:

- Code gezielt geprueft; ein sinnvoller automatischer Test waere hier ein
  Widget-Test der Erstellungsmaske. Solche Tests werden aktuell bewusst nicht
  ohne ausdrueckliche Anforderung ausgefuehrt.

### 2026-08-03 - Reines Tracking sperrt Missed Policy sichtbar

Beim Praxischeck fiel auf: Bei `Wert erfassen` mit `Reines Tracking` konnte in
der UI weiterhin eine Missed Policy ausgewählt werden. Außerdem war der
Hinweistext unter `Verbindlichkeit` abgeschnitten.

Korrektur:

- Reines Tracking erlaubt fachlich und technisch nur noch
  `Keine Missed Policy`.
- Eine vorher gewählte Missed Policy wird beim Wechsel zu reinem Tracking
  automatisch zurückgesetzt.
- Das Missed-Policy-Feld bleibt sichtbar, ist aber gesperrt und grau
  hinterlegt.
- Der Hinweis erklärt direkt am Feld, dass reines Tracking nur echte Eingaben
  speichert und fehlende Tage nicht automatisch bewertet.
- Der Hinweis unter `Verbindlichkeit` ist gekürzt und mehrzeilig lesbar.

Pruefung:

- Validator-Test ergänzt: `pure tracking only allows no missed policy`.

### 2026-08-03 - Wertfeld setzt sich beim Datumswechsel korrekt zurück

Beim Praxischeck fiel auf: Wenn bei einem Habit mit reinem Tracking gestern
eine Uhrzeit gespeichert wurde und danach auf den heutigen Tag gewechselt
wurde, blieb die gestrige Uhrzeit im Eingabefeld sichtbar.

Ursache:

- Das Wert-Eingabefeld hielt seinen Text lokal in einem Controller.
- Bei leeren Tracking-Tagen gibt es noch keinen gespeicherten Entry, deshalb
  konnte das Feld den Wechsel auf einen anderen Tag nicht sicher erkennen.

Korrektur:

- `TaskCard` bekommt nun das aktuell angezeigte Instanzdatum.
- `ValueTaskInput` nutzt Aufgabe, Datum, Entry und Wert-Entry als Identität.
- Wenn diese Identität wechselt, wird der Feldinhalt neu aus den aktuellen
  Daten geladen.
- Nach erfolgreichem Speichern verliert das Eingabefeld den Fokus; die Tastatur
  wird geschlossen und der Bearbeitungsmodus fühlt sich abgeschlossen an.

Erwartetes Verhalten:

- Gestern mit Eintrag: gespeicherter Wert bleibt sichtbar.
- Heute ohne Eintrag: Feld ist leer.
- Heute mit Eintrag: heutiger Wert wird angezeigt.

### 2026-08-04 - Phase 12b abgeschlossen und Phase 12c gestartet

Phase 12b wird als abgeschlossen eingeordnet. Einzelwerte sind fuer die
naechste Teilphase stabil genug:

- Zahl, Dauer und Uhrzeit koennen als Einzelwerte konfiguriert werden.
- Werte werden pro Instanz gespeichert.
- `recorded` wird fuer echte Wert-Eingaben genutzt.
- Tages-/Habit-Karten koennen Werte erfassen und aendern.
- Abgeschlossene einmalige Wert-Aufgaben sind wieder auffindbar.
- Die wichtigsten Praxisfehler aus der Erstellung und Karteneingabe wurden
  behoben.

Offene Punkte werden nicht mehr in 12b geloest, sondern den passenden naechsten
Teilphasen zugeordnet:

- 12c: reines Tracking, virtuelle leere Tage und Tracking-Gruppe,
- 12d: verbindliche Wert-Eingaben mit Missed Policies,
- 12e: Zwei-Werte-Buendel,
- Phase 13: Wert-Auswertung,
- Phase 14: Ziele auf Wert-Auswertungen.

Phase 12c startet mit dem Ziel, reines Tracking ohne automatische leere Entries
sauber in Anzeige und spaetere Auswertung einzubinden.

### 2026-08-04 - Phase 12c finalisiert

Phase 12c wurde technisch abgeschlossen:

- Reine Trackings erscheinen in Tages-/Habits-Ansichten auch dann, wenn fuer den
  gewaehlten Tag noch kein Entry gespeichert ist.
- Der Scheduler erzeugt fuer reine Trackings keine automatischen leeren Entries.
- Beim Erstellen eines reinen Trackings wird kein initialer leerer Entry
  angelegt.
- Erst eine echte Wert-Eingabe materialisiert den Tag als Entry mit Wertdaten.
- Im Habits-Tab werden reine Trackings in einer eigenen Gruppe `Tracking`
  angezeigt.
- Reine Trackings bleiben dadurch sichtbar, werden aber nicht als offene
  Pflicht-Habits missverstanden.

Pruefung:

- `dart format` fuer die betroffenen Dateien erfolgreich.
- Gezielte Analyse meldete `No issues found`, der Prozess beendete in der
  Codex-Umgebung jedoch nicht sauber und lief ins Timeout.
- Gezielt ergaenzte Repository-Tests:
  - `zeigt reines Tracking ohne gespeicherten Entry`
  - `Scheduler erzeugt keine leeren Entries fuer reines Tracking`
- Der Flutter-Testlauf haengte in der Codex-Umgebung erneut; externe
  PowerShell-Pruefung wird empfohlen.

### 2026-08-04 - Phase 12d finalisiert

Phase 12d wurde technisch abgeschlossen. Verbindliche Wert-Eingaben verwenden
die bestehende Instanz- und Missed-Policy-Logik:

- Pflichtwerte erzeugen normale `pending`-Instanzen.
- Ein gespeicherter Wert setzt die Instanz auf `recorded`.
- `recorded` bleibt bei spaeterer Scheduler-Verarbeitung erhalten.
- Direkte Konsequenz kann verpasste Pflichtwerte als `failure` oder `no_entry`
  abschliessen.
- Puffer mit Folgeregel funktioniert fuer Pflichtwerte.
- Carryover mit Maximum funktioniert fuer Pflichtwerte.
- Bei Wert-Eingaben bedeutet `failure`: Pflicht-Eingabe verpasst. Es sagt
  nichts darueber aus, ob ein konkreter Zahlenwert gut oder schlecht gewesen
  waere.

Ergaenzte Tests:

- `verbindliche Wert-Eingabe bleibt nach Erfassung recorded`
- `verbindliche Wert-Eingabe verarbeitet direkte Konsequenz`
- `verbindliche Wert-Eingabe verarbeitet Puffer als Kein Eintrag`
- `verbindliche Wert-Eingabe begrenzt Carryover`

Pruefung:

- `dart format` fuer die Testdatei erfolgreich.
- Gezielte Analyse der betroffenen Dateien: keine Probleme gefunden.
- Der gezielte Flutter-Testlauf haengte in der Codex-Umgebung erneut; externe
  PowerShell-Pruefung wird empfohlen.

### 2026-08-04 - Phase 12d extern bestaetigt

Die externe PowerShell-Pruefung durch den Nutzer ist erfolgreich gelaufen.

- `reines Tracking`: `+2 All tests passed`
- Pflichtwert-/Wert-Tests: `All tests passed`

Damit ist Phase 12d nicht nur implementiert, sondern auch gezielt bestaetigt.

### 2026-08-04 - Phase 12e abgegrenzt

Phase 12e wurde nicht als erledigt markiert, weil Zwei-Werte-Buendel eine
echte neue Struktur brauchen und nicht nur eine UI-Ergaenzung sind.

Festgehalten wurde:

- Ein Buendel braucht eine eigene stabile Text-ID.
- Ein Buendel verbindet zwei eigenstaendige Teil-Trackings.
- Rohwerte bleiben ausschliesslich in den Teil-Entries.
- Die Buendeldefinition muss versionierbar sein.
- Die Tages-/Habit-Ansicht darf Teil-Trackings nicht doppelt anzeigen.
- Beim Aufloesen bleiben beide Teil-Trackings erhalten.

Offen fuer die Umsetzung:

- Drift-Tabellen fuer Buendel und Buendelversionen,
- Repository-Methoden,
- Berechnungslogik fuer Zeitintervall, Differenz und Summe,
- Buendelkarte,
- Erstellungs-/Bearbeitungsfluss,
- gezielte Tests inklusive Migration.

Diese Abgrenzung verhindert, dass spaeter nur Konstanten existieren, obwohl die
Planung Phase 12e als abgeschlossen ausweist.

### 2026-08-07 - Phase 12e in Teilschritte zerlegt

Phase 12e wurde im Plan genauer aufgeteilt, damit vor der Umsetzung sichtbar
ist, welche Entscheidungen und Bausteine gebraucht werden.

Neue technische Teilschritte:

1. Datenmodell final festlegen.
2. Drift-Schema und Migration vorbereiten.
3. Generatorlauf extern durchfuehren.
4. Repository-Grundfunktionen bauen.
5. Berechnungslogik fuer Zeitintervall, Differenz und Summe ergaenzen.
6. Anzeige-Modell fuer Buendel vorbereiten.
7. Tages-/Habit-UI anbinden.
8. Aufloesen und gezielte Tests ergaenzen.

Zusaetzlich wurden offene Klaerpunkte dokumentiert:

- zuerst vorhandene Trackings verknuepfen oder direkt neue Teil-Trackings im
  Buendel-Flow erzeugen,
- Schlaf-/Uhrzeit-Berechnung ueber Mitternacht,
- Anzeige teilweise erfasster Buendel,
- historisch sauberes Aufloesen,
- Begrenzung: ein Teil-Tracking in Phase 12 nur in einem sichtbaren
  Eingabe-Buendel,
- erste UI-Prioritaet: Zeitintervall und Zahlen-Differenz,
- Firebase-Prinzip: Buendeldefinitionen synchronisieren, abgeleitete Werte
  berechnen statt speichern.

### 2026-08-08 - Zahlen-Differenz fuer 12e frueh priorisiert

Ergaenzt wurde, dass Phase 12e nicht nur Uhrzeit-Intervalle wie Schlaf oder
Fasten frueh abdecken soll, sondern auch Zahlen-Differenzen.

Beispiel:

- Teil-Tracking A: Kalorienaufnahme in kcal
- Teil-Tracking B: Kalorienverbrauch in kcal
- Buendel: Kalorienbilanz
- Abgeleiteter Wert: Aufnahme minus Verbrauch oder Verbrauch minus Aufnahme

Damit bleibt Zeitintervall wichtig, aber Zahlen-Differenz wird nicht nach hinten
geschoben. Voraussetzung bleibt: Werttyp und Einheit muessen kompatibel sein.

### 2026-08-09 - Freitext-Einheiten in Phase 12 permissiv

Die Regel fuer Freitext-Einheiten wurde angepasst.

Vorherige Idee:

- Freitext-Einheiten nur kombinieren, wenn der Text exakt gleich ist.

Neue Phase-12-Regel:

- bekannte Einheiten werden weiterhin ueber Einheitenfamilien geprueft,
- Freitext-Einheiten werden zunaechst permissiv behandelt,
- Differenz/Summe ist bei Freitext erlaubt, solange beide Teilwerte
  Zahlentrackings sind,
- unterschiedliche Labels wie `kcal` und `Schritte` blockieren die Erstellung
  technisch nicht.

Begruendung:

Solange eigene Einheiten frei getippt werden, waere exakte Textgleichheit zu
streng. Tippfehler oder unterschiedliche Schreibweisen duerfen nicht verhindern,
dass Nutzende bewusst zwei Zahlen kombinieren.

Spaeter vorgesehen:

- eigene Einheitenverwaltung,
- Auswahl eigener Einheiten beim Erstellen,
- danach strengere Kompatibilitaetspruefung ueber echte Einheiten-IDs statt
  ueber getippten Text.

### 2026-08-08 - Phase 12e.1 und 12e.2 umgesetzt

Phase 12e.1 wurde finalisiert: Das Datenmodell fuer Zwei-Werte-Buendel ist
festgelegt.

Phase 12e.2 wurde im Source-Code vorbereitet:

- neue Drift-Tabelle `TaskValueBundles`,
- neue Drift-Tabelle `TaskValueBundleVersions`,
- Einbindung beider Tabellen in `AppDatabase`,
- Erhoehung der `schemaVersion` von 14 auf 15,
- neue Migration `_migrateTaskValueBundles`.

Die Struktur folgt der fachlichen Entscheidung:

- Buendel haben eigene stabile Text-IDs.
- Buendelversionen historisieren Name, Formel, Rollen, Quellen und Gueltigkeit.
- Rohwerte bleiben in den Teil-Entries.
- Abgeleitete Werte werden berechnet und nicht doppelt gespeichert.
- Zahlen-Differenzen wie kcal Aufnahme minus kcal Verbrauch sind neben
  Uhrzeit-Intervallen frueh vorgesehen.

Pruefung:

- `dart format` fuer die betroffenen Dart-Dateien erfolgreich.
- Der Generatorlauf `dart run build_runner build` hing in der Codex-Umgebung
  nach 120 Sekunden.
- Der externe Generatorlauf in PowerShell lief anschliessend erfolgreich.
- `app_database.g.dart` enthaelt die neuen Tabellen und Manager fuer
  `TaskValueBundles` und `TaskValueBundleVersions`.
- Eine Drift-Warnung wegen doppelter Referenznamen auf `Aufgaben` wurde durch
  eindeutige `@ReferenceName`-Annotationen fuer `firstTaskId` und
  `secondTaskId` behoben.
- Der Generatorlauf wurde danach erneut extern ausgefuehrt und lief
  warnungsfrei.
- `task_value_foundation_test.dart` lief extern mit `+5 All tests passed`.

### 2026-08-08 - Phase 12e.3 extern abgeschlossen

Der externe Generatorlauf wurde erfolgreich durchgefuehrt.

PowerShell-Ergebnis:

- `dart run build_runner build`: erfolgreich und warnungsfrei,
  `app_database.g.dart` aktualisiert.
- `flutter test --no-pub test\features\aufgaben\data\task_value_foundation_test.dart`:
  `+5 All tests passed`.

Damit sind 12e.1 bis 12e.3 abgeschlossen.

### 2026-08-09 - Phase 12e.4 bis 12e.8 umgesetzt

Phase 12e wurde technisch als erster Buendel-Kern abgeschlossen.

Umgesetzt wurde:

- `TaskValueBundleCalculation` berechnet abgeleitete Werte:
  - Zeitintervall aus zwei Uhrzeiten,
  - Differenz aus zwei Zahlen oder zwei Dauern,
  - Summe aus zwei Zahlen oder zwei Dauern.
- Uhrzeit-Intervalle behandeln Mitternacht sinnvoll:
  - Wenn die zweite Uhrzeit kleiner/gleich der ersten Uhrzeit ist, gilt sie als
    Folgetag.
  - Beispiel: 23:30 bis 07:15 ergibt 7 h 45 min.
- Freitext-Zahleneinheiten bleiben in Phase 12 permissiv:
  - Freitext + Freitext ist erlaubt, auch wenn die Labels unterschiedlich sind.
  - Beispiel: `kcal` minus `Schritte` wird technisch nicht blockiert, weil freie
    Einheiten erst spaeter ueber eigene Einheiten-IDs sauber verwaltet werden.
- `AufgabenRepository` kann Buendel:
  - erstellen,
  - fuer ein Datum laden,
  - aktive Versionen bestimmen,
  - Teil-Trackings aus der normalen Tages-/Habit-Liste ausblenden,
  - aufloesen,
  - gegen mehrfach aktive Buendel-Nutzung schuetzen.
- `TaskListForDate` enthaelt jetzt normale Aufgaben plus sichtbare
  Wert-Buendel.
- `TaskValueBundleForDate` beschreibt die gemeinsame Anzeige:
  - Buendeldefinition,
  - beide Teil-Trackings,
  - berechneter Wert,
  - Status `empty`, `partial`, `complete` oder `not_calculable`.
- `TaskValueBundleCard` zeigt eine gemeinsame Karte mit:
  - Name,
  - Status,
  - Eingabefeld fuer Teilwert A,
  - Eingabefeld fuer Teilwert B,
  - abgeleitetem Ergebnis,
  - Aktion zum Aufloesen.
- Die Tages-/Habit-Ansicht zeigt aktive Buendel statt der zwei Einzelkarten.
- Beim Aufloesen bleiben alle Rohdaten erhalten; danach erscheinen die
  Teil-Trackings wieder einzeln.
- Ein Teil-Tracking kann in Phase 12 nur in einem aktiven Eingabe-Buendel sein.
- Ein Teil-Tracking in einem aktiven Buendel kann nicht direkt geloescht werden.
- Historisch referenzierte Teil-Trackings werden nach dem Aufloesen ebenfalls
  vor hartem Loeschen geschuetzt, damit alte Buendelversionen nicht kaputtgehen.

Gezielte Tests wurden fuer folgende Faelle ergaenzt:

- Zeitintervall ueber Mitternacht,
- permissive Freitext-Zahlendifferenz,
- Sperre gegen zwei aktive Buendel mit demselben Teil-Tracking,
- Aufloesen macht Teil-Trackings wieder sichtbar,
- Loeschschutz fuer Teil-Trackings aktiver Buendel.

Pruefstatus:

- `dart format` fuer die betroffenen Dart-Dateien erfolgreich.
- In der Codex-Toolchain haengten `flutter test` und `dart analyze` erneut ohne
  fachliche Fehlermeldung. Deshalb ist die externe PowerShell-Pruefung der
  gezielten Buendeltests empfohlen.

Damit ist Phase 12e fachlich und technisch als erster Ausbaustand
abgeschlossen. Offen fuer spaeter bleiben Komfort-Erstellung von Buendeln,
historisch datumsscharfes Aufloesen alter Buendelansichten, Quellentausch mit
neuer Version, Mehrfachnutzung eines Teil-Trackings und Wert-Auswertungen in
Phase 13.

### 2026-08-10 - Phase 12e extern bestaetigt und Phase 12f abgeschlossen

Die externe PowerShell-Pruefung durch den Nutzer ist erfolgreich gelaufen:

```powershell
cd "C:\Users\maxkr\Documents\Flutter Apps\Upgear\momentum"
flutter test --no-pub test\features\aufgaben\data\aufgaben_repository_test.dart --plain-name "Buendel"
```

Ergebnis:

- `+5 All tests passed`

Damit sind die gezielten Buendeltests bestaetigt:

- Zeitintervall ueber Mitternacht,
- Freitext-Zahlendifferenz,
- Sperre gegen zwei aktive Buendel mit demselben Teil-Tracking,
- Aufloesen macht Teil-Trackings wieder sichtbar,
- Loeschschutz fuer historisch referenzierte Teil-Trackings.

Phase 12f bestand aus Abschlusspruefung, Dokumentationsnachzug und Vorbereitung
von Phase 13. Es gibt dafuer keine offenen fachlichen Fragen mehr. Phase 12 ist
als erster Ausbaustand abgeschlossen.
