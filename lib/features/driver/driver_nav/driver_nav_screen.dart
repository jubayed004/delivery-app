import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:delivery_app/core/custom_assets/assets.gen.dart';
import 'package:delivery_app/core/router/route_path.dart';
import 'package:delivery_app/core/router/routes.dart';
import 'package:delivery_app/features/chatList/chatList_screen.dart';
import 'package:delivery_app/features/driver/driver_home/driver_home_screen.dart';
import 'package:delivery_app/features/driver/parcels/parcels_screen.dart';
import 'package:delivery_app/features/profile/profile_screen.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class DriverNavScreen extends StatefulWidget {
  const DriverNavScreen({super.key});

  @override
  State<DriverNavScreen> createState() => _DriverNavScreenState();
}

class _DriverNavScreenState extends State<DriverNavScreen> {
  final ValueNotifier<int> selectedIndex = ValueNotifier<int>(0);
  final PageController controller = PageController();

  @override
  void dispose() {
    controller.dispose();
    selectedIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ValueListenableBuilder<int>(
        valueListenable: selectedIndex,
        builder: (context, selected, _) {
          return StylishBottomBar(
            backgroundColor: AppColors.navBarColor,
            option: AnimatedBarOptions(
              iconSize: 32,
              iconStyle: IconStyle.animated,
            ),
            items: [
              BottomBarItem(
                icon: const Icon(Iconsax.home),
                selectedIcon: const Icon(Iconsax.home1),
                selectedColor: AppColors.secondPrimaryColor,
                unSelectedColor: AppColors.secondPrimaryColor,
                title: const Text('Home'),
              ),
              BottomBarItem(
                icon: const Icon(Iconsax.directbox_send),
                selectedIcon: const Icon(Iconsax.directbox_send5),
                selectedColor: AppColors.secondPrimaryColor,
                unSelectedColor: AppColors.secondPrimaryColor,
                title: const Text('Parcels'),
              ),
              BottomBarItem(
                icon: const Icon(Iconsax.messages),
                selectedIcon: const Icon(Iconsax.messages_15),
                selectedColor: AppColors.secondPrimaryColor,
                unSelectedColor: AppColors.secondPrimaryColor,
                title: const Text('chat'),
              ),
              BottomBarItem(
                icon: const Icon(Iconsax.profile_add4),
                selectedIcon: const Icon(Iconsax.profile_add5),
                selectedColor: AppColors.secondPrimaryColor,
                unSelectedColor: AppColors.secondPrimaryColor,
                title: const Text('Profile'),
              ),
            ],
            hasNotch: true,
            fabLocation: StylishBarFabLocation.center,
            notchStyle: NotchStyle.circle,
            currentIndex: selected,
            onTap: (index) {
              if (index == selected) return;
              controller.jumpToPage(index);
              selectedIndex.value = index;
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AppRouter.route.pushNamed(RoutePath.trackParcelScreen);
        },
        backgroundColor: AppColors.primaryColor,
        shape: const CircleBorder(),
        child: Assets.icons.box.svg(),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      body: SafeArea(
        child: PageView(
          controller: controller,
          children: const [
            DriverHomeScreen(),
            ParcelsScreen(),

            ChatListScreen(),
            ProfileScreen(),
          ],
        ),
      ),
    );
  }
}
