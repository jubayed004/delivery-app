import 'package:delivery_app/features/chat/model/chat_model.dart';
import 'package:delivery_app/share/widgets/text_field/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:delivery_app/features/chat/controller/chat_controller.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ChatScreen extends StatefulWidget {
  final String id;
  const ChatScreen({super.key, required this.id});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final pagingController = PagingController<int, ChatMessage>(firstPageKey: 1);
  final scrollController = ScrollController();
  final messageController = TextEditingController();
  late final ChatController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ChatController(), permanent: false);
    pagingController.addPageRequestListener((pageKey) {
      // Assuming chat id is passed or hardcoded for now, based on user's code
      controller.getChatList(
        pageKey: pageKey,
        id: widget.id,
        pagingController: pagingController,
      );
    });
  }

  @override
  void dispose() {
    pagingController.dispose();
    scrollController.dispose();
    messageController.dispose();
    super.dispose();
    Get.delete<ChatController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        scrolledUnderElevation: 0,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Ann Smith",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.blackMainTextColor,
              ),
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.more_horiz,
                  color: AppColors.blackMainTextColor,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PagedListView<int, ChatMessage>(
              pagingController: pagingController,
              padding: const EdgeInsets.all(16),
              reverse: true,
              builderDelegate: PagedChildBuilderDelegate<ChatMessage>(
                itemBuilder: (context, item, index) {
                  return _buildMessageBubble(context, item);
                },
              ),
            ),
          ),
          _buildMessageInput(context, controller),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(BuildContext context, ChatMessage message) {
    return Obx(() {
      final bool isSender = message.senderId?.id == controller.userId.value;
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: isSender
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              decoration: BoxDecoration(
                color: isSender
                    ? AppColors.primaryColor
                    : AppColors.bgSecondaryButtonColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isSender ? 16 : 0),
                  bottomRight: Radius.circular(isSender ? 0 : 16),
                ),
              ),
              child: Text(
                message.content ?? "",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isSender
                      ? AppColors.white
                      : AppColors.blackMainTextColor,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "", // Formatting time based on message.createdAt can be done if needed
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.grayTextSecondaryColor,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildMessageInput(BuildContext context, ChatController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.backgroundsLinesColor)),
      ),
      child: Row(
        children: [
          Expanded(
            child: CustomTextField(
              controller: messageController,
              hintText: "Enter message...",
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: AppColors.primaryColor),
            onPressed: () {
              Map<String, String> body = {
                "chat_id": widget.id,
                "content": messageController.text,
              };
              if (messageController.text.isNotEmpty) {
                controller.sendMessage(
                  body: body,
                  pagingController: pagingController,
                );
                messageController.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
