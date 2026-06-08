/*
 * BizSoft ERP - Partners Module
 *
 * File:
 *   lib/core/widgets/app_data_table.dart
 *
 * Purpose:
 *   Provides a reusable horizontally scrollable DataTable wrapper.
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

import 'package:flutter/material.dart';

class AppDataTable extends StatelessWidget {
  const AppDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.emptyText = 'No records found.',
  });

  final List<DataColumn> columns;
  final List<DataRow> rows;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) {
      return Center(child: Text(emptyText));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(columns: columns, rows: rows),
    );
  }
}
