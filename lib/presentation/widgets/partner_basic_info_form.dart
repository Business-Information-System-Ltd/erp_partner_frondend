/*
 * BizSoft ERP - Partners Module
 *
 * File:
 *   lib/features/partners/presentation/widgets/partner_basic_info_form.dart
 *
 * Purpose:
 *   Renders editable common Partner master data fields.
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

import '../../../../core/widgets/app_section_card.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../domain/models/partner_model.dart';
import 'partner_type_dropdown.dart';

class PartnerBasicInfoForm extends StatelessWidget {
  const PartnerBasicInfoForm({
    super.key,
    required this.partner,
    required this.onChanged,
    this.errors = const <String, String>{},
    this.enabled = true,
  });

  final PartnerModel partner;
  final ValueChanged<PartnerModel> onChanged;
  final Map<String, String> errors;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return AppSectionCard(
      title: 'Basic Information',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 720;
          final fields = [
            PartnerTypeDropdown(
              value: partner.partnerType,
              enabled: enabled,
              onChanged: (value) {
                if (value != null) {
                  onChanged(partner.copyWith(partnerType: value));
                }
              },
            ),
            AppTextField(
              label: 'Partner Code',
              value: partner.partnerCode,
              enabled: enabled,
              onChanged: (value) =>
                  onChanged(partner.copyWith(partnerCode: value)),
            ),
            AppTextField(
              label: 'Display Name',
              value: partner.displayName,
              enabled: enabled,
              errorText: errors['display_name'],
              onChanged: (value) =>
                  onChanged(partner.copyWith(displayName: value)),
            ),
            AppTextField(
              label: 'Legal Name',
              value: partner.legalName,
              enabled: enabled,
              onChanged: (value) =>
                  onChanged(partner.copyWith(legalName: value)),
            ),
            AppTextField(
              label: 'Short Name',
              value: partner.shortName,
              enabled: enabled,
              onChanged: (value) =>
                  onChanged(partner.copyWith(shortName: value)),
            ),
            AppTextField(
              label: 'Country Code',
              value: partner.countryCode,
              enabled: enabled,
              errorText: errors['country_code'],
              onChanged: (value) =>
                  onChanged(partner.copyWith(countryCode: value.toUpperCase())),
            ),
            AppTextField(
              label: 'Default Language',
              value: partner.defaultLanguage,
              enabled: enabled,
              onChanged: (value) => onChanged(
                partner.copyWith(defaultLanguage: value.toLowerCase()),
              ),
            ),
            AppTextField(
              label: 'Default Currency',
              value: partner.defaultCurrencyCode,
              enabled: enabled,
              errorText: errors['default_currency_code'],
              onChanged: (value) => onChanged(
                partner.copyWith(defaultCurrencyCode: value.toUpperCase()),
              ),
            ),
            AppTextField(
              label: 'External Reference',
              value: partner.externalReference,
              enabled: enabled,
              onChanged: (value) =>
                  onChanged(partner.copyWith(externalReference: value)),
            ),
            AppTextField(
              label: 'Primary Contact',
              value: partner.primaryContact,
              enabled: enabled,
              onChanged: (value) =>
                  onChanged(partner.copyWith(primaryContact: value)),
            ),
          ];

          return Column(
            children: [
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  for (final field in fields)
                    SizedBox(
                      width: wide
                          ? (constraints.maxWidth - 12) / 2
                          : constraints.maxWidth,
                      child: field,
                    ),
                ],
              ),
              const SizedBox(height: 12),
              AppTextField(
                label: 'Remarks',
                value: partner.remarks,
                enabled: enabled,
                maxLines: 3,
                onChanged: (value) =>
                    onChanged(partner.copyWith(remarks: value)),
              ),
            ],
          );
        },
      ),
    );
  }
}
