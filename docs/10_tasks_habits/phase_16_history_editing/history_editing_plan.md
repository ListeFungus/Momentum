# Momentum – Phase 16: Historisierung und Bearbeitungsregeln

Stand: 20. September 2026  
Status: Abgeschlossen; Pakete 16a–16f umgesetzt und automatisiert geprüft

## Ziel

Änderungen an Aufgaben, Habits, Zielen, Rhythmen und Projekten sollen alte
Einträge nicht verfälschen. Gleichzeitig muss die App verständlich bleiben.

## Aktueller Stand

Phase 16 ist umgesetzt. Historische Definitionen und Projektzuordnungen werden
am jeweiligen Stichtag aufgelöst; zukünftige Änderungen werden separat
vorgemerkt. Einträge besitzen eine stabile Identität, einen optionalen
Durchführungstag und eine Revision. Einzel- und Sammelkorrekturen werden mit
persistenter Undo-Grundlage gespeichert. Historische Bündel bleiben sichtbar,
und inkompatible Wertdefinitionen werden nicht still aggregiert.

Die Datenbank verwendet Schema 19. Drift-Codegenerierung, die gemeinsame
Aufgaben-/Projekt-Regressionssuite mit 117 Tests und die vollständige
Projektanalyse wurden am 20. September 2026 erfolgreich ausgeführt. Ein
manueller vollständiger Geräte-Abnahmelauf ist kein automatisierter Nachweis
und bleibt als empfohlene zusätzliche Praxisprüfung dokumentiert.

### Arbeitsauftrag dieser Planung

- In diesem Chat ausschließlich Dokumentation bearbeiten, keinen Anwendungscode.
- Grundlegende Entscheidungen einzeln mit Empfehlung und konkretem Beispiel
  klären; leicht revidierbare Detailentscheidungen später bündeln.
- Fragen mit ausreichend Kontext und einem konkreten Nutzerablauf stellen.
  Release 1 bewusst einfach halten; Erweiterbarkeit durch klare Daten- und
  Verantwortungsgrenzen sichern, nicht durch vorgezogene Komfortfunktionen.
- Präzisierung des Nutzers vom 20.09.: Keine weiteren Einzelinterviews zu
  problemlos behandelbaren Randfällen. Verständliche Standardregeln selbst
  ableiten und dokumentieren; nur bei wesentlichen fachlichen Widersprüchen,
  Datenverlust oder grundlegenden Folgen erneut nachfragen. Unvollständige
  Daten anzeigen, statt jede Lücke durch Sonderregeln verhindern zu wollen.
- Bestehende Entscheidungen übernehmen, soweit kein konkreter Widerspruch oder
  Änderungsbedarf besteht. Codefakten selbst prüfen, nicht beim Nutzer erfragen.
- Bestätigte Regeln, Vorschläge und offene Fragen ausdrücklich unterscheiden.
- Am Ende enthält dieser Plan umsetzbare Arbeitspakete, betroffene Codebereiche,
  notwendige Migrationen, Abnahmeszenarien und Grenzen zu späteren Phasen.
- Keine vorgezogene Cloud-, Papierkorb- oder vollständige Projektimplementierung;
  deren Anforderungen an Daten und Schnittstellen hier berücksichtigen.

### Erste Bestandsaufnahme vom 17. September 2026

Dokument- und Codeinventar gesichtet und relevante Pfade bis 20.09. gezielt
abgeglichen. Kein vollständiger Codeaudit oder Nachweis durch ausgeführte Tests.
Dokumentation enthält teilweise ältere Phasenstände; der technische Vertrag
unten berücksichtigt den geprüften Code und die neueren Fachentscheidungen.

| Bereich | Geprüfter Iststand / Bedeutung für Phase 16 |
|---|---|
| Datenbank | `lib/core/database/app_database.dart`: Schema 18. Vor späterer Umsetzung erneut prüfen, falls parallel weiterentwickelt wurde. |
| Definitionshistorie | `task_definition_versions_table.dart` und `task_definition_version_writer.dart`: vollständige Snapshots mit ID, Versionsnummer, Vorgänger und Gültigkeitsbeginn; unverändertes Speichern erzeugt keine neue Version. |
| Einträge | `task_entries_tabelle.dart`: Versionsreferenz sowie Antwort-, Abschluss-, Wirksamkeits- und Änderungszeitpunkt; noch keine eigene Korrekturhistorie. Wertdaten liegen zusätzlich in `task_entry_values_table.dart`. |
| Lesen und Automatik | `AufgabenRepository.watchTaskListForDate` verknüpft Einträge mit aktuellen Aufgaben/Projekten. Der Scheduler liest für direkte Missed-Konsequenzen aktuelle Aufgabenregeln. Eine gespeicherte Versions-ID schützt allein daher noch nicht vor Umdeutung. Weitere Lese-/Schreibpfade prüfen. |
| Korrekturen | `setTaskCompleted`, `setBooleanHabitValue`, `setTaskEntryNoEntry`, `setTaskEntryValue`: schreiben den aktuellen Eintragszustand und Zeitfelder neu. Historische Regeln, zulässige Statuswechsel und Änderungsnachweis benötigen einen gemeinsamen Vertrag. |
| Zieländerungen | Phase 14c bietet bei reinen Zieländerungen sofortige Wirksamkeit oder nächsten Zielblock. Vorgemerkte Ziele werden als vollständige zukünftige Snapshots gespeichert. Zwischenzeitliche Bearbeitung und mehrere Vormerkungen gezielt prüfen. |
| Versionsauflösung | `versionIdForScheduledDate` sortiert passende Versionen nach Versionsnummer; `_goalDefinitionVersionForDate` nach Gültigkeitsbeginn. Zukünftige Snapshots und Änderungen am selben Tag brauchen eine einheitliche, deterministische Regel. |
| Wert-Auswertung | Phase 15 schützt Karten bei inkompatiblen Definitionen. Vollständige historische Detailauswertung, Einheitenwechsel und aufgelöste Bündel sind ausdrücklich an Phase 16 übergeben. |
| Projekte | `ProjectRepository` versioniert Aufgaben bei Zuordnungsänderungen. Name/Beschreibung/Farbe eines Projekts werden direkt überschrieben; Projektzusammenfassungen verwenden die aktuelle Zuordnung. |

Codepfade ohne Verzeichnisangabe liegen unter `lib/features/aufgaben/data/`.
Projektcode liegt unter `lib/features/projekte/data/`.

### Bereits dokumentierte Leitplanken

Diese Punkte sind bestehende Entscheidungen, keine neuen Beschlüsse dieser Sitzung:

- E-28/E-47/E-48 bis E-50 im Aufgabenstrukturplan: vergangene Instanzen bleiben
  korrigierbar und behalten ihre Definitionsversion. Bereits erzeugte
  Folgeinstanzen werden durch eine Antwortkorrektur nicht verschoben.
- Definition ändern und Antwort korrigieren sind verschiedene Vorgänge.
  Eine Definitionsänderung darf alte Antworten nicht stillschweigend umwerten.
- Phase 14c: sofortige Zieländerung innerhalb eines Zielblocks macht den
  betroffenen historischen Mischblock nicht wertbar; alternativ Start im
  nächsten Block. Kombination mit anderen Änderungen ist gesondert zu klären.
- Phase 12: virtuelle leere Tracking-Tage, gespeicherte Antworten, bewusste
  `no_entry`-Ausnahmen und automatische `no_entry`-Einträge unterscheiden.
  Virtuelle Tage werden erst bei bewusster Bearbeitung materialisiert.
- Phase 15: Kartenwerte sind aus heutigen Rohdaten berechnete Rückblicke;
  Antwortkorrekturen dürfen sie verändern. Anzeigepräferenzen sind keine
  fachlichen Definitionsversionen.
- Phase 17/19: Wiederherstellung ohne Nachplanung der Papierkorbzeit sowie
  schreibsparsame Synchronisierung vorbereiten; noch keine Cloud umsetzen.

### Reihenfolge der grundlegenden Klärungen

1. **Identität und Bearbeitungsgrenzen:** Welche Änderungen gehören noch zu
   derselben Aufgabe bzw. Messgröße, wann beginnt eine neue Aufgabe?
2. **Wirksamkeit:** Änderungen heute, alte offene Instanzen, nachträgliche
   Instanzerzeugung, virtuelle Tage und bereits vorgemerkte Ziele.
3. **Historische Darstellung und Auswertung:** damalige Texte/Projekte,
   vergleichbare Einheiten, inkompatible Abschnitte und Bündelversionen.
4. **Antwortkorrekturen:** erlaubte Übergänge, tatsächlicher Abschluss versus
   Korrekturzeit, Wiederöffnung, Nachweis und Rückgängigmachen.
5. **Sammelkorrekturen:** Auswahlumfang, Vorschau, atomare Ausführung und
   Auswirkungen auf Auswertungen sowie spätere Synchronisierung.
6. **Umsetzungspakete und Abnahme:** konkrete Lücken aus den bestätigten Regeln
   ableiten; kleine UI-/Komfortentscheidungen gesammelt abschließen.

Ersetzte Ansätze P16-01 bis P16-03 stehen ausschließlich im [Verlauf](history_editing_history.md). Maßgeblich ist die bestätigte Kopierlösung ab P16-04.

### P16-04 – Vereinfachung: feste Messkonfiguration und Kopiervorlage

**Bestätigt am 19. September 2026; ersetzt den Ablauf aus P16-01 bis P16-03:**
Bestehende Aufgaben behalten in
Release 1 ihren Erfassungsmodus, ihre Wertart und ihre Einheit einschließlich
benutzerdefinierter Einheitenbezeichnung. Auch kompatible Einheitenwechsel
(Liter zu Milliliter) werden zunächst nicht innerhalb derselben Aufgabe angeboten.
Gespeicherte Messwerte/Antworten bleiben korrigierbar; die Sperre betrifft nur
die Messkonfiguration. Verbindlichkeit/Tracking-Modus sind durch P16-12 gesperrt.

Beschlossener Ablauf:

