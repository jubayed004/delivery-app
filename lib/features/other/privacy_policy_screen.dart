import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:delivery_app/features/other/controller/other_controller.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:delivery_app/share/widgets/loading/loading_widget.dart';
import 'package:delivery_app/utils/app_strings/app_strings.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:delivery_app/share/widgets/no_internet/error_card.dart';
import 'package:delivery_app/share/widgets/no_internet/no_data_card.dart';
import 'package:delivery_app/share/widgets/no_internet/no_internet_card.dart';
import 'package:delivery_app/utils/enum/app_enum.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  final controller = Get.find<OtherController>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getPrivacyPolicy();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(AppStrings.privacyPolicy.tr),
        centerTitle: true,
      ),
      body: Obx(() {
        switch (controller.privacyLoading.value) {
          case ApiStatus.loading:
            return const LoadingWidget();
          case ApiStatus.internetError:
            return NoInternetCard(onTap: () => controller.getPrivacyPolicy());
          case ApiStatus.error:
            return ErrorCard(onTap: () => controller.getPrivacyPolicy());
          case ApiStatus.noDataFound:
            return NoDataCard(onTap: () => controller.getPrivacyPolicy());
          case ApiStatus.completed:
            final data = controller.privacyConditionsData.value.data;
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (data?.updatedAt != null)
                    Text(
                      "Last updated: ${data!.updatedAt!.toLocal().toString().split(' ')[0]}",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.grayTextSecondaryColor,
                      ),
                    ),
                  const SizedBox(height: 16),
                  HtmlWidget(
                    data?.content ?? "",
                    textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.grayTextSecondaryColor,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            );
        }
      }),
    );
  }
}
