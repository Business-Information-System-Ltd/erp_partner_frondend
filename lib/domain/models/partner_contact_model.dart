/*
 * BizSoft ERP - Partners Module
 *
 * File:
 *   lib/features/partners/domain/models/partner_contact_model.dart
 *
 * Purpose:
 *   Models contact points for partners.
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

class PartnerContactModel {
  const PartnerContactModel({
    this.id,
    this.contactType,
    this.value,
    this.personName,
    this.isPrimary = false,
  });

  final String? id;
  final String? contactType;
  final String? value;
  final String? personName;
  final bool isPrimary;

  factory PartnerContactModel.fromJson(Map<String, dynamic> json) =>
      PartnerContactModel(
        id: json['id']?.toString(),
        contactType: json['contact_type']?.toString(),
        value: json['value']?.toString(),
        personName: json['person_name']?.toString(),
        isPrimary: json['is_primary'] == true,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'contact_type': contactType,
    'value': value,
    'person_name': personName,
    'is_primary': isPrimary,
  };

  PartnerContactModel copyWith({
    String? id,
    String? contactType,
    String? value,
    String? personName,
    bool? isPrimary,
  }) => PartnerContactModel(
    id: id ?? this.id,
    contactType: contactType ?? this.contactType,
    value: value ?? this.value,
    personName: personName ?? this.personName,
    isPrimary: isPrimary ?? this.isPrimary,
  );
}
