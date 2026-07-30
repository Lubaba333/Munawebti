import 'dart:ui';
import 'package:flutter/material.dart';

import '../const/app_colors.dart';

class ScannerOverlayPainter extends CustomPainter {
  final double cutOutSize;
  final double laserValue;

  ScannerOverlayPainter({
    required this.cutOutSize,
    required this.laserValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final background = Paint()
      ..color = Colors.black.withOpacity(.65);

    final clearPaint = Paint()
      ..blendMode = BlendMode.clear;

    final layer = Rect.fromLTWH(
      0,
      0,
      size.width,
      size.height,
    );

    canvas.saveLayer(layer, Paint());

    canvas.drawRect(layer, background);

    final left = (size.width - cutOutSize) / 2;
    final top = (size.height - cutOutSize) / 2;

    final scanRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        left,
        top,
        cutOutSize,
        cutOutSize,
      ),
      const Radius.circular(22),
    );

    canvas.drawRRect(scanRect, clearPaint);

    canvas.restore();

    //----------------------------------------------------
    // Corners
    //----------------------------------------------------

    final borderPaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const corner = 35.0;

    // Top Left
    canvas.drawLine(
      Offset(left, top + corner),
      Offset(left, top),
      borderPaint,
    );

    canvas.drawLine(
      Offset(left, top),
      Offset(left + corner, top),
      borderPaint,
    );

    // Top Right
    canvas.drawLine(
      Offset(left + cutOutSize - corner, top),
      Offset(left + cutOutSize, top),
      borderPaint,
    );

    canvas.drawLine(
      Offset(left + cutOutSize, top),
      Offset(left + cutOutSize, top + corner),
      borderPaint,
    );

    // Bottom Left
    canvas.drawLine(
      Offset(left, top + cutOutSize - corner),
      Offset(left, top + cutOutSize),
      borderPaint,
    );

    canvas.drawLine(
      Offset(left, top + cutOutSize),
      Offset(left + corner, top + cutOutSize),
      borderPaint,
    );

    // Bottom Right
    canvas.drawLine(
      Offset(left + cutOutSize - corner, top + cutOutSize),
      Offset(left + cutOutSize, top + cutOutSize),
      borderPaint,
    );

    canvas.drawLine(
      Offset(left + cutOutSize, top + cutOutSize - corner),
      Offset(left + cutOutSize, top + cutOutSize),
      borderPaint,
    );

    //----------------------------------------------------
    // Border Glow
    //----------------------------------------------------

    final glow = Paint()
      ..color = AppColors.secondary.withOpacity(.30)
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        18,
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawRRect(scanRect, glow);

    //----------------------------------------------------
    // Laser
    //----------------------------------------------------

    final laserY =
        top + (cutOutSize * laserValue);

    final laserRect = Rect.fromLTWH(
      left + 10,
      laserY,
      cutOutSize - 20,
      3,
    );

    final laserPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          AppColors.primary.withOpacity(0),
          AppColors.primary,
          AppColors.accent,
          AppColors.primary,
          AppColors.primary.withOpacity(0),
        ],
      ).createShader(laserRect);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        laserRect,
        const Radius.circular(10),
      ),
      laserPaint,
    );

    //----------------------------------------------------
    // Laser Glow
    //----------------------------------------------------

    final glowPaint = Paint()
      ..color = AppColors.primary.withOpacity(.35)
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        15,
      );

    canvas.drawRect(
      Rect.fromLTWH(
        left + 10,
        laserY - 2,
        cutOutSize - 20,
        6,
      ),
      glowPaint,
    );
  }

  @override
  bool shouldRepaint(
      covariant ScannerOverlayPainter oldDelegate) {
    return laserValue != oldDelegate.laserValue;
  }
}