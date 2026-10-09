# Momentum – Phase 19: Firebase-Synchronisierung vorbereiten

Stand: 8. Oktober 2026  
Status: Abgeschlossen; lokale Sync-Vorbereitung umgesetzt und geprüft

## Abschlussstand vom 8. Oktober 2026

Die begrenzte lokale Vorbereitung aus T19-01 bis T19-05 ist umgesetzt. Die
bewusst spätere echte Synchronisierung aus T19-06 bleibt weiterhin offen.

- Schema 22 ergänzt nullable `updatedAt`-Zeitpunkte an Aufgaben und
  Bündelversionen sowie `isReset` an Kartenpräferenzen. Altbestände erhalten
  keine erfundenen Änderungszeitpunkte; bestehende Präferenzen werden als
  nicht zurückgesetzt übernommen.
- Echte Aufgaben-, Definitions-, Zuordnungs- und Lebenszyklusänderungen führen
  die passenden Zeitpunkte mit. Identische Stammwerte, bereits angewandte
  Vormerkungen und unveränderte Zuordnungen erzeugen keine erneuten Writes.
- Bündelversionen werden bei Erstellung, Textänderung, Intervallende und
  Aufhebung gestempelt. Eine bereits vollzogene Auflösung ist idempotent.
- Projekt-Neusortierung validiert alle übergebenen IDs vor dem ersten Write,
  weist doppelte, unbekannte und nicht aktive Projekte atomar ab und verändert
  nur Positionen, die sich tatsächlich verschieben.
- Karten-Reset bleibt als `isReset=true` mit leerem reserviertem Payload und
  Zeitpunkt erhalten. Wiederholter Reset ist ein No-op; explizites Ausblenden
  bleibt vom Standard unterscheidbar. Schreibschutz und Cascade-Purge gelten
  unverändert.
- Keine Firebase-Abhängigkeit, Kontopflicht, Outbox, Konfliktkopie,
  Cloud-Übertragung oder Konfliktoberfläche wurde vorgezogen.

Abschlussprüfung: Drift-Code generiert, vollständige statische Analyse ohne
Befund und vollständiger Flutter-Testlauf mit **142 bestandenen Tests**. Die
Schema-19-/20-Fixtures migrieren nach Schema 22 mit leerem
`PRAGMA foreign_key_check`. Ein zusätzlicher manueller Gerätetest wurde in
diesem Umsetzungslauf nicht durchgeführt; die Kartenbedienung selbst blieb
unverändert und ihr Auswahl-/Reset-Vertrag ist automatisiert geprüft.

## E19-10 – Bestätigter Zuschnitt nach Vereinfachung

Am 7. Oktober 2026 hinterfragt der Nutzer ausdrücklich, ob die Behandlung
seltener Mehrgeräte-Sonderfälle den Nutzen übersteigt und unnötige Kosten,
Laufzeit oder Entwicklungsaufwand verursacht. Die folgenden Vereinfachungen
sind **am 7. Oktober 2026 bestätigt**. E19-02 und E19-06 wurden entsprechend
ersetzt; die frühere verpflichtende Konfliktentscheidung und Auswertungssperre
sind nicht mehr umzusetzen.

- Lokale Aktionen bleiben sofort und ohne Internet nutzbar. Zusätzliche
  Metadaten nur bei echten gespeicherten Änderungen erfassen, nicht bei jedem
  Tastendruck, Lesen oder Ansichtswechsel.
- Späterer Sync gleicht Änderungen ab, nicht bei jeder Nutzung die gesamte
  Historie. Ein Erstabgleich oder eine notwendige Reparatur ist davon getrennt.
- Bei widersprüchlichen normalen Eingaben automatisch eine nach festgelegter
  Regel neuere Variante verwenden, den Konflikt kennzeichnen und die andere
  Variante zur optionalen Auswahl erhalten. Keine verpflichtende sofortige
  Entscheidung und keine pauschale Sperre abhängiger Auswertungen. Betroffene
  Ergebnisse werden mit der ausgewählten Variante berechnet und als noch
  konfliktbehaftet gekennzeichnet. Die gültigen Regeln stehen in E19-02/E19-06.
- Eine solche automatische Auswahl vereinfacht die Bedienung, ersetzt aber
  nicht den Nachweis konkurrierender Änderungen. Die Reihenfolge darf nicht
  versehentlich durch die spätere Übertragung einer alten Offline-Eingabe
  bestimmt werden. Die konkrete Regel bleibt technisch festzulegen.
- Löschung/Wiederherstellung sind wegen ihrer Folgen gesondert zu behandeln;
  aus dieser Vereinfachung folgt keine Erlaubnis zur automatischen Wiederbelebung
  endgültig gelöschter Daten. E19-11 klärt den Vorrang auch gegenüber einer
  Offline-Wiederherstellung; kein weiteres Sonderfallsystem dafür entwickeln.

**Bestätigte Grenze für Phase 19:** Identitäten/Referenzen, Zeitsemantik,
Erkennbarkeit echter Änderungen und Löschungen sowie die notwendigen lokalen
Anschlussstellen absichern. Kein vollständiger Sync-Motor, keine Cloud-Dienste,
keine Konfliktoberfläche und kein vorgezogener Umbau sämtlicher Auswertungen.
Die folgenden Entscheidungen beschreiben überwiegend das spätere Zielbild;
sie sind keine kumulative Implementierungsliste für Phase 19.

**Leistungseinordnung:** Zusätzliche Metadaten verursachen zusätzliche lokale
Arbeit und später Datenvolumen. Im Bestand gibt es bereits Revisionen,
Zeitstempel und Korrekturdaten. Noch wurde keine Laufzeitmessung durchgeführt;
keine Zusage über vernachlässigbare Kosten oder unveränderte Geschwindigkeit
ableiten. Gezielt begrenzte Änderungen und Hintergrundabgleich sind die
Planungsrichtung. Vollständige Historienvergleiche pro Bedienaktion und
unnötige zusätzliche Cloud-Zugriffe vermeiden.

## Planungsauftrag und Arbeitsweise

Diese Phase wird in einem eigenen Planungschat für die spätere Umsetzung in
einem anderen Chat ausgearbeitet. In diesem Chat werden ausschließlich
Dokumente bearbeitet, keine App-Funktionen oder Migrationen implementiert.

- Bestehenden Code und Dokumentation als Grundlage prüfen; technische Fakten
  nachschlagen statt sie beim Nutzer abzufragen.
- Grundlegende Produktentscheidungen einzeln mit Empfehlung klären. Leicht
  änderbare Details als kleines Vorschlagspaket bündeln.
- Bestätigte Entscheidungen, Vorschläge und offene Fragen klar unterscheiden.
- Aufwand und Codex-Kontingent beachten: vor intensiven Zusatzanalysen mit dem
  Nutzer deren Notwendigkeit klären; keine vorsorgliche Komplettarchitektur.
- Den fertigen Plan um konkrete Umsetzungspakete, betroffene Codebereiche,
  Migrationsregeln, Abnahmekriterien und eine Startanweisung ergänzen.
