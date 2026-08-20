import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

import '../const/app_colors.dart';
import '../controller/qr_scanner_controller.dart';
import '../services/api_service.dart';
import 'scanner_overlay_painter.dart';



class QrScannerView extends StatefulWidget {


  const QrScannerView({
    super.key,
  });



  @override
  State<QrScannerView> createState() =>
      _QrScannerViewState();


}






class _QrScannerViewState extends State<QrScannerView>
    with SingleTickerProviderStateMixin {


  final GlobalKey qrKey =
  GlobalKey(
      debugLabel: 'QR'
  );


  QRViewController?
  qrViewController;


  late QrScannerController controller;


  late AnimationController laserController;


  bool scanned = false;


  @override
  void initState() {
    super.initState();


    controller =
        Get.put(
          QrScannerController(
            ApiService(),
          ),
        );


    laserController =
    AnimationController(

      vsync: this,

      duration:
      const Duration(
          seconds: 2
      ),

    )
      ..repeat(
          reverse: true
      );
  }


  @override
  void dispose() {
    qrViewController?.dispose();

    laserController.dispose();


    if (Get.isRegistered<QrScannerController>()) {
      Get.delete<QrScannerController>();
    }


    super.dispose();
  }


  @override
  void reassemble() {
    super.reassemble();


    qrViewController
        ?.pauseCamera();


    qrViewController
        ?.resumeCamera();
  }


  @override
  Widget build(BuildContext context) {
    final size =
        MediaQuery
            .of(context)
            .size;


    final cutOut =
        size.width * .72;


    return Scaffold(


      backgroundColor:
      Colors.black,


      body:
      Stack(


        children: [


          QRView(


            key:
            qrKey,


            onQRViewCreated:
            _onQRViewCreated,


          ),


          AnimatedBuilder(


            animation:
            laserController,


            builder:
                (_, __) {
              return CustomPaint(


                size:
                Size.infinite,


                painter:
                ScannerOverlayPainter(


                  cutOutSize:
                  cutOut,


                  laserValue:
                  laserController.value,


                ),


              );
            },

          ),


          SafeArea(


            child:
            Padding(


              padding:
              const EdgeInsets.symmetric(

                horizontal: 20,

                vertical: 15,

              ),


              child:
              Column(


                children: [


                  Row(


                    children: [


                      GestureDetector(


                        onTap: () async {
                          await qrViewController?.pauseCamera();

                          Get.back();
                        },


                        child:
                        Container(


                          padding:
                          const EdgeInsets.all(10),


                          decoration:
                          BoxDecoration(


                            color:
                            Colors.black45,


                            borderRadius:
                            BorderRadius.circular(14),


                          ),


                          child:
                          const Icon(


                            Icons.arrow_back_ios_new,


                            color:
                            Colors.white,


                          ),


                        ),


                      ),


                      const Spacer(),


                      Text(


                        "scan_qr".tr,


                        style:
                        const TextStyle(


                          color:
                          Colors.white,


                          fontSize: 22,


                          fontWeight:
                          FontWeight.bold,


                        ),


                      ),


                      const Spacer(),


                      const SizedBox(
                        width: 40,
                      ),


                    ],


                  ),


                  const SizedBox(
                    height: 40,
                  ),


                  Container(


                    padding:
                    const EdgeInsets.all(18),


                    decoration:
                    BoxDecoration(


                      color:
                      Colors.white.withOpacity(.15),


                      borderRadius:
                      BorderRadius.circular(20),


                    ),


                    child:
                    Row(


                      children: [


                        const Icon(

                          Icons.qr_code_scanner,

                          color:
                          Colors.white,

                          size: 34,

                        ),


                        const SizedBox(
                          width: 15,
                        ),


                        Expanded(


                          child:
                          Text(


                            "qr_scan_hint".tr,


                            style:
                            const TextStyle(


                              color:
                              Colors.white,


                              fontSize: 15,


                              height: 1.5,


                            ),


                          ),


                        ),


                      ],


                    ),


                  ),


                ],


              ),


            ),


          ),
          //------------------------------------------
          // CAMERA BUTTONS
          //------------------------------------------

          Positioned(
            bottom: MediaQuery
                .of(context)
                .size
                .height * 0.18,
            left: 35,
            right: 35,
            child: Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceEvenly,
              children: [

                _circleButton(
                  Icons.flash_on,
                      () async {
                    await qrViewController
                        ?.toggleFlash();
                  },
                ),


                _circleButton(
                  Icons.cameraswitch,
                      () async {
                    await qrViewController
                        ?.flipCamera();
                  },
                ),

              ],
            ),
          ),


          //------------------------------------------
          // STATUS CARD
          //------------------------------------------

          Positioned(
            bottom: 35,
            left: 25,
            right: 25,
            child: Obx(() {
              return AnimatedContainer(

                duration:
                const Duration(
                    milliseconds: 300
                ),


                padding:
                const EdgeInsets.all(18),


                decoration:
                BoxDecoration(


                  gradient:
                  LinearGradient(


                    colors:
                    controller.isLoading.value

                        ?

                    [
                      AppColors.secondary,
                      AppColors.primary,
                    ]

                        :

                    AppColors.mainGradient,


                  ),


                  borderRadius:
                  BorderRadius.circular(22),


                  boxShadow: [

                    BoxShadow(

                      color:
                      AppColors.primary
                          .withOpacity(.35),


                      blurRadius:
                      18,


                      offset:
                      const Offset(0, 8),

                    )

                  ],


                ),


                child:
                Row(


                  children: [


                    controller.isLoading.value

                        ?

                    const SizedBox(


                      width: 26,

                      height: 26,


                      child:
                      CircularProgressIndicator(


                        strokeWidth:
                        2.5,


                        color:
                        Colors.white,


                      ),


                    )

                        :

                    const Icon(


                      Icons.qr_code_2,


                      color:
                      Colors.white,


                      size:
                      30,


                    ),


                    const SizedBox(
                      width: 15,
                    ),


                    Expanded(

                      child:
                      Text(


                        controller.isLoading.value

                            ?

                        "processing_attendance".tr

                            :

                        "ready_to_scan".tr,


                        style:
                        const TextStyle(


                          color:
                          Colors.white,


                          fontSize:
                          16,


                          fontWeight:
                          FontWeight.w600,


                        ),


                      ),

                    ),


                  ],


                ),


              );
            }),
          ),


        ],

      ),

    );
  }


  Widget _circleButton(IconData icon,
      VoidCallback onTap,) {
    return InkWell(


      onTap: onTap,


      borderRadius:
      BorderRadius.circular(50),


      child:
      Container(


        width: 65,

        height: 65,


        decoration:
        BoxDecoration(


          shape:
          BoxShape.circle,


          gradient:
          const LinearGradient(

            colors:
            AppColors.buttonGradient,

          ),


          boxShadow: [

            BoxShadow(

              color:
              AppColors.primary
                  .withOpacity(.45),


              blurRadius:
              14,


            )

          ],


        ),


        child:
        Icon(


          icon,


          color:
          Colors.white,


          size:
          28,


        ),


      ),


    );
  }

  // void _onQRViewCreated(
  //     QRViewController controllerQR,
  //     ) {
  //
  //   qrViewController = controllerQR;
  //
  //
  //   controllerQR.scannedDataStream.listen(
  //         (scanData) async {
  //
  //
  //       if(scanned){
  //         return;
  //       }
  //
  //
  //
  //       final code = scanData.code;
  //
  //
  //
  //       if(code == null || code.isEmpty){
  //         return;
  //       }
  //
  //
  //
  //       scanned = true;
  //
  //
  //
  //       await qrViewController?.pauseCamera();
  //
  //
  //
  //       try {
  //
  //
  //         await controller.scanQr(code);
  //
  //
  //
  //       } catch(e){
  //
  //
  //         Get.snackbar(
  //           "error".tr,
  //           e.toString()
  //               .replaceFirst(
  //               "Exception: ",
  //               ""
  //           ),
  //           backgroundColor: Colors.red,
  //           colorText: Colors.white,
  //         );
  //
  //
  //       } finally {
  //
  //
  //
  //         await Future.delayed(
  //           const Duration(seconds:1),
  //         );
  //
  //
  //         scanned = false;
  //
  //
  //
  //         await qrViewController
  //             ?.resumeCamera();
  //
  //
  //       }
  //
  //
  //
  //     },
  //   );
  //
  // }

  void _onQRViewCreated(
      QRViewController controllerQR,
      ) {
    qrViewController = controllerQR;

    controllerQR.scannedDataStream.listen(
          (scanData) async {
        if (scanned) {
          return;
        }

        final code = scanData.code;

        if (code == null || code.isEmpty) {
          return;
        }

        scanned = true;

        try {
          await qrViewController?.pauseCamera();

          await controller.scanQr(code);

          // لا يوجد resumeCamera هنا
          // لأن scanQr() عند النجاح يعمل Get.back()
        } catch (e) {
          if (!mounted) return;

          try {
            await qrViewController?.resumeCamera();
          } catch (_) {}

          scanned = false;
        }
      },
    );
  }
}
