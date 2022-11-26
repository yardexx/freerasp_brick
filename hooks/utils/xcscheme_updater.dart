import 'package:file/file.dart';
import 'package:file/local.dart';

import '../errors/errors.dart';

class XcschemeUpdater {
  const XcschemeUpdater._();

  static bool update(String path, [FileSystem fs = const LocalFileSystem()]){
    try {
      return _updateFile(fs.file(path));
    } on FileSystemException {
      throw FreeRaspBrickException.wtf(
        message: 'Unable to find Runner.xcscheme file',
      );
    }
  }

  static bool _updateFile(File schemeFile) {
    return _addScript(schemeFile.readAsStringSync());
  }

  static bool _addScript(String xml){
    throw UnimplementedError();
  }
}
