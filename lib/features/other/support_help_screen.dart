import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:delivery_app/features/other/controller/other_controller.dart';
import 'package:delivery_app/share/widgets/loading/loading_widget.dart';
import 'package:delivery_app/utils/app_strings/app_strings.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:delivery_app/utils/enum/app_enum.dart';
import 'package:delivery_app/share/widgets/no_internet/error_card.dart';
import 'package:delivery_app/share/widgets/no_internet/no_data_card.dart';
import 'package:delivery_app/share/widgets/no_internet/no_internet_card.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportHelpScreen extends StatefulWidget {
  const SupportHelpScreen({super.key});

  @override
  State<SupportHelpScreen> createState() => _SupportHelpScreenState();
}

class _SupportHelpScreenState extends State<SupportHelpScreen> {
  final controller = Get.find<OtherController>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getFaq();
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
        title: Text(AppStrings.supportHelp.tr),
        centerTitle: true,
      ),
      body: Obx(() {
        switch (controller.faqLoading.value) {
          case ApiStatus.loading:
            return const LoadingWidget();
          case ApiStatus.internetError:
            return NoInternetCard(onTap: () => controller.getFaq());
          case ApiStatus.error:
            return ErrorCard(onTap: () => controller.getFaq());
          case ApiStatus.noDataFound:
            return NoDataCard(onTap: () => controller.getFaq());
          case ApiStatus.completed:
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Center(
                    child: Column(
                      children: [
                        const Icon(
                          Icons.support_agent,
                          size: 48,
                          color: AppColors.primaryColor,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          AppStrings.faqs.tr,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.blackMainTextColor,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // FAQ Section
                  Text(
                    "Frequently asked questions".tr,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.blackMainTextColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (controller.faqData.isEmpty)
                    const SizedBox()
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.faqData.length,
                      itemBuilder: (context, index) {
                        final item = controller.faqData[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildFaqTile(
                            item['question'] ?? "",
                            item['answer'] ?? "",
                          ),
                        );
                      },
                    ),
                  const SizedBox(height: 32),

                  // Contact Us Section
                  Text(
                    "Contact Us".tr,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.blackMainTextColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Container(
                  //   padding: const EdgeInsets.all(16),
                  //   decoration: BoxDecoration(
                  //     color: AppColors.white,
                  //     borderRadius: BorderRadius.circular(12),
                  //     boxShadow: [
                  //       BoxShadow(
                  //         // ignore: deprecated_member_use
                  //         color: Colors.black.withOpacity(0.05),
                  //         blurRadius: 10,
                  //         offset: const Offset(0, 4),
                  //       ),
                  //     ],
                  //   ),
                  //   child: Row(
                  //     children: [
                  //       Container(
                  //         padding: const EdgeInsets.all(12),
                  //         decoration: BoxDecoration(
                  //           color: AppColors.backgroundColor,
                  //           borderRadius: BorderRadius.circular(12),
                  //         ),
                  //         child: const Icon(
                  //           Icons.email_outlined,
                  //           color: AppColors.blackMainTextColor,
                  //         ),
                  //       ),
                  //       const SizedBox(width: 16),
                  //       Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Text(
                  //             AppStrings.email.tr,
                  //             style: Theme.of(context).textTheme.bodyMedium
                  //                 ?.copyWith(
                  //                   fontWeight: FontWeight.w600,
                  //                   color: AppColors.blackMainTextColor,
                  //                 ),
                  //           ),
                  //           const SizedBox(height: 4),
                  //           Text(
                  //             "annsmith@gmail.com",
                  //             style: Theme.of(context).textTheme.bodySmall
                  //                 ?.copyWith(
                  //                   color: AppColors.grayTextSecondaryColor,
                  //                 ),
                  //           ),
                  //         ],
                  //       ),
                  //       const Spacer(),
                  //       const Icon(
                  //         Icons.arrow_forward_ios,
                  //         size: 16,
                  //         color: AppColors.grayTextSecondaryColor,
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Card(
                    color: Colors.white,
                    child: InkWell(
                      onTap: () => _openDialScreen(context, "12124567890"),
                      child: ListTile(
                        leading: const Icon(
                          Icons.support_agent,
                          size: 48,
                          color: AppColors.primaryColor,
                        ),
                        title: Text("Call Us (+1-212-456-7890)"),
                        subtitle: Text("Our help line service is active: 24/7"),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // // Message Form Section
                  // Text(
                  //   AppStrings.sendUsAMessage.tr,
                  //   style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  //     fontWeight: FontWeight.bold,
                  //     color: AppColors.blackMainTextColor,
                  //   ),
                  // ),
                  // const SizedBox(height: 16),
                  // CustomTextField(hintText: AppStrings.topic.tr),
                  // const SizedBox(height: 16),
                  // CustomTextField(
                  //   hintText: AppStrings.yourMessage.tr,
                  //   maxLines: 5,
                  // ),
                  // const SizedBox(height: 24),
                  // CustomButton(
                  //   text: AppStrings.sendMessage.tr,
                  //   onTap: () {
                  //     // TODO: Implement send message logic
                  //   },
                  // ),
                  // const SizedBox(height: 24),
                ],
              ),
            );
        }
      }),
    );
  }

  Widget _buildFaqTile(String title, String content) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.blackMainTextColor,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                content,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.grayTextSecondaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openDialScreen(BuildContext context, String phoneNumber) async {
    final Uri dialUri = Uri(scheme: 'tel', path: phoneNumber);

    try {
      if (await canLaunchUrl(dialUri)) {
        bool launched = await launchUrl(
          dialUri,
          mode: LaunchMode.externalApplication,
        );
        if (!launched) {
          _showErrorDialog(context, "Dialer app found but failed to open.");
        }
      } else {
        _showErrorDialog(context, "No dialer app found on this device.");
      }
    } catch (e) {
      _showErrorDialog(context, "Error: ${e.toString()}");
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }
}
