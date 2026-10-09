import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/features/aufgaben/data/task_goal.dart';
import 'package:momentum/features/aufgaben/data/task_value_type.dart';
import 'package:momentum/features/aufgaben/presentation/widgets/task_goal_field.dart';

void main() {
  testWidgets('Zielauswahl zeigt fuer Statusaufgaben keine Wertziele', (
    tester,
  ) async {
    await tester.pumpWidget(
      _TestHost(
        child: TaskGoalField(
          selectedGoalType: TaskGoalType.none,
          goalValue: 1,
          goalWindowDays: 7,
          selectedPeriod: GoalPeriod.week,
          selectedPeriodAlignment: GoalPeriodAlignment.calendar,
          supportsPeriodGoals: true,
          valueType: TaskValueType.none,
          onGoalTypeChanged: (_) {},
          onGoalValueChanged: (_) {},
          onGoalWindowDaysChanged: (_) {},
          onPeriodChanged: (_) {},
          onPeriodAlignmentChanged: (_) {},
        ),
      ),
    );

    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();

    expect(find.text('Anzahl pro Zeitraum'), findsOneWidget);
    expect(find.text('Mindestens Summe in X Tagen'), findsNothing);
    expect(
      find.text(
        'Für diese Aufgabe werden Statusziele angeboten. Wertziele erscheinen bei Zahl- oder Dauer-Erfassung.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('Zielauswahl zeigt fuer Buendel nur Wertziele', (tester) async {
    await tester.pumpWidget(
      _TestHost(
        child: TaskGoalField(
          selectedGoalType: TaskGoalType.none,
          goalValue: 1,
          goalWindowDays: 7,
          selectedPeriod: GoalPeriod.week,
          selectedPeriodAlignment: GoalPeriodAlignment.calendar,
          supportsPeriodGoals: true,
          valueType: TaskValueType.number,
          valueGoalsOnly: true,
          onGoalTypeChanged: (_) {},
          onGoalValueChanged: (_) {},
          onGoalWindowDaysChanged: (_) {},
          onPeriodChanged: (_) {},
          onPeriodAlignmentChanged: (_) {},
        ),
      ),
    );

    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();

    expect(find.text('Anzahl pro Zeitraum'), findsNothing);
    expect(find.text('Mindestens Summe in X Tagen'), findsOneWidget);
    expect(find.text('Mindestens Durchschnitt in X Tagen'), findsOneWidget);
  });

  testWidgets('Zielauswahl blendet Summenziel fuer Zeitintervall-Buendel aus', (
    tester,
  ) async {
    await tester.pumpWidget(
      _TestHost(
        child: TaskGoalField(
          selectedGoalType: TaskGoalType.valueSumMin,
          goalValue: 1,
          goalWindowDays: 7,
          selectedPeriod: GoalPeriod.week,
          selectedPeriodAlignment: GoalPeriodAlignment.calendar,
          supportsPeriodGoals: true,
          valueType: TaskValueType.duration,
          allowValueSumGoal: false,
          valueGoalsOnly: true,
          onGoalTypeChanged: (_) {},
          onGoalValueChanged: (_) {},
          onGoalWindowDaysChanged: (_) {},
          onPeriodChanged: (_) {},
          onPeriodAlignmentChanged: (_) {},
        ),
      ),
    );

    expect(find.text('Kein Ziel'), findsOneWidget);
    expect(
      find.text(
        'Dieses Bündel nutzt Wertziele. Zeitintervalle unterstützen aktuell Durchschnittsziele, aber keine Summenziele.',
      ),
      findsOneWidget,
    );

    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();

    expect(find.text('Mindestens Summe in X Tagen'), findsNothing);
    expect(find.text('Mindestens Durchschnitt in X Tagen'), findsOneWidget);
  });
}

class _TestHost extends StatelessWidget {
  const _TestHost({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(padding: const EdgeInsets.all(16), child: child),
      ),
    );
  }
}
