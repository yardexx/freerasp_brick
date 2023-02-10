// coverage:ignore-file
import 'package:mason/mason.dart';

extension LoggerX on Logger {
  String masonPrompt(
    String? message, {
    Object? defaultValue,
    bool hidden = false,
  }) {
    return prompt(
      '${green.wrap('?')} ${message ?? ''}',
      defaultValue: defaultValue,
      hidden: hidden,
    );
  }

  bool masonConfirm(
    String? message, {
    bool defaultValue = false,
  }) {
    return confirm(
      '${green.wrap('?')} ${message ?? ''}',
      defaultValue: defaultValue,
    );
  }
}

extension StringX on String {
  String toListString() {
    return split(',')
        .map((item) => item.trim())
        .map((item) => "'$item'")
        .toList()
        .toString();
  }
}
