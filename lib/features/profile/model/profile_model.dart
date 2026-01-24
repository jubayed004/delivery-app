class ProfileModel {
  final bool? success;
  final String? message;
  final Data? data;

  ProfileModel({this.success, this.message, this.data});

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
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
  final String? id;
  final String? fullName;
  final String? email;
  final String? role;
  final String? status;
  final String? profilePicture;
  final bool? isProfileCompleted;
  final bool? isVerified;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? passwordChangedAt;
  final int? v;
  final String? address;
  final String? phoneNumber;
  final String? dataId;

  Data({
    this.id,
    this.fullName,
    this.email,
    this.role,
    this.status,
    this.profilePicture,
    this.isProfileCompleted,
    this.isVerified,
    this.createdAt,
    this.updatedAt,
    this.passwordChangedAt,
    this.v,
    this.address,
    this.phoneNumber,
    this.dataId,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["_id"],
    fullName: json["full_name"],
    email: json["email"],
    role: json["role"],
    status: json["status"],
    profilePicture: json["profile_picture"],
    isProfileCompleted: json["is_profile_completed"],
    isVerified: json["is_verified"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    passwordChangedAt: json["password_changed_at"] == null
        ? null
        : DateTime.parse(json["password_changed_at"]),
    v: json["__v"],
    address: json["address"],
    phoneNumber: json["phone_number"],
    dataId: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "full_name": fullName,
    "email": email,
    "role": role,
    "status": status,
    "profile_picture": profilePicture,
    "is_profile_completed": isProfileCompleted,
    "is_verified": isVerified,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "password_changed_at": passwordChangedAt?.toIso8601String(),
    "__v": v,
    "address": address,
    "phone_number": phoneNumber,
    "id": dataId,
  };
}
