# Phase 21 – #011/#020/A01: Tagesübersicht, kompakte Tracker und Gruppen

Stand: 28. Oktober 2026

Status: G0–G4 implementiert; G5 ausgeführt und G6 dokumentiert. Nach separater
Zeitumstellungskorrektur am 28. Oktober vollständige Suite 229 Tests grün,
gezielte Analyse ohne Befunde. Gerätenachtest weiterhin offen.
Fachliche Nutzerentscheidungen und abgeleitete V1-Grenzen bleiben unten getrennt
dokumentiert. Der gemeinsame Abschluss bezieht auch #004 ein. Monitoring bleibt
verschoben. Nachträglich am 28. Oktober auf ausdrücklichen Auftrag APK 1.0.0+5
erstellt: [Updateprüfung und Nachtest](update_1_0_0_5.md). Frühere Build-Aussagen
unten dokumentieren den damaligen Stand.

## Umsetzungsfortschritt am 27. Oktober

| Schritt | Tatsächlicher Stand |
|---|---|
| G0 | Abgeglichen: sauberes Arbeitsverzeichnis, Schema 25, Kalender/#002/#013 vorhanden; keine fachliche Rückfrage erforderlich. |
| G1 | Schema 26, zwei Gruppentabellen, CRUD, Reihenfolge/Einklappen, explizites Verschieben und beidseitiger Bündelschutz; Backup 22–26. Gezielte Daten-/Migrationstests grün. |
| G2 | Gemeinsame Tagesauflösung vor Bündeldarstellung, abgeleitete Vollständigkeit, Vorschau/Fingerprint und atomare Voll-/Teilaktion über vorhandene Schreibwege. Service-Abnahmefälle grün. |
| G3 | Gruppentab, Verwaltung, Sortierung, Einklappen; exklusive Filter nur in operativen UI-Listen. Kalender/Projektzugriffe bleiben vollständig. |
| G4 | Zahlenzeile im kompakten Modus, gemeinsamer Parser, zentral gehaltene Entwürfe, Navigation mit Speichern/Verwerfen/Abbrechen, Feldmarkierung und Teilaktion. Integrierter Widgettest grün. |
| G5 | Analyse von 25 geänderten Dart-Dateien ohne Befunde. 11 neue Daten-/Migrationstests und ein integrierter Widgettest grün. Gesamtlauf und gezielte Wiederholungen siehe Prüfnachweis unten; keine uneingeschränkte Gesamtfreigabe. |
| G6 | Umsetzung, Grenzen, Prüfbefunde und Gerätenachtest dokumentiert; keine APK gebaut. |

### Prüfnachweis und verbleibende Abnahme

**Aktualisierung 28. Oktober:** Die unten historisch beschriebenen Testfehler
sind behoben. Vollständige Suite 229 Tests grün, Analyse acht Dateien ohne
Befunde. Auch der Erhalt von Eingabe-Fehlermarkierungen beim Kartenklappen ist
abgesichert. [Korrekturbericht und Befehle](goal_calendar_fix.md).
Die folgenden Laufzahlen dokumentieren den früheren Stand vom 27. Oktober.

- Ein vollständiger Testlauf: 212 bestanden, 12 fehlgeschlagen. Darunter
  zeitumstellungsabhängige ältere Tests sowie eine neue Migrations-Testfixture
  mit fehlender Dauer zur Startuhrzeit. Die Fixture wurde korrigiert.
- Testdaten im Repository-Test verwenden nun Kalendertage statt 24-Stunden-
  Subtraktion. Anschließender gezielter Lauf `test/features/aufgaben/data`:
  **168 bestanden, 2 fehlgeschlagen**. Die neuen Gruppenfälle sind grün.
- Verbleibend: `historische Statuszielbloecke listen laufenden Block nicht` und
  `plant reine Zielaenderung ab naechstem Zielblock ohne aktive Aufgabe zu aendern`.
  Die bestehende Zielblockberechnung in `task_goal_evaluation_summary.dart`
  verwendet weiterhin Duration-Tage über die Zeitumstellung. Nicht Teil dieses
  Gruppenpakets; nicht durch geänderte Erwartungen kaschiert.
- Integrierter Widgettest grün: exklusive Listenanzeige, fehlende/ungültige
  Werte, explizite Teilaktion, erhaltene Entwürfe, Navigation abbrechen,
  vollständiges Speichern und schmale Ansicht mit großer Schrift.
- Kein erneuter vollständiger Testlauf nach den Korrekturen, um Nutzung zu sparen.
  Daher wird ausdrücklich kein vollständig grüner Gesamtlauf behauptet.

Kurzer Gerätenachtest (noch offen):

1. Gruppe mit Checkbox, Ja/Nein-Habit und Zahlentracker erstellen; normale Tabs
   dürfen diese Mitglieder nicht doppelt zeigen, Kalender bleibt vollständig.
