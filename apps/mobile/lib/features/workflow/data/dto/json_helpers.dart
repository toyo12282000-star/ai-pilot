/// Supabase JSON レスポンスの共通パース処理。
DateTime parseTimestamp(dynamic value) {
  if (value is DateTime) {
    return value;
  }
  if (value is String) {
    return DateTime.parse(value);
  }
  throw FormatException('Invalid timestamp: $value');
}

List<String> parseStringList(dynamic value) {
  if (value == null) {
    return const [];
  }
  if (value is List) {
    return value.map((item) => item.toString()).toList();
  }
  return const [];
}

String? parseNullableString(dynamic value) {
  if (value == null) {
    return null;
  }
  return value.toString();
}

/// PostgREST ilike 用に `%` / `_` をエスケープする。
String escapeIlikePattern(String query) {
  return query
      .replaceAll(r'\', r'\\')
      .replaceAll('%', r'\%')
      .replaceAll('_', r'\_');
}
