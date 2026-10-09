# Momentum - Projekte: Konzept

Stand: 6. Oktober 2026  
Status: Bestätigtes und umgesetztes Release-Konzept

## Rolle von Projekten

Ein Projekt ist ein optionaler Ordnungsrahmen für Aufgaben und Habits. Es
bündelt zusammenhängende Einträge, macht Fortschritt sichtbar und bildet eine
Auswertungsebene oberhalb einzelner Aufgaben.

Bestätigt am 4. Oktober 2026: Nutzer bestimmen den Verwendungszweck selbst.
Projekte unterstützen dauerhafte Lebensbereiche und abschließbare Vorhaben
mit derselben Grundstruktur, ohne verpflichtende Projekttypen. Flexibilität
soll nicht zu unnötiger Komplexität führen. Erledigte Aufgaben schließen ein
Projekt nicht automatisch ab.

Bestätigt am 6. Oktober 2026: Projekte lassen sich reversibel archivieren.
Sie bleiben samt Verlauf erreichbar, verschwinden aber aus der aktiven
Projektübersicht. Aufgaben und Habits laufen unverändert weiter. Ein eigener
Status „abgeschlossen“ ist für Phase 18 nicht vorgesehen. Die verbindlichen
Details stehen im Arbeitsplan unter P18-02; die Löschoptionen regelt P18-03.

Die verbindlichen Entscheidungen, technischen Verträge und Arbeitspakete stehen
führend im [`Arbeitsplan`](projects_plan.md). Dieses Konzept fasst sie zusammen.

Beispiele:

- Gesundheit
- Haushalt
- Lernen
- Training vorbereiten
- Arbeit oder private Organisation

## Grundregeln für den ersten Release

| Regel | Bedeutung |
|---|---|
| Projekte sind optional | Aufgaben und Habits können ohne Projekt bleiben. |
| Ein Inhalt gehört höchstens zu einem Projekt | Aufgaben, Habits und Bündel werden unabhängig zugeordnet; Mehrfachzuordnung kommt frühestens später. |
| Projektzuordnung besitzt einen zeitlichen Verlauf | Datierte Zuordnungsereignisse ergänzen vorhandene Aufgaben-Snapshots; keine pauschale Umschreibung alter Definitionen. |
| Projekte interpretieren keine Einträge anders | Status, Ziel und Missed Policy bleiben Aufgabe/Habit-verantwortlich. |
| Projektanalyse aggregiert vorhandene Werte | Keine parallelen Erfolgsbegriffe für Projekte einführen. |

## Erste Projektauswertung

Bestätigt am 6. Oktober 2026 (P18-07): Die Übersicht zeigt aktuell zugeordnete
Aufgaben/Habits mit Zugang zu ihren Details. Die Analyse zählt historisch zum
Projekt gehörende Einträge im gewählten Zeitraum nach bestehendem Status:
offen, erfolgreich, Wert erfasst, nicht erfolgreich oder ohne Antwort
abgeschlossen. Vorhandene Zeiträume übernehmen: letzte 7, 20, 30 Tage und
„Seit Beginn“.

Kein pauschaler Projektfortschritt in Prozent für den Start. Werte und Ziele
bleiben in der jeweiligen Aufgabenauswertung. Unterschiedliche Messeinheiten
werden nicht zu einer Projektsumme zusammengefasst. Genauere Auswertungen
werden später ergänzt.

Später möglich:

- Zielerreichung über alle Aufgaben mit Ziel
- getrennte Auswertung nach Aufgabenart
- Trends über Wochen und Monate
- Vergleich mehrerer Projekte
- Aussagekraft-Hinweise bei sehr wenigen oder vielen neutralen Eintraegen

## Bündelergebnisse in Projekten

