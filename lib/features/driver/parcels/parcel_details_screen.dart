// import 'package:delivery_app/features/driver/parcels/controller/parcel_details_controller.dart';
// import 'package:delivery_app/features/parcel_owner/my_parcel/widgets/parcel_details_section.dart';
// import 'package:delivery_app/features/parcel_owner/my_parcel/widgets/parcel_image_section.dart';
// import 'package:delivery_app/features/parcel_owner/my_parcel/widgets/receiver_details_section.dart';
// import 'package:delivery_app/utils/enum/app_enum.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gap/gap.dart';
// import 'package:get/get.dart';
// import 'package:delivery_app/utils/app_strings/app_strings.dart';
// import 'package:delivery_app/utils/color/app_colors.dart';
// import 'package:delivery_app/share/widgets/loading/loading_widget.dart';
// import 'package:delivery_app/share/widgets/no_internet/error_card.dart';
// import 'package:delivery_app/share/widgets/no_internet/no_data_card.dart';
// import 'package:delivery_app/share/widgets/no_internet/no_internet_card.dart';

// class ParcelDetailsScreen extends StatefulWidget {
//   final String parcelId;
//   const ParcelDetailsScreen({super.key, required this.parcelId});

//   @override
//   State<ParcelDetailsScreen> createState() => _ParcelDetailsScreenState();
// }

// class _ParcelDetailsScreenState extends State<ParcelDetailsScreen> {
//   final ParcelDetailsController controller = Get.put(ParcelDetailsController());

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       controller.singleDetailsMyParcel(id: widget.parcelId);
//     });
//   }

//   @override
//   void dispose() {
//     Get.delete<ParcelDetailsController>();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.backgroundColor,
//       appBar: AppBar(
//         backgroundColor: AppColors.white,
//         scrolledUnderElevation: 0,
//         centerTitle: true,
//         title: Text(AppStrings.detailsPage.tr),
//       ),
//       body: RefreshIndicator(
//         onRefresh: () async {
//           await controller.singleDetailsMyParcel(id: widget.parcelId);
//         },
//         child: CustomScrollView(
//           physics: const AlwaysScrollableScrollPhysics(),
//           slivers: [
//             Obx(() {
//               switch (controller.loading.value) {
//                 case ApiStatus.loading:
//                   return const SliverFillRemaining(
//                     child: Center(child: LoadingWidget()),
//                   );
//                 case ApiStatus.error:
//                   return SliverFillRemaining(
//                     child: Center(
//                       child: ErrorCard(
//                         onTap: () {
//                           controller.singleDetailsMyParcel(id: widget.parcelId);
//                         },
//                       ),
//                     ),
//                   );
//                 case ApiStatus.internetError:
//                   return SliverFillRemaining(
//                     child: Center(
//                       child: NoInternetCard(
//                         onTap: () {
//                           controller.singleDetailsMyParcel(id: widget.parcelId);
//                         },
//                       ),
//                     ),
//                   );
//                 case ApiStatus.noDataFound:
//                   return SliverFillRemaining(
//                     child: Center(
//                       child: NoDataCard(
//                         onTap: () {
//                           controller.singleDetailsMyParcel(id: widget.parcelId);
//                         },
//                       ),
//                     ),
//                   );
//                 case ApiStatus.completed:
//                   final parcelDetails = controller.detailsMyParcel.value?.data;

//                   if (parcelDetails == null) {
//                     return SliverFillRemaining(
//                       child: Center(child: Text("No details found".tr)),
//                     );
//                   }

//                   return SliverToBoxAdapter(
//                     child: Column(
//                       children: [
//                         // Parcel Image
//                         ParcelImageSection(
//                           imageUrl:
//                               (parcelDetails.parcelImages != null &&
//                                   parcelDetails.parcelImages!.isNotEmpty)
//                               ? parcelDetails.parcelImages!.first
//                               : null,
//                         ),

//                         Padding(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: 16.w,
//                             vertical: 16.h,
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               // Parcel Details
//                               ParcelDetailsSection(
//                                 parcelDetails: parcelDetails,
//                               ),

//                               Gap(16.h),

//                               // Receiver Details
//                               ReceiverDetailsSection(
//                                 parcelDetails: parcelDetails,
//                               ),

//                               Gap(16.h),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//               }
//             }),
//           ],
//         ),
//       ),
//     );
//   }
// }