2. Vollabschluss ohne Wert versuchen: Feld markiert, nichts teilweise gespeichert.
   Explizite Teilaktion testen; eingetippte Zahl muss erhalten bleiben.
3. Gültigen Wert einschließlich 0 speichern, bewusstes Nein und erneutes Öffnen
   prüfen; Gruppenstatus muss den Einzelzuständen folgen.
4. Einklappen, Reihenfolge, Verschieben und Gruppenlöschung testen; Aufgaben und
   Messwerte bleiben erhalten. Entwurf beim Tab-/Datumswechsel abbrechen/verwerfen.
5. Neustart und Backup/Import prüfen; Gruppenzuordnung und Reihenfolge bleiben.
   Alte offene Tage einzeln bearbeiten; keine rückwirkende Sammelaktion.

Die bisherige APK enthält dieses Paket nicht. Monitoring/A01, Unteraufgaben und
weitere Phase-21-Pakete bleiben unberührt.

Technische Ableitungen: Gruppen-/Mitgliederreihenfolge über „nach oben“-Aktionen;
Einzelstatus-/Wertänderungen bleiben in den vorhandenen Karten. Unter 420 Pixeln
oder bei großer Schrift bricht die numerische Eingabe in eine vertikale Anordnung
um. Weder neue Aufgabenart noch neue Erfolgsregel. Geräteabnahme separat offen.

## Quellen und ursprünglicher Umfang

- [Phase-20-Originalmeldungen](../phase_20_private_test/mobile_test_feedback_2026_10.md):
  #011 kompakte Zahlen-Tracker (Titel und Werteingabe), Messreihe gegenüber
  Durchführung unterscheiden, Ziele weiterhin möglich; fehlende Messwerte nicht
  unbedacht als Misserfolg behandeln. Eigene Aufgabenart noch nicht entschieden.
- #020 ursprünglich reine Anzeigegruppen: frei benannt, Reihenfolge festlegbar,
  optional einklappbar, enthaltene Aufgaben bleiben eigenständig.
- #004 ursprünglich separat: Routine mit gemeinsamem Abschluss mehrerer Aufgaben;
  Verhalten bei teilweiser Erledigung noch auszuarbeiten.
- [A01](../../00_overview/app_concept_ideas_2026_10.md): Tagesübersicht und Monitoring,
  geplante Messungen im Tagesablauf, gemeinsame Daten statt doppelter Erfassung.
  Konkrete Navigation war noch nicht beschlossen.

## Nutzerentscheidung vom 25. Oktober 2026

- Anzeigegruppen bekommen einen eigenen Tab.
- Eine Gruppe wie „Morgenroutine“ lässt sich gemeinsam abhaken; ihre enthaltenen
  Aufgaben und Habits werden dadurch erledigt.
- Zugeordnete Aufgaben und Habits erscheinen ausschließlich im Gruppentab,
  nicht zusätzlich in den Tabs Aufgaben oder Habits.
- Alles andere bleibt gleich. Der vorherige Agentenvorschlag einer einheitlichen,
  gemischten Tagesliste ist damit nicht die beschlossene Navigation.
- Dies erweitert ausdrücklich #020 um den gemeinsamen Abschluss aus #004.
  Die ältere Trennung beider Wünsche bleibt als Quellenhistorie erhalten und
  darf die neuere Entscheidung nicht überstimmen. #010 Unteraufgaben wird dadurch
  nicht automatisch Bestandteil dieses Pakets.
- Monitoring aus A01 wird auf ausdrücklichen Nutzerwunsch später separat geplant.
  Im aktuellen Paket bleiben der Gruppentab, seine Abschlusslogik und die
  kompakten Tracker-Eingaben #011. Kein zusätzlicher Monitoringbereich und kein
  Umbau der übrigen Navigation in diesem Paket.

### Präzisierung: vollständiger und teilweiser Gruppenabschluss

Vom Nutzer ausdrücklich festgelegt; ersetzt den vorherigen Agentenvorschlag,
beim allgemeinen Gruppen-Haken automatisch nur abhakbare Einträge zu erledigen:

- Gruppen können auch Einträge mit Eingabefeldern enthalten. Vollständig erledigt
  ist eine Gruppe erst, wenn alle notwendigen Eingaben ausgefüllt und alle
  enthaltenen Einträge abgeschlossen sind.
- Werden alle Einträge einzeln abgehakt beziehungsweise eingegeben, wird die
  Gruppe automatisch als erledigt markiert. Kein zusätzlicher Gruppen-Haken nötig.
- Beim Versuch eines manuellen Gruppenabschlusses mit fehlenden Eingaben werden
  die betroffenen Felder markiert und der Nutzer darauf hingewiesen. Die Gruppe
  wird nicht als erledigt markiert.
