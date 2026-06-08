// import 'package:flutter/material.dart';

// import 'enterprise_app_frame.dart';

// class BackendMenuNode {
//   const BackendMenuNode({
//     required this.code,
//     required this.label,
//     this.icon = Icons.folder_outlined,
//     this.children = const <BackendMenuNode>[],
//   });

//   final String code;
//   final String label;
//   final IconData icon;
//   final List<BackendMenuNode> children;

//   bool get hasChildren => children.isNotEmpty;
// }

// const List<BackendMenuNode> backendMenuTree = [
//   BackendMenuNode(
//     code: 'demo',
//     label: 'Demo',
//     icon: Icons.code,
//     children: [
//       BackendMenuNode(
//         code: 'composite_code_input',
//         label: 'Composite Code Input',
//         icon: Icons.edit_attributes,
//       ),
//       BackendMenuNode(
//         code: 'data_entry_browser',
//         label: 'Data Entry Browser',
//         icon: Icons.table_rows,
//       ),
//     ],
//   ),
//   BackendMenuNode(
//     code: 'asset_core',
//     label: 'Asset Core',
//     icon: Icons.inventory_2_outlined,
//     children: [
//       BackendMenuNode(code: 'asset', label: 'Asset Register'),
//       BackendMenuNode(code: 'asset_identifier', label: 'Asset Identifier'),
//       BackendMenuNode(code: 'asset_status', label: 'Asset Status'),
//       BackendMenuNode(code: 'asset_snapshot', label: 'Asset Snapshot'),
//     ],
//   ),
//   BackendMenuNode(
//     code: 'asset_lifecycle',
//     label: 'Asset Lifecycle',
//     icon: Icons.route_outlined,
//     children: [
//       BackendMenuNode(code: 'registration', label: 'Registration'),
//       BackendMenuNode(code: 'capitalization', label: 'Capitalization'),
//       BackendMenuNode(code: 'deployment', label: 'Deployment'),
//       BackendMenuNode(code: 'transfer', label: 'Transfer'),
//       BackendMenuNode(code: 'decommission', label: 'Decommission'),
//       BackendMenuNode(code: 'disposal', label: 'Disposal'),
//       BackendMenuNode(code: 'write_off', label: 'Write Off'),
//       BackendMenuNode(code: 'held_for_sale', label: 'Held for Sale'),
//     ],
//   ),
//   BackendMenuNode(
//     code: 'asset_valuation',
//     label: 'Asset Valuation',
//     icon: Icons.price_change_outlined,
//     children: [
//       BackendMenuNode(
//         code: 'depreciation_policy',
//         label: 'Depreciation Policy',
//       ),
//       BackendMenuNode(code: 'depreciation_run', label: 'Depreciation Run'),
//       BackendMenuNode(code: 'depreciation_entry', label: 'Depreciation Entry'),
//       BackendMenuNode(code: 'impairment', label: 'Impairment'),
//       BackendMenuNode(code: 'revaluation', label: 'Revaluation'),
//       BackendMenuNode(code: 'useful_life_change', label: 'Useful Life Change'),
//       BackendMenuNode(
//         code: 'residual_value_change',
//         label: 'Residual Value Change',
//       ),
//     ],
//   ),
//   BackendMenuNode(
//     code: 'asset_structure',
//     label: 'Asset Structure',
//     icon: Icons.account_tree_outlined,
//     children: [
//       BackendMenuNode(code: 'split', label: 'Split'),
//       BackendMenuNode(code: 'merge', label: 'Merge'),
//       BackendMenuNode(code: 'component_addition', label: 'Component Addition'),
//       BackendMenuNode(
//         code: 'component_replacement',
//         label: 'Component Replacement',
//       ),
//       BackendMenuNode(code: 'parent_child_link', label: 'Parent Child Link'),
//     ],
//   ),
//   BackendMenuNode(
//     code: 'verification',
//     label: 'Verification',
//     icon: Icons.fact_check_outlined,
//     children: [
//       BackendMenuNode(code: 'physical_count', label: 'Physical Count'),
//       BackendMenuNode(
//         code: 'physical_count_sheet',
//         label: 'Physical Count Sheet',
//       ),
//       BackendMenuNode(
//         code: 'physical_count_result',
//         label: 'Physical Count Result',
//       ),
//       BackendMenuNode(code: 'discrepancy', label: 'Discrepancy'),
//     ],
//   ),
//   BackendMenuNode(
//     code: 'master_data',
//     label: 'Master Data',
//     icon: Icons.dataset_outlined,
//     children: [
//       BackendMenuNode(code: 'branch', label: 'Branch'),
//       BackendMenuNode(code: 'location', label: 'Location'),
//       BackendMenuNode(code: 'custodian', label: 'Custodian'),
//       BackendMenuNode(code: 'department', label: 'Department'),
//       BackendMenuNode(
//         code: 'asset_classification',
//         label: 'Asset Classification',
//       ),
//       BackendMenuNode(code: 'manufacturer', label: 'Manufacturer'),
//     ],
//   ),
//   BackendMenuNode(
//     code: 'reference',
//     label: 'Reference',
//     icon: Icons.link_outlined,
//     children: [
//       BackendMenuNode(code: 'branch_reference', label: 'Branch Reference'),
//       BackendMenuNode(code: 'location_reference', label: 'Location Reference'),
//       BackendMenuNode(
//         code: 'custodian_reference',
//         label: 'Custodian Reference',
//       ),
//       BackendMenuNode(
//         code: 'department_reference',
//         label: 'Department Reference',
//       ),
//       BackendMenuNode(code: 'account_reference', label: 'Account Reference'),
//     ],
//   ),
//   BackendMenuNode(
//     code: 'setup',
//     label: 'Setup',
//     icon: Icons.settings_outlined,
//     children: [
//       BackendMenuNode(code: 'system_setting', label: 'System Setting'),
//       BackendMenuNode(
//         code: 'reference_source_setting',
//         label: 'Reference Source Setting',
//       ),
//       BackendMenuNode(code: 'posting_rule', label: 'Posting Rule'),
//       BackendMenuNode(
//         code: 'depreciation_setting',
//         label: 'Depreciation Setting',
//       ),
//       BackendMenuNode(code: 'numbering_rule', label: 'Numbering Rule'),
//     ],
//   ),
//   BackendMenuNode(
//     code: 'reporting',
//     label: 'Reporting',
//     icon: Icons.assessment_outlined,
//     children: [
//       BackendMenuNode(code: 'asset_summary', label: 'Asset Summary'),
//       BackendMenuNode(code: 'asset_history', label: 'Asset History'),
//       BackendMenuNode(code: 'movement_report', label: 'Movement Report'),
//       BackendMenuNode(code: 'valuation_report', label: 'Valuation Report'),
//       BackendMenuNode(
//         code: 'physical_count_report',
//         label: 'Physical Count Report',
//       ),
//     ],
//   ),
//   BackendMenuNode(
//     code: 'workstations',
//     label: 'Workstations',
//     icon: Icons.workspaces_outline,
//     children: [
//       BackendMenuNode(code: 'draft_assets', label: 'Draft Assets'),
//       BackendMenuNode(
//         code: 'assets_for_capitalization',
//         label: 'Assets for Capitalization',
//       ),
//       BackendMenuNode(
//         code: 'assets_for_deployment',
//         label: 'Assets for Deployment',
//       ),
//       BackendMenuNode(
//         code: 'assets_for_transfer',
//         label: 'Assets for Transfer',
//       ),
//       BackendMenuNode(
//         code: 'assets_for_disposal',
//         label: 'Assets for Disposal',
//       ),
//       BackendMenuNode(
//         code: 'held_for_sale_workstation',
//         label: 'Held for Sale',
//       ),
//     ],
//   ),
//   BackendMenuNode(
//     code: 'integrations',
//     label: 'Integrations',
//     icon: Icons.hub_outlined,
//     children: [
//       BackendMenuNode(code: 'gl_api_client', label: 'GL Integration'),
//       BackendMenuNode(code: 'hr_api_client', label: 'HR Integration'),
//       BackendMenuNode(
//         code: 'org_api_client',
//         label: 'Organization Integration',
//       ),
//       BackendMenuNode(code: 'notification_service', label: 'Notifications'),
//       BackendMenuNode(code: 'cache_service', label: 'Cache'),
//       BackendMenuNode(code: 'file_export_service', label: 'File Export'),
//     ],
//   ),
// ];

