import 'package:flutter/material.dart';

class CustomDashLine extends StatelessWidget {
  final double height;
  final double dashHeight;
  final double dashWidth;
  final Color dashColor;
  final double fillRate; // [0, 1] totalDashSpace/totalSpace
  final Axis direction;

  const CustomDashLine({
    super.key,
    this.dashHeight = 1,
    this.dashWidth = 8,
    this.dashColor = Colors.black,
    this.fillRate = 0.5,
    this.direction = Axis.horizontal,
    this.height = 1,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxSize = direction == Axis.horizontal ? constraints.constrainWidth() : constraints.constrainHeight();
        final dCount = (boxSize * fillRate / dashWidth).floor();
        return Padding(
          padding: EdgeInsets.symmetric(vertical: height / 2),
          child: Flex(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            direction: direction,
            children: List.generate(
              dCount,
              (_) {
                return SizedBox(
                  width: direction == Axis.horizontal ? dashWidth : dashHeight,
                  height: direction == Axis.horizontal ? dashHeight : dashWidth,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: dashColor),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