- Unter diesem Hinweis gibt es eine ausdrückliche Teilaktion, beispielsweise
  „Nur abhakbare Einträge erledigen“. Sie erledigt die noch offenen Ja/Nein-Einträge,
  die keine Werteingabe verlangen. Sie ergänzt keine Messwerte.
- Nach dieser Teilaktion bleibt die Gruppe unvollständig, solange Eingaben fehlen.
  Eine Gruppe mit fehlenden Eingaben darf auch dann nicht vollständig erledigt
  erscheinen, wenn alle Ja/Nein-Einträge bereits erledigt sind.
- Ergänzend bestätigt: Ein bewusst mit Nein beantworteter Habit zählt für den
  Gruppenabschluss als bearbeitet. „Gruppe erledigt“ bedeutet vollständig
  bearbeitet, nicht ausschließlich erfolgreich. Die individuelle Bewertung
  bleibt erhalten; die Gruppenaktion überschreibt die Antwort nicht. Bei normaler
  Erfolgsregel bleibt Nein ein Misserfolg, bei umgekehrter gilt die bestehende
  Erfolgsregel (siehe Codebefund).

Technisch abgeleitete Regeln, keine weiteren Nutzerentscheidungen:

- Der Gruppenstatus wird aus den zugrunde liegenden Einträgen abgeleitet; kein
  unabhängig schaltbarer Erledigt-Status, der unvollständige Inhalte überstimmt.
- Ein blockierter vollständiger Abschluss verändert zunächst keine Einträge.
  Erst die ausdrücklich gewählte Teilaktion schließt die zulässigen Einträge ab.
- Ausgefüllt bedeutet nach den bestehenden Feldregeln gültig und gespeichert;
  ein Entwurf allein setzt noch keinen Erledigt-Status. Die vollständige
  Gruppenaktion darf gültige Entwürfe atomar mitspeichern (siehe G2/G4).
  Ungültiger Text genügt nicht. Ein gültiger Wert 0 ist keine
  fehlende Eingabe. Optionale Notizen sind keine Pflichtfelder. Ziele und
  Zielerreichung nicht mit fehlenden Eingaben gleichsetzen.
- Bereits vorhandene Antworten und Messwerte bleiben erhalten; insbesondere
  darf eine Sammelaktion ein vorhandenes Nein nicht stillschweigend in Ja ändern.
- Wird eine notwendige Eingabe später entfernt oder ein Abschluss zurückgenommen,
  muss auch der abgeleitete Gruppenstatus wieder unvollständig werden.
- Vollständigkeitsprüfung und Teilaktion im schreibenden Datenpfad durchsetzen,
  nicht nur durch deaktivierte Oberflächenelemente.

## Abgeleitete Leitplanken (keine zusätzlichen Nutzerbeschlüsse)

- Gruppen verweisen auf bestehende Aufgaben/Habits; keine Kopien der Einträge
  oder parallele Messhistorie. Projektzugehörigkeit bleibt davon unabhängig.
- „Nur im Gruppentab“ betrifft zunächst die genannten Aufgaben-/Habitlisten.
  Kein stillschweigendes Entfernen aus Kalender, Auswertung oder Projektdetails.
- Gruppenzuordnung und Tabwechsel ändern keine Termine, Wiederholungen oder
  bestehenden Antworten. Ein Gruppenabschluss darf keine später fälligen
  Vorkommen oder sämtliche historischen Rückstände pauschal erledigen.
- Messwerte niemals aus einem Gruppen-Haken erzeugen oder durch einen
  erfundenen Standardwert ersetzen. Vollständiger und teilweiser Abschluss folgen
  der oben bestätigten Präzisierung.
- Frei benannte Gruppen, ihre Reihenfolge und Einklappen aus #020 bleiben
  erhalten; die neue Tabentscheidung streicht diese Anforderungen nicht.

## Bestätigte Paketgrenze

Monitoring wird später separat geplant; die bisher offene Frage zur Aufteilung
ist damit entschieden. Messdaten und bestehende Auswertungen bleiben erhalten.
Neue Fragebogen-/Diagnostikfunktionen gehören nicht in dieses Paket. A01 bleibt
als weiterführende Idee erhalten und wird nicht als vollständig erledigt markiert.

## Gezielter Codebefund für die weitere Vorbereitung

- `aufgaben_screen.dart` hat die Ansichten Aufgaben, Habits und Dringlichkeit.
  Gruppentab dort ergänzen; bestehende Projektgruppierung für nicht zugeordnete
  Aufgaben/Habits erhalten. Gemeinsame Datenabfragen nicht global filtern, sonst
  würden gruppierte Einträge auch aus Kalender oder Auswertungen verschwinden.
