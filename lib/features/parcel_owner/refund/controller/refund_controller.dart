import 'package:get/get.dart';
import '../model/refund_model.dart';

class RefundController extends GetxController {
  final RxList<RefundModel> refundItems = <RefundModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadMockData();
  }

  void loadMockData() {
    refundItems.value = [
      RefundModel(
        id: 1,
        parcelId: '112222',
        parcelName: 'Chime Alozie',
        date: '12 Aug25-15Aug25',
        status: RefundStatus.none,
      ),
      RefundModel(
        id: 2,
        parcelId: '112222',
        parcelName: 'Chime Alozie',
        date: '12 Aug25-15Aug25',
        status: RefundStatus.pending,
      ),
      RefundModel(
        id: 3,
        parcelId: '112222',
        parcelName: 'Chime Alozie',
        date: '12 Aug25-15Aug25',
        status: RefundStatus.approved,
      ),
      RefundModel(
        id: 4,
        parcelId: '112222',
        parcelName: 'Chime Alozie',
        date: '12 Aug25-15Aug25',
        status: RefundStatus.rejected,
      ),
      RefundModel(
        id: 5,
        parcelId: '112222',
        parcelName: 'Chime Alozie',
        date: '12 Aug25-15Aug25',
        status: RefundStatus.submitted,
      ),
      RefundModel(
        id: 6,
        parcelId: '112222',
        parcelName: 'Chime Alozie',
        date: '12 Aug25-15Aug25',
        status: RefundStatus.inReview,
      ),
    ];
  }
}
