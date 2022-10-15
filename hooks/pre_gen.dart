import 'package:mason/mason.dart';

const defaultAppPackage = 'com.example.app';

void run(HookContext context) {
  final isAndroid = context.vars['android'];
  final isIOS = context.vars['ios'];

  if (isAndroid) parseAndroidData(context);

  if (isIOS) parseCupertinoData(context);
}

void parseCupertinoData(HookContext context) {
  final logger = context.logger;

  final bundleId =
      logger.prompt("What's app bundle ID?", defaultValue: defaultAppPackage);
  final teamId =
      logger.prompt("What's app team ID?", defaultValue: defaultAppPackage);

  context.vars.addAll({
    'bundle_id': bundleId,
    'team_id': teamId,
  });
}

void parseAndroidData(HookContext context) {
  final logger = context.logger;

  final packageName = logger.prompt("What's app package name?",
      defaultValue: defaultAppPackage);
  final signingHash = logger.prompt("What's app singing hash?");

  context.vars.addAll({
    'package_name': packageName,
    'signing_hash': signingHash,
  });
}
