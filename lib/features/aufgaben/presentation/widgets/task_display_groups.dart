part of '../aufgaben_screen.dart';

class _DisplayGroups extends StatefulWidget {
  const _DisplayGroups({
    required this.repository,
    required this.projectRepository,
    required this.date,
    required this.onUndo,
  });
  final AufgabenRepository repository;
  final ProjectRepository projectRepository;
  final DateTime date;
  final ValueChanged<_UndoAction> onUndo;
  @override
  State<_DisplayGroups> createState() => _DisplayGroupsState();
}

class _DisplayGroupsState extends State<_DisplayGroups> {
  late Stream<List<DisplayGroupDay>> stream;
  @override
  void initState() {
    super.initState();
    stream = widget.repository.displayGroups.watchDay(widget.date);
  }

  @override
  void didUpdateWidget(covariant _DisplayGroups old) {
    super.didUpdateWidget(old);
    if (old.date != widget.date) {
      stream = widget.repository.displayGroups.watchDay(widget.date);
    }
  }

  Future<void> _create() async {
    final name = await _groupName(context);
    if (name == null) return;
    try {
      final id = await widget.repository.displayGroups.store.create(name);
      if (mounted) await _manageGroup(context, widget.repository, id);
    } catch (e) {
      if (mounted) _groupError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      TextButton.icon(
        onPressed: _create,
        icon: const Icon(Icons.add),
        label: const Text('Gruppe anlegen'),
      ),
      Expanded(
        child: StreamBuilder<List<DisplayGroupDay>>(
          stream: stream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Gruppen konnten nicht geladen werden.'),
              );
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final days = snapshot.data!;
            if (days.isEmpty) {
              return const Center(child: Text('Noch keine Gruppen.'));
            }
            return CardDisplaySession(
              cards: [
                for (final day in days)
                  for (final item in day.items)
                    DisplayCardIdentity.task(
                      item.task.id,
                      item.entry?.scheduledDate ?? day.date,
                    ),
              ],
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                children: [
                  for (var i = 0; i < days.length; i++)
                    _DisplayGroupPanel(
                      key: ValueKey(days[i].group.id),
                      day: days[i],
                      repository: widget.repository,
                      projectRepository: widget.projectRepository,
                      onUndo: widget.onUndo,
                      onMove:
                          i == 0
                              ? null
                              : () async {
                                final ids =
                                    days.map((d) => d.group.id).toList();
                                final id = ids.removeAt(i);
                                ids.insert(i - 1, id);
                                try {
                                  await widget.repository.displayGroups.store
                                      .reorder(ids);
                                } catch (e) {
                                  if (context.mounted) _groupError(context, e);
                                }
                              },
                    ),
                ],
              ),
            );
          },
        ),
      ),
    ],
  );
}

class _DisplayGroupPanel extends StatefulWidget {
  const _DisplayGroupPanel({
    super.key,
    required this.day,
    required this.repository,
    required this.projectRepository,
    required this.onUndo,
    this.onMove,
  });
  final DisplayGroupDay day;
  final AufgabenRepository repository;
  final ProjectRepository projectRepository;
  final ValueChanged<_UndoAction> onUndo;
  final VoidCallback? onMove;
  @override
  State<_DisplayGroupPanel> createState() => _DisplayGroupPanelState();
}

