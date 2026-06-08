import 'package:flutter/material.dart';

enum ReportDatePreset {
  today,
  yesterday,
  thisWeek,
  thisMonth,
  thisQuarter,
  thisYear,
  specificDate,
}

enum ReportDateInputAppearance { compact, normal }

class ReportDateRange {
  const ReportDateRange({
    required this.fromDate,
    required this.toDate,
    required this.preset,
  });

  final DateTime fromDate;
  final DateTime toDate;
  final ReportDatePreset preset;
}

class ReusableReportDateRangePicker extends StatefulWidget {
  const ReusableReportDateRangePicker({
    super.key,
    required this.onChanged,
    this.initialPreset = ReportDatePreset.today,
    this.initialFromDate,
    this.initialToDate,
    this.appearance = ReportDateInputAppearance.normal,
    this.firstDate,
    this.lastDate,
    this.labelText = 'Report Date',
    this.fromLabelText = 'From Date',
    this.toLabelText = 'To Date',
    this.allowFutureDate = false,
  });

  final ValueChanged<ReportDateRange> onChanged;
  final ReportDatePreset initialPreset;
  final DateTime? initialFromDate;
  final DateTime? initialToDate;
  final ReportDateInputAppearance appearance;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String labelText;
  final String fromLabelText;
  final String toLabelText;
  final bool allowFutureDate;

  @override
  State<ReusableReportDateRangePicker> createState() =>
      _ReusableReportDateRangePickerState();
}

