import 'package:file/file.dart';
import 'package:file/memory.dart';
import 'package:test/test.dart';

import '../../errors/errors.dart';
import '../../utils/utils.dart';
import '../test_inputs/gradle_files/gradle_files.dart';

void main() {
  group('GradleUpdater.update', () {
    late FileSystem mockFileSystem;

    group('Valid inputs', () {
      setUpAll(() {
        mockFileSystem = MemoryFileSystem();

        mockFileSystem
            .file('value_build.gradle')
            .writeAsStringSync(valueBuildGradle);

        mockFileSystem
            .file('variable_build.gradle')
            .writeAsStringSync(variableBuildGradle);

        mockFileSystem
            .file('supported_build.gradle')
            .writeAsStringSync(supportedBuildGradle);
      });

      test(
          'Should update SDK version when value is "flutter.minSdkVersion" '
          '(API 16)', () {
        expect(
          GradleUpdater.update('variable_build.gradle', mockFileSystem),
          isTrue,
        );

        final updatedLevel = mockFileSystem
            .file('variable_build.gradle')
            .readAsLinesSync()
            .firstWhere((line) => line.contains('minSdkVersion'))
            .split(' ')
            .last;

        expect(
          updatedLevel,
          equals(GradleUpdater.minSupportedVersion.toString()),
        );
      });

      test(
          'Should update SDK version when value is lower than currently '
          'supported', () {
        expect(
          GradleUpdater.update('value_build.gradle', mockFileSystem),
          true,
        );

        final updatedLevel = mockFileSystem
            .file('value_build.gradle')
            .readAsLinesSync()
            .firstWhere((line) => line.contains('minSdkVersion'))
            .split(' ')
            .last;

        expect(
          updatedLevel,
          equals(GradleUpdater.minSupportedVersion.toString()),
        );
      });

      test(
          'Should NOT update SDK version when value is equal or higher than '
          'currently supported', () {
        expect(
          GradleUpdater.update('supported_build.gradle', mockFileSystem),
          false,
        );

        final updatedLevel = mockFileSystem
            .file('supported_build.gradle')
            .readAsLinesSync()
            .firstWhere((line) => line.contains('minSdkVersion'))
            .split(' ')
            .last;

        expect(updatedLevel, equals('32'));
      });
    });

    group('Invalid inputs', () {
      setUpAll(() {
        mockFileSystem = MemoryFileSystem();

        mockFileSystem
            .file('missing_key.gradle')
            .writeAsStringSync(missingKeyGradle);

        mockFileSystem
            .file('missing_value.gradle')
            .writeAsStringSync(missingValueGradle);
      });

      test(
        'Should throw Exception when invalid path is provided',
        () {
          expect(
            () => GradleUpdater.update('invalid_path', mockFileSystem),
            throwsA(isA<FreeRaspBrickException>()),
          );
        },
      );

      test(
        'Should throw Exception when gradle file does not contain '
        'minSdkVersion key',
        () {
          expect(
            () => GradleUpdater.update('missing_key.gradle', mockFileSystem),
            throwsA(isA<FreeRaspBrickException>()),
          );
        },
      );

      test(
          'Should throw Exception when gradle file does not contain value of '
          'minSdkVersion key', () {
        expect(
          () => GradleUpdater.update('missing_value.gradle', mockFileSystem),
          throwsA(isA<FreeRaspBrickException>()),
        );
      });
    });
  });
}
