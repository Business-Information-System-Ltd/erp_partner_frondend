/*
 * BizSoft ERP - Partners Module
 *
 * File:
 *   lib/core/api/api_exception.dart
 *
 * Purpose:
 *   Defines normalized API exception details for Partner UI requests.
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

// class ApiException implements Exception {
//   const ApiException({
//     required this.message,
//     this.statusCode,
//     this.validationErrors = const <String, List<String>>{},
//   });

//   final String message;
//   final int? statusCode;
//   final Map<String, List<String>> validationErrors;

//   bool get hasValidationErrors => validationErrors.isNotEmpty;

//   @override
//   String toString() => message;
// }

class ApiException implements Exception {
  const ApiException({
    required this.message,
    this.statusCode,
    this.validationErrors = const <String, List<String>>{},
    this.responseData,
  });

  final String message;
  final int? statusCode;
  final Map<String, List<String>> validationErrors;
  final dynamic responseData; // raw server response

  bool get hasValidationErrors => validationErrors.isNotEmpty;

  String get fullMessage {
    final buffer = StringBuffer();
    if (statusCode != null) buffer.write('HTTP $statusCode: ');
    buffer.write(message);
    if (hasValidationErrors) {
      buffer.write(' – Validation: $validationErrors');
    }
    return buffer.toString();
  }

  @override
  String toString() => fullMessage;
}
