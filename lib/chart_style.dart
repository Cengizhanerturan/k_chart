import 'package:flutter/material.dart' show Color;

class ChartColors {
  Color getMAColor(int index,
      {required Color ma5Color,
      required Color ma10Color,
      required Color ma30Color}) {
    switch (index % 3) {
      case 1:
        return ma10Color;
      case 2:
        return ma30Color;
      default:
        return ma5Color;
    }
  }
}

class ChartStyle {
  double topPadding = 30.0;

  double bottomPadding = 20.0;

  double childPadding = 12.0;

  double candleWidth = 8.5;

  double candleLineWidth = 1.5;

  double volWidth = 8.5;

  double macdWidth = 3.0;

  double vCrossWidth = 8.5;

  double hCrossWidth = 0.5;

  double nowPriceLineLength = 1;

  double nowPriceLineSpan = 1;

  double nowPriceLineWidth = 1;

  int gridRows = 4;

  int gridColumns = 4;

  List<String>? dateTimeFormat;
}
