import 'package:flutter/material.dart';
import 'package:partner_demo/features/composite_code_input.dart';

void main() {
  runApp(const CompositeCodeInputSampleApp());
}

class CompositeCodeInputSampleApp extends StatelessWidget {
  const CompositeCodeInputSampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Composite Code Input',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const CompositeCodeInputExamplePage(),
    );
  }
}

class CompositeCodeInputExamplePage extends StatefulWidget {
  const CompositeCodeInputExamplePage({super.key});

  @override
  State<CompositeCodeInputExamplePage> createState() =>
      _CompositeCodeInputExamplePageState();
}

class _CompositeCodeInputExamplePageState
    extends State<CompositeCodeInputExamplePage> {
  CompositeCodeInputValue? _companyBranchValue;
  CompositeCodeInputValue? _assetCodeValue;
  CompositeCodeInputValue? _noSeparatorValue;

  late final StaticListDataSourceStrategy _staticDataSource =
      StaticListDataSourceStrategy({
        'companies': const [
          SegmentLookupItem(
            id: '1',
            code: 'BIS',
            name: 'Business Information Systems',
          ),
          SegmentLookupItem(id: '2', code: 'FAR', name: 'Fixed Asset Register'),
        ],
        'branches': const [
          SegmentLookupItem(id: '1', code: 'YGN', name: 'Yangon'),
          SegmentLookupItem(id: '2', code: 'MDY', name: 'Mandalay'),
          SegmentLookupItem(id: '3', code: 'NPW', name: 'Naypyitaw'),
        ],
        'categories': const [
          SegmentLookupItem(id: '1', code: 'EQP', name: 'Equipment'),
          SegmentLookupItem(id: '2', code: 'VEH', name: 'Vehicle'),
          SegmentLookupItem(id: '3', code: 'BLD', name: 'Building'),
        ],
      });

  Map<String, SegmentDataSourceStrategy> get _dataSources => {
    'companies': _staticDataSource,
    'branches': _staticDataSource,
    'categories': _staticDataSource,
  };

  Map<String, DisplayStrategy> get _displayStrategies => {
    'codeOnly': CodeOnlyDisplayStrategy(),
    'codeName': CodeNameDisplayStrategy(),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Composite Code Input')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CompositeCodeInput(
            labelText: 'Company-Branch-Year-Sequence',
            helperText: 'Example: BIS-YGN-2026-000125',
            definition: _companyBranchYearSeqDefinition,
            dataSourceStrategies: _dataSources,
            displayStrategies: _displayStrategies,
            onChanged: (value) => setState(() => _companyBranchValue = value),
          ),
          _ValuePreview(value: _companyBranchValue),
          const SizedBox(height: 24),
          CompositeCodeInput(
            labelText: 'Asset Code',
            helperText: 'Example: EQP-YGN-000125',
            definition: _assetCodeDefinition,
            dataSourceStrategies: _dataSources,
            displayStrategies: _displayStrategies,
            onChanged: (value) => setState(() => _assetCodeValue = value),
          ),
          _ValuePreview(value: _assetCodeValue),
          const SizedBox(height: 24),
          CompositeCodeInput(
            labelText: 'No Separator Code',
            helperText: 'Example: BISYGN2026000125',
            definition: _noSeparatorDefinition,
            dataSourceStrategies: _dataSources,
            displayStrategies: _displayStrategies,
            onChanged: (value) => setState(() => _noSeparatorValue = value),
          ),
          _ValuePreview(value: _noSeparatorValue),
        ],
      ),
    );
  }
}

