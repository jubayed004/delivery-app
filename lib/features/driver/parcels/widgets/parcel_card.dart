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
  final VoidCallback onTap;

  const ParcelCard({
    super.key,
    required this.status,
    required this.parcelId,
    required this.parcelName,
    required this.size,
    required this.price,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.primaryColor.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          clipBehavior: Clip.hardEdge,
          child: Padding(
            padding: EdgeInsets.only(
              left: 12.r,
              right: 12.r,
              top: 24.r,
              bottom: 12.r,
            ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: onTap,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: CustomNetworkImage(
                          imageUrl: imageUrl,
                          width: 100.w,
                          height: 80.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      // Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDetailRow("Parcel ID", parcelId),
                            _buildDetailRow("Parcel Name", parcelName),
                            _buildDetailRow("Size", size),
                            _buildDetailRow("Price", "\$$price"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(12.h),
                // Actions
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: _buildActionButtons(context),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Status Badge - Positioned at top-right corner
        Positioned(top: 0, right: 0, child: _buildStatusBadge(status)),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: RichText(
        text: TextSpan(
          text: '$label: ',
          style: TextStyle(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 12.sp,
          ),
          children: [
            TextSpan(
              text: value,
              style: TextStyle(
                color: Colors.grey[700],
                fontWeight: FontWeight.normal,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color badgeColor;
    String statusText;

    if (status == "Ongoing") {
      badgeColor = AppColors.orangeSecondaryAccentColorNormal;
      statusText = 'Ongoing Parcel';
    } else {
      // Completed
      badgeColor = AppColors.success;
      statusText = 'Completed';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(12.r),
          bottomLeft: Radius.circular(12.r),
        ),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  List<Widget> _buildActionButtons(BuildContext context) {
    List<Widget> buttons = [];

    // Chat button - available for both statuses
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

    // Ongoing specific buttons
    if (status == "Ongoing") {
      buttons.add(
        _ActionButton(
          label: "Track Live",
          icon: Icons.location_on,
          isOutlined: true,
          color: Colors.red,
          onTap: () {},
        ),
      );
      buttons.add(Gap(8.w));
      buttons.add(
        _ActionButton(
          label: "Confirm",
          icon: Icons.check_circle_outline,
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
