/*
 * BizSoft ERP - Partners Module
 *
 * File:
 *   lib/core/widgets/app_text_field.dart
 *
 * Purpose:
 *   Provides a reusable text field with validation error display.
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

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.errorText,
    this.maxLines = 1,
    this.enabled = true,
    this.keyboardType,
  });

  final String label;
  final String? value;
  final ValueChanged<String> onChanged;
  final String? errorText;
  final int maxLines;
  final bool enabled;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value,
      enabled: enabled,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(labelText: label, errorText: errorText),
      onChanged: onChanged,
    );
  }
}
