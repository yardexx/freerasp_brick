// coverage:ignore-start
import 'dart:io';

import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:mason/mason.dart';

const String androidBuild = 'build.gradle';
const String flutterBuild = 'lib';
const int minSupportedVersion = 21;

Future<void> run(HookContext context) async {
  final logger = context.logger;

  await _runPubAdd(logger);
  await _runPubGet(logger);
  await _runDartFix(logger);
}

Future<void> _runPubAdd(Logger logger) async {
  final progress = logger.progress('Running dart pub add');
  final result = await Process.run('dart', ['pub', 'add', 'freerasp']);

  if (result.exitCode == 0) {
    return progress.complete('freeRASP dependency added successfully');
  }

  if ((result.stderr as String).contains('is already in "dependencies".')) {
    return progress.complete('freeRASP dependency found in pubspec.yaml');
  }

  return progress.fail(
    'Failed to add freeRASP dependency. Please handle it manually.',
  );
}

Future<void> _runPubGet(Logger logger) async {
  final progress = logger.progress('Running dart pub get');
  final result = await Process.run('dart', ['pub', 'get']);
  return result.exitCode == 0
      ? progress.complete('Dependencies fetched')
      : progress.fail('Pub get failed. Please handle dependency manually.');
}

Future<void> _runDartFix(Logger logger) async {
  final progress = logger.progress('Running dart fix --apply');
  final result = await Process.run('dart', ['fix', '--apply']);
  return result.exitCode == 0
      ? progress.complete('Fix applied.')
      : progress.fail("Fix couldn't be applied");
}

// coverage:ignore-end

// TODO(yardexx): Refactor when Mason adds support for relative imports.
// See https://github.com/felangel/mason/pull/622
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

// TODO(yardexx): Refactor when Mason adds support for relative imports.
// See https://github.com/felangel/mason/pull/622
/// Functional type of call
void gradleUpdate(String path) => GradleUpdater.update(path);

/// A class which checks current minimal version of SDK and updates it if
/// necessary.
///
/// [GradleUpdater] takes [String] path to gradle which is then parsed and
/// checked, then checks for "minSdkVersion" key and parses its value.
///
/// Rule of minimal possible level is applied - if current level is less than
/// [minSupportedVersion], then its updated to this version. If its equal or
/// more than level is kept.
///
/// If any issues occurs, [FreeRaspBrickException] is thrown.
class GradleUpdater {
  const GradleUpdater._();

  /// Updates gradle file at given [path].
  ///
  /// Throws [FreeRaspBrickException] if some issue occurs.
  static bool update(String path, [FileSystem fs = const LocalFileSystem()]) {
    try {
      return _updateFile(fs.file(path));
    } on FileSystemException {
      throw FreeRaspBrickException.wtf(
        message: 'Unable to find build.gradle file',
      );
    }
  }

  static bool _updateFile(File gradleFile) {
    final content = gradleFile.readAsStringSync();
    final updatedContent = _updateVersion(content);

    if (content != updatedContent) {
      gradleFile.writeAsStringSync(updatedContent);
    }

    return content != updatedContent;
  }

  static String _updateVersion(String content) {
    final version = RegExp(
      r'''minSdkVersion ([1-9]|1[0-9]|20|flutter.minSdkVersion)$''',
      multiLine: true,
    );

    if (!version.hasMatch(content)) {
      _checkForKey(content);
    }

    return content.replaceAll(version, 'minSdkVersion $minSupportedVersion');
  }

  static void _checkForKey(String content) {
    final supportedVersion = RegExp(
      r'''minSdkVersion (2[1-9]|3[0-9])$''',
      multiLine: true,
    );

    if (!supportedVersion.hasMatch(content)) {
      throw FreeRaspBrickException.gradleUpdateFailure();
    }
  }
}
