import 'package:alakhtabut/src/config/colors.dart';
import 'package:alakhtabut/src/modules/app_tour/controllers/app_tour_view_model.dart';
import 'package:alakhtabut/src/modules/app_tour/views/tour_spot.dart';
import 'package:alakhtabut/src/modules/app_tour/views/tour_starter.dart';
import 'package:alakhtabut/src/modules/grades/data/model/grade_model.dart';
import 'package:alakhtabut/src/modules/grades/views/widgets/grade_grid_tile.dart';
import 'package:flutter/material.dart';

class GradesGridView extends StatelessWidget {
  final List<GradeModel> grades;

  const GradesGridView({super.key, required this.grades});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GridView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.all(24.0),
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 24.0,
          crossAxisSpacing: 24.0,
          childAspectRatio: 2.2,
        ),
        // itemCount: grades.length,
        itemCount: 1,
        itemBuilder: (context, index) {
          final tile =  GradeGridTile(
            gradeModel: grades.last,
            color: ColorManager.paletteColors[index % ColorManager.paletteColors.length],
          );
          // ✅ spotlight only the first item
          return index == 0
              ? Stack(
            children: [
              TourSpot(id: TourId.homeGradesGrid, child: tile),
              const TourStarter(flowKey: 'home_v1')
            ],
          )
              : tile;
        },
      ),
    );
  }
}
