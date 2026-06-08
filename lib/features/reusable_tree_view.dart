import 'package:flutter/material.dart';

class TreeViewNode {
  const TreeViewNode({
    required this.code,
    required this.title,
    this.children = const <TreeViewNode>[],
    this.selectable = true,
    this.subtitle,
    this.data,
  });

  final String code;
  final String title;
  final String? subtitle;
  final List<TreeViewNode> children;

  /// Use false for parent/group rows or disabled choices.
  final bool selectable;

  /// Optional custom object from your application.
  final Object? data;

  bool get hasChildren => children.isNotEmpty;
}

class TreeViewSelection {
  const TreeViewSelection({required this.code, required this.node});

  final String code;
  final TreeViewNode node;
}

class TreeViewPopupAppearance {
  const TreeViewPopupAppearance({
    this.width = 420,
    this.height = 520,
    this.backgroundColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.padding = const EdgeInsets.all(12),
    this.titlePadding = const EdgeInsets.fromLTRB(16, 14, 8, 8),
    this.treePadding = const EdgeInsets.only(bottom: 8),
    this.elevation = 12,
    this.verticalGap = 4,
    this.viewportPadding = const EdgeInsets.all(8),
  });

  final double width;
  final double height;
  final Color? backgroundColor;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry titlePadding;
  final EdgeInsetsGeometry treePadding;
  final double elevation;
  final double verticalGap;
  final EdgeInsetsGeometry viewportPadding;
}

class ReusableTreeViewPicker extends StatefulWidget {
  const ReusableTreeViewPicker({
    super.key,
    required this.nodes,
    required this.onSelected,
    this.selectedCode,
    this.selectable = true,
    this.expandAll = false,
    this.title = 'Select',
    this.placeholder = 'Select',
    this.buttonText,
    this.pathSeparator = ' >> ',
    this.popupAppearance = const TreeViewPopupAppearance(),
    this.closeOnSelect = true,
    this.barrierDismissible = true,
    this.selectedColor,
    this.selectedTextStyle,
    this.textStyle,
    this.dense = false,
    this.buttonStyle,
  });

  final List<TreeViewNode> nodes;
  final ValueChanged<TreeViewSelection> onSelected;
  final String? selectedCode;
  final bool selectable;
  final bool expandAll;
  final String title;
  final String placeholder;
  final String? buttonText;
  final String pathSeparator;
  final TreeViewPopupAppearance popupAppearance;
  final bool closeOnSelect;
  final bool barrierDismissible;
  final Color? selectedColor;
  final TextStyle? selectedTextStyle;
  final TextStyle? textStyle;
  final bool dense;
  final ButtonStyle? buttonStyle;

  @override
  State<ReusableTreeViewPicker> createState() => _ReusableTreeViewPickerState();
}

