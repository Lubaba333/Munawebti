import 'package:get/get.dart';
import 'package:supervisors/models/WarningModel.dart';
import '../services/api_service.dart';

class WarningsController extends GetxController {

  final ApiService api = ApiService();

  RxList<WarningModel> warnings =
      <WarningModel>[].obs;

  RxBool loading = false.obs;

  Future<void> getStudentWarnings(int studentId) async {
    print("Student Id = $studentId");

    loading(true);

    try {
      print("Calling API...");

      final response = await api.get(
        '/supervisor/warnings',
      );

      print(response);

      final List list = response['data']['data'];

      warnings.value = list
          .where((e) => e['target_id'] == studentId)
          .map((e) => WarningModel.fromJson(e))
          .toList();

      print("Warnings Count = ${warnings.length}");

    } catch (e) {
      print(e);

      Get.snackbar(
        "خطأ",
        e.toString(),
      );
    } finally {
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
          warnings.first.id
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