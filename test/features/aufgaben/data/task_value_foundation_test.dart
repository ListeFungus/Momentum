import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/features/aufgaben/data/task_entry_status.dart';
import 'package:momentum/features/aufgaben/data/task_value_bundle.dart';
import 'package:momentum/features/aufgaben/data/task_value_commitment.dart';
import 'package:momentum/features/aufgaben/data/task_value_type.dart';
import 'package:momentum/features/aufgaben/data/task_value_unit.dart';

void main() {
  test('recorded ist ein abgeschlossener Wertstatus', () {
    expect(TaskEntryStatus.values, contains(TaskEntryStatus.recorded));
    expect(TaskEntryStatus.isFinal(TaskEntryStatus.recorded), isTrue);
    expect(TaskEntryStatus.isResolved(TaskEntryStatus.recorded), isTrue);
    expect(
      TaskEntryStatus.isPositiveCompletion(TaskEntryStatus.recorded),
      isTrue,
    );
  });

  test('Phase-12-Werttypen sind zentral benannt', () {
    expect(TaskValueType.phase12Values, {
      TaskValueType.number,
      TaskValueType.duration,
      TaskValueType.timeOfDay,
    });
  });

  test('Verbindlichkeit unterscheidet reines Tracking und Pflichtwerte', () {
    expect(TaskValueCommitment.values, contains(TaskValueCommitment.none));
    expect(
      TaskValueCommitment.values,
      contains(TaskValueCommitment.pureTracking),
    );
    expect(TaskValueCommitment.values, contains(TaskValueCommitment.required));
  });

  test('bekannte Einheiten decken die beschlossenen Familien ab', () {
    expect(
      TaskValueUnits.byKey(TaskValueUnitKey.liter)?.family,
      TaskValueUnitFamily.volume,
    );
    expect(
      TaskValueUnits.byKey(TaskValueUnitKey.milliliter)?.family,
      TaskValueUnitFamily.volume,
    );
    expect(
      TaskValueUnits.byKey(TaskValueUnitKey.kilometer)?.family,
      TaskValueUnitFamily.distance,
    );
    expect(
      TaskValueUnits.byKey(TaskValueUnitKey.centimeter)?.family,
      TaskValueUnitFamily.distance,
    );
    expect(
      TaskValueUnits.byKey(TaskValueUnitKey.hour)?.family,
      TaskValueUnitFamily.duration,
    );
    expect(
      TaskValueUnits.byKey(TaskValueUnitKey.second)?.family,
      TaskValueUnitFamily.duration,
    );
    expect(
      TaskValueUnits.byKey(TaskValueUnitKey.timeOfDay)?.family,
      TaskValueUnitFamily.time,
    );
  });

  test('Phase-12-Buendeltypen sind vorbereitet', () {
    expect(TaskValueBundleType.values, {
      TaskValueBundleType.timeInterval,
      TaskValueBundleType.difference,
      TaskValueBundleType.sum,
    });
  });
}