- Spätere Erweiterungen durch klare Anschlussstellen ermöglichen; deren
  vollständige Umsetzung gehört nicht automatisch zu Phase 19.

## Erste Bestandsaufnahme vom 7. Oktober 2026

Geprüft wurden bislang Projektvorgaben, Masterplan, die Pläne der Phasen
19–21, der Abschlussbericht von Phase 18, der zentrale Phasenstatus sowie
Datenbankregistrierung und ausgewählte Tabellen/Schreibpfade. Dies ist noch
kein vollständiger Code- und Dokumentabgleich; dieser wird entlang der
Planungsentscheidungen gezielt ergänzt.

- `AppDatabase.schemaVersion` steht auf **21**; 16 Tabellen sind registriert.
- Phase 18 ist laut aktuellem Verlauf abgeschlossen. Ältere Aussagen im
  Masterplan, die Projektfunktionen noch als ausstehend beschreiben, sind
  hierfür überholt; maßgeblich sind aktueller Code und Phase-18-Abschluss.
- SQLite/Drift ist vorhanden; `pubspec.yaml` enthält derzeit keine
  Firebase-Abhängigkeiten.
- Aufgaben, Instanzen und Projekte verwenden Text-IDs. Neue Instanzen und
  Definitionsversionen erhalten in den geprüften Schreibern UUIDs. Eine
  vollständige Prüfung aller ID-Erzeuger einschließlich Migrationen steht aus.
- Änderungsmetadaten sind unterschiedlich ausgeprägt: Einträge besitzen
  `revision`/`updatedAt`, Aufgaben eigene Lebenszyklusmetadaten, Projekte
  `revision`/`updatedAt`. Das ist noch kein vollständiger Sync-Vertrag.
- Aufgaben/Bündel besitzen endgültige Löschmarker; Projekte behalten nach
  endgültiger Löschung einen anonymisierten historischen Verweis.
- Der Masterplan sieht langfristig Coaching vor und unterscheidet Eigentümer,
  Urheber, betroffene Person und Zugriffsrechte. Das bestätigte Zielbild und die
  Grenze der Vorbereitung darauf stehen in Entscheidung E19-01.

### Ergänzender Datenmodellabgleich

Die 16 registrierten Tabellen sind anhand ihrer Definitionen gesichtet.
Schreibwege wurden bislang gezielt geprüft, noch nicht lückenlos auditiert.

| Datenbereich | Befund und Konsequenz für die weitere Planung |
|---|---|
| `Aufgaben`, `Projects`, `TaskValueBundles` | Stabile Text-IDs vorhanden; allgemeine und Lebenszyklusmetadaten sind unterschiedlich. Fachliche Revisionen für bestehendes Undo/Restore nicht ungeprüft als Sync-Reihenfolge verwenden. |
| `TaskEntries`, `TaskEntryValues` | Eine Instanz je Aufgabe/Tag, ein Wertdatensatz je Instanz. Scheduler und Eingabe erzeugen neue UUIDs lokal: Zwei Geräte können denselben fachlichen Eintrag unter verschiedenen IDs erzeugen. Zuordnung und Referenzerhalt müssen vor echtem Sync geklärt sein. |
| `TaskDefinitionVersions`, `TaskValueBundleVersions` | UUID plus fortlaufende Versionsnummer je Aufgabe/Bündel. Zwei Geräte können dieselbe nächste Nummer vergeben. Lokale Nummern sind keine geräteübergreifend eindeutigen Versionen. Vorgänger, Gültigkeit, Aufhebung und abhängige Einträge gemeinsam betrachten. |
| `TaskPendingDefinitionChanges` | Datierte Änderungen mit versioniertem Payload und veränderlichem Zustand. Vormerkung und spätere Anwendung dürfen nicht zu zwei widersprüchlichen fachlichen Änderungen werden. |
| `TaskProjectAssignmentChanges` | Eigene UUID, aber lokal hochgezählte Sequenz mit Eindeutigkeitsindex pro Aufgabe/Bündel. Konflikte betreffen auch Zuordnungsreihenfolge, Wirksamkeitstag und rückwirkende Zuordnungen. |
| `TaskPlanningInterruptions` | Bereits explizite Kalendertage als Text, Zeitpunkte und Revision. Pause/Papierkorb betreffen zusätzlich Instanzplanung und Auswertung. |
| `TaskCardMetricPreferences` | Stabile ID je Aufgabe/Bündel; Zurücksetzen auf Standard löscht die Zeile. Ein späterer Abgleich muss dieses Zurücksetzen ausdrücklich übertragen können. |
| `TaskCorrectionOperations`, `TaskCorrectionItems` | Lokale Vorher-/Nachher-Zustände und erwartete Eintragsrevisionen schützen Undo. Das ist kein universelles Änderungsjournal; erste reguläre Eingaben werden damit nicht vollständig protokolliert. |
| `EntityDeletionMarkers` | Minimale Marker für Aufgaben/Bündel vorhanden; künftige technische Änderungs- und Konfliktdaten müssen in den endgültigen Löschvertrag einbezogen werden. |
| `ProjectDeletionBatches`, `ProjectDeletionBatchItems` | Wiederherstellung hängt an lokalen Lebenszyklusrevisionen. Falls Wiederherstellung geräteübergreifend verfügbar sein soll, braucht sie einen übertragbaren fachlichen Vertrag statt einer unveränderten Kopie lokaler Revisionsannahmen. |

**Technische Folgerung:** UUIDs und ein `updatedAt`-Feld allein reichen für das
bestätigte Zielbild nicht aus. Der Plan muss fachliche Identität, Herkunft,
bekannten Ausgangsstand und zusammengehörige Änderungen berücksichtigen.
Das begründet keinen Umbau sämtlicher IDs oder einen vollständigen Sync-Motor
in Phase 19. Der begrenzte Umsetzungsumfang steht in T19-01 bis T19-06 unten.

Weitere konkret geprüfte Anschlussstellen:

- `_rescheduleOneTimeEntry` erhält beim Verschieben die bestehende
  Eintrags-ID und verändert den Termin. Deshalb darf ein späterer fachlicher
  Instanzschlüssel nicht pauschal mit dem jeweils aktuellen Termin gleichgesetzt
  werden. Bestehende Korrektur- und Wertreferenzen müssen stabil bleiben.
- `ProjectRepository.watchProjectDetail` kann fällige Zuordnungsänderungen
  anwenden. Anzeige und tatsächliche Nachholverarbeitung unterscheiden:
  Eine fällige fachliche Änderung darf einmal erfasst werden, wiederholtes
  Beobachten desselben unveränderten Stands erzeugt keine weiteren Änderungen.

## Bestätigte Entscheidungen

### E19-01 – Eigene Daten auf mehreren Geräten; Coaching später

**Bestätigt am 7. Oktober 2026.** Die erste echte Synchronisierung soll dieselbe
Person auf mehreren Geräten einschließlich Offline-Nutzung unterstützen.
Phase 19 bereitet die dafür notwendigen lokalen Grundlagen vor; sie setzt
noch keine Cloud-Synchronisierung um.

