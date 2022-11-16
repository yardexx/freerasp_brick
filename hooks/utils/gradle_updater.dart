import 'package:file/file.dart';
import 'package:file/local.dart';

import '../errors/errors.dart';
import '../extensions.dart';

/// Functional type of call
void gradleUpdate(String path) => GradleUpdater.update(path);

/// A class which checks current minimal version of SDK and updates it if
/// necessary.
///
/// [GradleUpdater] takes [String] path to gradle which is then parsed and
/// checked, then checks for "minSdkVersion" key and parses its value.
///
/// Rule of minimal possible level is applied - if current level is less than
/// [minSupportedVersion], then its updated to this version. If its equal or
/// more than level is kept.
///
/// If any issues occurs, [FreeRaspBrickException] is thrown.
class GradleUpdater {
  const GradleUpdater._();

  static int get minSupportedVersion => 21;

  /// Updates gradle file at given [path].
  ///
  /// Throws [FreeRaspBrickException] if some issue occurs.
  static void update(String path, [FileSystem fs = const LocalFileSystem()]) {
    try {
      _updateFile(fs.file(path));
    }
    // TODO(yardexx): Fix: Shouldn't play pokemon here.
    // Rethrow everything as BrickException
    catch (_) {
      throw FreeRaspBrickException.gradleUpdateFailure(
        stackTrace: StackTrace.current,
      );
    }
  }

  static void _updateFile(File gradleFile) {
    final lines = gradleFile.readAsLinesSync();

    if (!hasSupportedVersion(lines)) {
      lines.replaceValues({'minSdkVersion': '$minSupportedVersion'});
      gradleFile.writeAsStringSync(lines.join('\n'));
    }
  }

  /// Checks whether "minSdkVersion" has version which is at least equal
  /// to [minSupportedVersion].
  ///
  /// Throws [FreeRaspBrickException] if some issue occurs.
  static bool hasSupportedVersion(List<String> lines) {
    final version = lines
        .firstWhere((line) => line.contains('minSdkVersion'))
        .split(' ')
        .last;

    try {
      return version.toInt() >= minSupportedVersion;
    } on FormatException {
      // Special case of API 16
      if (version == 'flutter.minSdkVersion') {
        return false;
      }
      rethrow;
    }
  }
}
