class FreeRaspBrickException implements Exception {
  const FreeRaspBrickException({
    this.code = 'brick-failure',
    this.message,
    this.stackTrace,
  });

  factory FreeRaspBrickException.wtf({StackTrace? stackTrace}) {
    return FreeRaspBrickException(
      message: 'Unexpected error occurred.',
      stackTrace: stackTrace,
    );
  }

  factory FreeRaspBrickException.gradleUpdateFailure({StackTrace? stackTrace}) {
    return FreeRaspBrickException(
      code: 'gradle-failure',
      message: 'Issue occurred during update of gradle file.',
      stackTrace: stackTrace,
    );
  }

  final String code;
  final String? message;
  final StackTrace? stackTrace;
}
