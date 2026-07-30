import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

import '../const/app_colors.dart';
import '../controller/qr_scanner_controller.dart';
import '../services/api_service.dart';
import 'scanner_overlay_painter.dart';

class QrScannerView extends StatefulWidget {
  const QrScannerView({super.key});

  @override
  State<QrScannerView> createState() => _QrScannerViewState();
}

class _QrScannerViewState extends State<QrScannerView>
    with SingleTickerProviderStateMixin {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  QRViewController? qrViewController;

  late final QrScannerController controller;

  late AnimationController laserController;

  @override
  void initState() {
    super.initState();

    controller = Get.put(
      QrScannerController(ApiService()),
    );

    laserController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    qrViewController?.dispose();
    laserController.dispose();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();

    qrViewController?.pauseCamera();
    qrViewController?.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final cutOut = size.width * .72;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [

          //------------------------------------------
          // CAMERA
          //------------------------------------------

          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
          ),

          //------------------------------------------
          // OVERLAY
          //------------------------------------------

          AnimatedBuilder(
            animation: laserController,
            builder: (_, __) {
              return CustomPaint(
                size: Size.infinite,
                painter: ScannerOverlayPainter(
                  cutOutSize: cutOut,
                  laserValue: laserController.value,
                ),
              );
            },
          ),

          //------------------------------------------
          // TOP
          //------------------------------------------

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
              child: Column(
                children: [

                  Row(
                    children: [

                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.black45,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),

                      const Spacer(),

                      const Text(
                        "Scan QR",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),

                      const Spacer(),

                      const SizedBox(width: 40),
                    ],
                  ),

                  const SizedBox(height: 40),

                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.glass,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.glassBorder,
                      ),
                    ),
                    child: const Row(
                      children: [

                        Icon(
                          Icons.qr_code_scanner,
                          color: Colors.white,
                          size: 34,
                        ),

                        SizedBox(width: 15),

                        Expanded(
                          child: Text(
                            "Place the QR code inside the frame.\nScanning starts automatically.",
                            style: TextStyle(
                              color: Colors.white,
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
          // BOTTOM BUTTONS
          //------------------------------------------

          Positioned(
            bottom: 140,
            left: 35,
            right: 35,
            child: Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceEvenly,
              children: [

                _circleButton(
                  Icons.flash_on,
                      () async {
                    await qrViewController?.toggleFlash();
                  },
                ),

                _circleButton(
                  Icons.cameraswitch,
                      () async {
                    await qrViewController?.flipCamera();
                  },
                ),
              ],
            ),
          ),

          //------------------------------------------
          // BOTTOM CARD
          //------------------------------------------

          Positioned(
            bottom: 30,
            left: 25,
            right: 25,
            child: Obx(() {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: controller.isLoading.value
                        ? [
                      AppColors.secondary,
                      AppColors.primary,
                    ]
                        : AppColors.mainGradient,
                  ),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary
                          .withOpacity(.35),
                      blurRadius: 18,
                    )
                  ],
                ),
                child: Row(
                  children: [

                    controller.isLoading.value
                        ? const SizedBox(
                      width: 24,
                      height: 24,
                      child:
                      CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                        : const Icon(
                      Icons.qr_code_2,
                      color: Colors.white,
                      size: 28,
                    ),

                    const SizedBox(width: 15),

                    Expanded(
                      child: Text(
                        controller.isLoading.value
                            ? "Processing attendance..."
                            : "Ready to scan",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
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

  Widget _circleButton(
      IconData icon,
      VoidCallback onTap,
      ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 65,
        height: 65,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: AppColors.buttonGradient,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(.45),
              blurRadius: 14,
            ),
          ],
        ),
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }

  void _onQRViewCreated(
      QRViewController controllerQR) {
    qrViewController = controllerQR;

    controllerQR.scannedDataStream.listen(
          (scanData) async {
        if (scanData.code == null) return;

        await qrViewController?.pauseCamera();

        await controller.scanQr(scanData.code!);
      },
    );
  }
}