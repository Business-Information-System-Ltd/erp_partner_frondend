/*
 * BizSoft ERP - Partners Module
 *
 * File:
 *   lib/features/partners/presentation/widgets/partner_status_chip.dart
 *
 * Purpose:
 *   Displays Partner status with consistent color coding.
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

import '../../domain/enums/partner_enums.dart';

class PartnerStatusChip extends StatelessWidget {
  const PartnerStatusChip({super.key, required this.status});

  final PartnerStatus status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      PartnerStatus.active => Colors.green,
      PartnerStatus.blocked => Colors.red,
      PartnerStatus.inactive => Colors.grey,
      PartnerStatus.draft => Colors.orange,
    };

    return Chip(
      label: Text(status.label),
      visualDensity: VisualDensity.compact,
      backgroundColor: color.withValues(alpha: 0.12),
      labelStyle: TextStyle(color: color.shade700, fontWeight: FontWeight.w600),
      side: BorderSide(color: color.withValues(alpha: 0.35)),
    );
  }
}
