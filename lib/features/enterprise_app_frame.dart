import 'package:flutter/material.dart';

enum EnterpriseMessageSeverity { info, success, warning, error }

class EnterpriseMessage {
  const EnterpriseMessage({
    required this.text,
    this.severity = EnterpriseMessageSeverity.info,
  });

  final String text;
  final EnterpriseMessageSeverity severity;
}

class EnterpriseMenuAction {
  const EnterpriseMenuAction({
    required this.label,
    required this.onSelected,
    this.icon,
  });

  final String label;
  final IconData? icon;
  final VoidCallback onSelected;
}

class EnterpriseMenuGroup {
  const EnterpriseMenuGroup({required this.label, required this.actions});

  final String label;
  final List<EnterpriseMenuAction> actions;
}

class EnterpriseNavigationItem {
  const EnterpriseNavigationItem({
    required this.label,
    required this.icon,
    required this.page,
  });

  final String label;
  final IconData icon;
  final Widget page;
}

class EnterpriseAppFrame extends StatefulWidget {
  const EnterpriseAppFrame({
    super.key,
    required this.title,
    required this.navigationItems,
    required this.selectedIndex, // controlled by router
    required this.onNavigationSelected, // router callback
    required this.child, // current route’s screen
    this.menuGroups = const [],
    this.initiallyCollapsed = false,
    this.expandedMenuWidth = 240,
    this.collapsedMenuWidth = 64,
    this.messageAreaHeight = 34,
    this.initialMessage = const EnterpriseMessage(text: 'Ready'),
  });

  final String title;
  final List<EnterpriseNavigationItem> navigationItems;
  final int selectedIndex;
  final ValueChanged<int> onNavigationSelected;
  final Widget child;
  final List<EnterpriseMenuGroup> menuGroups;
  final bool initiallyCollapsed;
  final double expandedMenuWidth;
  final double collapsedMenuWidth;
  final double messageAreaHeight;
  final EnterpriseMessage initialMessage;

  @override
  State<EnterpriseAppFrame> createState() => _EnterpriseAppFrameState();
}

class _EnterpriseAppFrameState extends State<EnterpriseAppFrame> {
  late bool _collapsed;
  late EnterpriseMessage _message;

  @override
  void initState() {
    super.initState();
    _collapsed = widget.initiallyCollapsed;
    _message = widget.initialMessage;
  }

  @override
  void didUpdateWidget(covariant EnterpriseAppFrame oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialMessage.text != widget.initialMessage.text ||
        oldWidget.initialMessage.severity != widget.initialMessage.severity) {
      _message = widget.initialMessage;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _TopMenuBar(
            title: widget.title,
            menuGroups: widget.menuGroups,
            onHelp: _showHelp,
            onSetMessage: _setMessage,
          ),
          Expanded(
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  width: _collapsed
                      ? widget.collapsedMenuWidth
                      : widget.expandedMenuWidth,
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    border: Border(
                      right: BorderSide(color: Theme.of(context).dividerColor),
                    ),
                  ),
                  child: _LeftNavigationBar(
                    collapsed: _collapsed,
                    selectedIndex: widget.selectedIndex,
                    items: widget.navigationItems,
                    onToggleCollapsed: () {
                      setState(() => _collapsed = !_collapsed);
                    },
                    onSelected: widget.onNavigationSelected,
                  ),
                ),
                Expanded(
                  child: ColoredBox(
                    color: Theme.of(context).colorScheme.surface,
                    child: widget.child,
                  ),
                ),
              ],
            ),
          ),
          _MessageArea(
            message: _message,
            height: widget.messageAreaHeight,
            onClear: () => _setMessage(const EnterpriseMessage(text: 'Ready')),
          ),
        ],
      ),
    );
  }

  void _setMessage(EnterpriseMessage message) =>
      setState(() => _message = message);
  Future<void> _showHelp() async {
    /* ... keep existing ... */
  }
}
// class EnterpriseAppFrame extends StatefulWidget {
//   const EnterpriseAppFrame({
//     super.key,
//     required this.title,
//     required this.navigationItems,

