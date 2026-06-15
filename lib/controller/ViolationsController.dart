import 'package:get/get.dart';
import 'package:supervisors/models/ViolationModel.dart';

import '../services/api_service.dart';

class ViolationsController
    extends GetxController {

  final ApiService api =
  ApiService();

  RxList<ViolationModel>
  violations =
      <ViolationModel>[].obs;

  RxBool loading =
      false.obs;

  Future<void> getStudentViolations(
      int studentId) async {

    loading(true);

    try {

      final response =
      await api.get(
        '/supervisor/violations',
      );

      final List list =
      response['data']['data'];

      violations.value = list
          .where(
            (e) =>
        e['target_id'] ==
            studentId,
      )
          .map(
            (e) =>
            ViolationModel
                .fromJson(e),
      )
          .toList();

    } catch (e) {

      Get.snackbar(
        "خطأ",
        e.toString(),
      );

    } finally {

      loading(false);
    }
  }

  Future<ViolationModel>
  getViolation(
      int violationId) async {

    final response =
    await api.get(
      '/supervisor/violations/$violationId',
    );

    return ViolationModel
        .fromJson(
      response['data'],
    );
  }

  // Future<void> updateViolation({
  //   required int violationId,
  //   required String title,
  //   required String description,
  //   required String category,
  //   required String penalty,
  // }) async {
  //
  //   await api.put(
  //     '/supervisor/violations/$violationId',
  //     {
  //       "title": title,
  //       "description":
  //       description,
  //       "category":
  //       category,
  //       "penalty":
  //       penalty,
  //     },
  //   );
  //
  //   Get.snackbar(
  //     "نجاح",
  //     "تم تعديل المخالفة",
  //   );
  // }



  Future<bool> updateViolation({

    required int violationId,

    required String title,

    required String description,

    required String violationDate,

    required String category,

    required String penalty,


  }) async {


    loading(true);


    try{


      await api.put(

        '/supervisor/violations/$violationId',

        {


          "title":title,

          "description":description,

          "violation_date":violationDate,

          "category":category,

          "penalty":penalty,


        },

      );



      final index =
      violations.indexWhere(
              (e)=>e.id==violationId
      );



      if(index!=-1){


        violations[index] =

            violations[index].copyWith(


              title:title,

              description:description,

              violationDate:violationDate,

              category:category,

              penalty:penalty,


            );



        violations.refresh();


      }



      Get.snackbar(
        "نجاح",
        "تم تعديل المخالفة",
      );



      return true;



    }catch(e){


      Get.snackbar(
        "خطأ",
        e.toString(),
      );


      return false;


    }finally{


      loading(false);


    }


  }
  Future<void> deleteViolation(
      int violationId) async {

    await api.delete(
      '/supervisor/violations/$violationId',
    );

    violations.removeWhere(
          (e) =>
      e.id ==
          violationId,
    );

    Get.snackbar(
      "نجاح",
      "تم حذف المخالفة",
    );
  }
}