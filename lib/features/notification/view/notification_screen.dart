import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:delivery_app/utils/app_strings/app_strings.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:delivery_app/features/notification/controller/notification_controller.dart';
import 'package:delivery_app/features/notification/model/notification_model.dart';
import 'package:delivery_app/share/widgets/loading/loading_widget.dart';
import 'package:delivery_app/share/widgets/no_internet/error_card.dart';
import 'package:delivery_app/share/widgets/no_internet/no_data_card.dart';
import 'package:delivery_app/helper/date_converter/date_converter.dart';
import 'package:delivery_app/features/notification/widgets/notification_item.dart'
    as widget_item;

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late final NotificationController notifyController;
  final PagingController<int, NotificationItem> pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    notifyController = Get.put(NotificationController());
    pagingController.addPageRequestListener((pageKey) {
      notifyController.getNotify(
        pageKey: pageKey,
        pagingController: pagingController,
      );
    });
  }

  @override
  void dispose() {
    pagingController.dispose();
    Get.delete<NotificationController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(AppStrings.notification.tr),
        centerTitle: true,
        scrolledUnderElevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          pagingController.refresh();
        },
        child: CustomScrollView(
          slivers: [
            PagedSliverList<int, NotificationItem>(
              pagingController: pagingController,
              builderDelegate: PagedChildBuilderDelegate<NotificationItem>(
                itemBuilder: (context, notification, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: 16.h,
                      left: 16.w,
                      right: 16.w,
                      top: index == 0 ? 16.h : 0,
                    ),
                    child: widget_item.NotificationItem(
                      title: notification.title ?? "Notification",
                      body: notification.message ?? "",
                      date: notification.createdAt == null
                          ? "Just now"
                          : DateConverter.timeAgo(notification.createdAt!),
                    ),
                  );
                },
                firstPageErrorIndicatorBuilder: (context) => SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Center(
                    child: ErrorCard(onTap: () => pagingController.refresh()),
                  ),
                ),
                noItemsFoundIndicatorBuilder: (context) => SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Center(
                    child: NoDataCard(
                      onTap: () => pagingController.refresh(),
                      title: "No Notifications Found",
                    ),
                  ),
                ),
                firstPageProgressIndicatorBuilder: (context) => SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: const Center(child: LoadingWidget()),
                ),
                newPageProgressIndicatorBuilder: (context) => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: LoadingWidget(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
