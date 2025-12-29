import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:delivery_app/utils/extension/base_extension.dart';

class RecentDeliveryList extends StatelessWidget {
  const RecentDeliveryList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> recentParcels = [
      {
        "id": "112222",
        "name": "Medicine",
        "size": "Small",
        "image": "https://cdn-icons-png.flaticon.com/512/883/883407.png",
      },
      {
        "id": "112222",
        "name": "Electronics",
        "size": "Small",
        "image": "https://cdn-icons-png.flaticon.com/512/3659/3659899.png",
      },
      {
        "id": "112222",
        "name": "Gifts",
        "size": "Small",
        "image": "https://cdn-icons-png.flaticon.com/512/4213/4213958.png",
      },
    ];

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: recentParcels.length,
      separatorBuilder: (context, index) => Gap(12.h),
      itemBuilder: (context, index) {
        final parcel = recentParcels[index];
        return Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: AppColors.primaryColor.withValues(alpha: 0.1),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 70.w,
                height: 70.w,
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8.r),
                  image: DecorationImage(
                    image: NetworkImage(parcel['image']),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Gap(12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          "Completed Parcel",
                          style: context.labelMedium.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      "Parcel ID: ${parcel['id']}",
                      style: context.labelMedium.copyWith(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Gap(4.h),
                    RichText(
                      text: TextSpan(
                        text: "Parcel Name: ",
                        style: context.bodySmall.copyWith(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: parcel['name'],
                            style: context.bodySmall.copyWith(
                              color: AppColors.grayTextSecondaryColor,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: "Size: ",
                        style: context.bodySmall.copyWith(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: parcel['size'],
                            style: context.bodySmall.copyWith(
                              color: AppColors.grayTextSecondaryColor,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
