# Momentum - Aufgabenarten und Auswertungen: Matrix

Stand: 10. August 2026  
Status: Arbeitsmatrix fuer Status-Auswertung und aktive Phase 13 Wert-Auswertung

## Zweck

Dieses Dokument verbindet Aufgaben-/Habit-Arten mit passenden Auswertungen.
Es soll sichtbar machen:

- welche Aufgabenarten und Konfigurationsvarianten es gibt,
- welche Auswertung bei welcher Aufgabenart fachlich sinnvoll ist,
- welche Auswertung bereits umgesetzt ist,
- welche Auswertung spaeter ergaenzt wird,
- welche Kombination bewusst nicht angezeigt werden sollte.

Die Matrix ist kein Ersatz fuer die fachliche Regelmatrix. Die Regelmatrix sagt,
welche Aufgaben-Konfigurationen erlaubt sind. Diese Matrix sagt, welche
Auswertungen fuer diese Konfigurationen sinnvoll sind. Langfristig soll hier
eine moeglichst vollstaendige Uebersicht aller Aufgaben- und Habit-Arten
entstehen.

Die konkrete Sichtbarkeitslogik der Status-Auswertungen steht in
[`phase_11_complete_analytics/status_metric_visibility.md`](phase_11_complete_analytics/status_metric_visibility.md).

## Legende

| Kuerzel | Bedeutung |
|---|---|
| `JA` | Fachlich sinnvoll und grundsaetzlich vorgesehen. |
| `NEIN` | Fachlich nicht sinnvoll oder nicht anwendbar. |
| `WARN` | Sinnvoll, aber nur mit Hinweis, weil die Kennzahl leicht missverstanden werden kann. |
| `SPAETER` | Sinnvoll, aber nicht Teil der aktuellen Phase. |
| `OFFEN` | Fachlich noch zu klaeren. |
| `UMGESETZT` | Bereits technisch vorhanden oder in der App sichtbar umgesetzt. |

## Grundregel fuer Erfolgsquoten

Die strenge Erfolgsquote ist die Standardquote fuer Status-Aufgaben und Habits.
Sie zaehlt Erfolge gegen alle faelligen, abgeschlossenen Instanzen.
Misserfolge und `no_entry` sind dabei keine Erfolge.

Wenn eine Aufgabe durch ihre Konfiguration `no_entry` gar nicht erzeugen kann,
ist die strenge Erfolgsquote automatisch die passende Hauptquote. Dann besteht
die Grundmenge praktisch aus Erfolgen und Misserfolgen.

Wenn `no_entry` moeglich ist, bleibt die strenge Erfolgsquote ebenfalls
sinnvoll, braucht aber einen verstaendlichen Hinweis. Sonst kann sie so wirken,
als waeren neutrale oder nicht wertende Eintraege normale Misserfolge.

## Matrix A - Abhaken und Status-Erfassung

Diese Tabelle gilt fuer Aufgaben und Habits, die ueber Statuswerte ausgewertet
werden:

- `pending`: noch offen
- `success`: Erfolg
- `failure`: Misserfolg
- `no_entry`: abgeschlossen ohne wertende Antwort

