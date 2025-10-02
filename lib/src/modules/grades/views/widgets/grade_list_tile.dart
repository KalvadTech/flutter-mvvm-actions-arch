import 'package:alakhtabut/src/config/colors.dart';
import 'package:alakhtabut/src/modules/grades/actions/grade_actions.dart';
import 'package:alakhtabut/src/modules/grades/data/model/grade_model.dart';
import 'package:alakhtabut/src/views/custom/custom_text.dart';
import 'package:flutter/material.dart';

class GradeListTile extends StatelessWidget {
  final GradeModel gradeModel;
  const GradeListTile({super.key, required this.gradeModel});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onGradeSelected,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      contentPadding: const EdgeInsets.symmetric(horizontal:16.0, vertical: 8.0),
      tileColor: ColorManager.cardColor,
      title: CustomText(gradeModel.name),
      trailing: const Icon(Icons.navigate_next_rounded),
    );
  }

  void onGradeSelected() {
    GradeActions.instance.onGradeSelected(gradeModel);
  }
}
