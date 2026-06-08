// // router.dart
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:partner_demo/features/backend_structure_menu.dart';
// import 'package:partner_demo/features/enterprise_app_frame.dart';
// import 'package:partner_demo/presentation/screens/partner_detail_screen.dart';
// import 'package:partner_demo/presentation/screens/partner_form_screen.dart';
// import 'package:partner_demo/presentation/screens/partner_list_screen.dart';

// // ---------------------------------------------------------------------
// // 1. Build the left sidebar navigation items
// // ---------------------------------------------------------------------
// final List<EnterpriseNavigationItem> _navigationItems = [
//   const EnterpriseNavigationItem(
//     label: 'Partners',
//     icon: Icons.people_outline,
//     page: SizedBox.shrink(), // not used – the child is provided by the router
//   ),
//   ...buildBackendNavigationItems().map(
//     (item) => EnterpriseNavigationItem(
//       label: item.label,
//       icon: item.icon,
//       page: const SizedBox.shrink(),
//     ),
//   ),
// ];

// // ---------------------------------------------------------------------
// // 2. Build the top menu groups (File, Help, and Asset groups)
// // ---------------------------------------------------------------------
// final List<EnterpriseMenuGroup> _menuGroups = [
//   EnterpriseMenuGroup(
//     label: 'File',
//     actions: [
//       EnterpriseMenuAction(
//         label: 'Exit',
//         icon: Icons.exit_to_app,
//         onSelected: () => _rootNavigatorKey.currentState?.maybePop(),
//       ),
//     ],
//   ),
//   // Add the asset groups; clicking them will navigate to the corresponding asset module
//   ...buildBackendMenuGroups(
//     onSelected: (code, label) {
//       _shellNavigatorKey.currentContext?.go('/asset/$code');
//     },
//   ),
// ];

// // ---------------------------------------------------------------------
// // 3. Global navigator keys for ShellRoute
// // ---------------------------------------------------------------------
// final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey();
// final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey();

// // ---------------------------------------------------------------------
// // 4. Helper to determine which navigation item is active based on the route
// // ---------------------------------------------------------------------
// int _getSelectedIndex(String location) {
//   if (location.startsWith('/partners')) return 0;
//   for (int i = 0; i < backendMenuTree.length; i++) {
//     if (location.startsWith('/asset/${backendMenuTree[i].code}')) return i + 1;
//   }
//   return 0; // fallback to Partners
// }

// // ---------------------------------------------------------------------
// // 5. The GoRouter configuration
// // ---------------------------------------------------------------------
// final GoRouter router = GoRouter(
//   navigatorKey: _rootNavigatorKey,
//   initialLocation: '/partners',
//   routes: [
//     ShellRoute(
//       navigatorKey: _shellNavigatorKey,
//       builder: (context, state, child) {
//         final location = state.uri.toString();
//         final selectedIndex = _getSelectedIndex(location);
//         return EnterpriseAppFrame(
//           title: 'BizSoft ERP',
//           navigationItems: _navigationItems,
//           selectedIndex: selectedIndex,
//           onNavigationSelected: (index) {
//             // Called when the user clicks a left sidebar item
//             if (index == 0) {
//               context.go('/partners');
//             } else {
//               final node = backendMenuTree[index - 1];
//               context.go('/asset/${node.code}');
//             }
//           },
//           menuGroups: _menuGroups,
//           child: child,
//         );
//       },
//       routes: [
//         // ==================== PARTNERS MODULE ====================
//         GoRoute(
//           path: '/partners',
//           name: 'partners',
//           builder: (context, state) => const PartnerListScreen(),
//           routes: [
//             GoRoute(
//               path: 'new',
//               name: 'partner_new',
//               builder: (context, state) => const PartnerFormScreen(),
//             ),
//             GoRoute(
//               path: ':partnerId',
//               name: 'partner_detail',
//               builder: (context, state) {
//                 final id = state.pathParameters['partnerId']!;
//                 return PartnerDetailScreen(partnerId: id);
//               },
//               routes: [
//                 GoRoute(
//                   path: 'edit',
//                   name: 'partner_edit',
//                   builder: (context, state) {
//                     final id = state.pathParameters['partnerId']!;
//                     return PartnerFormScreen(partnerId: id);
//                   },
//                 ),
//               ],
//             ),
//           ],
//         ),

//         // ==================== ASSET MODULE (generic for now) ====================
//         for (final node in backendMenuTree)
//           GoRoute(
//             path: '/asset/${node.code}',
//             name: 'asset_${node.code}',
//             builder: (context, state) => BackendModulePage(node: node),
//           ),
//       ],
//     ),
//   ],
// );

