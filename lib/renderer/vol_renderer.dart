import 'package:flutter/material.dart';
import 'package:k_chart/flutter_k_chart.dart';

class VolRenderer extends BaseChartRenderer<VolumeEntity> {
  late double mVolWidth;
  final ChartStyle chartStyle;
  final ChartColors chartColors;

  final Color gridColor;
  final Color upColor;
  final Color dnColor;
  final Color ma5Color;
  final Color ma10Color;
  final Color volColor;

  VolRenderer(
      Rect mainRect,
      double maxValue,
      double minValue,
      double topPadding,
      int fixedLength,
      this.chartStyle,
      this.chartColors,
      this.gridColor,
      this.upColor,
      this.dnColor,
      this.ma5Color,
      this.ma10Color,
      this.volColor)
      : super(
          chartRect: mainRect,
          maxValue: maxValue,
          minValue: minValue,
          topPadding: topPadding,
          fixedLength: fixedLength,
          gridColor: gridColor,
        ) {
    mVolWidth = chartStyle.volWidth;
  }

  @override
  void drawChart(VolumeEntity lastPoint, VolumeEntity curPoint, double lastX,
      double curX, Size size, Canvas canvas) {
    var r = mVolWidth / 2;
    var top = getVolY(curPoint.vol);
    var bottom = chartRect.bottom;
    if (curPoint.vol != 0) {
      canvas.drawRect(
          Rect.fromLTRB(curX - r, top, curX + r, bottom),
          chartPaint
            ..color = curPoint.close > curPoint.open ? upColor : dnColor);
    }

    if (lastPoint.MA5Volume != 0) {
      drawLine(lastPoint.MA5Volume, curPoint.MA5Volume, canvas, lastX, curX,
          ma5Color);
    }

    if (lastPoint.MA10Volume != 0) {
      drawLine(lastPoint.MA10Volume, curPoint.MA10Volume, canvas, lastX, curX,
          ma10Color);
    }
  }

  double getVolY(double value) =>
      (maxValue - value) * (chartRect.height / maxValue) + chartRect.top;

  @override
  void drawText(Canvas canvas, VolumeEntity data, double x) {
    var span = TextSpan(
      children: [
        TextSpan(
            text: 'VOL:${NumberUtil.format(data.vol)}    ',
            style: getTextStyle(volColor)),
        if (data.MA5Volume.notNullOrZero)
          TextSpan(
              text: 'MA5:${NumberUtil.format(data.MA5Volume!)}    ',
              style: getTextStyle(ma5Color)),
        if (data.MA10Volume.notNullOrZero)
          TextSpan(
              text: 'MA10:${NumberUtil.format(data.MA10Volume!)}    ',
              style: getTextStyle(ma10Color)),
      ],
    );
    var tp = TextPainter(text: span, textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(canvas, Offset(x, chartRect.top - topPadding));
  }

  @override
  void drawVerticalText(canvas, textStyle, int gridRows) {
    var span =
        TextSpan(text: '${NumberUtil.format(maxValue)}', style: textStyle);
    var tp = TextPainter(text: span, textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(
        canvas, Offset(chartRect.width - tp.width, chartRect.top - topPadding));
  }

  @override
  void drawGrid(Canvas canvas, int gridRows, int gridColumns) {
    canvas.drawLine(Offset(0, chartRect.bottom),
        Offset(chartRect.width, chartRect.bottom), gridPaint);
    var columnSpace = chartRect.width / gridColumns;
    for (var i = 0; i <= columnSpace; i++) {
      //vol垂直线
      canvas.drawLine(Offset(columnSpace * i, chartRect.top - topPadding),
          Offset(columnSpace * i, chartRect.bottom), gridPaint);
    }
  }
}
