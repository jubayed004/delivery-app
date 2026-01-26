import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:delivery_app/features/driver/parcels/widgets/parcel_card.dart';

class ParcelList extends StatelessWidget {
  final String status;

  const ParcelList({required this.status});

  @override
  Widget build(BuildContext context) {
    // Mock Data
    final List<Map<String, dynamic>> parcels = List.generate(
      3,
      (index) => {
        "id": "112222",
        "name": "Electronics",
        "size": "Small",
        "price": "50.00",
        "image":
            "https://img.freepik.com/free-photo/cardboard-box-isolated_125540-652.jpg", // Placeholder
      },
    );

    return ListView.separated(
      padding: EdgeInsets.all(16.r),
      itemCount: parcels.length,
      separatorBuilder: (context, index) => Gap(16.h),
      itemBuilder: (context, index) {
        final parcel = parcels[index];
        return ParcelCard(
          status: status,
          parcelId: parcel['id'],
          parcelName: parcel['name'],
          size: parcel['size'],
          price: parcel['price'],
          imageUrl: parcel['image'],
        );
      },
    );
  }
}
