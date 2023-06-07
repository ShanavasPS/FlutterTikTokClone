import 'package:flutter/cupertino.dart';
import 'package:tiktokclone/utils/tiktok_strings.dart';

String getDuration(Duration duration) {
  int seconds = duration.inSeconds.remainder(60);
  int minutes = duration.inMinutes.remainder(60);
  int hours = duration.inHours;
  int preFix = seconds;
  String postFix = TikTokStrings.secondPostFix;
  if(hours > 0) {
    preFix = hours;
    postFix = TikTokStrings.hourPostFix;
  } else if(minutes > 0) {
    preFix = minutes;
    postFix = TikTokStrings.minutePostFix;
  }

  return "$preFix $postFix";
}

double measureTextWidth(String text, TextStyle style) {
  final TextPainter textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    textDirection: TextDirection.ltr,
  );

  textPainter.layout();

  return textPainter.width;
}