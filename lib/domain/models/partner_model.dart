/*
 * BizSoft ERP - Partners Module
 *
 * File:
 *   lib/features/partners/domain/models/partner_model.dart
 *
 * Purpose:
 *   Defines the main Partner aggregate consumed by list, detail, and form screens.
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
import 'legal_entity_profile_model.dart';
import 'model_helpers.dart';
import 'partner_address_model.dart';
import 'partner_compliance_model.dart';
import 'partner_contact_model.dart';
import 'partner_identification_model.dart';
import 'partner_registration_model.dart';
import 'partner_relationship_model.dart';
import 'partner_role_model.dart';
import 'person_profile_model.dart';

class PartnerModel {
  const PartnerModel({
    this.id,
    this.partnerCode,
    required this.partnerType,
    this.displayName,
    this.legalName,
    this.shortName,
    this.countryCode,
    this.defaultLanguage,
    this.defaultCurrencyCode,
    this.externalReference,
    this.remarks,
    this.status = PartnerStatus.draft,
    this.primaryContact,
    this.personProfile,
    this.legalEntityProfile,
    this.roles = const <PartnerRoleModel>[],
    this.relationships = const <PartnerRelationshipModel>[],
    this.addresses = const <PartnerAddressModel>[],
    this.contacts = const <PartnerContactModel>[],
    this.identifications = const <PartnerIdentificationModel>[],
    this.registrations = const <PartnerRegistrationModel>[],
    this.compliance,
  });

  final String? id;
  final String? partnerCode;
  final PartnerType partnerType;
  final String? displayName;
  final String? legalName;
  final String? shortName;
  final String? countryCode;
  final String? defaultLanguage;
  final String? defaultCurrencyCode;
  final String? externalReference;
  final String? remarks;
  final PartnerStatus status;
  final String? primaryContact;
  final PersonProfileModel? personProfile;
  final LegalEntityProfileModel? legalEntityProfile;
  final List<PartnerRoleModel> roles;
  final List<PartnerRelationshipModel> relationships;
  final List<PartnerAddressModel> addresses;
  final List<PartnerContactModel> contacts;
  final List<PartnerIdentificationModel> identifications;
  final List<PartnerRegistrationModel> registrations;
  final PartnerComplianceModel? compliance;

  factory PartnerModel.empty() =>
      const PartnerModel(partnerType: PartnerType.legalPerson);

  factory PartnerModel.fromJson(Map<String, dynamic> json) => PartnerModel(
    id: json['id']?.toString(),
    partnerCode: json['partner_code']?.toString(),
    partnerType: PartnerTypeJson.fromJson(json['partner_type']?.toString()),
    displayName: json['display_name']?.toString(),
    legalName: json['legal_name']?.toString(),
    shortName: json['short_name']?.toString(),
    countryCode: json['country_code']?.toString(),
    defaultLanguage: json['default_language']?.toString(),
    defaultCurrencyCode: json['default_currency_code']?.toString(),
    externalReference: json['external_reference']?.toString(),
    remarks: json['remarks']?.toString(),
    status: PartnerStatusJson.fromJson(json['status']?.toString()),
    primaryContact: json['primary_contact']?.toString(),
    personProfile: json['person_profile'] is Map
        ? PersonProfileModel.fromJson(
            Map<String, dynamic>.from(json['person_profile'] as Map),
          )
        : null,
    legalEntityProfile: json['legal_entity_profile'] is Map
        ? LegalEntityProfileModel.fromJson(
            Map<String, dynamic>.from(json['legal_entity_profile'] as Map),
          )
        : null,
    roles: parseList(json['roles'], PartnerRoleModel.fromJson),
    relationships: parseList(
      json['relationships'],
      PartnerRelationshipModel.fromJson,
    ),
    addresses: parseList(json['addresses'], PartnerAddressModel.fromJson),
    contacts: parseList(json['contacts'], PartnerContactModel.fromJson),
    identifications: parseList(
      json['identifications'],
      PartnerIdentificationModel.fromJson,
    ),
    registrations: parseList(
      json['registrations'],
      PartnerRegistrationModel.fromJson,
    ),
    compliance: json['compliance'] is Map
        ? PartnerComplianceModel.fromJson(
            Map<String, dynamic>.from(json['compliance'] as Map),
          )
        : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'partner_code': partnerCode,
    'partner_type': partnerType.value,
    'display_name': displayName,
    'legal_name': legalName,
    'short_name': shortName,
    'country_code': countryCode,
    'default_language': defaultLanguage,
    'default_currency_code': defaultCurrencyCode,
    'external_reference': externalReference,
    'remarks': remarks,
    'status': status.value,
    'primary_contact': primaryContact,
    'person_profile': personProfile?.toJson(),
    'legal_entity_profile': legalEntityProfile?.toJson(),
    'roles': roles.map((item) => item.toJson()).toList(),
    'relationships': relationships.map((item) => item.toJson()).toList(),
    'addresses': addresses.map((item) => item.toJson()).toList(),
    'contacts': contacts.map((item) => item.toJson()).toList(),
    'identifications': identifications.map((item) => item.toJson()).toList(),
    'registrations': registrations.map((item) => item.toJson()).toList(),
    'compliance': compliance?.toJson(),
  };

  PartnerModel copyWith({
    String? id,
    String? partnerCode,
    PartnerType? partnerType,
    String? displayName,
    String? legalName,
    String? shortName,
    String? countryCode,
    String? defaultLanguage,
    String? defaultCurrencyCode,
    String? externalReference,
    String? remarks,
    PartnerStatus? status,
    String? primaryContact,
    PersonProfileModel? personProfile,
    LegalEntityProfileModel? legalEntityProfile,
    List<PartnerRoleModel>? roles,
    List<PartnerRelationshipModel>? relationships,
    List<PartnerAddressModel>? addresses,
    List<PartnerContactModel>? contacts,
    List<PartnerIdentificationModel>? identifications,
    List<PartnerRegistrationModel>? registrations,
    PartnerComplianceModel? compliance,
  }) => PartnerModel(
    id: id ?? this.id,
    partnerCode: partnerCode ?? this.partnerCode,
    partnerType: partnerType ?? this.partnerType,
    displayName: displayName ?? this.displayName,
    legalName: legalName ?? this.legalName,
    shortName: shortName ?? this.shortName,
    countryCode: countryCode ?? this.countryCode,
    defaultLanguage: defaultLanguage ?? this.defaultLanguage,
    defaultCurrencyCode: defaultCurrencyCode ?? this.defaultCurrencyCode,
    externalReference: externalReference ?? this.externalReference,
    remarks: remarks ?? this.remarks,
    status: status ?? this.status,
    primaryContact: primaryContact ?? this.primaryContact,
    personProfile: personProfile ?? this.personProfile,
    legalEntityProfile: legalEntityProfile ?? this.legalEntityProfile,
    roles: roles ?? this.roles,
    relationships: relationships ?? this.relationships,
    addresses: addresses ?? this.addresses,
    contacts: contacts ?? this.contacts,
    identifications: identifications ?? this.identifications,
    registrations: registrations ?? this.registrations,
    compliance: compliance ?? this.compliance,
  );
}
