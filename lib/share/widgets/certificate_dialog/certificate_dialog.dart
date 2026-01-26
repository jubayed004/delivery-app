import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:delivery_app/utils/extension/base_extension.dart';

class CertificateDialog extends StatelessWidget {
  final String title;
  final List<String> items;

  const CertificateDialog({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// TITLE + CLOSE BUTTON
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: context.headlineSmall.copyWith(
                    color: const Color(0xFF102039),
                  ),
                ),
                GestureDetector(
                  onTap: () => context.pop(),
                  child: Icon(Icons.close, size: 22),
                ),
              ],
            ),

            SizedBox(height: 20),

            /// LIST OF ITEMS
            Column(
              children: items.map((text) {
                return Container(
                  margin: EdgeInsets.only(bottom: 14),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F6FA),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.verified_outlined, size: 20),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          text,
                          style: context.bodyMedium.copyWith(
                            color: const Color(0xFF243048),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
