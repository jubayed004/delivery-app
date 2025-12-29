import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:delivery_app/utils/app_strings/app_strings.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:delivery_app/utils/extension/base_extension.dart';

class CustomerReviewScreen extends StatelessWidget {
  const CustomerReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.customerReview.tr),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: EdgeInsets.all(16.w),
          itemCount: 8,
          separatorBuilder: (context, index) => Gap(12.h),
          itemBuilder: (context, index) => _buildReviewCard(context: context),
        ),
      ),
    );
  }

  Widget _buildReviewCard({required BuildContext context}) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.04,
            ), // Slightly increased opacity for visibility
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: AppColors.bgSecondaryButtonColor.withValues(alpha: 0.5),
        ), // Added subtle border
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundImage: const NetworkImage(
                  'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200',
                ),
              ),
              Gap(12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ann Smith', style: context.titleMedium),
                  Text('24-10-2025', style: context.bodySmall),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  Text('5.0', style: context.titleMedium),
                  Gap(4.w),
                  Icon(Icons.star, color: Colors.amber, size: 20.r),
                ],
              ),
            ],
          ),
          Gap(12.h),
          Text(
            'Lorem ipsum dolor sit amet consectetur. Felis et lacus ut egestas urna aliquam scelerisque pretium mauris. Risus aliquam varius ut a. In est viverra dui.',
            style: context.bodyMedium,
          ),
        ],
      ),
    );
  }
}
