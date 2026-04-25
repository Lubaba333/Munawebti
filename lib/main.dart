import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studants/views/home_view.dart';
import 'package:studants/views/register_view.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
       
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
     home:  HomeView(),
    //home: RegisterView(), // 🔥 مباشر لصفحة التسجيل
    );
  }
}