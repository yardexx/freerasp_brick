// GENERATED FILE
// Generated using mason
// mason • lay the foundation!

import 'package:freerasp/talsec_app.dart';
part 'freerasp_callback.g.dart';

TalsecConfig _config = TalsecConfig(
  watcherMail: '{{watcher_mail}}',{{#android}}
  androidConfig: AndroidConfig(
    expectedPackageName: '{{package_name}}',
    expectedSigningCertificateHashes: {{{signing_hashes}}},
  ),{{/android}}{{#ios}}
  iosConfig: IOSconfig(
    appBundleId: '{{bundle_id}}',
    appTeamId: '{{team_id}}',
  ),{{/ios}}
);

TalsecApp talsec = TalsecApp(
  config: _config,
  callback: callback,
);
