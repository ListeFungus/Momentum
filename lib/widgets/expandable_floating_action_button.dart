import 'package:flutter/material.dart';

class ExpandableFloatingActionButton extends StatefulWidget {
  const ExpandableFloatingActionButton({required this.options, super.key});

  final List<Widget> options;

  @override
  State<ExpandableFloatingActionButton> createState() =>
      _ExpandableFloatingActionButtonState();
}

class _ExpandableFloatingActionButtonState
    extends State<ExpandableFloatingActionButton> {
  bool _isExpanded = false;

  void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          child:
              _isExpanded
                  ? Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [...widget.options, const SizedBox(height: 12)],
                  )
                  : const SizedBox.shrink(),
        ),
        FloatingActionButton(
          onPressed: _toggle,
          tooltip: _isExpanded ? 'Menü schließen' : 'Menü öffnen',
          child: AnimatedRotation(
            turns: _isExpanded ? 0.125 : 0,
            duration: const Duration(milliseconds: 200),
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}

class FloatingActionOption extends StatelessWidget {
  const FloatingActionOption({
    required this.label,
    required this.icon,
    this.onPressed,
    super.key,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(label),
          ),
        ),
        const SizedBox(width: 12),
        FloatingActionButton.small(
          heroTag: null,
          onPressed: onPressed,
          child: Icon(icon),
        ),
      ],
    );
  }
}
