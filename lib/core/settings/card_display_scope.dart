import 'package:flutter/material.dart';
import 'package:momentum/core/settings/card_display_repository.dart';

final cardDisplayRouteObserver = RouteObserver<PageRoute<dynamic>>();

class CardDisplayHost extends StatefulWidget {
  const CardDisplayHost({
    required this.repository,
    required this.child,
    super.key,
  });
  final CardDisplayRepository repository;
  final Widget child;

  @override
  State<CardDisplayHost> createState() => _CardDisplayHostState();
}

class _CardDisplayHostState extends State<CardDisplayHost> {
  late final _preferences = widget.repository.watch();

  @override
  Widget build(BuildContext context) => StreamBuilder<CardDisplayPreferences>(
    stream: _preferences,
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return Scaffold(
          body: Center(
            child:
                snapshot.hasError
                    ? const Text(
                      'Anzeigeeinstellungen konnten nicht geladen werden.',
                    )
                    : const CircularProgressIndicator(),
          ),
        );
      }
      return CardDisplayScope(
        repository: widget.repository,
        preferences: snapshot.data!,
        child: widget.child,
      );
    },
  );
}

class CardDisplayScope extends InheritedWidget {
  const CardDisplayScope({
    required this.repository,
    required this.preferences,
    required super.child,
    super.key,
  });
  final CardDisplayRepository repository;
  final CardDisplayPreferences preferences;

  static CardDisplayScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<CardDisplayScope>();

  @override
  bool updateShouldNotify(CardDisplayScope oldWidget) =>
      preferences != oldWidget.preferences;
}

/// Entity identity is remembered across dates; input/visible identity is not.
class DisplayCardIdentity {
  DisplayCardIdentity.task(String id, DateTime date)
    : entityKey = 'task:$id',
      instanceKey = 'task:$id:${DateUtils.dateOnly(date).toIso8601String()}';
  DisplayCardIdentity.bundle(String id, DateTime date)
    : entityKey = 'bundle:$id',
      instanceKey = 'bundle:$id:${DateUtils.dateOnly(date).toIso8601String()}';
  final String entityKey;
  final String instanceKey;
}

/// One visible list coordinates expansion across project sections and card types.
class CardDisplaySession extends StatefulWidget {
  const CardDisplaySession({
    required this.cards,
    required this.child,
    super.key,
  });
  final List<DisplayCardIdentity> cards;
  final Widget child;

  @override
  State<CardDisplaySession> createState() => _CardDisplaySessionState();
}

class _CardDisplaySessionState extends State<CardDisplaySession>
    with RouteAware {
  final Map<String, int> _manual = {};
  int _order = 0;
  String? _selectedInstance;
  CardDisplayPreferences _preferences = const CardDisplayPreferences();
  PageRoute<dynamic>? _route;
  bool _saving = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final next =
        CardDisplayScope.maybeOf(context)?.preferences ??
        const CardDisplayPreferences();
    if (next.mode != _preferences.mode) {
      _manual.clear();
      _selectedInstance = null;
    } else if (next.restrictToOne && !_preferences.restrictToOne) {
      final opened =
          _manual.entries.where((entry) => entry.value > 0).toList()
            ..sort((a, b) => b.value.compareTo(a.value));
      for (final entry in opened.skip(1)) {
        _manual[entry.key] = -1;
      }
    }
    _preferences = next;
    final modalRoute = ModalRoute.of(context);
    final route = modalRoute is PageRoute ? modalRoute : null;
    if (route != _route) {
      cardDisplayRouteObserver.unsubscribe(this);
      _route = route;
      if (route != null) cardDisplayRouteObserver.subscribe(this, route);
    }
  }

  @override
  void didPopNext() {
    setState(() {
      _manual.clear();
      _selectedInstance = null;
    });
  }

  @override
  void dispose() {
    cardDisplayRouteObserver.unsubscribe(this);
    super.dispose();
  }

  bool _expanded(DisplayCardIdentity card) {
    if (_preferences.mode != CardDisplayMode.remember) {
      return _manual.containsKey(card.instanceKey)
          ? _manual[card.instanceKey]! > 0
          : _preferences.mode == CardDisplayMode.expanded;
    }
    if (!_preferences.opened.containsKey(card.entityKey)) return false;
    if (!_preferences.restrictToOne) return true;
    final candidates =
        widget.cards
            .where((c) => _preferences.opened.containsKey(c.entityKey))
            .toList()
          ..sort((a, b) {
            final order = _preferences.opened[b.entityKey]!.compareTo(
              _preferences.opened[a.entityKey]!,
            );
            if (order != 0) return order;
            if (a.instanceKey == _selectedInstance) return -1;
            if (b.instanceKey == _selectedInstance) return 1;
            return a.instanceKey.compareTo(b.instanceKey);
          });
    return candidates.isNotEmpty &&
        candidates.first.instanceKey == card.instanceKey;
  }

  Future<void> _toggle(DisplayCardIdentity card) async {
    if (_saving) return;
    final expanded = !_expanded(card);
    final repository = CardDisplayScope.maybeOf(context)?.repository;
    if (_preferences.mode == CardDisplayMode.remember && repository != null) {
      setState(() => _saving = true);
      try {
        await repository.remember(
          entityKey: card.entityKey,
          expanded: expanded,
        );
        if (mounted) {
          setState(
            () => _selectedInstance = expanded ? card.instanceKey : null,
          );
        }
      } catch (_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Kartenanzeige konnte nicht gespeichert werden. Bitte erneut versuchen.',
              ),
            ),
          );
        }
      } finally {
        if (mounted) setState(() => _saving = false);
      }
      return;
    }
    setState(() {
      if (expanded && _preferences.restrictToOne) _manual.clear();
      _manual[card.instanceKey] = expanded ? ++_order : -1;
    });
  }

  @override
  Widget build(BuildContext context) => _CardSessionScope(
    expanded: _expanded,
    toggle: _saving ? null : _toggle,
    child: widget.child,
  );
}

class _CardSessionScope extends InheritedWidget {
  const _CardSessionScope({
    required this.expanded,
    required this.toggle,
    required super.child,
  });
  final bool Function(DisplayCardIdentity) expanded;
  final Future<void> Function(DisplayCardIdentity)? toggle;

  @override
  bool updateShouldNotify(_CardSessionScope oldWidget) => true;
}

/// Gives standalone cards a usable compact default as well as shared list control.
class ExpandableCardContent extends StatefulWidget {
  const ExpandableCardContent({
    required this.identity,
    required this.builder,
    super.key,
  });
  final DisplayCardIdentity identity;
  final Widget Function(BuildContext, bool, Widget) builder;

  @override
  State<ExpandableCardContent> createState() => _ExpandableCardContentState();
}

class _ExpandableCardContentState extends State<ExpandableCardContent> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final session =
        context.dependOnInheritedWidgetOfExactType<_CardSessionScope>();
    final expanded = session?.expanded(widget.identity) ?? _expanded;
    return widget.builder(
      context,
      expanded,
      IconButton(
        tooltip: expanded ? 'Karte einklappen' : 'Karte aufklappen',
        isSelected: expanded,
        icon: Icon(expanded ? Icons.expand_less : Icons.expand_more),
        onPressed:
            session == null
                ? () => setState(() => _expanded = !_expanded)
                : session.toggle == null
                ? null
                : () => session.toggle!(widget.identity),
      ),
    );
  }
}
