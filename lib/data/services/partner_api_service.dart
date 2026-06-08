/*
 * BizSoft ERP - Partners Module
 *
 * File:
 *   lib/features/partners/data/services/partner_api_service.dart
 *
 * Purpose:
 *   Calls Django Partner API endpoints using Dio.
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

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_exception.dart';

class PartnerApiService {
  const PartnerApiService(this._client);

  final ApiClient _client;

  Future<Map<String, dynamic>> listPartners({
    String? search,
    String? partnerType,
    String? roleType,
    String? status,
    int page = 1,
  }) async {
    try {
      final response = await _client.dio.get<Map<String, dynamic>>(
        '/api/partners/',
        queryParameters: {
          if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
          if (partnerType != null) 'partner_type': partnerType,
          if (roleType != null) 'role_type': roleType,
          if (status != null) 'status': status,
          'page': page,
        },
      );
      return response.data ?? <String, dynamic>{};
    } catch (error) {
      throw _client.normalizeError(error);
    }
  }

  Future<Map<String, dynamic>> getPartner(String id) async {
    try {
      final response = await _client.dio.get<Map<String, dynamic>>('/api/partners/$id/');
      return response.data ?? <String, dynamic>{};
    } catch (error) {
      throw _client.normalizeError(error);
    }
  }

  Future<Map<String, dynamic>> createPartner(Map<String, dynamic> data) async {
    try {
      final response = await _client.dio.post<Map<String, dynamic>>('/api/partners/', data: data);
      return response.data ?? <String, dynamic>{};
    } catch (error) {
      throw _client.normalizeError(error);
    }
  }

  Future<Map<String, dynamic>> updatePartner(String id, Map<String, dynamic> data) async {
    try {
      final response = await _client.dio.put<Map<String, dynamic>>('/api/partners/$id/', data: data);
      return response.data ?? <String, dynamic>{};
    } catch (error) {
      throw _client.normalizeError(error);
    }
  }

  Future<Map<String, dynamic>> patchPartner(String id, Map<String, dynamic> data) async {
    try {
      final response = await _client.dio.patch<Map<String, dynamic>>('/api/partners/$id/', data: data);
      return response.data ?? <String, dynamic>{};
    } catch (error) {
      throw _client.normalizeError(error);
    }
  }

  Future<void> activatePartner(String id) async => _action(id, 'activate');

  Future<void> blockPartner(String id) async => _action(id, 'block');

  Future<void> _action(String id, String action) async {
    try {
      await _client.dio.post<void>('/api/partners/$id/$action/');
    } catch (error) {
      throw _client.normalizeError(error);
    }
  }

  Future<List<Map<String, dynamic>>> listChildRecords(String partnerId, String childName) async {
    try {
      final response = await _client.dio.get<dynamic>('/api/partners/$partnerId/$childName/');
      final data = response.data;
      if (data is Map && data['results'] is List) {
        return (data['results'] as List).whereType<Map>().map((item) => Map<String, dynamic>.from(item)).toList();
      }
      if (data is List) {
        return data.whereType<Map>().map((item) => Map<String, dynamic>.from(item)).toList();
      }
      return <Map<String, dynamic>>[];
    } catch (error) {
      throw _client.normalizeError(error);
    }
  }

  Future<Map<String, dynamic>> createChildRecord(
    String partnerId,
    String childName,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.dio.post<Map<String, dynamic>>(
        '/api/partners/$partnerId/$childName/',
        data: data,
      );
      return response.data ?? <String, dynamic>{};
    } catch (error) {
      throw _client.normalizeError(error);
    }
  }
}
