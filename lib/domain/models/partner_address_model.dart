/*
 * BizSoft ERP - Partners Module
 *
 * File:
 *   lib/features/partners/domain/models/partner_address_model.dart
 *
 * Purpose:
 *   Models postal and physical addresses for partners.
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

class PartnerAddressModel {
  const PartnerAddressModel({
    this.id,
    this.addressType,
    this.line1,
    this.line2,
    this.city,
    this.state,
    this.postalCode,
    this.countryCode,
    this.isPrimary = false,
  });

  final String? id;
  final String? addressType;
  final String? line1;
  final String? line2;
  final String? city;
  final String? state;
  final String? postalCode;
  final String? countryCode;
  final bool isPrimary;

  factory PartnerAddressModel.fromJson(Map<String, dynamic> json) => PartnerAddressModel(
        id: json['id']?.toString(),
        addressType: json['address_type']?.toString(),
        line1: json['line1']?.toString(),
        line2: json['line2']?.toString(),
        city: json['city']?.toString(),
        state: json['state']?.toString(),
        postalCode: json['postal_code']?.toString(),
        countryCode: json['country_code']?.toString(),
        isPrimary: json['is_primary'] == true,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'address_type': addressType,
        'line1': line1,
        'line2': line2,
        'city': city,
        'state': state,
        'postal_code': postalCode,
        'country_code': countryCode,
        'is_primary': isPrimary,
      };

  PartnerAddressModel copyWith({
    String? id,
    String? addressType,
    String? line1,
    String? line2,
    String? city,
    String? state,
    String? postalCode,
    String? countryCode,
    bool? isPrimary,
  }) =>
      PartnerAddressModel(
        id: id ?? this.id,
        addressType: addressType ?? this.addressType,
        line1: line1 ?? this.line1,
        line2: line2 ?? this.line2,
        city: city ?? this.city,
        state: state ?? this.state,
        postalCode: postalCode ?? this.postalCode,
        countryCode: countryCode ?? this.countryCode,
        isPrimary: isPrimary ?? this.isPrimary,
      );
}
