import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '/src/presentation/custom/custom_text.dart';
import '/src/config/config.dart';
import '/src/modules/menu/menu.dart';
import '/src/presentation/custom/customs.dart';

class SideMenu extends GetWidget<MenuViewModel> {
  const SideMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Drawer(
        child: ListView(
          children: [
            Row(
              children: [
                Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: SvgPicture.asset(
                    AssetsManager.logoPath,
                    height: MediaQuery.of(context).size.height * 0.2,
                    colorFilter: ColorFilter.mode(Theme.of(context).primaryColor, BlendMode.srcIn),
                  ),
                ),
                controller.expanded
                    ? const CustomText(
                        appName,
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w700,
                      )
                    : Container()
              ],
            ),
            DrawerItem(
              label: 'Page 1',
              iconData: Icons.house,
              selected: controller.selectedIndex == 0,
              onTap: () => MenuActions.instance.toPage1(),
            ),
            DrawerItem(
              label: 'Page 2',
              iconData: Icons.category,
              selected: controller.selectedIndex == 1,
              onTap: () => MenuActions.instance.toPage2(),
            ),
            DrawerItem(
              label: 'Page 3',
              iconData: Icons.person,
              selected: controller.selectedIndex == 2,
              onTap: () => MenuActions.instance.toPage3(),
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  final String label;
  final IconData iconData;
  final bool selected;
  final VoidCallback onTap;

  const DrawerItem({
    Key? key,
    required this.label,
    required this.iconData,
    required this.selected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.horizontal(right: Radius.circular(16.0)),
          color: selected ? Theme.of(context).primaryColor.withValues(alpha: 0.5) : Colors.transparent,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              iconData,
              size: 24.0,
              color: Colors.grey[900],
            ),
            const SizedBox(width: 16.0),
            CustomText(
              label,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(width: 64.0),
          ],
        ),
      ),
    );
  }
}
