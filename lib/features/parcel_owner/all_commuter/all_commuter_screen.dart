import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:delivery_app/core/router/route_path.dart';
import 'package:delivery_app/core/router/routes.dart';
import 'package:delivery_app/features/parcel_owner/all_commuter/controller/all_commuter_controller.dart';
import 'package:delivery_app/features/parcel_owner/all_commuter/widgets/commuter_card.dart';
import 'package:delivery_app/utils/color/app_colors.dart';


class AllCommuterScreen extends GetView<AllCommuterController> {
  const AllCommuterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AllCommuterController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text("All Commuter"),
        scrolledUnderElevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Obx(
        () => ListView.separated(
          padding: EdgeInsets.all(20.w),
          itemCount: controller.commuters.length,
          separatorBuilder: (context, index) => SizedBox(height: 16.h),
          itemBuilder: (context, index) {
            final commuter = controller.commuters[index];
            return CommuterCard(
              commuter: commuter,

              onTap: () =>
                  AppRouter.route.pushNamed(RoutePath.commuterProfileScreen),
            );
          },
        ),
      ),
    );
  }
}
