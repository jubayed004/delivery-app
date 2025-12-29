import 'package:get/get.dart';
import 'package:delivery_app/features/parcel_owner/all_commuter/model/commuter_model.dart';

class AllCommuterController extends GetxController {
  RxList<CommuterModel> commuters = <CommuterModel>[].obs;
  RxInt selectedCommuterId = (-1).obs;

  @override
  void onInit() {
    super.onInit();
    fetchCommuters();
  }

  void fetchCommuters() {
    // Mock data based on the provided image
    commuters.value = [
      CommuterModel(
        id: 1,
        name: "Wade Warren",
        vehicleType: "Car",
        rating: 4.8,
        deliveryCount: 120,
        image:
            "https://t3.ftcdn.net/jpg/06/99/46/60/360_F_699466075_DaPTBNlNQTOwwjkOiFEoOvzDV0ByXR9E.jpg",
        carImages: [
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRQi2Mm5P8j09P4hPKa1B-t9eIOHzHmR7IBkw&s",
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTgKpoOr-PUnAljpxR2LCoihCZqdoGkXYrN5g&s",
        ],
        numberPlateImage:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ_Ue3rdbPmvqTqGqL_D3bT-lWl-4tB_x_W2g&s",
      ),
      CommuterModel(
        id: 2,
        name: "Marvin McKinney",
        vehicleType: "Car",
        rating: 4.8,
        deliveryCount: 120,
        image:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRQi2Mm5P8j09P4hPKa1B-t9eIOHzHmR7IBkw&s",
        carImages: [
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRQi2Mm5P8j09P4hPKa1B-t9eIOHzHmR7IBkw&s",
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTgKpoOr-PUnAljpxR2LCoihCZqdoGkXYrN5g&s",
        ],
      ),
      CommuterModel(
        id: 3,
        name: "Leslie Alexander",
        vehicleType: "Car",
        rating: 4.8,
        deliveryCount: 120,
        image:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT4tyzRbIVlP7gnEI1SD0gKdTxccxKWaFgILFg3tyVy5w&s",
        carImages: [
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRQi2Mm5P8j09P4hPKa1B-t9eIOHzHmR7IBkw&s",
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTgKpoOr-PUnAljpxR2LCoihCZqdoGkXYrN5g&s",
        ],
      ),
      CommuterModel(
        id: 4,
        name: "Jerome Bell",
        vehicleType: "Car",
        rating: 4.8,
        deliveryCount: 120,
        image:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQmLlz4kiZ23iny0wdtSPKQSpK-tpZfuM2QAQ&s",
        carImages: [
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRQi2Mm5P8j09P4hPKa1B-t9eIOHzHmR7IBkw&s",
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTgKpoOr-PUnAljpxR2LCoihCZqdoGkXYrN5g&s",
        ],
      ),
      CommuterModel(
        id: 5,
        name: "Kathryn Murphy",
        vehicleType: "Car",
        rating: 4.8,
        deliveryCount: 120,
        image:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRQi2Mm5P8j09P4hPKa1B-t9eIOHzHmR7IBkw&s",
        carImages: [
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRQi2Mm5P8j09P4hPKa1B-t9eIOHzHmR7IBkw&s",
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTgKpoOr-PUnAljpxR2LCoihCZqdoGkXYrN5g&s",
        ],
      ),
      CommuterModel(
        id: 6,
        name: "Jane Cooper",
        vehicleType: "Car",
        rating: 4.8,
        deliveryCount: 120,
        image:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTgKpoOr-PUnAljpxR2LCoihCZqdoGkXYrN5g&s",
        carImages: [
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRQi2Mm5P8j09P4hPKa1B-t9eIOHzHmR7IBkw&s",
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTgKpoOr-PUnAljpxR2LCoihCZqdoGkXYrN5g&s",
        ],
      ),
      CommuterModel(
        id: 7,
        name: "Guy Hawkins",
        vehicleType: "Car",
        rating: 4.8,
        deliveryCount: 120,
        image:
            "https://t3.ftcdn.net/jpg/06/99/46/60/360_F_699466075_DaPTBNlNQTOwwjkOiFEoOvzDV0ByXR9E.jpg",
        carImages: [
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRQi2Mm5P8j09P4hPKa1B-t9eIOHzHmR7IBkw&s",
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTgKpoOr-PUnAljpxR2LCoihCZqdoGkXYrN5g&s",
        ],
      ),
    ];
  }
}
