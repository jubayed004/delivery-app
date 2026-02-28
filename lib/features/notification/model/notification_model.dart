class NotificationsModel {
  final bool? success;
  final String? message;
  final Meta? meta;
  final List<NotificationItem>? data;

  NotificationsModel({this.success, this.message, this.meta, this.data});

  factory NotificationsModel.fromJson(Map<String, dynamic> json) =>
      NotificationsModel(
        success: json["success"],
        message: json["message"],
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
        data: json["data"] == null
            ? []
            : List<NotificationItem>.from(
                json["data"]!.map((x) => NotificationItem.fromJson(x)),
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

class NotificationItem {
  final String? id;
  final UserId? userId;
  final String? type;
  final String? title;
  final String? message;
  final String? status;
  final String? priority;
  final ParcelId? parcelId;
  final String? actionUrl;
  final Data? data;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? datumId;

  NotificationItem({
    this.id,
    this.userId,
    this.type,
    this.title,
    this.message,
    this.status,
    this.priority,
    this.parcelId,
    this.actionUrl,
    this.data,
    this.createdAt,
    this.updatedAt,
    this.datumId,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) =>
      NotificationItem(
        id: json["_id"],
        userId: json["user_id"] == null
            ? null
            : UserId.fromJson(json["user_id"]),
        type: json["type"],
        title: json["title"],
        message: json["message"],
        status: json["status"],
        priority: json["priority"],
        parcelId: json["parcel_id"] == null
            ? null
            : ParcelId.fromJson(json["parcel_id"]),
        actionUrl: json["action_url"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        datumId: json["id"],
      );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "user_id": userId?.toJson(),
    "type": type,
    "title": title,
    "message": message,
    "status": status,
    "priority": priority,
    "parcel_id": parcelId?.toJson(),
    "action_url": actionUrl,
    "data": data?.toJson(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "id": datumId,
  };
}

class Data {
  final String? parcelName;
  final String? driverId;

  Data({this.parcelName, this.driverId});

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(parcelName: json["parcel_name"], driverId: json["driver_id"]);

  Map<String, dynamic> toJson() => {
    "parcel_name": parcelName,
    "driver_id": driverId,
  };
}

class ParcelId {
  final String? id;
  final String? parcelId;
  final String? parcelName;
  final String? status;
  final String? parcelIdId;

  ParcelId({
    this.id,
    this.parcelId,
    this.parcelName,
    this.status,
    this.parcelIdId,
  });

  factory ParcelId.fromJson(Map<String, dynamic> json) => ParcelId(
    id: json["_id"],
    parcelId: json["parcel_id"],
    parcelName: json["parcel_name"],
    status: json["status"],
    parcelIdId: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "parcel_id": parcelId,
    "parcel_name": parcelName,
    "status": status,
    "id": parcelIdId,
  };
}

class UserId {
  final String? id;
  final String? fullName;
  final String? email;
  final String? userIdId;

  UserId({this.id, this.fullName, this.email, this.userIdId});

  factory UserId.fromJson(Map<String, dynamic> json) => UserId(
    id: json["_id"],
    fullName: json["full_name"],
    email: json["email"],
    userIdId: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "full_name": fullName,
    "email": email,
    "id": userIdId,
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
