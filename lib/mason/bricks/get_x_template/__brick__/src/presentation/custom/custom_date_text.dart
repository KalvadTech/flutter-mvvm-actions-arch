import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/src/config/colors.dart';
import '/src/config/config.dart';
import '/src/utils/screen_utils.dart';
import 'package:timeago/timeago.dart' as timeago;

/// **CustomDateText**
///
/// Displays formatted date strings with locale and responsive font sizing.
///
/// **Why**
/// - Encapsulate date formatting logic to keep views clean.
/// - Support flexible formatting options (with/without year, day names, etc.).
/// - Integrate responsive sizing via [ScreenUtils].
///
/// **Key Features**
/// - Formats dates using `intl.DateFormat` in English locale.
/// - Optional `toDateTime` for date ranges.
/// - Customizable flags: `withYear`, `withDayName`, `withShortYear`, `withShortDayName`.
/// - Returns empty string when `dateTime` is null.
///
/// **Example**
/// ```dart
/// CustomDateText(
///   DateTime.now(),
///   dateFormat: 'MMM d, yyyy',
///   fontSize: 12,
///   color: Colors.grey,
/// )
/// ```
///
// ────────────────────────────────────────────────
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

/// **CustomTimeText**
///
/// Displays formatted time strings with optional time range support.
///
/// **Why**
/// - Centralize time formatting to avoid duplication in views.
/// - Support time ranges (e.g., "10:00 AM - 12:00 PM").
///
/// **Key Features**
/// - Uses `intl.DateFormat` for time formatting.
/// - Optional `toDateTime` for time ranges.
/// - Outputs uppercase by default.
///
/// **Example**
/// ```dart
/// CustomTimeText(
///   DateTime.now(),
///   dateFormat: 'h:mm a',
///   fontSize: 10,
/// )
/// ```
///
// ────────────────────────────────────────────────
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

/// **CustomTimeAgoText**
///
/// Displays relative time strings ("2 hours ago", "just now") with automatic periodic updates.
///
/// **Why**
/// - Provide user-friendly relative timestamps that stay fresh.
/// - Automatically update every minute to keep text accurate.
///
/// **Key Features**
/// - Uses `timeago` package for relative time formatting.
/// - Stateful widget with a periodic timer (1 minute interval).
/// - Timer is canceled on disposal to prevent memory leaks.
///
/// **Example**
/// ```dart
/// CustomTimeAgoText(
///   DateTime.now().subtract(Duration(hours: 2)),
///   fontSize: 10,
///   color: Colors.grey,
/// )
/// ```
///
// ────────────────────────────────────────────────
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
