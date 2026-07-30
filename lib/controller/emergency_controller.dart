import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:supervisors/models/StudentModel.dart';
import 'package:supervisors/models/emergency_case_model.dart';
import 'package:supervisors/services/api_service.dart';


class EmergencyController extends GetxController {

  // final EmergencyController emergencyController = Get.find<EmergencyController>();

  final ApiService api = ApiService();


  final titleController = TextEditingController();

  final descriptionController = TextEditingController();

  final severityController = TextEditingController();

  final caseTypeController = TextEditingController();


  var isLoading = false.obs;


  var cases = <EmergencyCase>[].obs;


  var students = <StudentModel>[].obs;

  Rx<StudentModel?> selectedStudent = Rx<StudentModel?>(null);



  @override
  void onClose(){

    titleController.dispose();

    descriptionController.dispose();

    severityController.dispose();

    caseTypeController.dispose();

    super.onClose();

  }






  Future<void> fetchCases() async {

    try {

      isLoading.value=true;


      final response =
      await api.get('/supervisor/emergency-cases');


      final List data=response['data']['data'];


      cases.value =
          data.map((e)=>EmergencyCase.fromJson(e)).toList();



    }catch(e){

      Get.snackbar(
          "Error",
          e.toString()
      );

    }

    finally{

      isLoading.value=false;

    }

  }






  Future<void> fetchStudents() async {

    try {

      final response =
      await api.get('/supervisor/students');


      final List data =
      response['data']['data'];


      students.value =
          data.map(
                (e)=>StudentModel.fromJson(e),
          ).toList();



      print("Students Loaded: ${students.length}");


    }catch(e){

      print(e);

      Get.snackbar(
          "Error",
          e.toString()
      );

    }

  }


  Future<void> createCase() async {


    try{


      if(selectedStudent.value == null){

        Get.snackbar(
            "Error",
            "Please select student"
        );

        return;

      }



      isLoading.value=true;



      await api.post(

          '/supervisor/emergency-cases',

          {


            "student_id":
            selectedStudent.value!.id,


            "case_type":
            caseTypeController.text,


            "title":
            titleController.text,


            "description":
            descriptionController.text,


            "severity":
            severityController.text,


          });



      await fetchCases();


      Get.back();



      Get.snackbar(
          "Success",
          "Emergency created"
      );



    }

    catch(e){


      Get.snackbar(
          "Error",
          e.toString()
      );


    }

    finally{

      isLoading.value=false;

    }


  }
}