import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studants/services/service.dart';
class ProfileController extends GetxController {

  final ApiService _apiService = ApiService();
  /// 🔹 بيانات قابلة للتعديل
  var name = "Ghaeda Alhalaki".obs;
  var email = "ghaeda@gmail.com".obs;

  /// 🔒 بيانات غير قابلة للتعديل
  final _studentId = "202100123".obs;
  final _room = "Room 204".obs;

  String get studentId => _studentId.value;
  String get room => _room.value;

  /// 🖼️ صورة البروفايل
  var profileImage = Rxn<File>();
  final ImagePicker _picker = ImagePicker();

  /// 🔹 حالات
  var isLoading = false.obs;
  var isEditing = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
    loadImage();
    
  }
Future<void> loadImage() async {
  final prefs = await SharedPreferences.getInstance();
  final path = prefs.getString('profile_image');

  if (path != null) {
    profileImage.value = File(path);
  }
}
  Future<void> loadProfile() async {
    try {
      isLoading.value = true;

      final prefs = await SharedPreferences.getInstance();

      name.value = prefs.getString('name') ?? name.value;
      email.value = prefs.getString('email') ?? email.value;

      _studentId.value =
          prefs.getString('studentId') ?? _studentId.value;

      _room.value =
          prefs.getString('room') ?? _room.value;
    } finally {
      isLoading.value = false;
    }
  }  
Future<void> getProfile() async {
  try {
    isLoading.value = true;

    final response =
        await _apiService.get('/auth/student/me');

    print("✅ ME Response: $response");

    final student = response['data']['student'];

    if (student != null) {
      name.value = student['full_name'] ?? name.value;
      email.value = student['email'] ?? email.value;

      _studentId.value =
          student['student_identifier'] ?? _studentId.value;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('name', name.value);
      await prefs.setString('email', email.value);
      await prefs.setString('studentId', _studentId.value);
    }

  } catch (e) {
    print("❌ ME Error: $e");
  } finally {
    isLoading.value = false;
  }
}

  /// 📸 اختيار صورة
Future<void> pickImage(ImageSource source) async {
  final pickedFile = await _picker.pickImage(source: source);

  if (pickedFile != null) {
    profileImage.value = File(pickedFile.path);

    /// 💾 حفظ المسار
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_image', pickedFile.path);
  }
}
Future<void> saveImagePath(String path) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('profile_image', path);
}

  Future<bool> updateProfile({
    required String newName,
    required String newEmail,
  }) async {
    if (newName.trim().length < 3) {
      errorMessage.value = 'الاسم ضعيف';
      return false;
    }

    if (!GetUtils.isEmail(newEmail)) {
      errorMessage.value = 'إيميل غير صحيح';
      return false;
    }

    try {
      isLoading.value = true;

      name.value = newName.trim();
      email.value = newEmail.trim();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('name', name.value);
      await prefs.setString('email', email.value);

      return true;
    } finally {
      isLoading.value = false;
    }
  }

  void clearProfile() {
  name.value = '';
  email.value = '';
  profileImage.value = null;
}
}