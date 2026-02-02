import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:delivery_app/features/other/controller/other_controller.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:delivery_app/share/widgets/loading/loading_widget.dart';
import 'package:delivery_app/utils/app_strings/app_strings.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:delivery_app/utils/enum/app_enum.dart';
import 'package:delivery_app/share/widgets/no_internet/error_card.dart';
import 'package:delivery_app/share/widgets/no_internet/no_data_card.dart';
import 'package:delivery_app/share/widgets/no_internet/no_internet_card.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  State<TermsAndConditionsScreen> createState() =>
      _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  final controller = Get.find<OtherController>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getTermsCondition();
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
        title: Text(AppStrings.termsAndCondition.tr),
        centerTitle: true,
      ),
      body: Obx(() {
        switch (controller.termsLoading.value) {
          case ApiStatus.loading:
            return const LoadingWidget();
          case ApiStatus.internetError:
            return NoInternetCard(onTap: () => controller.getTermsCondition());
          case ApiStatus.error:
            return ErrorCard(onTap: () => controller.getTermsCondition());
          case ApiStatus.noDataFound:
            return NoDataCard(onTap: () => controller.getTermsCondition());
          case ApiStatus.completed:
            final data = controller.termsConditionsData.value.data;
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
