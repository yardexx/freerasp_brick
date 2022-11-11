/// Extension to simplify work with String lists.
extension ListX on List<String> {

  /// Returns index of first matched [String] in [List].
  ///
  /// Throws IterableElementError.noElement() if given [String] cannot be
  /// matched with any [String] in the [List].
  int firstMatchIndex(String value) {
    return indexOf(firstWhere((line) => line.contains(value)));
  }

  /// Replaces matched values with values from [values] map.
  ///
  /// Map [values] matches key and first occurrence is replaced with value
  /// associated with this key.
  ///
  /// Throws IterableElementError.noElement() if given [String] cannot be
  /// matched with any [String] in the [List].
  void replaceValues(Map<String, String> values) {
    values.forEach((key, value) {
      final line = firstWhere((element) => element.contains(key));
      final newLine = _replaceValue(line, value);
      this[(firstMatchIndex(key))] = newLine;
    });
  }

  String _replaceValue(String line, String value) {
    return line.replaceFirstMapped(line.trim().split(' ').last, (_) => value);
  }
}

/// Extension to simplify work with [String].
extension StringX on String {
  /// Converts [String] to [int].
  ///
  /// Equivalent of calling [int.parse].
  ///
  /// Throws [FormatException] (from [int.parse]) when instance cannot be
  /// converted.
  int toInt(){
    return int.parse(this);
  }
}
