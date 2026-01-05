import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:delivery_app/core/router/route_path.dart';
import 'package:delivery_app/core/router/routes.dart';
import 'package:delivery_app/share/widgets/network_image/custom_network_image.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:delivery_app/utils/extension/base_extension.dart';

class ParcelCard extends StatelessWidget {
  final String status;
  final String parcelId;
  final String parcelName;
  final String size;
  final String price;
  final String imageUrl;

  const ParcelCard({
    super.key,
    required this.status,
    required this.parcelId,
    required this.parcelName,
    required this.size,
    required this.price,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: CustomNetworkImage(
                  imageUrl: imageUrl,
                  width: 100.w,
                  height: 100.w,
                  fit: BoxFit.cover,
                ),
              ),
              Gap(12.w),
              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            "Parcel ID:$parcelId",
                            style: context.bodyMedium.copyWith(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        _buildStatusBadge(status),
                      ],
                    ),
                    Text(
                      "Parcel Name: $parcelName",
                      style: context.bodyMedium.copyWith(
                        color: AppColors.secondPrimaryColor,
                      ),
                    ),
                    Text(
                      "Size: $size",
                      style: context.bodyMedium.copyWith(
                        color: AppColors.secondPrimaryColor,
                      ),
                    ),
                    Text(
                      "Price : \$$price",
                      style: context.bodyMedium.copyWith(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gap(12.h),
          // Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: _buildActionButtons(context),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    if (status == "Ongoing") {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: Text(
          "Ongoing Parcel",
          style: TextStyle(color: Colors.white, fontSize: 10.sp),
        ),
      );
    } else if (status == "Completed") {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: Color(0xFF1B4D3E), // Dark Green
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: Text(
          "Completed",
          style: TextStyle(color: Colors.white, fontSize: 10.sp),
        ),
      );
    } else if (status == "Reject") {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: Text(
          "Reject",
          style: TextStyle(color: Colors.white, fontSize: 10.sp),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {},
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.red),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.location_on, color: Colors.red, size: 12.r),
              Gap(4.w),
              Text(
                "Track Live",
                style: TextStyle(color: Colors.red, fontSize: 10.sp),
              ),
            ],
          ),
        ),
      );
    }
  }

  List<Widget> _buildActionButtons(BuildContext context) {
    List<Widget> buttons = [];
    buttons.add(
      _ActionButton(
        label: "Chat",
        icon: Icons.chat_bubble_outline,
        isOutlined: true,
        color: AppColors.primaryColor,
        onTap: () {
          AppRouter.route.pushNamed(RoutePath.chatScreen);
        },
      ),
    );
    buttons.add(Gap(8.w));
    if (status == "Pending") {
      buttons.add(
        _ActionButton(
          label: "Accept",
          color: AppColors.primaryColor,
          textColor: Colors.white,
          onTap: () {},
        ),
      );
      buttons.add(Gap(8.w));
      buttons.add(
        _ActionButton(
          label: "Reject",
          color: Colors.red,
          textColor: Colors.white,
          onTap: () {},
        ),
      );
    } else if (status == "Ongoing") {
      buttons.add(
        _ActionButton(
          label: "Track Live",
          icon: Icons.location_on,
          isOutlined: true,
          color: Colors.red,
          onTap: () {},
        ),
      );
    } else if (status == "Completed") {
      buttons.add(
        _ActionButton(
          label: "Confirm",
          icon: Icons.logout,
          isOutlined: true,
          color: Colors.green,
          onTap: () {
            AppRouter.route.pushNamed(RoutePath.transactionScreen);
          },
        ),
      );
    }
    return buttons;
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color color;
  final Color? textColor;
  final bool isOutlined;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    this.icon,
    required this.color,
    this.textColor,
    this.isOutlined = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isOutlined ? Colors.transparent : color,
          borderRadius: BorderRadius.circular(8.r),
          border: isOutlined ? Border.all(color: color) : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16.r, color: isOutlined ? color : textColor),
              Gap(4.w),
            ],
            Text(
              label,
              style: context.bodyMedium.copyWith(
                color: isOutlined ? color : (textColor ?? Colors.white),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