1. Gesperrte Felder lesbar anzeigen und mit einem sichtbaren Hinweis erklären:
   Änderung über eine neue Aufgabe; bestehende Auswertungen bleiben erhalten.
2. Aktion **Als neue Aufgabe kopieren** öffnet eine vorausgefüllte
   Erstellung. Bis zum Speichern existiert nur ein Entwurf; Abbruch schreibt nichts.
3. Name, Beschreibung, Projekt und Rhythmus können als Vorlage dienen.
   Messkonfiguration ist im neuen Entwurf frei änderbar.
4. Neue Aufgabe erhält eigene ID und erste Definitionsversion, keine alten
   Antworten, Termine oder Versionsketten. Startdatum standardmäßig heute;
   alte Fälligkeit nicht ungeprüft übernehmen. Kein rückwirkender Start durch Kopieren.
5. Bei geänderter Messkonfiguration alte Wertziele zurücksetzen und sichtbar
   zur Neueinstellung anbieten: z. B. ein Ziel von 5 Kilometern darf nicht
   automatisch ein Ziel von 5 Minuten werden. Bündelzugehörigkeit, vorgemerkte
   Zieländerungen und Kartenpräferenzen nicht automatisch übertragen.
6. Original bleibt vollständig unverändert. Dies ersetzt ausdrücklich
   P16-02 (keine automatische Beendigung durch Kopieren).
   Wer das Original nicht weiterführen möchte, benötigt einen getrennten Vorgang;
   eine vollständige Beenden-/Archivfunktion existiert derzeit noch nicht.

Begründung: Kein Umbau historischer Maßeinheiten und keine gekoppelte
Ersetzen-Transaktion nötig. Unabhängige Aufgaben und bestehende
Definitionsversionen lassen spätere kontrollierte Einheitenwechsel weiterhin zu.
Bereits früher entstandene gemischte Daten müssen trotzdem sicher angezeigt
werden; eine neue Bearbeitungssperre repariert diese nicht rückwirkend.

Codebefund: Der Erfassungsmodus ist im bestehenden `TaskEditScreen` bereits
fest, Wertart/Einheit sind noch editierbar. `AufgabeHinzufuegenScreen` hat bisher
keinen Vorlagenparameter; hierfür einen optionalen Erstellungsentwurf ergänzen
und bestehende Validierung wiederverwenden. `createTask` erzeugt bereits eine
neue ID und Anfangsversion. Sperren zusätzlich im Repository absichern.

Abnahme: gesperrte Messkonfiguration auch im Speicherpfad; Messwerte weiterhin
korrigierbar; Kopierentwurf abbrechbar ohne Schreibvorgang; gespeicherte Kopie
mit eigener ID und ohne Alteinträge; Original inklusive Planung unverändert;
keine automatische Übernahme unpassender Wertziele oder Bündelverknüpfungen.

### Vorgemerkte Erweiterung – kompatible Einheiten wechseln

**Auf Nutzerwunsch am 19. September 2026 vorgemerkt, nicht Teil von Release 1:**
Wechsel innerhalb derselben Messgröße, z. B. Liter ↔ Milliliter oder Kilometer
↔ Meter, sollen später ohne neue Aufgabe ergänzt werden können.

Dies ist gegenüber einem Messgrößenwechsel eine überschaubare, gezielte
Erweiterung: Einheitenfamilien, Umrechnungsfaktoren, gespeicherte Originaleinheiten,
normalisierte Zahlenwerte und Definitionsversionen sind bereits vorhanden.
Kein grundlegender Neuaufbau des Aufgabenmodells ist dafür vorgesehen.
Es ist aber mehr als das Entsperren eines Dropdowns:

- Originalwerte und damalige Einheit unverändert erhalten; Auswertung verwendet
  eine gemeinsame Basiseinheit und rechnet für die Anzeige um.
- Wertziele korrekt umrechnen (2 Liter entsprechen 2000 Millilitern), nicht nur
  das Einheitenlabel austauschen.
- Historische Korrekturen, Karten-/Detailauswertung und Bündel konsistent halten.
- Nur bekannte kompatible Einheiten erlauben; keine Umrechnung von freien
  Einheitenbezeichnungen oder zwischen unterschiedlichen Messgrößen ableiten.

Die Release-1-Sperre als zentrale Bearbeitungsregel umsetzen; vorhandene
Einheitenmetadaten und Versionsbezüge erhalten. Später lässt sich die Freigabe
gezielt erweitern, ohne neue Aufgaben oder Antworten rückwirkend zu vermischen.

### P16-05 – Planungsänderungen ab morgen und nachvollziehbare Erklärung

**Bestätigt am 19. September 2026:** Änderungen des Rhythmus und der Regeln für
verpasste Einträge gelten ab dem nächsten lokalen Kalendertag. Der heutige Tag
und ältere Einträge behalten ihre bisherigen Regeln, einschließlich laufender
Puffer. Maßgeblich ist der fachliche Tag, nicht der Zeitpunkt, zu dem die App
eine Instanz tatsächlich in der Datenbank anlegt. Auch nach einer Nutzungspause
werden historische Tage nach ihrer damals gültigen Planung behandelt.

- Die bestehende Sonderregel für reine Zieländerungen bleibt erhalten
  (sofort oder nächster Zielblock). Keine pauschale Übertragung der Morgen-Regel
  auf Titel, Projektzuordnung, Startdatum oder einmalige Fälligkeit; diese Felder
  in der abschließenden Bearbeitungsmatrix ausdrücklich einordnen.
- Bestehende Antworten, Versionsbezüge und offene Altinstanzen nicht durch
  die Planungsänderung umschreiben. Vorab erzeugte zukünftige Instanzen sind
  ein gesonderter Prüffall: nicht stillschweigend überschreiben oder löschen;
  den konkreten Umgang regelt technischer Vertrag A.

**Verbindliche UX-Anforderung des Nutzers:** Es muss erkennbar sein, was eine
Änderung bewirkt, ab wann sie zählt und warum. Info-Button oder erklärendes
Popup bereitstellen; nicht voraussetzen, dass Nutzende die Regeln kennen.

Für Rhythmus-/Policy-Änderungen konkret:

- Vor dem Speichern den tatsächlichen Gültigkeitsbeginn sichtbar angeben,
  z. B. bei Bearbeitung am 19.09.2026: **„Gilt ab morgen, 20.09.2026.
  Heutige und ältere Einträge behalten ihre bisherigen Regeln.“**
- Direkt zugeordnetes Info-Element erklärt den Grund: bisherige Planung,
  laufende Fristen und historische Auswertungen bleiben nachvollziehbar.
- Nach dem Speichern muss in Details und beim erneuten Bearbeiten die
  vorgemerkte Änderung mit ihrem Datum erkennbar bleiben. Ein einmaliger
  flüchtiger Hinweis allein genügt nicht.
- Ist bei einem alten offenen Eintrag noch die frühere Regel wirksam,
  diese am Eintrag anzeigen/erklären, statt nur die neue Aufgabeneinstellung.
- Bei mehreren Änderungen mit unterschiedlichen Gültigkeitsbeginnen die
  betroffenen Gruppen mit Datum ausweisen, nicht pauschal „ab morgen“ melden.
- Datum aus dem tatsächlich gespeicherten Wirksamkeitsbeginn ableiten;
  Tageswechsel zwischen Öffnen und Speichern darf keine falsche Zusage erzeugen.

Technische Konsequenz für die Umsetzung: fachlich datierte Versionsauflösung
gemeinsam für Scheduler, Eingaben, Ansichten und Auswertung verwenden.
`updateTask` schreibt heute unmittelbar die aktive Aufgabe; nur `validFrom`
auf morgen zu setzen reicht daher nicht. Kombination mit vorgemerkten
Zielversionen sowie erneute Bearbeitung vor Wirksamkeit müssen ohne Verlust
anderer Einstellungen funktionieren. Architektur und Paketgrenze stehen in A/16a–16b.

Abnahme: Änderung heute mit Wirksamkeit morgen; alter Puffer bleibt bestehen;
Nachplanung nach mehrtägiger Nichtnutzung; erneutes Öffnen zeigt Vormerkung;
Erklärung und gespeichertes Datum stimmen überein; kombinierte Zieländerung
überschreibt keine andere vorgemerkte Regel.

### P16-06 – Durchführung und Nachtrag unterscheiden

**Bestätigt am 19. September 2026:** Bei nachträglicher Erledigung unterscheidet
die App tatsächliche Durchführung und spätere Eingabe/Korrektur.

- Für einen vergangenen Eintrag die Auswahl **Am vorgesehenen Tag erledigt**
  oder **Heute erledigt** anbieten; bei Bedarf ein anderes Datum auswählen.
- Beispiel: Montag fällig, Donnerstag eingetragen. Durchführung am Montag ist
  ein rechtzeitiger Nachtrag; Durchführung am Donnerstag ist verspätet,
  sofern die damalige Pufferregel keine Rechtzeitigkeit mehr erlaubt.
- Fachlichen Durchführungstag und technischen Eingabe-/Korrekturzeitpunkt
  getrennt speichern. `scheduledDate` bleibt der geplante Instanztag; ein
  verspäteter Abschluss verschiebt nicht die Zuordnung der Instanz.
- Rechtzeitigkeit anhand der Durchführung und damals gültigen Frist bestimmen;
  verspätetes Eintragen nicht automatisch mit verspäteter Durchführung gleichsetzen.
- Eine Korrektur bereits gespeicherter Messwerte oder Notizen verändert nicht
  beiläufig den Durchführungstag. Eine Änderung dieses Tages muss bewusst erfolgen.
- Bereits erzeugte Folgetermine bleiben nach E-47 unverändert. Wenn noch keine
  Folgeinstanz existiert, ist bei abschlussgebundenem Rhythmus die fachliche
  Wirksamkeit maßgeblich; Nachplanung mit zurückdatiertem Abschluss gezielt prüfen.
- Nach P16-05 im Dialog erklären, dass die Auswahl Rechtzeitigkeit beeinflusst,
  bestehende Folgetermine aber nicht verschiebt.

