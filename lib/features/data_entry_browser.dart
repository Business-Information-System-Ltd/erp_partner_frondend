import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

import 'data_entry_core.dart';
import 'data_entry_form_screen.dart';
import 'reusable_search_box.dart';

class DataEntryBrowser<T> extends StatefulWidget {
  const DataEntryBrowser({
    super.key,
    required this.config,
    required this.repository,
  });

  final DataEntryProgramConfig<T> config;
  final DataEntryRepository<T> repository;

  @override
  State<DataEntryBrowser<T>> createState() => _DataEntryBrowserState<T>();
}

class _DataEntryBrowserState<T> extends State<DataEntryBrowser<T>> {
  final SearchResult _emptySearch = const SearchResult(text: '', patterns: []);

  bool _loading = false;
  List<T> _records = <T>[];
  SearchResult? _lastSearch;
  int _lazyRefreshVersion = 0;

  bool get _isLazyMode =>
      widget.config.browserMode == DataEntryBrowserMode.lazyPagination;

  @override
  void initState() {
    super.initState();
    _lastSearch = _emptySearch;

    if (!_isLazyMode) {
      _loadLocalRecords(_emptySearch);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _BrowserToolbar(
          searchHintText: widget.config.searchHintText,
          newButtonText: widget.config.newButtonText,
          onSearch: _handleSearch,
          onNew: () => _openEntry(record: widget.config.createNewRecord()),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: Stack(
            children: [
              PlutoGrid(
                columns: _buildColumns(),
                rows: _isLazyMode ? const <PlutoRow>[] : _buildRows(_records),
                mode: PlutoGridMode.normal,
                configuration: widget.config.gridConfiguration,
                createFooter: _isLazyMode
                    ? (stateManager) {
                        return PlutoLazyPagination(
                          key: ValueKey(_lazyRefreshVersion),
                          initialPage: 1,
                          initialFetch: true,
                          fetchWithSorting: true,
                          fetchWithFiltering: true,
                          pageSizeToMove: 1,
                          fetch: _fetchLazyPage,
                          stateManager: stateManager,
                        );
                      }
                    : null,
              ),
              if (_loading)
                const Positioned.fill(
                  child: ColoredBox(
                    color: Color(0x33000000),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  List<PlutoColumn> _buildColumns() {
    final columns = <PlutoColumn>[
      ...widget.config.columns,
      PlutoColumn(
        title: '',
        field: '_recordIndex',
        type: PlutoColumnType.number(),
        hide: true,
      ),
    ];

    if (widget.config.showEditActionColumn) {
      columns.add(
        PlutoColumn(
          title: 'Action',
          field: '_action',
          width: 90,
          type: PlutoColumnType.text(),
          enableEditingMode: false,
          renderer: (rendererContext) {
            final index =
                rendererContext.row.cells['_recordIndex']?.value as int?;
            if (index == null || index < 0 || index >= _records.length) {
              return const SizedBox.shrink();
            }

            return TextButton(
              onPressed: () =>
                  _openEntry(record: _records[index], isEdit: true),
              child: Text(widget.config.editButtonText),
            );
          },
        ),
      );
    }

    return columns;
  }

  List<PlutoRow> _buildRows(List<T> records) {
    return [
      for (var index = 0; index < records.length; index++)
        PlutoRow(
          cells: {
            ...widget.config.buildCells(records[index]),
            '_recordIndex': PlutoCell(value: index),
            '_action': PlutoCell(value: ''),
          },
        ),
    ];
  }

  Future<void> _handleSearch(SearchResult search) async {
    _lastSearch = search;

    if (_isLazyMode) {
      setState(() => _lazyRefreshVersion++);
      return;
    }

    await _loadLocalRecords(search);
  }

  Future<void> _loadLocalRecords(SearchResult search) async {
    setState(() {
      _loading = true;
      _lastSearch = search;
    });

    try {
      final records = await widget.repository.search(search);
      if (!mounted) {
        return;
      }

      setState(() => _records = records);
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<PlutoLazyPaginationResponse> _fetchLazyPage(
    PlutoLazyPaginationRequest request,
  ) async {
    final repository = widget.repository;
    if (repository is! DataEntryLazyRepository<T>) {
      throw StateError(
        'DataEntryBrowserMode.lazyPagination requires DataEntryLazyRepository.',
      );
    }

    final page = await repository.fetchPage(
      search: _lastSearch ?? _emptySearch,
      page: request.page,
      pageSize: widget.config.lazyPageSize,
      sortColumn: request.sortColumn,
      filterRows: request.filterRows,
    );

    _records = page.records;

    return PlutoLazyPaginationResponse(
      totalPage: page.totalPages,
      rows: _buildRows(page.records),
    );
  }

  Future<void> _openEntry({required T record, bool isEdit = false}) async {
    final form = DataEntryFormScreen<T>(
      title: widget.config.title,
      record: record,
      isEdit: isEdit,
      buildForm: widget.config.buildForm,
      onSave: (record, action) async {
        await widget.repository.save(record);
        await _refreshAfterSave();

        if (action == DataEntrySaveAction.saveAndNew) {
          return widget.config.createNewRecord();
        }

        return null;
      },
    );

    if (widget.config.openMode == DataEntryOpenMode.page) {
      await Navigator.of(context).push<void>(
        MaterialPageRoute(
          builder: (_) => Scaffold(body: SafeArea(child: form)),
        ),
      );
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (context) {
        return Dialog(
          child: SizedBox(
            width: widget.config.popupWidth,
            height: widget.config.popupHeight,
            child: form,
          ),
        );
      },
    );
  }

  Future<void> _refreshAfterSave() async {
    if (_isLazyMode) {
      setState(() => _lazyRefreshVersion++);
      return;
    }

    await _loadLocalRecords(_lastSearch ?? _emptySearch);
  }
}

class _BrowserToolbar extends StatelessWidget {
  const _BrowserToolbar({
    required this.searchHintText,
    required this.newButtonText,
    required this.onSearch,
    required this.onNew,
  });

  final String searchHintText;
  final String newButtonText;
  final ValueChanged<SearchResult> onSearch;
  final VoidCallback onNew;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ReusableSearchBox(
            hintText: searchHintText,
            triggerMode: SearchTriggerMode.searchButtonPress,
            onSearch: onSearch,
          ),
        ),
        const SizedBox(width: 8),
        FilledButton.icon(
          onPressed: onNew,
          icon: const Icon(Icons.add),
          label: Text(newButtonText),
        ),
      ],
    );
  }
}

// A simple model for demo
class DemoItem {
  DemoItem({required this.code, required this.name, this.description});
  final String code;
  final String name;
  final String? description;

  @override
  String toString() => name;
}

// In-memory repository
class DemoItemRepository extends InMemoryDataEntryRepository<DemoItem> {
  DemoItemRepository() : super(_initialRecords);

  static final _initialRecords = [
    DemoItem(code: 'ITM001', name: 'Laptop', description: 'High performance'),
    DemoItem(code: 'ITM002', name: 'Mouse', description: 'Wireless'),
    DemoItem(code: 'ITM003', name: 'Keyboard', description: 'Mechanical'),
  ];

  @override
  String getRecordCode(DemoItem record) => record.code;

  @override
  Map<String, String> getSearchFields(DemoItem record) {
    return {
      'code': record.code,
      'name': record.name,
      'description': record.description ?? '',
    };
  }
}

class DataEntryBrowserDemoScreen extends StatelessWidget {
  DataEntryBrowserDemoScreen({super.key}) : _repository = DemoItemRepository();

  final DemoItemRepository _repository;

  @override
  Widget build(BuildContext context) {
    final config = DataEntryProgramConfig<DemoItem>(
      title: 'Demo Item',
      createNewRecord: () => DemoItem(code: '', name: ''),
      getRecordCode: (item) => item.code,
      columns: [
        PlutoColumn(title: 'Code', field: 'code', type: PlutoColumnType.text()),
        PlutoColumn(title: 'Name', field: 'name', type: PlutoColumnType.text()),
        PlutoColumn(
          title: 'Description',
          field: 'description',
          type: PlutoColumnType.text(),
        ),
      ],
      buildCells: (item) => {
        'code': PlutoCell(value: item.code),
        'name': PlutoCell(value: item.name),
        'description': PlutoCell(value: item.description ?? ''),
      },
      buildForm: (context, formContext) {
        return Column(
          children: [
            TextFormField(
              initialValue: formContext.record.code,
              decoration: const InputDecoration(labelText: 'Code'),
              onChanged: (value) {
                // final updated = formContext.record.copyWith(code: value);
                // Note: copyWith not defined – for demo we mutate.
                // In real code use proper copyWith.
              },
            ),
            TextFormField(
              initialValue: formContext.record.name,
              decoration: const InputDecoration(labelText: 'Name'),
              onChanged: (value) {
                // Update record
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: formContext.cancel,
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => formContext.save(formContext.record),
                  child: const Text('Save'),
                ),
                OutlinedButton(
                  onPressed: () => formContext.saveAndNew(formContext.record),
                  child: const Text('Save & New'),
                ),
              ],
            ),
          ],
        );
      },
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Data Entry Browser Demo')),
      body: DataEntryBrowser<DemoItem>(config: config, repository: _repository),
    );
  }
}
