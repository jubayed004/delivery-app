import 'dart:io';
import 'package:delivery_app/core/service/datasource/remote/socket_service.dart';
import 'package:delivery_app/features/chat/model/chat_model.dart';
import 'package:delivery_app/share/widgets/text_field/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:delivery_app/features/chat/controller/chat_controller.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  const ChatScreen({super.key, required this.chatId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final pagingController = PagingController<int, ChatMessage>(firstPageKey: 1);
  final scrollController = ScrollController();
  final messageController = TextEditingController();
  final controller = Get.find<ChatController>();
  final RxBool isSending = false.obs;

  @override
  void initState() {
    super.initState();
    _initializeSocketAndController();
    pagingController.addPageRequestListener((pageKey) async {
      try {
        final newItems = await controller.getChatList(
          pageKey: pageKey,
          id: widget.chatId,
        );
        if (newItems.isEmpty) {
          pagingController.appendLastPage(newItems);
        } else {
          pagingController.appendPage(newItems, pageKey + 1);
        }
      } catch (error) {
        pagingController.error = error;
      }
    });
  }

  Future<void> _initializeSocketAndController() async {
    try {
      await SocketApi.init();
      controller.listenForNewMessages(
        chatId: widget.chatId,
        onNewMessage: (newMessage) {
          if (!mounted) return;
          final currentMessages = pagingController.itemList ?? [];
          if (!currentMessages.any((msg) => msg.id == newMessage.id)) {
            pagingController.itemList = [newMessage, ...currentMessages];
          }
        },
      );
    } catch (e) {
      debugPrint("Socket Error Chat Screen: $e");
    }
  }

  @override
  void dispose() {
    SocketApi.socket?.off('new_message');
    pagingController.dispose();
    scrollController.dispose();
    messageController.dispose();
    super.dispose();
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                Gap(20.h),
                Text(
                  "Select Image Source",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.blackMainTextColor,
                  ),
                ),
                Gap(20.h),
                Row(
                  children: [
                    Expanded(
                      child: _sourceOption(
                        icon: Icons.photo_library_rounded,
                        label: "Gallery",
                        color: AppColors.primaryColor,
                        onTap: () async {
                          Navigator.pop(context);
                          await controller.pickImages();
                        },
                      ),
                    ),
                    Gap(16.w),
                    Expanded(
                      child: _sourceOption(
                        icon: Icons.camera_alt_rounded,
                        label: "Camera",
                        color: Colors.orange,
                        onTap: () async {
                          Navigator.pop(context);
                          await controller.pickCameraImage();
                        },
                      ),
                    ),
                  ],
                ),
                Gap(12.h),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _sourceOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32.sp),
            Gap(8.h),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendMessage() async {
    final hasText = messageController.text.trim().isNotEmpty;
    final hasImages = controller.selectedImages.isNotEmpty;

    if (!hasText && !hasImages) return;

    isSending.value = true;
    final Map<String, String> body = {
      "chat_id": widget.chatId,
      "content": messageController.text.trim(),
    };
    messageController.clear();

    final result = await controller.sendMessage(
      body: body,
    );

    if (result.success == true && result.data != null) {
      if (mounted) {
        final chatMessage = ChatMessage.fromJson(result.data!.toJson());
        final currentMessages = pagingController.itemList ?? [];
        if (!currentMessages.any((msg) => msg.id == chatMessage.id)) {
          pagingController.itemList = [chatMessage, ...currentMessages];
        }
      }
    }

    isSending.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        elevation: 0.5,
        shadowColor: Colors.grey.withValues(alpha: 0.2),
        title: Text(
          "Chat",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
            color: AppColors.blackMainTextColor,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: AppColors.blackMainTextColor),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: PagedListView<int, ChatMessage>(
              pagingController: pagingController,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              reverse: true,
              builderDelegate: PagedChildBuilderDelegate<ChatMessage>(
                itemBuilder: (context, item, index) {
                  return _buildMessageBubble(context, item);
                },
              ),
            ),
          ),

          // Image Preview Strip
          Obx(() {
            if (controller.selectedImages.isEmpty) return const SizedBox.shrink();
            return Container(
              height: 90.h,
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: controller.selectedImages.length,
                separatorBuilder: (_, _) => Gap(8.w),
                itemBuilder: (context, index) {
                  final img = controller.selectedImages[index];
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: Image.file(
                          File(img.path),
                          width: 70.w,
                          height: 70.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 2,
                        right: 2,
                        child: GestureDetector(
                          onTap: () => controller.removeImage(index),
                          child: Container(
                            padding: EdgeInsets.all(2.r),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.close, size: 12.sp, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          }),

          // Input Bar
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppColors.backgroundsLinesColor),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Image picker button
          GestureDetector(
            onTap: _showImageSourceSheet,
            child: Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.image_outlined,
                color: AppColors.primaryColor,
                size: 22.sp,
              ),
            ),
          ),
          Gap(8.w),

          // Text Field
          Expanded(
            child: CustomTextField(
              controller: messageController,
              hintText: "Type a message...",
            ),
          ),
          Gap(8.w),

          // Send button
          Obx(() => GestureDetector(
            onTap: isSending.value ? null : _sendMessage,
            child: Container(
              padding: EdgeInsets.all(11.r),
              decoration: BoxDecoration(
                color: isSending.value
                    ? AppColors.primaryColor.withValues(alpha: 0.5)
                    : AppColors.primaryColor,
                shape: BoxShape.circle,
              ),
              child: isSending.value
                  ? SizedBox(
                      width: 20.r,
                      height: 20.r,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Icon(Icons.send_rounded, color: Colors.white, size: 20.sp),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(BuildContext context, ChatMessage message) {
    return Obx(() {
      final senderId = message.senderId?.id ?? message.senderId?.senderIdId;
      final bool isSender = senderId == controller.userId.value;

      final hasImages =
          message.attachments != null && message.attachments!.isNotEmpty;

      return Padding(
        padding: EdgeInsets.only(bottom: 12.h),
        child: Column(
          crossAxisAlignment:
              isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // Image attachments
            if (hasImages)
              Wrap(
                spacing: 6.w,
                runSpacing: 6.h,
                alignment: isSender ? WrapAlignment.end : WrapAlignment.start,
                children: message.attachments!.map((url) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Image.network(
                      url.toString(),
                      width: 160.w,
                      height: 160.h,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 160.w,
                        height: 160.h,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.broken_image, color: Colors.grey),
                      ),
                    ),
                  );
                }).toList(),
              ),

            // Text bubble (only if there's text)
            if (message.content != null && message.content!.isNotEmpty) ...[
              if (hasImages) Gap(4.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.72,
                ),
                decoration: BoxDecoration(
                  color: isSender
                      ? AppColors.primaryColor
                      : AppColors.bgSecondaryButtonColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.r),
                    topRight: Radius.circular(16.r),
                    bottomLeft: Radius.circular(isSender ? 16.r : 0),
                    bottomRight: Radius.circular(isSender ? 0 : 16.r),
                  ),
                ),
                child: Text(
                  message.content!,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: isSender ? Colors.white : AppColors.blackMainTextColor,
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    });
  }
}
