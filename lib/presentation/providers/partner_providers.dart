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

import '../../../../core/api/api_client.dart';
import '../../data/services/partner_api_service.dart';

const partnerApiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://127.0.0.1:8000',
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
