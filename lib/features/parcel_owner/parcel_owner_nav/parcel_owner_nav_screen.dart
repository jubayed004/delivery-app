import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:delivery_app/core/custom_assets/assets.gen.dart';
import 'package:delivery_app/core/router/route_path.dart';
import 'package:delivery_app/core/router/routes.dart';
import 'package:delivery_app/features/chatList/chatList_screen.dart';
import 'package:delivery_app/features/parcel_owner/my_parcel/my_parcel_screen.dart';
import 'package:delivery_app/features/parcel_owner/parcel_owner_home/parcel_owner_home_screen.dart';
import 'package:delivery_app/features/profile/profile_screen.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class ParcelOwnerNavScreen extends StatefulWidget {
  final int? initialIndex;

  const ParcelOwnerNavScreen({super.key, this.initialIndex});

  @override
  State<ParcelOwnerNavScreen> createState() => _ParcelOwnerNavScreenState();
}

class _ParcelOwnerNavScreenState extends State<ParcelOwnerNavScreen> {
  late final ValueNotifier<int> selectedIndex;

  @override
  void initState() {
    super.initState();
    print("widget.initialIndex call: ${widget.initialIndex}");
    print("initialIndex: ${widget.initialIndex}");
    selectedIndex = ValueNotifier<int>(widget.initialIndex ?? 0);
    print("selectedIndex: ${selectedIndex.value}");
  }

  @override
  void didUpdateWidget(covariant ParcelOwnerNavScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialIndex != null) {
      selectedIndex.value = widget.initialIndex!;
    }
  }

  @override
  void dispose() {
    selectedIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.initialIndex);
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

      body: ValueListenableBuilder<int>(
        valueListenable: selectedIndex,
        builder: (context, selected, _) {
          return switch (selected) {
            0 => const ParcelOwnerHomeScreen(),
            1 => const MyParcelScreen(),
            2 => const ChatListScreen(),
            3 => const ProfileScreen(),
            _ => const ParcelOwnerHomeScreen(),
          };
        },
      ),
    );
  }
}