Technische Ausarbeitung: `respondedAt`, `finalizedAt`, `effectiveAt` und
`updatedAt` existieren, werden bei manuellen Antworten aber derzeit überwiegend
auf den Eingabezeitpunkt gesetzt. Feldvertrag und alle Auswertungsleser gemeinsam
anpassen; Datumsangaben dürfen keine tatsächlich bekannte Uhrzeit vortäuschen.
Granularität und Migration alter Zeitangaben sind in Vertrag B/F festgelegt.
Keine historische Durchführung aus alten technischen Zeitstempeln erfinden.
Für negative Antworten, `no_entry` und Uhrzeit-Messwerte keine tatsächliche
„Erledigung“ unterstellen; diese Fälle in der Korrekturmatrix separat behandeln.

Abnahme: rechtzeitiger Nachtrag; tatsächlich verspätete Durchführung; anderes
Datum; Puffergrenze; bloße Wert-/Notizkorrektur erhält Durchführungstag;
bestehender Folgetermin unverändert; neuer Folgetermin aus fachlichem Abschluss.

### P16-07 – Umfang der Sammelkorrekturen

**Bestätigt am 19. September 2026:** Release 1 erlaubt Sammelkorrekturen von
Antworten/Status innerhalb genau einer Aufgabe. Auswahl einzelner Einträge oder
Filter nach Zeitraum und bisherigem Status; keine aufgabenübergreifende Aktion.

- Vor dem Speichern Anzahl, bisherigen Status bzw. Statusverteilung und
  Zielstatus anzeigen. Erklären, dass die Auswertung aktualisiert wird und
  nicht ausgewählte Einträge unverändert bleiben.
- Beispiel: **„12 Einträge werden von Kein Eintrag zu Nicht geschafft geändert.“**
- Messwerte, Durchführungsdaten und Notizen bleiben in Release 1 einzeln
  korrigierbar. Kein gemeinsames Eintragen von z. B. 2 Litern für mehrere Tage
  und kein gemeinsames Verschieben von Durchführungsdaten.
- Nur fachlich zulässige Antworten anbieten; die konkrete Übergangsmatrix je
  Erfassungsart und der Umgang mit Zeitangaben bei Statuswechseln stehen in
  Vertrag B/C. Die Umfangsentscheidung erlaubt nicht jeden technischen Status.
- Virtuelle Tracking-Lücken sind nicht automatisch gespeicherte
  `no_entry`-Einträge. Auswahl/Materialisierung getrennt klären, keine pauschale
  Umwertung leerer Kalendertage aus dieser Entscheidung ableiten.

Erweiterbarkeit: Auswahl/Filter, Validierung und Anwendung einer Korrektur
getrennt halten. Weitere Korrekturarten können später dieselben Grundlagen
nutzen; keine vorgezogene generische Massenbearbeitungsoberfläche entwickeln.

Abnahme: Auswahl bleibt innerhalb einer Aufgabe; Vorschau entspricht dem
tatsächlichen Umfang; nur gewählte zulässige Einträge werden geändert;
Auswertungen reagieren auf die Korrektur; Messwerte/Notizen/Durchführungsdaten
sind keine frei wählbaren Sammelbearbeitungsfelder.

### P16-08 – Einfache Rückgängig-Funktion

**Bestätigt am 19. September 2026:** Die letzte Einzel- oder Sammelkorrektur
pro Aufgabe kann rückgängig gemacht werden, auch nach erneutem Öffnen der App.
Eine Sammelkorrektur ist ein zusammengehöriger Vorgang. Keine mehrstufige
Undo-/Redo-Oberfläche oder umfangreiche sichtbare Änderungshistorie in Release 1.

- Vorherigen Zustand, Änderungszeitpunkt und die betroffenen Einträge dauerhaft
  speichern. Bei Wertkorrekturen gehören relevante Wertdaten dazu; bei
  Statuskorrekturen auch fachliche Zeitangaben und Herkunft.
- Rückgängig stellt den vorherigen fachlichen Zustand wieder her. Technische
  Änderungsmetadaten müssen den neuen Rückgängig-Vorgang widerspiegeln, damit
  spätere Synchronisierung ihn als Änderung erkennen kann.
- Wurde seit der Korrektur einer der betroffenen Einträge erneut bearbeitet
  oder automatisch verändert, den gesamten Rückgängig-Vorgang ablehnen.
  Keine Teilwiederherstellung und kein Überschreiben neuerer Änderungen.
- Mit verständlicher Erklärung auf Einzelkorrektur verweisen, z. B.
  **„Ein betroffener Eintrag wurde inzwischen geändert. Diese Korrektur kann
  deshalb nicht mehr vollständig rückgängig gemacht werden.“**
- Prüfung und Wiederherstellung als atomaren Vorgang ausführen. Auch eine
  Sammelkorrektur selbst wird vollständig gespeichert oder gar nicht.
- Rückgängig ändert keine bereits erzeugten Folgetermine (E-47). Auswirkungen
  auf Auswertung und Karten werden aus den wiederhergestellten Daten abgeleitet.

Technische Grundlage (konkretisiert in Vertrag C): dauerhaften Korrekturvorgang mit stabiler
ID, Vorher-Zuständen und verlässlichem Vergleich gegen den erwarteten
Nachher-Zustand definieren. Keine flüchtige Snackbar als einzige Undo-Grundlage.
Erste reguläre Eingabe versus spätere Korrektur, materialisierte Tracking-Tage,
Aufbewahrung verbrauchter Vorgänge und Anbindung an spätere endgültige Löschung
nach Vertrag C/F behandeln. Kein vollständiges Event-Sourcing der App erforderlich.

Abnahme: Einzelkorrektur rückgängig; vollständige Sammelkorrektur rückgängig;
Neustart zwischen Korrektur und Undo; ein inzwischen geänderter Eintrag sperrt
den gesamten Vorgang ohne Teiländerung; Auswertungen aktualisiert;
Folgetermine unverändert; kein mehrstufiges Undo/Redo vorausgesetzt.

### P16-09 – Wiederöffnen ohne neue Frist

**Bestätigt am 19. September 2026:** Antworten bleiben nach Ablauf korrigierbar;
eine neue offene Verpflichtung mit neu gestarteter Frist entsteht dadurch nicht.

- Innerhalb einer laufenden Frist einschließlich Puffer darf eine Antwort
  entfernt und der Eintrag wieder auf `pending` gesetzt werden.
- Nach Ablauf einer automatischen Abschlussfrist ist Wiederöffnen gesperrt.
  Andere fachlich zulässige Antwortkorrekturen bleiben möglich.
- Ohne automatische Abschlussregel bleibt Wiederöffnen möglich.
- Gesperrte Aktion erklären: **„Die Frist dieses Eintrags ist bereits
  abgelaufen. Du kannst die Antwort korrigieren, den Eintrag aber nicht erneut
  öffnen.“** Kein stilles Zurücksetzen mit sofortigem automatischem Abschluss.
- Historische Instanzregeln verwenden, nicht die inzwischen geänderte
  Aufgabenkonfiguration. Wiederöffnen erzeugt keine neue Definitionsversion.

Beispiel: Am Montag fällig und am Dienstag automatisch abgeschlossen. Am
Donnerstag kann die Antwort zu „erledigt am Montag“ korrigiert werden; sie kann
nicht auf „offen“ mit einer neuen Frist gesetzt werden.

Die ergänzenden Regeln für Carryover-Höchstzahl, vorhandene Folgeinstanzen und
Rückgängig nach zwischenzeitlichem Fristablauf sind in P16-15 bestätigt.

Abnahme: Wiederöffnen innerhalb der Frist und im Puffer; Sperre nach Ablauf mit
Erklärung; Wiederöffnen ohne automatische Konsequenz; alternative
Antwortkorrektur bleibt nach Ablauf möglich.

### P16-10 – Projektidentität und Darstellung

**Bestätigt am 20. September 2026:** Projekte besitzen eine stabile ID.
Name, Farbe und Beschreibung können geändert werden; auch bei historischen
Einträgen werden die aktuellen Projektangaben angezeigt. Keine eigene
Versionshistorie dieser Projektangaben in Release 1 erforderlich.

- Umbenennen/Umfärben verändert weder die Projektidentität noch die historische
  Zuordnung oder die daraus abgeleiteten Zahlen.
- Beispiel: Projekt „Gesundheit“ wird in „Wohlbefinden“ umbenannt. Ältere
  Einträge zeigen „Wohlbefinden“, gehören aber unverändert zu derselben Projekt-ID.
- Historische Zugehörigkeit einer Aufgabe ist davon getrennt. Eine Änderung
  ihrer Projekt-ID darf nicht versehentlich alle älteren Einträge umhängen.
- Darstellung nach Projektlöschung und Erhalt historischer Referenzen mit
  Phase 17/18 abstimmen; keine Löschregel aus dieser Entscheidung ableiten.

### P16-11 – Projektwechsel mit zwei ausdrücklich benannten Optionen

**Bestätigt am 20. September 2026:** Beide Varianten anbieten:

| Option | Wirkung | Beispiel |
|---|---|---|
| Ab Datum X zuordnen | Vor dem Stichtag bleibt die bisherige Zuordnung; ab dem Stichtag zählt die Aufgabe zum gewählten Projekt. | Wechsel am 01.10.: September bleibt bei Gesundheit, Oktober zählt zu Training. |
| Gesamte Historie verschieben | Die gesamte bisherige Historie und die aktuelle Zuordnung wechseln bewusst zum gewählten Projekt. | Eine von Anfang an falsch zugeordnete Aufgabe wird vollständig richtig zugeordnet. |

- Stichtagswechsel ist der normale Vorgang; rückwirkendes Verschieben als
  separate, ausdrücklich benannte Option mit Vorschau und Erklärung anbieten.
- Historische Zuordnung anhand des geplanten Instanztags bestimmen, nicht
  anhand des späteren Eingabe-/Korrekturzeitpunkts. Antworten und Messwerte
  bleiben durch den Projektwechsel unverändert.
