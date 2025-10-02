import 'package:alakhtabut/src/config/config.dart';
import 'package:alakhtabut/src/modules/grades/actions/grade_actions.dart';
import 'package:alakhtabut/src/modules/grades/data/model/grade_model.dart';
import 'package:alakhtabut/src/views/custom/custom_container.dart';
import 'package:alakhtabut/src/views/custom/custom_text.dart';
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
                      tkGradeLabel,
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
