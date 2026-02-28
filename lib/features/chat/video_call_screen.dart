// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gap/gap.dart';
// import 'package:go_router/go_router.dart';
// import 'package:delivery_app/utils/color/app_colors.dart';
// import 'package:delivery_app/utils/extension/base_extension.dart';

// class AudioCallScreen extends StatelessWidget {
//   const AudioCallScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.primaryColor,
//       body: SafeArea(
//         child: Stack(
//           children: [
//             // Back Button
//             Positioned(
//               top: 16.h,
//               left: 16.w,
//               child: IconButton(
//                 icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
//                 onPressed: () {
//                   if (context.canPop()) {
//                     context.pop();
//                   }
//                 },
//               ),
//             ),

//             // Content
//             Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 const Spacer(flex: 2),

//                 // Profile Image with ring
//                 Center(
//                   child: Container(
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       border: Border.all(
//                         color: Colors.white.withValues(alpha: 0.5),
//                         width: 2.w,
//                       ),
//                     ),
//                     padding: EdgeInsets.all(4.r),
//                     child: CircleAvatar(
//                       radius: 60.r,
//                       backgroundImage: const NetworkImage(
//                         'https://i.pravatar.cc/300',
//                       ), // Placeholder
//                     ),
//                   ),
//                 ),
//                 Gap(24.h),

//                 // Name
//                 Text(
//                   'Sonia Perem',
//                   style: context.headlineSmall.copyWith(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Gap(8.h),

//                 // Timer
//                 Text(
//                   '00:25',
//                   style: context.bodyMedium.copyWith(
//                     color: Colors.white70,
//                     fontSize: 16.sp,
//                   ),
//                 ),
//                 Gap(4.h),

//                 // Status
//                 Text(
//                   'Audio call',
//                   style: context.bodySmall.copyWith(
//                     color: Colors.white70,
//                     fontSize: 14.sp,
//                   ),
//                 ),

//                 const Spacer(flex: 3),

//                 // Action Buttons
//                 Padding(
//                   padding: EdgeInsets.only(bottom: 48.h),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       _buildActionButton(
//                         context,
//                         icon: Icons.volume_up,
//                         label: 'Speaker',
//                         onTap: () {},
//                       ),
//                       Gap(32.w),
//                       _buildActionButton(
//                         context,
//                         icon: Icons.mic_off,
//                         label: 'Mute',
//                         onTap: () {},
//                       ),
//                       Gap(32.w),
//                       _buildEndCallButton(
//                         context,
//                         onTap: () {
//                           if (context.canPop()) {
//                             context.pop();
//                           }
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildActionButton(
//     BuildContext context, {
//     required IconData icon,
//     required String label,
//     required VoidCallback onTap,
//   }) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(30.r),
//           child: Container(
//             width: 60.w,
//             height: 60.h,
//             decoration: BoxDecoration(
//               color: Colors.white.withValues(alpha: 0.2),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(icon, color: Colors.white, size: 28.r),
//           ),
//         ),
//         Gap(8.h),
//         Text(
//           label,
//           style: context.labelSmall.copyWith(
//             color: Colors.white70,
//             fontSize: 12.sp,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildEndCallButton(
//     BuildContext context, {
//     required VoidCallback onTap,
//   }) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(30.r),
//           child: Container(
//             width: 60.w,
//             height: 60.h,
//             decoration: const BoxDecoration(
//               color: AppColors.redColor,
//               shape: BoxShape.circle,
//             ),
//             child: Icon(Icons.call_end, color: Colors.white, size: 28.r),
//           ),
//         ),
//         Gap(8.h),
//         Text(
//           'End call',
//           style: context.labelSmall.copyWith(
//             color: Colors.white70,
//             fontSize: 12.sp,
//           ),
//         ),
//       ],
//     );
//   }
// }
