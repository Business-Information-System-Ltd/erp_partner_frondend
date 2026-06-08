/*
 * BizSoft ERP - Partners Module
 *
 * File:
 *   lib/features/partners/domain/models/partner_role_model.dart
 *
 * Purpose:
 *   Models module-neutral Partner role assignments.
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

import '../enums/partner_enums.dart';
import 'model_helpers.dart';

class PartnerRoleModel {
  const PartnerRoleModel({
    this.id,
    required this.roleType,
    this.validFrom,
    this.validTo,
    this.isPrimary = false,
    this.remarks,
  });

  final String? id;
  final PartnerRoleType roleType;
  final DateTime? validFrom;
  final DateTime? validTo;
  final bool isPrimary;
  final String? remarks;

  factory PartnerRoleModel.fromJson(Map<String, dynamic> json) =>
      PartnerRoleModel(
        id: json['id']?.toString(),
        roleType: PartnerRoleTypeJson.fromJson(json['role_type']?.toString()),
        validFrom: parseDate(json['valid_from']),
        validTo: parseDate(json['valid_to']),
        isPrimary: json['is_primary'] == true,
        remarks: json['remarks']?.toString(),
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'role_type': roleType.value,
    'valid_from': dateToJson(validFrom),
    'valid_to': dateToJson(validTo),
    'is_primary': isPrimary,
    'remarks': remarks,
  };

  PartnerRoleModel copyWith({
    String? id,
    PartnerRoleType? roleType,
    DateTime? validFrom,
    DateTime? validTo,
    bool? isPrimary,
    String? remarks,
  }) => PartnerRoleModel(
    id: id ?? this.id,
    roleType: roleType ?? this.roleType,
    validFrom: validFrom ?? this.validFrom,
    validTo: validTo ?? this.validTo,
    isPrimary: isPrimary ?? this.isPrimary,
    remarks: remarks ?? this.remarks,
  );
}
