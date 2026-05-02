// import 'package:get/get.dart';

// class AuthController extends GetxController {
//   var username = ''.obs;
//   var email = ''.obs;
//   var password = ''.obs;

//   var isPasswordHidden = true.obs;
//   var rememberMe = false.obs;

//   void togglePassword() {
//     isPasswordHidden.value = !isPasswordHidden.value;
//   }

//   void toggleRemember(bool? value) {
//     rememberMe.value = value ?? false;
//   }

//   void login() {
//     print("Login: ${username.value}");
//   }

//   void signup() {
//     print("Signup: ${username.value} - ${email.value}");
//   }

//   void resetPassword() {
//     print("Reset password for: ${email.value}");
//   }
// }




import 'package:get/get.dart';

import 'package:my_app/services/api_service.dart';

class AuthController extends GetxController {
  final ApiService api = ApiService();

var email = ''.obs;
var password = ''.obs;
var username = ''.obs;

var isPasswordHidden = true.obs;
var rememberMe = false.obs;

var confirmPassword = ''.obs;
var isConfirmHidden = true.obs;

  var isLoading = false.obs;

  void togglePassword() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleRemember(bool? value) {
    rememberMe.value = value ?? false;
  }

  /// 🔥 LOGIN الحقيقي
  Future<void> login() async {
    try {
      isLoading.value = true;

      final response = await api.post(
        '/auth/supervisor/login',
        {
          "email": email.value,
          "password": password.value,
        },
        authRequired: false,
      );

      print("✅ RESPONSE: $response");

      if (response['status_code'] == 200) {
        final token = response['data']['token'];

        // 💾 خزّن التوكن
        api.setToken(token);

        Get.snackbar("Success", response['message']);

        // 🔥 روح للهوم
        // Get.offAll(() => HomeView());
      } else {
        Get.snackbar("Error", response['message']);
      }
    } catch (e) {
      print("❌ LOGIN ERROR: $e");
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
    void signup() {
    print("Signup: ${username.value} - ${email.value}");
  }

  void resetPassword() {
    print("Reset password for: ${email.value}");
  }
  
  void toggleConfirm() {
  isConfirmHidden.value = !isConfirmHidden.value;
}
}