| ID | Aufgaben-/Habit-Art | Rhythmus / Terminlogik | Missed Policy | Zieltyp | Erfolgsquote | Wertende Quote | Erfolge / Misserfolge | Kein Eintrag | Offen | Fortschritt | Ueberfaelligkeit / Puffer / Carryover | Einzelantworten / Notizen | Raster | Sammelauswertung | Zielbewertung | Kartenkennzahl |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A-01 | Einzelne einmalige Aufgabe ohne Faelligkeit | einmalig, ohne konkreten Stichtag | keine | kein Ziel | NEIN | NEIN | NEIN | NEIN | JA | NEIN | NEIN | JA | NEIN | JA | NEIN | UMGESETZT |
| A-02 | Einzelne einmalige Aufgabe mit Faelligkeit | einmalig, mit Faelligkeitsdatum | keine oder direkte Konsequenz | kein Ziel | NEIN | NEIN | NEIN | WARN | JA | NEIN | JA | JA | NEIN | JA | NEIN | UMGESETZT |
| A-03 | Wiederkehrende Aufgabe ohne Ziel | taeglich / woechentlich / monatlich | direkte Konsequenz `failure` | kein Ziel | JA | JA | JA | NEIN | JA | JA | JA | JA | JA | NEIN | NEIN | UMGESETZT |
| A-04 | Wiederkehrende Aufgabe ohne Ziel | taeglich / woechentlich / monatlich | direkte Konsequenz `no_entry` | kein Ziel | WARN | WARN | JA | JA | JA | JA | JA | JA | JA | NEIN | NEIN | UMGESETZT |
| A-05 | Wiederkehrende Aufgabe mit Puffer | fester kalendergebundener Rhythmus | Puffer, danach `failure` oder `no_entry` | optional | JA | JA | JA | WARN | JA | JA | JA | JA | JA | NEIN | SPAETER | UMGESETZT |
| A-06 | Wiederkehrende Aufgabe mit Carryover | fester kalendergebundener Rhythmus | Aufstauen mit Maximum und Konsequenz | optional | JA | JA | JA | WARN | JA | JA | JA | JA | JA | NEIN | SPAETER | UMGESETZT |
| A-07 | Abschlussgebundene Aufgabe | alle X Tage nach Abschluss | offen bis Abschluss oder Stichtag | optional | WARN | WARN | JA | WARN | JA | JA | JA | JA | SPAETER | NEIN | SPAETER | UMGESETZT |
| A-08 | Habit taeglich sichtbar, Ziel seltener | z. B. taeglich angezeigt, Ziel 2x pro Woche | abhaengig von Einstellung | Anzahl pro Zeitraum | WARN | JA | JA | WARN | JA | JA | JA | JA | JA | NEIN | SPAETER | UMGESETZT |
| A-09 | Habit mit Prozentziel | wiederkehrend | direkte Konsequenz, Puffer oder Carryover | Prozentziel | JA | JA | JA | WARN | JA | JA | JA | JA | JA | NEIN | SPAETER | UMGESETZT |
| A-10 | Habit mit maximalen Fehlschlaegen | wiederkehrend | direkte Konsequenz, Puffer oder Carryover | maximale Misserfolge | JA | JA | JA | WARN | JA | JA | JA | JA | JA | NEIN | SPAETER | UMGESETZT |
| A-11 | Rollierendes Statusziel | wiederkehrend | direkte Konsequenz, Puffer oder Carryover | X Erfolge in X Tagen | JA | JA | JA | WARN | JA | JA | JA | JA | JA | NEIN | SPAETER | UMGESETZT |
| A-12 | Wiederkehrend ohne Missed Policy | fester kalendergebundener Rhythmus | keine | optional | WARN | WARN | JA | NEIN | JA | JA | JA | JA | JA | NEIN | SPAETER | UMGESETZT |

### Hinweise zu Matrix A

- Einmalige Aufgaben erhalten keine klassische Habit-Quote. Fuer sie sind eher
  konkrete Detaildaten und Sammelauswertungen ueber viele einmalige Aufgaben
  sinnvoll.
- Fuer Phase 14 wird das Release-Zielmodell vereinfacht: Statusziele verwenden
  einen positiven Grundtyp „mindestens Erfolg in X Tagen“ mit Anzahl- oder
  Prozentdarstellung. Die aelteren Matrixzeilen zu Prozentziel,
  Anzahl-pro-Zeitraum und maximalen Misserfolgen beschreiben noch den
  historischen Brainstorming-Stand und duerfen nicht ungeprueft als finale
  Release-Zieltypen umgesetzt werden.
- Ziele nach dem Muster „maximale Misserfolge“ bleiben fuer den Release
  gestrichen, weil Zieldefinitionen positiv formuliert sein sollen.
- Die strenge Erfolgsquote ist fuer alle wiederkehrenden Status-Aufgaben die
  Standardquote. Bei Aufgaben ohne moegliche `no_entry`-Konsequenz ist sie
  besonders eindeutig.
