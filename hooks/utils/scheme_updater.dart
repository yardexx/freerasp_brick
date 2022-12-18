import 'package:file/file.dart';
import 'package:file/local.dart';

import '../errors/errors.dart';

/// A class which adds Talsec pre-build script phase to Xcode project.
///
/// [SchemeUpdater] takes [String] path to Runner.xcscheme file which is then
/// parsed and checked, then checks for "PreActions" and/or "BuildActionEntries"
/// keys and inserts Talsec pre-build script phase.
///
/// If any issues occurs, [FreeRaspBrickException] is thrown.
class SchemeUpdater {
  const SchemeUpdater._();

  static const _shellScript = r'''
         <ExecutionAction
            ActionType = "Xcode.IDEStandardExecutionActionsCore.ExecutionActionType.ShellScriptAction">
            <ActionContent
               title = "Run Script"
               scriptText = "cd &quot;${SRCROOT}/.symlinks/plugins/talsec/ios&quot;&#10;if [ &quot;${CONFIGURATION}&quot; = &quot;Release&quot; ]; then&#10;    rm -rf ./TalsecRuntime.xcframework&#10;    ln -s ./Release/TalsecRuntime.xcframework/ TalsecRuntime.xcframework&#10;else&#10;    rm -rf ./TalsecRuntime.xcframework&#10;    ln -s ./Debug/TalsecRuntime.xcframework/ TalsecRuntime.xcframework&#10;fi&#10;">
               <EnvironmentBuildable>
                  <BuildableReference
                     BuildableIdentifier = "primary"
                     BlueprintIdentifier = "97C146ED1CF9000F007C117D"
                     BuildableName = "Runner.app"
                     BlueprintName = "Runner"
                     ReferencedContainer = "container:Runner.xcodeproj">
                  </BuildableReference>
               </EnvironmentBuildable>
            </ActionContent>
         </ExecutionAction>''';

  static const _preActionsTag = '''
      <PreActions>
      </PreActions>''';

  /// Updated xcscheme file at given [path].
  ///
  /// Be aware that this method doesn't check if pre-build script phase is
  /// already present.
  ///
  /// Returns true if Talsec pre-build script phase was added, false otherwise.
  static bool update(String path, [FileSystem fs = const LocalFileSystem()]) {
    try {
      _updateFile(fs.file(path));
    } catch (e) {
      return false;
    }
    return true;
  }

  static void _updateFile(File schemeFile) {
    return _addScript(schemeFile);
  }

  /// Adds Talsec pre-build script phase to given [schemeFile].
  ///
  /// If [schemeFile] doesn't contain "PreActions" tag, it is added. If adding
  /// "PreActions" tag fails, [FreeRaspBrickException] is thrown.
  ///
  /// Throws [FreeRaspBrickException] if any issues occurs.
  static void _addScript(File schemeFile) {
    _checkForPreActions(schemeFile);

    final lines = schemeFile.readAsLinesSync();

    var index = -1;
    for (final value in lines) {
      if (value.contains('<PreActions>')) {
        index = lines.indexOf(value);
      }
    }

    lines.insert(index + 1, _shellScript);
    schemeFile.writeAsStringSync(lines.join('\n'));
  }

  /// Checks if [schemeFile] contains "PreActions" tag.
  ///
  /// If not, it is added.
  ///
  /// Throws [FreeRaspBrickException] if any issues occurs.
  static void _checkForPreActions(File schemeFile) {
    final lines = schemeFile.readAsLinesSync();

    var index = -1;
    for (final value in lines) {
      if (value.contains('<PreActions>')) {
        return;
      }

      if (value.contains('<BuildActionEntries>')) {
        index = lines.indexOf(value);
        break;
      }
    }

    if (index == -1) {
      throw FreeRaspBrickException.schemeUpdateFailure(
        message: 'Unable to find <BuildActionEntries> tag.',
      );
    }

    lines.insert(index, _preActionsTag);
    schemeFile.writeAsStringSync(lines.join('\n'));
  }
}