//     this.menuGroups = const <EnterpriseMenuGroup>[],
//     this.initialIndex = 0,
//     this.initiallyCollapsed = false,
//     this.expandedMenuWidth = 240,
//     this.collapsedMenuWidth = 64,
//     this.messageAreaHeight = 34,
//     this.initialMessage = const EnterpriseMessage(text: 'Ready'),
//   });

//   final String title;
//   final List<EnterpriseNavigationItem> navigationItems;
//   final List<EnterpriseMenuGroup> menuGroups;
//   final int initialIndex;
//   final bool initiallyCollapsed;
//   final double expandedMenuWidth;
//   final double collapsedMenuWidth;
//   final double messageAreaHeight;
//   final EnterpriseMessage initialMessage;

//   @override
//   State<EnterpriseAppFrame> createState() => _EnterpriseAppFrameState();
// }

// class _EnterpriseAppFrameState extends State<EnterpriseAppFrame> {
//   late int _selectedIndex;
//   late bool _collapsed;
//   late EnterpriseMessage _message;

//   @override
//   void initState() {
//     super.initState();
//     _selectedIndex = widget.initialIndex;
//     _collapsed = widget.initiallyCollapsed;
//     _message = widget.initialMessage;
//   }

//   @override
//   void didUpdateWidget(covariant EnterpriseAppFrame oldWidget) {
//     super.didUpdateWidget(oldWidget);

//     if (oldWidget.initialMessage.text != widget.initialMessage.text ||
//         oldWidget.initialMessage.severity != widget.initialMessage.severity) {
//       _message = widget.initialMessage;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final selectedPage = widget.navigationItems[_selectedIndex].page;
//     final menuWidth = _collapsed
//         ? widget.collapsedMenuWidth
//         : widget.expandedMenuWidth;

//     return Scaffold(
//       body: Column(
//         children: [
//           _TopMenuBar(
//             title: widget.title,
//             menuGroups: widget.menuGroups,
//             onHelp: _showHelp,
//             onSetMessage: _setMessage,
//           ),
//           Expanded(
//             child: Row(
//               children: [
//                 AnimatedContainer(
//                   duration: const Duration(milliseconds: 160),
//                   curve: Curves.easeOut,
//                   width: menuWidth,
//                   decoration: BoxDecoration(
//                     color: theme.colorScheme.surfaceContainerHighest,
//                     border: Border(
//                       right: BorderSide(color: theme.dividerColor),
//                     ),
//                   ),
//                   child: _LeftNavigationBar(
//                     collapsed: _collapsed,
//                     selectedIndex: _selectedIndex,
//                     items: widget.navigationItems,
//                     onToggleCollapsed: () {
//                       setState(() => _collapsed = !_collapsed);
//                     },
//                     onSelected: (index) {
//                       setState(() {
//                         _selectedIndex = index;
//                         _message = EnterpriseMessage(
//                           text: '${widget.navigationItems[index].label} opened',
//                         );
//                       });
//                     },
//                   ),
//                 ),
//                 Expanded(
//                   child: ColoredBox(
//                     color: theme.colorScheme.surface,
//                     child: selectedPage,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           _MessageArea(
//             message: _message,
//             height: widget.messageAreaHeight,
//             onClear: () => _setMessage(const EnterpriseMessage(text: 'Ready')),
//           ),
//         ],
//       ),
//     );
//   }

//   void _setMessage(EnterpriseMessage message) {
//     setState(() => _message = message);
//   }

//   Future<void> _showHelp() async {
//     await showDialog<void>(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Help'),
//           content: const Text(
//             'Use the top menu for commands and the left menu to switch modules.',
//           ),
//           actions: [
//             FilledButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

class _TopMenuBar extends StatelessWidget {
  const _TopMenuBar({
    required this.title,
    required this.menuGroups,
    required this.onHelp,
    required this.onSetMessage,
  });