- `no_entry` wird nur angezeigt, wenn die Aufgabe durch ihre Konfiguration
  ueberhaupt `no_entry` erzeugen kann.
- Bei Aufgaben, deren Rhythmus haeufiger ist als ihr Ziel, darf die Auswertung
  nicht automatisch so wirken, als seien alle nicht benoetigten Tage ein
  Problem. Das wird ueber zielunabhaengige Auswertung und spaetere
  Zielbewertung getrennt.
- Carryover- und Puffer-Auswertungen sollen motivieren, Aufgaben zeitnah zu
  erledigen, ohne fachlich falsche Erfolgswerte zu erzeugen.
- Zielbewertung bleibt bewusst `SPAETER`, weil zuerst die Auswertungen selbst
  stabil sein muessen.

## Matrix B - Eingaben und Werte

Diese Tabelle bereitet Wert-Erfassungsarten vor. Phase 12 hat die Erfassung
umgesetzt; Phase 13 nutzt diese Matrix jetzt fuer die Wert-Auswertung.

| ID | Eingabeart | Beispiel | Summe | Durchschnitt | Minimum / Maximum | Verlauf / Trend | Zielwertvergleich | Abweichung vom Ziel | Haeufigkeit der Eingaben | Fehlende Werte / `no_entry` | Ausreisser | Wochen-/Monatsvergleich | Raster / Kalender | Zielbewertung | Kartenkennzahl |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| B-01 | Zahl pro Eintrag, summierbar | Glaeser Wasser, gelesene Seiten | JA | JA | JA | JA | SPAETER | SPAETER | JA | WARN | SPAETER | JA | JA | SPAETER | UMGESETZT |
| B-02 | Zahl als Messwert | Gewicht, Blutdruckwert, Energielevel | JA | JA | JA | JA | SPAETER | SPAETER | JA | WARN | SPAETER | JA | JA | SPAETER | UMGESETZT |
| B-03 | Dauer | Sportdauer, Meditation, Schlafdauer | JA | JA | JA | JA | SPAETER | SPAETER | JA | WARN | SPAETER | JA | JA | SPAETER | UMGESETZT |
| B-04 | Uhrzeit | Schlafenszeit, Aufstehzeit, Medikament genommen um | NEIN | JA | JA | JA | SPAETER | SPAETER | JA | WARN | SPAETER | JA | JA | SPAETER | UMGESETZT |
| B-05 | Skala | Stimmung 1-10, Schmerz 1-10 | NEIN | JA | JA | JA | SPAETER | SPAETER | JA | WARN | SPAETER | JA | JA | SPAETER | SPAETER |
| B-06 | Zwei-Werte-Buendel: Zeitintervall | Schlafdauer, Fastenfenster | NEIN | JA | JA | JA | SPAETER | SPAETER | JA | WARN | SPAETER | JA | JA | SPAETER | UMGESETZT |
| B-07 | Zwei-Werte-Buendel: Differenz | Kalorienbilanz, Einnahmen minus Ausgaben | JA | JA | JA | JA | SPAETER | SPAETER | JA | WARN | SPAETER | JA | JA | SPAETER | UMGESETZT |
| B-08 | Zwei-Werte-Buendel: Summe | Dauer A + Dauer B, kompatible Zahlenwerte | JA | JA | JA | JA | SPAETER | SPAETER | JA | WARN | SPAETER | JA | JA | SPAETER | UMGESETZT |
| B-09 | Mehrere Werte oder Sessions pro Tag | 3x 10 Minuten Spazieren, mehrere Messungen | OFFEN | OFFEN | OFFEN | OFFEN | SPAETER | SPAETER | JA | WARN | SPAETER | SPAETER | SPAETER | SPAETER | SPAETER |

### Hinweise zu Matrix B

- Diese Eingabearten sind release-relevant, aber noch nicht Teil der aktuellen
  Status-Auswertung.
