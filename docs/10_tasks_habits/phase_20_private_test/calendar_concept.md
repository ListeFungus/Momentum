# Momentum – Kalenderkonzept (aus der privaten Testphase)

Stand: 21. Oktober 2026  
Status: **Fachlicher Konzeptentwurf V0.4, noch nicht implementiert**  
Ursprung: Gespräche im Android-Praxistest, insbesondere Testprotokoll #007, #017, #018, #019 und App-Konzept #A01.  
**Abgrenzung:** Dies ist die interne Momentum-Kalenderansicht. Die Integration externer Kalender (#019) ist eine spätere, separate Idee.

## Ziel und Produktidee

Eine eigenständige Kalenderoberfläche für bestehende Aufgaben/Habits und deren Planung: intuitiv wie etablierte Kalender, mit mehr Transparenz über offene, erledigte und noch nicht determinierbare Aufgaben. Keine zweite Aufgaben-Datenhaltung und keine unbemerkte Änderung von Wiederholungs-, Historien- oder Missed-Policy-Regeln.

Der Kalender soll auch zukünftige Tage anzeigen können. Dies ist derzeit in der vorhandenen Tagesnavigation eingeschränkt; diese Beschränkung ist ein **technischer Ist-Zustand**, keine gewünschte fachliche Kalenderregel. Zukünftige Ansicht und Berechnung müssen separat technisch geprüft werden.

## Vereinbarte Anforderungen

### 1. Navigation

- Eigener Menüpunkt **Kalender**; alternativ spätere Einbettung in ein Dashboard denkbar, aber direkter Zugang zum Kalender gewünscht.
- Vollflächige, umschaltbare **Tages-, Wochen-, Monats- und Listenansicht**, nicht alle gleichzeitig.
- Aufgabenkarten/-blöcke in jeder Ansicht anklickbar: vollständige Details und reguläre Bearbeitung öffnen.

### 2. Zeitinformationen bei der Aufgabenerstellung

- Das vorhandene Fälligkeitsdatum bleibt bestehen.
- Optional **geplante Dauer (Stunden und Minuten)** und/oder **Start- und Enduhrzeit** erfassen; Eingaben sollen schnell und intuitiv sein.
- **Dauer ohne Startzeit**: Aufgabe erscheint im Tages-/Wochenbereich **„Ohne Uhrzeit“**, mit Dauer neben dem Titel (z. B. „Einkaufen · 45 Min.“). Keine automatische Verplanung in freie Zeitfenster für V1.
- Aufgaben ohne Uhrzeit **und** ohne Dauer bleiben möglich.
- Die Unterscheidung zwischen *geschätzter Dauer*, *verbindlich geplanter Zeitspanne* und *Fälligkeit* ist fachlich wichtig und vor technischer Umsetzung explizit zu definieren.

### 3. Ansichten

**Tag**
- Zeitachse über den gesamten Tag; zeitlich platzierte Aufgaben als Blöcke nach Start/Ende bzw. Dauer.
- Oberhalb der Zeitachse kompakte Liste/Spalte **„Ohne Uhrzeit“** für Aufgaben ohne feste Startzeit, auch wenn sie eine geschätzte Dauer haben.
- In der Liste primär Titel oder gekürzter Titel, bei Bedarf Dauer, Details per Antippen.

**Woche**
- Sieben Tage mit kompakten Zeitblöcken.
- In dichten Darstellungen kurze Titel oder wahlweise Projektbezeichnung; konkrete Darstellung/Einstellung später prüfen.
- Pro Tag ein kompakter Bereich **„Ohne Uhrzeit“**; wenn eng, eventuell nur Anzahl/aufklappbarer Inhalt.

**Monat**
- Übersicht vorrangig über **Anzahl der Aufgaben pro Kalendertag**, nicht über ausgedehnte Aufgabenblöcke.
- Beispiel: „17. November: 8 Aufgaben“; geplante Anzahl klar von unbestimmten Folgeterminen trennen.
- Ggf. weiterer Status erledigt/offen, ohne die Zellen zu überfrachten.

**Liste/Agenda**
- Chronologische, scrollbare Folge von Tagen (heute, morgen und weitere), mit Aufgabenname und **von–bis Uhrzeit**; ohne Uhrzeit entsprechend kennzeichnen.
- Aufgaben antippen -> Details/Bearbeiten.

### 4. Direktbearbeitung und Drag-and-drop (Version 1)

**Freie, einmalige und unabhängige Termine:**
- **Offenes Schloss** signalisiert direkte Verschiebbarkeit.
- Kalenderblock lange drücken und vertikal ziehen -> Startzeit verschieben.
- Block innerhalb der Wochenansicht in einen anderen Tag ziehen -> geplanten Tag entsprechend ändern.
- Tagesansicht: Beim Ziehen zum Rand Wechsel-/Zielmöglichkeit für vorherigen/nächsten Tag vorsehen (konkreter Gestaltungsmechanismus offen).
- Blocklänge durch Ziehen am unteren Rand ändern; **Einrasten alle 15 Minuten**.
- Antippen bleibt Detail-/Bearbeitungsaktion. Wie Long-Press, Drag und Resize technisch abgegrenzt werden, ist UX-/Implementierungsdetail.

**Feste/wiederkehrende oder abhängige Termine:**
- **Geschlossenes Schloss** kennzeichnet Einträge, deren direktes Verschieben Folgewirkungen auslösen könnte.
- Kein Drag-and-drop oder direktes Resize in V1; Details bleiben zugänglich.
- Änderungen nur über reguläre **Bearbeiten**-Funktion und die bestehende Wiederholungs-/Rhythmuslogik.
- Dazu zählt auch das Verändern einer regelmäßigen Uhrzeit: in V1 einheitlich als gesperrte direkte Kalenderoperation behandeln.
- Nicht jedes Habit allein wegen des Typs sperren: entscheidend sind Serien-/Abhängigkeitsregeln.
- **V1 verzichtet auf Ausnahmen einzelner Instanzen einer Wiederholungsserie** („diesen Termin verschieben, alle anderen unverändert“).
- Ein klarer Erklärtext zum Schloss ist sinnvoll (z. B. „Wiederholung: Rhythmus bearbeiten“).
- Schloss ist ein Interaktionssignal, **nicht** zwingend ein eigener persistierter Status. Bestehende Historienregeln respektieren.

### 5. Anzeige wiederkehrender und zukünftiger Aufgaben

**Deterministische Fälligkeiten** (z. B. jeden Montag, alle sieben Tage nach festem Datumsanker):
- Zukünftige Instanzen/Termine **in der Kalenderansicht sichtbar berechnen**, sofern ihr Tag eindeutig feststeht.
- Rechenlogik konsistent zur bestehenden Domain und bei Änderungen an Regeln/Historie aktualisieren.
- Nicht automatisch behaupten, dass diese Instanzen schon in der Datenbank erzeugt sind: Kalenderprojektion und persistente Termininstanzen fachlich trennen.

**Abhängige Wiederholungen** (z. B. sieben Tage *nach tatsächlicher Erledigung*):
- Solange die Voraussetzung noch nicht eingetreten ist, **keinen fiktiven festen Termin** im Kalender zeigen.
- Bei Erledigung wird das neu determinierte Fälligkeitsdatum gemäß bestehenden Regeln berechnet und angezeigt.
- Auch rückwirkende Korrekturen müssen Neubewertung betroffener Projektionen auslösen, ohne vorhandene historische Daten zu verfälschen.

**Indikator für unbestimmte Folgetermine:**
- Wenn für eine offene Serie ein **frühestmöglicher Folgetermin** fachlich ableitbar ist, **an diesem frühestmöglichen Datum einmalig ein „+1“** oder entsprechender Zähler für mögliche weitere Aufgaben.
- **Nicht an jedem zukünftigen Tag wiederholen.**
- Zusätzlich **oberhalb oder unterhalb des Kalenders stets gut sichtbar die Gesamtzahl** der derzeit noch nicht feststehenden nächsten Folgetermine/Serien.
- Tippen auf die Gesamtzahl zeigt **welche Aufgaben betroffen sind**, gegebenenfalls mit frühestem möglichen Zeitpunkt und Hinweis, wovon die Fälligkeit abhängt.
- Unbestimmte Folgetermine **nicht in die Zahl bereits geplanter fester Aufgaben einrechnen**.
- Unbestimmte Serien **nicht mehrfach zählen**, insbesondere nicht eine unendliche Folge künftiger Wiederholungen.
- **Wichtiger Prüfpunkt:** Ein frühestmöglicher Folgetermin ist nicht immer eindeutig ableitbar (z. B. wenn die derzeitige Erledigung beliebig später stattfinden kann). Für V1 nur einen fachlich begründbaren Untergrenzentermin markieren; anderenfalls die Serie nur im allgemeinen „noch unbestimmt“-Zähler und dessen Detailansicht führen. Eine früher genannte beispielhafte „+1“-Markierung darf nicht als verbindliche Terminberechnung missverstanden werden.

### 6. Toleranzradius ausdrücklich verworfen

Die zwischenzeitliche Idee **„alle sieben Tage nach Erledigung ±1 Tag“** als zusätzliche Einstellung **nicht** für V1 einführen. Bestehende Puffer-/Missed-Regeln und deren Anzeigen reichen vorerst als Ausgangspunkt. Ein **Puffer nach Fälligkeit** ist fachlich nicht dasselbe wie „schon einen Tag früher fällig“; das darf nicht stillschweigend gleichgesetzt werden.

## Prüf- und Entwurfsfragen vor Implementierung

1. **Datenmodell:** Sind „Dauer“, Start-/Endzeit und rein geschätzte Dauer bereits fachlich getrennt abbildbar? Was ist beim Verschieben genau das Fälligkeitsdatum gegenüber einem separaten geplanten Zeitblock?
2. **Serienprojektion:** Wie werden zukünftige deterministische Vorkommen performant dargestellt, ohne persistente Instanzen vorzeitig zu erzeugen oder Missed-Policy-Regeln zu umgehen?
3. **Ungenaue Frühesttermine:** Ab wann kann eine neue, erledigungsabhängige Instanz tatsächlich frühestens entstehen, und wie werden laufende überfällige Instanzen berücksichtigt?
4. **Statuszählung:** Was zählt zur Tages-/Monatszahl (Aufgaben, Habits, Tracking, Carryover, abgeschlossene/gelöschte Einträge)? Welche Gesamtzahl umfasst der Unbestimmt-Zähler?
5. **Drag/Resize:** Grenzen am Tageswechsel, Zeitkonflikte/Überlappungen, Aufgaben ohne Uhrzeit, Sommerzeitwechsel und Touch-Bedienbarkeit.
6. **Wiederholung bearbeiten:** Was bedeutet Rhythmusänderung im bestehenden Versions-/Historienmodell? Nur zukünftige Termine ändern, keine stillen Historienänderungen.
7. **UX:** Typ-/Projektbeschriftung in engen Wochenzellen; kleine Screens; Schlosssymbol und barrierefreie Alternativen; Umgang mit vielen „Ohne Uhrzeit“-Einträgen.
8. **Priorisierung:** Festlegen, welcher Teil in einer ersten Kalenderausbaustufe tatsächlich gebaut wird. Das Konzept definiert gewünschtes Verhalten, **keinen fertigen Implementierungsplan**.

## Abhängigkeiten / Referenzen

- [Praxistest-Feedback](mobile_test_feedback_2026_10.md) – insbesondere #007, #017, #018 und #019.
- [Fachliche Regelmatrix](../task_rule_matrix.md) und [Aufgabenstruktur](../task_structure_plan.md) – Rhythmen, Missed-Policies, Puffer, Carryover.
- [Phase 16: Historische Bearbeitung](../phase_16_history_editing/history_editing_plan.md) – Versions- und Änderungsregeln.
- [Übergreifende App-Konzepte](../../00_overview/app_concept_ideas_2026_10.md) – #A01 Navigation/Monitoring.

**Nicht in diesem Schritt beauftragt:** Codeänderungen, Datenbankmigrationen, Termin-Engine-Umbau, externe Kalender-Synchronisierung oder feste Release-Termine.
