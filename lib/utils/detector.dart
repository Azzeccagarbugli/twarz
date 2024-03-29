import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_ml_vision/google_ml_vision.dart';

enum Detector {
  face,
}

const List<Point<int>> faceMaskConnections = [
  Point(0, 4),
  Point(0, 55),
  Point(4, 7),
  Point(4, 55),
  Point(4, 51),
  Point(7, 11),
  Point(7, 51),
  Point(7, 130),
  Point(51, 55),
  Point(51, 80),
  Point(55, 72),
  Point(72, 76),
  Point(76, 80),
  Point(80, 84),
  Point(84, 72),
  Point(72, 127),
  Point(72, 130),
  Point(130, 127),
  Point(117, 130),
  Point(11, 117),
  Point(11, 15),
  Point(15, 18),
  Point(18, 21),
  Point(21, 121),
  Point(15, 121),
  Point(21, 25),
  Point(25, 125),
  Point(125, 128),
  Point(128, 127),
  Point(128, 29),
  Point(25, 29),
  Point(29, 32),
  Point(32, 0),
  Point(0, 45),
  Point(32, 41),
  Point(41, 29),
  Point(41, 45),
  Point(45, 64),
  Point(45, 32),
  Point(64, 68),
  Point(68, 56),
  Point(56, 60),
  Point(60, 64),
  Point(56, 41),
  Point(64, 128),
  Point(64, 127),
  Point(125, 93),
  Point(93, 117),
  Point(117, 121),
  Point(121, 125),
];

class FaceDetectorPainter extends CustomPainter {
  FaceDetectorPainter({
    required this.absoluteImageSize,
    required this.faces,
    required this.camPos,
  });

  final Size absoluteImageSize;
  final List<Face> faces;
  final bool camPos;

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width / absoluteImageSize.width;
    final double scaleY = size.height / absoluteImageSize.height;

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.white;

    final Paint greenPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.white;

    for (final Face face in faces) {
      final contour = face.getContour(FaceContourType.allPoints);

      if (!camPos) {
        canvas.drawPoints(
          ui.PointMode.points,
          contour!.positionsList
              .map(
                (offset) => Offset(
                  size.width - (offset.dx * scaleX),
                  offset.dy * scaleY,
                ),
              )
              .toList(),
          paint,
        );
      } else {
        canvas.drawPoints(
          ui.PointMode.points,
          contour!.positionsList
              .map(
                (offset) => Offset(
                  offset.dx * scaleX,
                  offset.dy * scaleY,
                ),
              )
              .toList(),
          paint,
        );
      }

      for (final connection in faceMaskConnections) {
        if (!camPos) {
          final tmpDxConnectionX = size.width -
              contour.positionsList[connection.x].scale(scaleX, scaleY).dx;
          final tmpDyConnectionX =
              contour.positionsList[connection.x].scale(scaleX, scaleY).dy;
          final a = Offset(tmpDxConnectionX, tmpDyConnectionX);
          final tmpDxConnectionY = size.width -
              contour.positionsList[connection.y].scale(scaleX, scaleY).dx;
          final tmpDyConnectionY =
              contour.positionsList[connection.y].scale(scaleX, scaleY).dy;
          final b = Offset(tmpDxConnectionY, tmpDyConnectionY);
          canvas.drawLine(a, b, paint);
        } else {
          canvas.drawLine(
            contour.positionsList[connection.x].scale(scaleX, scaleY),
            contour.positionsList[connection.y].scale(scaleX, scaleY),
            paint,
          );
        }
      }

      canvas.drawRRect(
        _scaleRect(
          rect: face.boundingBox,
          imageSize: absoluteImageSize,
          widgetSize: size,
          scaleX: scaleX,
          scaleY: scaleY,
          camPos: camPos,
        ),
        greenPaint,
      );
    }
  }

  @override
  bool shouldRepaint(FaceDetectorPainter oldDelegate) {
    return oldDelegate.absoluteImageSize != absoluteImageSize ||
        oldDelegate.faces != faces;
  }
}

RRect _scaleRect({
  required Rect rect,
  required Size imageSize,
  required Size widgetSize,
  required double scaleX,
  required double scaleY,
  required bool camPos,
}) {
  if (!camPos) {
    return RRect.fromLTRBR(
      widgetSize.width - rect.left * scaleX,
      rect.top * scaleY,
      widgetSize.width - rect.right * scaleX,
      rect.bottom * scaleY,
      const Radius.circular(8),
    );
  } else {
    return RRect.fromLTRBR(
      rect.left * scaleX,
      rect.top * scaleY,
      rect.right * scaleX,
      rect.bottom * scaleY,
      const Radius.circular(8),
    );
  }
}
