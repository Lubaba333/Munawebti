import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../model/SectionModel.dart';
import '../services/api_service.dart';

class SectionController extends GetxController {
  final ApiService _apiService = ApiService();
  var sections = <SectionModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSections(); // هذا السطر يضمن جلب البيانات فور تشغيل الكنترولر
  }

  // جلب قائمة الشعب (مع معالجة الـ Pagination)
  Future<void> fetchSections() async {
    try {
      isLoading(true);
      update();
      final response = await _apiService.get('/admin/sections');

      // السيرفر يضع القائمة داخل data ثم داخل data أخرى بسبب نظام الصفحات
      if (response['status_code'] == 200 && response['data'] != null) {
        var rawList = response['data']['data'] as List;
        sections.assignAll(rawList.map((e) => SectionModel.fromJson(e)).toList());
      }
    } catch (e) {
      print("خطأ في جلب البيانات: $e");
    } finally {
      isLoading(false);
    }
  }

  // إضافة شعبة جديدة (توقع كود 201)
  Future<void> addSection(int year, String academicYear, String sectionNo) async {
    try {
      final response = await _apiService.post('/admin/sections', {
        'year': year,
        'academic_year': academicYear,
        'section_number': sectionNo,
      });

      if (response['status_code'] == 201) {
        await fetchSections(); // تحديث القائمة
        Get.back(); // إغلاق الدايلوج
        Get.snackbar('نجاح', 'تم إضافة الشعبة بنجاح', backgroundColor: Colors.green, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في الإضافة: $e');
    }
  }

  // تعديل شعبة موجودة[cite: 1]
  Future<void> updateSection(int id, int year, String academicYear, String sectionNo) async {
    try {
      final response = await _apiService.put('/admin/sections/$id', {
        'year': year,
        'academic_year': academicYear,
        'section_number': sectionNo,
      });

      if (response['status_code'] == 200) {
        await fetchSections();
        Get.back();
        Get.snackbar('نجاح', 'تم تحديث البيانات', backgroundColor: Colors.blue, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('خطأ', 'فشل التحديث');
    }
  }

  // حذف شعبة[cite: 1]
  Future<void> deleteSection(int id) async {
    try {
      final response = await _apiService.delete('/admin/sections/$id');
      if (response['status_code'] == 200) {
        sections.removeWhere((s) => s.id == id);
        Get.snackbar('نجاح', 'تم حذف الشعبة', backgroundColor: Colors.redAccent, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('خطأ', 'فشل الحذف');
    }
  }
}