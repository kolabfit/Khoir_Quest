import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

Future<String> applicationSupportPath() async {
  final dir = await getApplicationSupportDirectory();
  return dir.path;
}

Future<void> ensureDirectory(String path) async {
  await Directory(path).create(recursive: true);
}

Future<void> writeFileBytes(
  String path,
  Uint8List bytes, {
  bool flush = false,
}) async {
  await File(path).writeAsBytes(bytes, flush: flush);
}

Future<bool> fileExists(String path) => File(path).exists();

Future<int> fileLength(String path) => File(path).length();

Future<Uint8List> readFileBytes(String path) => File(path).readAsBytes();

Future<void> deleteFileIfExists(String path) async {
  final file = File(path);
  if (await file.exists()) {
    await file.delete();
  }
}
