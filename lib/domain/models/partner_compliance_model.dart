/*
 * BizSoft ERP - Partners Module
 *
 * File:
 *   lib/features/partners/domain/models/partner_compliance_model.dart
 *
 * Purpose:
 *   Models compliance screening fields for partner master data.
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

import 'model_helpers.dart';

class PartnerComplianceModel {
  const PartnerComplianceModel({
    this.id,
    this.riskLevel,
    this.screeningStatus,
    this.lastScreenedDate,
    this.notes,
  });

  final String? id;
  final String? riskLevel;
  final String? screeningStatus;
  final DateTime? lastScreenedDate;
  final String? notes;

  factory PartnerComplianceModel.fromJson(Map<String, dynamic> json) => PartnerComplianceModel(
        id: json['id']?.toString(),
        riskLevel: json['risk_level']?.toString(),
        screeningStatus: json['screening_status']?.toString(),
        lastScreenedDate: parseDate(json['last_screened_date']),
        notes: json['notes']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'risk_level': riskLevel,
        'screening_status': screeningStatus,
        'last_screened_date': dateToJson(lastScreenedDate),
        'notes': notes,
      };

  PartnerComplianceModel copyWith({
    String? id,
    String? riskLevel,
    String? screeningStatus,
    DateTime? lastScreenedDate,
    String? notes,
  }) =>
      PartnerComplianceModel(
        id: id ?? this.id,
        riskLevel: riskLevel ?? this.riskLevel,
        screeningStatus: screeningStatus ?? this.screeningStatus,
        lastScreenedDate: lastScreenedDate ?? this.lastScreenedDate,
        notes: notes ?? this.notes,
      );
}
