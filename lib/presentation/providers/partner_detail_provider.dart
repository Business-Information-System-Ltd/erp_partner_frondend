/*
 * BizSoft ERP - Partners Module
 *
 * File:
 *   lib/features/partners/presentation/providers/partner_detail_provider.dart
 *
 * Purpose:
 *   Fetches Partner detail records by id.
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

import '../../domain/models/partner_model.dart';
import 'partner_providers.dart';

final partnerDetailProvider = FutureProvider.family<PartnerModel, String>((
  ref,
  id,
) async {
  return ref.watch(partnerRepositoryProvider).getPartner(id);
});
