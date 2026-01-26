import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:delivery_app/features/driver/commuter_registration/models/record_location.dart';

Future<void> openLocationPicker({
  required BuildContext context,
  required bool isFromField,
  required ValueNotifier<RecordLocation> fromLocation,
  required ValueNotifier<RecordLocation> toLocation,
  required TextEditingController fromController,
  required TextEditingController toController,
}) async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => MapLocationPicker(
        config: MapLocationPickerConfig(
          apiKey: "AIzaSyAszXC1be8aJ37eHuNcBm_-O1clWkPUwV4",
          initialPosition: const LatLng(37.422, -122.084),
          onNext: (result) {
            if (result != null) {
              final address =
                  result.formattedAddress ?? "Address not available";
              final location = RecordLocation(
                LatLng(
                  result.geometry.location.lat,
                  result.geometry.location.lng,
                ),
                address,
              );

              if (isFromField) {
                fromLocation.value = location;
                fromController.text = address;
              } else {
                toLocation.value = location;
                toController.text = address;
              }
            }
            if (context.mounted) {
              Navigator.pop(context, result);
            }
          },
        ),
        searchConfig: const SearchConfig(
          apiKey: "AIzaSyAszXC1be8aJ37eHuNcBm_-O1clWkPUwV4",
          searchHintText: "Search for a location",
        ),
      ),
    ),
  );
}
