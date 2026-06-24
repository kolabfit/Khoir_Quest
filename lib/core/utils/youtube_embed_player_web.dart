import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import 'media_source_helper.dart';

class AppYoutubeEmbedPlayer extends StatefulWidget {
  const AppYoutubeEmbedPlayer({
    super.key,
    required this.url,
    this.autoPlay = false,
    this.borderRadius = 18,
  });

  final String url;
  final bool autoPlay;
  final double borderRadius;

  @override
  State<AppYoutubeEmbedPlayer> createState() => _AppYoutubeEmbedPlayerState();
}

class _AppYoutubeEmbedPlayerState extends State<AppYoutubeEmbedPlayer> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = _createController();
  }

  @override
  void didUpdateWidget(covariant AppYoutubeEmbedPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url || oldWidget.autoPlay != widget.autoPlay) {
      _controller.close();
      _controller = _createController();
    }
  }

  YoutubePlayerController _createController() {
    final videoId = MediaSourceHelper.youtubeVideoId(widget.url) ?? '';
    return YoutubePlayerController.fromVideoId(
      videoId: videoId,
      autoPlay: widget.autoPlay,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaSourceHelper.youtubeVideoId(widget.url) == null) {
      return const _YoutubeErrorBox(message: 'Link YouTube tidak valid.');
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: YoutubePlayer(controller: _controller, aspectRatio: 16 / 9),
    );
  }
}

class _YoutubeErrorBox extends StatelessWidget {
  const _YoutubeErrorBox({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xffFFF1F2),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Center(
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xffBE123C),
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}
