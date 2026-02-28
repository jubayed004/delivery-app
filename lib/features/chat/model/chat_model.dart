class ChatModel {
  final bool? success;
  final String? message;
  final Meta? meta;
  final List<ChatMessage>? data;

  ChatModel({this.success, this.message, this.meta, this.data});

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
    success: json["success"],
    message: json["message"],
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    data: json["data"] == null
        ? []
        : List<ChatMessage>.from(
            json["data"]!.map((x) => ChatMessage.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "meta": meta?.toJson(),
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Meta {
  final int? page;
  final int? limit;
  final int? total;

  Meta({this.page, this.limit, this.total});

  factory Meta.fromJson(Map<String, dynamic> json) =>
      Meta(page: json["page"], limit: json["limit"], total: json["total"]);

  Map<String, dynamic> toJson() => {
    "page": page,
    "limit": limit,
    "total": total,
  };
}

class ChatMessage {
  final String? id;
  final String? chatId;
  final SenderId? senderId;
  final String? senderRole;
  final String? content;
  final List<dynamic>? attachments;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final bool? isRead;

  ChatMessage({
    this.id,
    this.chatId,
    this.senderId,
    this.senderRole,
    this.content,
    this.attachments,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.isRead,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
    id: json["_id"],
    chatId: json["chat_id"],
    senderId: json["sender_id"] == null
        ? null
        : SenderId.fromJson(json["sender_id"]),
    senderRole: json["sender_role"],
    content: json["content"],
    attachments: json["attachments"] == null
        ? []
        : List<dynamic>.from(json["attachments"]!.map((x) => x)),
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    isRead: json["isRead"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "chat_id": chatId,
    "sender_id": senderId?.toJson(),
    "sender_role": senderRole,
    "content": content,
    "attachments": attachments == null
        ? []
        : List<dynamic>.from(attachments!.map((x) => x)),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "isRead": isRead,
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
