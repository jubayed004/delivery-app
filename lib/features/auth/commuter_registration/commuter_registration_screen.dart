import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:delivery_app/core/router/route_path.dart';
import 'package:delivery_app/core/router/routes.dart';
import 'package:delivery_app/share/widgets/button/custom_button.dart';
import 'package:delivery_app/share/widgets/dropdown/custom_dropdown_field.dart';
import 'package:delivery_app/share/widgets/text_field/custom_text_field.dart';
import 'package:delivery_app/utils/app_strings/app_strings.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:delivery_app/utils/extension/base_extension.dart';

class CommuterRegistrationScreen extends StatefulWidget {
  const CommuterRegistrationScreen({super.key});

  @override
  State<CommuterRegistrationScreen> createState() =>
      _CommuterRegistrationScreenState();
}

class _CommuterRegistrationScreenState
    extends State<CommuterRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  final TextEditingController _carNumberController = TextEditingController();
  final TextEditingController _stopsController = TextEditingController();
  final TextEditingController _dailyCommuteTimeController =
      TextEditingController();
  final TextEditingController _availableForDeliveryController =
      TextEditingController();
  final TextEditingController _maxParcelWeightController =
      TextEditingController();
  final TextEditingController _preferredPickUpPointsController =
      TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _driverLicenceNumberController =
      TextEditingController();

  final ValueNotifier<String?> _selectedVehicleType = ValueNotifier(null);
  final List<String> _vehicleTypes = ['Car', 'Bike', 'Truck', 'Van'];

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    _carNumberController.dispose();
    _stopsController.dispose();
    _dailyCommuteTimeController.dispose();
    _availableForDeliveryController.dispose();
    _maxParcelWeightController.dispose();
    _preferredPickUpPointsController.dispose();
    _notesController.dispose();
    _driverLicenceNumberController.dispose();
    _selectedVehicleType.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.professionalInfo.tr),
        centerTitle: true,
        backgroundColor: AppColors.white,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  title: AppStrings.from.tr,
                  hintText: AppStrings.enterYourFrom.tr,
                  controller: _fromController,
                ),
                Gap(16.h),

                CustomTextField(
                  title: AppStrings.to.tr,
                  hintText: AppStrings.enterYourTo.tr,
                  controller: _toController,
                ),
                Gap(16.h),

                Text(AppStrings.vehicleType.tr, style: context.bodyLarge),
                Gap(8.h),
                ValueListenableBuilder<String?>(
                  valueListenable: _selectedVehicleType,
                  builder: (context, value, child) {
                    return CustomDropdownField<String>(
                      hintText: "Car",
                      items: _vehicleTypes,
                      value: value,
                      onChanged: (val) {
                        _selectedVehicleType.value = val;
                      },
                    );
                  },
                ),
                Gap(16.h),

                CustomTextField(
                  title: AppStrings.carNumber.tr,
                  hintText: "B456",
                  controller: _carNumberController,
                ),
                Gap(16.h),

                Text(AppStrings.numberPlateImage.tr, style: context.bodyLarge),
                Gap(8.h),
                Row(
                  children: [
                    _buildImagePickerBox(),
                    Gap(16.w),
                    // Placeholder for selected image if needed
                    // _buildSelectedImage(),
                  ],
                ),
                Gap(16.h),

                CustomTextField(
                  title: AppStrings.stopsAlongTheWay.tr,
                  hintText: AppStrings.enterStopsAlongTheWay.tr,
                  controller: _stopsController,
                ),
                Gap(16.h),

                Text(
                  AppStrings.scheduleAvailability.tr,
                  style: context.bodyLarge,
                ),
                Gap(8.h),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        hintText: AppStrings.enterYouTime.tr,
                        controller: _dailyCommuteTimeController,
                        title: AppStrings.dailyCommuteTime.tr,
                      ),
                    ),
                    Gap(16.w),
                    Expanded(
                      child: CustomTextField(
                        hintText: AppStrings.enterYouAvailable.tr,
                        controller: _availableForDeliveryController,
                        title: AppStrings.availableForDelivery.tr,
                      ),
                    ),
                  ],
                ),
                Gap(16.h),

                CustomTextField(
                  title: AppStrings.maxParcelWeight.tr,
                  hintText: AppStrings.enterMaxParcelWeight.tr,
                  controller: _maxParcelWeightController,
                ),
                Gap(16.h),

                CustomTextField(
                  title: AppStrings.preferredPickupPoints.tr,
                  hintText: AppStrings.enterPreferredPickupPoints.tr,
                  controller: _preferredPickUpPointsController,
                ),
                Gap(16.h),

                CustomTextField(
                  title: AppStrings.notes.tr,
                  hintText: AppStrings.enterYourNotes.tr,
                  controller: _notesController,
                  maxLines: 3,
                ),
                Gap(16.h),

                CustomTextField(
                  title: AppStrings.driverLicenceNumber.tr,
                  hintText: AppStrings.enterLicenceNumber.tr,
                  controller: _driverLicenceNumberController,
                ),
                Gap(16.h),

                Text(AppStrings.licenceImage.tr, style: context.bodyLarge),
                Gap(8.h),
                Row(children: [_buildImagePickerBox(), Gap(16.w)]),
                Gap(16.h),

                Text(AppStrings.carImages.tr, style: context.bodyLarge),
                Gap(8.h),
                Row(
                  children: [
                    _buildImagePickerBox(),
                    Gap(16.w),
                    _buildImagePickerBox(),
                  ],
                ),
                Gap(32.h),

                CustomButton(
                  text: AppStrings.update.tr,
                  onTap: () {
                    AppRouter.route.goNamed(RoutePath.driverNavScreen);
                  },
                ),
                Gap(20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePickerBox() {
    return Container(
      width: 100.w,
      height: 100.w,
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: AppColors.grayTextSecondaryColor.withValues(alpha: 0.3),
        ),
      ),
      child: Center(
        child: Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.blackMainTextColor, width: 2),
          ),
          child: const Icon(Icons.add, color: AppColors.blackMainTextColor),
        ),
      ),
    );
  }
}
