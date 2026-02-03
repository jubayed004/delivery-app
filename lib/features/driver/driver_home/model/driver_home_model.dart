class DriverHomeModel {
  final bool? success;
  final String? message;
  final List<ParcelInformation>? data;

  DriverHomeModel({this.success, this.message, this.data});

  factory DriverHomeModel.fromJson(Map<String, dynamic> json) =>
      DriverHomeModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null || json["data"]["data"] == null
            ? []
            : List<ParcelInformation>.from(
                json["data"]["data"]!.map((x) => ParcelInformation.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class ParcelInformation {
  final String? id;
  final String? parcelId;
  final String? userId;
  final String? parcelName;
  final String? size;
  final String? vehicleType;
  final double? weight;
  final Location? pickupLocation;
  final Location? handoverLocation;
  final String? priority;
  final DateTime? date;
  final String? time;
  final List<String>? parcelImages;
  final String? receiverName;
  final String? receiverPhone;
  final String? senderRemarks;
  final String? status;
  final int? finalPrice;
  final String? priceStatus;
  final dynamic rejectionReason;
  final dynamic acceptedBy;
  final dynamic acceptedAt;
  final dynamic completedAt;
  final dynamic stripeCheckoutSessionId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final DistanceInfo? distanceInfo;

  ParcelInformation({
    this.id,
    this.parcelId,
    this.userId,
    this.parcelName,
    this.size,
    this.vehicleType,
    this.weight,
    this.pickupLocation,
    this.handoverLocation,
    this.priority,
    this.date,
    this.time,
    this.parcelImages,
    this.receiverName,
    this.receiverPhone,
    this.senderRemarks,
    this.status,
    this.finalPrice,
    this.priceStatus,
    this.rejectionReason,
    this.acceptedBy,
    this.acceptedAt,
    this.completedAt,
    this.stripeCheckoutSessionId,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.distanceInfo,
  });

  factory ParcelInformation.fromJson(Map<String, dynamic> json) =>
      ParcelInformation(
        id: json["_id"],
        parcelId: json["parcel_id"],
        userId: json["user_id"],
        parcelName: json["parcel_name"],
        size: json["size"],
        vehicleType: json["vehicle_type"],
        weight: json["weight"]?.toDouble(),
        pickupLocation: json["pickup_location"] == null
            ? null
            : Location.fromJson(json["pickup_location"]),
        handoverLocation: json["handover_location"] == null
            ? null
            : Location.fromJson(json["handover_location"]),
        priority: json["priority"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        time: json["time"],
        parcelImages: json["parcel_images"] == null
            ? []
            : List<String>.from(json["parcel_images"]!.map((x) => x)),
        receiverName: json["receiver_name"],
        receiverPhone: json["receiver_phone"],
        senderRemarks: json["sender_remarks"],
        status: json["status"],
        finalPrice: json["final_price"],
        priceStatus: json["price_status"],
        rejectionReason: json["rejection_reason"],
        acceptedBy: json["accepted_by"],
        acceptedAt: json["accepted_at"],
        completedAt: json["completed_at"],
        stripeCheckoutSessionId: json["stripe_checkout_session_id"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        distanceInfo: json["distance_info"] == null
            ? null
            : DistanceInfo.fromJson(json["distance_info"]),
      );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "parcel_id": parcelId,
    "user_id": userId,
    "parcel_name": parcelName,
    "size": size,
    "vehicle_type": vehicleType,
    "weight": weight,
    "pickup_location": pickupLocation?.toJson(),
    "handover_location": handoverLocation?.toJson(),
    "priority": priority,
    "date":
        "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
    "time": time,
    "parcel_images": parcelImages == null
        ? []
        : List<dynamic>.from(parcelImages!.map((x) => x)),
    "receiver_name": receiverName,
    "receiver_phone": receiverPhone,
    "sender_remarks": senderRemarks,
    "status": status,
    "final_price": finalPrice,
    "price_status": priceStatus,
    "rejection_reason": rejectionReason,
    "accepted_by": acceptedBy,
    "accepted_at": acceptedAt,
    "completed_at": completedAt,
    "stripe_checkout_session_id": stripeCheckoutSessionId,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "distance_info": distanceInfo?.toJson(),
  };
}

class DistanceInfo {
  final String? parcelActualDistance;

  DistanceInfo({this.parcelActualDistance});

  factory DistanceInfo.fromJson(Map<String, dynamic> json) =>
      DistanceInfo(parcelActualDistance: json["parcel_actual_distance"]);

  Map<String, dynamic> toJson() => {
    "parcel_actual_distance": parcelActualDistance,
  };
}

class Location {
  final String? address;
  final double? latitude;
  final double? longitude;

  Location({this.address, this.latitude, this.longitude});

  factory Location.fromJson(Map<String, dynamic> json) => Location(
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