- `TaskForDate.isAnswered` beruht auf einem abgeschlossenen Status; das allein
  genügt für die neue Gruppen-Vollständigkeit nicht. Pflichtwerte und explizite
  Antworten gesondert prüfen, insbesondere automatisch abgeschlossene Einträge
  ohne Messwert nicht als vollständig eingegeben behandeln.
- Vorhandene Schreibwege sind `setTaskCompleted`, `setBooleanHabitValue` und
  `setTaskEntryValue` im Aufgabenrepository. Gruppenaktionen müssen deren
  Versions-, Lebenszyklus-, Korrektur- und Datumsregeln erhalten.
- Technische Präzisierung zur Nein-Entscheidung: `setBooleanHabitValue` bewertet
  Antworten anhand von `task.successValue`. Bei umgekehrter Erfolgsregel kann
  Nein bereits heute Erfolg bedeuten. Diese bestehende Fachregel bleibt erhalten;
  die Bestätigung zur vollständigen Bearbeitung führt keine neue Erfolgsregel ein.
  Ein Sammelabschluss muss die konfigurierte Erfolgsantwort verwenden, statt
  pauschal überall Ja zu speichern. Vorhandene Antworten bleiben unverändert.
- `ValueTaskInput` bietet bereits Werteingabe, Einheiten und Speichern. Die
  kompakte Zeile soll diese Regeln weiterverwenden. `TaskValueCommitment`
  unterscheidet bereits reine Messung und Pflichtwert; für ein kompakteres Layout
  allein ist kein neuer gespeicherter Aufgabentyp erforderlich (technische
  Ableitung, kein zusätzlich bestätigtes Produktmodell).
- Bündel verweisen bereits auf zwei eigenständige Messungen und gehören deshalb
  in den Zuordnungs-/Sichtbarkeitsabgleich; nicht als neue Messwerte kopieren.

## Bereits feststehende Abnahmefälle

- Gemischte Gruppe, keine Werte eingegeben: vollständiger Abschluss blockiert,
  fehlende Pflichtfelder hervorgehoben, Hinweis und gesonderte Teilaktion sichtbar.
- Teilaktion gewählt: offene einfache Ja/Nein-Einträge erledigt, Messungen
  unverändert, Gruppe weiterhin unvollständig.
- Alle Inhalte einzeln gültig gespeichert und erledigt: Gruppe automatisch fertig.
- Ein Habit bewusst mit Nein beantwortet, alle übrigen Inhalte vollständig:
  Gruppe fertig, Nein und individuelle Misserfolgswertung unverändert.
- Alle erforderlichen Werte vorhanden, einfache Einträge noch offen: gemeinsamer
  Abschluss erledigt diese Einträge und ergibt eine vollständige Gruppe.
- Ungültige Eingabe verhindert vollständigen Abschluss; gültige Null zählt als
  Eingabe. Gültige neue Entwürfe werden beim vollständigen Abschluss atomar
  gespeichert; vorhandene Antworten werden nicht pauschal überschrieben.
- Einzelnen Abschluss zurücknehmen oder Pflichtwert löschen: Gruppe wieder offen.

## V1-Detailregeln – aus den Nutzerentscheidungen abgeleitet

Diese Festlegungen sind technische beziehungsweise kleine Bedienentscheidungen
des Agenten, keine nachträglich behaupteten ausdrücklichen Nutzerbeschlüsse.

### Zuordnung und Verwaltung

- Ein Eintrag gehört höchstens einer Gruppe an; keine Untergruppen. Die Gruppe
  hat einen frei vergebenen, nicht leeren Namen und eine frei sortierbare Position.
  Mitglieder lassen sich ebenfalls umsortieren; neu hinzugefügte stehen am Ende.
- Im Tab „Gruppen“ gibt es „Gruppe anlegen“ und pro Gruppe Bearbeiten/Löschen.
  Bearbeiten umfasst Name, Mitglieder und Reihenfolge. Auswahl zeigt vorhandene
  Aufgaben, Habits und Werteingaben; es werden keine Kopien angelegt.
- Beim Umhängen eines schon zugeordneten Eintrags wird die bisherige Gruppe
  angezeigt. Explizites Verschieben ersetzt die Zuordnung atomar.
- Gruppe löschen löst nur die Zuordnungen, mit Hinweis „Die enthaltenen Aufgaben
  und Messwerte bleiben erhalten“. Danach erscheinen sie wieder in den normalen
  Ansichten. Entfernen eines Mitglieds hat denselben Effekt für diesen Eintrag.
- Gruppenzuordnung ist eine aktuelle Anzeigeeinstellung, keine rückwirkende
  fachliche Datenänderung: Auch ältere Ansichten verwenden die aktuelle Zuordnung.
  Keine versionierte Gruppenhistorie und keine eigenen Gruppen-Statistiken in V1.