- Bei gesamter Historie auf geänderte Auswertungen der betroffenen Projekte
  hinweisen. Hatte die Aufgabe mehrere frühere Projekte, umfasst „gesamte
  Historie“ sämtliche bisherigen Zuordnungen; Vorschau darf nicht nur das
  aktuelle Quellprojekt nennen.
- Keine neue Aufgabe erzeugen. Definitionen zu Messgröße, Rhythmus, Zielen und
  Fristen sowie bestehende Antwortzeitpunkte bleiben fachlich unverändert.
- Gleiche Regeln für Zuordnung aus der Aufgabenbearbeitung und aus einer
  Projektansicht verwenden; keine stillen Umgehungen durch zweite Schreibpfade.

Codebefund: `ProjectRepository._updateProjectAssignmentsWithVersions` schreibt
aktuell die Projekt-ID in der Aufgabenzeile und erzeugt einen vollständigen
Snapshot. Das allein genügt weder für geplante Stichtage noch für eine bewusst
rückwirkende Projektkorrektur. Vor Umsetzung einen zentralen, datierten
Zuordnungsvertrag ableiten; alte Definitionsversionen nicht pauschal umschreiben
und Einträge nicht an eine aktuelle Version mit anderen Fachregeln hängen.

Datumsbereich und Vormerkungen sind in P16-18 konkretisiert. Rückgängig für
Zuordnungskorrekturen und Schnittstelle zur Projektanalyse in Phase 18 stehen
im technischen Vertrag C/D.

Abnahme: Stichtag trennt alte/neue Projektzuordnung; gesamte Historie verschiebt
auch Einträge aus früheren Drittprojekten; keine Antwort-/Messwertänderungen;
keine Veränderung von Fristen/Zielen; Umbenennen eines Projekts ändert nur seine
Anzeige; gleicher Effekt über alle Zuordnungsoberflächen.

### P16-12 – Weitere Bearbeitungsgrenzen für Release 1

**Bestätigt am 20. September 2026:**

| Feld | Regel |
|---|---|
| Name, Beschreibung, Fragetext | Bearbeitbar; aktuelle Aufgabe zeigt neue Texte, historische Einträge behalten ihre damaligen Texte. |
| Ursprüngliches Startdatum | Nach Erstellung gesperrt, mit Erklärung und Verweis auf Kopierfunktion. |
| Aufgabenart Aufgabe/Habit | Nach Erstellung gesperrt; Wechsel über eigenständige Kopie. |
| Reines/verbindliches Wert-Tracking | Nach Erstellung gesperrt; Wechsel über eigenständige Kopie. |

- Diese Sperren ergänzen die bereits beschlossene Sperre von Erfassungsmodus,
  Wertart und Einheit. Auch im Repository prüfen, nicht ausschließlich in Widgets.
- Rhythmus, Ziele und Missed-Regeln bleiben nach P16-05 und den bestehenden
  Zieländerungsregeln bearbeitbar. Eine einmalige Fälligkeit ist vom ursprünglichen
  Startdatum getrennt und durch diese Entscheidung nicht gesperrt.
- Beispiel Textänderung: „Lesen“ wird „Fachbuch lesen“. Die aktuelle Aufgabe
  erhält den neuen Titel; alte Antworten bleiben im damals gültigen Textkontext.
- Die aktuelle Aufgabenanzeige und der historische Kontext eines Eintrags
  benötigen unterscheidbare Datenquellen. Ein neuer Titel darf bei gemeinsamer
  Speicherung nicht versehentlich eine für morgen vorgemerkte Rhythmusänderung
  vorzeitig aktivieren oder ein zukünftiges Ziel verwerfen.
- Kontrollierte Wechsel der gesperrten Konfiguration können später ergänzt
  werden; dafür bestehende Versionsdaten erhalten. Für Release 1 keine
  rückwirkende Neuinterpretation oder automatische Historienübertragung bauen.

Abnahme: neue Texte an aktueller Aufgabe, alte Texte bei historischen Einträgen;
gesperrte Felder mit Erklärung und funktionierender Kopieralternative;
unzulässige Änderungen auch bei direktem Repository-Aufruf abgewiesen;
Textänderung verändert keine vorgemerkten Fachregeln.

### P16-13 – Einmalige Fälligkeit verschieben

**Bestätigt am 20. September 2026:** Eine offene einmalige Aufgabe darf ihre
Fälligkeit sofort auf heute oder einen zukünftigen Tag verschieben. Das ist
eine ausdrückliche Ausnahme von der Morgen-Regel für wiederkehrende Planung.

- Es bleibt derselbe fachliche Eintrag mit vorhandenen Notizen. Am alten
  Termin keine zusätzliche Instanz oder einen allein durch das Verschieben
  verursachten Misserfolg erzeugen.
- Vor Speichern alten und neuen Termin sowie sofortige Wirksamkeit anzeigen,
  z. B. **„Fälligkeit wird vom 20.09. auf den 25.09. verschoben.
  Die neue Frist gilt sofort.“**
- Bereits überfällige, noch offene Aufgaben dürfen verschoben werden und
  gelten anschließend nach der neuen Frist. Ursprünglichen Termin zur
  Nachvollziehbarkeit erhalten; Verschiebe-Auswertung erst spätere Erweiterung.
- Bei bereits abgeschlossenen Einträgen (`success`, `failure`, `no_entry`
  bzw. `recorded`) bleibt die damalige Fälligkeit bestehen. Antworten können
  korrigiert werden; für einen neuen Versuch die Kopierfunktion anbieten.
- Kein rückwirkendes Verschieben auf einen vergangenen Tag aus dieser Regel
  ableiten. Hinzufügen/Entfernen einer Fälligkeit bei bisher undatierten
  Aufgaben regelt technischer Vertrag B.

Technische Konsequenz: Die aktuelle Eintrags-ID wird an mehreren Schreibstellen
aus `taskId:YYYY-MM-DD` abgeleitet. Ein bloßes Ändern von `Aufgaben.dueDate`
genügt nicht und kann einen weiteren Eintrag erzeugen. Verschieben als eigenen
atomaren Vorgang entwerfen, bestehende Eintragsidentität und Referenzen erhalten
und Datumsauflösung der Eingabe-/Lesewege prüfen. Dies ist keine allgemeine
Erlaubnis, historische Instanzen auf neuere Definitionsversionen umzuhängen.

Abnahme: offener Termin auf heute/Zukunft verschoben; überfälliger offener
Eintrag folgt neuer Frist; keine Doppelinstanz nach Scheduler-Lauf; Notizen und
Referenzen erhalten; abgeschlossener Eintrag gesperrt mit Erklärung;
Abbruch ohne Änderung; ursprünglicher Termin nachvollziehbar.

### P16-14 – Bündelberechnung für Release 1 fest

**Bestätigt am 20. September 2026:** Quellen, Formel einschließlich Richtung
und Tageszuordnung eines bestehenden Bündels bleiben unveränderlich. Für eine
andere Berechnung wird das Bündel aufgelöst und ein neues erstellt. Vorhandene
Einzeltrackings können weiterverwendet werden; keine Kopie ihrer Messwerte.

- Das alte Bündel bleibt für seinen damaligen Gültigkeitszeitraum historisch
  auswertbar, mit damaligen Quellen und damaliger Berechnung.
- An gesperrten Feldern den Weg über Auflösen/Neuanlage verständlich erklären.
- Beispiel: „Schlafdauer“ aus Einschlafzeit und Aufstehzeit wird durch ein
  neues Bündel aus Bettgehzeit und Aufstehzeit ersetzt. Historische Schlafdauer
  nicht nachträglich mit Bettgehzeit berechnen.
- Diese Entscheidung ersetzt für Release 1 die in Phase 12 vorgesehene direkte
  Änderung einer Quelle ab Datum. Ein Quellenwechsel innerhalb derselben
  Bündel-ID bleibt spätere Erweiterung auf vorhandener Bündelversionierung.
- Die Entscheidung betrifft Berechnungsstruktur, nicht automatisch Änderungen
  an Bündelnamen, Beschreibungen, Zielen oder reinen Anzeigepräferenzen.

Codebefund: `TaskValueBundleVersions` speichert Quellen, Formel, Richtung,
Tagesversatz und Gültigkeitsgrenzen bereits. `dissolveValueBundle` beendet die
Version und setzt das Bündel inaktiv. Historische Leser dürfen inaktive Bündel
nicht pauschal ausschließen. Auflösung am Erstellungstag, genaue Tagesgrenze
und anschließende Neuanlage mit denselben Quellen nach Vertrag E behandeln;
aktuelle Mindestlaufzeit der Version kann sonst eine Überschneidung verursachen.

Abnahme: alte Bündel nach Auflösung auffindbar und historisch korrekt;
Messwerte der Einzeltrackings unverändert; neue Berechnung nur im neuen Bündel;
keine doppelte aktive Zuordnung einer Quelle; Kopieren eines Einzeltrackings
übernimmt keine Bündelzugehörigkeit.

### P16-15 – Schutzregeln für Wiederöffnen und Rückgängig

**Bestätigt am 20. September 2026:** Korrektur und Rückgängig dürfen keinen
unzulässigen offenen Zustand erzeugen. Die Regeln ergänzen P16-08/P16-09.

| Situation | Verbindliche Regel |
|---|---|
| Rückgängig würde nach zwischenzeitlichem Fristablauf einen nicht mehr zulässig offenen Zustand herstellen | Gesamten Undo-Vorgang mit Erklärung sperren; andere zulässige Antwortkorrektur bleibt möglich. |
| Abschlussgebundener Rhythmus hat bereits eine Folgeinstanz erzeugt | Vorherigen Eintrag nicht wieder öffnen, auch nicht durch Undo. Antwortkorrektur bleibt möglich; bestehender Folgetermin bleibt unverändert. |
| Wiederöffnen würde das Carryover-Maximum überschreiten | Aktion sperren; nicht als Nebenwirkung einen anderen offenen Eintrag automatisch abschließen. |

- Historische Regeln und aktuellen Bestand gemeinsam prüfen. Erklärungen nennen
  den konkreten Grund (Frist, vorhandener Folgetermin oder Rückstandsmaximum).
