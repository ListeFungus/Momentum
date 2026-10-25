import 'package:flutter/material.dart';
import 'package:momentum/features/aufgaben/data/aufgaben_repository.dart';
import 'package:momentum/features/aufgaben/presentation/task_edit_screen.dart';
import 'package:momentum/features/projekte/data/project_repository.dart';
import '../data/calendar_clock.dart';
import '../data/calendar_planning.dart';
import '../data/calendar_projection.dart';
import '../data/calendar_repository.dart';
import 'calendar_planning_field.dart';
import 'calendar_timeline.dart';

String calendarDate(DateTime date) => '${date.day}.${date.month}.${date.year}';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({
    super.key,
    required this.tasks,
    required this.projects,
  });
  final AufgabenRepository tasks;
  final ProjectRepository projects;
  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late final CalendarRepository repository = widget.tasks.calendarRepository;
  late DateTime selected = calendarDay(repository.clock.now());
  CalendarFilter filter = const CalendarFilter();
  String view = 'week';
  Stream<CalendarRange>? stream;

  DateTime get start => switch (view) {
    'week' => calendarAddDays(selected, 1 - selected.weekday),
    'month' => calendarAddDays(
      DateTime(selected.year, selected.month),
      1 - DateTime(selected.year, selected.month).weekday,
    ),
    _ => selected,
  };
  int get days => switch (view) {
    'week' => 7,
    'month' => 42,
    'agenda' => 30,
    _ => 1,
  };
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final saved = await repository.settings();
    if (!mounted) return;
    if (saved != null) {
      filter = CalendarFilter(
        tasks: saved.showTasks,
        habits: saved.showHabits,
        trackers: saved.showTrackers,
      );
      view = saved.view;
    }
    _reload();
  }

  void _reload() => setState(
    () =>
        stream = repository.watchRange(
          start,
          calendarAddDays(start, days - 1),
          filter,
        ),
  );
  Future<void> _settings() async {
    await repository.saveSettings(filter, view);
    if (mounted) _reload();
  }

  void _step(int direction) {
    selected =
        view == 'month'
            ? DateTime(selected.year, selected.month + direction, 1)
            : calendarAddDays(selected, direction * days);
    _reload();
  }

  Future<void> _change(
    CalendarOccurrence item,
    DateTime day,
    CalendarPlanning planning,
  ) async {
    try {
      await widget.tasks.calendarCommands.change(
        expectedTask: item.currentTask,
        expectedEntry: item.entry,
        day: day,
        planning: planning,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
    if (mounted) _reload();
  }

  Future<void> _editDate(CalendarOccurrence item) async {
    var day = item.day ?? calendarDay(repository.clock.now());
    var planning = item.planning;
    final accepted = await showDialog<bool>(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, state) => AlertDialog(
                  title: const Text('Termin ändern'),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton.icon(
                          icon: const Icon(Icons.calendar_today),
                          label: Text(calendarDate(day)),
                          onPressed: () async {
                            final today = calendarDay(repository.clock.now());
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: day.isBefore(today) ? today : day,
                              firstDate: today,
                              lastDate: DateTime(today.year + 20),
                            );
                            if (picked != null) state(() => day = picked);
                          },
                        ),
                        CalendarPlanningField(
                          value: planning,
                          onChanged: (value) => state(() => planning = value),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Abbrechen'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Speichern'),
                    ),
                  ],
                ),
          ),
    );
    if (accepted == true) await _change(item, day, planning);
  }

  void _details(CalendarOccurrence item) => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder:
        (context) => SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.task.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(item.day == null ? 'Ohne Datum' : calendarDate(item.day!)),
                Text(item.task.beschreibung),
                Text(
                  item.project == null
                      ? 'Ohne Projekt'
                      : 'Projekt: ${item.project!.name}',
                ),
                Text(
                  item.isVirtual
                      ? 'Vorschau – kein gespeicherter Eintrag'
                      : 'Status: ${item.entry!.status}',
                ),
                if (item.entry?.note.isNotEmpty == true) Text(item.entry!.note),
                Text(
                  item.planning.startMinute == null
                      ? 'Ohne Uhrzeit'
                      : 'Start: ${calendarTime(item.planning.startMinute!)}',
                ),
                if (item.planning.durationMinutes != null)
                  Text(
                    'Geplante Dauer: ${item.planning.durationMinutes} Minuten',
                  ),
                if (item.bundleName != null)
                  Text(
                    'Bündel: ${item.bundleName} (Quelle, kein zusätzliches Ergebnis)',
                  ),
                if (item.warning != null) Text(item.warning!),
                if (item.day != null &&
                    item.day!.isBefore(calendarDay(repository.clock.now())) &&
                    item.entry?.status == 'pending')
                  Text('Überfällig · Missed Policy: ${item.task.missedPolicy}'),
                if (item.lockReason != null) Text(item.lockReason!),
                const Text(
                  'Kalenderdetails sind schreibfrei. Zukünftige Termine können hier nicht beantwortet werden.',
                ),
                if (item.canMove)
                  TextButton.icon(
                    icon: const Icon(Icons.edit_calendar),
                    label: const Text('Termin ändern'),
                    onPressed: () {
                      Navigator.pop(context);
                      _editDate(item);
                    },
                  ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.of(this.context).push(
                      MaterialPageRoute<void>(
                        builder:
                            (_) => TaskEditScreen(
                              task: item.currentTask,
                              repository: widget.tasks,
                              projectRepository: widget.projects,
                            ),
                      ),
                    );
                  },
                  child: const Text('Aufgabe regulär bearbeiten'),
                ),
              ],
            ),
          ),
        ),
  );
  Widget _tile(CalendarOccurrence item) => ListTile(
    leading: Icon(item.canMove ? Icons.lock_open : Icons.lock_outline),
    title: Text(item.task.name),
    subtitle: Text(
      [
        if (item.day != null) calendarDate(item.day!),
        item.visibleStart == null
            ? 'Ohne Uhrzeit'
            : calendarTime(item.visibleStart!),
        if (item.planning.durationMinutes != null)
          '${item.planning.durationMinutes} Min.',
        item.entry?.status ?? 'Vorschau',
      ].join(' · '),
    ),
    onTap: () => _details(item),
  );
  void _list(String title, List<CalendarOccurrence> items) =>
      showModalBottomSheet<void>(
        context: context,
        builder:
            (_) => SafeArea(
              child: Column(
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleLarge),
                  Expanded(
                    child: ListView(children: items.map(_tile).toList()),
                  ),
                ],
              ),
            ),
      );
  Widget _month(CalendarRange range) => GridView.builder(
    padding: const EdgeInsets.all(4),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 7,
        childAspectRatio: .55,
    ),
    itemCount: 42,
    itemBuilder: (context, index) {
      final day = calendarAddDays(start, index);
      final items = range.onDay(day);
      final plus = range.unknown.where((u) => u.earliest == day).length;
      final closed =
          items
              .where((e) => e.entry != null && e.entry!.status != 'pending')
              .length;
      return InkWell(
        onTap: () {
          selected = day;
          view = 'day';
          _settings();
        },
        child: Card(
          color:
              day == selected
                  ? Theme.of(context).colorScheme.secondaryContainer
                  : null,
          child: Padding(
            padding: const EdgeInsets.all(3),
            child: Column(
              children: [
                Text('${day.day}'),
                Text(
                  '${items.length}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (closed > 0)
                  Text('✓ $closed', style: const TextStyle(fontSize: 11)),
                if (plus > 0)
                  Text('+$plus?', style: const TextStyle(fontSize: 11)),
              ],
            ),
          ),
        ),
      );
    },
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Kalender')),
    body: Column(
      children: [
        Wrap(
          spacing: 4,
          children:
              ['day', 'week', 'month', 'agenda']
                  .map(
                    (key) => ChoiceChip(
                      label: Text(
                        const {
                          'day': 'Tag',
                          'week': 'Woche',
                          'month': 'Monat',
                          'agenda': 'Liste',
                        }[key]!,
                      ),
                      selected: view == key,
                      onSelected: (_) {
                        view = key;
                        _settings();
                      },
                    ),
                  )
                  .toList(),
        ),
        Wrap(
          spacing: 4,
          children: [
            FilterChip(
              label: const Text('Aufgaben'),
              selected: filter.tasks,
              onSelected: (v) {
                filter = CalendarFilter(
                  tasks: v,
                  habits: filter.habits,
                  trackers: filter.trackers,
                );
                _settings();
              },
            ),
            FilterChip(
              label: const Text('Habits'),
              selected: filter.habits,
              onSelected: (v) {
                filter = CalendarFilter(
                  tasks: filter.tasks,
                  habits: v,
                  trackers: filter.trackers,
                );
                _settings();
              },
            ),
            FilterChip(
              label: const Text('Tracker'),
              selected: filter.trackers,
              onSelected: (v) {
                filter = CalendarFilter(
                  tasks: filter.tasks,
                  habits: filter.habits,
                  trackers: v,
                );
                _settings();
              },
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              tooltip: 'Vorheriger Zeitraum',
              onPressed: () => _step(-1),
              icon: const Icon(Icons.chevron_left),
            ),
            Text(calendarDate(selected)),
            TextButton(
              onPressed: () {
                selected = calendarDay(repository.clock.now());
                _reload();
              },
              child: const Text('Heute'),
            ),
            IconButton(
              tooltip: 'Nächster Zeitraum',
              onPressed: () => _step(1),
              icon: const Icon(Icons.chevron_right),
            ),
          ],
        ),
        Expanded(
          child: StreamBuilder<CalendarRange>(
            stream: stream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Kalender konnte nicht geladen werden: ${snapshot.error}',
                  ),
                );
              }
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final range = snapshot.data!;
              if (!filter.tasks && !filter.habits && !filter.trackers) {
                return const Center(
                  child: Text('Alle Filter sind ausgeschaltet.'),
                );
              }
              return Column(
                children: [
                  Wrap(
                    children: [
                      TextButton(
                        onPressed: () => _list('Überfällig', range.overdue),
                        child: Text('Überfällig: ${range.overdue.length}'),
                      ),
                      TextButton(
                        onPressed: () => _list('Ohne Datum', range.undated),
                        child: Text('Ohne Datum: ${range.undated.length}'),
                      ),
                      TextButton(
                        onPressed:
                            () => showModalBottomSheet<void>(
                              context: context,
                              builder:
                                  (_) => SafeArea(
                                    child: ListView(
                                      children: [
                                        const ListTile(
                                          title: Text(
                                            'Nächster Folgetermin unbestimmt',
                                          ),
                                        ),
                                        ...range.unknown.map(
                                          (u) => ListTile(
                                            title: Text(u.task.name),
                                            subtitle: Text(
                                              u.earliest == null
                                                  ? 'Abhängig vom Abschluss; noch kein Datum bestimmbar.'
                                                  : 'Frühestens ${calendarDate(u.earliest!)} (+1, kein fester Termin)',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            ),
                        child: Text('Unbestimmt: ${range.unknown.length}'),
                      ),
                    ],
                  ),
                  Expanded(
                    child: switch (view) {
                      'month' => _month(range),
                      'agenda' =>
                        range.occurrences.isEmpty
                            ? const Center(
                              child: Text('Keine Termine in diesen 30 Tagen.'),
                            )
                            : ListView(
                              children: range.occurrences.map(_tile).toList(),
                            ),
                      _ => CalendarTimeline(
                        start: start,
                        days: days,
                        range: range,
                        onDetails: _details,
                        onChange: _change,
                      ),
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ],
    ),
  );
}
