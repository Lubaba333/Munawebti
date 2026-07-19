import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studants/services/service.dart';

class ProfileController extends GetxController {
  final ApiService _apiService = ApiService();

  var name = ''.obs;
  var email = ''.obs;
  var phone = ''.obs;
  var year = ''.obs;
  var specialization = ''.obs;
  var isResident = false.obs;
  var annualAverage = ''.obs;
final _group = ''.obs;

String get group => _group.value;
  final _studentId = ''.obs;
  final _room = ''.obs;
  final _roomUnit = ''.obs;

  String get studentId => _studentId.value;
  String get room => _room.value;
  String get roomUnit => _roomUnit.value;

  var profileImage = Rxn<File>();
  final ImagePicker _picker = ImagePicker();

  var isLoading = false.obs;
  var isEditing = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadImage();
    getProfile();
  }

  Future<void> loadImage() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString('profile_image');

    if (path != null && path.isNotEmpty) {
      profileImage.value = File(path);
    }
  }

  Future<void> getProfile() async {
    try {
      isLoading.value = true;

      final response = await _apiService.get(
        '/auth/student/me',
        authRequired: true,
      );

      print("✅ ME Response: $response");

      final student = response['data']?['student'];

      if (student == null) return;

      name.value = student['full_name']?.toString() ?? '';
      email.value = student['email']?.toString() ?? '';
      phone.value = student['phone_number']?.toString() ?? '';
      year.value = student['year']?.toString() ?? '';
      specialization.value = student['specialization']?.toString() ?? '';
      isResident.value = student['is_resident'] == true;
      annualAverage.value = student['annual_average']?.toString() ?? '';

      _studentId.value = student['student_identifier']?.toString() ?? '';

      final currentRoom = student['current_room'];

      if (currentRoom != null && currentRoom is Map) {
        final roomNumber = currentRoom['room_number']?.toString() ?? '';
        final unitName =
            currentRoom['dormitory_unit']?['name']?.toString() ?? '';

        _room.value = roomNumber.isEmpty ? 'not_specified'.tr : roomNumber;
        _roomUnit.value = unitName.isEmpty ? 'not_specified'.tr : _unitArabicName(unitName);
      } else {
        _room.value = isResident.value ? 'not_assigned'.tr : 'not_resident'.tr;
        _roomUnit.value = '';
      }
      final latestGroup = student['latest_group'];

if (latestGroup != null && latestGroup is Map) {
  _group.value = latestGroup['group_number']?.toString() ?? 'not_specified'.tr;
} else {
  _group.value = 'not_specified'.tr;
}

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('name', name.value);
      await prefs.setString('email', email.value);
      await prefs.setString('studentId', _studentId.value);
    } catch (e) {
      print("❌ ME Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  String _unitArabicName(String? name) {
    switch (name) {
      case "Building A":
        return "مبنى الطالبات الأول";
      case "Building B":
        return "مبنى الطالبات الثاني";
      case "Building C":
        return "مبنى الطالبات الثالث";
      default:
        return name ?? "not_specified".tr;
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      profileImage.value = File(pickedFile.path);

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
      errorMessage.value = 'weak_name'.tr;
      return false;
    }

    if (!GetUtils.isEmail(newEmail)) {
      errorMessage.value = 'invalid_email_format'.tr;
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
    _group.value = '';
    name.value = '';
    email.value = '';
    phone.value = '';
    year.value = '';
    specialization.value = '';
    annualAverage.value = '';
    isResident.value = false;
    _studentId.value = '';
    _room.value = '';
    _roomUnit.value = '';
    profileImage.value = null;
  }
}