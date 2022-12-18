import 'package:file/file.dart';
import 'package:file/memory.dart';
import 'package:test/test.dart';

import '../../utils/utils.dart';
import '../test_inputs/xcscheme_files/xcscheme_files.dart';

void main() {
  const scriptText =
      r'''scriptText = "cd &quot;${SRCROOT}/.symlinks/plugins/talsec/ios&quot;&#10;if [ &quot;${CONFIGURATION}&quot; = &quot;Release&quot; ]; then&#10;    rm -rf ./TalsecRuntime.xcframework&#10;    ln -s ./Release/TalsecRuntime.xcframework/ TalsecRuntime.xcframework&#10;else&#10;    rm -rf ./TalsecRuntime.xcframework&#10;    ln -s ./Debug/TalsecRuntime.xcframework/ TalsecRuntime.xcframework&#10;fi&#10;">''';

  group('SchemeUpdater.update', () {
    late FileSystem mockFileSystem;

    group('Valid inputs', () {
      setUpAll(() {
        mockFileSystem = MemoryFileSystem();

        mockFileSystem
            .file('preactions.xcscheme')
            .writeAsStringSync(containsPreActions);

        mockFileSystem
            .file('missing_preactions.xcscheme')
            .writeAsStringSync(missingPreActions);
      });

      test('Should insert build script when scheme contains no preactions', () {
        expect(
          SchemeUpdater.update('missing_preactions.xcscheme', mockFileSystem),
          isTrue,
        );

        final lines = mockFileSystem
            .file('missing_preactions.xcscheme')
            .readAsLinesSync();

        var found = false;
        for (final line in lines) {
          if (line.contains(scriptText)) {
            found = true;
            break;
          }
        }

        expect(found, isTrue);
      });

      test('Should insert build script when scheme contains some preactions',
          () {
        expect(
          SchemeUpdater.update('preactions.xcscheme', mockFileSystem),
          isTrue,
        );

        final lines =
            mockFileSystem.file('preactions.xcscheme').readAsLinesSync();

        var found = false;
        for (final line in lines) {
          if (line.contains(scriptText)) {
            found = true;
            break;
          }
        }

        expect(found, isTrue);
      });
    });

    group('Invalid inputs', () {
      setUpAll(() {
        mockFileSystem = MemoryFileSystem();

        mockFileSystem
            .file('missing_build.xcscheme')
            .writeAsStringSync(missingBuildActionEntries);
      });

      test('Should return false when scheme contains no build action entries',
          () {
        expect(
          SchemeUpdater.update('missing_build.xcscheme', mockFileSystem),
          isFalse,
        );
      });
    });
  });
}
