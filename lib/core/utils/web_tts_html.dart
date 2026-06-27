// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:html' as html;

Future<bool> speakWithNativeWebTts(
  String text, {
  required String language,
  double speechRate = .42,
  double pitch = 1.08,
}) async {
  final value = text.trim();
  if (value.isEmpty) return true;

  final synthesis = html.window.speechSynthesis;
  if (synthesis == null) return false;
  final voice = _matchingVoice(synthesis.getVoices(), language);
  if (voice == null && language.toLowerCase().startsWith('ar-')) return false;

  final utterance = html.SpeechSynthesisUtterance(value)
    ..lang = language
    ..rate = speechRate
    ..pitch = pitch;
  if (voice != null) utterance.voice = voice;

  synthesis.cancel();
  synthesis.speak(utterance);
  return true;
}

html.SpeechSynthesisVoice? _matchingVoice(
  List<html.SpeechSynthesisVoice> voices,
  String language,
) {
  final prefix = language.toLowerCase();
  for (final voice in voices) {
    if ((voice.lang ?? '').toLowerCase().startsWith(prefix)) return voice;
  }
  return null;
}
