# Momentum - Historisierung und Bearbeitung: Verlauf

Stand: 20. September 2026  
Status: Phase abgeschlossen

## Zweck

Dieses Dokument hält ersetzte Ansätze und den Abschluss der Planung fest.
Die gültigen Regeln und Umsetzungspakete stehen im [Arbeitsplan](history_editing_plan.md).

## Umsetzungsabschluss 20. September 2026

- Pakete 16a–16f umgesetzt; Datenbankschema auf Version 19 angehoben und
  generierter Drift-Code aktualisiert.
- Historische Definitionsauflösung, getrennte Vormerkungen, stabile
  Eintragsidentität, Durchführungstag und Revisionsschutz eingeführt.
- Einzel- und Sammelkorrekturen einschließlich persistentem einfachem Undo
  sowie zeitbezogene Projektzuordnungen umgesetzt.
- Historische Bündelintervalle und Schutz vor gemischten Wertauswertungen in
  Karten und Detailansichten durchgängig berücksichtigt.
- Gemeinsame Aufgaben-/Projekt-Regressionssuite: 117 Tests bestanden.
  Vollständiges `flutter analyze`: keine Probleme gefunden.
- Manueller Geräte-Abnahmelauf bleibt als zusätzliche Praxisprüfung empfohlen;
  bewusste spätere Erweiterungen sind im Arbeitsplan abgegrenzt.

## Planungsabschluss 20. September 2026

- Feste Messkonfiguration mit unabhängiger Kopiervorlage; kompatible
  Einheitenwechsel als spätere gezielte Erweiterung vorgemerkt.
- Wirksamkeit und Erklärungen, historische Projektzuordnung, Einzel-/Sammel-
  korrekturen, Durchführungstag und einfaches dauerhaftes Undo festgelegt.
- Bündeländerungen sofort sichtbar; unvollständige Ergebnisse zulässig und
  einzelne Tracking-Werte entfernbar. Keine eintägige Wartezeit.
- Technischer Vertrag für Resolver/Vormerkungen, stabile Eintragsidentität,
  Korrekturmetadaten und Projektzuordnung sowie Pakete 16a–16f ergänzt.
- Gezielter statischer Abgleich mit bestehenden Daten-/UI-Pfaden; keine
  Implementierung, kein Testlauf und keine Garantie eines vollständigen Codeaudits.
- Auf Nutzerwunsch Detailinterview beendet; unkomplizierte Randfälle durch
  dokumentierte Standardregeln behandeln. Nur echte Grundsatzkonflikte eskalieren.


## Ersetzte Ansätze aus der Planung vom 18.–20. September 2026

Diese Abschnitte sind Entscheidungsverlauf, keine Umsetzungsanweisung.

### P16-01 – Identität und inkompatible Änderungen (Ablauf ersetzt)

**Am 19. September 2026 durch P16-04 ersetzt:** Der nachfolgende ursprüngliche
Umstellungsablauf und seine Abnahmefälle sind nur Entscheidungsverlauf und
nicht umzusetzen. Für Release 1 gilt ausschließlich die Sperre mit unabhängiger
Kopiervorlage aus P16-04. Die Trennung verschiedener Messgrößen bleibt Leitlinie.

**Bestätigt am 18. September 2026:** Eine Aufgabe bleibt über Versionen hinweg
fachlich dieselbe Tätigkeit bzw. Messgröße. Umbenennung, Rhythmus, Ziel,
Projekt und kompatible Einheitenwechsel sind Änderungen derselben Aufgabe.
Ein Wechsel zu einer anderen Messgröße (z. B. Laufstrecke zu Körpergewicht)
beginnt eine neue Aufgabe statt einer sachlich vermischten Historie.

Version 1 bleibt bewusst einfach: fachlich inkompatible Umstellungen, die eine
widersprüchliche gemeinsame Auswertung erzeugen würden, werden nicht als neue
Version derselben Aufgabe gespeichert. Beispiel des Nutzers: kg zu Liter.

Ursprünglich vorgesehener Ablauf (ersetzt):

- Vor dem Speichern erklären, dass diese Änderung eine neue Aufgabe erfordert
  und bisherige Einträge bei der ursprünglichen Aufgabe bleiben.
- Zwei Aktionen anbieten: **Abbrechen** und **Neue Aufgabe erstellen**.
- Vor der ausdrücklichen Auswahl keine Daten verändern. Abbrechen erzeugt weder
  eine Aufgabe noch eine Definitionsversion.
- Bestätigung erzeugt eine eigenständige Aufgabe mit eigener ID und Historie;
  keine Übertragung, Umdeutung oder Vermischung alter Antworten/Werte.
