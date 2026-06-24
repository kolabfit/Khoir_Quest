import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_windows/webview_windows.dart';
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
  YoutubePlayerController? _iframeController;
  WebviewController? _windowsController;
  bool _windowsLoading = false;
  String? _windowsError;

  bool get _useWindowsWebView => Platform.isWindows;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant AppYoutubeEmbedPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url || oldWidget.autoPlay != widget.autoPlay) {
      _disposePlayer();
      _load();
    }
  }

  void _load() {
    final videoId = MediaSourceHelper.youtubeVideoId(widget.url);
    if (videoId == null) return;
    if (_useWindowsWebView) {
      _loadWindows(videoId);
      return;
    }
    _iframeController = YoutubePlayerController.fromVideoId(
      videoId: videoId,
      autoPlay: widget.autoPlay,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
      ),
    );
  }

  Future<void> _loadWindows(String videoId) async {
    setState(() {
      _windowsLoading = true;
      _windowsError = null;
    });
    final controller = WebviewController();
    _windowsController = controller;
    try {
      await controller.initialize();
      await controller.setBackgroundColor(Colors.black);
      await controller.setPopupWindowPolicy(WebviewPopupWindowPolicy.deny);
      await controller.loadStringContent(_youtubeHtml(videoId));
      if (!mounted || _windowsController != controller) return;
      setState(() => _windowsLoading = false);
    } on PlatformException catch (error) {
      if (!mounted || _windowsController != controller) return;
      setState(() {
        _windowsLoading = false;
        _windowsError = error.message ?? 'YouTube player Windows gagal dibuka.';
      });
    } catch (_) {
      if (!mounted || _windowsController != controller) return;
      setState(() {
        _windowsLoading = false;
        _windowsError = 'YouTube player Windows gagal dibuka.';
      });
    }
  }

  String _youtubeHtml(String videoId) {
    final autoplay = widget.autoPlay ? '1' : '0';
    final src =
        'https://www.youtube-nocookie.com/embed/$videoId'
        '?autoplay=$autoplay&controls=1&rel=0&modestbranding=1&playsinline=1';
    return '''
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>
    html, body { margin: 0; width: 100%; height: 100%; background: #000; overflow: hidden; }
    iframe { border: 0; width: 100%; height: 100%; }
  </style>
</head>
<body>
  <iframe src="$src" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>
</body>
</html>
''';
  }

  void _disposePlayer() {
    _iframeController?.close();
    _iframeController = null;
    _windowsController?.dispose();
    _windowsController = null;
  }

  @override
  void dispose() {
    _disposePlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaSourceHelper.youtubeVideoId(widget.url) == null) {
      return const _YoutubeErrorBox(message: 'Link YouTube tidak valid.');
    }
    if (_useWindowsWebView) {
      final controller = _windowsController;
      return ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (controller != null && controller.value.isInitialized)
                Webview(controller)
              else
                const ColoredBox(color: Colors.black),
              if (_windowsLoading)
                const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              if (_windowsError != null)
                _YoutubeErrorBox(message: _windowsError!),
            ],
          ),
        ),
      );
    }
    final controller = _iframeController;
    if (controller == null) {
      return const _YoutubeErrorBox(message: 'YouTube player belum siap.');
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: YoutubePlayer(controller: controller, aspectRatio: 16 / 9),
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
          child: Padding(
            padding: const EdgeInsets.all(16),
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
      ),
    );
  }
}
