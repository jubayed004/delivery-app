import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:delivery_app/features/driver/parcels/widgets/parcel_list.dart';
import 'package:delivery_app/utils/color/app_colors.dart';

class ParcelsScreen extends StatefulWidget {
  const ParcelsScreen({super.key});

  @override
  State<ParcelsScreen> createState() => _ParcelsScreenState();
}

class _ParcelsScreenState extends State<ParcelsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Dark background as per design
      appBar: AppBar(
        title: Text("Parcels"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(66.h),
          child: TabBar(
            controller: _tabController,
            padding: EdgeInsets.only(left: 16.w, right: 16.w),
            dividerColor: Colors.transparent,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(8.r),
            ),

            labelColor: Colors.white,
            unselectedLabelColor: Colors.black,
            unselectedLabelStyle: context.textTheme.titleSmall,
            tabs: [
              _buildTab("Pending", 0),
              _buildTab("Ongoing", 1),
              _buildTab("Completed", 2),
              _buildTab("Reject", 3),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ParcelList(status: "Pending"),
          ParcelList(status: "Ongoing"),
          ParcelList(status: "Completed"),
          ParcelList(status: "Reject"),
        ],
      ),
    );
  }

  Widget _buildTab(String text, int index) {
    return Tab(
      child: Container(
        padding: EdgeInsets.only(left: 8.w, right: 8.w),
        alignment: Alignment.center,
        child: Text(text),
      ),
    );
  }
}
