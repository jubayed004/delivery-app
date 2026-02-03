import 'dart:convert';

import 'package:delivery_app/features/driver/commuter_registration/models/record_location.dart';
import 'package:delivery_app/features/driver/commuter_registration/widgets/image_picker_box.dart';
import 'package:delivery_app/features/driver/professional_info/controller/professional_info_controller.dart';
import 'package:delivery_app/helper/location_picker_helper/location_picker_helper.dart';
import 'package:delivery_app/features/driver/commuter_registration/widgets/selected_image_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:delivery_app/share/widgets/button/custom_button.dart';
import 'package:delivery_app/share/widgets/dropdown/custom_dropdown_field.dart';
import 'package:delivery_app/share/widgets/text_field/custom_text_field.dart';
import 'package:delivery_app/utils/app_strings/app_strings.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:delivery_app/utils/extension/base_extension.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ProfessionalInfoEditScreen extends StatefulWidget {
  const ProfessionalInfoEditScreen({super.key});

  @override
  State<ProfessionalInfoEditScreen> createState() =>
      _ProfessionalInfoEditScreenState();
}

class _ProfessionalInfoEditScreenState
    extends State<ProfessionalInfoEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fromController = .new();
  final TextEditingController _toController = .new();
  final TextEditingController _carNumberController = .new();
  final TextEditingController _dailyCommuteTimeController = .new();
  final TextEditingController _maxParcelWeightController = .new();
  final TextEditingController _driverLicenceNumberController = .new();
  final ValueNotifier<String?> _selectedVehicleType = ValueNotifier(null);
  final List<String> _vehicleTypes = ['Car', 'Bike', 'Truck', 'Van'];

  final selectedFromLocation = ValueNotifier<RecordLocation>(
    RecordLocation(LatLng(0.0, 0.0), ""),
  );
  final selectedToLocation = ValueNotifier<RecordLocation>(
    RecordLocation(LatLng(0.0, 0.0), ""),
  );

  final ProfessionalInfoController controller = Get.find();

  @override
  void initState() {
    super.initState();
    _prefillData();
  }

  void _prefillData() {
    final data = controller.professionalInfo.value?.data;
    if (data != null) {
      final driverInfo = data.driverInfo;
      final vehicle = data.vehicle;

      if (driverInfo?.from != null) {
        _fromController.text = driverInfo!.from!.address ?? "";
        selectedFromLocation.value = RecordLocation(
          LatLng(
            driverInfo.from!.latitude ?? 0.0,
            driverInfo.from!.longitude ?? 0.0,
          ),
          driverInfo.from!.address ?? "",
        );
      }

      if (driverInfo?.to != null) {
        _toController.text = driverInfo!.to!.address ?? "";
        selectedToLocation.value = RecordLocation(
          LatLng(
            driverInfo.to!.latitude ?? 0.0,
            driverInfo.to!.longitude ?? 0.0,
          ),
          driverInfo.to!.address ?? "",
        );
      }

      _driverLicenceNumberController.text =
          driverInfo?.driverLicenseNumber ?? "";
      _dailyCommuteTimeController.text = driverInfo?.dailyCommuteTime ?? "";
      _maxParcelWeightController.text = driverInfo?.maxParcelWeight ?? "";

      if (vehicle != null) {
        _selectedVehicleType.value = vehicle.vehicleType;
        _carNumberController.text = vehicle.vehicleNumber ?? "";
      }
    }
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    _carNumberController.dispose();
    _dailyCommuteTimeController.dispose();
    _maxParcelWeightController.dispose();
    _driverLicenceNumberController.dispose();
    _selectedVehicleType.dispose();
    selectedFromLocation.dispose();
    selectedToLocation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Professional Info".tr),
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
                  readOnly: true,
                  onTap: () {
                    openLocationPicker(
                      context: context,
                      isFromField: true,
                      fromLocation: selectedFromLocation,
                      toLocation: selectedToLocation,
                      fromController: _fromController,
                      toController: _toController,
                    );
                  },
                  title: AppStrings.from.tr,
                  hintText: AppStrings.enterYourFrom.tr,
                  controller: _fromController,
                ),
                Gap(16.h),

                CustomTextField(
                  readOnly: true,
                  onTap: () {
                    openLocationPicker(
                      context: context,
                      isFromField: false,
                      fromLocation: selectedFromLocation,
                      toLocation: selectedToLocation,
                      fromController: _fromController,
                      toController: _toController,
                    );
                  },
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

                CustomTextField(
                  title: AppStrings.driverLicenceNumber.tr,
                  hintText: AppStrings.enterLicenceNumber.tr,
                  controller: _driverLicenceNumberController,
                ),
                Gap(16.h),

                Text(
                  AppStrings.scheduleAvailability.tr,
                  style: context.bodyLarge,
                ),
                Gap(16.h),
                CustomTextField(
                  readOnly: true,
                  onTap: () async {
                    final TimeOfDay? startTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                      builder: (context, child) {
                        return MediaQuery(
                          data: MediaQuery.of(
                            context,
                          ).copyWith(alwaysUse24HourFormat: false),
                          child: child!,
                        );
                      },
                    );

                    if (startTime != null && context.mounted) {
                      final TimeOfDay? endTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay(
                          hour: startTime.hour + 1,
                          minute: startTime.minute,
                        ),
                        builder: (context, child) {
                          return MediaQuery(
                            data: MediaQuery.of(
                              context,
                            ).copyWith(alwaysUse24HourFormat: false),
                            child: child!,
                          );
                        },
                      );

                      if (endTime != null) {
                        final startFormatted = startTime.format(context);
                        final endFormatted = endTime.format(context);
                        _dailyCommuteTimeController.text =
                            '$startFormatted - $endFormatted';
                      }
                    }
                  },
                  hintText: "08:00 AM - 06:00 PM",
                  controller: _dailyCommuteTimeController,
                  title: AppStrings.dailyCommuteTime.tr,
                  suffixIcon: Icon(
                    Icons.access_time,
                    color: AppColors.grayTextSecondaryColor,
                  ),
                ),

                Gap(16.h),

                CustomTextField(
                  title: AppStrings.maxParcelWeight.tr,
                  hintText: AppStrings.enterMaxParcelWeight.tr,
                  controller: _maxParcelWeightController,
                ),

                Gap(16.h),
                Text(AppStrings.numberPlateImage.tr, style: context.bodyLarge),
                Gap(8.h),
                Obx(
                  () => controller.numberPlateImage.value != null
                      ? SelectedImageBox(
                          image: controller.numberPlateImage.value!,
                          onRemove: () =>
                              controller.numberPlateImage.value = null,
                        )
                      : ImagePickerBox(
                          onTap: () =>
                              controller.pickImage('number_plate_image'),
                        ),
                ),
                Gap(16.h),

                Text(AppStrings.licenceImage.tr, style: context.bodyLarge),
                Gap(8.h),
                Obx(
                  () => controller.licenceImage.value != null
                      ? SelectedImageBox(
                          image: controller.licenceImage.value!,
                          onRemove: () => controller.licenceImage.value = null,
                        )
                      : ImagePickerBox(
                          onTap: () => controller.pickImage('license_image'),
                        ),
                ),
                Gap(16.h),

                Text(AppStrings.carImages.tr, style: context.bodyLarge),
                Gap(8.h),
                Obx(
                  () => SizedBox(
                    height: 100.w,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.carImages.length < 5
                          ? controller.carImages.length + 1
                          : 5,
                      separatorBuilder: (_, __) => Gap(16.w),
                      itemBuilder: (context, index) {
                        if (index == 0 && controller.carImages.length < 5) {
                          return ImagePickerBox(
                            onTap: () => controller.pickImage('vehicle_images'),
                          );
                        } else {
                          final imageIndex = controller.carImages.length < 5
                              ? index - 1
                              : index;
                          return SelectedImageBox(
                            image: controller.carImages[imageIndex],
                            onRemove: () =>
                                controller.removeCarImage(imageIndex),
                          );
                        }
                      },
                    ),
                  ),
                ),
                Gap(32.h),

                Obx(
                  () => CustomButton(
                    isLoading: controller.updateDriverInfoLoading.value,
                    text: AppStrings.update.tr,
                    onTap: () {
                      final body = {
                        "data": jsonEncode({
                          "driverInfo": {
                            "from": {
                              "address": selectedFromLocation.value.address,
                              "latitude": selectedFromLocation
                                  .value
                                  .latLng
                                  .latitude
                                  .toString(),
                              "longitude": selectedFromLocation
                                  .value
                                  .latLng
                                  .longitude
                                  .toString(),
                            },
                            "to": {
                              "address": selectedToLocation.value.address,
                              "latitude": selectedToLocation
                                  .value
                                  .latLng
                                  .latitude
                                  .toString(),
                              "longitude": selectedToLocation
                                  .value
                                  .latLng
                                  .longitude
                                  .toString(),
                            },
                            "driver_license_number":
                                _driverLicenceNumberController.text,
                            "daily_commute_time":
                                _dailyCommuteTimeController.text,
                            "max_parcel_weight":
                                _maxParcelWeightController.text,
                          },
                          "vehicle": {
                            "vehicle_type": _selectedVehicleType.value ?? "",
                            "vehicle_number": _carNumberController.text,
                          },
                        }),
                      };
                      if (_formKey.currentState!.validate()) {
                        controller.updateDriverInfo(body: body);
                      }
                    },
                  ),
                ),
                Gap(20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
