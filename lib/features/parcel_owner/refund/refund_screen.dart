import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:delivery_app/features/parcel_owner/refund/controller/refund_controller.dart';
import 'package:delivery_app/utils/app_strings/app_strings.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:delivery_app/utils/extension/base_extension.dart';
import 'widgets/refund_card.dart';
import 'widgets/refund_request_dialog.dart';

class RefundScreen extends StatelessWidget {
  const RefundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final RefundController controller = Get.put(RefundController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(AppStrings.refundCompensationRequest.tr),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),
            Text(
              'Recent Parcels'.tr,
              style: context.titleLarge.copyWith(color: AppColors.primaryColor),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: Obx(() {
                if (controller.refundItems.isEmpty) {
                  return const Center(child: Text("No parcels found"));
                }
                return ListView.builder(
                  itemCount: controller.refundItems.length,
                  itemBuilder: (context, index) {
                    final item = controller.refundItems[index];
                    return RefundCard(
                      refundItem: item,
                      onRefundTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => const RefundRequestDialog(),
                        );
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