- Die Fachregel muss auch im Speicherpfad gelten, nicht nur im Dialog.

Codebefund zur späteren Kompatibilitätsmatrix:

- `task_value_unit.dart` kennt Einheitenfamilien und Umrechnungsfaktoren für
  Volumen, Strecke, Dauer und Uhrzeit. Liter/Milliliter und Kilometer/Meter
  besitzen damit bereits eine Grundlage für kompatible Wechsel.
- kg ist derzeit keine vordefinierte Einheit; es kann als benutzerdefinierte
  Zahlen-Einheit vorkommen. Aus Freitext darf keine sichere Umrechnung oder
  Familienzugehörigkeit abgeleitet werden. Zusätzliche Standardeinheiten sind
  durch das Beispiel noch nicht beauftragt.
- Die konkrete Matrix für Wertart, Einheit, freie Einheitenbezeichnung und
  Erfassungsart wird noch festgelegt. Änderungen an Name, Rhythmus oder Ziel
  dürfen nicht pauschal wegen Implementierungsaufwand neue Aufgaben erzwingen.
- Die App kann einen Bedeutungswechsel allein aus einem frei geänderten Namen
  nicht zuverlässig erkennen; keine semantische Automatik dafür voraussetzen.

Vorgesehene Abnahmefälle: inkompatibler Wechsel mit Abbruch ohne Schreibvorgang;
Bestätigung mit neuer ID und unveränderten Altwerten; kompatibler Wechsel ohne
unnötige Neuanlage; keine Vermischung von Einträgen beider Aufgaben.

### P16-02 – Alte Planung bei Neuanlage beenden (ersetzt)

**Am 19. September 2026 durch P16-04 ersetzt:** Kein automatisches Beenden des
Originals beim Kopieren. Folgender früherer Beschluss ist nicht umzusetzen.

**Bestätigt am 18. September 2026:** Bei der in P16-01 beschriebenen Neuanlage
endet die Planung der ursprünglichen Aufgabe. Ihre Historie bleibt verfügbar;
die neue Aufgabe übernimmt ab ihrem Start. Kein automatischer Parallelbetrieb
beider Aufgaben und kein Löschen/Verschieben in den Papierkorb.

- Bestehende offene Einträge nicht allein wegen der Umstellung stillschweigend
  löschen oder abschließen. Ihr weiteres Verhalten wird in P16-03 geklärt.
- Der Hinweis vor dem Speichern muss auch das Ende der bisherigen Planung
  erklären, nicht nur die Anlage einer neuen Aufgabe.
- Technische Umsetzung muss Beendigung und Neuanlage gemeinsam erfolgreich
  speichern oder vollständig zurückrollen; keine halbfertige Umstellung.
- Exakter Stichtag, Behandlung des Umstellungstags und Übernahme von
  Ziel/Bündel/Kartenpräferenzen bleiben vor Umsetzung zu konkretisieren.

Codebefund: `Aufgaben.endDate` und `isActive` existieren bereits. Der Scheduler
beachtet `endDate` bei der Terminprüfung; mehrere Listen und Automatiken filtern
auf `isActive`. Deshalb nicht einfach `isActive = false` als fertige Lösung
annehmen: historische Auffindbarkeit und offene Altinstanzen müssen erhalten
bleiben. Beendete Planung, offene Einträge und spätere Papierkorbzeit sind
unterschiedliche Sachverhalte.

### P16-03 – Offene Altinstanzen nach Ende der Planung (entfallen)

Mit Annahme von P16-04 entfällt diese vorgeschlagene Sonderregel für den
Kopiervorgang. Das Original einschließlich offener Einträge bleibt unverändert.
Allgemeine Regeln zum Beenden einer Planung bleiben separat.

**Vorschlag, noch nicht bestätigt:** Bereits offene Einträge bleiben mit ihrer
ursprünglichen Messgröße und ihren bisherigen Frist-/Konsequenzregeln
bearbeitbar. Eine bereits vorgesehene automatische Konsequenz darf weiterhin
greifen; das Ende der Planung selbst ist keine neue Konsequenz. Keine weiteren
Instanzen der alten Aufgabe, auch nicht nach dem Abschluss einer Altinstanz.

Beispiel: Wechsel von Laufstrecke zu Laufdauer. Ein offener Laufstrecken-Eintrag
von gestern kann weiterhin in Kilometern beantwortet werden; neue Einträge
gehören zur Laufdauer. Alte offene Einträge ohne automatische Abschlussregel
bleiben offen. Eine allgemeine Aufräum-/Sammelkorrektur wird separat geplant.
