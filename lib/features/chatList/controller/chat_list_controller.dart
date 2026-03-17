import 'package:delivery_app/core/di/injection.dart';
import 'package:delivery_app/core/service/datasource/local/local_service.dart';
import 'package:delivery_app/core/service/datasource/remote/api_client.dart';
import 'package:delivery_app/core/service/datasource/remote/socket_service.dart';
import 'package:delivery_app/features/chatList/model/chat_list_model.dart';
import 'package:delivery_app/utils/api_urls/api_urls.dart';
import 'package:delivery_app/utils/config/app_config.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ChatListController extends GetxController {
  final ApiClient apiClient = sl<ApiClient>();
  final LocalService localService = sl<LocalService>();
  final PagingController<int, ConversationItems> pagingController =
      PagingController(firstPageKey: 1);
  final RxString userId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    pagingController.addPageRequestListener((pageKey) {
      getAllConversation(pageKey: pageKey);
    });
  }

  Future<void> getAllConversation({required int pageKey}) async {
    try {
      final resp = await apiClient
          .get(url: ApiUrls.getConversation(pageKey: pageKey))
          .timeout(const Duration(seconds: 15));
      AppConfig.logger.d(resp.data);
      if (resp.statusCode == 200) {
        final data = ChatListModel.fromJson(resp.data);
        AppConfig.logger.d(resp.data);
        final items = data.data?.modifiedData ?? [];
        final totalPages = data.data?.meta?.totalPages ?? 0;
        final isLastPage = pageKey >= totalPages;
        if (isLastPage) {
          pagingController.appendLastPage(items);
        } else {
          pagingController.appendPage(items, pageKey + 1);
        }
      } else {
        pagingController.error = 'Failed to load conversations';
      }
    } catch (e) {
      pagingController.error = e;
    }
  }

  void listenForChatListUpdates({
    required PagingController<int, ConversationItems> pagingController,
  }) {
    SocketApi.socket?.off('update_chat_list');

    SocketApi.socket?.on('update_chat_list', (data) {
      pagingController.refresh();
    });
  }

  Future<void> readTheMessage({required String chatId}) async {
    try {
      final resp = await apiClient
          .patch(
            url: ApiUrls.readTheMessage(id: chatId),
            body: {"chat_id": chatId},
          )
          .timeout(const Duration(seconds: 15));
      AppConfig.logger.d(resp.data);
      if (resp.statusCode == 200) {
        AppConfig.logger.d(resp.data);
      } else {
        AppConfig.logger.e("Failed to read the message");
      }
    } catch (e) {
      AppConfig.logger.e("Error reading the message: $e");
    }
  }

  @override
  void onClose() {
    pagingController.dispose();
    super.onClose();
  }
}
