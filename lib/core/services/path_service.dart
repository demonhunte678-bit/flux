import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class PathService {
  static Future<Directory> getAppSupportDirectory() async {
    if (Platform.isWindows) {
      final appData = Platform.environment['APPDATA'];
      if (appData != null) {
        final dir = Directory(p.join(appData, 'dev.wisamidris77', 'flux'));
        if (!await dir.exists()) {
          await dir.create(recursive: true);
        }
        return dir;
      }
    }
    return await getApplicationSupportDirectory();
  }

  static Future<File> getSharedPrefsFile() async {
    final supportDir = await getAppSupportDirectory();
    return File(p.join(supportDir.path, 'shared_prefs.json'));
  }
}
