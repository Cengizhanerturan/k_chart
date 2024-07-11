import 'package:flutter/material.dart';

import '../entity/macd_entity.dart';
import '../k_chart_widget.dart' show SecondaryState;
import 'base_chart_renderer.dart';

class SecondaryRenderer extends BaseChartRenderer<MACDEntity> {
  late double mMACDWidth;
  SecondaryState state;
  final ChartStyle chartStyle;
  final ChartColors chartColors;

  final Color gridColor;
  final Color rsiColor;
  final Color kColor;
  final Color dColor;
  final Color jColor;
  final Color upColor;
  final Color dnColor;
  final Color difColor;
  final Color deaColor;
  final Color macdColor;
  final Color defaultTextColor;

  SecondaryRenderer(
      Rect mainRect,
      double maxValue,
      double minValue,
      double topPadding,
      this.state,
      int fixedLength,
      this.chartStyle,
      this.chartColors,
      this.gridColor,
      this.rsiColor,
      this.kColor,
      this.dColor,
      this.jColor,
      this.upColor,
      this.dnColor,
      this.difColor,
      this.deaColor,
      this.macdColor,
      this.defaultTextColor)
      : super(
          chartRect: mainRect,
          maxValue: maxValue,
          minValue: minValue,
          topPadding: topPadding,
          fixedLength: fixedLength,
          gridColor: gridColor,
        ) {
    mMACDWidth = chartStyle.macdWidth;
  }

  @override
  void drawChart(MACDEntity lastPoint, MACDEntity curPoint, double lastX,
      double curX, Size size, Canvas canvas) {
    switch (state) {
      case SecondaryState.MACD:
        drawMACD(curPoint, canvas, curX, lastPoint, lastX);
        break;
      case SecondaryState.KDJ:
        drawLine(lastPoint.k, curPoint.k, canvas, lastX, curX, kColor);
        drawLine(lastPoint.d, curPoint.d, canvas, lastX, curX, dColor);
        drawLine(lastPoint.j, curPoint.j, canvas, lastX, curX, jColor);
        break;
      case SecondaryState.RSI:
        drawLine(lastPoint.rsi, curPoint.rsi, canvas, lastX, curX, rsiColor);
        break;
      case SecondaryState.WR:
        drawLine(lastPoint.r, curPoint.r, canvas, lastX, curX, rsiColor);
        break;
      case SecondaryState.CCI:
        drawLine(lastPoint.cci, curPoint.cci, canvas, lastX, curX, rsiColor);
        break;
      default:
        break;
    }
  }

  void drawMACD(MACDEntity curPoint, Canvas canvas, double curX,
      MACDEntity lastPoint, double lastX) {
    final macd = curPoint.macd ?? 0;
    var macdY = getY(macd);
    var r = mMACDWidth / 2;
    var zeroy = getY(0);
    if (macd > 0) {
      canvas.drawRect(Rect.fromLTRB(curX - r, macdY, curX + r, zeroy),
          chartPaint..color = upColor);
    } else {
      canvas.drawRect(Rect.fromLTRB(curX - r, zeroy, curX + r, macdY),
          chartPaint..color = dnColor);
    }
    if (lastPoint.dif != 0) {
      drawLine(lastPoint.dif, curPoint.dif, canvas, lastX, curX, difColor);
    }
    if (lastPoint.dea != 0) {
      drawLine(lastPoint.dea, curPoint.dea, canvas, lastX, curX, deaColor);
    }
  }

  @override
  void drawText(Canvas canvas, MACDEntity data, double x) {
    List<TextSpan>? children;
    switch (state) {
      case SecondaryState.MACD:
        children = [
          TextSpan(
              text: 'MACD(12,26,9)    ', style: getTextStyle(defaultTextColor)),
          if (data.macd != 0)
            TextSpan(
                text: 'MACD:${format(data.macd)}    ',
                style: getTextStyle(macdColor)),
          if (data.dif != 0)
            TextSpan(
                text: 'DIF:${format(data.dif)}    ',
                style: getTextStyle(difColor)),
          if (data.dea != 0)
            TextSpan(
                text: 'DEA:${format(data.dea)}    ',
                style: getTextStyle(deaColor)),
        ];
        break;
      case SecondaryState.KDJ:
        children = [
          TextSpan(
              text: 'KDJ(9,1,3)    ', style: getTextStyle(defaultTextColor)),
          if (data.macd != 0)
            TextSpan(
                text: 'K:${format(data.k)}    ', style: getTextStyle(kColor)),
          if (data.dif != 0)
            TextSpan(
                text: 'D:${format(data.d)}    ', style: getTextStyle(dColor)),
          if (data.dea != 0)
            TextSpan(
                text: 'J:${format(data.j)}    ', style: getTextStyle(jColor)),
        ];
        break;
      case SecondaryState.RSI:
        children = [
          TextSpan(
              text: 'RSI(14):${format(data.rsi)}    ',
              style: getTextStyle(rsiColor)),
        ];
        break;
      case SecondaryState.WR:
        children = [
          TextSpan(
              text: 'WR(14):${format(data.r)}    ',
              style: getTextStyle(rsiColor)),
        ];
        break;
      case SecondaryState.CCI:
        children = [
          TextSpan(
              text: 'CCI(14):${format(data.cci)}    ',
              style: getTextStyle(rsiColor)),
        ];
        break;
      default:
        break;
    }
    var tp = TextPainter(
        text: TextSpan(children: children ?? []),
        textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(canvas, Offset(x, chartRect.top - topPadding));
  }

  @override
  void drawVerticalText(canvas, textStyle, int gridRows) {
    var maxTp = TextPainter(
        text: TextSpan(text: '${format(maxValue)}', style: textStyle),
        textDirection: TextDirection.ltr);
    maxTp.layout();
    var minTp = TextPainter(
        text: TextSpan(text: '${format(minValue)}', style: textStyle),
        textDirection: TextDirection.ltr);
    minTp.layout();

    maxTp.paint(canvas,
        Offset(chartRect.width - maxTp.width, chartRect.top - topPadding));
    minTp.paint(canvas,
        Offset(chartRect.width - minTp.width, chartRect.bottom - minTp.height));
  }

  @override
  void drawGrid(Canvas canvas, int gridRows, int gridColumns) {
    canvas.drawLine(Offset(0, chartRect.top),
        Offset(chartRect.width, chartRect.top), gridPaint);
    canvas.drawLine(Offset(0, chartRect.bottom),
        Offset(chartRect.width, chartRect.bottom), gridPaint);
    var columnSpace = chartRect.width / gridColumns;
    for (var i = 0; i <= columnSpace; i++) {
      //mSecondaryRect垂直线
      canvas.drawLine(Offset(columnSpace * i, chartRect.top - topPadding),
          Offset(columnSpace * i, chartRect.bottom), gridPaint);
    }
  }
}