- Pausieren/Papierkorb erhält die Zuordnung, aber versteckt nicht anstehende
  Einträge wie bisher. Wiederherstellen verwendet die erhaltene Zuordnung.
  Endgültiges Löschen entfernt die Mitgliedschaft über Fremdschlüssel.
- Leere Gruppen dürfen zur Vorbereitung existieren. Sie zeigen „Keine Einträge“;
  Gruppen ohne anstehende Einträge am gewählten Tag „Heute nichts offen/geplant“
  beziehungsweise eine passende Datumsformulierung, keinen grünen Abschluss.

### Tagesbezug, Sichtbarkeit und Vollständigkeit

- „Gruppen“ ergänzt `TaskView` auf derselben Ebene wie Aufgaben/Habits/Dringlichkeit.
  Datumsauswahl bleibt heute/Vergangenheit. Standardansicht beim Start unverändert.
- Zunächst gemeinsame bestehende Tagesdaten lesen und Versionen korrekt auflösen;
  danach für die jeweiligen UI-Listen nach Gruppenzuordnung aufteilen. Aufgaben-
  und Habit-Tab zeigen ausschließlich nicht zugeordnete Einträge. Dringlichkeit
  als weitere operative Liste erhält denselben Ausschluss, damit keine zweite
  Arbeitsliste für Gruppenmitglieder entsteht. Kalender, Projekt-/Einzeldetails,
  Historie und Auswertungen verwenden weiterhin den vollständigen Bestand.
- Die Gruppendarstellung enthält die nach den bisherigen Termin-/Sichtbarkeitsregeln
  für den gewählten Tag vorhandenen Vorkommen beider Arten, einschließlich dort
  sichtbarer offener Rückstände. Nie für jeden Gruppenteil automatisch eine neue
  Instanz erzeugen. Mehrere Vorkommen derselben Aufgabe nach Eintrag/Termin
  unterscheiden; keine Deduplizierung allein nach Aufgaben-ID.
- Nicht fällige, noch nicht gestartete, pausierte und beendete Teile erzeugen
  keine künstliche Tagespflicht. Die bestehende Tagesauswahl entscheidet;
  Gruppenzugehörigkeit verändert weder Rhythmus noch Missed-Regeln.
- Jedes sichtbare Vorkommen muss vollständig bearbeitet sein. Checkbox-Aufgabe:
  tatsächlich erledigt; Ja/Nein-Modus: explizite Antwort vorhanden, auch Nein;
  Wertmodus: gültiger Wert des erwarteten Typs gespeichert und regulär verarbeitet.
  Automatischer Misserfolg oder `no_entry` ohne Antwort/Pflichtwert genügt nicht.
  Zielerreichung ist keine zusätzliche Vollständigkeitsbedingung.
- Vorhandene Rückstände bleiben mit Datum sichtbar und zählen zur Vollständigkeit.
  Sie werden einzeln über die bisherigen Wege bearbeitet; V1-Sammelaktionen
  schließen nur heutige Vorkommen ab (Sperren unten). Ein Rückstand darf also
  weder verschwinden noch durch den heutigen Haken versehentlich erledigt werden.
- Header zeigt z. B. „3 von 5 bearbeitet“. Erledigte Gruppen bleiben am selben
  Platz. Einklappen ist pro Gruppe gespeichert, startet ausgeklappt, darf mehrere
  Gruppen gleichzeitig betreffen und ändert keinen Daten-/Abschlussstatus.
  Die globalen Kartenoptionen gelten weiterhin für die enthaltenen Karten.

### Kompakte Eingabe #011

- Im kompakten Kartenmodus erscheinen numerische Werteingaben als Zeile mit Titel,
  Feld, Einheit und einer verständlichen Speicheraktion; schmale Displays und
  große Schrift dürfen auf zwei Zeilen umbrechen. Gilt im Gruppentab und für
  nicht gruppierte numerische Einträge in ihren bisherigen Tabs.
- Keine neue Aufgabenart und keine Umklassifizierung vorhandener Daten. Die
  Darstellung folgt dem bestehenden Erfassungsmodus/Wertetyp, auch bei Zielen.
  `pure_tracking`, `required`, Ja/Nein und fachliche Ziele bleiben erhalten.
- Details, Notizen und Auswertungszugang bleiben erreichbar; Aufklappen folgt
  Optionen → Kartenanzeige (kompakt/groß/merken, eine/mehrere offene Karten).
  Bestehende Einstellungen nicht zurücksetzen oder durch Gruppenpräferenzen ersetzen.
- Bestehende Parser/Einheiten/Speicherwege wiederverwenden, keine parallelen
  Regeln in der Zeile erfinden. Dauer/Uhrzeit behalten in V1 die vorhandenen
  Eingabeelemente; die platzsparende neue Zeile betrifft Zahlen-Tracker.
