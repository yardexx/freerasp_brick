class FreeRaspBrickException implements Exception {
  const FreeRaspBrickException({
    this.code = 'brick-failure',
    this.message,
    this.stackTrace,
  });

  factory FreeRaspBrickException.wtf({
    StackTrace? stackTrace,
    String? message,
  }) {
    return FreeRaspBrickException(
      message: message ?? 'Unexpected error occurred.',
      stackTrace: stackTrace,
    );
  }

  factory FreeRaspBrickException.gradleUpdateFailure({
    String? message,
    StackTrace? stackTrace,
  }) {
    return FreeRaspBrickException(
      code: 'gradle-failure',
      message: message ?? 'Issue occurred during update of gradle file.',
      stackTrace: stackTrace,
    );
  }

  factory FreeRaspBrickException.schemeUpdateFailure({
    String? message,
    StackTrace? stackTrace,
  }) {
    return FreeRaspBrickException(
      code: 'xcscheme-failure',
      message:
          message ?? 'Issue occurred during update of Runner.xcscheme file.',
      stackTrace: stackTrace,
    );
  }

  final String code;
  final String? message;
  final StackTrace? stackTrace;
}
