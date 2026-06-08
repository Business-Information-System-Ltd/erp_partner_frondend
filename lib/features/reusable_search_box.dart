import 'package:flutter/material.dart';

enum SearchDisplayMode { textBox, buttonOnly }

enum SearchTriggerMode { keyPress, searchButtonPress }

enum SearchOperator { and, or }

class SearchResult {
  const SearchResult({required this.text, required this.patterns});

  final String text;
  final List<SearchPattern> patterns;

  bool get hasPatterns => patterns.isNotEmpty;
}

class SearchPattern {
  const SearchPattern({
    required this.field,
    required this.value,
    this.operatorBefore,
  });

  final String field;
  final String value;
  final SearchOperator? operatorBefore;

  bool get hasWildcard => value.contains('*') || value.contains('%');
}

class ReusableSearchBox extends StatefulWidget {
  const ReusableSearchBox({
    super.key,
    required this.onSearch,
    this.displayMode = SearchDisplayMode.textBox,
    this.triggerMode = SearchTriggerMode.keyPress,
    this.initialValue = '',
    this.hintText = 'Search',
    this.buttonText = 'Search',
    this.dialogTitle = 'Search',
    this.textInputAction = TextInputAction.search,
    this.autofocus = false,
    this.clearAfterSearch = false,
    this.decoration,
  });

  final ValueChanged<SearchResult> onSearch;
  final SearchDisplayMode displayMode;
  final SearchTriggerMode triggerMode;
  final String initialValue;
  final String hintText;
  final String buttonText;
  final String dialogTitle;
  final TextInputAction textInputAction;
  final bool autofocus;
  final bool clearAfterSearch;
  final InputDecoration? decoration;

  @override
  State<ReusableSearchBox> createState() => _ReusableSearchBoxState();
}

class _ReusableSearchBoxState extends State<ReusableSearchBox> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.displayMode == SearchDisplayMode.buttonOnly) {
      return OutlinedButton.icon(
        onPressed: _openSearchDialog,
        icon: const Icon(Icons.search),
        label: Text(widget.buttonText),
      );
    }

    return _SearchInput(
      controller: _controller,
      hintText: widget.hintText,
      textInputAction: widget.textInputAction,
      autofocus: widget.autofocus,
      triggerMode: widget.triggerMode,
      decoration: widget.decoration,
      onChanged: widget.triggerMode == SearchTriggerMode.keyPress
          ? (_) => _submit()
          : null,
      onSubmitted: (_) => _submit(),
      onSearchPressed: _submit,
    );
  }

  Future<void> _openSearchDialog() async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        final dialogController = TextEditingController(text: _controller.text);

        return AlertDialog(
          title: Text(widget.dialogTitle),
          content: _SearchInput(
            controller: dialogController,
            hintText: widget.hintText,
            textInputAction: widget.textInputAction,
            autofocus: true,
            triggerMode: widget.triggerMode,
            decoration: widget.decoration,
            onChanged: widget.triggerMode == SearchTriggerMode.keyPress
                ? (_) {
                    _controller.text = dialogController.text;
                    _submit();
                  }
                : null,
            onSubmitted: (_) {
              _controller.text = dialogController.text;
              _submit();
              Navigator.of(context).pop();
            },
            onSearchPressed: () {
              _controller.text = dialogController.text;
              _submit();
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }

  void _submit() {
    final text = _controller.text;
    widget.onSearch(
      SearchResult(text: text, patterns: SearchPatternParser.parse(text)),
    );

    if (widget.clearAfterSearch) {
      _controller.clear();
    }
  }
}

class _SearchInput extends StatelessWidget {
  const _SearchInput({
    required this.controller,
    required this.hintText,
    required this.textInputAction,
    required this.autofocus,
    required this.triggerMode,
    required this.onSubmitted,
    required this.onSearchPressed,
    this.decoration,
    this.onChanged,
  });

  final TextEditingController controller;
  final String hintText;
  final TextInputAction textInputAction;
  final bool autofocus;
  final SearchTriggerMode triggerMode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onSearchPressed;
  final InputDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    final showSearchButton = triggerMode == SearchTriggerMode.searchButtonPress;

    return TextField(
      controller: controller,
      autofocus: autofocus,
      textInputAction: textInputAction,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      decoration: (decoration ?? InputDecoration(hintText: hintText)).copyWith(
        prefixIcon: const Icon(Icons.search),
        suffixIcon: showSearchButton
            ? IconButton(
                tooltip: 'Search',
                onPressed: onSearchPressed,
                icon: const Icon(Icons.arrow_forward),
              )
            : null,
      ),
    );
  }
}

class SearchPatternParser {
  static final RegExp _tokenExpression = RegExp(
    r'(#and#|#or#)|([A-Za-z][A-Za-z0-9_ ]*)\s*:\s*([^#\s]+)',
    caseSensitive: false,
  );

  static List<SearchPattern> parse(String text) {
    SearchOperator? pendingOperator;
    final patterns = <SearchPattern>[];

    for (final match in _tokenExpression.allMatches(text)) {
      final operatorToken = match.group(1);
      if (operatorToken != null) {
        pendingOperator = operatorToken.toLowerCase() == '#or#'
            ? SearchOperator.or
            : SearchOperator.and;
        continue;
      }

      final field = match.group(2)?.trim();
      final value = match.group(3)?.trim();
      if (field == null || value == null || field.isEmpty || value.isEmpty) {
        continue;
      }

      patterns.add(
        SearchPattern(
          field: field,
          value: value,
          operatorBefore: patterns.isEmpty ? null : pendingOperator,
        ),
      );
      pendingOperator = null;
    }

    return patterns;
  }
}
