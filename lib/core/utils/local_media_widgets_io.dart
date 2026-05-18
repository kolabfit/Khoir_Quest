import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:video_player/video_player.dart';

VideoPlayerController localVideoController(String path) {
  return VideoPlayerController.file(File(path));
}

Widget localImageWidget(
  String path, {
  required BoxFit fit,
  required ImageErrorWidgetBuilder errorBuilder,
}) {
  return Image.file(File(path), fit: fit, errorBuilder: errorBuilder);
}
