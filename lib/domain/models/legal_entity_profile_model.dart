/*
 * BizSoft ERP - Partners Module
 *
 * File:
 *   lib/features/partners/domain/models/legal_entity_profile_model.dart
 *
 * Purpose:
 *   Models legal entity profile data for Partner UI forms.
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

class LegalEntityProfileModel {
  const LegalEntityProfileModel({
    this.id,
    this.registeredName,
    this.tradeName,
    this.legalForm,
    this.incorporationDate,
    this.incorporationCountryCode,
  });

  final String? id;
  final String? registeredName;
  final String? tradeName;
  final String? legalForm;
  final DateTime? incorporationDate;
  final String? incorporationCountryCode;

  factory LegalEntityProfileModel.fromJson(Map<String, dynamic> json) => LegalEntityProfileModel(
        id: json['id']?.toString(),
        registeredName: json['registered_name']?.toString(),
        tradeName: json['trade_name']?.toString(),
        legalForm: json['legal_form']?.toString(),
        incorporationDate: parseDate(json['incorporation_date']),
        incorporationCountryCode: json['incorporation_country_code']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'registered_name': registeredName,
        'trade_name': tradeName,
        'legal_form': legalForm,
        'incorporation_date': dateToJson(incorporationDate),
        'incorporation_country_code': incorporationCountryCode,
      };

  LegalEntityProfileModel copyWith({
    String? id,
    String? registeredName,
    String? tradeName,
    String? legalForm,
    DateTime? incorporationDate,
    String? incorporationCountryCode,
  }) =>
      LegalEntityProfileModel(
        id: id ?? this.id,
        registeredName: registeredName ?? this.registeredName,
        tradeName: tradeName ?? this.tradeName,
        legalForm: legalForm ?? this.legalForm,
        incorporationDate: incorporationDate ?? this.incorporationDate,
        incorporationCountryCode: incorporationCountryCode ?? this.incorporationCountryCode,
      );
}
