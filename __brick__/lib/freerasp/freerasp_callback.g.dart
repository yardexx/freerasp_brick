// GENERATED FILE
// Generated using mason
// mason • lay the foundation!

part of 'freerasp.g.dart';

final callback = TalsecCallback({{#android}}
  androidCallback: AndroidCallback(
    onRootDetected: () => print('root'),
    onEmulatorDetected: () => print('emulator'),
    onHookDetected: () => print('hook'),
    onTamperDetected: () => print('tamper'),
    onDeviceBindingDetected: () => print('device binding'),
    onUntrustedInstallationDetected: () => print('untrusted install'),
  ), {{/android}} {{#ios}}
  iosCallback: IOSCallback(
      onSignatureDetected: () => print('signature'),
      onRuntimeManipulationDetected: () => print('runtime manipulation'),
      onJailbreakDetected: () => print('jailbreak'),
      onPasscodeDetected: () => print('passcode'),
      onSimulatorDetected: () => print('simulator'),
      onMissingSecureEnclaveDetected: () => print('secure enclave'),
      onDeviceChangeDetected: () => print('device change'),
      onDeviceIdDetected: () => print('device ID'),
      onUnofficialStoreDetected: () => print('unofficial store')), {{/ios}}
  onDebuggerDetected: () => print('debugger'),
);
