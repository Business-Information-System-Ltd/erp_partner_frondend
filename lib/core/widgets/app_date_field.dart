/*
 * BizSoft ERP - Partners Module
 *
 * File:
 *   lib/core/widgets/app_date_field.dart
 *
 * Purpose:
 *   Provides a reusable date picker field for Partner UI forms.
 *
 * Architectural Notes:
 *   - This UI consumes the Django Partner API.
 *   - Customer, Supplier, Employee, FAR, Finance, and other module-specific profiles
 *     are not implemented here.
 *   - This module manages common Business Partner / Stakeholder master data UI.
 *
 * Author:
 *   BizSoft Systems
 *
 * Created:
 *   2026-06-04
 */

import 'package:flutter/material.dart';

class AppDateField extends StatelessWidget {
  const AppDateField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.errorText,
    this.enabled = true,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;
  final String? errorText;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final text = value == null
        ? ''
        : '${value!.year}-${value!.month.toString().padLeft(2, '0')}-${value!.day.toString().padLeft(2, '0')}';

    return InkWell(
      onTap: enabled ? () => _pickDate(context) : null,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          errorText: errorText,
          suffixIcon: const Icon(Icons.calendar_month),
        ),
        child: Text(text.isEmpty ? 'Select date' : text),
      ),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final today = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: value ?? today,
      firstDate: DateTime(today.year - 120),
      lastDate: DateTime(today.year + 20),
    );
    onChanged(picked);
  }
}