class _DisplayGroupPanelState extends State<_DisplayGroupPanel> {
  bool busy = false;
  GroupActionPreview? blocked;
  Future<void> _act({bool partial = false}) async {
    if (busy) return;
    setState(() => busy = true);
    try {
      final service = widget.repository.displayGroups;
      final store = ValueDraftScope.maybeOf(context);
      final keys =
          widget.day.items
              .map((t) => groupOccurrenceKey(t, widget.day.date))
              .toSet();
      final drafts = <String, TaskValueDraft>{
        for (final e in (store?.drafts ?? <String, TaskValueDraft>{}).entries)
          if (keys.contains(e.key)) e.key: e.value,
      };
      final preview = await service.preview(
        widget.day.group.id,
        widget.day.date,
        drafts: drafts,
      );
      if (!partial && preview.errors.isNotEmpty) {
        await service.store.update(widget.day.group.id, collapsed: false);
        if (mounted) setState(() => blocked = preview);
        store?.mark(preview.errors);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          for (final key in preview.errors.keys) {
            final target = store?.anchors[key]?.currentContext;
            if (target != null) {
              Scrollable.ensureVisible(
                target,
                duration: const Duration(milliseconds: 200),
              );
              break;
            }
          }
        });
        return;
      }
      await service.complete(preview, drafts: drafts, checkableOnly: partial);
      if (!partial) {
        store?.saved(
          drafts.keys
              .where((key) => identical(store.drafts[key], drafts[key]))
              .toList(),
        );
      }
      if (mounted) setState(() => blocked = null);
    } catch (e) {
      if (mounted) _groupError(context, e);
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final day = widget.day;
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(day.complete ? Icons.check_circle : Icons.folder_outlined),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${day.group.name}\n${day.completed} von ${day.items.length} bearbeitet',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              IconButton(
                onPressed: widget.onMove,
                tooltip: 'Gruppe nach oben',
                icon: const Icon(Icons.arrow_upward),
              ),
              IconButton(
                tooltip: 'Gruppe bearbeiten',
                icon: const Icon(Icons.edit_outlined),
                onPressed: () async {
                  await _manageGroup(context, widget.repository, day.group.id);
                },
              ),
              IconButton(
                tooltip:
                    day.group.isCollapsed
                        ? 'Gruppe ausklappen'
                        : 'Gruppe einklappen',
                icon: Icon(
                  day.group.isCollapsed ? Icons.expand_more : Icons.expand_less,
                ),
                onPressed: () async {
                  try {
                    await widget.repository.displayGroups.store.update(
                      day.group.id,
                      collapsed: !day.group.isCollapsed,
                    );
                  } catch (e) {
                    if (context.mounted) _groupError(context, e);
                  }
                },
              ),
            ],
          ),
          if (day.items.isEmpty)
            Text(
              day.members.isEmpty
                  ? 'Keine Einträge'
                  : 'Für diesen Tag nichts offen/geplant',
            ),
          if (day.items.isNotEmpty)
            Align(
              alignment: Alignment.centerLeft,
              child: FilledButton.tonalIcon(
                onPressed: busy ? null : () => _act(),
                icon: const Icon(Icons.done_all),
                label: const Text('Gruppe abschließen'),
              ),
            ),
          if (blocked != null) ...[
            Text(
              blocked!.errors.values.toSet().join('\n'),
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            TextButton(
              onPressed:
                  busy || blocked!.checkableKeys.isEmpty
                      ? null
                      : () => _act(partial: true),
              child: const Text('Nur abhakbare Einträge erledigen'),
            ),
          ],
          Offstage(
            offstage: day.group.isCollapsed,
            child: Column(
              children: _TaskGroup(
                title: day.group.name,
                color: Theme.of(context).colorScheme.primary,
                completedTitle: '',
                openTasks: day.items,
                completedTasks: const [],
                scheduledDateFor: (t) => t.entry?.scheduledDate ?? day.date,
                metaLabelFor: (t) => _entryTimingLabel(t, day.date),
                repository: widget.repository,
                projectRepository: widget.projectRepository,
                onUndoAvailable: widget.onUndo,
              )._taskCards(context, day.items),
            ),
          ),
        ],
      ),
    );
  }
}

void _groupError(BuildContext context, Object e) => ScaffoldMessenger.of(
  context,
).showSnackBar(SnackBar(content: Text(e.toString())));
Future<String?> _groupName(BuildContext context, {String initial = ''}) async {
  var name = initial;
  final result = await showDialog<String>(
    context: context,
    builder:
        (context) => AlertDialog(
          title: const Text('Gruppenname'),
          content: TextFormField(
            initialValue: initial,
            onChanged: (value) => name = value,
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Abbrechen'),
            ),
            TextButton(
              onPressed: () {
                if (name.trim().isNotEmpty) Navigator.pop(context, name.trim());
              },
              child: const Text('Speichern'),
            ),
          ],
        ),
  );
  return result;
}

Future<void> _manageGroup(
  BuildContext context,
  AufgabenRepository repo,
  String id,
) async {
  if (!await ValueDraftScope.confirm(context) || !context.mounted) return;
  await Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => _GroupEditor(repository: repo, id: id),
    ),
  );
}

class _GroupEditor extends StatefulWidget {
  const _GroupEditor({required this.repository, required this.id});
  final AufgabenRepository repository;
  final String id;
  @override
  State<_GroupEditor> createState() => _GroupEditorState();
}

