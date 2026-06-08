/*
 * BizSoft ERP - Partners Module
 *
 * File:
 *   lib/features/partners/presentation/providers/partner_providers.dart
 *
 * Purpose:
 *   Provides shared API service and repository dependencies for Partner UI.
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

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:partner_demo/data/repositories/partner_repositories.dart';
import 'package:partner_demo/domain/enums/partner_enums.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../providers/partner_list_provider.dart';
import '../widgets/partner_status_chip.dart';

import '../../../../core/api/api_client.dart';
import '../../data/services/partner_api_service.dart';

const partnerApiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://localhost:8000',
);

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: partnerApiBaseUrl);
});

final partnerApiServiceProvider = Provider<PartnerApiService>((ref) {
  return PartnerApiService(ref.watch(apiClientProvider));
});

final partnerRepositoryProvider = Provider<PartnerRepository>((ref) {
  return PartnerRepository(ref.watch(partnerApiServiceProvider));
});

// partner_list_screen.dart

class PartnerListScreen extends ConsumerWidget {
  const PartnerListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(partnerListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Partners'),
        actions: [
          Row(
            children: [
              IconButton(
                tooltip: 'New Partner',
                icon: const Icon(Icons.add, size: 30, weight: 800),
                onPressed: () => context.go('/partners/new'),
              ),
              Text('Add New Partner'),
              SizedBox(width: 20),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) =>
                  ref.read(partnerListProvider.notifier).search(value),
            ),
          ),
          Expanded(
            child: state.loading
                ? const Center(child: CircularProgressIndicator())
                : state.error != null
                ? Center(child: Text('Error: ${state.error}'))
                : ListView.builder(
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      final partner = state.items[index];
                      return ListTile(
                        leading: Icon(
                          partner.partnerType == PartnerType.naturalPerson
                              ? Icons.person
                              : Icons.business,
                        ),
                        title: Text(
                          partner.displayName ?? partner.legalName ?? '',
                        ),
                        subtitle: Text(partner.partnerCode ?? ''),
                        trailing: PartnerStatusChip(status: partner.status),
                        onTap: () => context.go('/partners/${partner.id}'),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