class _ReusableReportDateRangePickerState
    extends State<ReusableReportDateRangePicker> {
  final LayerLink _fromDateLayerLink = LayerLink();
  final LayerLink _toDateLayerLink = LayerLink();
  OverlayEntry? _calendarOverlayEntry;
  late ReportDatePreset _preset;
  late DateTime _fromDate;
  late DateTime _toDate;
  String? _errorText;

  DateTime get _today => _dateOnly(DateTime.now());

  DateTime get _firstDate =>
      _dateOnly(widget.firstDate ?? DateTime(_today.year - 10, 1, 1));

  DateTime get _lastDate => _dateOnly(
    widget.lastDate ??
        (widget.allowFutureDate ? DateTime(_today.year + 10, 12, 31) : _today),
  );

  @override
  void initState() {
    super.initState();
    _preset = widget.initialPreset;

    final initialRange =
        _preset == ReportDatePreset.specificDate &&
            widget.initialFromDate != null &&
            widget.initialToDate != null
        ? ReportDateRange(
            fromDate: _dateOnly(widget.initialFromDate!),
            toDate: _dateOnly(widget.initialToDate!),
            preset: _preset,
          )
        : _rangeForPreset(_preset);

    _fromDate = initialRange.fromDate;
    _toDate = initialRange.toDate;
    _errorText = _validate();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _notifyIfValid();
      }
    });
  }

  @override
  void dispose() {
    _removeCalendarPopup();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSpecific = _preset == ReportDatePreset.specificDate;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.labelText.isNotEmpty) ...[
          Text(widget.labelText, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
        ],
        DropdownButtonFormField<ReportDatePreset>(
          value: _preset,
          decoration: const InputDecoration(
            labelText: 'Date Selection',
            border: OutlineInputBorder(),
          ),
          items: [
            for (final preset in ReportDatePreset.values)
              DropdownMenuItem(
                value: preset,
                child: Text(_presetLabel(preset)),
              ),
          ],
          onChanged: (preset) {
            if (preset != null) {
              _selectPreset(preset);
            }
          },
        ),
        const SizedBox(height: 10),
        if (isSpecific)
          widget.appearance == ReportDateInputAppearance.compact
              ? _CompactDateInputs(
                  fromDate: _fromDate,
                  toDate: _toDate,
                  fromLayerLink: _fromDateLayerLink,
                  toLayerLink: _toDateLayerLink,
                  onFromPressed: () => _openCalendarPopup(isFromDate: true),
                  onToPressed: () => _openCalendarPopup(isFromDate: false),
                )
              : _NormalDateInputs(
                  fromLabelText: widget.fromLabelText,
                  toLabelText: widget.toLabelText,
                  fromDate: _fromDate,
                  toDate: _toDate,
                  fromLayerLink: _fromDateLayerLink,
                  toLayerLink: _toDateLayerLink,
                  onFromPressed: () => _openCalendarPopup(isFromDate: true),
                  onToPressed: () => _openCalendarPopup(isFromDate: false),
                )
        else
          Text(
            '${_formatDate(_fromDate)} to ${_formatDate(_toDate)}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        if (_errorText != null) ...[
          const SizedBox(height: 8),
          Text(
            _errorText!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ],
      ],
    );
  }

  void _selectPreset(ReportDatePreset preset) {
    final range = preset == ReportDatePreset.specificDate
        ? ReportDateRange(fromDate: _fromDate, toDate: _toDate, preset: preset)
        : _rangeForPreset(preset);

    setState(() {
      _preset = preset;
      _fromDate = range.fromDate;
      _toDate = range.toDate;
    });
    _validateAndNotify();
  }

  void _openCalendarPopup({required bool isFromDate}) {
    _removeCalendarPopup();

    final layerLink = isFromDate ? _fromDateLayerLink : _toDateLayerLink;
    final selectedDate = _clampDate(isFromDate ? _fromDate : _toDate);

    _calendarOverlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _removeCalendarPopup,
                child: const SizedBox.expand(),
              ),
            ),
            CompositedTransformFollower(
              link: layerLink,
              showWhenUnlinked: false,
              targetAnchor: Alignment.bottomLeft,
              followerAnchor: Alignment.topLeft,
              offset: const Offset(0, 4),
              child: Material(
                elevation: 12,
                borderRadius: BorderRadius.circular(8),
                clipBehavior: Clip.antiAlias,
                child: SizedBox(
                  width: 330,
                  height: 360,
                  child: CalendarDatePicker(
                    initialDate: selectedDate,
                    firstDate: _firstDate,
                    lastDate: _lastDate,
                    onDateChanged: (pickedDate) {
                      setState(() {
                        if (isFromDate) {
                          _fromDate = _dateOnly(pickedDate);
                        } else {
                          _toDate = _dateOnly(pickedDate);
                        }
                      });
                      _validateAndNotify();
                      _removeCalendarPopup();
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context).insert(_calendarOverlayEntry!);
  }

  void _removeCalendarPopup() {
    _calendarOverlayEntry?.remove();
    _calendarOverlayEntry = null;
  }

  void _validateAndNotify() {
    final error = _validate();
    setState(() => _errorText = error);

    _notifyIfValid();
  }

  void _notifyIfValid() {
    if (_errorText != null) {
      return;
    }

    widget.onChanged(
      ReportDateRange(fromDate: _fromDate, toDate: _toDate, preset: _preset),
    );
  }

  String? _validate() {
    if (_fromDate.isBefore(_firstDate) || _fromDate.isAfter(_lastDate)) {
      return 'From date is outside the allowed date range.';
    }

    if (_toDate.isBefore(_firstDate) || _toDate.isAfter(_lastDate)) {
      return 'To date is outside the allowed date range.';
    }

    if (_fromDate.isAfter(_toDate)) {
      return 'From date must be before or equal to To date.';
    }

    if (!widget.allowFutureDate &&
        (_fromDate.isAfter(_today) || _toDate.isAfter(_today))) {
      return 'Future dates are not allowed.';
    }

    return null;
  }

  ReportDateRange _rangeForPreset(ReportDatePreset preset) {
    final today = _today;

    switch (preset) {
      case ReportDatePreset.today:
        return ReportDateRange(fromDate: today, toDate: today, preset: preset);
      case ReportDatePreset.yesterday:
        final yesterday = today.subtract(const Duration(days: 1));
        return ReportDateRange(
          fromDate: yesterday,
          toDate: yesterday,
          preset: preset,
        );
      case ReportDatePreset.thisWeek:
        final fromDate = today.subtract(Duration(days: today.weekday - 1));
        return ReportDateRange(
          fromDate: fromDate,
          toDate: today,
          preset: preset,
        );
      case ReportDatePreset.thisMonth:
        final fromDate = DateTime(today.year, today.month, 1);
        return ReportDateRange(
          fromDate: fromDate,
          toDate: today,
          preset: preset,
        );
      case ReportDatePreset.thisQuarter:
        final quarterStartMonth = (((today.month - 1) ~/ 3) * 3) + 1;
        final fromDate = DateTime(today.year, quarterStartMonth, 1);
        return ReportDateRange(
          fromDate: fromDate,
          toDate: today,
          preset: preset,
        );
      case ReportDatePreset.thisYear:
        final fromDate = DateTime(today.year, 1, 1);
        return ReportDateRange(
          fromDate: fromDate,
          toDate: today,
          preset: preset,
        );
      case ReportDatePreset.specificDate:
        return ReportDateRange(
          fromDate: _fromDate,
          toDate: _toDate,
          preset: preset,
        );
    }
  }

  DateTime _clampDate(DateTime date) {
    if (date.isBefore(_firstDate)) {
      return _firstDate;
    }

    if (date.isAfter(_lastDate)) {
      return _lastDate;
    }

    return date;
  }

  DateTime _dateOnly(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }

  String _formatDate(DateTime value) {
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    return '${value.year}-$month-$day';
  }

  String _presetLabel(ReportDatePreset preset) {
    switch (preset) {
      case ReportDatePreset.today:
        return 'Today';
      case ReportDatePreset.yesterday:
        return 'Yesterday';
      case ReportDatePreset.thisWeek:
        return 'This Week';
      case ReportDatePreset.thisMonth:
        return 'This Month';
      case ReportDatePreset.thisQuarter:
        return 'This Quarter';
      case ReportDatePreset.thisYear:
        return 'This Year';
      case ReportDatePreset.specificDate:
        return 'Specific Date';
    }
  }
}

class _CompactDateInputs extends StatelessWidget {
  const _CompactDateInputs({
    required this.fromDate,
    required this.toDate,
    required this.fromLayerLink,
    required this.toLayerLink,
    required this.onFromPressed,
    required this.onToPressed,
  });

  final DateTime fromDate;
  final DateTime toDate;
  final LayerLink fromLayerLink;
  final LayerLink toLayerLink;
  final VoidCallback onFromPressed;
  final VoidCallback onToPressed;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        CompositedTransformTarget(
          link: fromLayerLink,
          child: IconButton(
            tooltip: 'From Date',
            onPressed: onFromPressed,
            icon: const Icon(Icons.calendar_month),
          ),
        ),
        Text(_formatDate(fromDate)),
        const Text('to'),
        CompositedTransformTarget(
          link: toLayerLink,
          child: IconButton(
            tooltip: 'To Date',
            onPressed: onToPressed,
            icon: const Icon(Icons.event),
          ),
        ),
        Text(_formatDate(toDate)),
      ],
    );
  }
}

