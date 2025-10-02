import 'package:flutter/material.dart';

class CustomVisible extends StatelessWidget {
  final bool show;
  final Widget child;
  final Widget? placeHolder;
  const CustomVisible({super.key, required this.show, required this.child, this.placeHolder});

  @override
  Widget build(BuildContext context) {
    return show ? child : placeHolder ?? Container();
  }
}