**Ausdrücklich vorgesehene spätere Erweiterung:** Trainer-/Klientenfunktionen
und Coaching bleiben Teil des langfristigen Konzepts. Bei Datenidentität und
Eigentum muss diese Erweiterung berücksichtigt werden. Das spätere Modell
muss Dateneigentümer, Urheber, betroffene Person und Zugriffsberechtigte
unterscheiden können; diese Rollen dürfen nicht untrennbar mit einer
Geräteidentität gleichgesetzt werden.

Rollenverwaltung, Freigaben und gemeinsame Bearbeitung durch mehrere Personen
gehören weder zur Umsetzung von Phase 19 noch zum hier bestätigten ersten
Sync-Nutzungsfall. Konkrete zusätzliche Felder oder Tabellen sind damit noch
nicht beschlossen; sie werden nur bei nachgewiesenem Bedarf für die lokale
Vorbereitung in den Umsetzungsumfang aufgenommen.

### E19-02 – Widersprüchliche Eingaben automatisch auswählen, Alternative erhalten

Beispiel: Zwei Geräte bearbeiten offline denselben Tageswert unabhängig vom
gleichen Ausgangsstand; eines speichert 80 kg, das andere 82 kg.

**Bestätigter Endstand vom 7. Oktober 2026 nach E19-10:** Beide konkurrierenden
Eingaben erhalten; eine nach festgelegter Regel neuere Variante automatisch
verwenden. Der Nutzer kann die alternative Eingabe bei Bedarf auswählen,
muss aber nicht erst entscheiden, um weiterzuarbeiten. Unabhängige Änderungen
ohne Rückfrage zusammenführen, soweit Fachregeln dies erlauben. Eine bewusst
auf dem bereits bekannten neuen Stand ausgeführte Korrektur ist kein solcher
Parallelkonflikt. Die automatische Auswahl ist kein Anlass, die andere
Variante stillschweigend zu verwerfen.

Die konkrete Erkennung und automatische Reihenfolge sind noch technisch
festzulegen. Die Auswirkung auf Auswertungen regelt E19-06. Konfliktoberfläche
und tatsächlicher Geräteabgleich gehören zur späteren Sync-Umsetzung.
Die vorhandenen lokalen Revisionen und Korrekturdaten allein stellen keine
geräteübergreifende Konfliktlösung dar.

Die Entscheidung betrifft konkurrierende normale Eingaben. Für Löschungen,
Papierkorb und automatische Abschlüsse gelten die gesonderten Regeln unten.
Keine pauschale Pflicht ableiten, endgültig gelöschte Rohdaten als
Konfliktkopien dauerhaft aufzubewahren.

### E19-03 – Endgültige Löschung verhindert Wiederbelebung

**Bestätigt am 7. Oktober 2026:** Eine gültige endgültige Löschung setzt sich
gegen Änderungen eines Geräts durch, das diese Löschung noch nicht kannte.
Beim späteren Abgleich wird die alte Aufgabe nicht wiederbelebt; dazugehörige
Rohdaten werden auch nicht als dauerhafte Konfliktkopie aufgehoben. Der Nutzer
soll einen verständlichen Hinweis erhalten, wenn dadurch noch nicht übertragene
Änderungen verworfen werden. Die Gültigkeit der Löschung, insbesondere bei
konkurrierender Wiederherstellung und automatischem Fristablauf, benötigt eine
gesonderte Regel.

Das entspricht der bisherigen Trennung zwischen reversiblem Papierkorb und
endgültigem Entfernen. Papierkorb gegen Bearbeitung regelt E19-08;
Wiederherstellen gegen endgültiges Löschen regelt E19-11.

### E19-04 – Bewusste Antwort vor unwissendem automatischem Abschluss

Der vorhandene Scheduler schließt offene Einträge abhängig von Missed Policy,
Puffer und Carryover automatisch ab. `resolutionOrigin` unterscheidet bereits
`manual`, `automatic` und `migration`; automatische Abschlüsse setzen keinen
Nutzer-Antwortzeitpunkt. Damit ist eine fachliche Unterscheidung vorhanden,
aber noch kein geräteübergreifender Vorrang implementiert.

**Bestätigt am 7. Oktober 2026:** Wenn ein Gerät mangels Kenntnis einer
Offline-Antwort automatisch `failure` oder `no_entry` setzt, gilt beim Abgleich
die gültige bewusste Antwort bzw. Werteingabe des Nutzers. Dafür ist keine
Konfliktrückfrage nötig. Das gilt auch für eine bewusst negative Antwort;
maßgeblich ist die Nutzerhandlung, nicht der positivere Status. Antwort- und
Durchführungszeitpunkte bleiben erhalten; der spätere Übertragungszeitpunkt
darf die Eingabe nicht nachträglich als verspätet einstufen.

Diese Regel hebt weder endgültiges Löschen nach E19-03 auf noch entscheidet sie
Konflikte zwischen zwei Nutzerantworten. Wiederöffnen, Planänderungen und
Folgeinstanzen sind gesondert auf ihre fachlichen Auswirkungen zu prüfen;
aus `manual` allein darf kein pauschaler Vorrang für beliebige Felder folgen.

### E19-05 – Vollständiges fachliches Weiterarbeiten auf jedem Gerät

**Bestätigt am 7. Oktober 2026:** Nach vollständigem Abgleich soll ein
zweites Gerät denselben fachlichen Arbeitsstand bieten: vollständige noch
aufbewahrte Historie, Definitionen, Projekte, Bündel, Pausen, Papierkorb und
Anzeigeeinstellungen. Historische Korrekturen, das nach bestehenden Schutzregeln
noch zulässige Rückgängigmachen und Wiederherstellung sollen geräteübergreifend
möglich sein. Endgültig gelöschte Daten sind davon ausgenommen.

Berechnete Kennzahlen werden weiterhin lokal aus den Fachgrundlagen ermittelt.
Dies schreibt keine Eins-zu-eins-Übertragung sämtlicher SQLite-Tabellen vor.
Geräteübergreifendes Undo/Restore erfordert eine ausdrückliche Zuordnung der
benötigten fachlichen Metadaten; lokale Revisionsnummern allein reichen nicht.

Das ist ein Zielvertrag für die spätere Synchronisierung, keine Ausweitung von
Phase 19 auf deren vollständige Implementierung. Der Umsetzungsplan muss
ausweisen, welche Grundlagen jetzt geschaffen und welche Abläufe erst mit
der tatsächlichen Synchronisierung gebaut und geräteübergreifend getestet werden.

### E19-06 – Mit gekennzeichneter Konfliktvariante weiterarbeiten und auswerten

**Bestätigter Endstand vom 7. Oktober 2026 nach E19-10:**

- Offene Konflikte werden sichtbar und gesammelt zugänglich, blockieren aber
  nicht die gesamte App. Unabhängige Eingaben und Abgleiche laufen weiter.
