import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:delivery_app/share/widgets/network_image/custom_network_image.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import '../model/parcel_model.dart';

class ParcelCardList extends StatelessWidget {
  final ParcelModel parcel;
  final VoidCallback? onChatTap;
  final VoidCallback? onReviewTap;
  final VoidCallback? onRefundTap;
  final VoidCallback? onTrackLiveTap;
  final VoidCallback? onTap;

  const ParcelCardList({
    super.key,
    required this.parcel,
    this.onChatTap,
    this.onReviewTap,
    this.onRefundTap,
    this.onTrackLiveTap,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
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
        child: Column(
          children: [
            Stack(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: CustomNetworkImage(
                        imageUrl: parcel.imageUrl,
                        height: 80.h,
                        width: 100.w,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    // Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 16.h), // Space for badge
                          _buildDetailRow('Parcel ID', parcel.parcelId),
                          _buildDetailRow('Parcel Name', parcel.parcelName),
                          _buildDetailRow('Size', parcel.size),
                          _buildDetailRow(
                            'Price',
                            '\$${parcel.price.toStringAsFixed(2)}',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Status Badge
                Positioned(right: 0, top: 0, child: _buildStatusBadge()),
              ],
            ),
            SizedBox(height: 12.h),
            // Action Buttons
            isButtonsVisible()
                ? _buildActionButtons()
                : const SizedBox.shrink(),
          ],
        ),
      ),
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

  Widget _buildStatusBadge() {
    Color badgeColor = Colors.grey;
    String statusText = '';

    switch (parcel.status) {
      case ParcelStatus.pending:
        badgeColor = AppColors.orangeSecondaryAccentColorNormal;
        statusText = 'Pending';
        break;
      case ParcelStatus.ongoing:
        badgeColor = AppColors.orangeSecondaryAccentColorNormal;
        statusText = 'Ongoing Parcel';
        break;
      case ParcelStatus.completed:
        badgeColor = AppColors.success; // Or greenTextColor if preferred
        statusText = 'Completed Parcel';
        break;
      case ParcelStatus.reject:
        badgeColor = AppColors.redColor;
        statusText = 'Reject';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(8.r),
          bottomLeft: Radius.circular(8.r),
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

  bool isButtonsVisible() {
    // Checking if we should show any buttons row at all
    return true;
  }

  Widget _buildActionButtons() {
    List<Widget> buttons = [];

    switch (parcel.status) {
      case ParcelStatus.pending:
        buttons.add(
          _buildButton(
            label: 'Chat',
            icon: Icons.chat_bubble_outline,
            onTap: onChatTap,
          ),
        );
        break;
      case ParcelStatus.ongoing:
        buttons.add(
          _buildButton(
            label: 'Chat',
            icon: Icons.chat_bubble_outline,
            onTap: onChatTap,
          ),
        );
        buttons.add(SizedBox(width: 8.w));
        buttons.add(
          _buildButton(
            label: 'Refund',
            icon: Icons.undo,
            onTap: onRefundTap,
            color: AppColors.orangeSecondaryAccentColorNormal,
          ),
        );
        buttons.add(SizedBox(width: 8.w));
        buttons.add(
          _buildButton(
            label: 'Track Live',
            icon: Icons.location_on,
            onTap: onTrackLiveTap,
            color: AppColors.redColor,
          ),
        );
        break;
      case ParcelStatus.completed:
        buttons.add(
          _buildButton(
            label: 'Chat',
            icon: Icons.chat_bubble_outline,
            onTap: onChatTap,
          ),
        );
        buttons.add(SizedBox(width: 8.w));
        buttons.add(
          _buildButton(label: 'Add Review', icon: null, onTap: onReviewTap),
        );
        break;
      case ParcelStatus.reject:
        buttons.add(
          _buildButton(
            label: 'Chat',
            icon: Icons.chat_bubble_outline,
            onTap: onChatTap,
          ),
        );
        buttons.add(SizedBox(width: 8.w));
        buttons.add(
          _buildButton(label: 'Add Review', icon: null, onTap: onReviewTap),
        );
        break;
    }

    return Row(mainAxisAlignment: MainAxisAlignment.end, children: buttons);
  }

  Widget _buildButton({
    required String label,
    IconData? icon,
    VoidCallback? onTap,
    Color color = AppColors.primaryColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: color),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14.sp, color: color),
              SizedBox(width: 4.w),
            ],
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
