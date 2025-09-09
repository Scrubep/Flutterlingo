import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutterlingo/models/drawing_models/draw_actions/draw_actions.dart';
import 'package:flutterlingo/providers/drawing_provider.dart';
import 'drawing_painter.dart';

// Checks for touch input and displays drawing actions accordingly
// Canvas updates with users' stroke and gives the drawing to the painter
class DrawArea extends StatelessWidget {
  const DrawArea({super.key, required this.width, required this.height});

  final double width, height;

  // Icon UI for undo, redo, and clear
  @override
  Widget build(BuildContext context) {
    return Consumer<DrawingProvider>(
      builder: (context, drawingProvider, unchangingChild) {
        return Column(
          children: [
           SizedBox (
              width: width,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.undo,
                      semanticLabel: 'Undo'
                    ),
                    key: const Key('Undo'),
                    onPressed: () => drawingProvider.undo(),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.redo,
                      semanticLabel: 'Redo'
                    ),
                    key: const Key('Redo'),
                    onPressed: () => drawingProvider.redo(),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.clear_all,
                      semanticLabel: 'Clear'
                    ),
                    key: const Key('Clear'),
                    onPressed: () => drawingProvider.clear(),
                  )
                ]
              ),
            ),
            CustomPaint(
              size: Size(width, height),
              painter: DrawingPainter(drawingProvider),
              child: GestureDetector(
                onPanStart: (details) => _panStart(details, drawingProvider),
                onPanUpdate: (details) => _panUpdate(details, drawingProvider),
                onPanEnd: (details) => _panEnd(details, drawingProvider),
                child: Container(
                    width: width,
                    height: height,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                      ),
                      color: Colors.transparent,
                    ),
                    child: unchangingChild)
                    ),
            )
          ],
        );
      },
    );
  }

  // Starts a new drawing stroke when the user interacts witht he canvas
  // Parameters:
  // DragStartDetails details: creates details for gestures
  // DrawingProvider drawingProvider: Provider managing and storing drawing state
  void _panStart(DragStartDetails details, DrawingProvider drawingProvider) {
    drawingProvider.pendingAction = StrokeAction(
      [details.localPosition],
    );
  }

  // Updates the drawing action as the user draws on the canvas
  // Parameters:
  // DragStartDetails details: creates details for gestures
  // DrawingProvider drawingProvider: Provider managing and storing drawing state
  void _panUpdate(DragUpdateDetails details, DrawingProvider drawingProvider) {
    final pendingAction = drawingProvider.pendingAction as StrokeAction;
    drawingProvider.pendingAction = StrokeAction(
      [...(pendingAction.points), details.localPosition],
    );
  }

  // Finalized the drawing
  // Parameters:
  // DragStartDetails details: creates details for gestures
  // DrawingProvider drawingProvider: Provider managing and storing drawing state
  void _panEnd(DragEndDetails details, DrawingProvider drawingProvider) {
    final action = drawingProvider.pendingAction;

    if (action is! NullAction) {
      drawingProvider.add(action);
    }

    drawingProvider.pendingAction = NullAction();
  }
}