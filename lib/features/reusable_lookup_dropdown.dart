import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pluto_grid/pluto_grid.dart';

class LookupSelection<T> {
  const LookupSelection({
    required this.key,
    required this.displayText,
    required this.item,
  });

  final String key;
  final String displayText;
  final T item;
}

class LookupPopupAppearance {
  const LookupPopupAppearance({
    this.width = 560,
    this.height = 320,
    this.verticalGap = 4,
    this.viewportPadding = const EdgeInsets.all(8),
    this.elevation = 12,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.backgroundColor,
  });

  final double width;
  final double height;
  final double verticalGap;
  final EdgeInsetsGeometry viewportPadding;
  final double elevation;
  final BorderRadius borderRadius;
  final Color? backgroundColor;
}

typedef LookupSearch<T> = Future<List<T>> Function(String text);
typedef LookupKeyGetter<T> = String Function(T item);
typedef LookupDisplayGetter<T> = String Function(T item);
typedef LookupCellsBuilder<T> = Map<String, PlutoCell> Function(T item);

class ReusableLookupDropdown<T> extends StatefulWidget {
  const ReusableLookupDropdown({
    super.key,
    required this.search,
    required this.columns,
    required this.buildCells,
    required this.getKey,
    required this.getDisplayText,
    required this.onSelected,
    this.initialText = '',
    this.initialSelection,
    this.labelText,
    this.hintText = 'Type search text, press ?',
    this.popupAppearance = const LookupPopupAppearance(),
    this.minimumSearchLength = 0,
    this.searchOnTextChange = false,
    this.questionKeyOpensPopup = true,
    this.showSearchIconButton = true,
    this.selectedLabel = 'Selected',
    this.decoration,
    this.gridConfiguration = const PlutoGridConfiguration(
      style: PlutoGridStyleConfig(
        rowHeight: 36,
        columnHeight: 40,
        activatedColor: Color(0xFFEAF3FF),
        gridBorderColor: Color(0xFFE5E5E5),
      ),
    ),
  });

  final LookupSearch<T> search;
  final List<PlutoColumn> columns;
  final LookupCellsBuilder<T> buildCells;
  final LookupKeyGetter<T> getKey;
  final LookupDisplayGetter<T> getDisplayText;
  final ValueChanged<LookupSelection<T>> onSelected;
  final String initialText;
  final LookupSelection<T>? initialSelection;
  final String? labelText;
  final String hintText;
  final LookupPopupAppearance popupAppearance;
  final int minimumSearchLength;
  final bool searchOnTextChange;
  final bool questionKeyOpensPopup;
  final bool showSearchIconButton;
  final String selectedLabel;
  final InputDecoration? decoration;
  final PlutoGridConfiguration gridConfiguration;

  @override
  State<ReusableLookupDropdown<T>> createState() =>
      _ReusableLookupDropdownState<T>();
}

