import 'package:delivery_app/core/router/route_path.dart';
import 'package:delivery_app/features/chatList/controller/chat_list_controller.dart';
import 'package:delivery_app/features/chatList/model/chat_list_model.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:delivery_app/utils/extension/base_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  late final ChatListController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(ChatListController());
  }

  @override
  void dispose() {
    Get.delete<ChatListController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text("Chat"),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            sliver: PagedSliverList<int, ConversationItems>(
              pagingController: _controller.pagingController,
              builderDelegate: PagedChildBuilderDelegate<ConversationItems>(
                itemBuilder: (context, item, index) => _ChatTile(item: item),
                firstPageProgressIndicatorBuilder: (_) => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: CircularProgressIndicator(),
                  ),
                ),
                newPageProgressIndicatorBuilder: (_) => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  ),
                ),
                noItemsFoundIndicatorBuilder: (_) => Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 80.h),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 48.r,
                          color: Colors.grey.shade400,
                        ),
                        Gap(12.h),
                        Text(
                          'No conversations yet',
                          style: context.titleSmall.copyWith(
                            color: AppColors.grayTextSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                firstPageErrorIndicatorBuilder: (_) => Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 80.h),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48.r,
                          color: Colors.redAccent,
                        ),
                        Gap(12.h),
                        Text(
                          'Failed to load chats',
                          style: context.titleSmall.copyWith(
                            color: AppColors.grayTextSecondaryColor,
                          ),
                        ),
                        Gap(12.h),
                        ElevatedButton(
                          onPressed: () =>
                              _controller.pagingController.refresh(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Chat Tile Widget
// ─────────────────────────────────────────────
class _ChatTile extends StatelessWidget {
  const _ChatTile({required this.item});
  final ConversationItems item;

  String get _otherName {
    final participants = item.participants ?? [];
    if (participants.isEmpty) return 'Unknown';

    return participants.first.fullName ?? 'Unknown';
  }

  String get _avatar {
    final participants = item.participants ?? [];
    if (participants.isEmpty) return '';
    return participants.first.profilePicture ?? '';
  }

  String get _lastMessage => item.lastMessage ?? '';

  String get _time {
    final t = item.lastMessageAt ?? item.updatedAt;
    if (t == null) return '';
    final now = DateTime.now();
    final diff = now.difference(t);
    if (diff.inDays >= 1) return '${diff.inDays}d ago';
    if (diff.inHours >= 1) return '${diff.inHours}h ago';
    if (diff.inMinutes >= 1) return '${diff.inMinutes}m ago';
    return 'Just now';
  }

  @override
  Widget build(BuildContext context) {
    print("Last Message: $_lastMessage");
    final nameStyle = context.titleMedium;
    final messageStyle = context.titleSmall.copyWith(
      fontWeight: FontWeight.w500,
      fontSize: 13.sp,
      color: AppColors.grayTextSecondaryColor,
      height: 1.2,
    );
    final timeStyle = context.bodySmall.copyWith(
      color: AppColors.grayTextSecondaryColor,
    );

    return InkWell(
      onTap: () {
        context.pushNamed(RoutePath.chatScreen, extra: item);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade200, width: 1.w),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: _avatar.isNotEmpty
                  ? Image.network(
                      _avatar,
                      width: 50.r,
                      height: 50.r,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _AvatarPlaceholder(),
                    )
                  : _AvatarPlaceholder(),
            ),
            Gap(12.w),

            // Name + Message
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _otherName,
                    style: nameStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Gap(4.h),
                  Text(
                    _lastMessage,
                    style: messageStyle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Gap(10.w),

            // Time + Arrow
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_time, style: timeStyle),
                    Gap(8.w),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14.r,
                      color: AppColors.grayTextSecondaryColor.withValues(
                        alpha: 0.6,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AvatarPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50.r,
      height: 50.r,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Icon(Icons.person, color: Colors.grey.shade400, size: 28.r),
    );
  }
}
