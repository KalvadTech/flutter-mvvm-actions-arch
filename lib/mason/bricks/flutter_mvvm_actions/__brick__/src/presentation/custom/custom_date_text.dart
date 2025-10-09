import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/src/utils/responsive_utils.dart';
import 'package:timeago/timeago.dart' as timeago;

/// **CustomDateText**
///
/// A theme-aware widget that displays formatted date strings with responsive sizing.
///
/// **Features**:
/// - Theme-aware colors with automatic light/dark mode support
/// - Responsive font sizing via [ScreenUtils]
/// - Date range support with `toDateTime`
/// - Flexible formatting using `intl.DateFormat`
/// - Proper overflow handling
///
/// **Usage**:
/// ```dart
/// // Simple date
/// CustomDateText(DateTime.now())
///
/// // Custom format
/// CustomDateText(
///   DateTime.now(),
///   dateFormat: 'MMM d, yyyy',
///   fontSize: 14,
/// )
///
/// // Date range
/// CustomDateText(
///   startDate,
///   toDateTime: endDate,
///   dateFormat: 'MMM d',
/// )
/// ```
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
  final TextOverflow? overflow;

  const CustomDateText(
    this.dateTime, {
    super.key,
    this.dateFormat,
    this.color,
    this.fontSize = 12.0,
    this.fontWeight = FontWeight.w400,
    this.height,
    this.letterSpacing,
    this.fontFamily,
    this.textAlign,
    this.maxLines,
    this.textStyle,
    this.toDateTime,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.textTheme.bodyMedium?.color;

    final customStyle = TextStyle(
      fontSize: ResponsiveUtils.scaledFontSize(context, fontSize),
      color: effectiveColor,
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

    final formatter = dateFormat == null
        ? DateFormat.MMMMd('en')
        : DateFormat(dateFormat, 'en');

    final text = toDateTime != null
        ? '${formatter.format(dateTime!)} - ${formatter.format(toDateTime!)}'
        : formatter.format(dateTime!);

    return Text(
      text,
      style: textStyle ?? customStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// **CustomTimeText**
///
/// A theme-aware widget that displays formatted time strings with responsive sizing.
///
/// **Features**:
/// - Theme-aware colors with automatic light/dark mode support
/// - Responsive font sizing via [ScreenUtils]
/// - Time range support with `toDateTime`
/// - Flexible formatting using `intl.DateFormat`
/// - Optional uppercase transformation
/// - Proper overflow handling
///
/// **Usage**:
/// ```dart
/// // Simple time
/// CustomTimeText(DateTime.now())
///
/// // Custom format
/// CustomTimeText(
///   DateTime.now(),
///   dateFormat: 'h:mm a',
///   fontSize: 12,
///   uppercase: false,
/// )
///
/// // Time range
/// CustomTimeText(
///   startTime,
///   toDateTime: endTime,
/// )
/// ```
class CustomTimeText extends StatelessWidget {
  final DateTime dateTime;
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
  final TextOverflow? overflow;
  final bool uppercase;

  const CustomTimeText(
    this.dateTime, {
    super.key,
    this.dateFormat,
    this.color,
    this.fontSize = 12.0,
    this.fontWeight = FontWeight.w400,
    this.height,
    this.letterSpacing,
    this.fontFamily,
    this.textAlign,
    this.maxLines,
    this.textStyle,
    this.toDateTime,
    this.overflow,
    this.uppercase = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.textTheme.bodyMedium?.color;

    final format = dateFormat == null
        ? DateFormat.Hm()
        : DateFormat(dateFormat, 'en');

    final text = toDateTime != null
        ? '${format.format(dateTime)} - ${format.format(toDateTime!)}'
        : format.format(dateTime);

    final displayText = uppercase ? text.toUpperCase() : text;

    return Text(
      displayText,
      style: textStyle ??
          TextStyle(
            fontSize: ResponsiveUtils.scaledFontSize(context, fontSize),
            color: effectiveColor,
            fontWeight: fontWeight,
            letterSpacing: letterSpacing,
            height: height,
            fontFamily: fontFamily,
          ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// **CustomTimeAgoText**
///
/// A theme-aware widget that displays relative time strings with automatic updates.
///
/// **Features**:
/// - Theme-aware colors with automatic light/dark mode support
/// - Responsive font sizing via [ScreenUtils]
/// - Automatic periodic updates to keep time fresh
/// - Configurable update interval
/// - Uses `timeago` package for formatting
/// - Proper overflow handling
///
/// **Usage**:
/// ```dart
/// // Simple relative time
/// CustomTimeAgoText(
///   DateTime.now().subtract(Duration(hours: 2)),
/// )
///
/// // Custom styling
/// CustomTimeAgoText(
///   postDate,
///   fontSize: 12,
///   color: Colors.grey,
///   updateInterval: Duration(seconds: 30),
/// )
/// ```
class CustomTimeAgoText extends StatefulWidget {
  final DateTime dateTime;
  final Color? color;
  final double fontSize;
  final double? letterSpacing;
  final double? height;
  final int? maxLines;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final TextAlign? textAlign;
  final TextStyle? textStyle;
  final TextOverflow? overflow;
  final Duration updateInterval;

  const CustomTimeAgoText(
    this.dateTime, {
    super.key,
    this.color,
    this.fontSize = 12.0,
    this.fontWeight = FontWeight.w400,
    this.height,
    this.letterSpacing,
    this.fontFamily,
    this.textAlign,
    this.maxLines,
    this.textStyle,
    this.overflow,
    this.updateInterval = const Duration(minutes: 1),
  });

  @override
  State<CustomTimeAgoText> createState() => _CustomTimeAgoTextState();
}

class _CustomTimeAgoTextState extends State<CustomTimeAgoText> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    // Only start timer if widget is still mounted
    if (mounted) {
      _timer = Timer.periodic(widget.updateInterval, (timer) {
        if (mounted) {
          setState(() {});
        } else {
          timer.cancel();
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = widget.color ?? theme.textTheme.bodyMedium?.color;

    return Text(
      timeago.format(widget.dateTime),
      style: widget.textStyle ??
          TextStyle(
            fontSize: ResponsiveUtils.scaledFontSize(context, widget.fontSize),
            color: effectiveColor,
            fontWeight: widget.fontWeight,
            letterSpacing: widget.letterSpacing,
            height: widget.height,
            fontFamily: widget.fontFamily,
          ),
      textAlign: widget.textAlign,
      maxLines: widget.maxLines,
      overflow: widget.overflow,
    );
  }
}
