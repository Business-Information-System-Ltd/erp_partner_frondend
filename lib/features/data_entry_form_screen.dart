import 'package:flutter/material.dart';

import 'data_entry_core.dart';

class DataEntryFormScreen<T> extends StatefulWidget {
  const DataEntryFormScreen({
    super.key,
    required this.title,
    required this.record,
    required this.isEdit,
    required this.buildForm,
    required this.onSave,
  });

  final String title;
  final T record;
  final bool isEdit;
  final DataEntryFormBuilder<T> buildForm;
  final Future<T?> Function(T record, DataEntrySaveAction action) onSave;

  @override
  State<DataEntryFormScreen<T>> createState() => _DataEntryFormScreenState<T>();
}

class _DataEntryFormScreenState<T> extends State<DataEntryFormScreen<T>> {
  late T _record;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _record = widget.record;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 8, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.isEdit
                          ? 'Edit ${widget.title}'
                          : 'New ${widget.title}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Close',
                    onPressed: _cancel,
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: widget.buildForm(
                  context,
                  DataEntryFormContext<T>(
                    record: _record,
                    isEdit: widget.isEdit,
                    save: _save,
                    saveAndNew: _saveAndNew,
                    cancel: _cancel,
                  ),
                ),
              ),
            ),
          ],
        ),
        if (_saving)
          const Positioned.fill(
            child: ColoredBox(
              color: Color(0x33000000),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
      ],
    );
  }

  Future<void> _save(T record) async {
    await _runSave(record, DataEntrySaveAction.save);
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _saveAndNew(T record) async {
    final newRecord = await _runSave(record, DataEntrySaveAction.saveAndNew);
    if (mounted && newRecord != null) {
      setState(() => _record = newRecord);
    }
  }

  Future<T?> _runSave(T record, DataEntrySaveAction action) async {
    setState(() => _saving = true);

    try {
      return await widget.onSave(record, action);
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  void _cancel() {
    Navigator.of(context).pop();
  }
}