Nutzeranforderung vom 6. Oktober 2026: Ein abgeleiteter Wert wie Schlafdauer
ist eigenständig nutzbar und auswertbar und muss in einem Projekt vorhanden sein
können. Die vorhandene Bündelauswertung soll dafür wiederverwendet werden.
Bestätigt ist eine optionale eigene Zuordnung zu höchstens einem Projekt,
unabhängig von den Quellen. Ergebnisse bleiben aus den ursprünglichen Werten
berechnet; keine zusätzlichen Rohwertkopien. Bestätigt ist außerdem die
Anwendung derselben Projektwechsel-, Archiv-, Lösch- und Wiederherstellungsregeln
auf direkt zugeordnete Bündel (P18-09). Quellen werden durch die Verknüpfung
allein nicht mit verschoben oder gelöscht. Die Projektanalyse zeigt einen
eigenen Bereich für Bündelergebnisse mit „vollständig“, „teilweise“, „fehlend“
und „nicht berechenbar“; keine Addition mit Aufgabenstatus zu einer gemeinsamen
Erledigungszahl (P18-10). Einzelne Bündel öffnen ihre vorhandene Detailauswertung.

## Löschung

Bestätigt am 6. Oktober 2026: Beide Löschoptionen werden mit einem
Projekt-Papierkorb und standardmäßig sieben Tagen Aufbewahrung umgesetzt.

| Aktion | Bedeutung | Release-Einordnung |
|---|---|---|
| Nur Projekt löschen | Projekt kommt in den Papierkorb; Aufgaben und Habits bleiben erhalten und werden aktuell projektlos. | Bestätigt für Phase 18. |
| Projekt samt Inhalten löschen | Projekt und direkt zugeordnete Aufgaben/Habits/Bündel kommen gemeinsam in den Papierkorb; inzwischen verschobene Inhalte und nicht selbst zugeordnete Quellen bleiben unberührt. | Bestätigt für Phase 18. |

Bestätigt am 6. Oktober 2026: Wiederherstellung wahlweise nur des Projekts oder
einschließlich der bei derselben Aktion mitgelöschten Aufgaben. Separat
gelöschte Aufgaben und spätere Nutzeränderungen bleiben unberührt. Details
und Abnahmefälle stehen im Arbeitsplan unter P18-04.

Nach „Nur Projekt löschen“ werden beim Zurückholen des Projekts keine aktuellen
Aufgaben-Zuordnungen automatisch wiederhergestellt. Erhaltene Aufgaben bleiben
projektlos oder behalten eine zwischenzeitliche neue Zuordnung; erneutes
Hinzufügen erfolgt über die normale Projektzuordnung (P18-06).

Bestätigt am 6. Oktober 2026: Historische Einträge behalten die damalige
Projektidentität. Im Papierkorb wird der erhaltene Projektname mit Löschhinweis
angezeigt; nach endgültiger Löschung nur „Gelöschtes Projekt“. Name,
Beschreibung und Farbe werden entfernt, ein minimaler technischer
Identitätsverweis bleibt. Einträge und Auswertungen erhaltener Aufgaben bleiben
bestehen (P18-05). Zuordnungssonderfälle, Vormerkungen und technische Löschverweise
sind im Arbeitsplan unter T18-01 bis T18-03 konkretisiert.

## Spaetere Erweiterungen

### Unterprojekte

Projekte können später hierarchisch werden. Dann muss entschieden werden:

- ob Unterprojekte beliebig tief verschachtelt sein dürfen,
- ob Auswertungen rekursiv über Unterprojekte laufen,
- was beim Verschieben oder Löschen eines Elternprojekts passiert,
- wie Aufgaben angezeigt werden, die direkt am Elternprojekt haengen.

### Unteraufgaben

Unteraufgaben sind verwandt, aber nicht dasselbe wie Unterprojekte. Eine
Unteraufgabe kann entweder eine echte Aufgabe mit eigener Instanzlogik sein oder
ein leichtes Checklistenelement innerhalb einer Aufgabe. Diese Entscheidung
beeinflusst Auswertung, Sync und Löschung und gehört deshalb in eine spätere
eigene Phase.

## Bewusst einfacher Start

Keine neue Projektanzahlgrenze oder Paywall in Phase 18. Farben dienen der
Orientierung; zusätzliche Farbfilter sind später möglich. Aufgaben/Habits
können direkt aus aktiven Projekten erstellt werden, bestehende Inhalte werden
zugeordnet. Archivierte Projekte werden vor neuen Zuordnungen zurückgeholt.
Genauere Analysen, Unterprojekte und weitere Inhaltstypen bleiben spätere
Erweiterungen. Für den festgelegten Startumfang sind keine Produktfragen offen.
