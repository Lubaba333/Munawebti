import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../const/app_colors.dart';
import '../controller/AuthController.dart';

class OTPView extends StatelessWidget {

  OTPView({super.key});

  final AuthController controller =
      Get.find<AuthController>();

  final List<TextEditingController>
      otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  final List<FocusNode> focusNodes =
      List.generate(
    6,
    (_) => FocusNode(),
  );

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Stack(

        children: [

          _background(),

          Center(

            child: Padding(

              padding:
                  const EdgeInsets.symmetric(
                horizontal: 25,
              ),

              child: ClipRRect(

                borderRadius:
                    BorderRadius.circular(30),

                child: BackdropFilter(

                  filter: ImageFilter.blur(
                    sigmaX: 15,
                    sigmaY: 15,
                  ),

                  child: Container(

                    padding:
                        const EdgeInsets.all(25),

                    decoration: BoxDecoration(

                      color: AppColors.glass,

                      borderRadius:
                          BorderRadius.circular(
                        30,
                      ),

                      border: Border.all(
                        color:
                            AppColors.glassBorder,
                      ),
                    ),

                    child: Column(

                      mainAxisSize:
                          MainAxisSize.min,

                      children: [

                        Text(

                          "verification_code".tr,

                          style: const TextStyle(

                            fontSize: 22,

                            fontWeight:
                                FontWeight.bold,

                            color:
                                AppColors.textWhite,
                          ),
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        Text(

                          "enter_otp_sent_to_email".tr,

                          textAlign:
                              TextAlign.center,

                          style: const TextStyle(
                            color:
                                AppColors.textLight,
                          ),
                        ),

                        const SizedBox(
                          height: 25,
                        ),

                        Row(

                          mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,

                          children: List.generate(

                            6,

                            (i) => Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets
                                        .symmetric(
                                  horizontal: 3,
                                ),
                                child: _otpField(i),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 25,
                        ),

                        _button(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _otpField(int index) {

    return Container(

      width: double.infinity,

      height: 60,

      decoration: BoxDecoration(

        color:
            Colors.white.withOpacity(0.2),

        borderRadius:
            BorderRadius.circular(15),
      ),

      child: TextField(

        controller:
            otpControllers[index],

        focusNode: focusNodes[index],

        textAlign: TextAlign.center,

        maxLength: 1,

        keyboardType:
            TextInputType.number,

        style: const TextStyle(

          color: Colors.white,

          fontSize: 22,
        ),

        decoration: const InputDecoration(

          counterText: "",

          border: InputBorder.none,
        ),

        onChanged: (value) {

          if (value.isNotEmpty &&
              index < 5) {

            FocusScope.of(Get.context!)
                .requestFocus(
              focusNodes[index + 1],
            );
          }
        },
      ),
    );
  }

  Widget _button() {

    return Obx(

      () => GestureDetector(

        onTap:
            controller.isLoading.value

                ? null

                : () {

                    controller.otp.value =

                        otpControllers
                            .map(
                              (e) => e.text,
                            )
                            .join();

                    controller.verifyOtp();
                  },

        child: Container(

          width: double.infinity,

          padding:
              const EdgeInsets.symmetric(
            vertical: 16,
          ),

          decoration: BoxDecoration(

            gradient: LinearGradient(
              colors:
                  AppColors.buttonGradient,
            ),

            borderRadius:
                BorderRadius.circular(20),
          ),

          child: Center(

            child:
                controller.isLoading.value

                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )

                    : Text(

                        "verify_code".tr,

                        style: const TextStyle(

                          color:
                              AppColors.textWhite,

                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
          ),
        ),
      ),
    );
  }

  Widget _background() {

    return Stack(

      children: [

        Container(

          decoration:
              const BoxDecoration(

            gradient: LinearGradient(
              colors:
                  AppColors.mainGradient,
            ),
          ),
        ),

        Positioned(
          top: -50,
          left: -50,
          child: _blurCircle(200),
        ),

        Positioned(
          bottom: -60,
          right: -60,
          child: _blurCircle(250),
        ),
      ],
    );
  }

  Widget _blurCircle(double size) {

    return Container(

      width: size,

      height: size,

      decoration: BoxDecoration(

        shape: BoxShape.circle,

        color: AppColors.blur,
      ),
    );
  }
}
