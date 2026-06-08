/*
 * BizSoft ERP - Partners Module
 *
 * File:
 *   lib/features/partners/presentation/widgets/legal_entity_profile_form.dart
 *
 * Purpose:
 *   Renders legal entity profile fields for a Partner.
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

import '../../../../core/widgets/app_date_field.dart';
import '../../../../core/widgets/app_section_card.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../domain/models/legal_entity_profile_model.dart';

class LegalEntityProfileForm extends StatelessWidget {
  const LegalEntityProfileForm({
    super.key,
    required this.profile,
    required this.onChanged,
    this.enabled = true,
  });

  final LegalEntityProfileModel profile;
  final ValueChanged<LegalEntityProfileModel> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return AppSectionCard(
      title: 'Legal Entity Profile',
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          SizedBox(
            width: 360,
            child: AppTextField(
              label: 'Registered Name',
              value: profile.registeredName,
              enabled: enabled,
              onChanged: (v) => onChanged(profile.copyWith(registeredName: v)),
            ),
          ),
          SizedBox(
            width: 360,
            child: AppTextField(
              label: 'Trade Name',
              value: profile.tradeName,
              enabled: enabled,
              onChanged: (v) => onChanged(profile.copyWith(tradeName: v)),
            ),
          ),
          SizedBox(
            width: 240,
            child: AppTextField(
              label: 'Legal Form',
              value: profile.legalForm,
              enabled: enabled,
              onChanged: (v) => onChanged(profile.copyWith(legalForm: v)),
            ),
          ),
          SizedBox(
            width: 240,
            child: AppDateField(
              label: 'Incorporation Date',
              value: profile.incorporationDate,
              enabled: enabled,
              onChanged: (v) =>
                  onChanged(profile.copyWith(incorporationDate: v)),
            ),
          ),
          SizedBox(
            width: 240,
            child: AppTextField(
              label: 'Incorporation Country',
              value: profile.incorporationCountryCode,
              enabled: enabled,
              onChanged: (v) => onChanged(
                profile.copyWith(incorporationCountryCode: v.toUpperCase()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
