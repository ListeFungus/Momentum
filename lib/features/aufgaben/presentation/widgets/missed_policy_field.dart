import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:momentum/features/aufgaben/data/missed_policy.dart';
import 'package:momentum/features/aufgaben/data/post_buffer_behavior.dart';
import 'package:momentum/features/aufgaben/data/task_configuration_validator.dart';

class MissedPolicyField extends StatelessWidget {
  const MissedPolicyField({
    required this.selectedPolicy,
    required this.selectedConsequence,
    required this.selectedPostBufferBehavior,
    required this.bufferDays,
    required this.maxCarryoverCount,
    required this.usesThreeStateCapture,
    required this.policyRule,
    required this.consequenceRule,
    required this.bufferDaysRule,
    required this.postBufferBehaviorRule,
    required this.maxCarryoverCountRule,
    required this.onPolicyChanged,
    required this.onConsequenceChanged,
    required this.onPostBufferBehaviorChanged,
    required this.onBufferDaysChanged,
    required this.onMaxCarryoverCountChanged,
    this.enabled = true,
    super.key,
  });

  final String selectedPolicy;
  final String selectedConsequence;
  final String selectedPostBufferBehavior;
  final int bufferDays;
  final int maxCarryoverCount;
  final bool usesThreeStateCapture;
  final TaskFieldRule policyRule;
  final TaskFieldRule consequenceRule;
  final TaskFieldRule bufferDaysRule;
  final TaskFieldRule postBufferBehaviorRule;
  final TaskFieldRule maxCarryoverCountRule;
  final ValueChanged<String> onPolicyChanged;
  final ValueChanged<String> onConsequenceChanged;
  final ValueChanged<String> onPostBufferBehaviorChanged;
  final ValueChanged<int> onBufferDaysChanged;
  final ValueChanged<int> onMaxCarryoverCountChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final availablePolicies = _availablePolicies();
    final enabledPolicies =
        availablePolicies.where((policy) => policy.enabled).toList();
    final hasMultiplePolicyOptions = enabledPolicies.length > 1;
    final effectivePolicy =
        availablePolicies.any(
              (policy) => policy.value == selectedPolicy && policy.enabled,
            )
            ? selectedPolicy
            : enabledPolicies.first.value;
    final showConsequence = consequenceRule.isEnabled;
    final showBuffer = bufferDaysRule.isEnabled;
    final showPostBufferBehavior = postBufferBehaviorRule.isEnabled;
    final showCarryoverLimit = maxCarryoverCountRule.isEnabled;
    final canChangePolicy =
        enabled && policyRule.isEnabled && hasMultiplePolicyOptions;
    final isPolicyLocked = !canChangePolicy;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButtonFormField<String>(
          isExpanded: true,
          value: effectivePolicy,
          decoration: InputDecoration(
            labelText: 'Missed Policy',
            helperText:
                policyRule.reason ??
                'Was passiert, wenn bis zur Fälligkeit kein Eintrag erfolgt?',
            helperMaxLines: 3,
            filled: isPolicyLocked,
            fillColor: colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.55,
            ),
            border: const OutlineInputBorder(),
          ),
          items:
              availablePolicies
                  .map(
                    (policy) => DropdownMenuItem(
                      value: policy.value,
                      enabled: policy.enabled,
                      child: Text(policy.label),
                    ),
                  )
                  .toList(),
          onChanged:
              canChangePolicy
                  ? (value) {
                    if (value != null) {
                      onPolicyChanged(value);
                    }
                  }
                  : null,
        ),
        if (!hasMultiplePolicyOptions) ...[
          const SizedBox(height: 8),
          Text(
            'Keine weitere sinnvolle Option für die aktuelle Kombination verfügbar.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
        const SizedBox(height: 8),
        _PolicyHint(
          policy: effectivePolicy,
          usesThreeStateCapture: usesThreeStateCapture,
          warning: policyRule.warning,
        ),
        if (showBuffer) const SizedBox(height: 20),
        if (showBuffer)
          _NumberField(
            labelText: 'Puffer in Tagen',
            helperText:
                bufferDaysRule.warning ??
                'Kulanzzeitraum, bevor die gewählte Folgeregel greift.',
            value: bufferDays,
            minValue: 1,
            enabled: enabled,
            onChanged: onBufferDaysChanged,
          )
        else
          const SizedBox.shrink(),
        if (showPostBufferBehavior) const SizedBox(height: 20),
        if (showPostBufferBehavior)
          DropdownButtonFormField<String>(
            isExpanded: true,
            value: selectedPostBufferBehavior,
            decoration: InputDecoration(
              labelText: 'Verhalten nach dem Puffer',
              helperText:
                  postBufferBehaviorRule.warning ??
                  'Lege fest, ob der Eintrag scheitert oder als Kein Eintrag gespeichert wird.',
              border: const OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(
                value: PostBufferBehavior.markAsFailure,
                child: Text('Sofort als Misserfolg abschließen'),
              ),
              DropdownMenuItem(
                value: PostBufferBehavior.markAsNoEntry,
                child: Text('Als Kein Eintrag abschlieÃŸen'),
              ),
            ],
            onChanged:
                enabled
                    ? (value) {
                      if (value != null) {
                        onPostBufferBehaviorChanged(value);
                      }
                    }
                    : null,
          )
        else
          const SizedBox.shrink(),
        if (showCarryoverLimit) const SizedBox(height: 20),
        if (showCarryoverLimit)
          _NumberField(
            labelText: 'Maximal aufgestaute Einträge',
            helperText:
                'Begrenzt, wie viele verpasste Wiederholungen gleichzeitig offen bleiben.',
            value: maxCarryoverCount,
            minValue: 1,
            enabled: enabled,
            onChanged: onMaxCarryoverCountChanged,
          )
        else
          const SizedBox.shrink(),
        if (showConsequence) const SizedBox(height: 20),
        if (showConsequence)
          DropdownButtonFormField<String>(
            isExpanded: true,
            value: _effectiveConsequence,
            decoration: InputDecoration(
              labelText:
                  effectivePolicy == MissedPolicy.carryover
                      ? 'Konsequenz bei überschrittener Grenze'
                      : 'Konsequenz',
              helperText:
                  consequenceRule.reason ??
                  (effectivePolicy == MissedPolicy.carryover
                      ? 'Was passiert, wenn mehr Einträge aufstauen als erlaubt?'
                      : 'Was wird nach der Missed Policy eingetragen?'),
              border: const OutlineInputBorder(),
            ),
            items:
                _availableConsequences()
                    .map(
                      (consequence) => DropdownMenuItem(
                        value: consequence.value,
                        child: Text(consequence.label),
                      ),
                    )
                    .toList(),
            onChanged:
                enabled && _availableConsequences().length > 1
                    ? (value) {
                      if (value != null) {
                        onConsequenceChanged(value);
                      }
                    }
                    : null,
          )
        else
          const SizedBox.shrink(),
      ],
    );
  }

  String get _effectiveConsequence {
    final consequences = _availableConsequences();

    if (consequences.any(
      (consequence) => consequence.value == selectedConsequence,
    )) {
      return selectedConsequence;
    }

    return consequences.first.value;
  }

  List<_PolicyOption> _availablePolicies() {
    return [
      const _PolicyOption(
        value: MissedPolicy.none,
        label: 'Keine Missed Policy',
        enabled: false,
      ),
      const _PolicyOption(
        value: MissedPolicy.direct,
        label: 'Direkte Konsequenz',
        enabled: false,
      ),
      const _PolicyOption(
        value: MissedPolicy.carryover,
        label: 'Aufstauen',
        enabled: false,
      ),
      const _PolicyOption(
        value: MissedPolicy.buffer,
        label: 'Puffer',
        enabled: false,
      ),
    ].map((option) {
      return _PolicyOption(
        value: option.value,
        label: option.label,
        enabled: policyRule.allowedValues.contains(option.value),
      );
    }).toList();
  }

  List<_PolicyOption> _availableConsequences() {
    return const [
      _PolicyOption(
        value: MissedConsequence.keepNeutral,
        label: 'Als Kein Eintrag / ohne Antwort werten',
      ),
      _PolicyOption(
        value: MissedConsequence.markAsNotDone,
        label: 'Als nicht erfolgreich markieren',
      ),
    ];
  }
}

