import 'package:flutter/material.dart';
import '/src/config/config.dart';

class CustomCard extends StatelessWidget {
  final double? width;
  final double? height;
  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets? margin;
  final Color? color;

  const CustomCard({super.key, this.width, this.height, required this.child, this.padding = const EdgeInsets.all(8.0), this.margin, this.color = ColorManager.darkBackgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      width: width,
      height: height,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: child,
    );
  }
}
