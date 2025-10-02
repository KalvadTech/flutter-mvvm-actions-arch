
import '/src/modules/grades/controllers/grade_view_model.dart';
import '/src/modules/grades/views/widgets/grades_grid_view.dart';
import '/src/views/custom/customs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: const SideMenu(),
      body: Stack(
        children: [
          ListView(
            children: [
              GetX<GradeViewModel>(
                builder: (controller) => ApiHandler(
                  tryAgain: controller.refreshData,
                  apiResponse: controller.grades,
                  onSuccess: GradesGridView(grades: controller.grades.data ?? []),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
