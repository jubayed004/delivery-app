import 'package:delivery_app/utils/enum/app_enum.dart';

class ParcelModel {
  final int id;
  final String parcelId;
  final String parcelName;
  final String size;
  final double price;
  final ParcelStatus status;
  final String imageUrl;
  final String weight;
  final String priority;
  final String date;
  final String time;
  final String handoverLocation;
  final String receiverName;
  final String receiverPhone;
  final String senderRemarks;

  ParcelModel({
    required this.id,
    required this.parcelId,
    required this.parcelName,
    required this.size,
    required this.price,
    required this.status,
    this.imageUrl =
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT2Qp8paJgXVKLyyJkx4N7TOlv5izREplTlXw&s',
    this.weight = '1kg',
    this.priority = 'Standard',
    this.date = '12 Aug 25 - 15 Aug 25',
    this.time = 'Fri 28 at 11:30 am - 12:00 pm',
    this.handoverLocation = '1901 Thornridge Cir. Shiloh, Hawaii 81063',
    this.receiverName = 'Chime Alozie',
    this.receiverPhone = '12233333',
    this.senderRemarks =
        'Integer turpis quam, laoreet id orci nec, ultrices lacinia nunc. Aliquam erat volutpat.',
  });
}
