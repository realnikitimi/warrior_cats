import 'package:file_picker/file_picker.dart' show PlatformFile;
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:warrior_cats/blocs/events/avatar_frame.dart';
import 'package:warrior_cats/blocs/states/avatar_frame.dart';
import 'package:warrior_cats/utils/file_storage.dart';
import 'package:warrior_cats/utils/futures.dart';

class AvatarFrameBloc extends Bloc<AvatarFrameEvents, AvatarFrameWithFile> {
  final futures = Futures();

  AvatarFrameBloc() : super(AvatarFrameWithFile(selectedImageToJson: null)) {
    on<AvatarFrameSelectFromGallery>((event, emit) async {
      var map = await state.fileStorage.openGallery();
      if (map['platformFile'] == null) {
        return addError('Image cannot be selected.');
      }
      debugPrint('PATH => ${map['platformFile']?.path}');
      var newState =
          AvatarFrameWithFile.fromSelf(map['platformFile'] as PlatformFile)
            ..changeIndex = state.selectedIndex
            ..addFrames = state.frameListBuffer;
      emit(newState);
    });

    on<AvatarFrameSetFrames>((event, emit) async {
      final frameList = await futures.frameList();
      state.addFrames = frameList;
      emit(state);
    });
  }
}
