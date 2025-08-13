import 'dart:async';
import 'dart:convert' show jsonDecode, jsonEncode, utf8;
import 'dart:io';
import 'dart:typed_data';

import 'package:http_parser/http_parser.dart' show MediaType;
import 'package:flutter/material.dart' show debugPrint;
import 'package:http/http.dart' as http;
import 'package:warrior_cats/buffer.dart';
import 'package:warrior_cats/endpoints.dart';

final origin = 'https://automate-avatar-frame.onrender.com';

class Futures {
  final endpoint = Endpoints.from(origin);

  Future<void> initializeRenderApp() async {
    var uri = Uri.parse(origin);
    final response = await http.get(uri);
    bool isStatusOk = response.statusCode <= 200;

    if (!isStatusOk) {
      debugPrint('Failed to initialize render application.');
    } else {
      debugPrint('Successfully initialized render application.');
    }
  }

  Future<List<Buffer>> frameList() async {
    var uri = Uri.parse(endpoint.frameList());
    final response = await http.get(uri);
    bool isStatusOk = response.statusCode == 200;

    if (!isStatusOk) {
      return <Buffer>[];
    }

    List<dynamic> entries = jsonDecode(response.body);
    final bufferMap = entries.map(
      (entry) => Buffer.decode(entry['type'], entry['data']),
    );

    return bufferMap.toList();
  }

  Future<void> changeFrame(int index) async {
    final body = jsonEncode({"index": '$index'});
    final response = await http.post(
      Uri.parse(endpoint.changeFrame()),
      body: body,
      headers: {"content-type": "application/json"},
    );
    debugPrint('ChangeFrame: ${response.body}');
    debugPrint(body);
  }

  Future<void> postImage(
    File img,
    String mimeType,
    Function(String?) onDataCallback,
  ) async {
    var mimeTypeSplit = mimeType.split('/');
    var request = http.MultipartRequest(
      "POST",
      Uri.parse(endpoint.outputFile()),
    );
    request.files.add(
      http.MultipartFile.fromBytes(
        "image",
        img.readAsBytesSync(),
        filename: "Photo.jpg",
        contentType: MediaType(mimeTypeSplit[0], mimeTypeSplit[1]),
      ),
    );

    final response = await request.send();
    debugPrint('PostImage: ${response.statusCode}');
    response.stream.transform(utf8.decoder).listen(onDataCallback);
  }

  Future<Uint8List> getImage(String? id) async {
    final uri = Uri.parse('${endpoint.outputFile()}?id=$id');
    final response = await http.get(uri);
    final fileKey = jsonDecode(response.body)['key'];
    final fileResponse = await http.get(
      Uri.parse('https://utfs.io/f/$fileKey'),
    );
    return fileResponse.bodyBytes;
  }
}