- Entwürfe nach Aufgabe und tatsächlichem Vorkommen identifizieren. Streams,
  Teilabschluss, Auf-/Zuklappen und Validierung dürfen sie nicht verwerfen.
  Datums-/Tabwechsel oder Navigation bei ungespeicherten Änderungen fragt
  Speichern/Verwerfen/Abbrechen; ungültige Werte können nicht gespeichert werden.

### Gemeinsame Aktion und Rücknahme

- Der normale Gruppenabschluss prüft alle sichtbaren Inhalte. Fehlende/ungültige
  Werte werden an den Feldern markiert; Gruppe dafür öffnen und erste Problemstelle
  sichtbar machen. Keine Datenänderung bei gescheitertem vollständigem Abschluss.
- Darunter explizit „Nur abhakbare Einträge erledigen“: Nur zulässige offene
  Checkbox-/Ja-Nein-Vorkommen schreiben. Keine Werte speichern, Entwürfe erhalten,
  fertige Antworten nicht ändern. Bei null zulässigen Einträgen Aktion deaktivieren.
- Ohne Hindernis speichert die normale Aktion gültige neue/geänderte Wertentwürfe
  über die bestehenden Wertkorrekturwege und schließt die offenen abhakbaren
  Einträge in derselben Transaktion. Bereits gespeicherte Werte bleiben ohne
  ausdrücklichen Bearbeitungsentwurf unverändert. Bei Ja/Nein wird die zum
  aufgelösten Vorkommen konfigurierte Erfolgsantwort verwendet.
- Der Service ermittelt Ziele selbst aus Gruppe, Datum und aktuellen Einträgen;
  keine beliebigen Task-IDs oder Erledigt-Flags aus der Oberfläche übernehmen.
  Vorschau enthält Eintrags-/Versionsrevisionen, Zuordnung und relevante Regeln.
  Direkt vor dem Schreiben atomar erneut prüfen. Bei Änderungen: nichts schreiben,
  Ansicht aktualisieren und „Einträge haben sich geändert. Bitte erneut prüfen.“
- Wiederholtes Antippen ist unschädlich, UI sperrt laufende Aktion. Keine doppelten
  Instanzen, Antworten oder Korrekturen; ein Fehler rollt die gesamte gewählte
  Aktion zurück. Ein regulärer Validierungsfehler darf nicht unbemerkt zur
  Teilaktion werden. Asynchrone Fehler sichtbar anzeigen.
- Kein pauschales „Gruppe wieder öffnen“, das Antworten/Werte aller Mitglieder
  löscht. V1 korrigiert einzelne Einträge über bestehende Wege; der Gruppenstatus
  folgt automatisch. Ein vorhandener Einzel-Undo darf nur seinen Eintrag ändern.
  Kein irreführender Gruppen-Undo, solange keine atomare Rücknahme implementiert ist.

## Bewusste Grenzen der ersten Version

Jede fachliche Sperre auch im schreibenden Service prüfen; vorhandene Einzelwege
bleiben erhalten. Keine Einschränkung nur durch ausgeblendete UI.

| Fall | Verhalten/Grund | Hinweis und Ausweg |
|---|---|---|
| Sammelabschluss für Vergangenheit oder Rückstände | Gesperrt: Ausführungsdatum, Historienkorrektur und mehrere Serienvorkommen nicht pauschal festlegen | „Ältere Einträge bitte einzeln bearbeiten.“ Heute zulässige Einträge sind über die Teilaktion bearbeitbar; Rest hält Gruppe offen |
| Zukunft | Wie bisher kein Gruppenabschluss und keine Gruppentagesnavigation in die Zukunft | Planung im vorhandenen Kalender |
| An ein Wertebündel gebundener Eintrag | Gruppenzuordnung zunächst gesperrt, sobald eine nicht stornierte Bündelversion ihn referenziert, einschließlich historischer Versionen: keine doppelte Darstellung oder unterbrochene Kombination | „Bündelgebundene Einträge können derzeit keiner Gruppe zugeordnet werden.“ Bestehendes Bündel normal weiterverwenden; keine Neuanlage der Messhistorie verlangen |
| Neues/geändertes/wiederhergestelltes Bündel mit Gruppenmitglied | Entsprechenden Konflikt vor Schreibvorgang abweisen; auch Backup-Import prüfen | „Entferne den Eintrag zuerst aus seiner Gruppe.“ Keine heimliche Entfernung/Umzuordnung |
| Pausiert, Papierkorb, unzulässige historische Korrektur, unbekannter Erfassungsmodus oder andere bestehende Schreibsperre | Keine Umgehung durch Gruppenaktion; Vollabschluss stoppt, Teilaktion nur für explizit zulässige offene einfache Einträge | Bestehenden konkreten Sperrgrund anzeigen; Einzelbearbeitung beziehungsweise Wiederaufnahme nutzen |
| Leere Gruppe/kein anstehender Eintrag | Kein Sammelabschluss, keine fiktive Erledigung | Gruppe bearbeiten beziehungsweise anderen Tag wählen |
| Mehrfachzuordnung, Untergruppen, eigener Gruppenrhythmus | V1 nicht angeboten; einfaches, eindeutiges Eigentum der Anzeige | Eintrag verschieben; Rhythmus bleibt pro Aufgabe/Habit |

