import 'package:alakhtabut/src/modules/grades/data/model/grade_model.dart';
import 'package:flutter/material.dart';
import 'grade_list_tile.dart';

class GradesListView extends StatelessWidget {
  final List<GradeModel> grades;

  const GradesListView({super.key, required this.grades});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView.separated(
        shrinkWrap: true,
        padding: const EdgeInsets.all(24.0),
        itemCount: grades.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => GradeListTile(gradeModel: grades[index]),
        separatorBuilder: (context, index) => const SizedBox(height: 12.0),
      ),
    );
  }
}