class _ReusableLookupDropdownState<T> extends State<ReusableLookupDropdown<T>> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  OverlayEntry? _overlayEntry;
  LookupSelection<T>? _selection;
  List<T> _items = <T>[];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialText;
    _selection = widget.initialSelection;
  }

  @override
  void didUpdateWidget(covariant ReusableLookupDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialSelection != widget.initialSelection) {
      _selection = widget.initialSelection;
    }
  }

  @override
  void dispose() {
    _removePopup();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selection = _selection;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        KeyboardListener(
          focusNode: _focusNode,
          onKeyEvent: _handleKeyEvent,
          child: TextField(
            controller: _controller,
            onChanged: _handleTextChanged,
            onSubmitted: (_) => _searchAndOpen(),
            decoration:
                (widget.decoration ??
                        InputDecoration(
                          labelText: widget.labelText,
                          hintText: widget.hintText,
                        ))
                    .copyWith(
                      suffixIcon: widget.showSearchIconButton
                          ? IconButton(
                              tooltip: 'Search',
                              icon: const Icon(Icons.search),
                              onPressed: _searchAndOpen,
                            )
                          : null,
                    ),
          ),
        ),
        if (selection != null) ...[
          const SizedBox(height: 6),
          Text(
            '${widget.selectedLabel}: ${selection.displayText}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ],
    );
  }

  void _handleTextChanged(String value) {
    if (widget.questionKeyOpensPopup && value.contains('?')) {
      final cleanValue = value.replaceAll('?', '');
      _controller.value = TextEditingValue(
        text: cleanValue,
        selection: TextSelection.collapsed(offset: cleanValue.length),
      );
      _searchAndOpen();
      return;
    }

    if (widget.searchOnTextChange) {
      _searchAndOpen();
    }
  }

  void _handleKeyEvent(KeyEvent event) {
    if (!widget.questionKeyOpensPopup || event is! KeyDownEvent) {
      return;
    }

    if (event.logicalKey == LogicalKeyboardKey.question ||
        event.character == '?') {
      _searchAndOpen();
    }
  }

  Future<void> _searchAndOpen() async {
    final text = _controller.text.trim();
    if (text.length < widget.minimumSearchLength) {
      return;
    }

    setState(() => _loading = true);
    _openPopup();

    try {
      final items = await widget.search(text);
      if (!mounted) {
        return;
      }

      setState(() => _items = items);
      _refreshPopup();
    } finally {
      if (mounted) {
        setState(() => _loading = false);
        _refreshPopup();
      }
    }
  }

  void _openPopup() {
    if (_overlayEntry != null) {
      _refreshPopup();
      return;
    }

    _overlayEntry = OverlayEntry(builder: _buildPopupOverlay);
    Overlay.of(context).insert(_overlayEntry!);
  }

  Widget _buildPopupOverlay(BuildContext overlayContext) {
    final geometry = _calculatePopupGeometry();
    final appearance = widget.popupAppearance;

    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: _removePopup,
            child: const SizedBox.expand(),
          ),
        ),
        Positioned(
          left: geometry.left,
          top: geometry.top,
          width: geometry.width,
          height: geometry.height,
          child: Material(
            elevation: appearance.elevation,
            color: appearance.backgroundColor ?? Theme.of(context).cardColor,
            borderRadius: appearance.borderRadius,
            clipBehavior: Clip.antiAlias,
            child: _LookupPopupContent<T>(
              loading: _loading,
              columns: _buildGridColumns(),
              rows: _buildGridRows(),
              configuration: widget.gridConfiguration,
              onRowSelected: _selectByRow,
            ),
          ),
        ),
      ],
    );
  }

  List<PlutoColumn> _buildGridColumns() {
    return [
      ...widget.columns,
      PlutoColumn(
        title: '',
        field: '_lookupIndex',
        type: PlutoColumnType.number(),
        hide: true,
      ),
    ];
  }

  List<PlutoRow> _buildGridRows() {
    return [
      for (var index = 0; index < _items.length; index++)
        PlutoRow(
          cells: {
            ...widget.buildCells(_items[index]),
            '_lookupIndex': PlutoCell(value: index),
          },
        ),
    ];
  }

  void _selectByRow(PlutoRow row) {
    final index = row.cells['_lookupIndex']?.value as int?;
    if (index == null || index < 0 || index >= _items.length) {
      return;
    }

    final item = _items[index];
    final selection = LookupSelection<T>(
      key: widget.getKey(item),
      displayText: widget.getDisplayText(item),
      item: item,
    );

    setState(() => _selection = selection);
    widget.onSelected(selection);
    _removePopup();
  }

  void _refreshPopup() {
    _overlayEntry?.markNeedsBuild();
  }

  void _removePopup() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  _PopupGeometry _calculatePopupGeometry() {
    final appearance = widget.popupAppearance;
    final renderBox = context.findRenderObject() as RenderBox;
    final overlay = Overlay.of(context);
    final overlayBox = overlay.context.findRenderObject() as RenderBox;
    final targetOffset = renderBox.localToGlobal(
      Offset.zero,
      ancestor: overlayBox,
    );
    final targetSize = renderBox.size;
    final overlaySize = overlayBox.size;
    final viewportPadding = appearance.viewportPadding.resolve(
      Directionality.of(context),
    );
    final availableWidth =
        overlaySize.width - viewportPadding.left - viewportPadding.right;
    final maxWidth = availableWidth > 0 ? availableWidth : overlaySize.width;
    final popupWidth = appearance.width.clamp(0, maxWidth).toDouble();
    final left = _clampDouble(
      targetOffset.dx,
      viewportPadding.left,
      overlaySize.width - viewportPadding.right - popupWidth,
    );
    final belowTop =
        targetOffset.dy + targetSize.height + appearance.verticalGap;
    final spaceBelow = overlaySize.height - viewportPadding.bottom - belowTop;
    final spaceAbove =
        targetOffset.dy - viewportPadding.top - appearance.verticalGap;
    final openAbove = spaceBelow < appearance.height && spaceAbove > spaceBelow;
    final maxPopupHeight = openAbove ? spaceAbove : spaceBelow;
    final fallbackHeight =
        overlaySize.height - viewportPadding.top - viewportPadding.bottom;
    final availableHeight = maxPopupHeight > 0
        ? maxPopupHeight
        : fallbackHeight;
    final popupHeight = appearance.height
        .clamp(0, availableHeight > 0 ? availableHeight : appearance.height)
        .toDouble();
    final calculatedTop = openAbove
        ? targetOffset.dy - appearance.verticalGap - popupHeight
        : belowTop;
    final top = _clampDouble(
      calculatedTop,
      viewportPadding.top,
      overlaySize.height - viewportPadding.bottom - popupHeight,
    );

    return _PopupGeometry(
      left: left,
      top: top,
      width: popupWidth,
      height: popupHeight,
    );
  }

  double _clampDouble(double value, double lowerLimit, double upperLimit) {
    if (upperLimit < lowerLimit) {
      return lowerLimit;
    }

    return value.clamp(lowerLimit, upperLimit).toDouble();
  }
}

class _LookupPopupContent<T> extends StatelessWidget {
  const _LookupPopupContent({
    required this.loading,
    required this.columns,
    required this.rows,
    required this.configuration,
    required this.onRowSelected,
  });

  final bool loading;
  final List<PlutoColumn> columns;
  final List<PlutoRow> rows;
  final PlutoGridConfiguration configuration;
  final ValueChanged<PlutoRow> onRowSelected;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PlutoGrid(
          columns: columns,
          rows: rows,
          mode: PlutoGridMode.selectWithOneTap,
          configuration: configuration,
          onSelected: (event) {
            final row = event.row;
            if (row != null) {
              onRowSelected(row);
            }
          },
          onRowDoubleTap: (event) => onRowSelected(event.row),
        ),
        if (rows.isEmpty && !loading)
          const Center(child: Text('No records found')),
        if (loading)
          const Positioned.fill(
            child: ColoredBox(
              color: Color(0x22000000),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
      ],
    );
  }
}

class _PopupGeometry {
  const _PopupGeometry({
    required this.left,
    required this.top,
    required this.width,
    required this.height,
  });

  final double left;
  final double top;
  final double width;
  final double height;
}