- Für Sammeländerung/Undo den gesamten resultierenden Zustand prüfen, nicht
  nur jeden Eintrag isoliert. Keine teilweise Ausführung bei einem Konflikt.
- Prüfung und Schreiben gehören in denselben atomaren Vorgang. UI-Vorschau
  allein schützt nicht gegen zwischenzeitliche Änderungen.
- Die Prüfung gilt für alle Wege zu `pending`; Checkbox-Rücknahme oder direkte
  Repository-Aufrufe dürfen sie nicht umgehen.

Abnahme: Undo vor/nach Fristablauf; Wiederöffnen mit vorhandener Folgeinstanz;
Carryover an/unter Höchstzahl; mehrere zusammen wiedergeöffnete Einträge
überschreiten erst gemeinsam das Maximum; Sperre erzeugt keine Schreibänderung
und nennt den Grund; andere zulässige Korrekturen bleiben erreichbar.

### P16-16 – Bedeutung einer gemeinsamen Erledigt-Korrektur

**Bestätigt am 20. September 2026:** Eine Sammelkorrektur auf „Erledigt“ bzw.
positive Statusantwort bedeutet: jeder ausgewählte Eintrag wurde an seinem
jeweiligen vorgesehenen Tag erledigt. Diese Aussage vor Speichern ausdrücklich
in der Vorschau bestätigen lassen; keine unbemerkte Datumsannahme.

- Beispiel: **„3 Einträge werden als erledigt markiert – jeweils am
  vorgesehenen Tag. Damit gelten sie als rechtzeitig erledigt. Bereits erzeugte
  Folgetermine bleiben unverändert.“**
- Unterschiedliche tatsächliche Durchführungstage oder „alle heute erledigt“
  zunächst einzeln nach P16-06 korrigieren. Kein freies Datumsfeld in der
  Sammelbearbeitung; diese begrenzte fachliche Bedeutung ist Teil der Statusaktion.
- Bei Zielstatus bereits passende Einträge überspringen, ihre fachlichen und
  technischen Zeitangaben unverändert lassen und sie nicht als geändert zählen.
- Ein Werteintrag wird nur durch einen echten Messwert zu `recorded`;
  Status-Sammelkorrekturen dürfen keinen Messwert oder positiven Wertabschluss
  erfinden. Das gilt auch für daraus abgeleitete Bündelergebnisse.
- „Am vorgesehenen Tag“ ist eine Tagesangabe, keine behauptete genaue Uhrzeit.
  Die Speicherung folgt dem technischen Zeitvertrag B.

Abnahme: drei geplante Tage erhalten jeweils ihren eigenen Durchführungstag;
Vorschau erklärt Rechtzeitigkeit; Eingabezeitpunkt bleibt tatsächlicher
Korrekturzeitpunkt; bereits passende Antworten unverändert; keine
Sammelerzeugung von `recorded` ohne Wert; bestehende Folgetermine unverändert.

### P16-17 – Auswahlgrenzen der Sammelkorrektur

**Bestätigt am 20. September 2026:**

- Nur tatsächlich gespeicherte Einträge auswählen. Virtuelle leere Tage bei
  reinem Tracking bleiben unverändert und werden durch eine Sammelkorrektur
  nicht materialisiert. Einzelnes Nachtragen bleibt möglich.
- Vorhandene Messwerte nicht durch Sammelkorrektur entfernen oder umwerten.
  Einträge mit Messwert sind von der Status-Sammeländerung ausgeschlossen;
  einzeln können Werte weiterhin korrigiert oder entfernt werden.
- Vorschau erklärt beide Ausschlüsse, zeigt den tatsächlich veränderbaren
  Umfang und weist ausgeschlossene Messwerteinträge aus. Beispielhinweis:
  **„Leere Tracking-Tage werden nicht verändert.“**
- Keine stille Interpretation einer Tracking-Lücke als gespeicherte Ausnahme,
  kein Erzeugen eines Nullwerts und kein massenhaftes Löschen von Messwerten.
- Zusammen mit P16-16: bereits passende Statuswerte überspringen. Bei null
  tatsächlichen Änderungen weder Daten schreiben noch einen Undo-Vorgang erzeugen.

Beispiel: Ein Monat enthält gespeicherte `no_entry`-Ausnahmen, erfasste Literwerte
und virtuelle leere Tage. Die Sammelkorrektur kann nur fachlich zulässige
gespeicherte Einträge ohne Messwert ändern; Literwerte und virtuelle Tage bleiben
unverändert. Welche Statusziele zulässig sind, richtet sich weiterhin nach der
Erfassungsart (bei reinem Tracking insbesondere kein `failure`).

Abnahme: Filter umfasst keine virtuellen Tage; vorhandene Wertdaten bleiben
unverändert; Ausschlüsse sind vor Speichern sichtbar; Einzelkorrektur bleibt
erreichbar; leere/identische Auswahl schreibt nichts und verdrängt kein Undo.

### P16-18 – Projektstichtage und Vormerkungen begrenzen

**Bestätigt am 20. September 2026:**

- **Ab Datum:** heute oder ein zukünftiger Tag. Zuordnung vor dem Stichtag
  bleibt bestehen. Kein frei wählbarer rückwirkender Stichtag in Release 1;
  rückwirkend ausschließlich die separate Aktion „Gesamte Historie verschieben“.
- Höchstens ein vorgemerkter Projektwechsel pro Aufgabe. Eine neue Vormerkung
  ersetzt die bisherige; vor Speichern alte und neue Vormerkung ausdrücklich
  anzeigen. Vormerkungen können auch abgebrochen werden.
- **Gesamte Historie verschieben:** bisherige Historie und aktuelle Zuordnung
  vollständig dem Zielprojekt zuweisen. Eine vorgemerkte weitere Zuordnung
  wird mit ausdrücklichem Hinweis ebenfalls entfernt, damit kein unerwarteter
  späterer Projektwechsel folgt.
- Beispiel: Wechsel zu Weiterbildung am 01.10. vorgemerkt; neue Auswahl
  Studium ab 05.10. ersetzt ihn. Bis 04.10. gilt die vorher aktuelle Zuordnung.
- Auf allen Zuordnungswegen die tatsächlichen Datumsgrenzen vor Speichern
  erklären und die noch vorgemerkte Änderung anschließend sichtbar halten.

Technische Konsequenz: spätere Vormerkung nicht als aktuell wirksame Projekt-ID
interpretieren. Abbrechen/Ersetzen nur die Projektvormerkung ändern; andere
geplante Rhythmus-/Zieländerungen und deren Zeitpunkte bleiben erhalten.

Abnahme: heute/zukünftiges Datum zulässig, vergangener Einzelstichtag gesperrt;
neue Vormerkung ersetzt alte ohne Zwischenwechsel; Abbruch lässt aktuelle
Zuordnung bestehen; vollständige Verschiebung entfernt die Projektvormerkung
nach Vorschau; keine Nebenwirkung auf andere geplante Definitionsänderungen.

### P16-19 – Bündeländerungen sofort sichtbar machen

**Nutzerfeedback am 20. September 2026:** Der Vorschlag, Bündel erst ab morgen
aufzulösen, wurde wegen der Wartezeit abgelehnt. Nutzende müssen sofort sehen
können, ob die Änderung wie gewünscht funktioniert. Keine verpflichtende
eintägige Wartezeit für Auflösung/Neuanlage vorsehen.

**Pragmatische Planungsregel aus dem Nutzerfeedback vom 20.09.:**
Bündelauflösung wirkt sofort
für den gesamten heutigen Auswertungstag. Frühere Auswertungstage behalten das
alte Bündel. Ein neues Bündel kann mit denselben Einzeltrackings ab heute
erstellt werden; heutige vorhandene Messwerte werden direkt neu ausgewertet.

- Auflösung verändert keine Rohwerte oder Einzeltrackings. Ohne neues Bündel
  erscheinen die Quellen sofort als Einzeltrackings; ein neues Bündel zeigt
  seine Berechnung unmittelbar, soweit die benötigten Werte vorhanden sind.
- Vor Bestätigung erklären, dass die neue Zuordnung für den gesamten heutigen
  Auswertungstag gilt, einschließlich bereits heute erfasster Werte. Kein
  impliziter Wechsel nur ab aktueller Uhrzeit.
- Bei tagesübergreifenden Zeitintervallen bleibt der definierte Bündeltag
  maßgeblich; Quellen können weiterhin einen Wert vom Vortag verwenden.
- Fehlt durch den Wechsel einer der beiden Werte, zeigt die Auswertung das
  Bündel einfach als unvollständig bzw. nicht berechenbar. Dies verhindert
  weder Auflösung noch Neuanlage. Keine erfundenen Ersatzwerte, erzwungenen
  Nachträge oder zusätzlichen Übergangsassistenten.
- Ein heute neu erstelltes und sofort wieder aufgelöstes Bündel darf keinen
  künstlichen historischen Gültigkeitstag oder eine Quellenblockade erhalten.
- Bisherige rückwirkende Bündelerstellung nicht stillschweigend abschaffen;
  neue Zuordnungen dürfen bestehende historische Bündelintervalle derselben
  Quellen nicht überlagern. Intervallprüfung und Historienzugriff gemeinsam
  entwerfen, nicht nur nach dem globalen `isActive`-Flag prüfen.

Technischer Prüfpunkt: `dissolveValueBundle` erzwingt aktuell bei Auflösung am
Erstellungstag eine Mindestlaufzeit von einem Tag; die Datenbank verlangt
`validTo > validFrom`. Der Fall ohne historischen Gültigkeitstag braucht deshalb
eine ausdrücklich geplante Repräsentation statt einer vorgetäuschten Laufzeit.
Die Morgen-Regel für Rhythmus/Missed Policy wird durch dieses Nutzerfeedback
nicht automatisch geändert.

### P16-20 – Unvollständige Bündel und einzelnes Entfernen

**Nutzerentscheidung am 20. September 2026:** Unvollständige Bündel nach einer
Änderung sind ein zulässiger Zustand und werden in der Auswertung entsprechend
angezeigt. Bei Bedarf kann der Nutzer einen einzelnen Tracking-Eintrag entfernen.

