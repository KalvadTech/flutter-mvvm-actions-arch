import '/src/config/config.dart';
import '/src/modules/grades/actions/grade_actions.dart';
import '/src/modules/grades/data/model/grade_model.dart';
import '/src/views/custom/custom_container.dart';
import '/src/views/custom/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GradeGridTile extends StatelessWidget {
  final GradeModel gradeModel;
  final Color color;

  const GradeGridTile({super.key, required this.gradeModel, required this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onGradeSelected,
      child: CustomCard.leftBorder(
        alignment: Get.locale.toString() == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
        padding: EdgeInsets.zero,
        color: ColorManager.cardColor,
        borderColor: color.withValues(alpha: 0.3),
        child: AspectRatio(
          aspectRatio: 2.2,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                right: Get.locale!.languageCode != 'ar' ? -32 : null,
                left: Get.locale!.languageCode == 'ar' ? -32 : null,
                child: CustomContainer(
                  size: 50 * 2,
                  color: color,
                  opacity: 0.1,
                  child: CustomContainer(
                    size: 50 * 1.5,
                    color: color,
                    opacity: 0.2,
                    child: CustomContainer(
                      size: 50,
                      color: color,
                      opacity: 0.8,
                      padding: const EdgeInsets.all(8.0),
                      child: FittedBox(
                        child: CustomText.title(
                          gradeModel.name.split('Grade').last.trim(),
                          textAlign: TextAlign.center,
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 28,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    CustomText.title(
                      'Grade',
                      color: ColorManager.primaryColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onGradeSelected() {
    GradeActions.instance.onGradeSelected(gradeModel);
  }
}

class CustomCard extends StatelessWidget {
  final double? width;
  final double? height;
  final double radius;
  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets? margin;
  final Color? color;
  final Color? borderColor;
  final Alignment alignment;
  final double? borderWidth;
  final double? borderHeight;

  const CustomCard({
    super.key,
    this.width,
    this.height,
    required this.child,
    this.padding = const EdgeInsets.all(8.0),
    this.margin,
    this.color = ColorManager.cardColor,
    this.radius = 12.0,
    this.alignment = Alignment.bottomCenter,
    this.borderColor = Colors.transparent,
    this.borderWidth = 0,
    this.borderHeight = 0,
  });

  const CustomCard.bottomBorder({
    super.key,
    this.width,
    this.height,
    required this.child,
    this.padding = const EdgeInsets.all(8.0),
    this.margin,
    this.color = ColorManager.cardColor,
    this.radius = 12.0,
    this.alignment = Alignment.bottomCenter,
    this.borderColor = ColorManager.primaryColor,
    this.borderWidth,
    this.borderHeight = 8,
  });

  const CustomCard.topBorder({
    super.key,
    this.width,
    this.height,
    required this.child,
    this.padding = const EdgeInsets.all(8.0),
    this.margin,
    this.color = ColorManager.cardColor,
    this.radius = 12.0,
    this.alignment = Alignment.topCenter,
    this.borderColor = ColorManager.primaryColor,
    this.borderWidth,
    this.borderHeight = 8,
  });

  const CustomCard.leftBorder({
    super.key,
    this.width,
    this.height,
    required this.child,
    this.padding = const EdgeInsets.all(8.0),
    this.margin,
    this.color = ColorManager.cardColor,
    this.radius = 12.0,
    this.alignment = Alignment.centerLeft,
    this.borderColor = ColorManager.primaryColor,
    this.borderWidth = 8,
    this.borderHeight,
  });

  const CustomCard.rightBorder({
    super.key,
    this.width,
    this.height,
    required this.child,
    this.padding = const EdgeInsets.all(8.0),
    this.margin,
    this.color = ColorManager.cardColor,
    this.radius = 12.0,
    this.alignment = Alignment.centerRight,
    this.borderColor = ColorManager.primaryColor,
    this.borderWidth = 8,
    this.borderHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      width: width,
      height: height,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        boxShadow: [
          // main soft shadow
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            spreadRadius: 0,
            offset: const Offset(0, 6),
          ),
          // small lift (optional)
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 2,
            spreadRadius: 0,
            offset: const Offset(0, 1),
          ),
          // small lift (optional)
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.01),
            blurRadius: 2,
            spreadRadius: 0,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: padding,
            child: child,
          ),
          Align(
            alignment: alignment,
            child: Container(
              color: borderColor,
              width: borderWidth,
              height: borderHeight,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomContainer extends StatelessWidget {
  final Widget child;
  final double size;
  final Color color;
  final double opacity;
  final EdgeInsets padding;
  final BoxShape shape;
  final BorderRadius? borderRadius;

  const CustomContainer({
    super.key,
    required this.child,
    this.size = 48.0,
    this.padding = const EdgeInsets.all(4.0),
    this.color = ColorManager.primaryColor,
    this.opacity = 0.08,
    this.shape = BoxShape.circle,
    this.borderRadius,
  });

  const CustomContainer.circle({
    super.key,
    required this.child,
    this.size = 48.0,
    this.padding = const EdgeInsets.all(4.0),
    this.color = ColorManager.primaryColor,
    this.opacity = 0.08,
    this.shape = BoxShape.circle,
    this.borderRadius,
  });

  const CustomContainer.square({
    super.key,
    required this.child,
    this.size = 48.0,
    this.padding = const EdgeInsets.all(4.0),
    this.color = ColorManager.primaryColor,
    this.opacity = 0.08,
    this.shape = BoxShape.rectangle,
    this.borderRadius = const BorderRadius.all(Radius.circular(12.0)),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      padding: padding,
      decoration: BoxDecoration(
        color: color.withValues(alpha: opacity),
        shape: shape,
        borderRadius: borderRadius,
      ),
      child: child,
    );
  }
}