- Ein betroffener Eintrag verwendet die automatisch ausgewählte Variante
  nach E19-02, zeigt einen dezenten Konflikthinweis und erlaubt bei Bedarf
  die Einsicht und Auswahl der anderen Variante.
- Kennzahlen, Ziele und Bündelergebnisse werden mit genau dieser Variante
  regulär berechnet. Vom Konflikt abhängige Ergebnisse erhalten einen Hinweis;
  keine vorübergehende Auswertungssperre allein wegen des Konflikts. Keine
  Doppelzählung beider Varianten, Ersatznull oder stilles Herausrechnen aus
  dem Nenner. Konfliktfreiheit und Vollständigkeit sind getrennte Begriffe.
- Wählt der Nutzer die andere Variante, werden die betroffenen lokalen
  Auswertungen neu berechnet. Die genaue Gestaltung von Hinweis und Auswahl
  bleibt der späteren Sync-Oberfläche vorbehalten.

Der geprüfte Code erwartet derzeit genau einen wirksamen Eintrag samt optionalem
Wert (`TaskEntryWithValue`, eindeutige `TaskEntryValues.entryId`); zwei
Konfliktvarianten dürfen nicht einfach als zwei normale Messungen gezählt werden.
Die bestehende Nichtverfügbarkeit von Aggregaten bei fachlich unberechenbaren
Daten bleibt bestehen, wird aber nicht pauschal auf Sync-Konflikte ausgeweitet.
Ein Sync-Konflikt ist ein zusätzlicher technischer Klärungszustand und darf
nicht ungeprüft als neuer fachlicher Eintragsstatus eingeführt werden.

### E19-07 – Zurückgenommen: Online-Bestätigung als Voraussetzung

**Am 7. Oktober 2026 durch die spätere Nutzervorgabe E19-09 ersetzt.**
Der zunächst akzeptierte Vorschlag, Wiederherstellung bis zum Online-Abgleich
ausstehend zu lassen, darf nicht als Nutzungssperre umgesetzt werden.
Der Nutzer hat nach Erläuterung ausdrücklich vollständige Offline-Nutzbarkeit
verlangt. Der spätere Abgleich kann einen Sync-Zustand bestätigen; er darf
keine Voraussetzung für die lokale Wiederherstellung und Weiterarbeit sein.

### E19-08 – Papierkorb erhält Offline-Eingaben; Darstellungskonflikte automatisch lösen

**Bestätigt am 7. Oktober 2026:** Die Punkte zu gewöhnlicher Offline-Bearbeitung
und reinen Anzeigeeinstellungen wurden bestätigt. Die ausstehende
Wiederherstellung wurde ausdrücklich zur Erläuterung ausgeklammert.

1. **Papierkorb gegen gewöhnliche Offline-Bearbeitung:** Die Aufgabe bleibt
   im Papierkorb. Gültige Offline-Eingaben gehen nicht allein durch das
   Verschieben verloren, aktivieren die Aufgabe aber auch nicht automatisch.
   Sie bleiben im Rahmen der normalen Papierkorbfrist erhalten; endgültiges
   Löschen nach E19-03 entfernt sie. Inhaltliche Konflikte bleiben nach E19-02
   erhalten. Das ist ein interner Abgleich von Änderungen eines unwissenden
   Geräts, keine Freigabe der normalen Bearbeitung bekannter Papierkorbinhalte.
2. **Reine Darstellungskonflikte:** Unterschiedliche Projektfarben,
   Projektsortierungen oder Kartenkennzahl-Einstellungen werden automatisch
   und auf allen Geräten einheitlich entschieden. Dafür keine manuelle
   Konfliktliste. Diese Ausnahme betrifft keine Messwerte, Antworten,
   Notizen, Namen, Beschreibungen, Ziele, Rhythmen oder Zuordnungen. Das
   Zurücksetzen einer Kartenanzeige auf Standard ist ebenfalls eine echte
   Einstellung und darf nicht durch eine alte Geräteversion verloren gehen.

Die genaue deterministische Regel für Punkt 2 wird im technischen Vertrag
festgelegt; nicht blind nach unzuverlässigen Geräteuhren sortieren.

### E19-09 – Lokale Nutzung benötigt niemals eine Internetverbindung

**Explizite Nutzervorgabe vom 7. Oktober 2026:** Internet darf für die lokale
App-Nutzung nicht unabdingbar sein, auch nicht bei aktivierter Synchronisierung.
Dies umfasst die nach lokalen Fachregeln zulässige Wiederherstellung und
anschließende Weiterarbeit. Eine abgelaufene lokale Papierkorbfrist oder ein
bereits lokal endgültig gelöschter Inhalt wird dadurch nicht wiederherstellbar.

- SQLite bleibt die unmittelbar nutzbare Arbeitsgrundlage. Lokale Aktionen
  warten nicht auf Serverbestätigung; Änderungen werden lokal dauerhaft erfasst.
- Ein späterer Abgleich überträgt Änderungen und erkennt Widersprüche.
  „Noch nicht synchronisiert“ ist keine Bearbeitungssperre.
- Bereits lokal bekannte Konflikte sollen auch lokal entscheidbar sein;
  die Auflösung wird anschließend wie eine weitere Änderung übertragen.
- Keine Verbindungspflicht nach einer bestimmten Offline-Dauer einführen.
- Daten eines anderen Geräts können ohne Austausch noch nicht bekannt sein.
  E19-09 verspricht deshalb keinen überall identischen Stand während einer
  Netztrennung. Cloud-Übertragung selbst setzt naturgemäß eine Verbindung voraus.

E19-07 und die vorgeschlagene Sperre während der Wartezeit sind zurückgenommen.
Die Folge einer später bekannt werdenden endgültigen Löschung regelt E19-11.

### E19-11 – Endgültige Löschung gewinnt auch gegen Offline-Wiederherstellung

**Bestätigt am 7. Oktober 2026:** Lokal sofort wiederherstellen und
weiterarbeiten lassen. Wird beim späteren Abgleich eine gültige endgültige
Löschung derselben Identität bekannt, bleibt E19-03 maßgeblich: Die lokal
wiederhergestellte Aufgabe wird einschließlich zwischenzeitlicher Eingaben
wieder entfernt. Ein verständlicher Hinweis erklärt dies. Diese Einschränkung
wurde dem Nutzer ausdrücklich einschließlich des möglichen Datenverlusts
erläutert und von ihm bestätigt.

Für den seltenen Widerspruch kein zusätzliches Freigabe-/Warteverfahren bauen.
Eine gültige endgültige Löschung kann aus bestätigtem manuellem Löschen oder
dem gültigen Ablauf der bestehenden Papierkorbfrist entstehen. Ein Gerät,
das die Wiederherstellung bereits kennt, darf nicht auf Grundlage eines
überholten Papierkorbstands neue Löschung erzeugen. Eine unabhängig bereits
gültig vollzogene endgültige Löschung bleibt dagegen endgültig.

## Technische Einordnung für die spätere Synchronisierung

