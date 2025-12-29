import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:delivery_app/share/widgets/network_image/custom_network_image.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:delivery_app/utils/extension/base_extension.dart';
import '../model/refund_model.dart';

class RefundCard extends StatelessWidget {
  final RefundModel refundItem;
  final VoidCallback? onRefundTap;

  const RefundCard({super.key, required this.refundItem, this.onRefundTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.primaryColor.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: CustomNetworkImage(
                  imageUrl: refundItem.imageUrl,
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
                    SizedBox(height: 12.h), // Space for top alignment if needed
                    _buildDetailRow(context, 'Parcel ID', refundItem.parcelId),
                    _buildDetailRow(
                      context,
                      'Parcel Name',
                      refundItem.parcelName,
                    ),
                    _buildDetailRow(context, 'Date', refundItem.date),
                    SizedBox(height: 8.h),
                    _buildRefundButton(context),
                  ],
                ),
              ),
            ],
          ),
          // Status Badge
          if (refundItem.status != RefundStatus.none)
            Positioned(right: 0, top: 0, child: _buildStatusBadge(context)),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: RichText(
        text: TextSpan(
          text: '$label: ',
          style: context.bodySmall.copyWith(color: AppColors.primaryColor),
          children: [
            TextSpan(text: value, style: context.bodySmall.copyWith()),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    Color badgeColor = Colors.grey;
    String statusText = '';
    Color textColor = Colors.white;

    switch (refundItem.status) {
      case RefundStatus.pending:
        badgeColor = Color(0xFFA5920D); // Gold/Dark Yellow
        statusText = 'Pending';
        break;
      case RefundStatus.approved:
        badgeColor = Color(0xFF1F6E8C); // Dark Blue/Teal
        statusText = 'Approved';
        break;
      case RefundStatus.rejected:
        badgeColor = AppColors.redColor;
        statusText = 'Rejected';
        break;
      case RefundStatus.submitted:
        badgeColor = Color(0xFF8DA3B3); // Greyish Blue
        statusText = 'Submitted';
        break;
      case RefundStatus.inReview:
        badgeColor = Color(0xFFE0D8C3); // Beige/Light Brown
        statusText = 'In Review';
        textColor = Colors.brown;
        break;
      case RefundStatus.none:
        return SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(8.r),
          bottomLeft: Radius.circular(8.r),
        ),
      ),
      child: Text(
        statusText,
        style: context.bodySmall.copyWith(
          color: textColor,
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildRefundButton(BuildContext context) {
    return InkWell(
      onTap: onRefundTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: Color(0xFFA5920D),
          ), // Gold color matching design
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.undo, size: 14.sp, color: Color(0xFFA5920D)),
            SizedBox(width: 4.w),
            Text(
              'Refund',
              style: context.bodySmall.copyWith(
                color: const Color(0xFFA5920D),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
