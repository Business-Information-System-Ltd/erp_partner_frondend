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
          (dio ??
          Dio(
            BaseOptions(
              baseUrl: baseUrl,
              connectTimeout: const Duration(seconds: 20),
              receiveTimeout: const Duration(seconds: 30),
              headers: {'Accept': 'application/json'},
              validateStatus: (status) => status != null && status < 500,
            ),
          ));

  final Dio dio;

  //   ApiException normalizeError(Object error) {
  //     if (error is DioException) {
  //       final response = error.response;
  //       final data = response?.data;
  //       final validationErrors = <String, List<String>>{};

  //       if (data is Map<String, dynamic>) {
  //         for (final entry in data.entries) {
  //           final value = entry.value;
  //           if (value is List) {
  //             validationErrors[entry.key] = value.map((item) => '$item').toList();
  //           } else {
  //             validationErrors[entry.key] = ['$value'];
  //           }
  //         }
  //       }

  //       return ApiException(
  //         message:
  //             response?.statusMessage ?? error.message ?? 'API request failed.',
  //         statusCode: response?.statusCode,
  //         validationErrors: validationErrors,
  //       );
  //     }

  //     return ApiException(message: error.toString());
  //   }
  // }

  ApiException normalizeError(Object error) {
    if (error is DioException) {
      final response = error.response;
      final data = response?.data;
      final statusCode = response?.statusCode;
      final statusMessage = response?.statusMessage;
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

      // Build a meaningful message
      String message = statusMessage ?? 'API request failed.';
      if (statusCode == 422 && validationErrors.isNotEmpty) {
        message = 'Validation error. Please check the fields.';
      } else if (statusCode == 404) {
        message = 'Resource not found.';
      } else if (statusCode == 401) {
        message = 'Unauthorized. Please log in again.';
      } else if (statusCode == 500) {
        message = 'Server error. Please try again later.';
      } else if (error.message != null) {
        message = error.message!;
      }

      return ApiException(
        message: message,
        statusCode: statusCode,
        validationErrors: validationErrors,
        responseData: data,
      );
    }

    return ApiException(message: error.toString());
  }
}
