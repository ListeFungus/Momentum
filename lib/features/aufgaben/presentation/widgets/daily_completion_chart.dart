import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:momentum/features/aufgaben/data/aufgaben_repository.dart';
import 'package:momentum/features/aufgaben/data/daily_completion_summary.dart';

class DailyCompletionChart extends StatefulWidget {
  const DailyCompletionChart({required this.repository, super.key});
  final AufgabenRepository repository;
  @override
  State<DailyCompletionChart> createState() => _DailyCompletionChartState();
}

class _DailyCompletionChartState extends State<DailyCompletionChart>
    with WidgetsBindingObserver {
  DateTime? _endingOn;
  DateTime? _selectedDay;
  late DateTime _today;
  late Stream<DailyCompletionSummary> _stream;
  Timer? _timer;

  DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _today = _dateOnly(DateTime.now());
    _updateStream();
    _scheduleDayCheck();
  }

  void _updateStream() {
    _stream = widget.repository.watchDailyCompletionSummary(
      endingOn: _endingOn ?? _today,
    );
  }

  void _scheduleDayCheck() {
    _timer?.cancel();
    final now = DateTime.now();
    _timer = Timer(
      DateTime(now.year, now.month, now.day + 1).difference(now),
      _checkDay,
    );
  }

  void _checkDay() {
    final today = _dateOnly(DateTime.now());
    if (today != _today && mounted) {
      setState(() {
        _today = today;
        _selectedDay = null;
        _updateStream();
      });
    }
    _scheduleDayCheck();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _checkDay();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endingOn ?? _today,
      firstDate: DateTime(1900),
      lastDate: _today,
      helpText: 'Sieben Tage bis einschließlich',
      cancelText: 'Abbrechen',
      confirmText: 'Auswählen',
    );
    if (picked != null && mounted) {
      setState(() {
        _endingOn = picked == _today ? null : picked;
        _selectedDay = picked;
        _updateStream();
      });
    }
  }

  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.zero,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Erledigt in 7 Tagen',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const Text('Aufgaben & Habits · nach Erledigungstag'),
          Row(
            children: [
              Expanded(
                child: TextButton.icon(
                  onPressed: _pickDate,
                  icon: const Icon(Icons.calendar_month_outlined, size: 18),
                  label: Text(
                    _endingOn == null
                        ? 'Letzte 7 Tage'
                        : 'Bis ${_label(_endingOn!)}',
                  ),
                ),
              ),
              if (_endingOn != null)
                TextButton(
                  onPressed:
                      () => setState(() {
                        _endingOn = null;
                        _selectedDay = null;
                        _updateStream();
                      }),
                  child: const Text('Heute'),
                ),
            ],
          ),
          StreamBuilder<DailyCompletionSummary>(
            key: ValueKey(_endingOn ?? _today),
            stream: _stream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text(
                  'Die Tagesübersicht konnte nicht geladen werden.',
                );
              }
              if (!snapshot.hasData) {
                return const SizedBox(
                  height: 140,
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final summary = snapshot.data!;
              final maxCount = summary.days.fold(
                1,
                (value, day) => math.max(value, day.count),
              );
              final colors = Theme.of(context).colorScheme;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      for (final day in summary.days)
                        Expanded(
                          child: Semantics(
                            button: true,
                            selected: _selectedDay == day.date,
                            label: '${_label(day.date)}: ${day.count} erledigt',
                            child: InkWell(
                              onTap:
                                  () => setState(() => _selectedDay = day.date),
                              borderRadius: BorderRadius.circular(8),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 6,
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      '${day.count}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    SizedBox(
                                      height: 64,
                                      child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                          height:
                                              day.count == 0
                                                  ? 2
                                                  : 64 * day.count / maxCount,
                                          width: 22,
                                          decoration: BoxDecoration(
                                            color:
                                                day.count == 0
                                                    ? colors.outlineVariant
                                                    : _selectedDay == day.date
                                                    ? colors.tertiary
                                                    : colors.primary,
                                            borderRadius: BorderRadius.circular(
                                              5,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      const [
                                        'Mo',
                                        'Di',
                                        'Mi',
                                        'Do',
                                        'Fr',
                                        'Sa',
                                        'So',
                                      ][day.date.weekday - 1],
                                    ),
                                    Text(
                                      '${day.date.day}.',
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _selectedDay == null
                        ? '${summary.total} insgesamt · Tag antippen für Details'
                        : '${_label(_selectedDay!)}: ${summary.days.firstWhere((day) => day.date == _selectedDay).count} erledigt',
                  ),
                  if (summary.total == 0)
                    const Text('In diesem Zeitraum noch keine Erledigungen.'),
                  if (summary.unknownDateCount > 0)
                    Text(
                      '${summary.unknownDateCount} ältere Erledigungen ohne bekanntes Erledigungsdatum sind nicht zugeordnet.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                ],
              );
            },
          ),
        ],
      ),
    ),
  );

  String _label(DateTime date) => '${date.day}.${date.month}.${date.year}';
}
