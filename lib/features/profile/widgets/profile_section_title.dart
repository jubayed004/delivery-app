import 'package:flutter/material.dart';
import 'package:delivery_app/share/widgets/align/custom_align_text.dart';
import 'package:delivery_app/utils/extension/base_extension.dart';

class ProfileSectionTitle extends StatelessWidget {
  final String title;

  const ProfileSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return CustomAlignText(
      text: title,
      style: context.bodyMedium,
      textAlign: TextAlign.start,
    );
  }
}
