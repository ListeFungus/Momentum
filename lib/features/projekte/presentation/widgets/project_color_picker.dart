import 'package:flutter/material.dart';
import 'package:momentum/core/theme/hex_color.dart';

const projectColorOptions = [
  '#5B67D6',
  '#7C5CE7',
  '#9B51E0',
  '#B44BC1',
  '#D65B8C',
  '#E0526F',
  '#D94B4B',
  '#E56B4A',
  '#ED8240',
  '#E3A12F',
  '#C6A52D',
  '#8FAE3C',
  '#5BAE57',
  '#3C9B78',
  '#2FA58D',
  '#24A6A6',
  '#2E8FA3',
  '#348CBF',
  '#527FC7',
  '#4169B1',
  '#667085',
  '#7A6F67',
  '#A06B52',
  '#C06C84',
];

class ProjectColorPicker extends StatelessWidget {
  const ProjectColorPicker({
    required this.selectedColorHex,
    required this.onChanged,
    this.usedColorHexes = const {},
    this.enabled = true,
    super.key,
  });

  final String selectedColorHex;
  final ValueChanged<String> onChanged;
  final Set<String> usedColorHexes;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Projektfarbe',
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        Text(
          'Diese Farbe kennzeichnet das Projekt und seine Aufgaben.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        if (usedColorHexes.isNotEmpty) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(
                Icons.check_circle,
                size: 15,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Text(
                'Markierte Farben werden bereits verwendet.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 14),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children:
              projectColorOptions.map((colorHex) {
                final color = colorFromHex(colorHex);
                final isSelected = colorHex == selectedColorHex;
                final isUsed = usedColorHexes.contains(colorHex);

                return Semantics(
                  button: true,
                  selected: isSelected,
                  label:
                      isUsed
                          ? 'Projektfarbe $colorHex, bereits verwendet'
                          : 'Projektfarbe $colorHex',
                  child: InkWell(
                    onTap: enabled ? () => onChanged(colorHex) : null,
                    customBorder: const CircleBorder(),
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            bottom: 0,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 160),
                              width: 46,
                              height: 46,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color:
                                      isSelected
                                          ? Theme.of(
                                            context,
                                          ).colorScheme.onSurface
                                          : Colors.transparent,
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: color.withValues(alpha: 0.28),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child:
                                  isSelected
                                      ? const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 24,
                                      )
                                      : null,
                            ),
                          ),
                          if (isUsed)
                            Positioned(
                              right: 0,
                              top: 0,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.outlineVariant,
                                  ),
                                ),
                                child: Icon(
                                  Icons.check_circle,
                                  size: 18,
                                  color:
                                      Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }
}
