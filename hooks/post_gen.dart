import 'dart:io';

import 'package:mason/mason.dart';

const String androidBuild = 'build.gradle';
const String flutterBuild = 'lib';

void run(HookContext context) async {
  final logger = context.logger;

  await _runPub(logger);
  await _runDartFix(logger);
}

Future<void> _runPub(Logger logger) async {
  final progress = logger.progress('Running dart pub get');
  final result = await Process.run('dart', ['pub', 'get']);
  return result.exitCode == 0
      ? progress.complete('Pub get run successfully')
      : progress.fail('Pub get failed. Please handle dependency manually.');
}

Future<void> _runDartFix(Logger logger) async {
  final progress = logger.progress('Running dart fix --apply');
  final result = await Process.run('dart', ['fix', '--apply']);
  return result.exitCode == 0
      ? progress.complete('Fix applied.')
      : progress.fail('Fix couldn\'t be applied');
}