- Bündel besitzen keine eigenen Rohwerteinträge. Entfernen betrifft den
  gewählten Einzelwert im Teiltracking; keine automatische Entfernung des
  anderen Werts, der gesamten Aufgabe oder aller Bündeldaten.
- Der entfernte Wert geht nicht mehr in die aktuelle Berechnung ein. Fehlt
  dadurch eine Quelle, bleibt das Ergebnis unvollständig, nicht null.
- Einzelnes Entfernen in die Korrektur-/Undo-Grundlage aus P16-08 integrieren;
  keine neue Massenlöschfunktion aus diesem Wunsch ableiten.
- Ein vorhandener geplanter Pflichttermin und ein erfasster Messwert sind
  technisch zu unterscheiden: Entfernen eines Werts darf keine andere
  Verpflichtung löschen oder die Eintragszahl unbeabsichtigt verfälschen.
- Die ältere pauschale Aussage E-38 „einzelne Instanzen nicht löschbar“ darf
  nicht als Sperre gegen das hier ausdrücklich gewünschte Entfernen einzelner
  Tracking-Eingaben verwendet werden. Endgültige Löschung ganzer Aufgaben und
  Papierkorb bleiben Phase 17.

Abnahme: Bündelwechsel trotz fehlendem Teilwert möglich; unvollständiges
Ergebnis verständlich angezeigt; einzelnen Wert entfernen und rückgängig
machen; anderer Teilwert bleibt erhalten; keine automatische Datenergänzung.

## Geplanter Ablauf

| Schritt | Inhalt | Status |
|---:|---|---|
| 16.1 | Beispiele für reale Änderungen sammeln | Konkrete Beispiele in P16-04 bis P16-20 vorhanden. |
| 16.2 | Namens-, Rhythmus-, Ziel- und Projektwechsel durchspielen | Fachregeln und technischer Vertrag festgelegt. |
| 16.3 | Darstellung alter Einträge und Versionen klären | Fachregeln und betroffene Lesewege festgelegt. |
| 16.4 | Projektversionierung prüfen | Keine Historisierung von Projekttexten/Farben; zeitliche Zuordnung mit zwei Wechseloptionen beschlossen. |
| 16.5 | Bearbeitungsgrenzen und Warnhinweise festlegen | Sperren, Kopie und sichtbare Wirksamkeit festgelegt. |
| 16.6 | Nachträgliche Einzel- und Sammelkorrekturen von Antworten planen | Umfang, Vorschau, Undo und Datenvertrag festgelegt. |
| 16.7 | Umsetzungslücken und Tests ableiten | Pakete 16a–16f und Abnahme unten; Implementierung/Tests erfolgen im Umsetzungschat. |

## Technischer Umsetzungsvertrag

Stand 20.09.2026. Die folgenden Festlegungen sind aus den bestätigten Regeln
abgeleitete Implementierungsvorgaben, keine zusätzlich interviewpflichtigen
Produktentscheidungen. Sie schließen die technischen Prüfvermerke der
P16-Abschnitte. Bei Widerspruch haben die späteren bestätigten Entscheidungen
Vorrang. Keine weiteren Detailfreigaben für Dateinamen, Helper oder Layout nötig.

### A. Definitionen, Vormerkungen und historische Leser

- Bestehende vollständige Definitionssnapshots und Versions-IDs erhalten.
  Einträge lesen ihre Fachregeln über ihre gespeicherte Version; virtuelle oder
  noch nicht erzeugte Tage über die an diesem Tag gültige Definition.
- Einen gemeinsamen `TaskDefinitionResolver` einführen: Auflösung nach
  `validFrom`, bei Gleichstand nach Versionsnummer. Niemals ungefiltert die
  höchste Versionsnummer als aktuell wirksam ansehen. Fehlende historische
  Version nicht durch eine beliebige heutige Definition ersetzen; stattdessen
  einen erklärbaren Datenzustand liefern und die Migration dafür prüfen.
- Neue Vormerkungen getrennt von bereits wirksamen Snapshots speichern:
  `TaskPendingDefinitionChanges` mit UUID, taskId, Gruppe (`schedule`/`goal`),
  lokalem Wirksamkeitstag, typisiert validiertem versioniertem Payload,
  createdAt/updatedAt und Zustand (`pending`/`applied`/`cancelled`).
  Payload enthält ausschließlich Felder der Gruppe, keine komplette Kopie.
- Höchstens eine offene Vormerkung je Gruppe und Aufgabe. Erneutes Bearbeiten
  derselben Gruppe ersetzt deren vorgemerkten Inhalt mit sichtbarer Erklärung;
  anderer Gruppeninhalt bleibt erhalten. Speichern ohne wirksame Änderung ist
  ein No-op und löscht keine bereits vorhandene Vormerkung.
- Rhythmus, Wochentage und Missed-/Puffer-/Carryover-Regeln bilden `schedule`
  und gelten ab morgen. Reine Zieländerungen behalten die vorhandene Wahl
  sofort/nächster Zielblock. Bei gemeinsamer Änderung von Ziel und Planung
  beide ab morgen vormerken; betroffenen Ziel-Mischblock wie bisher nicht werten
  und dies vor Speichern anzeigen. Keine zusätzliche Auswahloberfläche bauen.
- Name/Beschreibung/Fragetext gelten für die aktuelle Aufgabe sofort. Ein
  bereits vorhandener heutiger oder älterer Eintrag behält seinen Snapshot;
  bei Bedarf dessen damaligen Text im Eintragsdetail zeigen. Die aktuelle
  Aufgabenüberschrift darf den neuen Namen zeigen, ohne die Antwort umzudeuten.
- Fällige Vormerkungen chronologisch, gruppenweise zusammengeführt und atomar
  anwenden: aktuelle wirksame Definition plus Payloads ergibt einen neuen
  Snapshot; `validFrom` ist der geplante Tag, nicht der spätere App-Start.
  `applied`-Markierung und Versionsanlage gemeinsam schreiben. Wiederholung
  darf keine zusätzliche Version erzeugen. Den Übergang vor der fachlichen
  Nachplanung abgleichen. Zukunftsvorschauen berechnen dieselben Patches rein
  lesend, ohne Versionen oder Instanzen zur bloßen Anzeige zu erzeugen.
- Scheduler, Listen, Details, Ziele, Karten und virtuelle Tracking-Lücken
  müssen denselben Resolver nutzen. Bestehende offene Altinstanzen verarbeiten
  ihre eigene Policy. Carryover-Maximum pro historischer Policy-/Maximum-Gruppe
  prüfen; eine kleinere neue Grenze darf alte Regeln nicht rückwirkend ändern.
- Wechsel zu einem abschlussgebundenen Rhythmus erzeugt keine zusätzliche
  offene Instanz, solange noch ein blockierender Alt-Eintrag besteht. Für
  Folgeplanung bestehende spätere Instanzen respektieren; nur hinter dem
  letzten bestehenden Eintrag weiterplanen, keine korrigierten Zwischenräume
  mit neuen Folgeterminen auffüllen. `no_entry` bleibt bei diesem Rhythmus
  blockierend und benötigt dieselben Schutzprüfungen wie Wiederöffnen.
- Falls alte Codepfade bereits zukünftige Zeilen angelegt haben: leere,
  unbeantwortete Reservierungen ohne Wert/Notiz dürfen bei geänderter Planung
  abgeglichen werden; fachlich unveränderte behalten ihre ID. Sobald echte
  Eingaben betroffen wären, Änderung mit konkretem Hinweis sperren statt Daten
  zu löschen. Keine reguläre Voraberzeugung von Zukunftseinträgen hinzufügen.

Betroffene Stellen: `task_definition_version_writer.dart`,
`task_instance_scheduler.dart`, `AufgabenRepository.updateTask`,
`scheduleTaskGoalChangeForNextBlock`, `_definitionVersionIdForEntry`,
`watchTaskListForDate`, `watchTasksByUrgency`, `_taskForDateById`,
`_isTaskVisibleOnDate`, Wert-/Zielauswertungen und `TaskForDate`.
Nur tatsächliche Änderungen an Zielfeldern dürfen einen Ziel-Mischblock
auslösen; eine bloße neue Snapshot-ID oder Umbenennung genügt nicht.

### B. Eintragsidentität und Zeitangaben

- Bestehende Eintrags-IDs bleiben stabil. Neue IDs als UUID erzeugen;
  Eindeutigkeit weiterhin über `(taskId, scheduledDate)`. Alle Aufrufe, die
  `_entryId(taskId, date)` als Suchschlüssel oder Bundle-Map-Key voraussetzen,
  auf Suche nach ID bzw. fachlichem Aufgaben-/Tagespaar umstellen.
  Kein flächiges Neuschreiben alter IDs und Fremdschlüssel.
- Für einmaliges Verschieben dieselbe Zeile einschließlich Wert-/Notizbezügen
  verwenden. `originalScheduledDate` beim ersten Verschieben sichern; aktuellen
  `scheduledDate`, dueDate und passenden Definitionsbezug gemeinsam ändern.
  Das ist der explizite Reschedule-Vorgang, keine allgemeine Umhängung historischer
  Antworten. Eine einmalige Aufgabe ohne Fälligkeit bleibt über dieselbe
  Eintrags-ID erreichbar, auch wenn deren ursprünglicher Tagesanker alt ist.
- Fälligkeit hinzufügen/entfernen nur bei offener einmaliger Aufgabe erlauben.
  Entfernen löscht keinen Eintrag; ohne Fälligkeit gibt es keine automatische
  Fristkonsequenz. Bei Hinzufügen heute/Zukunft wählen. Beim Speichern zuerst
  fachlich fällige Automatiken abgleichen, damit ein eigentlich schon
  automatisch abgeschlossener Eintrag nicht als offener Termin umgangen wird.
