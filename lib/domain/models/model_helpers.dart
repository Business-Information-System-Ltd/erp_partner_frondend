/*
 * BizSoft ERP - Partners Module
 *
 * File:
 *   lib/features/partners/domain/models/model_helpers.dart
 *
 * Purpose:
 *   Provides JSON parsing helpers shared by Partner model classes.
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

DateTime? parseDate(dynamic value) {
  if (value == null || '$value'.isEmpty) {
    return null;
  }
  return DateTime.tryParse('$value');
}

String? dateToJson(DateTime? value) {
  if (value == null) {
    return null;
  }
  return '${value.year.toString().padLeft(4, '0')}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
}

List<T> parseList<T>(dynamic value, T Function(Map<String, dynamic>) parser) {
  if (value is! List) {
    return <T>[];
  }
  return value
      .whereType<Map>()
      .map((item) => parser(Map<String, dynamic>.from(item)))
      .toList();
}
