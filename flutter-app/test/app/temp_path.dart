import 'dart:io';
import 'package:flutter/services.dart';
import "package:path/path.dart" as p;

final tempFile = File(p.absolute("images\\profile.png"));
Future<Uint8List> loadImage() async {
  ByteData byteData = await rootBundle.load("images/profile.png");
  return byteData.buffer.asUint8List();
}
