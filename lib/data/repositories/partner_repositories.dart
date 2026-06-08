/*
 * BizSoft ERP - Partners Module
 *
 * File:
 *   lib/features/partners/data/repositories/partner_repository.dart
 *
 * Purpose:
 *   Converts Partner API data into domain models for UI providers.
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

import '../../domain/enums/partner_enums.dart';
import '../../domain/models/partner_model.dart';
import '../services/partner_api_service.dart';

class PartnerListPage {
  const PartnerListPage({
    required this.items,
    required this.count,
    required this.page,
    required this.hasNext,
    required this.hasPrevious,
  });

  final List<PartnerModel> items;
  final int count;
  final int page;
  final bool hasNext;
  final bool hasPrevious;
}

class PartnerRepository {
  const PartnerRepository(this._apiService);

  final PartnerApiService _apiService;

  Future<PartnerListPage> listPartners({
    String? search,
    PartnerType? partnerType,
    PartnerRoleType? roleType,
    PartnerStatus? status,
    int page = 1,
  }) async {
    final data = await _apiService.listPartners(
      search: search,
      partnerType: partnerType?.value,
      roleType: roleType?.value,
      status: status?.value,
      page: page,
    );
    final rawResults = data['results'];
    final rawItems = rawResults is List ? rawResults : data['items'];
    final items = rawItems is List
        ? rawItems.whereType<Map>().map((item) => PartnerModel.fromJson(Map<String, dynamic>.from(item))).toList()
        : <PartnerModel>[];
    return PartnerListPage(
      items: items,
      count: data['count'] is int ? data['count'] as int : items.length,
      page: page,
      hasNext: data['next'] != null,
      hasPrevious: data['previous'] != null,
    );
  }

  Future<PartnerModel> getPartner(String id) async {
    final data = await _apiService.getPartner(id);
    return PartnerModel.fromJson(data);
  }

  Future<PartnerModel> createPartner(PartnerModel partner) async {
    final data = await _apiService.createPartner(partner.toJson());
    return PartnerModel.fromJson(data);
  }

  Future<PartnerModel> updatePartner(PartnerModel partner) async {
    final id = partner.id;
    if (id == null) {
      throw ArgumentError('Partner id is required for update.');
    }
    final data = await _apiService.updatePartner(id, partner.toJson());
    return PartnerModel.fromJson(data);
  }

  Future<void> activatePartner(String id) => _apiService.activatePartner(id);

  Future<void> blockPartner(String id) => _apiService.blockPartner(id);
}
