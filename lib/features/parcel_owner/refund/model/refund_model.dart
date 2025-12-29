enum RefundStatus { pending, approved, rejected, submitted, inReview, none }

class RefundModel {
  final int id;
  final String parcelId;
  final String parcelName;
  final String date;
  final String imageUrl;
  final RefundStatus status;

  RefundModel({
    required this.id,
    required this.parcelId,
    required this.parcelName,
    required this.date,
    required this.status,
    this.imageUrl =
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT2Qp8paJgXVKLyyJkx4N7TOlv5izREplTlXw&s',
  });
}
