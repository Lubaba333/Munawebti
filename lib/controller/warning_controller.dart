import 'package:get/get.dart';
import 'package:supervisors/models/WarningModel.dart';
import 'package:supervisors/services/api_service.dart';


class WarningsController extends GetxController {

  final ApiService api = ApiService();

  RxList<WarningModel> warnings =
      <WarningModel>[].obs;

  RxInt currentStudentId = 0.obs;

  RxBool loading = false.obs;

  Future<void> getStudentWarnings(int studentId) async {

    currentStudentId.value = studentId;

    loading(true);

    try {

      final response = await api.get(
        '/supervisor/warnings',
      );


      final List list =
      response['data']['data'];


      warnings.value = list
          .where(
              (e)=> e['target_id'] == studentId
      )
          .map(
              (e)=> WarningModel.fromJson(e)
      )
          .toList();



    } catch(e){

      Get.snackbar(
          "خطأ",
          e.toString()
      );

    }
    finally{

      loading(false);

    }

  }

  Future<WarningModel?> getWarning(
      int warningId,
      ) async {

    try {

      final response = await api.get(
        '/supervisor/warnings/$warningId',
      );

      return WarningModel.fromJson(
        response['data'],
      );

    } catch (e) {

      Get.snackbar(
        "خطأ",
        e.toString(),
      );

      return null;
    }
  }

  Future<bool> updateWarning({

    required int warningId,

    required String title,

    required String description,

    required String warningDate,

    required String possiblePenalty,

  }) async {


    loading(true);


    try {


      await api.put(

        '/supervisor/warnings/$warningId',

        {


          "title": title,


          "description": description,


          "warning_date": warningDate,


          "possible_penalty": possiblePenalty,


        },

      );


      await getStudentWarnings(
          currentStudentId.value
      );



      Get.snackbar(
        "نجاح",
        "تم تعديل التحذير",
      );


      return true;



    }catch(e){


      Get.snackbar(
        "خطأ",
        e.toString(),
      );


      return false;


    }

    finally{

      loading(false);

    }


  }

  Future<void> deleteWarning(
      int warningId,
      ) async {

    loading(true);

    try {

      await api.delete(
        '/supervisor/warnings/$warningId',
      );

      warnings.removeWhere(
            (e) => e.id == warningId,
      );

      Get.snackbar(
        "نجاح",
        "تم حذف التحذير",
      );

    } catch (e) {

      Get.snackbar(
        "خطأ",
        e.toString(),
      );

    } finally {

      loading(false);
    }
  }



}