class _PolicyHint extends StatelessWidget {
  const _PolicyHint({
    required this.policy,
    required this.usesThreeStateCapture,
    this.warning,
  });

  final String policy;
  final bool usesThreeStateCapture;
  final String? warning;

  @override
  Widget build(BuildContext context) {
    final text = _hintText();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        if (warning != null) ...[
          const SizedBox(height: 8),
          Text(
            warning!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.error,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }

  String _hintText() {
    if (policy == MissedPolicy.none) {
      return 'Es passiert nichts automatisch. Sinnvoll, wenn es keinen klaren Fälligkeitsmoment gibt.';
    }

    if (policy == MissedPolicy.direct) {
      return usesThreeStateCapture
          ? 'Nach Ablauf wird die Aufgabe je nach Konsequenz als nicht erfolgreich oder als Kein Eintrag gewertet.'
          : 'Nach Ablauf wird die Aufgabe je nach Konsequenz als nicht erledigt oder als Kein Eintrag gewertet.';
    }

    if (policy == MissedPolicy.carryover) {
      return 'Verpasste Wiederholungen bleiben offen und können nachgeholt werden.';
    }

    if (policy == MissedPolicy.buffer) {
      return 'Der Puffer gibt zusätzliche Zeit. Was danach passiert, wird separat festgelegt.';
    }

    return '';
  }
}

class _NumberField extends StatefulWidget {
  const _NumberField({
    required this.labelText,
    required this.helperText,
    required this.value,
    required this.minValue,
    required this.enabled,
    required this.onChanged,
  });

  final String labelText;
  final String helperText;
  final int value;
  final int minValue;
  final bool enabled;
  final ValueChanged<int> onChanged;

  @override
  State<_NumberField> createState() => _NumberFieldState();
}

class _NumberFieldState extends State<_NumberField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      enabled: widget.enabled,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        labelText: widget.labelText,
        helperText: widget.helperText,
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        final parsedValue = int.tryParse(value ?? '');
        if (parsedValue == null || parsedValue < widget.minValue) {
          return 'Bitte gib eine Zahl ab ${widget.minValue} ein.';
        }
        return null;
      },
      onChanged: (value) {
        final parsedValue = int.tryParse(value);

        if (parsedValue == null || parsedValue < widget.minValue) {
          return;
        }

        widget.onChanged(parsedValue);
      },
    );
  }
}

class _PolicyOption {
  const _PolicyOption({
    required this.value,
    required this.label,
    this.enabled = true,
  });

  final String value;
  final String label;
  final bool enabled;
}
