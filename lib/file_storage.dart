import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class FileStorage {
  Future<Map<String, PlatformFile?>> openGallery() async {
    var fallback = {"platformFile": null};
    var permissionStatus = await Permission.manageExternalStorage.request();
    if (permissionStatus.isGranted) {
      try {
        var result = await FilePicker.platform.pickFiles(
          type: FileType.image,
          allowMultiple: false,
        );
        if (result == null) return fallback;
        var file = result.files[0];

        return {"platformFile": file};
      } catch (e) {
        debugPrint(e.toString());
      }
    }
    return fallback;
  }
}
