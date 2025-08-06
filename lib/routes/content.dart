import 'dart:convert' show base64Decode, jsonDecode, jsonEncode;
import 'dart:io';
import 'dart:typed_data' show ByteBuffer, Uint8List;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:warrior_cats/buffer.dart';
import 'package:warrior_cats/file_storage.dart';
import 'package:warrior_cats/futures.dart';

class Content extends StatefulWidget {
  const Content({super.key, required this.fileStorage});
  final imageDimension = 128.0;
  final FileStorage fileStorage;

  @override
  State<Content> createState() => _ContentState();
}

class _ContentState extends State<Content> {
  final futures = Futures();
  Future<List<Buffer>>? frameListBuffer;
  String? id;
  int? selectedIndex;
  PlatformFile? selectedImageToJSON;

  @override
  void initState() {
    frameListBuffer = futures.frameList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futures.initializeRenderApp(),
      builder: (context, snapshot) {
        Color sharedColor =
            (selectedImageToJSON == null || selectedIndex == null)
            ? Colors.grey
            : Colors.black;
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          spacing: 12,
          children: [
            MaterialButton(
              onPressed: () async {
                var map = await widget.fileStorage.openGallery();
                if (map['platformFile'] == null) return;
                setState(() {
                  selectedImageToJSON = map['platformFile'];
                });
              },
              child: Text(
                selectedImageToJSON == null
                    ? 'Please select a file.'
                    : selectedImageToJSON!.name,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selectedIndex == null
                      ? 'Please select a avatar frame.'
                      : 'Press submit to continue.',
                ),
                SizedBox(
                  height: widget.imageDimension,
                  width: widget.imageDimension * 3,
                  child: snapshot.connectionState == ConnectionState.done
                      ? ColoredBox(
                          color: Color.fromARGB(20, 58, 91, 255),
                          child: _frameList(),
                        )
                      : Text('Loading...'),
                ),
              ],
            ),
            OutlinedButton(
              onPressed: () async {
                if (selectedImageToJSON == null) return;
                if (selectedIndex == null) return;
                await futures.changeFrame(selectedIndex!);
                await futures.postImage(
                  File.fromUri(Uri.parse(selectedImageToJSON!.path!)),
                  'image/${selectedImageToJSON!.extension}',
                  onDataCallback,
                );

                var response = await futures.getImage(id);
                var uInt8List = base64Decode(jsonDecode(response)['buffer']);
                var result = await FilePicker.platform.saveFile(
                  bytes: uInt8List,
                  type: FileType.image,
                  fileName: 'output',
                );
                debugPrint(result);
              },
              style: ButtonStyle(
                side: WidgetStatePropertyAll(BorderSide(color: sharedColor)),
              ),
              child: Text('Submit', style: TextStyle(color: sharedColor)),
            ),
            Text(''),
          ],
        );
      },
    );
  }

  FutureBuilder _frameList() {
    return FutureBuilder(
      future: frameListBuffer,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (!snapshot.hasData) return Text('No frame list.');
            var bufferList = (snapshot.data as List<Buffer>);
            return ListView.builder(
              itemCount: bufferList.length,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.all(12),
              itemBuilder: (_, index) {
                Buffer buffer = bufferList[index];
                var image = Image.memory(buffer.uintArray);
                return MaterialButton(
                  color: selectedIndex == index ? Colors.greenAccent : null,
                  onPressed: () => setState(() => selectedIndex = index),
                  child: Image(image: image.image),
                );
              },
            );
          case ConnectionState.active:
            return Text('framelist: Active connection');
          case ConnectionState.none:
            return Text('framelist: No connection.');
          default:
            return Text('framelist: Loading...');
        }
      },
    );
  }

  void onDataCallback(String? value) async {
    if (value == null) return debugPrint('Id is null');
    setState(() {
      id = jsonDecode(value)['id'];
    });
  }
}
