import 'package:file/file.dart';
import 'package:file/local.dart';

import '../errors/errors.dart';

class XcschemeUpdater {
  const XcschemeUpdater._();

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

  static bool update(String path, [FileSystem fs = const LocalFileSystem()]) {
    try {
      _updateFile(fs.file(path));
    } on FileSystemException {
      throw FreeRaspBrickException.wtf(
        message: 'Unable to find Runner.xcscheme file',
      );
    }
    return true;
  }

  static void _updateFile(File schemeFile) {
    return _addScript(schemeFile);
  }

  static void _addScript(File schemeFile) {
    _checkForPreActions(schemeFile);

    final lines = schemeFile.readAsLinesSync();

    var index = -1;
    for (final value in lines) {
      if (value.contains('<PreActions>')) {
        index = lines.indexOf(value);
      }
    }

    if (index == -1) {
      throw FreeRaspBrickException.schemeUpdateFailure(
        message: 'Unable to find <PreActions> tag',
      );
    }

    lines.insert(index + 1, _shellScript);
    schemeFile.writeAsStringSync(lines.join('\n'));
  }

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

bool xcschemeUpdate(String path) => XcschemeUpdater.update(path);
