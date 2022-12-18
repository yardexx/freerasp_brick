import 'package:file/file.dart';
import 'package:file/local.dart';

import '../errors/errors.dart';

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

  static const int minSupportedVersion = 21;

  /// Updates gradle file at given [path].
  ///
  /// Throws [FreeRaspBrickException] if some issue occurs.
  static bool update(String path, [FileSystem fs = const LocalFileSystem()]) {
    try {
      return _updateFile(fs.file(path));
    } on FileSystemException {
      throw FreeRaspBrickException.wtf(
        message: 'Unable to find build.gradle file',
      );
    }
  }

  /// Reads from [gradleFile], checks whether file needs to be updated and
  /// writes new content if needed.
  ///
  /// Returns bool if file was updated.
  static bool _updateFile(File gradleFile) {
    final content = gradleFile.readAsStringSync();
    final updatedContent = _updateVersion(content);

    if (content != updatedContent) {
      gradleFile.writeAsStringSync(updatedContent);
    }

    return content != updatedContent;
  }

  /// Matches given [content] with regular expression and replaces its content
  /// if matched.
  ///
  /// [content] is matched when **unsupported** API level is detected and
  /// is replaced with [minSupportedVersion] API level.
  ///
  /// If content is not matched, [_checkForKey] is called.
  ///
  /// Returns content which could be altered.
  static String _updateVersion(String content) {
    final version = RegExp(
      r'''minSdkVersion ([1-9]|1[0-9]|20|flutter.minSdkVersion)$''',
      multiLine: true,
    );

    if (!version.hasMatch(content)) {
      _checkForKey(content);
    }

    return content.replaceAll(version, 'minSdkVersion $minSupportedVersion');
  }

  /// Checks whether [content] contains **supported** API level.
  ///
  /// Returns void when supported API level matched.
  ///
  /// Throws [FreeRaspBrickException.gradleUpdateFailure] when cannot be matched
  /// (e.g. file contains garbage, missing key, invalid API value).
  static void _checkForKey(String content) {
    final supportedVersion = RegExp(
      r'''minSdkVersion (2[1-9]|3[0-9])$''',
      multiLine: true,
    );

    if (!supportedVersion.hasMatch(content)) {
      throw FreeRaspBrickException.gradleUpdateFailure();
    }
  }
}
