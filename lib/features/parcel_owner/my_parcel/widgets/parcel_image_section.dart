import 'package:delivery_app/share/widgets/network_image/custom_network_image.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ParcelImageSection extends StatelessWidget {
  final String? imageUrl;

  const ParcelImageSection({super.key, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250.h,
      width: double.infinity,
      color: AppColors.grayTabBgColor,
      child: CustomNetworkImage(imageUrl: imageUrl ?? "", fit: BoxFit.contain),
    );
  }
}
