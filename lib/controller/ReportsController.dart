import 'package:get/get.dart';
import 'package:supervisors/models/ReportModel.dart';
import 'package:supervisors/services/api_service.dart';


class ReportsController extends GetxController {

  final ApiService api = ApiService();

  RxList<ReportModel> reports =
      <ReportModel>[].obs;
  RxInt currentStudentId = 0.obs;

  RxBool loading = false.obs;

  Future<void> getStudentReports(
      int studentId) async {

    currentStudentId.value = studentId;

    loading(true);

    try {

      final response =
      await api.get(
        '/supervisor/student-reports',
      );


      final List list =
      response['data']['data'];


      reports.value = list
          .where(
            (e)=> e['student_id'] == studentId,
      )
          .map(
            (e)=> ReportModel.fromJson(e),
      )
          .toList();


    }catch(e){

      Get.snackbar(
        "خطأ",
        e.toString(),
      );

    }finally{

      loading(false);

    }

  }

  Future<ReportModel> getReport(
      int reportId) async {

    final response =
    await api.get(
      '/supervisor/student-reports/$reportId',
    );

    return ReportModel.fromJson(
      response['data'],
    );
  }

  Future<bool> updateReport({

    required int reportId,

    required String notes,

  }) async {


    loading(true);


    try{


      final response =
      await api.put(

        '/supervisor/student-reports/$reportId',

        {

          "notes":notes,

        },


      );



      if(response['status_code']==200){


        final index =
        reports.indexWhere(
                (e)=>e.id==reportId
        );



        if(index!=-1){


          reports[index] =
              ReportModel(

                id:
                reports[index].id,


                studentId:
                reports[index].studentId,


                notes:
                notes,


                createdAt:
                reports[index].createdAt,


                updatedAt:
                response['data']['updated_at'] ?? "",


              );



          reports.refresh();


        }



        Get.snackbar(

          "نجاح",

          "تم تعديل التقرير",

        );



        return true;



      }



      return false;



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

  Future<void> deleteReport(
      int reportId) async {

    await api.delete(
      '/supervisor/student-reports/$reportId',
    );

    await getStudentReports(
        currentStudentId.value
    );

    Get.snackbar(
      "نجاح",
      "تم حذف التقرير",
    );
  }
}