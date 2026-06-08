/*
 * BizSoft ERP - Partners Module
 *
 * File:
 *   lib/features/partners/presentation/widgets/person_profile_form.dart
 *
 * Purpose:
 *   Renders natural person profile fields for a Partner.
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
import '../../domain/models/person_profile_model.dart';

class PersonProfileForm extends StatelessWidget {
  const PersonProfileForm({
    super.key,
    required this.profile,
    required this.onChanged,
    this.enabled = true,
  });

  final PersonProfileModel profile;
  final ValueChanged<PersonProfileModel> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return AppSectionCard(
      title: 'Person Profile',
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          SizedBox(
            width: 320,
            child: AppTextField(
              label: 'First Name',
              value: profile.firstName,
              enabled: enabled,
              onChanged: (v) => onChanged(profile.copyWith(firstName: v)),
            ),
          ),
          SizedBox(
            width: 320,
            child: AppTextField(
              label: 'Middle Name',
              value: profile.middleName,
              enabled: enabled,
              onChanged: (v) => onChanged(profile.copyWith(middleName: v)),
            ),
          ),
          SizedBox(
            width: 320,
            child: AppTextField(
              label: 'Last Name',
              value: profile.lastName,
              enabled: enabled,
              onChanged: (v) => onChanged(profile.copyWith(lastName: v)),
            ),
          ),
          SizedBox(
            width: 320,
            child: AppDateField(
              label: 'Date of Birth',
              value: profile.dateOfBirth,
              enabled: enabled,
              onChanged: (v) => onChanged(profile.copyWith(dateOfBirth: v)),
            ),
          ),
          SizedBox(
            width: 320,
            child: AppTextField(
              label: 'Gender',
              value: profile.gender,
              enabled: enabled,
              onChanged: (v) => onChanged(profile.copyWith(gender: v)),
            ),
          ),
          SizedBox(
            width: 320,
            child: AppTextField(
              label: 'Nationality Code',
              value: profile.nationalityCode,
              enabled: enabled,
              onChanged: (v) =>
                  onChanged(profile.copyWith(nationalityCode: v.toUpperCase())),
            ),
          ),
        ],
      ),
    );
  }
}
