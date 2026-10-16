import 'package:flutter/material.dart';
import 'package:momentum/core/settings/card_display_repository.dart';
import 'package:momentum/core/settings/card_display_scope.dart';

class OptionsScreen extends StatelessWidget {
  const OptionsScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Optionen')),
    body: ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.view_agenda_outlined),
          title: const Text('Kartenanzeige'),
          subtitle: const Text('Startansicht und Aufklappen'),
          trailing: const Icon(Icons.chevron_right),
          onTap:
              () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const CardDisplayOptionsScreen(),
                ),
              ),
        ),
      ],
    ),
  );
}

class CardDisplayOptionsScreen extends StatefulWidget {
  const CardDisplayOptionsScreen({super.key});

  @override
  State<CardDisplayOptionsScreen> createState() =>
      _CardDisplayOptionsScreenState();
}

class _CardDisplayOptionsScreenState extends State<CardDisplayOptionsScreen> {
  bool _saving = false;

  Future<void> _save({CardDisplayMode? mode, bool? singleOpen}) async {
    final repository = CardDisplayScope.maybeOf(context)!.repository;
    setState(() => _saving = true);
    try {
      await repository.configure(mode: mode, singleOpen: singleOpen);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Einstellung konnte nicht gespeichert werden. Bitte erneut versuchen.',
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = CardDisplayScope.maybeOf(context)!.preferences;
    return Scaffold(
      appBar: AppBar(title: const Text('Kartenanzeige')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Gilt für Aufgaben, Habits, Tracker und Bündel – auch bei abgeschlossenen Aufgaben.',
            ),
          ),
          const SizedBox(height: 12),
          for (final mode in CardDisplayMode.values)
            RadioListTile<CardDisplayMode>(
              title: Text(switch (mode) {
                CardDisplayMode.compact => 'Kompakt starten',
                CardDisplayMode.expanded => 'Aufgeklappt starten',
                CardDisplayMode.remember => 'Letzten Zustand merken',
              }),
              subtitle: Text(switch (mode) {
                CardDisplayMode.compact =>
                  'Beim Öffnen der Ansicht und beim Datumswechsel sind Karten eingeklappt.',
                CardDisplayMode.expanded =>
                  'Beim Öffnen der Ansicht und beim Datumswechsel sind alle Karten aufgeklappt.',
                CardDisplayMode.remember =>
                  'Je Aufgabe oder Bündel merken – auch für andere Tage und nach einem Neustart.',
              }),
              value: mode,
              groupValue: settings.mode,
              onChanged: _saving ? null : (value) => _save(mode: value),
            ),
          const Divider(),
          SwitchListTile(
            title: const Text('Nur eine Karte gleichzeitig aufklappen'),
            subtitle: Text(
              settings.mode == CardDisplayMode.expanded
                  ? 'Bei „Aufgeklappt starten“ nicht anwendbar. Deine Auswahl bleibt für die anderen Modi gespeichert.'
                  : 'Beim Öffnen einer Karte schließt die vorherige. Ausgeschaltet können mehrere Karten offen bleiben.',
            ),
            value: settings.singleOpen,
            onChanged:
                _saving || settings.mode == CardDisplayMode.expanded
                    ? null
                    : (value) => _save(singleOpen: value),
          ),
          const Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Du kannst Karten in jedem Modus manuell öffnen und schließen. Einstellungen und gemerkte Zustände werden mitgesichert.',
            ),
          ),
        ],
      ),
    );
  }
}
