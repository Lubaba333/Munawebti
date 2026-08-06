// import 'package:get/get.dart';
//
// import '../models/attendance_history_model.dart';
// import '../services/api_service.dart';
//
//
// class AttendanceHistoryController extends GetxController {
//   final ApiService apiService;
//
//   AttendanceHistoryController(this.apiService);
//
//   final RxList<AttendanceHistoryModel> history =
//       <AttendanceHistoryModel>[].obs;
//
//   final RxBool isLoading = false.obs;
//
//   final RxString errorMessage = ''.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     loadHistory();
//   }
//
//   Future<void> loadHistory({
//     int page = 1,
//     int perPage = 15,
//     String? shiftType,
//     String? dateFrom,
//     String? dateTo,
//   }) async {
//     try {
//       isLoading.value = true;
//       errorMessage.value = '';
//
//       final Map<String, dynamic> query = {
//         "page": page,
//         "per_page": perPage,
//       };
//
//       if (shiftType != null) {
//         query["shift_type"] = shiftType;
//       }
//
//       if (dateFrom != null) {
//         query["date_from"] = dateFrom;
//       }
//
//       if (dateTo != null) {
//         query["date_to"] = dateTo;
//       }
//
//       final response = await apiService.get(
//         "/supervisor/attendance/history",
//         queryParameters: query,
//       );
//
//       final List data = response["data"]["data"];
//
//       history.assignAll(
//         data
//             .map(
//               (e) => AttendanceHistoryModel.fromJson(e),
//         )
//             .toList(),
//       );
//     } catch (e) {
//       errorMessage.value =
//           e.toString().replaceFirst("Exception: ", "");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future<void> refresh() async {
//     await loadHistory();
//   }
// }


import 'package:get/get.dart';

import '../models/attendance_history_model.dart';
import '../services/api_service.dart';


class AttendanceHistoryController extends GetxController {


  final ApiService apiService;


  // النوع القادم من صفحة الحضور
  final String? shiftType;


  AttendanceHistoryController(
      this.apiService,
      {
        this.shiftType,
      }
      );



  // القائمة
  final RxList<AttendanceHistoryModel> history =
      <AttendanceHistoryModel>[].obs;



  final RxBool isLoading =
      false.obs;



  final RxString errorMessage =
      ''.obs;



  // Pagination

  final RxInt currentPage =
      1.obs;


  final RxInt lastPage =
      1.obs;


  final RxBool hasMore =
      true.obs;



  // الفلاتر

  final RxString selectedType =
      ''.obs;


  final RxString dateFrom =
      ''.obs;


  final RxString dateTo =
      ''.obs;




  @override
  void onInit() {

    super.onInit();


    // إذا جاء النوع من صفحة الشفت نضعه مباشرة
    if(shiftType != null){

      selectedType.value =
      shiftType!;

    }


    loadHistory();

  }







  Future<void> loadHistory({

    int page = 1,

    bool refresh = false,

  }) async {



    try {



      if(refresh){

        history.clear();

        currentPage.value = 1;

        hasMore.value = true;

      }




      if(!hasMore.value){

        return;

      }




      isLoading.value = true;



      errorMessage.value = '';




      final Map<String,dynamic> query = {


        "page": page,


        "per_page": 15,


      };







      // نوع الحضور
      if(selectedType.value.isNotEmpty){


        query["shift_type"] =
            selectedType.value;


      }







      // التاريخ

      if(dateFrom.value.isNotEmpty){


        query["date_from"] =
            dateFrom.value;


      }





      if(dateTo.value.isNotEmpty){


        query["date_to"] =
            dateTo.value;


      }








      final response =
      await apiService.get(


        "/supervisor/attendance/history",


        queryParameters: query,


      );







      final data =
      response["data"];






      final List list =
          data["data"] ?? [];






      final newData =
      list.map(

              (e)=>

              AttendanceHistoryModel
                  .fromJson(e)

      ).toList();







      history.addAll(newData);







      currentPage.value =
          data["current_page"] ?? 1;





      lastPage.value =
          data["last_page"] ?? 1;






      if(currentPage.value >=
          lastPage.value){


        hasMore.value=false;


      }




    }

    catch(e){


      errorMessage.value =
          e.toString()
              .replaceFirst(
              "Exception: ",
              ""
          );


    }

    finally{


      isLoading.value=false;


    }


  }









  // تغيير النوع من الواجهة

  void changeType(String type){


    selectedType.value =
        type;



    loadHistory(

        refresh:true

    );


  }









  // تغيير التاريخ

  void changeDate({

    String? from,

    String? to,

  }){



    dateFrom.value =
        from ?? '';



    dateTo.value =
        to ?? '';




    loadHistory(

        refresh:true

    );



  }









  Future<void> loadNextPage() async {



    if(isLoading.value ||
        !hasMore.value){


      return;


    }




    await loadHistory(


      page:
      currentPage.value + 1,


    );



  }









  Future<void> refresh() async {



    await loadHistory(


        refresh:true

    );



  }



}