- `performedOn` als nullable lokalen Kalendertag ergänzen, zusätzlich
  `performedOnSource` (`user`/`legacy_unknown`). Neue positive manuelle Antworten
  und Wertaufzeichnungen erhalten den bestätigten Durchführungstag; heutige
  normale Erfassung setzt heute. Nachträge nutzen P16-06/P16-16.
  Keine zukünftigen Durchführungstage oder Tage vor Aufgabenstart zulassen.
- `respondedAt`: technische letzte Antwortinteraktion; `updatedAt`: technische
  letzte Änderung; `finalizedAt`: technische Speicherung des Abschlusses;
  `effectiveAt`: fachliche Wirksamkeit für die Folgeplanung. Bei taggenauer
  Durchführung ein Tagesanker, keine als bekannt dargestellte Uhrzeit.
  Uhrzeit-Messwert und Durchführungstag sind unterschiedliche Daten.
- Bereits abgeschlossene Antworten bei bloßer Statuskorrektur ohne neue
  Durchführung zeitlich erhalten. Neuer manueller Misserfolgsabschluss aus
  offen/`no_entry` wirkt zum Korrekturtag; nicht als fiktive Durchführung
  darstellen. Automatische Konsequenzen behalten ihre regelbasierte Wirksamkeit.
- Rechtzeitigkeit nutzt `performedOn` und die Frist der Eintragsversion.
  Altdaten erhalten keine erfundene Durchführung; vorhandene Zeitwerte als
  bisherige Näherung nutzen und bei betreffenden Details als Altdaten kenntlich
  machen. Nach manueller Bestätigung ist der Durchführungstag eindeutig.
- Datumshilfen für lokale Kalendertage verwenden; nächster Tag über
  `DateTime(year, month, day + 1)`, nicht über eine angenommene 24-Stunden-Dauer.
  `now` für Services/Scheduler injizierbar machen, damit Stichtage testbar sind.

### C. Korrekturen, Entfernen und Undo

- Einen `TaskEntryCorrectionService` für UI und Repository verwenden, mit
  typisierten Befehlen für Antwort, Einzelwert, Notiz, Wertentfernung und
  Wiederöffnen. Bestehende Setter leiten dorthin weiter; keine zweite
  Validierung ausschließlich im Screen.
- Erst tatsächliche zeitabhängige Zustände abgleichen, dann Vorschau erzeugen.
  Vorschau enthält konkrete IDs, erwartete Zustände und tatsächliche Änderungen.
  Beim Bestätigen den erwarteten Stand atomar erneut prüfen. Bei zwischenzeitlicher
  Änderung nichts teilweise schreiben, sondern neue Vorschau anbieten.

| Erfassungsart | Zulässige Korrektur |
|---|---|
| Checkbox | success, failure, begründetes no_entry; pending nur mit Schutzprüfung. |
| Ja/Nein | Rohantwort zur damaligen Erfolgsrichtung auswerten; begründetes no_entry; pending nur mit Schutzprüfung. |
| Reines Wert-Tracking | Einzelwert speichern/korrigieren/entfernen, begründetes no_entry; niemals failure oder success statt eines Messwerts. |
| Verbindliche Wert-Eingabe | Einzelwert ergibt recorded; failure/no_entry möglich; pending nur mit Schutzprüfung. |
| Bündel | Keine eigene Rohantwort ändern; Korrektur am jeweiligen Teiltracking. |

- Wertentfernung ist eine explizite Einzelaktion. Aktiven Payload entfernen
  (einschließlich altem `numberValue`-Spiegel); vorherigen Payload im Undo sichern.
  Pflichtinstanz erhalten: pending, wenn zulässig, sonst ausdrückliches manuelles
  no_entry. Reines Tracking als gespeichertes no_entry ohne Messwert führen;
  damit bleiben Notiz und Undo-Bezug erhalten. Nicht als Null auswerten.
  Dialog beschreibt den resultierenden Zustand. Keine Pflichtinstanz aus der
  Grundgesamtheit löschen und keine Laufzeit-Neuanlage durch den Scheduler.
- `no_entry` erfordert weiterhin eine Begründung; eine Sammelaktion kann eine
  gemeinsame Begründung erfassen, ohne bestehende Notizen zu überschreiben.
  Begründung als Korrekturmetadatum speichern. Für neue negative Antworten
  keine Durchführung erfinden. Status-Sammelaktion enthält keine Wertpayloads.
- Datenmodell: `TaskCorrectionOperations` (UUID, taskId, Typ, createdAt,
  Zustand applied/undone, Payload-Version) und `TaskCorrectionItems`
  (operationId, entryId, vollständiger Vorher-/Nachher-Zustand der veränderten
  Fachfelder und Wertdaten, erwartete Revision). Notizen und Nullwerte erhalten.
- `revision` an Einträgen ergänzen; jede tatsächliche Mutation einschließlich
  Scheduler, Notiz und Undo erhöht sie. Damit blockiert auch Ändern-und-zurück
  ein veraltetes Undo. Alle Schreiber müssen dieselbe Konvention verwenden.
- Letzte tatsächlich angewendete Korrektur pro Aufgabe ist undo-fähig; ältere
  werden nicht nach Verbrauch des letzten Undo wieder aktiv. Kein Redo.
  Erste reguläre Eingaben brauchen keinen zusätzlichen Korrekturverlauf;
  Nachtrag zu vorhandener automatischer Antwort ist eine Korrektur.
- Undo prüft alle Revisionen und die Schutzregeln, stellt Vorher-Fachzustände
  atomar wieder her und setzt technische Änderungszeit/Revision neu. Kein
  erneuter Undo-Eintrag für Undo. Neue Daten nach der Vorschau nie überschreiben.
- Korrekturdatensätze zunächst behalten; durch Fremdschlüssel der Aufgabe
  zuordnen. Phase 17 übernimmt sie bei endgültiger Löschung, Phase 19 klärt
  Cloud-Aufbewahrung. Keine eigene sichtbare Audit-Oberfläche erforderlich.
- Projektkorrektur „gesamte Historie“ kann denselben letzten Korrekturplatz mit
  projektspezifischem Payload verwenden; keine allgemeinen JSON-Patches für
  beliebige Datenbanktabellen bauen. Späterer Projektwechsel verhindert altes
  Projekt-Undo. Antworten sind davon unabhängig und werden nicht mitkopiert.

### D. Projektzuordnung ohne Umdeutung alter Definitionen

- Eigene `TaskProjectAssignmentChanges` als kleiner fachlicher Verlauf:
  UUID, taskId, Zielprojekt nullable, scope (`from_date`/`all_history`),
  Wirksamkeitstag, Sequenz je Aufgabe, createdAt/updatedAt und Zustand
  pending/applied/cancelled/undone. Nullable Ziel bedeutet „ohne Projekt“.
- Ein zentraler Resolver startet bei Altinstanzen mit der Projekt-ID ihres
  Snapshots, bei virtuellen Tagen mit der gültigen Definition. Darauf werden
  Zuordnungskorrekturen in gespeicherter Sequenz angewendet: `from_date` nur
  ab Stichtag, `all_history` für alle Tage. Das erhält alte Snapshots, erlaubt
  aber die ausdrücklich gewünschte rückwirkende Korrektur.
- Ein heutiger Wechsel gilt für den ganzen heutigen Instanztag, ein zukünftiger
  bleibt Vormerkung. Neue Wechsel ersetzen eine offene Projektvormerkung mit
  Hinweis. Angewendete frühere Zuordnungen bleiben im Verlauf. Standard im
  Datumsfeld heute. Historienverschiebung entfernt eine offene Vormerkung.
- Die aktuelle Aufgabenzeile darf als Cache der heutigen Zuordnung dienen,
  ist aber keine Quelle historischer Projektstatistik. Aufgabenlisten nach
  heutiger Zugehörigkeit, historische Eintragszahlen nach Instanztag zuordnen.
- Beide Repository-Schreibwege auf denselben Service umstellen. Bei mehreren
  ausgewählten Aufgaben in der Projektbearbeitung denselben klar erklärten
  Modus verwenden; alle Änderungen transaktional ausführen.
- Projekt-ID in Aufgaben-Snapshots bleibt für Altdaten und Nachvollziehbarkeit
  bestehen, neue Zuordnungskorrekturen niemals durch Umschreiben dieser Zeilen.
  Fehlendes Projekt mit „Projekt nicht mehr vorhanden“ anzeigen statt einen
  gleichnamigen Ersatz zu erfinden. Keine neue Projekt-Löschfunktion in Phase 16.

### E. Bündel und sichere historische Auswertung

- Bündelintervalle als `[validFrom, validTo)` nach Bündeltag behandeln.
  Historische Abfragen allein nach Intervall, nicht globalem Aktiv-Flag filtern.
  Bei Auflösung heute endet ein älteres Bündel exklusiv heute; seine bisherigen
  Tage bleiben sichtbar. Rohwerte der Quellen unverändert lassen.
- Für am selben Tag erstellte/aufgelöste Bündel `cancelledAt` an der Version
  ergänzen: keine künstliche Laufzeit, cancelled-Version gilt an keinem Tag.
  So kann die vorhandene Bedingung `validTo > validFrom` bestehen bleiben.
- Quellenbelegung anhand überschneidender gültiger Intervalle prüfen, auch bei
  rückwirkender Erstellung. Nicht allein den Starttag oder `isActive` prüfen.
  Bei Überschneidung kurze Erklärung mit Datum; keine automatische Aufteilung.
- Berechnungsfelder einschließlich Tagesversatz bleiben gesperrt. Bündelname
  und Beschreibung können als Metadaten bearbeitet werden; vergangene
  gespeicherte Versionen erhalten. Neue Bündelziel-Bearbeitungsoberfläche ist
  kein zusätzliches Phase-16-Paket; vorhandene Zielauswertung weiterverwenden.
- Vorhandene Werte am heutigen Tag direkt auswerten; fehlt eine Quelle,
  „Unvollständig“/„nicht berechenbar“, niemals Ersatznull. Entfernen und Undo
  eines Teilwerts müssen auch historische Bündel- und Kartenwerte aktualisieren.
