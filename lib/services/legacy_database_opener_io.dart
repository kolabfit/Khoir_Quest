import 'dart:io';

import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

Future<Database?> openLegacyDatabaseIfExists(String path) async {
  final file = File(path);
  if (!await file.exists()) return null;
  return databaseFactoryIo.openDatabase(path, version: 1);
}
