import 'reusable_search_box.dart';

enum SqlPlaceholderStyle { questionMark, postgresql, named }

class SearchSqlBuildResult {
  const SearchSqlBuildResult({
    required this.whereClause,
    required this.parameters,
  });

  final String whereClause;
  final Map<String, Object?> parameters;

  bool get hasWhereClause => whereClause.isNotEmpty;
}

class SearchSqlField {
  const SearchSqlField({required this.searchName, required this.columnName});

  final String searchName;
  final String columnName;
}

class SearchSqlBuilder {
  const SearchSqlBuilder({
    required this.fields,
    this.placeholderStyle = SqlPlaceholderStyle.named,
    this.caseInsensitive = true,
  });

  final List<SearchSqlField> fields;
  final SqlPlaceholderStyle placeholderStyle;
  final bool caseInsensitive;

  SearchSqlBuildResult build(SearchResult search) {
    if (search.text.trim().isEmpty) {
      return const SearchSqlBuildResult(whereClause: '', parameters: {});
    }

    if (search.hasPatterns) {
      return _buildPatternSearch(search.patterns);
    }

    return _buildFreeTextSearch(search.text);
  }

  SearchSqlBuildResult _buildPatternSearch(List<SearchPattern> patterns) {
    final groups = <List<String>>[];
    var currentGroup = <String>[];
    final parameters = <String, Object?>{};

    for (var index = 0; index < patterns.length; index++) {
      final pattern = patterns[index];
      final field = _fieldBySearchName(pattern.field);
      if (field == null) {
        continue;
      }

      final parameterName = 'p$index';
      final placeholder = _placeholder(parameterName, parameters.length + 1);
      final condition = _condition(field.columnName, placeholder);
      final operator = pattern.operatorBefore ?? SearchOperator.and;

      if (currentGroup.isEmpty || operator == SearchOperator.or) {
        currentGroup.add(condition);
      } else {
        groups.add(currentGroup);
        currentGroup = [condition];
      }
      parameters[parameterName] = _toSqlLikePattern(pattern.value);
    }

    if (currentGroup.isNotEmpty) {
      groups.add(currentGroup);
    }

    final parts = [
      for (final group in groups)
        group.length == 1 ? group.first : '(${group.join(' OR ')})',
    ];

    return SearchSqlBuildResult(
      whereClause: parts.isEmpty ? '' : parts.join(' AND '),
      parameters: parameters,
    );
  }

  SearchSqlBuildResult _buildFreeTextSearch(String text) {
    final parameters = <String, Object?>{};
    final parts = <String>[];

    for (var index = 0; index < fields.length; index++) {
      final field = fields[index];
      final parameterName = 'p$index';
      final placeholder = _placeholder(parameterName, index + 1);
      parts.add(_condition(field.columnName, placeholder));
      parameters[parameterName] = '%${_escapeLikeValue(text.trim())}%';
    }

    return SearchSqlBuildResult(
      whereClause: parts.isEmpty ? '' : '(${parts.join(' OR ')})',
      parameters: parameters,
    );
  }

  SearchSqlField? _fieldBySearchName(String searchName) {
    final normalizedSearchName = searchName.trim().toLowerCase();

    for (final field in fields) {
      if (field.searchName.trim().toLowerCase() == normalizedSearchName) {
        return field;
      }
    }

    return null;
  }

  String _condition(String columnName, String placeholder) {
    if (caseInsensitive) {
      return 'LOWER($columnName) LIKE LOWER($placeholder)';
    }

    return '$columnName LIKE $placeholder';
  }

  String _placeholder(String parameterName, int position) {
    switch (placeholderStyle) {
      case SqlPlaceholderStyle.questionMark:
        return '?';
      case SqlPlaceholderStyle.postgresql:
        return '\$$position';
      case SqlPlaceholderStyle.named:
        return ':$parameterName';
    }
  }

  String _toSqlLikePattern(String value) {
    return _escapeLikeValue(value.trim()).replaceAll('*', '%');
  }

  String _escapeLikeValue(String value) {
    return value.replaceAll(r'\', r'\\').replaceAll('_', r'\_');
  }
}
