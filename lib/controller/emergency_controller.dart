import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:supervisors/models/emergency_case_model.dart';
import '../services/api_service.dart';


class EmergencyController extends GetxController {
  final ApiService api = ApiService();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final studentIdController = TextEditingController();


  var severity = "high".obs;

  var caseType = "medical".obs;

  var isLoading = false.obs;
  var cases = <EmergencyCase>[].obs;

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    studentIdController.dispose();
    super.onClose();
  }

  /// 📥 GET ALL CASES
  Future<void> fetchCases() async {
    try {
      isLoading.value = true;

      final response =
      await api.get('/supervisor/emergency-cases');

      final List data = response['data']['data'];

      cases.value =
          data.map((e) => EmergencyCase.fromJson(e)).toList();

    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// 🚨 CREATE CASE
  // Future<void> createCase() async {
  //   try {
  //     isLoading.value = true;
  //
  //     await api.post('/supervisor/emergency-cases', {
  //       "student_id": int.parse(studentIdController.text),
  //       "title": titleController.text,
  //       "case_type": "medical",
  //       "description": descriptionController.text,
  //       "severity": "high"
  //     });
  //
  //     await fetchCases();
  //
  //     Get.back();
  //     Get.snackbar("Success", "Emergency created");
  //
  //   } catch (e) {
  //     Get.snackbar("Error", e.toString());
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  Future<void> createCase() async {

    try {

      isLoading.value = true;


      await api.post(
          '/supervisor/emergency-cases',
          {

            "student_id":
            int.parse(studentIdController.text),


            "case_type":
            caseType.value,


            "title":
            titleController.text,


            "description":
            descriptionController.text,


            "severity":
            severity.value,


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