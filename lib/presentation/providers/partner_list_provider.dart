/*
 * BizSoft ERP - Partners Module
 *
 * File:
 *   lib/features/partners/presentation/providers/partner_list_provider.dart
 *
 * Purpose:
 *   Manages Partner browse/search/filter list state.
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

// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:partner_demo/core/api/api_exception.dart';
import 'package:partner_demo/data/repositories/partner_repositories.dart';
import '../../domain/enums/partner_enums.dart';
import '../../domain/models/partner_model.dart';
import 'partner_providers.dart';

class PartnerListState {
  const PartnerListState({
    this.items = const <PartnerModel>[],
    this.loading = false,
    this.error,
    this.search = '',
    this.partnerType,
    this.roleType,
    this.status,
    this.page = 1,
    this.count = 0,
    this.hasNext = false,
    this.hasPrevious = false,
  });

  final List<PartnerModel> items;
  final bool loading;
  final String? error;
  final String search;
  final PartnerType? partnerType;
  final PartnerRoleType? roleType;
  final PartnerStatus? status;
  final int page;
  final int count;
  final bool hasNext;
  final bool hasPrevious;

  PartnerListState copyWith({
    List<PartnerModel>? items,
    bool? loading,
    String? error,
    String? search,
    PartnerType? partnerType,
    PartnerRoleType? roleType,
    PartnerStatus? status,
    int? page,
    int? count,
    bool? hasNext,
    bool? hasPrevious,
    bool clearError = false,
    bool clearPartnerType = false,
    bool clearRoleType = false,
    bool clearStatus = false,
  }) => PartnerListState(
    items: items ?? this.items,
    loading: loading ?? this.loading,
    error: clearError ? null : error ?? this.error,
    search: search ?? this.search,
    partnerType: clearPartnerType ? null : partnerType ?? this.partnerType,
    roleType: clearRoleType ? null : roleType ?? this.roleType,
    status: clearStatus ? null : status ?? this.status,
    page: page ?? this.page,
    count: count ?? this.count,
    hasNext: hasNext ?? this.hasNext,
    hasPrevious: hasPrevious ?? this.hasPrevious,
  );
}

class PartnerListNotifier extends StateNotifier<PartnerListState> {
  PartnerListNotifier(this._repository) : super(const PartnerListState());

  final PartnerRepository _repository;

  Future<void> load({int? page}) async {
    state = state.copyWith(loading: true, clearError: true);
    try {
      final result = await _repository.listPartners(
        search: state.search,
        partnerType: state.partnerType,
        roleType: state.roleType,
        status: state.status,
        page: page ?? state.page,
      );
      state = state.copyWith(
        items: result.items,
        loading: false,
        page: result.page,
        count: result.count,
        hasNext: result.hasNext,
        hasPrevious: result.hasPrevious,
        clearError: true,
      );
    } catch (error) {
      final msg = error is ApiException ? error.fullMessage : error.toString();
      state = state.copyWith(loading: false, error: msg);
    }
  }

  Future<void> search(String value) async {
    state = state.copyWith(search: value, page: 1);
    await load(page: 1);
  }

  Future<void> setFilters({
    PartnerType? partnerType,
    PartnerRoleType? roleType,
    PartnerStatus? status,
    bool clearPartnerType = false,
    bool clearRoleType = false,
    bool clearStatus = false,
  }) async {
    state = state.copyWith(
      partnerType: partnerType,
      roleType: roleType,
      status: status,
      clearPartnerType: clearPartnerType,
      clearRoleType: clearRoleType,
      clearStatus: clearStatus,
      page: 1,
    );
    await load(page: 1);
  }
}

final partnerListProvider =
    StateNotifierProvider<PartnerListNotifier, PartnerListState>((ref) {
      return PartnerListNotifier(ref.watch(partnerRepositoryProvider));
    });