const CompositeCodePatternDefinition _companyBranchYearSeqDefinition =
    CompositeCodePatternDefinition(
      pattern: '{CompanyCode}-{BranchCode}-{YYYY}-{SEQ}',
      separator: '-',
      segments: [
        CompositeCodeSegmentDefinition(
          segmentKey: 'companyCode',
          label: 'Company',
          token: '{CompanyCode}',
          inputMode: SegmentInputMode.selectOnly,
          popupType: SegmentPopupType.list,
          validationMode: SegmentValidationMode.fixedLength,
          fixedLength: 3,
          required: true,
          dataSourceCode: 'companies',
          displayStrategyCode: 'codeName',
          placeholder: 'BIS',
        ),
        CompositeCodeSegmentDefinition(
          segmentKey: 'branchCode',
          label: 'Branch',
          token: '{BranchCode}',
          inputMode: SegmentInputMode.selectOnly,
          popupType: SegmentPopupType.searchGrid,
          validationMode: SegmentValidationMode.fixedLength,
          fixedLength: 3,
          required: true,
          dataSourceCode: 'branches',
          displayStrategyCode: 'codeName',
          placeholder: 'YGN',
        ),
        CompositeCodeSegmentDefinition(
          segmentKey: 'year',
          label: 'Year',
          token: '{YYYY}',
          inputMode: SegmentInputMode.autoGenerated,
          popupType: SegmentPopupType.none,
          validationMode: SegmentValidationMode.fixedLength,
          fixedLength: 4,
          required: true,
        ),
        CompositeCodeSegmentDefinition(
          segmentKey: 'sequence',
          label: 'Sequence',
          token: '{SEQ}',
          inputMode: SegmentInputMode.inputOnly,
          popupType: SegmentPopupType.none,
          validationMode: SegmentValidationMode.regexAndFixedLength,
          fixedLength: 6,
          regexPattern: r'^\d{6}$',
          required: true,
          placeholder: '000125',
        ),
      ],
    );

const CompositeCodePatternDefinition _assetCodeDefinition =
    CompositeCodePatternDefinition(
      pattern: '{CategoryCode}-{BranchCode}-{SEQ}',
      separator: '-',
      segments: [
        CompositeCodeSegmentDefinition(
          segmentKey: 'categoryCode',
          label: 'Category',
          token: '{CategoryCode}',
          inputMode: SegmentInputMode.selectOnly,
          popupType: SegmentPopupType.tree,
          validationMode: SegmentValidationMode.fixedLength,
          fixedLength: 3,
          required: true,
          dataSourceCode: 'categories',
          displayStrategyCode: 'codeName',
        ),
        CompositeCodeSegmentDefinition(
          segmentKey: 'branchCode',
          label: 'Branch',
          token: '{BranchCode}',
          inputMode: SegmentInputMode.selectOnly,
          popupType: SegmentPopupType.searchGrid,
          validationMode: SegmentValidationMode.fixedLength,
          fixedLength: 3,
          required: true,
          dataSourceCode: 'branches',
          displayStrategyCode: 'codeName',
        ),
        CompositeCodeSegmentDefinition(
          segmentKey: 'sequence',
          label: 'Sequence',
          token: '{SEQ}',
          inputMode: SegmentInputMode.inputOnly,
          popupType: SegmentPopupType.none,
          validationMode: SegmentValidationMode.regexAndFixedLength,
          fixedLength: 6,
          regexPattern: r'^\d{6}$',
          required: true,
        ),
      ],
    );

const CompositeCodePatternDefinition _noSeparatorDefinition =
    CompositeCodePatternDefinition(
      pattern: '{CompanyCode}{BranchCode}{YYYY}{SEQ}',
      separator: null,
      segments: [
        CompositeCodeSegmentDefinition(
          segmentKey: 'companyCode',
          label: 'Company',
          token: '{CompanyCode}',
          inputMode: SegmentInputMode.selectOnly,
          popupType: SegmentPopupType.list,
          validationMode: SegmentValidationMode.fixedLength,
          fixedLength: 3,
          required: true,
          dataSourceCode: 'companies',
          displayStrategyCode: 'codeName',
        ),
        CompositeCodeSegmentDefinition(
          segmentKey: 'branchCode',
          label: 'Branch',
          token: '{BranchCode}',
          inputMode: SegmentInputMode.selectOnly,
          popupType: SegmentPopupType.searchGrid,
          validationMode: SegmentValidationMode.fixedLength,
          fixedLength: 3,
          required: true,
          dataSourceCode: 'branches',
          displayStrategyCode: 'codeName',
        ),
        CompositeCodeSegmentDefinition(
          segmentKey: 'year',
          label: 'Year',
          token: '{YYYY}',
          inputMode: SegmentInputMode.autoGenerated,
          popupType: SegmentPopupType.none,
          validationMode: SegmentValidationMode.fixedLength,
          fixedLength: 4,
          required: true,
        ),
        CompositeCodeSegmentDefinition(
          segmentKey: 'sequence',
          label: 'Sequence',
          token: '{SEQ}',
          inputMode: SegmentInputMode.inputOnly,
          popupType: SegmentPopupType.none,
          validationMode: SegmentValidationMode.regexAndFixedLength,
          fixedLength: 6,
          regexPattern: r'^\d{6}$',
          required: true,
        ),
      ],
    );

