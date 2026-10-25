import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../data/calendar_clock.dart';
import '../data/calendar_planning.dart';
import '../data/calendar_projection.dart';
import 'calendar_planning_field.dart';

typedef CalendarChange =
    Future<void> Function(CalendarOccurrence, DateTime, CalendarPlanning);

/// Greedy overlap lanes; one common lane count per connected overlap group.
Map<CalendarOccurrence, (int, int)> calendarLanes(
  List<CalendarOccurrence> input,
) {
  final items = [...input]
    ..sort((a, b) => a.visibleStart!.compareTo(b.visibleStart!));
  final result = <CalendarOccurrence, (int, int)>{};
  var group = <CalendarOccurrence>[];
  var groupEnd = -1;
  void flush() {
    final ends = <int>[];
    final lanes = <CalendarOccurrence, int>{};
    for (final item in group) {
      var lane = ends.indexWhere((end) => end <= item.visibleStart!);
      if (lane < 0) {
        lane = ends.length;
        ends.add(0);
      }
      ends[lane] = item.visibleStart! + item.planning.durationMinutes!;
      lanes[item] = lane;
    }
    for (final item in group) {
      result[item] = (lanes[item]!, ends.length);
    }
  }

  for (final item in items) {
    if (item.visibleStart! >= groupEnd) {
      flush();
      group = [];
      groupEnd = -1;
    }
    group.add(item);
    groupEnd = math.max(
      groupEnd,
      item.visibleStart! + item.planning.durationMinutes!,
    );
  }
  flush();
  return result;
}

class CalendarTimeline extends StatelessWidget {
  const CalendarTimeline({
    super.key,
    required this.start,
    required this.days,
    required this.range,
    required this.onDetails,
    required this.onChange,
  });
  final DateTime start;
  final int days;
  final CalendarRange range;
  final ValueChanged<CalendarOccurrence> onDetails;
  final CalendarChange onChange;
  static const minuteHeight = 1.0;

  Future<void> _drop(
    BuildContext context,
    CalendarOccurrence item,
    DateTime day,
    int? minute,
  ) async {
    if (!item.canMove) return;
    var duration = item.planning.durationMinutes;
    if (minute != null && duration == null) {
      final value = await showCalendarPlanningDialog(
        context,
        const CalendarPlanning(),
      );
      if (value == null || value.durationMinutes == null) return;
      duration = value.durationMinutes;
    }
    await onChange(
      item,
      day,
      CalendarPlanning(startMinute: minute, durationMinutes: duration),
    );
  }

