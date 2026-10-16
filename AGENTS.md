## Agent skills

### Issue tracker

Issues are tracked in GitHub Issues for `ListeFungus/Momentum`; external PRs are not treated as a triage surface. See `docs/agents/issue-tracker.md`.

### Triage labels

The repo uses the default triage labels: `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, and `wontfix`. See `docs/agents/triage-labels.md`.

### Domain docs

This is a single-context repo: read root `CONTEXT.md` and root `docs/adr/` when present. See `docs/agents/domain.md`.

### Anforderungen aus bestehenden Beschreibungen bewahren

- Vor der Ausarbeitung eines vorhandenen Punkts dessen Originalbeschreibung
  und spätere Nutzerentscheidungen lesen. Titel/ID und den ausdrücklich
  gewünschten Funktionsumfang in Zusammenfassungen erhalten.
- Originalwunsch, spätere bestätigte Änderung, technischer Befund und eigener
  Lösungsvorschlag klar unterscheiden. Eigene Alternativen oder Einschränkungen
  ersetzen den Nutzerwunsch erst nach dessen ausdrücklicher Zustimmung.
- Bereits beschriebene oder entschiedene Anforderungen nicht erneut als offene
  Grundsatzfrage stellen. Nur tatsächlich unbeschriebene Folgen, Widersprüche
  oder notwendige Entscheidungen mit einer konkreten Begründung erfragen.
- Eine leichtere Umsetzung, bestehende Sperre oder vorhandene Ersatzfunktion
  ist kein Beleg dafür, dass der Nutzer etwas anderes will. Technische Risiken
  erklären und sichere Umsetzung prüfen; offene Teile des Wunsches sichtbar lassen.
- Kleine technische Ausführungsentscheidungen selbst treffen und als solche
  dokumentieren; sie nicht als ausdrücklich bestätigte Produktregeln ausgeben.
- Vor Umsetzung und Abschluss Originalumfang gegen Plan, offene Punkte und
  Abnahme abgleichen. Bestätigungen nur auf das tatsächlich besprochene Paket
  beziehen; Vorschläge zur Priorisierung nicht als Nutzerentscheidung darstellen.
