/*
 * BizSoft ERP - Partners Module
 *
 * File:
 *   lib/features/partners/presentation/widgets/partner_type_dropdown.dart
 *
 * Purpose:
 *   Provides a reusable Partner type dropdown.
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

import '../../../../core/widgets/app_dropdown.dart';
import '../../domain/enums/partner_enums.dart';

class PartnerTypeDropdown extends StatelessWidget {
  const PartnerTypeDropdown({
    super.key,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  final PartnerType value;
  final ValueChanged<PartnerType?> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return AppDropdown<PartnerType>(
      label: 'Partner Type',
      value: value,
      enabled: enabled,
      items: [
        for (final type in PartnerType.values)
          AppDropdownItem(value: type, label: type.label),
      ],
      onChanged: onChanged,
    );
  }
}
