class CommuterModel {
  final int id;
  final String name;
  final String vehicleType;
  final double rating;
  final int deliveryCount;
  final String image;

  // Profile Details
  final String fromLocation;
  final String toLocation;
  final String stops;
  final String schedule;
  final String carNumber;
  final String numberPlateImage;
  final String dailyCommuteTime;
  final String availability;
  final String maxParcelWeight;
  final String parcelSize;
  final String preferredPickupPoints;
  final String notes;
  final List<String> carImages;

  CommuterModel({
    required this.id,
    required this.name,
    required this.vehicleType,
    required this.rating,
    required this.deliveryCount,
    required this.image,
    this.fromLocation = "Uttara, Dhaka",
    this.toLocation = "Motijheel, Dhaka",
    this.stops = "Banani, Gulshan, Paltan",
    this.schedule = "Daily",
    this.carNumber = "456 MNP",
    this.numberPlateImage = "",
    this.dailyCommuteTime = "8:30 AM → 6:30 PM",
    this.availability = "Morning & Evening",
    this.maxParcelWeight = "15 KG",
    this.parcelSize = "Medium (Up To 60 Cm)",
    this.preferredPickupPoints = "Metro Stations / Bus Stops",
    this.notes = "Can Carry Fragile Items With Care",
    this.carImages = const [],
  });
}