class _NormalDateInputs extends StatelessWidget {
  const _NormalDateInputs({
    required this.fromLabelText,
    required this.toLabelText,
    required this.fromDate,
    required this.toDate,
    required this.fromLayerLink,
    required this.toLayerLink,
    required this.onFromPressed,
    required this.onToPressed,
  });

  final String fromLabelText;
  final String toLabelText;
  final DateTime fromDate;
  final DateTime toDate;
  final LayerLink fromLayerLink;
  final LayerLink toLayerLink;
  final VoidCallback onFromPressed;
  final VoidCallback onToPressed;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _DateTextBox(
          labelText: fromLabelText,
          value: _formatDate(fromDate),
          layerLink: fromLayerLink,
          onPressed: onFromPressed,
        ),
        _DateTextBox(
          labelText: toLabelText,
          value: _formatDate(toDate),
          layerLink: toLayerLink,
          onPressed: onToPressed,
        ),
      ],
    );
  }
}

class _DateTextBox extends StatelessWidget {
  const _DateTextBox({
    required this.labelText,
    required this.value,
    required this.layerLink,
    required this.onPressed,
  });

  final String labelText;
  final String value;
  final LayerLink layerLink;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: CompositedTransformTarget(
        link: layerLink,
        child: InkWell(
          onTap: onPressed,
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: labelText,
              suffixIcon: IconButton(
                tooltip: 'Select date',
                onPressed: onPressed,
                icon: const Icon(Icons.calendar_month),
              ),
            ),
            child: Text(value),
          ),
        ),
      ),
    );
  }
}

String _formatDate(DateTime value) {
  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  return '${value.year}-$month-$day';
}
