import 'package:flutter/material.dart';
import 'custom_text.dart';

class TextDivider extends StatelessWidget {
  final String text;
  final double height;
  final double thickness;
  final Color color;
  const TextDivider(this.text,{Key? key, this.height = 16.0, this.thickness = 0.1, this.color = const Color(0xFF000000)}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(height: height,thickness: thickness,color: color,)),
        const SizedBox(width: 16.0),
        CustomText(text,color: color,),
        const SizedBox(width: 16.0),
        Expanded(child: Divider(height: height,thickness: thickness,color: color,)),
      ],
    );
  }
}