- Bei historischen Wertdaten pro Eintrag Typ und Einheit prüfen. Der Schutz
  aus Phase 15 muss auch in Details/Zielen gelten: bei inkompatiblen Altdaten
  keine Mischsumme und keine unbemerkte Teilmenge. Rohwerte mit ihrer damaligen
  Einheit anzeigen; Aggregat mit kurzer Erklärung nicht verfügbar.
  Die bewusst verschobene allgemeine Einheitenkonvertierung nicht vorziehen.
- Vorhandene Summaries/Berechnungsfunktionen wiederverwenden. Keine dauerhaft
  gespeicherten Statistikstände; Streams lesen auch Definitions-, Zuordnungs-,
  Korrektur- und Bündeländerungen als Abhängigkeiten. Historische Zielblöcke
  werden nach tatsächlicher Korrektur neu berechnet, nicht als alte Zahl eingefroren.

### F. Schema und Migration

- Ausgangspunkt des geprüften Codes: Schema 18. Nächste freie Version wählen
  (19, falls bis zur Umsetzung unverändert), in einem nachvollziehbaren
  Migrationspaket; keinen laufenden fremden Schemawechsel überschreiben.
- Ergänzungen: PendingDefinitionChanges, ProjectAssignmentChanges,
  CorrectionOperations/Items; Entry-Felder revision (Default 0), performedOn,
  performedOnSource, originalScheduledDate; BundleVersion.cancelledAt.
  `supersededAt` an Definitionsversionen nur für ersetzte bisherige zukünftige
  Ziel-Snapshots vorsehen, damit ihre IDs bei der Migration erhalten bleiben.
- Bereits zukünftige reine Zielversionen in Zielvormerkungen übertragen,
  Originalsnapshot erhalten und von zeitbasierter aktiver Auflösung ausnehmen.
  Bei mehreren alten Vormerkungen den zuletzt gespeicherten Zielwunsch als
  offene Vormerkung übernehmen; vorhandene referenzierte IDs bleiben lesbar.
  Bereits wirksame Snapshots nicht nachträglich als unbekannte Patches behandeln.
- Keine Historie aus fehlenden Daten erfinden. Bestehende Eintrags-/Wert-IDs,
  Zeiten, Status und Versionsreferenzen erhalten. Neue Tabellen zunächst leer,
  soweit keine echte bestehende Vormerkung überführt werden muss.
- Neue DB und Upgrade von Schema 18 mit Antworten, Wertdaten, geplanten Zielen,
  Projekten und aufgelösten Bündeln prüfen. Vorhandene frühe Migrationsfälle
  weiterlaufen lassen; generierten Drift-Code ausschließlich generieren.

## Umgesetzte Pakete

Die Paketgrenzen dienten als Checkpoints der Umsetzung. Dateien unten sind
relativ zum Repository.

| Paket | Inhalt / zentrale Dateien | Ergebnis | Status |
|---|---|---|---|
| 16a – Datenverträge | Schema/Tabellen unter `lib/core/database/` und `lib/features/aufgaben/data/`; Resolver und Migration | Schema 19, getrennte Vormerkungen, Zuordnungs- und Korrekturtabellen sowie deterministische historische Auflösung. Bestehende IDs und Rohdaten bleiben erhalten. | abgeschlossen |
| 16b – Planung und Bearbeitung | VersionWriter, Scheduler, Repository, `TaskForDate`, `task_edit_screen.dart`, `aufgabe_hinzufuegen_screen.dart` | Planungsregeln wirken ab morgen, Ziele gruppiert bzw. vorgemerkt, Textänderungen sofort; feste Messkonfiguration, Kopiervorlage und stabile einmalige Einträge umgesetzt. | abgeschlossen |
| 16c – Korrekturen | CorrectionService, Entry-Setter, `task_entry_corrections_screen.dart`, Detail- und Eingabeansichten | Einzel-/Sammelkorrektur, Wertentfernung, Durchführungstag, Revisionen und persistentes einfaches Undo sind transaktional umgesetzt. | abgeschlossen |
| 16d – Projekte | AssignmentService, Aufgaben- und Projekt-Repository, Projektwahl in der Bearbeitung | Stichtagswechsel, Wechsel der gesamten Historie und Undo verwenden eine getrennte Zuordnungshistorie; historische Ansichten lösen den jeweiligen Tag auf. | abgeschlossen |
| 16e – Historische Auswertung/Bündel | Repository-Queries, Summaries, Detail-/Bündelseiten, Karten-Abhängigkeiten | Bündel verwenden Gültigkeitsintervalle und bleiben historisch auswertbar; Auflösung am selben Tag ist sichtbar; inkompatible Wertdefinitionen erzeugen keine Mischstatistik. | abgeschlossen |
| 16f – Abschluss | Codegenerierung, Format, Analyse, Regressionssuite und Dokumentation | Drift-Code generiert; 117 Aufgaben-/Projekt-Tests bestanden; vollständiges `flutter analyze` ohne Befund. Manueller Geräteablauf bleibt eine zusätzliche Praxisprüfung. | abgeschlossen |

### Mindestprüfungen

1. Definition morgen ändern, App mehrere Tage nicht öffnen, nachplanen:
   richtige Version je Tag, alter Puffer unverändert, Wiederholung ohne Writes.
   Daneben Ziel für nächsten Block vormerken und heute umbenennen: nichts geht verloren.
2. Aufgabenstart/Art/Messkonfiguration in UI und Repository gesperrt; Kopie
   abbrechen bzw. speichern: eigene ID, keine Historie/Bündelübernahme,
   ursprüngliche Aufgabe unverändert, unpassendes Wertziel zurückgesetzt.
3. Einmaligen offenen Termin verschieben/entfernen/neu setzen: stabile ID,
   keine zweite Instanz, Notiz erhalten, geschlossener Termin nicht verschiebbar.
4. Nachtrag Montag versus Durchführung Donnerstag, Puffergrenze und Sommerzeit:
   Rechtzeitigkeit richtig, Kalenderdatum erhalten, Folgetermin eingefroren.
5. Statusmatrix einschließlich value/pure/required; virtuelle Tage und echte
   Werte aus Sammelauswahl ausgeschlossen; No-op verändert Revision/Undo nicht.
6. Sammelkorrektur mit mehreren Einträgen und Neustart-Undo; Notiz-/Scheduler-
   Änderung danach blockiert Undo vollständig. Wiederöffnung gegen Frist,
   Carryover-Grenze und vorhandenen Folgetermin prüfen, einschließlich no_entry
   als blockierendem Zustand bei abschlussgebundenem Rhythmus.
7. Projektstichtag, Ersatz/Abbruch einer Vormerkung, gesamte Historie mit früheren
   Drittprojekten, Projekt-Undo; Aufgabenregeln/Antworten unverändert.
8. Bündel heute erstellen/auflösen/neuerstellen; altes Bündel auswerten;
   tagesübergreifende Quellen, fehlender Teilwert, Einzelwert entfernen/Undo;
   keine Intervallüberschneidung oder doppelte Quellenbelegung.
9. Bestehende Mischdaten verschiedener Einheiten sowie geplante Ziel-Altdaten
   migrieren: weder Datenverlust noch falsche Aggregation. Karten-/Detailwerte
   aktualisieren sich nach Korrektur ohne Neustart.

Tests möglichst in bestehenden Dateien ergänzen:
`test/features/aufgaben/data/aufgaben_repository_test.dart`,
`task_value_foundation_test.dart`, `task_card_metric_preference_test.dart` sowie
`test/features/projekte/data/project_repository_test.dart`. Neue reine
Service-/Migrationstests getrennt halten, wenn das verständlicher ist.
Wenige Widgettests für Speichern/Abbruch, sichtbares Wirksamkeitsdatum und
Korrekturvorschau; keine Tests für jede Beschriftung.

Nach der Schemaänderung wurde Drift neu generiert. Die betroffenen Dart-Dateien
wurden formatiert und analysiert. Zum Abschluss bestanden
`flutter test --no-pub test/features/aufgaben test/features/projekte` mit 117
Tests sowie `flutter analyze` ohne Befund.

### Kurzer manueller Abnahmelauf

Eine Statusaufgabe, ein freiwilliges und ein verbindliches Wert-Tracking sowie
ein Schlafbündel anlegen. Kopieren, Morgen-Regel und Zielvormerkung kombinieren,
eine Antwort nachtragen, mehrere Status korrigieren, App neu öffnen und Undo
ausführen. Projektwechsel mit Datum und gesamter Historie prüfen. Bündel heute
auflösen/neuerstellen, einen Teilwert entfernen: Ergebnis sofort unvollständig.
Bei jedem Schritt sind Datum, Wirkung und Sperrgrund ohne technisches Wissen
erkennbar; alte Rohwerte bleiben außer bei ausdrücklicher Korrektur unverändert.

## Abschluss und bewusste Grenzen

- Die Pakete 16a–16f sind abgeschlossen. Der technische Stand wurde durch
  Codegenerierung, automatisierte Tests und statische Analyse geprüft.
- Der kurze manuelle Abnahmelauf oben bleibt für den nächsten Gerätetest
  empfohlen; er ändert den fachlichen Abschluss der Phase nicht.
- Später: kompatible Einheitenwechsel, freie rückwirkende Projektstichtage,
  mehrere Vormerkungen derselben Gruppe, wechselnde Bündelquellen innerhalb
  derselben ID, mehrstufiges Undo, ausführliche sichtbare Änderungshistorie.
- Phase 17: Papierkorb und endgültige Löschung einschließlich neuer
  Korrektur-/Zuordnungsdaten; nicht stillschweigend mit Umsetzung von Phase 16 starten.
- Phase 18: Ausbau der Projektauswertung auf dem hier festgelegten
  historischen Zuordnungsvertrag. Phase 19: echte Sync-Konflikte/Cloud-Kosten,
  Aufbewahrung und Löschabgleich. Jetzt stabile IDs und echte Änderungsrevisionen,
  aber kein vorgezogenes Cloud-System.
- Vor Umsetzung `git status` und Schema erneut prüfen: Workspace enthält
  umfangreiche bestehende Änderungen und unversionierte Dateien. Nichts
  zurücksetzen oder als ausschließlich eigene Änderung behandeln.
