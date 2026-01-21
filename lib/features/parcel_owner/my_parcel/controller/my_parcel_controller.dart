import 'package:delivery_app/utils/enum/app_enum.dart';
import 'package:get/get.dart';
import 'package:delivery_app/features/parcel_owner/my_parcel/model/parcel_model.dart';

class MyParcelController extends GetxController {
  final RxList<ParcelModel> parcels = <ParcelModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadMockData();
  }

  void loadMockData() {
    parcels.value = [
      // Waiting
      ParcelModel(
        id: 9,
        parcelId: '#112222',
        parcelName: 'Waiting Parcel 1',
        size: 'Medium',
        price: 30.00,
        status: ParcelStatus.waiting,
        imageUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT2Qp8paJgXVKLyyJkx4N7TOlv5izREplTlXw&s',
      ),
      // Pending
      ParcelModel(
        id: 1,
        parcelId: '#112222',
        parcelName: 'Apples',
        size: 'Small',
        price: 50.00,
        status: ParcelStatus.pending,
        imageUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT2Qp8paJgXVKLyyJkx4N7TOlv5izREplTlXw&s',
      ),
      ParcelModel(
        id: 2,
        parcelId: '#112222',
        parcelName: 'Electronics',
        size: 'Small',
        price: 50.00,
        status: ParcelStatus.pending,
        imageUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT2Qp8paJgXVKLyyJkx4N7TOlv5izREplTlXw&s',
      ),
      // Ongoing
      ParcelModel(
        id: 3,
        parcelId: '#112222',
        parcelName: 'Electronics',
        size: 'Small',
        price: 50.00,
        status: ParcelStatus.ongoing,
        imageUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT2Qp8paJgXVKLyyJkx4N7TOlv5izREplTlXw&s',
      ),
      ParcelModel(
        id: 4,
        parcelId: '#112222',
        parcelName: 'Electronics',
        size: 'Small',
        price: 50.00,
        status: ParcelStatus.ongoing,
        imageUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT2Qp8paJgXVKLyyJkx4N7TOlv5izREplTlXw&s',
      ),
      // Completed
      ParcelModel(
        id: 5,
        parcelId: '#112222',
        parcelName: 'Electronics',
        size: 'Small',
        price: 50.00,
        status: ParcelStatus.completed,
        imageUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT2Qp8paJgXVKLyyJkx4N7TOlv5izREplTlXw&s',
      ),
      ParcelModel(
        id: 6,
        parcelId: '#112222',
        parcelName: 'Electronics',
        size: 'Small',
        price: 50.00,
        status: ParcelStatus.completed,
        imageUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT2Qp8paJgXVKLyyJkx4N7TOlv5izREplTlXw&s',
      ),
      // Reject
      ParcelModel(
        id: 7,
        parcelId: '#112222',
        parcelName: 'Electronics',
        size: 'Small',
        price: 50.00,
        status: ParcelStatus.reject,
        imageUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT2Qp8paJgXVKLyyJkx4N7TOlv5izREplTlXw&s',
      ),
      ParcelModel(
        id: 8,
        parcelId: '#112222',
        parcelName: 'Electronics',
        size: 'Small',
        price: 50.00,
        status: ParcelStatus.reject,
        imageUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT2Qp8paJgXVKLyyJkx4N7TOlv5izREplTlXw&s',
      ),
    ];
  }

  List<ParcelModel> getParcelsByStatus(ParcelStatus status) {
    return parcels.where((p) => p.status == status).toList();
  }

  void changeTab(int index) {
    // Tab filtering is handled by TabBarView, this might be used for analytics or other logic
  }
}
