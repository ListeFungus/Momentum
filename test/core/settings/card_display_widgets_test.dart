import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/core/database/app_database.dart';
import 'package:momentum/core/settings/card_display_repository.dart';
import 'package:momentum/core/settings/card_display_scope.dart';
import 'package:momentum/features/aufgaben/data/aufgaben_repository.dart';
import 'package:momentum/features/aufgaben/data/task_card_metric.dart';
import 'package:momentum/features/aufgaben/data/task_for_date.dart';
import 'package:momentum/features/aufgaben/data/task_value_bundle_for_date.dart';
import 'package:momentum/features/aufgaben/presentation/widgets/task_card.dart';
import 'package:momentum/features/aufgaben/presentation/widgets/task_value_bundle_card.dart';

final day = DateTime(2026, 10, 16);

TaskCard taskCard(TaskForDate task, {VoidCallback? completed}) => TaskCard(
  task: task,
  scheduledDate: day,
  onCompletedChanged: (_) => completed?.call(),
  onBooleanValueChanged: (_) {},
  onValueSaved: (_) {},
  onEditNote: () {},
  onOpenDetails: () {},
  onEdit: () {},
  onDelete: () {},
  onConfigureCardMetric: () {},
);

void main() {
  late AppDatabase db;
  late TaskForDate task;
  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    await AufgabenRepository(db, now: () => day).createTask(
      name: 'Gewicht',
      beschreibung: 'Ausführliche Beschreibung',
      erfassungsmodus: 'checkbox',
      taskType: 'task',
      recurrence: 'none',
      projectId: null,
    );
    task = TaskForDate(
      task: await db.select(db.aufgaben).getSingle(),
      entry: null,
      entryValue: null,
      project: null,
      cardMetrics: const [
        TaskCardMetric(
          label: 'Fortschritt',
          value: '75 %',
          tone: TaskCardMetricTone.neutral,
        ),
      ],
    );
  });
  tearDown(() async => db.close());

  testWidgets(
    'compact checkbox works; details and selected metrics expand without overflow',
    (tester) async {
      tester.view.physicalSize = const Size(320, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      var completed = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: taskCard(task, completed: () => completed++),
              ),
            ),
          ),
        ),
      );
      expect(find.text('Ausführliche Beschreibung'), findsNothing);
      expect(find.text('75 %'), findsNothing);
      await tester.tap(find.byType(Checkbox));
      expect(completed, 1);
      await tester.tap(find.byTooltip('Karte aufklappen'));
      await tester.pump();
      expect(find.text('Ausführliche Beschreibung'), findsOneWidget);
      expect(find.text('75 %'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets('value draft and validation survive repeated folding', (
    tester,
  ) async {
    final valueTask = TaskForDate(
      task: task.task.copyWith(
        erfassungsmodus: 'value',
        valueType: 'number',
        valueUnitLabel: 'kg',
        valueUnitKey: 'custom',
      ),
      entry: null,
      entryValue: null,
      project: null,
      cardMetrics: task.cardMetrics,
    );
    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: taskCard(valueTask))),
    );
    await tester.enterText(find.byType(TextField), ',');
    await tester.tap(find.text('Speichern'));
    await tester.pump();
    expect(find.text('Bitte gib eine gültige Zahl ein.'), findsOneWidget);
    await tester.tap(find.byTooltip('Karte aufklappen'));
    await tester.pump();
    await tester.tap(find.byTooltip('Karte einklappen'));
    await tester.pump();
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      ',',
    );
    expect(find.text('Bitte gib eine gültige Zahl ein.'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets(
    'bundle inputs retain drafts when single mode automatically closes them',
    (tester) async {
      await tester.runAsync(() async {
        await AufgabenRepository(db, now: () => day).createTask(
          name: 'Zweiter Wert',
          beschreibung: '',
          erfassungsmodus: 'checkbox',
          projectId: null,
        );
        final other = (await db.select(db.aufgaben).get()).firstWhere(
          (row) => row.id != task.task.id,
        );
        await db.customStatement(
          "INSERT INTO task_value_bundles (id, updated_at) VALUES ('b', 1234)",
        );
        await db.customStatement(
          "INSERT INTO task_value_bundle_versions (id, bundle_id, version_number, valid_from, bundle_type, first_task_id, second_task_id) VALUES ('bv', 'b', 1, 1234, 'difference', ?, ?)",
          [task.task.id, other.id],
        );
      });
      final rows = await tester.runAsync(
        () async => (
          await db.select(db.taskValueBundles).getSingle(),
          await db.select(db.taskValueBundleVersions).getSingle(),
        ),
      );
      final valueTask = TaskForDate(
        task: task.task.copyWith(erfassungsmodus: 'value', valueType: 'number'),
        entry: null,
        entryValue: null,
        project: null,
      );
      final bundle = TaskValueBundleForDate(
        scheduledDate: day,
        bundle: rows!.$1,
        version: rows.$2,
        firstTask: valueTask,
        secondTask: valueTask,
        calculation: null,
        status: 'empty',
      );
      final identities = [
        DisplayCardIdentity.bundle('b', day),
        DisplayCardIdentity.task(task.task.id, day),
      ];
      await tester.pumpWidget(
        MaterialApp(
          home: CardDisplayScope(
            repository: CardDisplayRepository(db),
            preferences: const CardDisplayPreferences(singleOpen: true),
            child: Scaffold(
              body: SingleChildScrollView(
                child: CardDisplaySession(
                  cards: identities,
                  child: Column(
                    children: [
                      TaskValueBundleCard(
                        bundle: bundle,
                        scheduledDate: day,
                        onValueSaved: (_, _) {},
                        onOpenDetails: () {},
                        onConfigureCardMetric: () {},
                        onDissolve: () {},
                        onDelete: () {},
                      ),
                      taskCard(task),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      expect(find.byType(TextField), findsNothing);
      expect(find.text('Ergebnis: Noch kein Ergebnis'), findsOneWidget);
      await tester.tap(find.byTooltip('Karte aufklappen').first);
      await tester.pump();
      await tester.enterText(find.byType(TextField).first, '72,5');
      await tester.ensureVisible(find.byTooltip('Karte aufklappen'));
      await tester.tap(find.byTooltip('Karte aufklappen'));
      await tester.pump();
      expect(find.byType(TextField), findsNothing);
      expect(find.byTooltip('Karte einklappen'), findsOneWidget);
      await tester.ensureVisible(find.byTooltip('Karte aufklappen'));
      await tester.tap(find.byTooltip('Karte aufklappen'));
      await tester.pump();
      expect(
        tester.widget<TextField>(find.byType(TextField).first).controller!.text,
        '72,5',
      );
      expect(find.byTooltip('Karte einklappen'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets(
    'remembered entity follows dates but single mode never opens duplicate instances',
    (tester) async {
      var date = day;
      var preferences = CardDisplayPreferences(
        mode: CardDisplayMode.remember,
        singleOpen: true,
        opened: {'task:${task.task.id}': 1},
      );
      Widget screen() {
        final cards = [
          DisplayCardIdentity.task(task.task.id, date),
          DisplayCardIdentity.task(
            task.task.id,
            date.add(const Duration(days: 1)),
          ),
        ];
        return MaterialApp(
          home: CardDisplayScope(
            repository: CardDisplayRepository(db),
            preferences: preferences,
            child: Scaffold(
              body: CardDisplaySession(
                key: ValueKey(date),
                cards: cards,
                child: Column(
                  children: [
                    for (final card in cards)
                      ExpandableCardContent(
                        identity: card,
                        builder:
                            (_, open, toggle) => Row(
                              children: [Text(open ? 'offen' : 'zu'), toggle],
                            ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      }

      await tester.pumpWidget(screen());
      expect(find.text('offen'), findsOneWidget);
      date = day.add(const Duration(days: 2));
      await tester.pumpWidget(screen());
      expect(find.text('offen'), findsOneWidget);
      preferences = const CardDisplayPreferences(
        mode: CardDisplayMode.expanded,
        singleOpen: true,
      );
      await tester.pumpWidget(screen());
      expect(find.text('offen'), findsNWidgets(2));
      await tester.tap(find.byTooltip('Karte einklappen').first);
      await tester.pump();
      expect(find.text('offen'), findsOneWidget);
      date = date.add(const Duration(days: 1));
      await tester.pumpWidget(screen());
      expect(find.text('offen'), findsNWidgets(2));
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );
}
