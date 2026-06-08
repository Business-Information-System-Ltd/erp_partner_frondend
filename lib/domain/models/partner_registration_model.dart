/*
 * BizSoft ERP - Partners Module
 *
 * File:
 *   lib/features/partners/domain/models/partner_registration_model.dart
 *
 * Purpose:
 *   Models tax, company, and statutory registrations for partners.
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

class PartnerRegistrationModel {
  const PartnerRegistrationModel({
    this.id,
    this.registrationType,
    this.registrationNumber,
    this.countryCode,
    this.validFrom,
    this.validTo,
  });

  final String? id;
  final String? registrationType;
  final String? registrationNumber;
  final String? countryCode;
  final DateTime? validFrom;
  final DateTime? validTo;

  factory PartnerRegistrationModel.fromJson(Map<String, dynamic> json) =>
      PartnerRegistrationModel(
        id: json['id']?.toString(),
        registrationType: json['registration_type']?.toString(),
        registrationNumber: json['registration_number']?.toString(),
        countryCode: json['country_code']?.toString(),
        validFrom: parseDate(json['valid_from']),
        validTo: parseDate(json['valid_to']),
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'registration_type': registrationType,
    'registration_number': registrationNumber,
    'country_code': countryCode,
    'valid_from': dateToJson(validFrom),
    'valid_to': dateToJson(validTo),
  };

  PartnerRegistrationModel copyWith({
    String? id,
    String? registrationType,
    String? registrationNumber,
    String? countryCode,
    DateTime? validFrom,
    DateTime? validTo,
  }) => PartnerRegistrationModel(
    id: id ?? this.id,
    registrationType: registrationType ?? this.registrationType,
    registrationNumber: registrationNumber ?? this.registrationNumber,
    countryCode: countryCode ?? this.countryCode,
    validFrom: validFrom ?? this.validFrom,
    validTo: validTo ?? this.validTo,
  );
}
