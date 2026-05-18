import 'dart:typed_data';

Future<String> applicationSupportPath() async {
  throw UnsupportedError('File system storage is not available on this platform.');
}

Future<void> ensureDirectory(String path) async {}

Future<void> writeFileBytes(
  String path,
  Uint8List bytes, {
  bool flush = false,
}) async {
  throw UnsupportedError('File writes are not available on this platform.');
}

Future<bool> fileExists(String path) async => false;

Future<int> fileLength(String path) async => 0;

Future<Uint8List> readFileBytes(String path) async {
  throw UnsupportedError('File reads are not available on this platform.');
}

Future<void> deleteFileIfExists(String path) async {}