Bündelsperre ist eine abgeleitete vorläufige Abgrenzung, kein Nutzerwunsch gegen
Bündel. Vorhandene Bündelfunktionen und ihre Messhistorie bleiben erhalten.

## Daten und technische Schnittstellen

- Neue Tabellen `TaskDisplayGroups` (ID, Name, Reihenfolge, isCollapsed,
  createdAt/updatedAt, Revision) und `TaskDisplayGroupMembers` (taskId als eindeutiger
  Schlüssel/FK, groupId als FK, Reihenfolge). FKs beim echten Löschen kaskadieren
  nur auf Mitgliedschaften. Gruppenstatus wird nicht gespeichert.
- Mitgliedschaft nicht in TaskDefinitionVersions aufnehmen: reine aktuelle
  Anzeigezuordnung. TaskTypeChanges #013 und Änderungen des Trackingbeginns #002
  verändern die Gruppe nicht; keine neuen Sperren für normale Artenwechsel nötig.
- Eigene kleine Daten-/Projektions-/Aktionsklasse unter `features/aufgaben`:
  Gruppen-CRUD, Tagesprojektion und `preview`/`complete`/`completeCheckableOnly`.
  Date/Now injizierbar. Reine Vollständigkeitsfunktion getrennt von Schreiblogik.
  Abgeleitete Rückgabetypen enthalten Feldfehler, Sperrgründe und geänderte IDs.