### Zeitstempel, Änderungsnachweise und Kosten

Nutzerfrage: Jede Eingabe mit klaren Zeitstempeln versehen und Widersprüche
erst bei Online-Nutzung abgleichen; unnötigen Verbrauch vermeiden.

**Anschlussvertrag für die spätere echte Synchronisierung:** Jede tatsächliche
fachliche Änderung dann lokal mit einer eindeutigen Änderungs-ID, Herkunft und Erfassungszeit
sowie einem Verweis auf den bekannten Ausgangsstand erfassen. Uhrzeit und
lokale fortlaufende Revision allein unterscheiden eine bewusste Folgeänderung
nicht zuverlässig von zwei unabhängigen Offline-Änderungen. Die Referenz auf
den Ausgangsstand muss geräteübergreifend verständlich sein; keine bloße
lokale Revisionszahl als globale Versionsidentität ausgeben.

- Zeitpunkte der Erfassung, fachliche Tage/Zeiten und späteren Serverempfang
  getrennt halten. Eine späte Übertragung verschiebt keinen Durchführungstag.
- Zeitstempel dienen Nachvollziehbarkeit; unterschiedliche Geräteuhren dürfen
  keinen stillen Verlust einer konkurrierenden Eingabe verursachen.
- Änderungen zunächst nur lokal festhalten. Bei Verbindung ausstehende
  Änderungen übertragen und seit dem letzten bestätigten Abgleich neu
  hinzugekommene Änderungen beziehen; keine komplette Historie bei jeder
  Eingabe oder jedem Ansichtswechsel erneut vergleichen.
- Wiederholte Übertragung derselben Änderungs-ID darf fachlich nicht doppelt
  wirken. Zusammenfassen nur, soweit Konfliktnachweise, Undo, Löschungen und
  zusammengehörige Aktionen erhalten bleiben.
- Batching reduziert nicht automatisch die Zahl abgerechneter Dokumentwrites.
  Eine spätere Kostenrechnung muss die tatsächliche Cloud-Abbildung zählen,
  einschließlich Bestätigungen, Löschmarkern und Konfliktmetadaten.

**Offizieller Quellenabgleich am 7. Oktober 2026:** Falls Cloud Firestore
Standard verwendet wird, zählen insbesondere Dokument-Lese-, Schreib- und
Löschvorgänge, Index-Lesevorgänge, Speicher und Datenverkehr. Ein zusätzliches
Zeitstempelfeld im ohnehin geschriebenen Dokument bedeutet keinen separaten
Dokumentschreibvorgang; zusätzliche Dokumente oder separate Aktualisierungen
können dagegen weitere Vorgänge verursachen. Datenvolumen/Indexspeicher bleiben
zu berücksichtigen. Keine konkrete Kostenprognose ohne Datenmengen und
Cloud-Design abgeben.

