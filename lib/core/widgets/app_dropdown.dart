/*
 * BizSoft ERP - Partners Module
 *
 * File:
 *   lib/core/widgets/app_dropdown.dart
 *
 * Purpose:
 *   Provides a reusable dropdown field with validation error display.
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

class AppDropdownItem<T> {
  const AppDropdownItem({required this.value, required this.label});

  final T value;
  final String label;
}

class AppDropdown<T> extends StatelessWidget {
  const AppDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.errorText,
    this.enabled = true,
  });

  final String label;
  final T? value;
  final List<AppDropdownItem<T>> items;
  final ValueChanged<T?> onChanged;
  final String? errorText;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(labelText: label, errorText: errorText),
      items: [
        for (final item in items)
          DropdownMenuItem(value: item.value, child: Text(item.label)),
      ],
      onChanged: enabled ? onChanged : null,
    );
  }
}