class _ValuePreview extends StatelessWidget {
  const _ValuePreview({required this.value});

  final CompositeCodeInputValue? value;

  @override
  Widget build(BuildContext context) {
    final value = this.value;
    if (value == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        'Code: ${value.finalCode}\nValid: ${value.isValid}\nSegments: ${value.segmentValues}',
      ),
    );
  }
}

// UI screen
class CompositeCodeInputDemoScreen extends StatelessWidget {
  const CompositeCodeInputDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Composite Code Input Demo')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CompositeCodeInput(
            labelText: 'Company-Branch-Year-Sequence',
            helperText: 'Example: BIS-YGN-2026-000125',
            definition: _companyBranchYearSeqDefinition,
            dataSourceStrategies: _staticDataSources,
            displayStrategies: _displayStrategies,
            onChanged: (value) {
              // Optional: show result in console or a snackbar
              debugPrint('Code: ${value.finalCode}, Valid: ${value.isValid}');
            },
          ),
          const SizedBox(height: 24),
          CompositeCodeInput(
            labelText: 'Asset Code',
            helperText: 'Example: EQP-YGN-000125',
            definition: _assetCodeDefinition,
            dataSourceStrategies: _staticDataSources,
            displayStrategies: _displayStrategies,
            onChanged: (value) {},
          ),
          const SizedBox(height: 24),
          CompositeCodeInput(
            labelText: 'No Separator Code',
            helperText: 'Example: BISYGN2026000125',
            definition: _noSeparatorDefinition,
            dataSourceStrategies: _staticDataSources,
            displayStrategies: _displayStrategies,
            onChanged: (value) {},
          ),
        ],
      ),
    );
  }

  // Reuse the definitions from composite_code_input_example.dart
  static const _companyBranchYearSeqDefinition = CompositeCodePatternDefinition(
    pattern: '{CompanyCode}-{BranchCode}-{YYYY}-{SEQ}',
    separator: '-',
    segments: [
      CompositeCodeSegmentDefinition(
        segmentKey: 'companyCode',
        label: 'Company',
        token: '{CompanyCode}',
        inputMode: SegmentInputMode.selectOnly,
        popupType: SegmentPopupType.list,
        validationMode: SegmentValidationMode.fixedLength,
        fixedLength: 3,
        required: true,
        dataSourceCode: 'companies',
        displayStrategyCode: 'codeName',
      ),
      CompositeCodeSegmentDefinition(
        segmentKey: 'branchCode',
        label: 'Branch',
        token: '{BranchCode}',
        inputMode: SegmentInputMode.selectOnly,
        popupType: SegmentPopupType.searchGrid,
        validationMode: SegmentValidationMode.fixedLength,
        fixedLength: 3,
        required: true,
        dataSourceCode: 'branches',
        displayStrategyCode: 'codeName',
      ),
      CompositeCodeSegmentDefinition(
        segmentKey: 'year',
        label: 'Year',
        token: '{YYYY}',
        inputMode: SegmentInputMode.autoGenerated,
        popupType: SegmentPopupType.none,
        validationMode: SegmentValidationMode.fixedLength,
        fixedLength: 4,
        required: true,
      ),
      CompositeCodeSegmentDefinition(
        segmentKey: 'sequence',
        label: 'Sequence',
        token: '{SEQ}',
        inputMode: SegmentInputMode.inputOnly,
        popupType: SegmentPopupType.none,
        validationMode: SegmentValidationMode.regexAndFixedLength,
        fixedLength: 6,
        regexPattern: r'^\d{6}$',
        required: true,
      ),
    ],
  );

  static const _assetCodeDefinition = CompositeCodePatternDefinition(
    pattern: '{CategoryCode}-{BranchCode}-{SEQ}',
    separator: '-',
    segments: [
      CompositeCodeSegmentDefinition(
        segmentKey: 'categoryCode',
        label: 'Category',
        token: '{CategoryCode}',
        inputMode: SegmentInputMode.selectOnly,
        popupType: SegmentPopupType.tree,
        validationMode: SegmentValidationMode.fixedLength,
        fixedLength: 3,
        required: true,
        dataSourceCode: 'categories',
        displayStrategyCode: 'codeName',
      ),
      CompositeCodeSegmentDefinition(
        segmentKey: 'branchCode',
        label: 'Branch',
        token: '{BranchCode}',
        inputMode: SegmentInputMode.selectOnly,
        popupType: SegmentPopupType.searchGrid,
        validationMode: SegmentValidationMode.fixedLength,
        fixedLength: 3,
        required: true,
        dataSourceCode: 'branches',
        displayStrategyCode: 'codeName',
      ),
      CompositeCodeSegmentDefinition(
        segmentKey: 'sequence',
        label: 'Sequence',
        token: '{SEQ}',
        inputMode: SegmentInputMode.inputOnly,
        popupType: SegmentPopupType.none,
        validationMode: SegmentValidationMode.regexAndFixedLength,
        fixedLength: 6,
        regexPattern: r'^\d{6}$',
        required: true,
      ),
    ],
  );

  static const _noSeparatorDefinition = CompositeCodePatternDefinition(
    pattern: '{CompanyCode}{BranchCode}{YYYY}{SEQ}',
    separator: null,
    segments: [
      CompositeCodeSegmentDefinition(
        segmentKey: 'companyCode',
        label: 'Company',
        token: '{CompanyCode}',
        inputMode: SegmentInputMode.selectOnly,
        popupType: SegmentPopupType.list,
        validationMode: SegmentValidationMode.fixedLength,
        fixedLength: 3,
        required: true,
        dataSourceCode: 'companies',
        displayStrategyCode: 'codeName',
      ),
      CompositeCodeSegmentDefinition(
        segmentKey: 'branchCode',
        label: 'Branch',
        token: '{BranchCode}',
        inputMode: SegmentInputMode.selectOnly,
        popupType: SegmentPopupType.searchGrid,
        validationMode: SegmentValidationMode.fixedLength,
        fixedLength: 3,
        required: true,
        dataSourceCode: 'branches',
        displayStrategyCode: 'codeName',
      ),
      CompositeCodeSegmentDefinition(
        segmentKey: 'year',
        label: 'Year',
        token: '{YYYY}',
        inputMode: SegmentInputMode.autoGenerated,
        popupType: SegmentPopupType.none,
        validationMode: SegmentValidationMode.fixedLength,
        fixedLength: 4,
        required: true,
      ),
      CompositeCodeSegmentDefinition(
        segmentKey: 'sequence',
        label: 'Sequence',
        token: '{SEQ}',
        inputMode: SegmentInputMode.inputOnly,
        popupType: SegmentPopupType.none,
        validationMode: SegmentValidationMode.regexAndFixedLength,
        fixedLength: 6,
        regexPattern: r'^\d{6}$',
        required: true,
      ),
    ],
  );

  static final Map<String, SegmentDataSourceStrategy> _staticDataSources = {
    'companies': StaticListDataSourceStrategy({
      'companies': const [
        SegmentLookupItem(
          id: '1',
          code: 'BIS',
          name: 'Business Information Systems',
        ),
        SegmentLookupItem(id: '2', code: 'FAR', name: 'Fixed Asset Register'),
      ],
      'branches': const [
        SegmentLookupItem(id: '1', code: 'YGN', name: 'Yangon'),
        SegmentLookupItem(id: '2', code: 'MDY', name: 'Mandalay'),
        SegmentLookupItem(id: '3', code: 'NPW', name: 'Naypyitaw'),
      ],
      'categories': const [
        SegmentLookupItem(id: '1', code: 'EQP', name: 'Equipment'),
        SegmentLookupItem(id: '2', code: 'VEH', name: 'Vehicle'),
        SegmentLookupItem(id: '3', code: 'BLD', name: 'Building'),
      ],
    }),
  };

  static final Map<String, DisplayStrategy> _displayStrategies = {
    'codeOnly': CodeOnlyDisplayStrategy(),
    'codeName': CodeNameDisplayStrategy(),
  };
}
