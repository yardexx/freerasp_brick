// coverage:ignore-file
import 'package:mason/mason.dart';

import 'extensions.dart';

const defaultAppPackage = 'com.example.app';

void run(HookContext context) {
  final isAndroid = context.vars['android'] as bool;
  final isIOS = context.vars['ios'] as bool;

  if (isAndroid) parseAndroidData(context);

  if (isIOS) parseCupertinoData(context);
}

void parseCupertinoData(HookContext context) {
  final logger = context.logger;

  final bundleId = logger.masonPrompt(
    "What's app bundle ID?",
    defaultValue: defaultAppPackage,
  );

  final teamId = logger.masonPrompt(
    "What's app team ID?",
    defaultValue: defaultAppPackage,
  );

  final updateScheme = logger.masonConfirm(
    'Do you want to update Runner.xcscheme? (Experimental)',
    defaultValue: true,
  );

  context.vars.addAll({
    'bundle_id': bundleId,
    'team_id': teamId,
    'update_scheme': updateScheme,
  });
}

void parseAndroidData(HookContext context) {
  final logger = context.logger;

  final packageName = logger.masonPrompt(
    "What's app package name?",
    defaultValue: defaultAppPackage,
  );

  final signingHashes =
      logger.masonPrompt('What are app singing hashes?').toListString();

  final updateGradle = logger.masonConfirm(
    'Do you want to check and update API level (minSdkVersion)?',
    defaultValue: true,
  );

  context.vars.addAll({
    'package_name': packageName,
    'signing_hashes': signingHashes,
    'update_gradle': updateGradle,
  });
}
