class ProfessionalInfoModel {
  final bool? success;
  final String? message;
  final Data? data;

  ProfessionalInfoModel({this.success, this.message, this.data});

  factory ProfessionalInfoModel.fromJson(Map<String, dynamic> json) =>
      ProfessionalInfoModel(
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
  final String? address;
  final bool? isVerified;
  final String? id;
  final String? fullName;
  final String? email;
  final String? role;
  final String? status;
  final String? profilePicture;
  final bool? isProfileCompleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? passwordChangedAt;
  final int? v;
  final DriverInfo? driverInfo;
  final Vehicle? vehicle;
  final String? dataId;

  Data({
    this.address,
    this.isVerified,
    this.id,
    this.fullName,
    this.email,
    this.role,
    this.status,
    this.profilePicture,
    this.isProfileCompleted,
    this.createdAt,
    this.updatedAt,
    this.passwordChangedAt,
    this.v,
    this.driverInfo,
    this.vehicle,
    this.dataId,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    address: json["address"],
    isVerified: json["is_verified"],
    id: json["_id"],
    fullName: json["full_name"],
    email: json["email"],
    role: json["role"],
    status: json["status"],
    profilePicture: json["profile_picture"],
    isProfileCompleted: json["is_profile_completed"],
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
    driverInfo: json["driver_info"] == null
        ? null
        : DriverInfo.fromJson(json["driver_info"]),
    vehicle: json["vehicle"] == null ? null : Vehicle.fromJson(json["vehicle"]),
    dataId: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "address": address,
    "is_verified": isVerified,
    "_id": id,
    "full_name": fullName,
    "email": email,
    "role": role,
    "status": status,
    "profile_picture": profilePicture,
    "is_profile_completed": isProfileCompleted,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "password_changed_at": passwordChangedAt?.toIso8601String(),
    "__v": v,
    "driver_info": driverInfo?.toJson(),
    "vehicle": vehicle?.toJson(),
    "id": dataId,
  };
}

class DriverInfo {
  final String? id;
  final String? userId;
  final From? from;
  final From? to;
  final String? driverLicenseNumber;
  final String? licenseImage;
  final List<From>? stops;
  final String? dailyCommuteTime;
  final String? availableForDelivery;
  final String? maxParcelWeight;
  final String? pickupTime;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final String? driverInfoId;

  DriverInfo({
    this.id,
    this.userId,
    this.from,
    this.to,
    this.driverLicenseNumber,
    this.licenseImage,
    this.stops,
    this.dailyCommuteTime,
    this.availableForDelivery,
    this.maxParcelWeight,
    this.pickupTime,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.driverInfoId,
  });

  factory DriverInfo.fromJson(Map<String, dynamic> json) => DriverInfo(
    id: json["_id"],
    userId: json["user_id"],
    from: json["from"] == null ? null : From.fromJson(json["from"]),
    to: json["to"] == null ? null : From.fromJson(json["to"]),
    driverLicenseNumber: json["driver_license_number"],
    licenseImage: json["license_image"],
    stops: json["stops"] == null
        ? []
        : List<From>.from(json["stops"]!.map((x) => From.fromJson(x))),
    dailyCommuteTime: json["daily_commute_time"],
    availableForDelivery: json["available_for_delivery"],
    maxParcelWeight: json["max_parcel_weight"],
    pickupTime: json["pickup_time"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    v: json["__v"],
    driverInfoId: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "user_id": userId,
    "from": from?.toJson(),
    "to": to?.toJson(),
    "driver_license_number": driverLicenseNumber,
    "license_image": licenseImage,
    "stops": stops == null
        ? []
        : List<dynamic>.from(stops!.map((x) => x.toJson())),
    "daily_commute_time": dailyCommuteTime,
    "available_for_delivery": availableForDelivery,
    "max_parcel_weight": maxParcelWeight,
    "pickup_time": pickupTime,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "__v": v,
    "id": driverInfoId,
  };
}

class From {
  final String? address;
  final double? latitude;
  final double? longitude;

  From({this.address, this.latitude, this.longitude});

  factory From.fromJson(Map<String, dynamic> json) => From(
    address: json["address"],
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "address": address,
    "latitude": latitude,
    "longitude": longitude,
  };
}

class Vehicle {
  final String? id;
  final String? userId;
  final String? vehicleType;
  final String? vehicleNumber;
  final String? numberPlateImage;
  final List<String>? vehicleImages;
  final bool? isDeleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  Vehicle({
    this.id,
    this.userId,
    this.vehicleType,
    this.vehicleNumber,
    this.numberPlateImage,
    this.vehicleImages,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
    id: json["_id"],
    userId: json["user_id"],
    vehicleType: json["vehicle_type"],
    vehicleNumber: json["vehicle_number"],
    numberPlateImage: json["number_plate_image"],
    vehicleImages: json["vehicle_images"] == null
        ? []
        : List<String>.from(json["vehicle_images"]!.map((x) => x)),
    isDeleted: json["is_deleted"],
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
    "user_id": userId,
    "vehicle_type": vehicleType,
    "vehicle_number": vehicleNumber,
    "number_plate_image": numberPlateImage,
    "vehicle_images": vehicleImages == null
        ? []
        : List<dynamic>.from(vehicleImages!.map((x) => x)),
    "is_deleted": isDeleted,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "__v": v,
  };
}
