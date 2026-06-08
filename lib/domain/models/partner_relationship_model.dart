/*
 * BizSoft ERP - Partners Module
 *
 * File:
 *   lib/features/partners/domain/models/partner_relationship_model.dart
 *
 * Purpose:
 *   Models relationships between business partners.
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

class PartnerRelationshipModel {
  const PartnerRelationshipModel({
    this.id,
    this.relatedPartnerId,
    this.relatedPartnerName,
    this.relationshipType,
    this.validFrom,
    this.validTo,
  });

  final String? id;
  final String? relatedPartnerId;
  final String? relatedPartnerName;
  final String? relationshipType;
  final DateTime? validFrom;
  final DateTime? validTo;

  factory PartnerRelationshipModel.fromJson(Map<String, dynamic> json) =>
      PartnerRelationshipModel(
        id: json['id']?.toString(),
        relatedPartnerId: json['related_partner']?.toString(),
        relatedPartnerName: json['related_partner_name']?.toString(),
        relationshipType: json['relationship_type']?.toString(),
        validFrom: parseDate(json['valid_from']),
        validTo: parseDate(json['valid_to']),
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'related_partner': relatedPartnerId,
    'relationship_type': relationshipType,
    'valid_from': dateToJson(validFrom),
    'valid_to': dateToJson(validTo),
  };

  PartnerRelationshipModel copyWith({
    String? id,
    String? relatedPartnerId,
    String? relatedPartnerName,
    String? relationshipType,
    DateTime? validFrom,
    DateTime? validTo,
  }) => PartnerRelationshipModel(
    id: id ?? this.id,
    relatedPartnerId: relatedPartnerId ?? this.relatedPartnerId,
    relatedPartnerName: relatedPartnerName ?? this.relatedPartnerName,
    relationshipType: relationshipType ?? this.relationshipType,
    validFrom: validFrom ?? this.validFrom,
    validTo: validTo ?? this.validTo,
  );
}
