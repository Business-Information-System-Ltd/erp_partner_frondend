/*
 * BizSoft ERP - Partners Module
 *
 * File:
 *   lib/core/widgets/app_checkbox.dart
 *
 * Purpose:
 *   Provides a reusable checkbox field for Partner UI forms.
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

class AppCheckbox extends StatelessWidget {
  const AppCheckbox({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: value,
      title: Text(label),
      dense: true,
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: enabled ? (value) => onChanged(value ?? false) : null,
    );
  }
}
