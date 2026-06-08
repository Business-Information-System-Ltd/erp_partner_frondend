/*
 * BizSoft ERP - Partners Module
 *
 * File:
 *   lib/features/partners/domain/models/partner_identification_model.dart
 *
 * Purpose:
 *   Models identification documents for partners.
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

class PartnerIdentificationModel {
  const PartnerIdentificationModel({
    this.id,
    this.idType,
    this.idNumber,
    this.issuedBy,
    this.issueDate,
    this.expiryDate,
  });

  final String? id;
  final String? idType;
  final String? idNumber;
  final String? issuedBy;
  final DateTime? issueDate;
  final DateTime? expiryDate;

  factory PartnerIdentificationModel.fromJson(Map<String, dynamic> json) =>
      PartnerIdentificationModel(
        id: json['id']?.toString(),
        idType: json['id_type']?.toString(),
        idNumber: json['id_number']?.toString(),
        issuedBy: json['issued_by']?.toString(),
        issueDate: parseDate(json['issue_date']),
        expiryDate: parseDate(json['expiry_date']),
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'id_type': idType,
    'id_number': idNumber,
    'issued_by': issuedBy,
    'issue_date': dateToJson(issueDate),
    'expiry_date': dateToJson(expiryDate),
  };

  PartnerIdentificationModel copyWith({
    String? id,
    String? idType,
    String? idNumber,
    String? issuedBy,
    DateTime? issueDate,
    DateTime? expiryDate,
  }) => PartnerIdentificationModel(
    id: id ?? this.id,
    idType: idType ?? this.idType,
    idNumber: idNumber ?? this.idNumber,
    issuedBy: issuedBy ?? this.issuedBy,
    issueDate: issueDate ?? this.issueDate,
    expiryDate: expiryDate ?? this.expiryDate,
  );
}
