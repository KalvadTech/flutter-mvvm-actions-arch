import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/src/config/colors.dart';
import '/src/config/config.dart';
import '/src/utils/screen_utils.dart';
import 'package:timeago/timeago.dart' as timeago;

class CustomDateText extends StatelessWidget {
  final DateTime? dateTime;
  final DateTime? toDateTime;
  final String? dateFormat;
  final Color? color;
  final double fontSize;
  final double? letterSpacing;
  final double? height;
  final int? maxLines;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final TextAlign? textAlign;
  final TextStyle? textStyle;
  final bool capsLock;
  final bool withYear;
  final bool withDayName;
  final bool withShortYear;
  final bool withShortDayName;

  const CustomDateText(
    this.dateTime, {
    super.key,
    this.dateFormat,
    this.color = ColorManager.bodyColor,
    this.fontSize = 10.0,
    this.fontWeight = FontWeight.w400,
    this.height,
    this.letterSpacing,
    this.fontFamily,
    this.textAlign,
    this.maxLines,
    this.textStyle,
    this.toDateTime,
    this.capsLock = true,
    this.withYear = true,
    this.withDayName = true,
    this.withShortYear = false,
    this.withShortDayName = false,
  });

  @override
  Widget build(BuildContext context) {
    final customStyle = TextStyle(
      fontSize: ScreenUtils.getFontSize(context, fontSize),
      color: color,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      height: height,
      fontFamily: fontFamily,
    );
    if (dateTime == null) {
      return Text(
        '',
        style: customStyle,
      );
    }
    var formatter = dateFormat == null ? DateFormat.MMMMd('en') : DateFormat(dateFormat, 'en');
    String text =  '${formatter.format(dateTime!)} ${toDateTime != null ? '- ${formatter.format(toDateTime!)}' : ''}';
    return Text(
      text,
      style: textStyle ?? customStyle,
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }
}

class CustomTimeText extends StatelessWidget {
  final DateTime dateTime;
  final DateTime? toDateTime;
  final String? dateFormat;
  final Color? color;
  final double? fontSize;
  final double? letterSpacing;
  final double? height;
  final int? maxLines;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final TextAlign? textAlign;
  final TextStyle? textStyle;

  const CustomTimeText(
    this.dateTime, {
    super.key,
    this.dateFormat,
    this.color = ColorManager.bodyColor,
    this.fontSize = 10.0,
    this.fontWeight = FontWeight.w400,
    this.height,
    this.letterSpacing,
    this.fontFamily,
    this.textAlign,
    this.maxLines,
    this.textStyle,
    this.toDateTime,
  });

  @override
  Widget build(BuildContext context) {
    var format = dateFormat == null ? DateFormat.Hm() : DateFormat(dateFormat, 'en');

    return Text(
      '${format.format(dateTime)} ${toDateTime != null ? '- ${format.format(toDateTime!)}' : ''}'.toUpperCase(),
      style: textStyle ??
          TextStyle(
            fontSize: fontSize,
            color: color,
            fontWeight: fontWeight,
            letterSpacing: letterSpacing,
            height: height,
            fontFamily: fontFamily,
          ),
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }
}

class CustomTimeAgoText extends StatefulWidget {
  final DateTime dateTime;
  final Color? color;
  final double? fontSize;
  final double? letterSpacing;
  final double? height;
  final int? maxLines;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final TextAlign? textAlign;
  final TextStyle? textStyle;

  const CustomTimeAgoText(
      this.dateTime, {
        super.key,
        this.color,
        this.fontSize = 10.0,
        this.fontWeight = FontWeight.w400,
        this.height,
        this.letterSpacing,
        this.fontFamily,
        this.textAlign,
        this.maxLines,
        this.textStyle,
      });

  @override
  State<CustomTimeAgoText> createState() => _CustomTimeAgoTextState();
}

class _CustomTimeAgoTextState extends State<CustomTimeAgoText> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      timeago.format(widget.dateTime),
      style: widget.textStyle ??
          TextStyle(
            fontSize: widget.fontSize,
            color: widget.color,
            fontWeight: widget.fontWeight,
            letterSpacing: widget.letterSpacing,
            height: widget.height,
            fontFamily: widget.fontFamily,
          ),
      textAlign: widget.textAlign,
      maxLines: widget.maxLines,
    );
  }
}