// List<EnterpriseNavigationItem> buildBackendNavigationItems() {
//   return [
//     for (final node in backendMenuTree)
//       EnterpriseNavigationItem(
//         label: node.label,
//         icon: node.icon,
//         page: BackendModulePage(node: node),
//       ),
//   ];
// }

// List<EnterpriseMenuGroup> buildBackendMenuGroups({
//   required void Function(String code, String label) onSelected,
// }) {
//   return [
//     for (final node in backendMenuTree)
//       EnterpriseMenuGroup(
//         label: node.label,
//         actions: [
//           for (final child in node.children)
//             EnterpriseMenuAction(
//               label: child.label,
//               icon: child.icon,
//               onSelected: () => onSelected(child.code, child.label),
//             ),
//         ],
//       ),
//   ];
// }

// class BackendModulePage extends StatelessWidget {
//   const BackendModulePage({super.key, required this.node});

//   final BackendMenuNode node;

//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       padding: const EdgeInsets.all(16),
//       children: [
//         Row(
//           children: [
//             Icon(node.icon, size: 28),
//             const SizedBox(width: 10),
//             Text(node.label, style: Theme.of(context).textTheme.titleLarge),
//           ],
//         ),
//         const SizedBox(height: 16),
//         Wrap(
//           spacing: 12,
//           runSpacing: 12,
//           children: [
//             for (final child in node.children)
//               SizedBox(
//                 width: 260,
//                 child: Card(
//                   child: ListTile(
//                     leading: Icon(child.icon),
//                     title: Text(child.label),
//                     subtitle: Text(child.code),
//                     trailing: const Icon(Icons.chevron_right),
//                     onTap: () {},
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'enterprise_app_frame.dart';

