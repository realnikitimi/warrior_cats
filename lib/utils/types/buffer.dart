import 'dart:typed_data';

class Buffer {
  late String type;
  late Uint8List uintArray;

  Buffer(this.type, this.uintArray);

  factory Buffer.decode(type, uintArray) {
    if (type.runtimeType != String) {
      throw Error.safeToString('Type is not a valid string.');
    }
    if (uintArray.runtimeType == List<dynamic>) {
      return Buffer(
        type,
        Uint8List.fromList(List.castFrom<dynamic, int>(uintArray)),
      );
    }
    return Buffer(type, uintArray);
  }

  @override
  String toString() {
    return '`$type` with ${uintArray.toString()}';
  }
}
