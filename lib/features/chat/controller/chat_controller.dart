import 'dart:io';

import 'package:delivery_app/core/di/injection.dart';
import 'package:delivery_app/core/service/datasource/local/local_service.dart';
import 'package:delivery_app/core/service/datasource/remote/api_client.dart';
import 'package:delivery_app/features/chat/model/chat_model.dart' as model;
import 'package:delivery_app/features/chat/model/chat_model.dart';
import 'package:delivery_app/utils/api_urls/api_urls.dart';
import 'package:delivery_app/utils/config/app_config.dart';
import 'package:delivery_app/utils/multipart/multipart_body.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ChatController extends GetxController {
  final ApiClient apiClient = sl<ApiClient>();
  final LocalService localService = sl<LocalService>();

  var isLoading = false;
  var chatModel = ChatModel().obs;

  Future<void> getChatList({
    required int pageKey,
    required String id,
    required PagingController<int, ChatMessage> pagingController,
  }) async {
    if (isLoading) return;
    isLoading = true;
    try {
      final response = await apiClient.get(
        url: ApiUrls.getMessageForChat(pageKey: pageKey, id: id),
      );
      AppConfig.logger.i("id: $id");
      AppConfig.logger.i(response.data);
      if (response.statusCode == 200) {
        final newData = ChatModel.fromJson(response.data);
        if (pageKey == 1) {
          chatModel.value = newData;
        }
        final newItems = newData.data ?? [];
        if (newItems.isEmpty) {
          pagingController.appendLastPage(newItems);
        } else {
          pagingController.appendPage(newItems, pageKey + 1);
        }
      } else {
        pagingController.error = 'An error occurred';
      }
    } catch (e) {
      AppConfig.logger.e("Error in getChatList: $e");
      pagingController.error = 'An error occurred';
    } finally {
      isLoading = false;
    }
  }

  final ImagePicker _picker = ImagePicker();
  RxList<XFile> selectedImages = <XFile>[].obs;

  Future<void> pickImage() async {
    selectedImages.clear();
    List<XFile> images = await _picker.pickMultiImage(
      imageQuality: 50,
      limit: 6,
    );
    if (images.isNotEmpty) {
      selectedImages.addAll(images);
    }
  }

  Future<void> pickCameraImage() async {
    selectedImages.clear();
    XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    if (image != null) {
      selectedImages.add(image);
    }
  }

  void removeImage(int index) {
    if (index >= 0 && index < selectedImages.length) {
      selectedImages.removeAt(index);
    }
  }

  Future<UploadImage> sendMessage({
    required Map<String, String> body,
    PagingController<int, ChatMessage>? pagingController,
  }) async {
    final token = await localService.getToken();
    try {
      List<MultipartBody> multipartBody = [];

      if (selectedImages.isNotEmpty) {
        for (var image in selectedImages) {
          multipartBody.add(
            MultipartBody(fieldKey: "attachments", file: File(image.path)),
          );
        }
      }

      final response = await apiClient.uploadMultipart(
        url: ApiUrls.sendMessage(),
        files: multipartBody,
        method: 'POST',
        token: token,
        fields: body,
      );
      AppConfig.logger.d(response.data);
      if (response.statusCode == 201) {
        final responseData = UploadImage.fromJson(response.data);

        // // Optimistically add to the beginning of the list to show immediately
        // if (pagingController != null && responseData.data != null) {
        //   final originalSender = responseData.data!.senderId;
        //   model.SenderId? convertedSender;

        //   if (originalSender != null) {
        //     convertedSender = model.SenderId(
        //       id: originalSender.id,
        //       fullName: originalSender.fullName,
        //       profilePicture: originalSender.profilePicture,
        //       senderIdId: originalSender.senderIdId,
        //     );
        //   }

        //   final newChatMessage = model.ChatMessage(
        //     id: responseData.data!.id,
        //     content: responseData.data!.content,
        //     createdAt: responseData.data!.createdAt,
        //     senderId: convertedSender,
        //   );

        //   final itemList = pagingController.itemList ?? [];
        //   pagingController.itemList = [newChatMessage, ...itemList];
        // }

        return responseData;
      } else {
        return UploadImage();
      }
    } catch (e) {
      AppConfig.logger.e("Error sending message: $e");
      return UploadImage();
    }
  }

  RxString userId = "".obs;

  void getUserId() async {
    try {
      userId.value = await localService.getUserId();
    } catch (e) {
      AppConfig.logger.e("Error getting user ID: $e");
    }
  }

  @override
  void onReady() {
    getUserId();
    super.onReady();
  }

  @override
  void onClose() {
    selectedImages.clear();
    super.onClose();
  }
}

class UploadImage {
  final bool? success;
  final String? message;
  final Data? data;

  UploadImage({this.success, this.message, this.data});

  factory UploadImage.fromJson(Map<String, dynamic> json) => UploadImage(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  final String? chatId;
  final SenderId? senderId;
  final String? senderRole;
  final String? content;
  final List<dynamic>? attachments;
  final String? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  Data({
    this.chatId,
    this.senderId,
    this.senderRole,
    this.content,
    this.attachments,
    this.id,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    chatId: json["chat_id"],
    senderId: json["sender_id"] == null
        ? null
        : SenderId.fromJson(json["sender_id"]),
    senderRole: json["sender_role"],
    content: json["content"],
    attachments: json["attachments"] == null
        ? []
        : List<dynamic>.from(json["attachments"]!.map((x) => x)),
    id: json["_id"],
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "chat_id": chatId,
    "sender_id": senderId?.toJson(),
    "sender_role": senderRole,
    "content": content,
    "attachments": attachments == null
        ? []
        : List<dynamic>.from(attachments!.map((x) => x)),
    "_id": id,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}

class SenderId {
  final String? id;
  final String? fullName;
  final String? profilePicture;
  final String? senderIdId;

  SenderId({this.id, this.fullName, this.profilePicture, this.senderIdId});

  factory SenderId.fromJson(Map<String, dynamic> json) => SenderId(
    id: json["_id"],
    fullName: json["full_name"],
    profilePicture: json["profile_picture"],
    senderIdId: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "full_name": fullName,
    "profile_picture": profilePicture,
    "id": senderIdId,
  };
}
