/*
 * BizSoft ERP - Partners Module
 *
 * File:
 *   lib/core/api/api_client.dart
 *
 * Purpose:
 *   Configures Dio and normalizes API errors for the Partner UI.
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

import 'package:dio/dio.dart';

import 'api_exception.dart';

class ApiClient {
  ApiClient({required String baseUrl, Dio? dio})
    : dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: baseUrl,
              connectTimeout: const Duration(seconds: 20),
              receiveTimeout: const Duration(seconds: 30),
              headers: {'Accept': 'application/json'},
            ),
          );

  final Dio dio;

  ApiException normalizeError(Object error) {
    if (error is DioException) {
      final response = error.response;
      final data = response?.data;
      final validationErrors = <String, List<String>>{};

      if (data is Map<String, dynamic>) {
        for (final entry in data.entries) {
          final value = entry.value;
          if (value is List) {
            validationErrors[entry.key] = value.map((item) => '$item').toList();
          } else {
            validationErrors[entry.key] = ['$value'];
          }
        }
      }

      return ApiException(
        message:
            response?.statusMessage ?? error.message ?? 'API request failed.',
        statusCode: response?.statusCode,
        validationErrors: validationErrors,
      );
    }

    return ApiException(message: error.toString());
  }
}
