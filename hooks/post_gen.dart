// coverage:ignore-file
import 'dart:io';

import 'package:mason/mason.dart';

import 'utils/utils.dart';

const String androidBuild = 'build.gradle';
const String flutterBuild = 'lib';

Future<void> run(HookContext context) async {
  final logger = context.logger;
  final isAndroid = context.vars['android'] as bool;

  await _runPubAdd(logger);
  await _runPubGet(logger);
  await _runDartFix(logger);

  if (isAndroid) await _runGradleCheck(context);
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
      ? progress.complete('Fix applied')
      : progress.fail("Fix couldn't be applied");
}

Future<void> _runGradleCheck(HookContext context) async {
  final progress = context.logger.progress('Checking build.gradle file');

  if (!(context.vars['update_gradle'] as bool)) {
    progress.complete('Gradle check not required. Skipping...');
    return;
  }

  try {
    final hasUpdated = GradleUpdater.update('android/app/build.gradle');
    progress.complete(
      hasUpdated
          ? 'build.gradle successfully updated'
          : 'build.gradle already contains supported API level',
    );
  } catch (_) {
    progress.fail("Couldn't update build.gradle");
  }
}
