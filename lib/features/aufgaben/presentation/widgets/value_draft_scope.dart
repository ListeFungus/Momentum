import 'package:flutter/material.dart';
import '../../data/task_value_draft.dart';

/// Lives above cards/groups so collapsing, moving and stream updates cannot
/// discard a draft. Keys include the actual scheduled day, never just task ID.
class ValueDraftStore extends ChangeNotifier {
  final drafts = <String, TaskValueDraft>{};
  final errors = <String, String>{};
  final savers = <String, Future<void> Function()>{};
  final anchors = <String, GlobalKey>{};
  GlobalKey anchor(String key) => anchors.putIfAbsent(key, () => GlobalKey());
  void changed(String key, TaskValueDraft value, Future<void> Function() save) {
    drafts[key] = value;
    savers[key] = save;
    errors.remove(key);
  }

  void saved(Iterable<String> keys) {
    for (final key in keys) {
      drafts.remove(key);
      savers.remove(key);
      errors.remove(key);
    }
    notifyListeners();
  }

  void mark(Map<String, String> values) {
    errors.addAll(values);
    notifyListeners();
  }

  void discard() {
    drafts.clear();
    errors.clear();
    savers.clear();
    notifyListeners();
  }

  bool _asking = false;
  Future<bool> confirm(BuildContext context) async {
    if (drafts.isEmpty) return true;
    if (_asking) return false;
    _asking = true;
    try {
      final choice = await showDialog<String>(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Ungespeicherte Eingaben'),
              content: const Text(
                'Eingaben vor dem Wechsel speichern oder verwerfen?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Abbrechen'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, 'discard'),
                  child: const Text('Verwerfen'),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(context, 'save'),
                  child: const Text('Speichern'),
                ),
              ],
            ),
      );
      if (choice == 'discard') {
        discard();
        return true;
      }
      if (choice != 'save') return false;
      try {
        for (final key in drafts.keys.toList()) {
          final save = savers[key];
          if (save == null) {
            throw StateError('Bitte den betroffenen Eintrag erneut öffnen.');
          }
          await save();
        }
        return drafts.isEmpty;
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(e.toString())));
        }
        return false;
      }
    } finally {
      _asking = false;
    }
  }
}

class ValueDraftScope extends InheritedWidget {
  const ValueDraftScope({required this.store, required super.child, super.key});
  final ValueDraftStore store;
  static ValueDraftStore? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ValueDraftScope>()?.store;
  static Future<bool> confirm(BuildContext context) async =>
      await maybeOf(context)?.confirm(context) ?? true;
  @override
  bool updateShouldNotify(ValueDraftScope old) => old.store != store;
}
