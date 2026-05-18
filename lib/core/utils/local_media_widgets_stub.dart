import 'package:flutter/widgets.dart';
import 'package:video_player/video_player.dart';

VideoPlayerController localVideoController(String path) {
  throw UnsupportedError('Local video files are not available on this platform.');
}

Widget localImageWidget(
  String path, {
  required BoxFit fit,
  required ImageErrorWidgetBuilder errorBuilder,
}) {
  return ErrorWidget.withDetails(message: 'Local images are not available.');
}