  final String title;
  final List<EnterpriseMenuGroup> menuGroups;
  final VoidCallback onHelp;
  final ValueChanged<EnterpriseMessage> onSetMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(bottom: BorderSide(color: theme.dividerColor)),
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 48,
          child: Row(
            children: [
              const SizedBox(width: 12),
              Icon(Icons.business, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              SizedBox(
                width: 220,
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium,
                ),
              ),
              Expanded(
                child: MenuBar(
                  children: [
                    for (final group in menuGroups)
                      SubmenuButton(
                        menuChildren: [
                          for (final action in group.actions)
                            MenuItemButton(
                              leadingIcon: action.icon == null
                                  ? null
                                  : Icon(action.icon),
                              onPressed: action.onSelected,
                              child: Text(action.label),
                            ),
                        ],
                        child: Text(group.label),
                      ),
                    SubmenuButton(
                      menuChildren: [
                        MenuItemButton(
                          leadingIcon: const Icon(Icons.help_outline),
                          onPressed: onHelp,
                          child: const Text('Help Contents'),
                        ),
                        MenuItemButton(
                          leadingIcon: const Icon(Icons.info_outline),
                          onPressed: () {
                            onSetMessage(
                              const EnterpriseMessage(
                                text: 'Enterprise frame sample version 1.0',
                              ),
                            );
                          },
                          child: const Text('About'),
                        ),
                      ],
                      child: const Text('Help'),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Notifications',
                onPressed: () {
                  onSetMessage(
                    const EnterpriseMessage(
                      text: 'No new notifications',
                      severity: EnterpriseMessageSeverity.info,
                    ),
                  );
                },
                icon: const Icon(Icons.notifications_none),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _LeftNavigationBar extends StatelessWidget {
  const _LeftNavigationBar({
    required this.collapsed,
    required this.selectedIndex,
    required this.items,
    required this.onToggleCollapsed,
    required this.onSelected,
  });

  final bool collapsed;
  final int selectedIndex;
  final List<EnterpriseNavigationItem> items;
  final VoidCallback onToggleCollapsed;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 48,
          child: Align(
            alignment: collapsed ? Alignment.center : Alignment.centerRight,
            child: IconButton(
              tooltip: collapsed ? 'Expand menu' : 'Collapse menu',
              onPressed: onToggleCollapsed,
              icon: Icon(collapsed ? Icons.menu_open : Icons.menu),
            ),
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final selected = selectedIndex == index;

              if (collapsed) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  child: IconButton(
                    tooltip: item.label,
                    isSelected: selected,
                    onPressed: () => onSelected(index),
                    icon: Icon(item.icon),
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                child: NavigationRailDestinationTile(
                  selected: selected,
                  icon: item.icon,
                  label: item.label,
                  onPressed: () => onSelected(index),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class NavigationRailDestinationTile extends StatelessWidget {
  const NavigationRailDestinationTile({
    super.key,
    required this.selected,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final bool selected;
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foregroundColor = selected
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurface;
    final backgroundColor = selected
        ? theme.colorScheme.primary.withOpacity(0.10)
        : null;

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: onPressed,
        child: SizedBox(
          height: 42,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Icon(icon, size: 20, color: foregroundColor),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: foregroundColor,
                      fontWeight: selected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MessageArea extends StatelessWidget {
  const _MessageArea({
    required this.message,
    required this.height,
    required this.onClear,
  });

  final EnterpriseMessage message;
  final double height;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _severityColor(theme, message.severity);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        border: Border(top: BorderSide(color: theme.dividerColor)),
      ),
      child: SizedBox(
        height: height,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Icon(_severityIcon(message.severity), size: 16, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  message.text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall,
                ),
              ),
              Text(
                TimeOfDay.now().format(context),
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(width: 6),
              IconButton(
                tooltip: 'Clear message',
                onPressed: onClear,
                icon: const Icon(Icons.close, size: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _severityColor(ThemeData theme, EnterpriseMessageSeverity severity) {
    switch (severity) {
      case EnterpriseMessageSeverity.info:
        return theme.colorScheme.primary;
      case EnterpriseMessageSeverity.success:
        return Colors.green;
      case EnterpriseMessageSeverity.warning:
        return Colors.orange;
      case EnterpriseMessageSeverity.error:
        return theme.colorScheme.error;
    }
  }

  IconData _severityIcon(EnterpriseMessageSeverity severity) {
    switch (severity) {
      case EnterpriseMessageSeverity.info:
        return Icons.info_outline;
      case EnterpriseMessageSeverity.success:
        return Icons.check_circle_outline;
      case EnterpriseMessageSeverity.warning:
        return Icons.warning_amber;
      case EnterpriseMessageSeverity.error:
        return Icons.error_outline;
    }
  }
}
