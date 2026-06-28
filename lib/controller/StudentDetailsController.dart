import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supervisors/models/StudentModel.dart';

class StudentDetailsController extends GetxController
    with GetSingleTickerProviderStateMixin {


  late TabController tabController;


  late StudentModel student;



  @override
  void onInit() {

    super.onInit();


    student =
    Get.arguments as StudentModel;



    tabController =
        TabController(

          length: 3,

          vsync: this,

        );

  }



  @override
  void onClose(){

    tabController.dispose();

    super.onClose();

  }

}