- Bestehende Tasklisten vor Bündel-Kartenaufbereitung gemeinsam nutzbar machen,
  statt die beiden fertig dargestellten Listen mit ausgeblendeten Mitgliedern
  blind zusammenzukleben. Versionen pro Eintrag erhalten (#013). Bestehende
  Scheduleraufrufe auf heute/Vergangenheit begrenzen; Kalenderprojektion unberührt.
- Gemeinsame Transaktionsgrenze um vorhandene Schreiboperationen legen; falls
  nötig kleine interne Methoden extrahieren. Keine Kopie der umfangreichen
  Repository-Abschlusslogik. Async callbacks der Eingaben müssen Fehler/Erfolg
  erwartbar zurückgeben, damit erst nach Commit „erledigt“ angezeigt wird.
- Aktuell Schema 25. Neue Migration 26, sofern sich der Stand bis Umsetzung
  nicht erhöht hat: zwei leere Tabellen, keine automatischen Gruppen aus Projekten.
  Alte Datensätze und Kartenoptionen unverändert. Drift-Dateien regenerieren.
- Backup: beide Tabellen exportieren, Schema 22/23/24/25 weiter importieren,
  fehlende Gruppentabellen nur bei alten Schemas leer ergänzen. Zulässige
  Schema-25-Version ausdrücklich aufnehmen: aktuell akzeptiert der Import neben
  22–24 nur `scratch.schemaVersion`, was nach Erhöhung sonst 25 ausschließen würde.
  Schema-24-Kalender und Schema-25-Artenwechselprotokoll nicht verlieren.
- Neue Backups auf FKs, eindeutige Zuordnung, gültige Namen/Reihenfolgen und
  Bündelkonflikte im Scratch-Bestand prüfen, vor Ersatz der produktiven Daten.
  Ungültiger Import verändert keinen Bestand. Import-/Löschreihenfolge beachten.

## Umsetzungsauftrag G0–G6

Jeden Schritt abschließen, bevor abhängige Schritte begonnen werden. Diese Liste
ist der Auftrag für einen Umsetzungschat; keine neue fachliche Interviewrunde
für die oben bereits entschiedenen beziehungsweise abgeleiteten Regeln nötig.

| Schritt | Inhalt und maßgebliche Codepfade | Fertig, wenn |
|---|---|---|
| G0 | Kurzer Abgleich dieses Plans mit aktuellem Git-/Schema-/Teststand; `aufgaben_repository.dart`, `task_for_date.dart`, `task_capture_mode.dart`, `aufgaben_screen.dart`, `task_card.dart`, `value_task_input.dart`, Lifecycle/Backup/Kartenoptionen | Keine fremden Änderungen überschrieben; etwaige neue Widersprüche konkret benannt, kein erneuter Gesamtaudit |
| G1 | Gruppentabellen, CRUD/Zuordnung, Bündelschutz in beiden Richtungen, Migration und Backup-Kompatibilität | Gruppenänderung erhält Task-/Eintragsdaten; alte Backups laden, neue roundtrip-sicher, Konflikte atomar abgewiesen |
| G2 | Tagesprojektion/Vollständigkeit und validierte vollständige/teilweise Aktion, Datums-/Revisionsprüfungen | Gleiche Fachregeln bei UI und direktem Serviceaufruf; alles oder nichts pro gewählter Aktion |
| G3 | Gruppentab, Verwaltung, Reihenfolge/Einklappen, exklusive operative Listenfilter, unabhängige Projektsicht | Kein Eintrag verloren oder doppelt angezeigt; Datumswechsel/Neustart konsistent |
| G4 | Kompakte Zahlenzeile, Entwurfserhaltung, Feldmarkierungen und Teilaktionshinweis; bestehende Details/Kartenoptionen erhalten | Normale Einzelbedienung und beide Gruppenaktionen funktionieren auch mit Eingabevalidierung |
| G5 | Nachstehende gezielte Tests, anschließend vorhandene Gesamtsuite und Analyze gemäß Repo-Konvention | Relevante Regressionen und neue Regeln geprüft; tatsächlich ausgeführte Befehle/Ergebnisse dokumentiert |
| G6 | README, Arbeitsplan, implemented_changes und Verlauf aktualisieren; kurzen Gerätenachtest anhängen | Umgesetzt versus Geräteabnahme klar getrennt; kein Build/Release/Commit fremder Änderungen ohne Auftrag |

## Erforderliche Prüfungen

1. Kern-Abnahmefälle oben auf Service- und Widgetebene; Ja/Nein einschließlich
   umgekehrter Erfolgsregel, gültige Null, Ziel verfehlt bei vollständigem Wert.
2. Vollabschluss mit einem ungültigen Wert ändert nichts; Teilaktion schreibt
   nur zulässige einfache Einträge, Entwürfe/Nein/Messwerte erhalten. Gültige
   Entwürfe mit vollständiger Aktion gemeinsam speichern. Simulierter Schreibfehler
   rollt alles zurück, parallele Revision/Umzuordnung wird erkannt, Doppeltipp sicher.
3. Gemischte Rhythmen, nicht fällig/pausiert/noch nicht begonnen, Rückstände mit
   mehreren Vorkommen, Vergangenheit, leere Gruppen; keine fremden Termine erzeugt
   oder abgeschlossen. Pflichtwert fehlt trotz `no_entry`/automatischem Fehler.
4. Mitglied entfernen/verschieben, Gruppe löschen/sortieren, Pause/Papierkorb/
   Restore/Purge; keine Datenverluste. Bündelkonflikte in Zuordnung, Bündelpflege,
   Restore und Import; kein direkter Service-Bypass.
5. Exklusive Darstellung in Aufgaben/Habits/Dringlichkeit, aber unveränderte
   Kalender-/Projekt-/Statistikdaten. #013-Historienarten, #002-Startdatum und
   bestehende Bündel ohne Gruppen regressionsprüfen.
6. Kartenmodi und gespeichertes Einklappen, lange Namen/große Schrift/schmales
   Display, Fokus und Entwürfe nach Streamupdates/Teilabschluss/Navigation.
   Dauer-/Uhrzeiteingaben behalten ihre bisherigen Regeln.
7. Migration von 25 (und bestehende Legacy-Migrationstests), Backup-Import 22–25,
   neuer Roundtrip, kaputte FK-/Doppelzuordnung/Bündelkonflikt ohne Teilrestore.

Manueller Nachtest: gemischte Morgenroutine erstellen, bei leerem Wert den
Gesamthaken versuchen, Feldmarkierung prüfen, Teilaktion nutzen, Wert speichern,
automatischen Abschluss sehen; Nein beibehalten; Gruppe löschen und Einzelkarten
wiederfinden; Neustart und Export/Restore prüfen. Diesen Nachtest erst nach
Umsetzung als offen führen, nicht als bereits bestanden.

## Kopierbarer Auftrag

> Setze Phase 21 #011/#020/#004 nach
> `docs/10_tasks_habits/phase_21_test_improvements/daily_overview_groups_plan.md`
> vollständig in den Schritten G0–G6 um. Monitoring/A01 bleibt verschoben.
> Bewahre vorhandene Änderungen und die Kalender-, Karten-, #002- und
> #013-Funktionen. Beachte bestätigte Gruppenabschlüsse, abgeleitete V1-Grenzen,
> Migration/Backup und Abnahmetests. Bei einem echten Widerspruch zum aktuellen
> Code konkret nachfragen; bereits entschiedene Produktregeln nicht erneut öffnen.
