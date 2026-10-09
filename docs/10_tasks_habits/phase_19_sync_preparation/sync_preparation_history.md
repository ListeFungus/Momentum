# Momentum - Sync-Vorbereitung: Verlauf

Stand: 8. Oktober 2026  
Status: Abgeschlossen

## Zweck

Dieses Dokument hält später fest, welche Synchronisierungsgrundlagen vorbereitet
wurden.

## 8. Oktober 2026 – Lokale Sync-Vorbereitung abgeschlossen

- Schema 22 ergänzt unbekannt bleibende Altbestands-Zeitpunkte für Aufgaben und
  Bündelversionen sowie einen expliziten Resetmarker für Kartenpräferenzen.
- Aufgabenstamm, fällige Definitionsänderungen, Projektzuordnungen und
  Lebenszyklusaktionen führen Änderungszeiten nur bei echten Änderungen mit.
- Bündelversionen werden bei Erstellung, Änderung und Auflösung gestempelt;
  wiederholtes Auflösen bleibt ohne weiteren Write.
- Projektsortierung validiert die Liste atomar und ändert nur tatsächlich
  verschobene aktive Projekte samt Revision und Zeitpunkt.
- Kartenstandard wird nach einer echten Auswahl nicht mehr durch Zeilenlöschung,
  sondern als idempotenter Resetzustand gespeichert. Explizites Ausblenden
  bleibt davon getrennt.
- Drift-Codegenerierung, Schema-19-/20-Migrationen, gezielte No-op-, Reset-,
  Bündel-, Historien-, Lebenszyklus-, Zuordnungs- und Projekttests sind grün.
  Die vollständige Analyse meldet keine Probleme; **142 Tests** bestanden.
- Kein manueller Gerätetest in diesem Lauf. Keine Firebase-Abhängigkeit,
  Cloud-Outbox, Konten-, Konflikt- oder Übertragungslogik umgesetzt.

## 7. Oktober 2026 – Planung und bewusste Vereinfachung

- Ziel: spätere eigene Nutzung auf mehreren Geräten, vollständiger erhaltener
  Fachstand einschließlich Undo/Restore; Trainer-/Klientenfunktionen später.
- Lokale App-Funktionen müssen auch bei aktivierter Synchronisierung ohne
  Internet nutzbar bleiben. Der zwischenzeitlich diskutierte Online-Vorbehalt
  bei Wiederherstellung wurde auf ausdrückliche Nutzervorgabe zurückgenommen.
- Bewusste Eingaben haben Vorrang vor unwissenden automatischen Abschlüssen.
  Gewöhnliche Offline-Eingaben holen Papierkorbinhalte nicht automatisch zurück.
- Zunächst vorgesehene verpflichtende Konfliktauswahl und gesperrte Auswertungen
  nach Nutzerkritik vereinfacht: eine Variante automatisch verwenden, andere
  erhalten und optional auswählbar machen; betroffene Ergebnisse kennzeichnen.
- Phase 19 bleibt lokale Vorbereitung. Kein vollständiger Sync-Motor,
  keine Cloud-Dienste, keine Konfliktoberfläche und kein vorgezogener Umbau
  sämtlicher Auswertungen.
- Die konkrete Folge von Offline-Wiederherstellung gegen endgültige Löschung
  wurde abschließend bestätigt: endgültige Löschung gewinnt auch dann;
  zwischenzeitliche Eingaben können beim Abgleich entfallen, mit Hinweis.
- Datenbankstand 21 und die 16 Tabellen gesichtet, ausgewählte Schreibwege
  geprüft. Kein vollständiger Audit aller Schreibwege und keine Laufzeitmessung.

Nur Dokumentation bearbeitet; keine App-Implementierung, Migration oder Tests.
Der Arbeitsplan enthält die gültigen Entscheidungen und offenen Punkte.

## Technische Übergabe am 7. Oktober 2026

- Vier Pakete 19a–19d, konkrete Schreibwege, Migration ab Schema 21,
  Abnahmetabelle und Startanweisung ausgearbeitet.
- Kleiner Schemaumfang: zwei nullable Änderungszeitpunkte für Aufgaben und
  Bündelversionen, expliziter Reset-Zustand an Kartenpräferenzen. Historische
  IDs und Daten bleiben erhalten; unbekannte alte Änderungszeiten nicht erfinden.
- Konkrete Prüfbefunde: Projektsortierung schreibt ohne Revisions-/Zeitpflege;
  aktuelle Projektzuordnung schreibt Stammfelder ohne Änderungszeit;
  wiederholtes Bündelauflösen aktualisiert erneut den Zeitpunkt; Kartenreset
  löscht bisher die Zeile. Diese Anschlüsse gezielt absichern.
- Kein vorgezogenes vollständiges Journal. Tatsächliche Änderungskennungen,
  Ausgangsversionen und Konfliktvarianten entstehen mit dem späteren Sync-Protokoll.
- Bewusst kein vollständiger Zeilenreview aller 63 Dokumente und sämtlicher
  UI-/generierter Dateien. Relevante Stellen gezielt geprüft; Prüfgrenzen sind
  im Plan transparent festgehalten. Die Implementierungsabnahme steht noch aus.
