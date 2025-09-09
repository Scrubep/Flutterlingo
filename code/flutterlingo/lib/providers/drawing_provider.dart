import 'package:flutter/material.dart';
import '../models/drawing_models/draw_actions/draw_actions.dart';
import '../models/drawing_models/drawing.dart';

// Provider for drawing strokes on the canvas.
class DrawingProvider extends ChangeNotifier {
  Drawing? _drawing;
  DrawAction _pendingAction = NullAction();
  
  final double width;
  final double height;

  final List<DrawAction> _pastActions;
  final List<DrawAction> _futureActions;

  DrawingProvider({required this.width, required this.height})
    : _pastActions = [],
      _futureActions = [];

  Drawing get drawing {
    if (_drawing == null) {
      _createCachedDrawing();
    }
    return _drawing!;
  }

  // Sets the currently pending drawing action and notifies listeners
  // Use when user starts to draw 
  // Parameters:
  // DrawAction action : represents the a set of actions a user can take to make a drawing.
  set pendingAction(DrawAction action) {
    _pendingAction = action;
    _invalidateAndNotify();
  }

  DrawAction get pendingAction => _pendingAction;

  // Invalidates the drawing and notifies users
  // Use when a change occurs to the drawing
  void _invalidateAndNotify() {
    _drawing = null;
    notifyListeners();
  }

  // Creates the cached drawing
  void _createCachedDrawing() {
    _drawing = Drawing(_pastActions, width: width, height: height);
  }

  // Adds a new drawing to the list of past actions
  // Clears future actions
  // Invalidates drawing and notifies user
  // Use this after a drawing stroke is done
  // Parameters:
  // DrawAction action : represents the a set of actions a user can take to make a drawing.
  void add(DrawAction action) {
    _pastActions.add(action);
    _futureActions.clear();
    _invalidateAndNotify();
  }

  // Undo the most recent action
  // Invalidates drawing and notifies user
  // Use if you want to undo a stroke
  void undo() {
    if (_pastActions.isNotEmpty) {
      final action = _pastActions.removeLast();
      _futureActions.add(action);
      _invalidateAndNotify();
    }
  }

  // Redo the most recent undone action
  // Invalidates drawing and notifies user
  // Use if you want to redo an undo
  void redo() {
    if (_futureActions.isNotEmpty) {
      final action = _futureActions.removeLast();
      _pastActions.add(action);
      _invalidateAndNotify();
    }
  }

  // Clears the drawing by adding a ClearAction to the stack
  // Use if you want to clear the canvas
  void clear() {
    if (_pastActions.isNotEmpty) {
      _pastActions.add(ClearAction());
      _futureActions.clear();
      _invalidateAndNotify();
    }
  }

  // Gets rid of all actions no matter the history
  void totalClear() {
    if (_pastActions.isNotEmpty) {
      _pastActions.clear();
      _futureActions.clear();
      _invalidateAndNotify();
    }
  }
}