class BackendMenuNode {
  const BackendMenuNode({
    required this.code,
    required this.label,
    this.icon = Icons.folder_outlined,
    this.children = const <BackendMenuNode>[],
  });

  final String code;
  final String label;
  final IconData icon;
  final List<BackendMenuNode> children;

  bool get hasChildren => children.isNotEmpty;
}

const List<BackendMenuNode> backendMenuTree = [
  BackendMenuNode(
    code: 'asset_core',
    label: 'Asset Core',
    icon: Icons.inventory_2_outlined,
    children: [
      BackendMenuNode(code: 'asset', label: 'Asset Register'),
      BackendMenuNode(code: 'asset_identifier', label: 'Asset Identifier'),
      BackendMenuNode(code: 'asset_status', label: 'Asset Status'),
      BackendMenuNode(code: 'asset_snapshot', label: 'Asset Snapshot'),
    ],
  ),
  BackendMenuNode(
    code: 'asset_lifecycle',
    label: 'Asset Lifecycle',
    icon: Icons.route_outlined,
    children: [
      BackendMenuNode(code: 'registration', label: 'Registration'),
      BackendMenuNode(code: 'capitalization', label: 'Capitalization'),
      BackendMenuNode(code: 'deployment', label: 'Deployment'),
      BackendMenuNode(code: 'transfer', label: 'Transfer'),
      BackendMenuNode(code: 'decommission', label: 'Decommission'),
      BackendMenuNode(code: 'disposal', label: 'Disposal'),
      BackendMenuNode(code: 'write_off', label: 'Write Off'),
      BackendMenuNode(code: 'held_for_sale', label: 'Held for Sale'),
    ],
  ),
  BackendMenuNode(
    code: 'asset_valuation',
    label: 'Asset Valuation',
    icon: Icons.price_change_outlined,
    children: [
      BackendMenuNode(
        code: 'depreciation_policy',
        label: 'Depreciation Policy',
      ),
      BackendMenuNode(code: 'depreciation_run', label: 'Depreciation Run'),
      BackendMenuNode(code: 'depreciation_entry', label: 'Depreciation Entry'),
      BackendMenuNode(code: 'impairment', label: 'Impairment'),
      BackendMenuNode(code: 'revaluation', label: 'Revaluation'),
      BackendMenuNode(code: 'useful_life_change', label: 'Useful Life Change'),
      BackendMenuNode(
        code: 'residual_value_change',
        label: 'Residual Value Change',
      ),
    ],
  ),
  BackendMenuNode(
    code: 'asset_structure',
    label: 'Asset Structure',
    icon: Icons.account_tree_outlined,
    children: [
      BackendMenuNode(code: 'split', label: 'Split'),
      BackendMenuNode(code: 'merge', label: 'Merge'),
      BackendMenuNode(code: 'component_addition', label: 'Component Addition'),
      BackendMenuNode(
        code: 'component_replacement',
        label: 'Component Replacement',
      ),
      BackendMenuNode(code: 'parent_child_link', label: 'Parent Child Link'),
    ],
  ),
  BackendMenuNode(
    code: 'verification',
    label: 'Verification',
    icon: Icons.fact_check_outlined,
    children: [
      BackendMenuNode(code: 'physical_count', label: 'Physical Count'),
      BackendMenuNode(
        code: 'physical_count_sheet',
        label: 'Physical Count Sheet',
      ),
      BackendMenuNode(
        code: 'physical_count_result',
        label: 'Physical Count Result',
      ),
      BackendMenuNode(code: 'discrepancy', label: 'Discrepancy'),
    ],
  ),
  BackendMenuNode(
    code: 'master_data',
    label: 'Master Data',
    icon: Icons.dataset_outlined,
    children: [
      BackendMenuNode(code: 'branch', label: 'Branch'),
      BackendMenuNode(code: 'location', label: 'Location'),
      BackendMenuNode(code: 'custodian', label: 'Custodian'),
      BackendMenuNode(code: 'department', label: 'Department'),
      BackendMenuNode(
        code: 'asset_classification',
        label: 'Asset Classification',
      ),
      BackendMenuNode(code: 'manufacturer', label: 'Manufacturer'),
    ],
  ),
  BackendMenuNode(
    code: 'reference',
    label: 'Reference',
    icon: Icons.link_outlined,
    children: [
      BackendMenuNode(code: 'branch_reference', label: 'Branch Reference'),
      BackendMenuNode(code: 'location_reference', label: 'Location Reference'),
      BackendMenuNode(
        code: 'custodian_reference',
        label: 'Custodian Reference',
      ),
      BackendMenuNode(
        code: 'department_reference',
        label: 'Department Reference',
      ),
      BackendMenuNode(code: 'account_reference', label: 'Account Reference'),
    ],
  ),
  BackendMenuNode(
    code: 'setup',
    label: 'Setup',
    icon: Icons.settings_outlined,
    children: [
      BackendMenuNode(code: 'system_setting', label: 'System Setting'),
      BackendMenuNode(
        code: 'reference_source_setting',
        label: 'Reference Source Setting',
      ),
      BackendMenuNode(code: 'posting_rule', label: 'Posting Rule'),
      BackendMenuNode(
        code: 'depreciation_setting',
        label: 'Depreciation Setting',
      ),
      BackendMenuNode(code: 'numbering_rule', label: 'Numbering Rule'),
    ],
  ),
  BackendMenuNode(
    code: 'reporting',
    label: 'Reporting',
    icon: Icons.assessment_outlined,
    children: [
      BackendMenuNode(code: 'asset_summary', label: 'Asset Summary'),
      BackendMenuNode(code: 'asset_history', label: 'Asset History'),
      BackendMenuNode(code: 'movement_report', label: 'Movement Report'),
      BackendMenuNode(code: 'valuation_report', label: 'Valuation Report'),
      BackendMenuNode(
        code: 'physical_count_report',
        label: 'Physical Count Report',
      ),
    ],
  ),
  BackendMenuNode(
    code: 'workstations',
    label: 'Workstations',
    icon: Icons.workspaces_outline,
    children: [
      BackendMenuNode(code: 'draft_assets', label: 'Draft Assets'),
      BackendMenuNode(
        code: 'assets_for_capitalization',
        label: 'Assets for Capitalization',
      ),
      BackendMenuNode(
        code: 'assets_for_deployment',
        label: 'Assets for Deployment',
      ),
      BackendMenuNode(
        code: 'assets_for_transfer',
        label: 'Assets for Transfer',
      ),
      BackendMenuNode(
        code: 'assets_for_disposal',
        label: 'Assets for Disposal',
      ),
      BackendMenuNode(
        code: 'held_for_sale_workstation',
        label: 'Held for Sale',
      ),
    ],
  ),
  BackendMenuNode(
    code: 'integrations',
    label: 'Integrations',
    icon: Icons.hub_outlined,
    children: [
      BackendMenuNode(code: 'gl_api_client', label: 'GL Integration'),
      BackendMenuNode(code: 'hr_api_client', label: 'HR Integration'),
      BackendMenuNode(
        code: 'org_api_client',
        label: 'Organization Integration',
      ),
      BackendMenuNode(code: 'notification_service', label: 'Notifications'),
      BackendMenuNode(code: 'cache_service', label: 'Cache'),
      BackendMenuNode(code: 'file_export_service', label: 'File Export'),
    ],
  ),
  // ==================== DEMO NODE ====================
  BackendMenuNode(
    code: 'demo',
    label: 'Demo',
    icon: Icons.code,
    children: [
      BackendMenuNode(
        code: 'composite_code_input',
        label: 'Composite Code Input',
        icon: Icons.edit_attributes,
      ),
      BackendMenuNode(
        code: 'data_entry_browser',
        label: 'Data Entry Browser',
        icon: Icons.table_rows,
      ),
    ],
  ),
];

List<EnterpriseNavigationItem> buildBackendNavigationItems() {
  return [
    for (final node in backendMenuTree)
      EnterpriseNavigationItem(
        label: node.label,
        icon: node.icon,
        page: BackendModulePage(node: node),
      ),
  ];
}

List<EnterpriseMenuGroup> buildBackendMenuGroups({
  required void Function(String code, String label) onSelected,
}) {
  return [
    for (final node in backendMenuTree)
      EnterpriseMenuGroup(
        label: node.label,
        actions: [
          for (final child in node.children)
            EnterpriseMenuAction(
              label: child.label,
              icon: child.icon,
              onSelected: () => onSelected(child.code, child.label),
            ),
        ],
      ),
  ];
}

class BackendModulePage extends StatelessWidget {
  const BackendModulePage({super.key, required this.node});

  final BackendMenuNode node;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Icon(node.icon, size: 28),
            const SizedBox(width: 10),
            Text(node.label, style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final child in node.children)
              SizedBox(
                width: 260,
                child: Card(
                  child: ListTile(
                    leading: Icon(child.icon),
                    title: Text(child.label),
                    subtitle: Text(child.code),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // Navigate to the child's route
                      final route = '/${node.code}/${child.code}';
                      context.go(route);
                    },
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