// router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:partner_demo/features/backend_structure_menu.dart';
import 'package:partner_demo/features/composite_code_input_example.dart';
import 'package:partner_demo/features/data_entry_browser.dart';
import 'package:partner_demo/features/enterprise_app_frame.dart';
import 'package:partner_demo/presentation/screens/partner_detail_screen.dart';
import 'package:partner_demo/presentation/screens/partner_form_screen.dart';
import 'package:partner_demo/presentation/screens/partner_list_screen.dart';

// ---------------------------------------------------------------------
// 1. Build the left sidebar navigation items
// ---------------------------------------------------------------------
final List<EnterpriseNavigationItem> _navigationItems = [
  const EnterpriseNavigationItem(
    label: 'Partners',
    icon: Icons.people_outline,
    page: SizedBox.shrink(),
  ),
  ...buildBackendNavigationItems().map(
    (item) => EnterpriseNavigationItem(
      label: item.label,
      icon: item.icon,
      page: const SizedBox.shrink(),
    ),
  ),
];

// ---------------------------------------------------------------------
// 2. Build the top menu groups (File, Help, and Asset groups)
// ---------------------------------------------------------------------
final List<EnterpriseMenuGroup> _menuGroups = [
  EnterpriseMenuGroup(
    label: 'File',
    actions: [
      EnterpriseMenuAction(
        label: 'Exit',
        icon: Icons.exit_to_app,
        onSelected: () => _rootNavigatorKey.currentState?.maybePop(),
      ),
    ],
  ),
  ...buildBackendMenuGroups(
    onSelected: (code, label) {
      // Find which top-level node this child belongs to
      for (final node in backendMenuTree) {
        if (node.children.any((child) => child.code == code)) {
          _shellNavigatorKey.currentContext?.go('/${node.code}/$code');
          return;
        }
      }
    },
  ),
];

// ---------------------------------------------------------------------
// 3. Global navigator keys
// ---------------------------------------------------------------------
final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey();

// ---------------------------------------------------------------------
// 4. Helper to determine which navigation item is active
// ---------------------------------------------------------------------
int _getSelectedIndex(String location) {
  if (location.startsWith('/partners')) return 0;
  for (int i = 0; i < backendMenuTree.length; i++) {
    final node = backendMenuTree[i];
    if (location.startsWith('/${node.code}')) return i + 1;
  }
  return 0;
}

// ---------------------------------------------------------------------
// 5. The GoRouter configuration
// ---------------------------------------------------------------------
final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/partners',
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        final location = state.uri.toString();
        final selectedIndex = _getSelectedIndex(location);
        return EnterpriseAppFrame(
          title: 'BizSoft ERP',
          navigationItems: _navigationItems,
          selectedIndex: selectedIndex,
          onNavigationSelected: (index) {
            if (index == 0) {
              context.go('/partners');
            } else {
              final node = backendMenuTree[index - 1];
              context.go('/${node.code}');
            }
          },
          menuGroups: _menuGroups,
          child: child,
        );
      },
      routes: [
        // ==================== PARTNERS MODULE ====================
        GoRoute(
          path: '/partners',
          name: 'partners',
          builder: (context, state) => const PartnerListScreen(),
          routes: [
            GoRoute(
              path: 'new',
              name: 'partner_new',
              builder: (context, state) => const PartnerFormScreen(),
            ),
            GoRoute(
              path: ':partnerId',
              name: 'partner_detail',
              builder: (context, state) {
                final id = state.pathParameters['partnerId']!;
                return PartnerDetailScreen(partnerId: id);
              },
              routes: [
                GoRoute(
                  path: 'edit',
                  name: 'partner_edit',
                  builder: (context, state) {
                    final id = state.pathParameters['partnerId']!;
                    return PartnerFormScreen(partnerId: id);
                  },
                ),
              ],
            ),
          ],
        ),

        // ==================== ASSET & DEMO MODULES (generic card view) ====================
        for (final node in backendMenuTree)
          GoRoute(
            path: '/${node.code}',
            name: 'module_${node.code}',
            builder: (context, state) => BackendModulePage(node: node),
          ),

        // ==================== CHILD SCREENS ====================
        // Composite Code Input Demo
        GoRoute(
          path: '/demo/composite_code_input',
          name: 'demo_composite_code_input',
          builder: (context, state) => const CompositeCodeInputDemoScreen(),
        ),
        // Data Entry Browser Demo
        GoRoute(
          path: '/demo/data_entry_browser',
          name: 'demo_data_entry_browser',
          builder: (context, state) => DataEntryBrowserDemoScreen(),
        ),
      ],
    ),
  ],
);
