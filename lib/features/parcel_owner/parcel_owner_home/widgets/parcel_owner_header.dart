import 'package:delivery_app/core/router/route_path.dart';
import 'package:delivery_app/core/router/routes.dart';
import 'package:delivery_app/share/widgets/network_image/custom_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:delivery_app/utils/extension/base_extension.dart';

class ParcelOwnerHeader extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String greeting;

  const ParcelOwnerHeader({
    super.key,
    required this.name,
    required this.imageUrl,
    this.greeting = "Welcome back!",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 50.h,
        left: 20.w,
        right: 20.w,
        bottom: 30.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
      ),
      child: Row(
        children: [
          CustomNetworkImage(
            imageUrl: imageUrl.isNotEmpty
                ? imageUrl
                : "https://i.pravatar.cc/150?img=12",
            borderRadius: BorderRadius.circular(28.r),
            width: 56.w,
            height: 56.w,
          ),
          Gap(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hello $name",
                  style: context.titleLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  greeting,
                  style: context.bodyMedium.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              AppRouter.route.pushNamed(RoutePath.notificationScreen);
            },
            child: Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Iconsax.notification, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
