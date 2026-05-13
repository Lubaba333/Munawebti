import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';
import '../model/DormitoryUnitModel.dart';

class DormitoryUnitController extends GetxController {
  final ApiService api = Get.find();
  var units = <DormitoryUnitModel>[].obs;
  var isLoading = false.obs;
  var selectedUnit = Rxn<DormitoryUnitModel>();
  @override
  void onInit() {
    super.onInit();
    fetchUnits();
  }

  // 🔄 جلب الوحدات مع معالجة الهيكل المتداخل
  Future<void> fetchUnits() async {
    try {
      isLoading.value = true;
      final response = await api.get('/admin/dormitory-units');

      // الوصول لـ response['data']['data'] لأن الباك إند يستخدم Pagination
      if (response['data'] != null && response['data']['data'] != null) {
        final List rawData = response['data']['data'];
        units.assignAll(rawData.map((e) => DormitoryUnitModel.fromJson(e)).toList());
      }
    } catch (e) {
      Get.snackbar("خطأ", "فشل جلب البيانات: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ➕ إضافة وحدة
  Future<void> addUnit(String name) async {
    try {
      await api.post('/admin/dormitory-units', {'name': name});
      fetchUnits();
      Get.snackbar("تم", "تمت الإضافة بنجاح");
    } catch (e) {
      Get.snackbar("خطأ", "فشل الإضافة");
    }
  }

  // ✏️ تعديل وحدة
  Future<void> updateUnit(int id, String name) async {
    try {
      await api.put('/admin/dormitory-units/$id', {'name': name});
      fetchUnits();
      Get.snackbar("تم", "تم التعديل بنجاح");
    } catch (e) {
      Get.snackbar("خطأ", "فشل التعديل");
    }
  }

  // ❌ حذف وحدة
  Future<void> deleteUnit(int id) async {
    try {
      await api.delete('/admin/dormitory-units/$id');
      units.removeWhere((u) => u.id == id);
      Get.snackbar("تم", "تم الحذف بنجاح");
    } catch (e) {
      // هنا نقوم بعرض رسالة الخطأ القادمة من السيرفر
      // إذا كان الخطأ 422 سيظهر للمستخدم أنه لا يمكن الحذف لوجود غرف
      Get.snackbar(
        "تنبيه",
        "لا يمكن حذف هذه الوحدة لأنها تحتوي على غرف مرتبطة بها. قم بحذف الغرف أولاً.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orangeAccent,
        colorText: Colors.white,
      );
      print("Error during delete: $e");
    }
  }
  Future<void> showUnit(int id) async {
    try {
      isLoading.value = true;
      // نطلب بيانات وحدة معينة من الباك إند
      final response = await api.get('/admin/dormitory-units/$id');

      if (response['data'] != null) {
        // نخزن البيانات العائدة في selectedUnit
        selectedUnit.value = DormitoryUnitModel.fromJson(response['data']);

        // ملاحظة للمستقبل: إذا كان الباك إند يرسل الغرف داخل الوحدة،
        // المودل تبعك لازم يتعدل ليستقبل لستة غرف.
      }
    } catch (e) {
      Get.snackbar("خطأ", "فشل جلب تفاصيل الوحدة");
      print("Show Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
