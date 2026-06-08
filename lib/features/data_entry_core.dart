import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

import 'reusable_search_box.dart';

enum DataEntryOpenMode { popup, page }

enum DataEntrySaveAction { save, saveAndNew }

enum DataEntryBrowserMode { local, lazyPagination }

abstract class DataEntryRepository<T> {
  Future<List<T>> search(SearchResult search);

  Future<T> save(T record);
}

class DataEntryLazyPage<T> {
  const DataEntryLazyPage({required this.totalPages, required this.records});

  final int totalPages;
  final List<T> records;
}

abstract class DataEntryLazyRepository<T> extends DataEntryRepository<T> {
  Future<DataEntryLazyPage<T>> fetchPage({
    required SearchResult search,
    required int page,
    required int pageSize,
    PlutoColumn? sortColumn,
    List<PlutoRow> filterRows = const <PlutoRow>[],
  });
}

abstract class InMemoryDataEntryRepository<T> extends DataEntryRepository<T> {
  InMemoryDataEntryRepository(List<T> records) : records = records;

  final List<T> records;

  String getRecordCode(T record);

  Map<String, String> getSearchFields(T record);

  @override
  Future<List<T>> search(SearchResult search) async {
    final text = search.text.trim();
    if (text.isEmpty) {
      return List<T>.from(records);
    }

    return records.where((record) => _matches(record, search)).toList();
  }

  @override
  Future<T> save(T record) async {
    final code = getRecordCode(record);
    final index = records.indexWhere((item) => getRecordCode(item) == code);

    if (index >= 0) {
      records[index] = record;
    } else {
      records.add(record);
    }

    return record;
  }

  bool _matches(T record, SearchResult search) {
    final fields = getSearchFields(
      record,
    ).map((key, value) => MapEntry(key.toLowerCase(), value));

    if (search.hasPatterns) {
      return _matchesPatterns(fields, search.patterns);
    }

    final text = search.text.toLowerCase();
    return fields.values.any((value) => value.toLowerCase().contains(text));
  }

  bool _matchesPatterns(
    Map<String, String> fields,
    List<SearchPattern> patterns,
  ) {
    bool? result;

    for (final pattern in patterns) {
      final fieldValue = fields[pattern.field.toLowerCase()] ?? '';
      final patternMatched = _wildcardMatch(fieldValue, pattern.value);

      if (result == null) {
        result = patternMatched;
        continue;
      }

      switch (pattern.operatorBefore ?? SearchOperator.and) {
        case SearchOperator.and:
          result = result && patternMatched;
        case SearchOperator.or:
          result = result || patternMatched;
      }
    }

    return result ?? false;
  }

  bool _wildcardMatch(String value, String pattern) {
    final escapedPattern = RegExp.escape(
      pattern,
    ).replaceAll('%', '.*').replaceAll(r'\*', '.*');
    final expression = RegExp('^$escapedPattern\$', caseSensitive: false);

    return expression.hasMatch(value);
  }
}

typedef DataEntryRecordFactory<T> = T Function();
typedef DataEntryRecordCodeGetter<T> = String Function(T record);
typedef DataEntryPlutoCellsBuilder<T> =
    Map<String, PlutoCell> Function(T record);
typedef DataEntryFormBuilder<T> =
    Widget Function(BuildContext context, DataEntryFormContext<T> formContext);

class DataEntryProgramConfig<T> {
  const DataEntryProgramConfig({
    required this.title,
    required this.createNewRecord,
    required this.getRecordCode,
    required this.columns,
    required this.buildCells,
    required this.buildForm,
    this.browserMode = DataEntryBrowserMode.local,
    this.openMode = DataEntryOpenMode.popup,
    this.popupWidth = 760,
    this.popupHeight = 620,
    this.searchHintText = 'Search',
    this.newButtonText = 'New',
    this.editButtonText = 'Edit',
    this.showEditActionColumn = true,
    this.lazyPageSize = 25,
    this.gridConfiguration = const PlutoGridConfiguration(
      style: PlutoGridStyleConfig(
        rowHeight: 36,
        columnHeight: 40,
        activatedColor: Color(0xFFEAF3FF),
        gridBorderColor: Color(0xFFE5E5E5),
      ),
    ),
  });

  final String title;
  final DataEntryRecordFactory<T> createNewRecord;
  final DataEntryRecordCodeGetter<T> getRecordCode;
  final List<PlutoColumn> columns;
  final DataEntryPlutoCellsBuilder<T> buildCells;
  final DataEntryFormBuilder<T> buildForm;
  final DataEntryBrowserMode browserMode;
  final DataEntryOpenMode openMode;
  final double popupWidth;
  final double popupHeight;
  final String searchHintText;
  final String newButtonText;
  final String editButtonText;
  final bool showEditActionColumn;
  final int lazyPageSize;
  final PlutoGridConfiguration gridConfiguration;
}

class DataEntryFormContext<T> {
  const DataEntryFormContext({
    required this.record,
    required this.isEdit,
    required this.save,
    required this.saveAndNew,
    required this.cancel,
  });

  final T record;
  final bool isEdit;
  final Future<void> Function(T record) save;
  final Future<void> Function(T record) saveAndNew;
  final VoidCallback cancel;
}
