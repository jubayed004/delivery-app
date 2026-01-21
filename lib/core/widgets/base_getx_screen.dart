// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// abstract class BaseGetxScreen<T extends GetxController> extends StatefulWidget {
//   const BaseGetxScreen({super.key});

//   T createController();

//   Widget buildView(BuildContext context, T controller);

//   @override
//   State<BaseGetxScreen<T>> createState() => _BaseGetxScreenState<T>();
// }

// class _BaseGetxScreenState<T extends GetxController>
//     extends State<BaseGetxScreen<T>> {
//   late final T controller;

//   @override
//   void initState() {
//     super.initState();
//     controller = Get.put(widget.createController());
//   }

//   @override
//   void dispose() {
//     Get.delete<T>();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return widget.buildView(context, controller);
//   }
// }
