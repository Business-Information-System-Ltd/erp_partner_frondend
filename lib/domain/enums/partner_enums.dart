/*
 * BizSoft ERP - Partners Module
 *
 * File:
 *   lib/features/partners/domain/enums/partner_enums.dart
 *
 * Purpose:
 *   Defines Partner module enum values and JSON helpers.
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

enum PartnerType {
  naturalPerson,
  legalPerson,
  governmentBody,
  internalOrganization,
}

enum PartnerStatus { draft, active, blocked, inactive }

enum PartnerRoleType { customer, supplier, employee, bank, taxAuthority, other }

extension PartnerTypeJson on PartnerType {
  String get value => switch (this) {
    PartnerType.naturalPerson => 'NATURAL_PERSON',
    PartnerType.legalPerson => 'LEGAL_PERSON',
    PartnerType.governmentBody => 'GOVERNMENT_BODY',
    PartnerType.internalOrganization => 'INTERNAL_ORGANIZATION',
  };

  String get label => switch (this) {
    PartnerType.naturalPerson => 'Natural Person',
    PartnerType.legalPerson => 'Legal Person',
    PartnerType.governmentBody => 'Government Body',
    PartnerType.internalOrganization => 'Internal Organization',
  };

  static PartnerType fromJson(String? value) => PartnerType.values.firstWhere(
    (item) => item.value == value,
    orElse: () => PartnerType.legalPerson,
  );
}

extension PartnerStatusJson on PartnerStatus {
  String get value => switch (this) {
    PartnerStatus.draft => 'DRAFT',
    PartnerStatus.active => 'ACTIVE',
    PartnerStatus.blocked => 'BLOCKED',
    PartnerStatus.inactive => 'INACTIVE',
  };

  String get label => switch (this) {
    PartnerStatus.draft => 'Draft',
    PartnerStatus.active => 'Active',
    PartnerStatus.blocked => 'Blocked',
    PartnerStatus.inactive => 'Inactive',
  };

  static PartnerStatus fromJson(String? value) =>
      PartnerStatus.values.firstWhere(
        (item) => item.value == value,
        orElse: () => PartnerStatus.draft,
      );
}

extension PartnerRoleTypeJson on PartnerRoleType {
  String get value => switch (this) {
    PartnerRoleType.customer => 'CUSTOMER',
    PartnerRoleType.supplier => 'SUPPLIER',
    PartnerRoleType.employee => 'EMPLOYEE',
    PartnerRoleType.bank => 'BANK',
    PartnerRoleType.taxAuthority => 'TAX_AUTHORITY',
    PartnerRoleType.other => 'OTHER',
  };

  String get label => switch (this) {
    PartnerRoleType.customer => 'Customer',
    PartnerRoleType.supplier => 'Supplier',
    PartnerRoleType.employee => 'Employee',
    PartnerRoleType.bank => 'Bank',
    PartnerRoleType.taxAuthority => 'Tax Authority',
    PartnerRoleType.other => 'Other',
  };

  static PartnerRoleType fromJson(String? value) =>
      PartnerRoleType.values.firstWhere(
        (item) => item.value == value,
        orElse: () => PartnerRoleType.other,
      );
}
