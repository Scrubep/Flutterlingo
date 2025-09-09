import 'package:flutter/material.dart';

import '../draw_actions.dart';

// Used to represent a line segment drawn by the user
class LineAction extends DrawAction {
  final Offset point1;
  final Offset point2;

  LineAction(this.point1, this.point2);
}
