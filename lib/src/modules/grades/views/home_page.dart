import 'package:alakhtabut/src/config/config.dart';
import 'package:alakhtabut/src/modules/app_tour/controllers/app_tour_view_model.dart';
import 'package:alakhtabut/src/modules/app_tour/views/tour_spot.dart';
import 'package:alakhtabut/src/modules/grades/controllers/grade_view_model.dart';
import 'package:alakhtabut/src/modules/grades/views/widgets/grades_grid_view.dart';
import 'package:alakhtabut/src/modules/menu/view/widgets/home_header.dart';
import 'package:alakhtabut/src/modules/menu/view/widgets/side_menu.dart';
import 'package:alakhtabut/src/views/custom/customs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar.logo(
        leading: Builder(
          builder: (context) => InkWell(
            onTap: () => Scaffold.of(context).openDrawer(),
            child: const TourSpot(
              id: TourId.homeMenu,
              child: Icon(Icons.menu),
            ),
          ),
        ),
      ),
      drawer: const SideMenu(),
      body: Stack(
        children: [
          ListView(
            children: [
              const HomeHeader(),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: CustomText.title(tkGradesLabel),
              ),
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
