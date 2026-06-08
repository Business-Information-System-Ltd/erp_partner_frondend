/*
 * BizSoft ERP - Partners Module
 *
 * File:
 *   lib/features/partners/presentation/widgets/partner_child_sections.dart
 *
 * Purpose:
 *   Provides reusable Partner child-record sections for tabs and detail pages.
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

import 'package:flutter/material.dart';
import 'package:partner_demo/domain/enums/partner_enums.dart';

import '../../../../core/widgets/app_data_table.dart';
import '../../../../core/widgets/app_section_card.dart';
import '../../domain/models/partner_model.dart';

class PartnerRoleSection extends StatelessWidget {
  const PartnerRoleSection({
    super.key,
    required this.partner,
    this.editable = false,
  });

  final PartnerModel partner;
  final bool editable;

  @override
  Widget build(BuildContext context) {
    return _SectionShell(
      title: 'Roles',
      partner: partner,
      editable: editable,
      child: AppDataTable(
        columns: const [
          DataColumn(label: Text('Role')),
          DataColumn(label: Text('Primary')),
          DataColumn(label: Text('Valid From')),
          DataColumn(label: Text('Valid To')),
        ],
        rows: [
          for (final role in partner.roles)
            DataRow(
              cells: [
                DataCell(Text(role.roleType.label)),
                DataCell(Text(role.isPrimary ? 'Yes' : 'No')),
                DataCell(Text(_date(role.validFrom))),
                DataCell(Text(_date(role.validTo))),
              ],
            ),
        ],
      ),
    );
  }
}

class PartnerRelationshipSection extends StatelessWidget {
  const PartnerRelationshipSection({
    super.key,
    required this.partner,
    this.editable = false,
  });

  final PartnerModel partner;
  final bool editable;

  @override
  Widget build(BuildContext context) {
    return _SectionShell(
      title: 'Relationships',
      partner: partner,
      editable: editable,
      child: AppDataTable(
        columns: const [
          DataColumn(label: Text('Partner')),
          DataColumn(label: Text('Type')),
          DataColumn(label: Text('Valid From')),
          DataColumn(label: Text('Valid To')),
        ],
        rows: [
          for (final item in partner.relationships)
            DataRow(
              cells: [
                DataCell(
                  Text(item.relatedPartnerName ?? item.relatedPartnerId ?? '-'),
                ),
                DataCell(Text(item.relationshipType ?? '-')),
                DataCell(Text(_date(item.validFrom))),
                DataCell(Text(_date(item.validTo))),
              ],
            ),
        ],
      ),
    );
  }
}

class PartnerAddressSection extends StatelessWidget {
  const PartnerAddressSection({
    super.key,
    required this.partner,
    this.editable = false,
  });

  final PartnerModel partner;
  final bool editable;

  @override
  Widget build(BuildContext context) {
    return _SectionShell(
      title: 'Addresses',
      partner: partner,
      editable: editable,
      child: AppDataTable(
        columns: const [
          DataColumn(label: Text('Type')),
          DataColumn(label: Text('Address')),
          DataColumn(label: Text('City')),
          DataColumn(label: Text('Country')),
          DataColumn(label: Text('Primary')),
        ],
        rows: [
          for (final item in partner.addresses)
            DataRow(
              cells: [
                DataCell(Text(item.addressType ?? '-')),
                DataCell(
                  Text([item.line1, item.line2].whereType<String>().join(', ')),
                ),
                DataCell(Text(item.city ?? '-')),
                DataCell(Text(item.countryCode ?? '-')),
                DataCell(Text(item.isPrimary ? 'Yes' : 'No')),
              ],
            ),
        ],
      ),
    );
  }
}

class PartnerContactSection extends StatelessWidget {
  const PartnerContactSection({
    super.key,
    required this.partner,
    this.editable = false,
  });

  final PartnerModel partner;
  final bool editable;

  @override
  Widget build(BuildContext context) {
    return _SectionShell(
      title: 'Contacts',
      partner: partner,
      editable: editable,
      child: AppDataTable(
        columns: const [
          DataColumn(label: Text('Type')),
          DataColumn(label: Text('Value')),
          DataColumn(label: Text('Person')),
          DataColumn(label: Text('Primary')),
        ],
        rows: [
          for (final item in partner.contacts)
            DataRow(
              cells: [
                DataCell(Text(item.contactType ?? '-')),
                DataCell(Text(item.value ?? '-')),
                DataCell(Text(item.personName ?? '-')),
                DataCell(Text(item.isPrimary ? 'Yes' : 'No')),
              ],
            ),
        ],
      ),
    );
  }
}

class PartnerIdentificationSection extends StatelessWidget {
  const PartnerIdentificationSection({
    super.key,
    required this.partner,
    this.editable = false,
  });

  final PartnerModel partner;
  final bool editable;

  @override
  Widget build(BuildContext context) {
    return _SectionShell(
      title: 'Identification',
      partner: partner,
      editable: editable,
      child: AppDataTable(
        columns: const [
          DataColumn(label: Text('Type')),
          DataColumn(label: Text('Number')),
          DataColumn(label: Text('Issued By')),
          DataColumn(label: Text('Expiry')),
        ],
        rows: [
          for (final item in partner.identifications)
            DataRow(
              cells: [
                DataCell(Text(item.idType ?? '-')),
                DataCell(Text(item.idNumber ?? '-')),
                DataCell(Text(item.issuedBy ?? '-')),
                DataCell(Text(_date(item.expiryDate))),
              ],
            ),
        ],
      ),
    );
  }
}

class PartnerRegistrationSection extends StatelessWidget {
  const PartnerRegistrationSection({
    super.key,
    required this.partner,
    this.editable = false,
  });

  final PartnerModel partner;
  final bool editable;

  @override
  Widget build(BuildContext context) {
    return _SectionShell(
      title: 'Registrations',
      partner: partner,
      editable: editable,
      child: AppDataTable(
        columns: const [
          DataColumn(label: Text('Type')),
          DataColumn(label: Text('Number')),
          DataColumn(label: Text('Country')),
          DataColumn(label: Text('Valid To')),
        ],
        rows: [
          for (final item in partner.registrations)
            DataRow(
              cells: [
                DataCell(Text(item.registrationType ?? '-')),
                DataCell(Text(item.registrationNumber ?? '-')),
                DataCell(Text(item.countryCode ?? '-')),
                DataCell(Text(_date(item.validTo))),
              ],
            ),
        ],
      ),
    );
  }
}

class PartnerComplianceSection extends StatelessWidget {
  const PartnerComplianceSection({
    super.key,
    required this.partner,
    this.editable = false,
  });

  final PartnerModel partner;
  final bool editable;

  @override
  Widget build(BuildContext context) {
    final compliance = partner.compliance;
    return _SectionShell(
      title: 'Compliance',
      partner: partner,
      editable: editable,
      child: compliance == null
          ? const Text('No compliance information recorded.')
          : Wrap(
              spacing: 24,
              runSpacing: 8,
              children: [
                _Info(label: 'Risk Level', value: compliance.riskLevel),
                _Info(
                  label: 'Screening Status',
                  value: compliance.screeningStatus,
                ),
                _Info(
                  label: 'Last Screened',
                  value: _date(compliance.lastScreenedDate),
                ),
                _Info(label: 'Notes', value: compliance.notes),
              ],
            ),
    );
  }
}

class _SectionShell extends StatelessWidget {
  const _SectionShell({
    required this.title,
    required this.partner,
    required this.child,
    required this.editable,
  });

  final String title;
  final PartnerModel partner;
  final Widget child;
  final bool editable;

  @override
  Widget build(BuildContext context) {
    return AppSectionCard(
      title: title,
      trailing: editable
          ? FilledButton.icon(
              onPressed: partner.id == null ? null : () {},
              icon: const Icon(Icons.add),
              label: const Text('Add'),
            )
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (editable && partner.id == null)
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text(
                'Save the partner first before adding child records.',
              ),
            ),
          child,
        ],
      ),
    );
  }
}

class _Info extends StatelessWidget {
  const _Info({required this.label, required this.value});

  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 2),
          Text(value == null || value!.isEmpty ? '-' : value!),
        ],
      ),
    );
  }
}

String _date(DateTime? value) {
  if (value == null) {
    return '-';
  }
  return '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
}