  Widget _draggable(CalendarOccurrence item, Widget child) =>
      !item.canMove
          ? child
          : LongPressDraggable<CalendarOccurrence>(
            data: item,
            dragAnchorStrategy: pointerDragAnchorStrategy,
            feedback: Material(
              elevation: 4,
              child: SizedBox(
                width: 150,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(item.task.name),
                ),
              ),
            ),
            childWhenDragging: Opacity(opacity: .35, child: child),
            child: child,
          );
  Widget _dayDrop(BuildContext context, DateTime day, String label) => Expanded(
    child: DragTarget<CalendarOccurrence>(
      onWillAcceptWithDetails: (details) => details.data.canMove,
      onAcceptWithDetails:
          (details) => _drop(
            context,
            details.data,
            day,
            details.data.planning.startMinute,
          ),
      builder:
          (context, candidates, _) => Container(
            padding: const EdgeInsets.all(12),
            color:
                candidates.isEmpty
                    ? Colors.transparent
                    : Theme.of(context).colorScheme.secondaryContainer,
            child: Text(label, textAlign: TextAlign.center),
          ),
    ),
  );

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final width =
          days == 1
              ? math.max(120.0, constraints.maxWidth - 44)
              : math.max(110.0, (constraints.maxWidth - 44) / days);
      return Column(
        children: [
          if (days == 1)
            Row(
              children: [
                _dayDrop(
                  context,
                  calendarAddDays(start, -1),
                  '← Vortag (Ablegen)',
                ),
                _dayDrop(
                  context,
                  calendarAddDays(start, 1),
                  'Folgetag (Ablegen) →',
                ),
              ],
            ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: 44 + width * days,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(width: 44),
                          for (var i = 0; i < days; i++)
                            SizedBox(
                              width: width,
                              child: _untimed(
                                context,
                                calendarAddDays(start, i),
                              ),
                            ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 44,
                            height: 1440 * minuteHeight,
                            child: Stack(
                              children: [
                                for (var h = 0; h < 24; h++)
                                  Positioned(
                                    top: h * 60 * minuteHeight,
                                    child: Text(
                                      '${h.toString().padLeft(2, '0')}:00',
                                      style: const TextStyle(fontSize: 11),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          for (var i = 0; i < days; i++)
                            SizedBox(
                              width: width,
                              child: _column(
                                context,
                                calendarAddDays(start, i),
                                width,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    },
  );

  Widget _untimed(
    BuildContext context,
    DateTime day,
  ) => DragTarget<CalendarOccurrence>(
    onWillAcceptWithDetails: (details) => details.data.canMove,
    onAcceptWithDetails: (details) => _drop(context, details.data, day, null),
    builder:
        (context, candidates, _) => Container(
          padding: const EdgeInsets.all(3),
          color:
              candidates.isEmpty
                  ? null
                  : Theme.of(context).colorScheme.secondaryContainer,
          constraints: const BoxConstraints(minHeight: 95),
          child: Column(
            children: [
              Text(
                '${const ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'][day.weekday - 1]} ${day.day}.${day.month}.',
              ),
              Text('${range.onDay(day).length} Termine'),
              const Text('Ohne Uhrzeit', style: TextStyle(fontSize: 11)),
              for (final item in range
                  .onDay(day)
                  .where((e) => e.visibleStart == null))
                _draggable(
                  item,
                  InkWell(
                    onTap: () => onDetails(item),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text(
                        '${item.canMove ? '♧' : '🔒'} ${item.task.name}${item.planning.durationMinutes == null ? '' : ' · ${item.planning.durationMinutes} Min.'}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              if (range.unknown.any((u) => u.earliest == day))
                Text(
                  '+${range.unknown.where((u) => u.earliest == day).length}? frühestens',
                ),
            ],
          ),
        ),
  );

  Widget _column(BuildContext context, DateTime day, double width) {
    final items =
        range.onDay(day).where((e) => e.visibleStart != null).toList();
    final lanes = calendarLanes(items);
    return Builder(
      builder:
          (columnContext) => DragTarget<CalendarOccurrence>(
            onWillAcceptWithDetails: (details) => details.data.canMove,
            onAcceptWithDetails: (details) {
              final box = columnContext.findRenderObject()! as RenderBox;
              final minute = ((box.globalToLocal(details.offset).dy /
                              minuteHeight /
                              15)
                          .round() *
                      15)
                  .clamp(0, 1425);
              _drop(context, details.data, day, minute);
            },
            builder:
                (context, candidates, _) => SizedBox(
                  height: 1440 * minuteHeight,
                  child: Stack(
                    children: [
                      for (var hour = 0; hour < 24; hour++)
                        Positioned(
                          top: hour * 60 * minuteHeight,
                          left: 0,
                          right: 0,
                          child: Divider(
                            height: 1,
                            color: Theme.of(context).dividerColor,
                          ),
                        ),
                      for (final item in items)
                        Positioned(
                          top: item.visibleStart! * minuteHeight,
                          left: lanes[item]!.$1 * width / lanes[item]!.$2,
                          width: width / lanes[item]!.$2 - 2,
                          height: math.max(
                            24.0,
                            item.planning.durationMinutes! * minuteHeight,
                          ),
                          child: _draggable(
                            item,
                            _CalendarBlock(
                              item: item,
                              onDetails: () => onDetails(item),
                              onResize:
                                  (delta) => onChange(
                                    item,
                                    day,
                                    CalendarPlanning(
                                      startMinute: item.planning.startMinute,
                                      durationMinutes: math.max(
                                        15,
                                        ((item.planning.durationMinutes! +
                                                        delta / minuteHeight) /
                                                    15)
                                                .round() *
                                            15,
                                      ),
                                    ),
                                  ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
          ),
    );
  }
}

class _CalendarBlock extends StatelessWidget {
  const _CalendarBlock({
    required this.item,
    required this.onDetails,
    required this.onResize,
  });
  final CalendarOccurrence item;
  final VoidCallback onDetails;
  final ValueChanged<double> onResize;
  @override
  Widget build(BuildContext context) {
    var drag = 0.0;
    final hex = item.project?.colorHex.replaceFirst('#', '');
    final color =
        hex == null
            ? Theme.of(context).colorScheme.primaryContainer
            : Color(0xff000000 | (int.tryParse(hex, radix: 16) ?? 0x5b67d6));
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(4),
      child: Column(
        children: [
          Expanded(
            child: InkWell(
              onTap: onDetails,
              child: SizedBox.expand(
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Text(
                    '${item.canMove ? '◇' : '🔒'} ${item.task.name}\n${item.entry?.status ?? 'Vorschau'}',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      color:
                          ThemeData.estimateBrightnessForColor(color) ==
                                  Brightness.dark
                              ? Colors.white
                              : Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (item.canMove)
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onVerticalDragStart: (_) => drag = 0,
              onVerticalDragUpdate: (details) => drag += details.delta.dy,
              onVerticalDragEnd: (_) => onResize(drag),
              child: const SizedBox(
                height: 12,
                width: double.infinity,
                child: Icon(Icons.drag_handle, size: 12),
              ),
            ),
        ],
      ),
    );
  }
}