class _ReusableTreeViewPickerState extends State<ReusableTreeViewPicker> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  String? _selectedCode;

  @override
  void initState() {
    super.initState();
    _selectedCode = widget.selectedCode;
  }

  @override
  void didUpdateWidget(covariant ReusableTreeViewPicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.selectedCode != widget.selectedCode) {
      _selectedCode = widget.selectedCode;
    }
  }

  @override
  void dispose() {
    _removeTreePopup();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedPath = _findNodePathByCode(widget.nodes, _selectedCode);
    final label =
        _formatNodePath(selectedPath) ??
        widget.buttonText ??
        widget.placeholder;

    return CompositedTransformTarget(
      link: _layerLink,
      child: OutlinedButton.icon(
        style: widget.buttonStyle,
        onPressed: _toggleTreePopup,
        icon: const Icon(Icons.account_tree_outlined),
        label: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
    );
  }

  void _toggleTreePopup() {
    if (_overlayEntry == null) {
      _openTreePopup();
    } else {
      _removeTreePopup();
    }
  }

  void _openTreePopup() {
    final appearance = widget.popupAppearance;
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
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

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            if (widget.barrierDismissible)
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: _removeTreePopup,
                  child: const SizedBox.expand(),
                ),
              ),
            Positioned(
              left: left,
              top: top,
              width: popupWidth,
              height: popupHeight,
              child: Material(
                elevation: appearance.elevation,
                color:
                    appearance.backgroundColor ??
                    Theme.of(context).dialogBackgroundColor,
                borderRadius: appearance.borderRadius,
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: appearance.padding,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: appearance.titlePadding,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            IconButton(
                              tooltip: 'Close',
                              onPressed: _removeTreePopup,
                              icon: const Icon(Icons.close),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: ReusableTreeView(
                          nodes: widget.nodes,
                          selectedCode: _selectedCode,
                          selectable: widget.selectable,
                          expandAll: widget.expandAll,
                          padding: appearance.treePadding,
                          selectedColor: widget.selectedColor,
                          selectedTextStyle: widget.selectedTextStyle,
                          textStyle: widget.textStyle,
                          dense: widget.dense,
                          onSelected: (selection) {
                            setState(() => _selectedCode = selection.code);
                            widget.onSelected(selection);

                            if (widget.closeOnSelect) {
                              _removeTreePopup();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    overlay.insert(_overlayEntry!);
  }

  void _removeTreePopup() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  double _clampDouble(double value, double lowerLimit, double upperLimit) {
    if (upperLimit < lowerLimit) {
      return lowerLimit;
    }

    return value.clamp(lowerLimit, upperLimit).toDouble();
  }

  String? _formatNodePath(List<TreeViewNode>? path) {
    if (path == null || path.isEmpty) {
      return null;
    }

    return path.map((node) => node.title).join(widget.pathSeparator);
  }

  List<TreeViewNode>? _findNodePathByCode(
    List<TreeViewNode> nodes,
    String? code,
  ) {
    if (code == null || code.isEmpty) {
      return null;
    }

    for (final node in nodes) {
      if (node.code == code) {
        return [node];
      }

      final childPath = _findNodePathByCode(node.children, code);
      if (childPath != null) {
        return [node, ...childPath];
      }
    }

    return null;
  }
}

class ReusableTreeView extends StatefulWidget {
  const ReusableTreeView({
    super.key,
    required this.nodes,
    required this.onSelected,
    this.selectedCode,
    this.selectable = true,
    this.expandAll = false,
    this.padding = EdgeInsets.zero,
    this.selectedColor,
    this.selectedTextStyle,
    this.textStyle,
    this.dense = false,
  });

  /// Pass tree data each time this widget is created/called.
  final List<TreeViewNode> nodes;

  /// Returns selected code and selected node.
  final ValueChanged<TreeViewSelection> onSelected;

  /// Use this for edit screens. Matching code will be preselected.
  final String? selectedCode;

  /// Global switch. If false, no row can be selected.
  final bool selectable;

  final bool expandAll;
  final EdgeInsetsGeometry padding;
  final Color? selectedColor;
  final TextStyle? selectedTextStyle;
  final TextStyle? textStyle;
  final bool dense;

  @override
  State<ReusableTreeView> createState() => _ReusableTreeViewState();
}

class _ReusableTreeViewState extends State<ReusableTreeView> {
  final Set<String> _expandedCodes = <String>{};
  String? _selectedCode;

  @override
  void initState() {
    super.initState();
    _selectedCode = widget.selectedCode;
    _syncExpandedNodes();
  }

  @override
  void didUpdateWidget(covariant ReusableTreeView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.selectedCode != widget.selectedCode ||
        oldWidget.nodes != widget.nodes ||
        oldWidget.expandAll != widget.expandAll) {
      _selectedCode = widget.selectedCode;
      _syncExpandedNodes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: widget.padding,
      shrinkWrap: true,
      children: [
        for (final node in widget.nodes)
          _TreeNodeTile(
            node: node,
            level: 0,
            expandedCodes: _expandedCodes,
            selectedCode: _selectedCode,
            globallySelectable: widget.selectable,
            dense: widget.dense,
            selectedColor: widget.selectedColor,
            selectedTextStyle: widget.selectedTextStyle,
            textStyle: widget.textStyle,
            onToggleExpanded: _toggleExpanded,
            onSelect: _selectNode,
          ),
      ],
    );
  }

  void _syncExpandedNodes() {
    _expandedCodes.clear();

    if (widget.expandAll) {
      _expandedCodes.addAll(_collectParentCodes(widget.nodes));
    }

    final selectedCode = widget.selectedCode;
    if (selectedCode != null && selectedCode.isNotEmpty) {
      _expandedCodes.addAll(_findAncestorCodes(widget.nodes, selectedCode));
    }
  }

  void _toggleExpanded(TreeViewNode node) {
    setState(() {
      if (_expandedCodes.contains(node.code)) {
        _expandedCodes.remove(node.code);
      } else {
        _expandedCodes.add(node.code);
      }
    });
  }

  void _selectNode(TreeViewNode node) {
    if (!widget.selectable || !node.selectable) {
      return;
    }

    setState(() => _selectedCode = node.code);
    widget.onSelected(TreeViewSelection(code: node.code, node: node));
  }

  Set<String> _collectParentCodes(List<TreeViewNode> nodes) {
    final codes = <String>{};

    for (final node in nodes) {
      if (node.hasChildren) {
        codes.add(node.code);
        codes.addAll(_collectParentCodes(node.children));
      }
    }

    return codes;
  }

  Set<String> _findAncestorCodes(List<TreeViewNode> nodes, String code) {
    final path = <String>[];

    bool visit(TreeViewNode node) {
      if (node.code == code) {
        return true;
      }

      for (final child in node.children) {
        if (visit(child)) {
          path.add(node.code);
          return true;
        }
      }

      return false;
    }

    for (final node in nodes) {
      if (visit(node)) {
        break;
      }
    }

    return path.toSet();
  }
}

class _TreeNodeTile extends StatelessWidget {
  const _TreeNodeTile({
    required this.node,
    required this.level,
    required this.expandedCodes,
    required this.selectedCode,
    required this.globallySelectable,
    required this.dense,
    required this.onToggleExpanded,
    required this.onSelect,
    this.selectedColor,
    this.selectedTextStyle,
    this.textStyle,
  });

  final TreeViewNode node;
  final int level;
  final Set<String> expandedCodes;
  final String? selectedCode;
  final bool globallySelectable;
  final bool dense;
  final Color? selectedColor;
  final TextStyle? selectedTextStyle;
  final TextStyle? textStyle;
  final ValueChanged<TreeViewNode> onToggleExpanded;
  final ValueChanged<TreeViewNode> onSelect;

  @override
  Widget build(BuildContext context) {
    final isExpanded = expandedCodes.contains(node.code);
    final isSelected = selectedCode == node.code;
    final canSelect = globallySelectable && node.selectable;
    final theme = Theme.of(context);
    final selectedBackground =
        selectedColor ?? theme.colorScheme.primary.withOpacity(0.10);
    final leftPadding = 12.0 + (level * 20.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Material(
          color: isSelected ? selectedBackground : Colors.transparent,
          child: InkWell(
            onTap: canSelect ? () => onSelect(node) : null,
            child: minHeightBox(
              minHeight: dense ? 36 : 44,
              child: Padding(
                padding: EdgeInsets.only(
                  left: leftPadding,
                  right: 8,
                  top: dense ? 4 : 6,
                  bottom: dense ? 4 : 6,
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: node.hasChildren
                          ? IconButton(
                              padding: EdgeInsets.zero,
                              tooltip: isExpanded ? 'Collapse' : 'Expand',
                              icon: Icon(
                                isExpanded
                                    ? Icons.keyboard_arrow_down
                                    : Icons.chevron_right,
                              ),
                              onPressed: () => onToggleExpanded(node),
                            )
                          : const SizedBox.shrink(),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      node.hasChildren ? Icons.folder_outlined : Icons.article,
                      size: 18,
                      color: canSelect
                          ? theme.colorScheme.onSurface
                          : theme.disabledColor,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            node.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: isSelected
                                ? selectedTextStyle ??
                                      theme.textTheme.bodyMedium?.copyWith(
                                        color: theme.colorScheme.primary,
                                        fontWeight: FontWeight.w600,
                                      )
                                : textStyle ??
                                      theme.textTheme.bodyMedium?.copyWith(
                                        color: canSelect
                                            ? theme.colorScheme.onSurface
                                            : theme.disabledColor,
                                      ),
                          ),
                          if (node.subtitle != null)
                            Text(
                              node.subtitle!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      Icon(
                        Icons.check,
                        size: 18,
                        color: theme.colorScheme.primary,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (node.hasChildren && isExpanded)
          for (final child in node.children)
            _TreeNodeTile(
              node: child,
              level: level + 1,
              expandedCodes: expandedCodes,
              selectedCode: selectedCode,
              globallySelectable: globallySelectable,
              dense: dense,
              selectedColor: selectedColor,
              selectedTextStyle: selectedTextStyle,
              textStyle: textStyle,
              onToggleExpanded: onToggleExpanded,
              onSelect: onSelect,
            ),
      ],
    );
  }

  Widget minHeightBox({required double minHeight, required Widget child}) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: minHeight),
      child: child,
    );
  }
}