class _GroupEditorState extends State<_GroupEditor> {
  late final service = widget.repository.displayGroups;
  late final stream = service.store.watchMembers();
  late final groups = service.store.watch();
  late final choices = service.choices();
  Future<void> _run(Future<void> Function() fn) async {
    try {
      await fn();
    } catch (e) {
      if (mounted) _groupError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Gruppe bearbeiten')),
    body: StreamBuilder<List<TaskDisplayGroup>>(
      stream: groups,
      builder: (context, gs) {
        final group = gs.data?.where((g) => g.id == widget.id).firstOrNull;
        if (group == null) return const SizedBox.shrink();
        return StreamBuilder<List<TaskDisplayGroupMember>>(
          stream: stream,
          builder:
              (context, ms) => FutureBuilder<List<Aufgabe>>(
                future: choices,
                builder: (context, ts) {
                  if (!ms.hasData || !ts.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final assigned =
                      ms.data!.where((m) => m.groupId == widget.id).toList()
                        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      ListTile(
                        title: Text(group.name),
                        trailing: const Icon(Icons.edit),
                        onTap: () async {
                          final name = await _groupName(
                            context,
                            initial: group.name,
                          );
                          if (name != null) {
                            await _run(
                              () => service.store.update(widget.id, name: name),
                            );
                          }
                        },
                      ),
                      for (var i = 0; i < assigned.length; i++)
                        ListTile(
                          title: Text(
                            ts.data!
                                    .where((t) => t.id == assigned[i].taskId)
                                    .firstOrNull
                                    ?.name ??
                                'Eintrag im Papierkorb',
                          ),
                          leading: IconButton(
                            tooltip: 'Mitglied nach oben',
                            icon: const Icon(Icons.arrow_upward),
                            onPressed:
                                i == 0
                                    ? null
                                    : () => _run(() async {
                                      final ids =
                                          assigned
                                              .map((m) => m.taskId)
                                              .toList();
                                      final moved = ids.removeAt(i);
                                      ids.insert(i - 1, moved);
                                      await service.store.reorder(
                                        ids,
                                        groupId: widget.id,
                                      );
                                    }),
                          ),
                          trailing: IconButton(
                            tooltip: 'Aus Gruppe entfernen',
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed:
                                () => _run(
                                  () => service.store.remove(
                                    assigned[i].taskId,
                                    widget.id,
                                  ),
                                ),
                          ),
                        ),
                      const Divider(),
                      const Text('Vorhandene Einträge hinzufügen'),
                      for (final t in ts.data!.where(
                        (t) => !assigned.any((m) => m.taskId == t.id),
                      ))
                        ListTile(
                          title: Text(t.name),
                          subtitle: Text(
                            ms.data!.any((m) => m.taskId == t.id)
                                ? 'Bereits in ${gs.data!.firstWhere((g) => g.id == ms.data!.firstWhere((m) => m.taskId == t.id).groupId).name}'
                                : 'Nicht zugeordnet',
                          ),
                          trailing: const Icon(Icons.add),
                          onTap:
                              () => _run(() async {
                                final old =
                                    ms.data!
                                        .where((m) => m.taskId == t.id)
                                        .firstOrNull;
                                if (old != null) {
                                  final yes = await showDialog<bool>(
                                    context: context,
                                    builder:
                                        (context) => AlertDialog(
                                          title: const Text(
                                            'Eintrag verschieben?',
                                          ),
                                          content: Text(
                                            '„${t.name}“ aus „${gs.data!.firstWhere((g) => g.id == old.groupId).name}“ in „${group.name}“ verschieben?',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed:
                                                  () => Navigator.pop(
                                                    context,
                                                    false,
                                                  ),
                                              child: const Text('Abbrechen'),
                                            ),
                                            TextButton(
                                              onPressed:
                                                  () => Navigator.pop(
                                                    context,
                                                    true,
                                                  ),
                                              child: const Text('Verschieben'),
                                            ),
                                          ],
                                        ),
                                  );
                                  if (yes != true) return;
                                }
                                await service.store.assign(
                                  t.id,
                                  widget.id,
                                  expectedPreviousGroup: old?.groupId,
                                );
                              }),
                        ),
                      const Divider(),
                      TextButton.icon(
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Gruppe löschen'),
                        onPressed:
                            () => _run(() async {
                              final yes = await showDialog<bool>(
                                context: context,
                                builder:
                                    (context) => AlertDialog(
                                      title: const Text('Gruppe löschen?'),
                                      content: const Text(
                                        'Die enthaltenen Aufgaben und Messwerte bleiben erhalten und erscheinen wieder in ihren normalen Tabs.',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed:
                                              () => Navigator.pop(context),
                                          child: const Text('Abbrechen'),
                                        ),
                                        TextButton(
                                          onPressed:
                                              () =>
                                                  Navigator.pop(context, true),
                                          child: const Text('Löschen'),
                                        ),
                                      ],
                                    ),
                              );
                              if (yes == true) {
                                await service.store.delete(widget.id);
                                if (context.mounted) Navigator.pop(context);
                              }
                            }),
                      ),
                    ],
                  );
                },
              ),
        );
      },
    ),
  );
}
