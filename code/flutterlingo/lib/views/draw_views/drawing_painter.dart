import 'package:flutter/material.dart';
import 'package:flutterlingo/models/drawing_models/drawing.dart';
import 'package:flutterlingo/models/drawing_models/draw_actions/draw_actions.dart';
import 'package:flutterlingo/providers/drawing_provider.dart';

// CustomPainter that draws DrawActions from the provider
class DrawingPainter extends CustomPainter {
  final Drawing _drawing;
  final DrawingProvider _provider;

  DrawingPainter(DrawingProvider provider) : _drawing = provider.drawing, _provider = provider;

// Paints all pending and committed drawing strokes
// Parameters:
// Canvas canvas: area where drawing takes place
// Size size: size of strokes
  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    canvas.clipRect(rect); // make sure we don't scribble outside the lines.

    final backgroundPaint = Paint()..color = Colors.white;
    canvas.drawRect(rect, backgroundPaint);

    for (final action in _provider.drawing.drawActions){
      _paintAction(canvas, action, size);
    }

    final pending = _provider.pendingAction;
    _paintAction(canvas, pending, size);
  }

  // Draws a specified DrawAction onto the canvas
  // Parameters:
  // Canvas canvas: area where drawing takes place
  // DrawAction action: a set of actions a user can take to make a drawing.
  // Size size: size of strokes
  void _paintAction(Canvas canvas, DrawAction action, Size size){
    final Rect rect = Offset.zero & size;
    // final erasePaint = Paint()..blendMode = BlendMode.clear;
    switch (action) {
      case NullAction _:
        break;
      case ClearAction _:
        final backgroundPaint = Paint()..color = Colors.white;
        canvas.drawRect(rect, backgroundPaint);
        break;
      case final StrokeAction strokeAction:
        final paint = Paint()..color = Colors.black
        ..strokeWidth = 2;
        for (int i = 0; i < strokeAction.points.length - 1; i++) {
          canvas.drawLine(strokeAction.points[i], strokeAction.points[i + 1], paint);
        }
        break;
    }
  }

  // Returns true if the current '_drawing' is different from the old one which repaints the canvas
  // Parameters:
  // DrawingPainter oldDelegate: previous instance of drawing
  @override
  bool shouldRepaint(covariant DrawingPainter oldDelegate) {
    return oldDelegate._drawing != _drawing;
  }
}