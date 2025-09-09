import 'package:flutter/material.dart';
import '../draw_actions.dart';

// This is used to represent a single continuous path drawn by the user.
class StrokeAction extends DrawAction {
  final List<Offset> points;

  StrokeAction(this.points);
}
