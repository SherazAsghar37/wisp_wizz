import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:wisp_wizz/features/app/constants/app_constants.dart';

class FileManager {
  static Future<void> createMediaFolder() async {
    final appDirectory = await getApplicationDocumentsDirectory();
    final appPath = appDirectory.path;

    final mediaPath = '$appPath/$appName/$mediaFolder';

    await Directory(appPath).create(recursive: true);
    await Directory(mediaPath).create(recursive: true);
  }

  static Future<void> createProfilePictureFolder() async {
    final appDirectory = await getApplicationDocumentsDirectory();
    final appPath = appDirectory.path;
    final mediaPath = '$appPath/$appName/$mediaFolder';
    final profilePicturesPath = '$mediaPath/$profilePicturesFolder';
    await Directory(profilePicturesPath).create(recursive: true);
  }

  static Future<String> saveProfilePicture(File file) async {
    final appDirectory = await getApplicationDocumentsDirectory();
    final appPath = appDirectory.path;
    final profilePicturesPath =
        '$appPath/$appName/$mediaFolder/$profilePicturesFolder';

    final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.png';
    final filePath = '$profilePicturesPath/$fileName';

    await file.copy(filePath);
    return filePath;
  }
}
