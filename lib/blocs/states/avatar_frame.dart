import 'package:file_picker/file_picker.dart' show PlatformFile;
import 'package:warrior_cats/utils/file_storage.dart';
import 'package:warrior_cats/utils/types/buffer.dart' show Buffer;

class AvatarFrameState {
  int selectedIndex = -1;
  List<Buffer> frameListBuffer = [];
  final imageDimension = 128.0;

  set changeIndex(int index) => selectedIndex = index;
  set addFrames(List<Buffer> list) => frameListBuffer.addAll(list);
  void resetFrames() => frameListBuffer = [];

  @override
  String toString() {
    return '[INDEX:$selectedIndex\n[FRAME LIST BUFFER]:${frameListBuffer.join('_')}';
  }
}

class AvatarFrameWithFile extends AvatarFrameState {
  final FileStorage fileStorage = FileStorage();
  PlatformFile? selectedImageToJson;

  AvatarFrameWithFile({required this.selectedImageToJson}) : super();

  factory AvatarFrameWithFile.fromSelf(PlatformFile platformFile) {
    return AvatarFrameWithFile(selectedImageToJson: platformFile);
  }
}
