import 'package:get/get.dart';

import '../models/attendance_scan_model.dart';
import '../services/api_service.dart';
import 'attendance_controller.dart';

class QrScannerController extends GetxController {

  final ApiService apiService;


  QrScannerController(
      this.apiService,
      );


  final RxBool isLoading = false.obs;


  bool _isScanning = false;



  Future<void> scanQr(String qrToken) async {


    if(_isScanning){
      return;
    }


    _isScanning = true;

    isLoading.value = true;



    try{


      final response =
      await apiService.post(

        "/supervisor/attendance/scan-qr-code",

        {
          "qr_token":qrToken,
        },

      );



      final result =
      AttendanceScanResponse.fromJson(response);



      if(Get.isRegistered<AttendanceController>()){

        await Get.find<AttendanceController>()
            .refresh();

      }



      Get.back(
          result:true
      );



      Get.snackbar(

        "تم تسجيل الحضور",

        result.message,

        snackPosition:
        SnackPosition.BOTTOM,

      );



    }
    catch(e){


      Get.snackbar(

        "خطأ",

        e.toString()
            .replaceFirst(
            "Exception: ",
            ""
        ),

        snackPosition:
        SnackPosition.BOTTOM,

      );


    }
    finally{


      isLoading.value=false;

      _isScanning=false;


    }


  }
//
//   Future<void> scanQr(String qrToken) async {
//     if (_isScanning) {
//       return;
//     }
//
//     _isScanning = true;
//     isLoading.value = true;
//
//     try {
//       final response = await apiService.post(
//         "/supervisor/attendance/scan-qr-code",
//         {
//           "qr_token": qrToken,
//         },
//       );
//
//       final result =
//       AttendanceScanResponse.fromJson(response);
//
//       if (Get.isRegistered<AttendanceController>()) {
//         await Get.find<AttendanceController>().refresh();
//       }
//
//       Get.snackbar(
//         "تم تسجيل الحضور",
//         result.message,
//         snackPosition: SnackPosition.BOTTOM,
//       );
//
//       Get.back(result: true);
//     } catch (e) {
//       Get.snackbar(
//         "خطأ",
//         e.toString().replaceFirst(
//           "Exception: ",
//           "",
//         ),
//         snackPosition: SnackPosition.BOTTOM,
//       );
//
//       rethrow;
//     } finally {
//       isLoading.value = false;
//       _isScanning = false;
//     }
//   }
//
}