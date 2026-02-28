class ChatListModel {
  final bool? success;
  final String? message;
  final Data? data;

  ChatListModel({this.success, this.message, this.data});

  factory ChatListModel.fromJson(Map<String, dynamic> json) => ChatListModel(
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
  final Meta? meta;
  final List<ConversationItems>? modifiedData;

  Data({this.meta, this.modifiedData});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    modifiedData: json["modifiedData"] == null
        ? []
        : List<ConversationItems>.from(
            json["modifiedData"]!.map((x) => ConversationItems.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "meta": meta?.toJson(),
    "modifiedData": modifiedData == null
        ? []
        : List<dynamic>.from(modifiedData!.map((x) => x.toJson())),
  };
}

class Meta {
  final int? total;
  final int? page;
  final int? limit;
  final int? totalPages;

  Meta({this.total, this.page, this.limit, this.totalPages});

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    total: json["total"],
    page: json["page"],
    limit: json["limit"],
    totalPages: json["totalPages"],
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "page": page,
    "limit": limit,
    "totalPages": totalPages,
  };
}

class ConversationItems {
  final String? id;
  final List<Participant>? participants;
  final List<String>? participantRoles;
  final bool? isSupportChat;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final String? lastMessage;
  final DateTime? lastMessageAt;
  final DateTime? modifiedDatumUpdatedAt;

  ConversationItems({
    this.id,
    this.participants,
    this.participantRoles,
    this.isSupportChat,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.lastMessage,
    this.lastMessageAt,
    this.modifiedDatumUpdatedAt,
  });

  factory ConversationItems.fromJson(Map<String, dynamic> json) =>
      ConversationItems(
        id: json["_id"],
        participants: json["participants"] == null
            ? []
            : List<Participant>.from(
                json["participants"]!.map((x) => Participant.fromJson(x)),
              ),
        participantRoles: json["participant_roles"] == null
            ? []
            : List<String>.from(json["participant_roles"]!.map((x) => x)),
        isSupportChat: json["is_support_chat"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        lastMessage: json["last_message"],
        lastMessageAt: json["last_message_at"] == null
            ? null
            : DateTime.parse(json["last_message_at"]),
        modifiedDatumUpdatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "participants": participants == null
        ? []
        : List<dynamic>.from(participants!.map((x) => x.toJson())),
    "participant_roles": participantRoles == null
        ? []
        : List<dynamic>.from(participantRoles!.map((x) => x)),
    "is_support_chat": isSupportChat,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "last_message": lastMessage,
    "last_message_at": lastMessageAt?.toIso8601String(),
    "updated_at": modifiedDatumUpdatedAt?.toIso8601String(),
  };
}

class Participant {
  final String? id;
  final String? fullName;
  final String? email;
  final String? role;
  final String? profilePicture;

  Participant({
    this.id,
    this.fullName,
    this.email,
    this.role,
    this.profilePicture,
  });

  factory Participant.fromJson(Map<String, dynamic> json) => Participant(
    id: json["_id"],
    fullName: json["full_name"],
    email: json["email"],
    role: json["role"],
    profilePicture: json["profile_picture"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "full_name": fullName,
    "email": email,
    "role": role,
    "profile_picture": profilePicture,
  };
}
