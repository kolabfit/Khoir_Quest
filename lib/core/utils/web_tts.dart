import 'web_tts_stub.dart' if (dart.library.html) 'web_tts_html.dart';

Future<bool> speakWithWebTts(
  String text, {
  required String language,
  double speechRate = .42,
  double pitch = 1.08,
}) {
  return speakWithNativeWebTts(
    text,
    language: language,
    speechRate: speechRate,
    pitch: pitch,
  );
}
