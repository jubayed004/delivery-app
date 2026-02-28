class ParcelOwnerReviewModel {
  final bool? success;
  final String? message;
  final int? averageRating;
  final Meta? meta;
  final List<ReviewItem>? data;

  ParcelOwnerReviewModel({
    this.success,
    this.message,
    this.averageRating,
    this.meta,
    this.data,
  });

  factory ParcelOwnerReviewModel.fromJson(Map<String, dynamic> json) =>
      ParcelOwnerReviewModel(
        success: json["success"],
        message: json["message"],
        averageRating: json["average_rating"],
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
        data: json["data"] == null
            ? []
            : List<ReviewItem>.from(
                json["data"]!.map((x) => ReviewItem.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "average_rating": averageRating,
    "meta": meta?.toJson(),
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class ReviewItem {
  final String? id;
  final String? parcelId;
  final CustomerId? customerId;
  final String? driverId;
  final int? rating;
  final String? feedback;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  ReviewItem({
    this.id,
    this.parcelId,
    this.customerId,
    this.driverId,
    this.rating,
    this.feedback,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory ReviewItem.fromJson(Map<String, dynamic> json) => ReviewItem(
    id: json["_id"],
    parcelId: json["parcel_id"],
    customerId: json["customer_id"] == null
        ? null
        : CustomerId.fromJson(json["customer_id"]),
    driverId: json["driver_id"],
    rating: json["rating"],
    feedback: json["feedback"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "parcel_id": parcelId,
    "customer_id": customerId?.toJson(),
    "driver_id": driverId,
    "rating": rating,
    "feedback": feedback,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "__v": v,
  };
}

class CustomerId {
  final String? id;
  final String? fullName;
  final String? profilePicture;
  final String? customerIdId;

  CustomerId({this.id, this.fullName, this.profilePicture, this.customerIdId});

  factory CustomerId.fromJson(Map<String, dynamic> json) => CustomerId(
    id: json["_id"],
    fullName: json["full_name"],
    profilePicture: json["profile_picture"],
    customerIdId: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "full_name": fullName,
    "profile_picture": profilePicture,
    "id": customerIdId,
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
