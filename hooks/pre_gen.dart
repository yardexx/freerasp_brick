import 'package:mason/mason.dart';

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

  context.vars.addAll({
    'bundle_id': bundleId,
    'team_id': teamId,
  });
}

void parseAndroidData(HookContext context) {
  final logger = context.logger;

  final packageName = logger.masonPrompt(
    "What's app package name?",
    defaultValue: defaultAppPackage,
  );

  final signingHash = logger.masonPrompt("What's app singing hash?");

  context.vars.addAll({
    'package_name': packageName,
    'signing_hash': signingHash,
  });
}

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
}
