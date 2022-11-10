import 'dart:io';

import 'package:mason/mason.dart';

const String androidBuild = 'build.gradle';
const String flutterBuild = 'lib';

class B {
  static bool foo(bool a){
    if (a){
      return a;
    }
    return !a;
  }
}

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
