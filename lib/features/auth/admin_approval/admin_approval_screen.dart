import 'package:delivery_app/core/di/injection.dart';
import 'package:delivery_app/core/service/datasource/local/local_service.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:delivery_app/utils/extension/base_extension.dart';
import 'package:delivery_app/share/widgets/button/custom_button.dart';
import 'package:delivery_app/core/router/route_path.dart';
import 'package:delivery_app/core/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AdminApprovalScreen extends StatefulWidget {
  const AdminApprovalScreen({super.key});

  @override
  State<AdminApprovalScreen> createState() => _AdminApprovalScreenState();
}

class _AdminApprovalScreenState extends State<AdminApprovalScreen> {
  final LocalService localService = sl();
  String status = "PENDING";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getStatus();
  }

  void _getStatus() async {
    final s = await localService.getStatus();
    setState(() {
      status = s.isEmpty ? "PENDING" : s;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    String title = "Admin Approval Pending";
    String description =
        "Your profile is currently under review by the admin. You will be notified once your account is approved.";
    IconData iconData = Icons.hourglass_empty_rounded;
    Color iconColor = AppColors.primaryColor;

    if (status == "BLOCKED") {
      title = "Account Blocked";
      description =
          "Your account has been blocked by the admin. Please contact support for more information.";
      iconData = Icons.block;
      iconColor = Colors.red;
    } else if (status == "REJECTED") {
      title = "Account Rejected";
      description =
          "Your application has been rejected by the admin. Please contact support for more information.";
      iconData = Icons.cancel;
      iconColor = Colors.red;
    } else if (status == "DELETED") {
      title = "Account Deleted";
      description =
          "Your account has been deleted. Please contact support if you believe this is a mistake.";
      iconData = Icons.delete_forever;
      iconColor = Colors.red;
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Icon(iconData, size: 100.h, color: iconColor),
                    Gap(40.h),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: context.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 24.sp,
                      ),
                    ),
                    Gap(16.h),
                    Text(
                      description,
                      textAlign: TextAlign.center,
                      style: context.bodyMedium.copyWith(
                        color: AppColors.grayTextSecondaryColor,
                      ),
                    ),
                    const Spacer(),
                    CustomButton(
                      text: "Logout",
                      onTap: () async {
                        await localService.logOut();
                        AppRouter.route.goNamed(RoutePath.loginScreen);
                      },
                    ),
                    Gap(20.h),
                  ],
                ),
        ),
      ),
    );
  }
}