- Zahlenwerte brauchen andere Kennzahlen als Ja/Nein-Aufgaben. Deshalb bleibt
  diese Matrix getrennt von Matrix A.
- In Phase 13 sind alle Zahlenwerte grundsaetzlich summierbar. Weil eigene
  Einheiten aktuell frei eingegeben werden koennen, bevormundet die App den
  Nutzer hier nicht. Ob eine Summe fachlich sinnvoll ist, wird spaeter ueber
  bessere Einheitenverwaltung, UI-Hinweise oder Kennzahl-Auswahl verbessert.
- Fehlende Werte muessen sichtbar bleiben. Sie duerfen Durchschnitte und Trends
  nicht still verfaelschen.
- Wert-Eingaben verwenden den Rohstatus `recorded` fuer erfasste Werte.
- Reines Tracking kann vergangene leere Tage virtuell als fehlenden Wert
  behandeln, ohne automatisch `no_entry`-Datensaetze zu schreiben.
- Zwei-Werte-Buendel haben zwei eigenstaendige Teil-Trackings und einen
  abgeleiteten Wert. Sie speichern keine doppelten Tageswerte.
- Zielbewertung fuer Werte folgt erst, wenn Erfassung und Auswertung der Werte
  stabil sind.

## Spaetere Kalender- und Blockauswertungen

Monats- und Jahresansichten gehoeren zur Auswertung, nicht zum Zielmodell. Ziele
bleiben fuer Phase 14 auf feste Tagesfenster beziehungsweise 7-Tage-Wochenanker
bezogen. Eine spaetere Monatsansicht darf trotzdem jeden Kalendermonat mit 28,
29, 30 oder 31 Tagen auswerten, weil die Rohdaten pro `scheduledDate`
vorliegen.

Moegliche spaetere Darstellung:

- Monatszeilen mit einem kleinen Block pro Kalendertag.
- Jahresueberblick mit allen Monatszeilen.
- Blockfarbe oder Symbol aus Tagesstatus, Tageswert oder abgeleiteter
  Zielaussage.
- Monatsvergleich als Auswertungsansicht, nicht als eigener Zieltyp.

Wichtig: Diese Ansichten duerfen keine neuen Rohdaten erzwingen. Sie sollen aus
vorhandenen Eintraegen, Wertdaten und Zielbewertungen berechnet werden.

## Pflegehinweise

Wenn eine neue Aufgabenart, Habit-Art oder Eingabeart hinzukommt:

1. zuerst pruefen, ob sie in der Regelmatrix erlaubt ist,
2. dann hier eine neue Zeile ergaenzen,
3. passende Auswertungen mit `JA`, `NEIN`, `WARN`, `SPAETER` oder `OFFEN`
   markieren,
4. erst danach UI und Code daraus ableiten.

Diese Matrix darf bewusst wachsen. Sie soll dabei aber eine Arbeitsmatrix
bleiben: klar, tabellarisch und schnell ueberpruefbar.

## Spaetere UI-Idee: Auswertungstabelle

Fuer die App und besonders fuer eine moegliche spaetere Browser-/Web-Version
ist eine tabellarische Auswertungsansicht sinnvoll.

Moeglicher Aufbau:

| Spalte | Inhalt |
|---|---|
| Auswertung | Name der Kennzahl, z. B. "Strenge Erfolgsquote". |
| Erklaerung | Kurzer Text oder Info-Button mit verstaendlicher Erklaerung. |
| Wert | Errechneter Wert im gewaehlten Zeitraum, z. B. `21,6 %` und `8 von 37`. |

Oberhalb der Tabelle kann der Zeitraum gewaehlt werden:

- letzte 7 Tage
- letzte 30 Tage
- seit Beginn
- spaeter: eigener Zeitraum

Diese Ansicht eignet sich auch als spaeteres Premium-Feature oder als
erweiterte Detailansicht. Wichtig: Die Berechnung selbst darf nicht Premium-
Logik werden. Premium waere nur die besonders komfortable Darstellung,
Filterung oder Langzeitanalyse.
