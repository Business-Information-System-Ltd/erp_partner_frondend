/*
 * BizSoft ERP - Partners Module
 *
 * File:
 *   lib/features/partners/presentation/screens/partner_detail_screen.dart
 *
 * Purpose:
 *   Displays read-only Partner master data detail.
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
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:partner_demo/domain/enums/partner_enums.dart';

import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../../core/widgets/app_section_card.dart';
import '../../domain/models/partner_model.dart';
import '../providers/partner_detail_provider.dart';
import '../widgets/partner_child_sections.dart';
import '../widgets/partner_status_chip.dart';

class PartnerDetailScreen extends ConsumerWidget {
  const PartnerDetailScreen({super.key, required this.partnerId});

  final String partnerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPartner = ref.watch(partnerDetailProvider(partnerId));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Partner Detail'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/partners'),
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(partnerDetailProvider(partnerId)),
          ),
          IconButton(
            tooltip: 'Edit',
            icon: const Icon(Icons.edit),
            onPressed: () => context.go('/partners/$partnerId/edit'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: asyncPartner.when(
        data: (partner) => _PartnerDetailBody(partner: partner),
        loading: () => const AppLoadingIndicator(message: 'Loading partner...'),
        error: (error, _) => AppErrorView(
          message: error.toString(),
          onRetry: () => ref.invalidate(partnerDetailProvider(partnerId)),
        ),
      ),
    );
  }
}

class _PartnerDetailBody extends StatelessWidget {
  const _PartnerDetailBody({required this.partner});

  final PartnerModel partner;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        AppSectionCard(
          title: partner.displayName ?? partner.legalName ?? 'Partner',
          trailing: PartnerStatusChip(status: partner.status),
          child: Wrap(
            spacing: 24,
            runSpacing: 12,
            children: [
              _Info(label: 'Code', value: partner.partnerCode),
              _Info(label: 'Type', value: partner.partnerType.label),
              _Info(label: 'Legal Name', value: partner.legalName),
              _Info(label: 'Short Name', value: partner.shortName),
              _Info(label: 'Country', value: partner.countryCode),
              _Info(label: 'Language', value: partner.defaultLanguage),
              _Info(label: 'Currency', value: partner.defaultCurrencyCode),
              _Info(label: 'Primary Contact', value: partner.primaryContact),
              _Info(label: 'External Ref', value: partner.externalReference),
              _Info(label: 'Remarks', value: partner.remarks),
            ],
          ),
        ),
        const SizedBox(height: 12),
        PartnerRoleSection(partner: partner),
        const SizedBox(height: 12),
        PartnerRelationshipSection(partner: partner),
        const SizedBox(height: 12),
        PartnerAddressSection(partner: partner),
        const SizedBox(height: 12),
        PartnerContactSection(partner: partner),
        const SizedBox(height: 12),
        PartnerIdentificationSection(partner: partner),
        const SizedBox(height: 12),
        PartnerRegistrationSection(partner: partner),
        const SizedBox(height: 12),
        PartnerComplianceSection(partner: partner),
      ],
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