Quellen: [Firestore-Abrechnung](https://firebase.google.com/docs/firestore/pricing),
[Offline-Verhalten](https://firebase.google.com/docs/firestore/manage-data/enable-offline).
Firestore beschreibt bei mehreren Änderungen desselben Dokuments standardmäßig
„last write wins“. Dieses Verhalten allein erfüllt E19-02 nicht: konkurrierende
Facheingaben müssen erhalten bleiben. SQLite bleibt gemäß Phasenziel bestehen;
kein Wechsel zum Firestore-Cache wird hier beschlossen.

## Übergabe aus Phase 18

Seit Schema 21 müssen in der Sync-Vorbereitung zusätzlich berücksichtigt
werden: Projekt-`revision`/`updatedAt`, Archiv- und Papierkorbzustände,
anonymisierte endgültige Projektverweise, typisierte datierte Zuordnungs-
ereignisse für Aufgaben und Bündel sowie Projekt-Löschbatches. Batchdaten sind
lokale Konsistenzmetadaten und dürfen nicht ungeprüft als dauerhaftes
Cloud-Fachobjekt behandelt werden. Die Produktregeln stehen oben; T19-06 grenzt
das spätere Delta-/Konfliktprotokoll von dieser lokalen Vorbereitung ab.
Phase 18 führt keine Cloud-Schreibvorgänge ein.

## Ziel

Die App soll lokal stabil bleiben, aber ihre Datenstruktur so vorbereiten, dass
eine spätere Firebase-Synchronisierung konfliktfähig und schreibsparsam möglich
wird.

## Leitplanken

- SQLite bleibt zunächst lokale Arbeitsgrundlage.
- Nur echte Änderungen werden später synchronisiert.
- Reine Anzeige erzeugt keine Cloud-Schreibvorgänge.
- Historische Rohdaten und Definitionsversionen bleiben erhalten.
- Konflikte zwischen Geräten müssen später nachvollziehbar lösbar sein.

## Konkreter lokaler Umsetzungsvertrag

Die folgenden technischen Festlegungen setzen den bestätigten kleinen Umfang
um. Sie verändern keine weiteren Produktregeln. Es entsteht noch kein System,
das selbstständig zwischen Geräten synchronisiert oder Konflikte erkennt.

### T19-01 – Identitäten und fachliche Einheiten erhalten

- Bestehende IDs als undurchsichtige stabile Textwerte behandeln. Neben UUIDs
  existieren etwa alte Migrations-IDs nach `taskId:Datum` und abgeleitete
  Kartenpräferenz-IDs. Keine UUID-Pflichtvalidierung oder Neuvergabe im Bestand.
- Neue Fachobjekte verwenden die vorhandene UUID-Erzeugung; Kartenpräferenzen
  behalten ihre abgeleitete ID. Keine Geräte-/Kontoinformation in Fach-IDs einbauen.
- Eine Aufgabe, ihre Definitionen, eine Instanz und deren Messwert sind
  unterschiedliche Identitäten. Messwert und zugehöriger Eintragsstatus werden
  fachlich gemeinsam geschrieben; nicht unabhängig widersprüchlich übertragen.
- Termine verschobener Einmalaufgaben ändern keine Eintrags-ID. Die späteren
  Sync-Verträge müssen unabhängige Instanzerzeugung, Versionsnummern und
  Zuordnungssequenzen behandeln; keine vorsorgliche Änderung der heutigen
  Eindeutigkeitsbedingungen oder Referenzen in Phase 19.
- Keine Konten-/Rollen-Tabellen, Platzhalter-Eigentümer oder Geräteverwaltung
  einführen. Der spätere Datenraum wird zusätzlich zur Fach-ID geführt.
  Geräteherkunft ist dabei kein Eigentumsnachweis (E19-01).

### T19-02 – Zeitsemantik ohne pauschalen historischen Umbau

- Technische Erstellungs-/Änderungs-/Löschzeitpunkte sind absolute Zeitpunkte.
  Neue technische Zeitstempel mit derselben Uhr pro fachlichem Schreibvorgang
  beziehen und als UTC-Zeitpunkte behandeln; vorhandene Epoch-Werte nicht
  durch erneutes Interpretieren als lokale Uhrzeit verschieben.
- Fachliche Tage (`scheduledDate`, `performedOn`, Start-/End-/Fälligkeitstage,
  datierte Vormerkungen/Zuordnungen) sind Kalenderzuordnungen. Im späteren
  Transport als `YYYY-MM-DD` darstellen, nicht durch UTC-Umrechnung umdatieren.
  Erfasste Uhrzeiten bleiben Minuten plus vorhandener Tagesoffset, Dauern
  bleiben Dauern. Zeitpunkte und Tagesfelder ausdrücklich unterscheiden.
- Die bestehende lokale Tagesgrenze um 00:00 bleibt. Keine neue Reise-/Zeitzonen-
  Einstellungsfunktion oder Umstellung aller Datumsspalten in dieser Phase.
  Vor echtem Geräteimport muss dessen Datumskodierung samt Zeitzonentests stehen.
- `updatedAt` ist weder Antwortzeit noch eindeutige globale Änderungskennung.
  Mehrere Änderungen können denselben gespeicherten Zeitstempel haben; späterer
  Delta-Abgleich darf deshalb nicht allein auf `updatedAt > letzterAbruf` beruhen.
- Für gezielte Tests eine injizierbare Uhr an den betroffenen Schreibern nutzen,
  soweit nötig. Keine Umstellung sämtlicher Anzeige-/Analyse-Zeitberechnungen.

### T19-03 – Kleine Schema-Ergänzung ab Version 21

Nächste freie Schemaversion verwenden, beim geprüften Stand **22**. Bestehende
Migrationsketten erhalten; `_addColumnIfMissing` bei alten Upgradepfaden nutzen,
die Tabellen bereits anhand der aktuellen Definition erzeugen können.

| Tabelle | Ergänzung | Bestehende Daten / neue Schreibvorgänge |
|---|---|---|
| `Aufgaben` | Nullable `updatedAt` | Altbestand bleibt `null`: damaliger letzter Änderungszeitpunkt nicht zuverlässig bekannt. Neue Aufgabe und echte Änderungen ihrer eigenen gespeicherten Felder setzen den Zeitpunkt. |
| `TaskValueBundleVersions` | Nullable `updatedAt` | Altbestand bleibt `null`, da gleichentägige Metadatenänderungen bisher keinen eigenen Änderungszeitpunkt besitzen. Neue Version und tatsächliche Änderung von Text, `validTo` oder `cancelledAt` setzen den Zeitpunkt. |
| `TaskCardMetricPreferences` | `isReset`, bool, Default `false` | Bestehende Konfigurationen bleiben unverändert. Eine echte Rücksetzung bleibt künftig als Zeile mit `isReset=true` und `updatedAt` erkennbar; genauer Vertrag T19-04. |

Keine erfundenen historischen Änderungsdaten aus dem Migrationszeitpunkt
erzeugen. `null` bedeutet unbekannter Altbestand, nicht „unverändert“ oder
„bei erstem Sync ignorieren“. Der spätere Erstabgleich übernimmt auch diese
Zeilen vollständig als Ausgangsbestand.

Bereits vorhandene Zeitfelder und fachliche Revisionen behalten ihre Bedeutung.
`TaskDefinitionVersions` werden im geprüften Laufzeitcode angelegt, nicht
inhaltlich überschrieben; `supersededAt` wird in einer alten Migration gesetzt.
Hier keine zusätzliche allgemeine Revision oder `updatedAt`-Spalte ohne
Laufzeitbedarf anlegen. Dasselbe gilt für unveränderliche Korrektur-Items und
Projektlöschbatch-Mitglieder. Bestehende Schema-/Fachconstraints bleiben.

### T19-04 – Rücksetzen einer Kartenanzeige nachvollziehbar speichern

Dies ersetzt gezielt die physische Zeilenlöschung beim Reset aus Phase 15;
für den Nutzer bleiben „Standard“ und „keine Kennzahl anzeigen“ unverändert.

- Fehlende Zeile bedeutet weiterhin Standard. Reset ohne vorhandene Zeile
  ist ein No-op; keine künstliche Zeile für nie geänderte Standardeinstellungen.
- Echten Reset als Änderung derselben Zeile speichern: `isReset=true`,
  `configJson=''` (reservierter, bei Reset nicht zu parsenden Wert),
  `updatedAt=now`. Referenz auf Aufgabe/Bündel und ID bleiben erhalten.
- `_cardMetricPreferenceSelection` prüft vor dem JSON-Parser auf `isReset` und
  liefert dann dieselbe Default-Auswahl wie bei fehlender Zeile. Bestehendes
  Verhalten für unbekanntes/beschädigtes JSON bei `isReset=false` erhalten.
- Wiederholter Reset einer bereits zurückgesetzten Zeile verändert nichts.
- Explizite Auswahl setzt `isReset=false` und das reguläre Konfigurations-JSON.
  Der Gleichheitsvergleich bezieht `isReset` mit ein. `items: []` bedeutet
  weiterhin bewusst keine Kennzahl, niemals Default.
- Setzen/Reset prüfen dieselben vorhandenen Schreibschutzregeln für Aufgabe
  und Bündel. Vorher-Prüfung und Änderung gemeinsam transaktional ausführen.
- Endgültiges Löschen der Aufgabe/des Bündels entfernt auch die Reset-Zeile
  über den bestehenden Fremdschlüssel. Der übergeordnete endgültige Löschmarker
  genügt; kein unbeschränkt wachsendes zweites Reset-Archiv.
- Reset erzeugt keine neue Aufgaben-/Bündel-Definitionsversion. Keine Änderung
  am Format normaler Kartenkonfigurationen oder an der Auswahloberfläche nötig.

### T19-05 – Schreibwege vervollständigen und No-ops bewahren

Änderungszeit und zugehörige Fachänderung gehören in denselben Schreibvorgang
bzw. dieselbe Transaktion. Nur die tatsächlich veränderte Zeile markieren:
Eine Messwerteingabe muss nicht zusätzlich den Aufgabenstamm aktualisieren.
Bestehende Lebenszyklusrevisionen bleiben auf ihren bisherigen Zweck begrenzt.

| Schreibbereich | Konkrete Arbeit |
|---|---|
| `AufgabenRepository.createTask/updateTask` | Neuen Aufgabenzeitstempel setzen. Unveränderte Stammfelder nicht erneut schreiben; geplante Änderungen dürfen trotzdem separat angelegt/angepasst werden. Vergleiche die tatsächlich normalisierten gespeicherten Felder, nicht pauschal alle optionalen Methodenparameter. |
| `TaskDefinitionResolver.applyDueChanges` | Geänderte Stammfelder mit Zeitstempel schreiben; unveränderten Stamm nicht künstlich ändern. Eine tatsächlich angewendete Vormerkung bleibt als Vorgang erhalten; bestehende fachliche Versions-/Gültigkeitsregeln nicht nebenbei ändern. Zweiter Lauf darf nichts erneut anwenden. |
| `TaskProjectAssignmentService._setCurrentProject` | Nur bei tatsächlich anderer Projekt-ID schreiben; `Aufgaben.updatedAt` bzw. bestehendes `TaskValueBundles.updatedAt` mitsetzen. Datierte Zuordnungsereignisse und deren eigene Metadaten bleiben erhalten. |
| `TaskLifecycleService` | Bei echter Änderung der Aufgabenzeile deren neuen Zeitstempel zusätzlich zu den bisherigen Lebenszyklusfeldern setzen. Bei Bündeln vorhandenes `updatedAt` für echte eigene Feldänderungen mitführen. Pause/Fortsetzen berühren bestehende Unterbrechungsintervalle und Revisionen weiterhin wie bisher. |
| Bündelerstellung/-bearbeitung/-auflösung im `AufgabenRepository` | Neue Versionen stempeln; bei gleichentägiger Textänderung sowie Beendigung/Aufhebung die betroffene Version stempeln. Wiederholtes Auflösen eines bereits aufgelösten Bündels darf dessen Zeitstempel nicht erneut verändern. |
| `ProjectRepository.reorderProjects` | Aktuell schreibt die Methode nur `sortOrder`, auch bei gleichem Wert. Künftig nur tatsächlich geänderte Positionen schreiben und jeweils `revision`/`updatedAt` mitführen. Vor Schreiben doppelte/unbekannte oder nicht mehr bearbeitbare Projekt-IDs abweisen; keine Teiländerung bei ungültiger Liste. Nicht aufgeführte Projekte unverändert lassen. |
| Entry-Setter, `TaskEntryCorrectionService`, `TaskInstanceScheduler` | Bestehende Antwort-/Wertzeitpunkte, Herkunft und Revisionen bewahren. Keine neue globale Revision oder Korrekturkopie für jede erste Eingabe. Beim Abgleich der Schreibwege nur konkrete No-op-/Atomaritätslücken korrigieren. |
| `ProjectLifecycleService` | Projektrevisionen, Löschbatches, exakte Mitglieder und anonymisierte endgültige Referenzen erhalten. Keine Cloud-Objekte daraus machen. Neue technische Metadaten dürfen bestehende Schutzprüfungen für Undo/Restore nicht außer Kraft setzen. |

Kein allgemeines Refactoring der großen Repository-Datei, kein neuer Scheduler,
keine generischen JSON-Patches oder automatische globale Datenbank-Trigger.
Gleicher gespeicherter Wert ist ein No-op; Ändern und später Zurückändern sind
dagegen zwei echte Änderungen. Lesepfade können fällige Nachholverarbeitung
auslösen; nur deren tatsächliche Fachänderungen zählen, nicht das Lesen selbst.

### T19-06 – Bewusst später: Übertragung und Konfliktprotokoll

Phase 19 speichert **kein vollständiges Ereignisjournal**, keine Cloud-Outbox,
keine Konfliktkopien und keine ungenutzten geräteübergreifenden Basisversionen.
Es gibt noch keinen gemeinsamen Cloud-Ausgangsstand. Beim späteren Aktivieren
von Sync wird dieser durch einen vollständigen Erstabgleich hergestellt;
anschließend werden ausstehende Änderungen samt bekanntem Ausgangsstand
dauerhaft und transaktional erfasst. Das ergänzt die lokalen Schreibwege,
ersetzt aber nicht das Fachmodell. Die heutigen Zeitfelder allein werden
ausdrücklich nicht als fertiges Konfliktprotokoll ausgegeben.

Vor der tatsächlichen Cloud-Umsetzung gesondert festzulegen und zu testen:

- Cloud-Produkt/Dokumentaufteilung, Kontozuordnung und Erstabgleich bestehender
  lokaler Daten; SQLite bleibt nutzbar, kein kontoabhängiger Startzwang.
- Eindeutige Änderungskennungen, bekannte Ausgangsversionen, sicherer Delta-Cursor
  und wiederholbare Übertragung ohne Doppelwirkung; keine unbemerkte Überschreibung
  konkurrierender Eingaben durch Firestore-Standardverhalten.
- Einheitliche automatische Konfliktreihenfolge einschließlich gleicher/falscher
  Gerätezeiten; echte Folgeänderung gegenüber konkurrierenden Änderungen erkennen.
  Empfangszeit einer alten Offline-Änderung nicht als deren Erfassungszeit ausgeben.
- Fachliche Zusammenführung unabhängig erzeugter gleicher Tagesinstanzen,
  gleich nummerierter Definitionen und Zuordnungen. Aktuelle lokale Nummern
  nicht als globale Konfliktlösung verwenden.
- Konfliktalternativen und Auswahl, Aufbewahrung sowie Schutz der noch zulässigen
  Undo-/Restore-Aktionen. Mehrtabellenaktionen gemeinsam und konsistent anwenden;
  lokale Revisionsnummern nicht unverändert zwischen Geräten vergleichen.
- Vollständigkeit des geladenen Bestands und Datumsübertragung prüfen, bevor
  automatische Missed Policies auf einem frisch synchronisierten Gerät laufen.
- Endgültige Löschmarker nicht allein nach Alter entfernen. Alte Geräte dürfen
  entfernte Daten nicht zurückbringen; Protokoll für Bereinigung/erneuten
  vollständigen Abgleich festlegen, ohne die lokale Nutzung zeitlich zu sperren.
- Konkrete Cloud-Kosten und Übertragungsleistung messen. Keine Schätzung aus
  „einem Zeitstempel pro Eingabe“ ableiten.

Diese Punkte sind bewusst Anschlussaufgaben der echten Synchronisierung und
keine Rückfragen oder versteckten Umsetzungsblocker für die lokale Phase 19.

## Umsetzungspakete und Abnahme

Die ursprünglichen Unterpunkte bleiben damit vollständig zugeordnet:
19.1 (IDs/Zeit/Metadaten) → Bestandsaufnahme und T19-01/02/05;
19.2 (Delta/Konflikte) → E19-02 bis E19-11 und T19-06;
19.3 (Papierkorb/Projekte/Werte) → Datenmodellabgleich und T19-04/05;
19.4 (Schema) → T19-03; 19.5 (Umfangsgrenze) → E19-10 und T19-06.

| Paket | Umfang und betroffene Dateien | Abhängigkeit / Status |
|---|---|---|
| 19a – Schema und Rückwärtskompatibilität | `lib/core/database/app_database.dart`, Tabellen `aufgaben_tabelle.dart`, `task_value_bundle_versions_table.dart`, `task_card_metric_preferences_table.dart`; Schema 22 gemäß T19-03, Drift-Code generieren | abgeschlossen |
| 19b – Änderungsmetadaten und Schreibsparsamkeit | Repository, Resolver, Zuordnungs-/Lebenszyklusdienste und Projektsortierung gemäß T19-05 | abgeschlossen |
| 19c – Rücksetzmarker für Kartenanzeige | Setter/Reset/Leser im `aufgaben_repository.dart`, bestehende Parser-/Auswahlverträge gemäß T19-04 | abgeschlossen |
| 19d – Abschluss und Übergabe | Migration, gezielte Regressionen, Analyse/Gesamttests, führende Doku aktualisieren | abgeschlossen |

Alle Aufgaben-Dateien liegen unter `lib/features/aufgaben/data/`, Projektdateien
unter `lib/features/projekte/data/`. Die vorhandenen Tests liegen entsprechend
unter `test/features/.../data/`. Keine neue UI für Phase 19 vorsehen.

| Abnahmefall | Erwarteter Nachweis |
|---|---|
| Echte Schema-21-Datei → 22; alte 19/20-Pfade → 22; Neuinstallation | Vorherige IDs, Fremdschlüssel, Einträge, Werte, Zeitpunkte, Versionen und Metadaten unverändert; neue Altbestandsfelder null, `isReset=false`; `PRAGMA foreign_key_check` leer. Fixtures nicht nur mit aktuellen Drift-Tabellen erstellen. |
| Neue Aufgabe / echte Stammänderung / gleiche Eingabe erneut | Technischer Zeitpunkt gesetzt bzw. geändert; wiederholtes identisches Speichern ändert keine Zeile, Revision oder Definitionsversion. Bei Stopp/Rollback keine isolierte Metadatenänderung. |
| Nur zukünftige Änderung vormerken / fällig anwenden / erneut anwenden | Vormerkung nachvollziehbar; gegenwärtige Stammfelder nicht vorzeitig verändert; tatsächliche Anwendung korrekt gestempelt; zweiter Lauf ohne neue Writes. |
| Projektzuordnung / Pause / Papierkorb / Restore | Eigene geänderte Zeilen gestempelt; vorhandene Lebenszyklus-, Zuordnungs- und Schutzregeln bleiben intakt. |
| Projektliste neu ordnen / identische Reihenfolge / ungültige Liste | Nur geänderte Positionen samt Revision/Zeitpunkt geschrieben; No-op ohne Writes; ungültige Liste atomar abgewiesen. |
| Bündel neu / Text am gleichen Tag / spätere Textversion / Auflösen zweimal | Betroffene Versionen erhalten Änderungszeit; Rohwerte und IDs bleiben; zweite identische Auflösung ohne Änderung. |
| Kartenpräferenz setzen → Standard → Standard → explizit ausblenden | Reset-Markierung bleibt; zweiter Reset ohne Änderung; explizit ausgeblendet unterscheidbar; keine zusätzliche Definitionsversion. Für Aufgaben und Bündel prüfen. |
| Reset im Papierkorb / endgültiges Löschen | Derselbe Schreibschutz wie beim Setzen; endgültiges Löschen entfernt Präferenz einschließlich Reset-Markierung, übergeordneter Löschmarker bleibt. |
| Wiederholtes Lesen/Beobachten/Statistik nach erledigtem Tagesabgleich | Keine neuen Writes/Versionen; bestehende berechnete Ergebnisse unverändert. No-op nicht nur anhand Zeitgleichheit prüfen, da mehrere Writes denselben Zeitstempel haben können. |
| Historie/Undo, Projekte und Bündel | Vorhandene Fachtests bleiben grün; keine Online-Abhängigkeit. Keine Mehrgerätegarantie durch diese lokalen Tests behaupten. |

In der Umsetzung einmal gezielt prüfen und danach abschließen:

1. `dart run build_runner build --delete-conflicting-outputs` nach Schemaänderung.
2. Betroffene Dateien formatieren; generierten Drift-Code nicht von Hand bearbeiten.
3. Gezielte Migrations-/Repository-/Lebenszyklus-/Korrekturtests, dann einmal
   `flutter analyze` und `flutter test` als Abschluss. Nicht grundlos wiederholen.
4. Kurzer manueller Check von Kartenstandard, explizit ausgeblendeter Anzeige
   und Offline-Wiederherstellung; wenn kein Gerät verfügbar, als nicht geprüft
   vermerken statt automatisierte Prüfung als Gerätetest auszugeben.

Kein Benchmarkprojekt. Falls gezielte Prüfungen zusätzliche Schreibvorgänge
oder eine reale Regression zeigen, diese beheben; größere Optimierungen vorher
mit dem Nutzer einordnen.

## Startanweisung für den Umsetzungschat

> Implementiere ausschließlich Phase 19 nach diesem Dokument, beginnend mit
> Paket 19a. E19-10 begrenzt den Umfang; T19-01 bis T19-06 und die Abnahmetabelle
> definieren die lokale Umsetzung. Die Regeln für echte Cloud-Synchronisierung
> sind Anschlussverträge und dürfen nicht vorgezogen werden.
>
> Lies AGENTS.md/CONTEXT.md, diesen Plan und den aktuellen Schema-/Arbeitsstand.
> Im Planungschat war Schema 21 aktiv; verwende die nächste freie Version,
> falls der Stand inzwischen fortgeschritten ist. Der Arbeitsbaum enthält
> umfangreiche bestehende Änderungen und unversionierte Dateien: nichts
> bereinigen, zurücksetzen oder pauschal überschreiben. Keine manuellen Edits
> an app_database.g.dart. Bekannte lokale Datenbanken/Seeddateien nicht verändern.
>
> Bestätigte Produktregeln nicht erneut abfragen. Technische Details innerhalb
> dieses begrenzten Vertrags selbst entscheiden. Nur bei einer konkreten
> Abweichung mit fachlichen Folgen oder einer deutlichen Umfangserweiterung
> rückfragen und den Befund nennen. Keine Firebase-Abhängigkeit, Kontopflicht,
> Cloud-Outbox, Konfliktoberfläche oder allgemeine Architekturüberarbeitung.
>
> Paketstatus und Verlauf fortschreiben. Nach erfolgreichen Abschlussprüfungen
> Phase 19 in diesem Ordner und im zentralen Phasenstatus als umgesetzt markieren;
> die spätere Cloud-Synchronisierung weiterhin ausdrücklich offen lassen.

## Historischer Prüfstand des Planungschats

- Statische Sichtung der 16 Tabellendefinitionen, Migrationseinstieg und gezielter
  Schreib-/Lesewege einschließlich Reset, Sortierung, Bündelversionen und
  Zuordnungsanwendung. Kein vollständiger Zeilenreview sämtlicher Screens oder
  generierter Dateien und kein vollständiger Audit jedes Schreibwegs.
- Dokumentationsbestand thematisch nach Sync-/Phase-19-Anschlüssen durchsucht;
  führenden Phasenstatus, Masterplan und relevante Fach-/Folgephasen gezielt
  abgeglichen. Historische Wiederholungen nicht vollständig Zeile für Zeile
  neu geprüft. Der Bestand umfasst 63 Markdown-Dokumente unter `docs/`.
- Im ursprünglichen Planungschat wurden nur Dokumente geändert. Die daraus
  folgende Implementierung und Abnahme ist inzwischen im Abschlussstand oben
  dokumentiert.
- Keine offene Produktfrage blockiert den beschriebenen lokalen Umfang.
  Bewusst spätere Protokollentscheidungen stehen abschließend in T19-06.
