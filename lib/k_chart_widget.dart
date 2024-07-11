import 'dart:async';
import 'package:flutter/material.dart';
import 'package:k_chart/flutter_k_chart.dart';
import 'package:k_chart/chart_translations.dart';

enum MainState { MA, BOLL, NONE }

enum SecondaryState { MACD, KDJ, RSI, WR, CCI, NONE }

class TimeFormat {
  static const List<String> YEAR_MONTH_DAY = [dd, '.', mm, '.', yyyy];
  static const List<String> YEAR_MONTH_DAY_WITH_HOUR = [
    dd,
    '.',
    mm,
    '.',
    yyyy,
    ' ',
    HH,
    ':',
    nn
  ];
  static const List<String> HOUR = [HH, ':', nn];
}

class KChartWidget extends StatefulWidget {
  final List<KLineEntity>? datas;
  final MainState mainState;
  final bool volHidden;
  final SecondaryState secondaryState;
  final Function()? onSecondaryTap;
  final bool isLine;
  final bool isTapShowInfoDialog;
  final bool hideGrid;
  final bool showNowPrice;
  final bool showInfoDialog;
  final bool materialInfoDialog;
  final Map<String, ChartTranslations> translations;
  final String languageCode;
  final List<String> timeFormat;

  final Function(bool)? onLoadMore;

  final int fixedLength;
  final List<int> maDayList;
  final int flingTime;
  final double flingRatio;
  final Curve flingCurve;
  final Function(bool)? isOnDrag;
  final ChartColors chartColors;
  final ChartStyle chartStyle;
  final VerticalTextAlignment verticalTextAlignment;
  final bool isTrendLine;
  final double xFrontPadding;

  final double pointWidth;
  final bool isSwipe;

  final TextStyle? infoWindowTitleTextStyle;
  final TextStyle? infoWindowValueTextStyle;
  final TextStyle? textStyle;

  //Colors
  final List<Color> bgColor;
  final Color kLineColor;
  final Color lineFillColor;
  final Color lineFillInsideColor;
  final Color ma5Color;
  final Color ma10Color;
  final Color ma30Color;
  final Color upColor;
  final Color dnColor;
  final Color volColor;
  final Color macdColor;
  final Color difColor;
  final Color deaColor;
  final Color kColor;
  final Color dColor;
  final Color jColor;
  final Color rsiColor;
  final Color defaultTextColor;
  final Color nowPriceUpColor;
  final Color nowPriceDnColor;
  final Color nowPriceTextColor;
  final Color depthBuyColor;
  final Color depthSellColor;
  final Color selectBorderColor;
  final Color selectFillColor;
  final Color gridColor;
  final Color infoWindowNormalColor;
  final Color infoWindowTitleColor;
  final Color infoWindowUpColor;
  final Color infoWindowDnColor;
  final Color hCrossColor;
  final Color vCrossColor;
  final Color crossTextColor;
  final Color trendLineColor;
  final Color maxColor;
  final Color minColor;

  KChartWidget(
    this.datas,
    this.chartStyle,
    this.chartColors, {
    required this.isTrendLine,
    this.infoWindowTitleTextStyle,
    this.infoWindowValueTextStyle,
    this.textStyle,
    this.pointWidth = 11,
    this.isSwipe = true,
    this.xFrontPadding = 100,
    this.mainState = MainState.MA,
    this.secondaryState = SecondaryState.MACD,
    this.onSecondaryTap,
    this.volHidden = false,
    this.isLine = false,
    this.isTapShowInfoDialog = false,
    this.hideGrid = false,
    this.showNowPrice = true,
    this.showInfoDialog = true,
    this.materialInfoDialog = true,
    this.translations = kChartTranslations,
    this.languageCode = 'tr',
    this.timeFormat = TimeFormat.YEAR_MONTH_DAY,
    this.onLoadMore,
    this.fixedLength = 2,
    this.maDayList = const [5, 10, 20],
    this.flingTime = 600,
    this.flingRatio = 0.5,
    this.flingCurve = Curves.decelerate,
    this.isOnDrag,
    this.verticalTextAlignment = VerticalTextAlignment.left,
    this.bgColor = const [Color(0xFF0A0F17), Color(0xFF0A0F17)],
    this.kLineColor = const Color(0xff4C86CD),
    this.lineFillColor = const Color(0x554C86CD),
    this.lineFillInsideColor = const Color(0x00000000),
    this.ma5Color = const Color(0xffC9B885),
    this.ma10Color = const Color(0xff6CB0A6),
    this.ma30Color = const Color(0xff9979C6),
    this.upColor = const Color(0xFF2EBD85),
    this.dnColor = const Color(0xFFE84257),
    this.volColor = const Color(0xff4729AE),
    this.macdColor = const Color(0xff4729AE),
    this.difColor = const Color(0xffC9B885),
    this.deaColor = const Color(0xff6CB0A6),
    this.kColor = const Color(0xffC9B885),
    this.dColor = const Color(0xff6CB0A6),
    this.jColor = const Color(0xff9979C6),
    this.rsiColor = const Color(0xffC9B885),
    this.defaultTextColor = const Color(0xff60738E),
    this.nowPriceUpColor = const Color(0xFF2EBD85),
    this.nowPriceDnColor = const Color(0xFFE84257),
    this.nowPriceTextColor = const Color(0xffffffff),
    this.depthBuyColor = const Color(0xFF2EBD85),
    this.depthSellColor = const Color(0xFFE84257),
    this.selectBorderColor = const Color(0xff6C7A86),
    this.selectFillColor = const Color(0xFF101621),
    this.gridColor = const Color(0xff4c5c74),
    this.infoWindowNormalColor = const Color(0xffffffff),
    this.infoWindowTitleColor = const Color(0xffffffff),
    this.infoWindowUpColor = const Color(0xFF2EBD85),
    this.infoWindowDnColor = const Color(0xFFE84257),
    this.hCrossColor = const Color(0xffffffff),
    this.vCrossColor = const Color(0x1Effffff),
    this.crossTextColor = const Color(0xffffffff),
    this.trendLineColor = const Color(0xff4C86CD),
    this.maxColor = const Color(0xffffffff),
    this.minColor = const Color(0xffffffff),
  });

  @override
  _KChartWidgetState createState() => _KChartWidgetState();
}

class _KChartWidgetState extends State<KChartWidget>
    with TickerProviderStateMixin {
  double mScaleX = 0.5, mScrollX = 0.0, mSelectX = 0.0;
  StreamController<InfoWindowEntity?>? mInfoWindowStream;
  double mHeight = 0, mWidth = 0;
  AnimationController? _controller;
  Animation<double>? aniX;

  //For TrendLine
  List<TrendLine> lines = [];
  double? changeinXposition;
  double? changeinYposition;
  double mSelectY = 0.0;
  bool waitingForOtherPairofCords = false;
  bool enableCordRecord = false;

  double getMinScrollX() {
    return mScaleX;
  }

  double _lastScale = 0.5;
  bool isScale = false, isDrag = false, isLongPress = false, isOnTap = false;

  @override
  void initState() {
    super.initState();
    mInfoWindowStream = StreamController<InfoWindowEntity?>();
    mScaleX = widget.isLine ? 1.0 : 0.5;
    _lastScale = widget.isLine ? 1.0 : 0.5;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    mInfoWindowStream?.close();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.datas != null && widget.datas!.isEmpty) {
      mScrollX = mSelectX = 0.0;
      mScaleX = 1.0;
    }
    final _painter = ChartPainter(
      widget.chartStyle, widget.chartColors,
      lines: lines, //For TrendLine
      xFrontPadding: widget.xFrontPadding,
      isTrendLine: widget.isTrendLine, //For TrendLine
      selectY: mSelectY, //For TrendLine
      datas: widget.datas,
      scaleX: mScaleX,
      scrollX: mScrollX,
      selectX: mSelectX,
      isLongPass: isLongPress,
      isOnTap: isOnTap,
      isTapShowInfoDialog: widget.isTapShowInfoDialog,
      mainState: widget.mainState,
      volHidden: widget.volHidden,
      secondaryState: widget.secondaryState,
      isLine: widget.isLine,
      hideGrid: widget.hideGrid,
      showNowPrice: widget.showNowPrice,
      sink: mInfoWindowStream?.sink,
      fixedLength: widget.fixedLength,
      maDayList: widget.maDayList,
      verticalTextAlignment: widget.verticalTextAlignment,
      pointWidth: widget.pointWidth,
      bgColor: widget.bgColor,
      selectFillColor: widget.selectFillColor,
      selectBorderColor: widget.selectBorderColor,
      defaultTextColor: widget.defaultTextColor,
      crossTextColor: widget.crossTextColor,
      nowPriceUpColor: widget.nowPriceUpColor,
      nowPriceDnColor: widget.nowPriceDnColor,
      minColor: widget.minColor,
      maxColor: widget.maxColor,
      hCrossColor: widget.hCrossColor,
      vCrossColor: widget.vCrossColor,
      nowPriceTextColor: widget.nowPriceTextColor,
      trendLineColor: widget.trendLineColor,
      gridColor: widget.gridColor,
      kLineColor: widget.kLineColor,
      ma5Color: widget.ma5Color,
      ma10Color: widget.ma10Color,
      ma30Color: widget.ma30Color,
      lineFillColor: widget.lineFillColor,
      lineFillInsideColor: widget.lineFillInsideColor,
      upColor: widget.upColor,
      dnColor: widget.dnColor,
      rsiColor: widget.rsiColor,
      kColor: widget.kColor,
      dColor: widget.dColor,
      jColor: widget.jColor,
      difColor: widget.difColor,
      deaColor: widget.deaColor,
      macdColor: widget.macdColor,
      volColor: widget.volColor,
      textStyle: widget.textStyle,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        mHeight = constraints.maxHeight;
        mWidth = constraints.maxWidth;

        return GestureDetector(
          onTapUp: (details) {
            if (!widget.isTrendLine &&
                widget.onSecondaryTap != null &&
                _painter.isInSecondaryRect(details.localPosition)) {
              widget.onSecondaryTap!();
            }

            if (!widget.isTrendLine &&
                _painter.isInMainRect(details.localPosition)) {
              isOnTap = true;
              if (mSelectX != details.localPosition.dx &&
                  widget.isTapShowInfoDialog) {
                mSelectX = details.localPosition.dx;
                notifyChanged();
              }
            }
            if (widget.isTrendLine && !isLongPress && enableCordRecord) {
              enableCordRecord = false;
              var p1 = Offset(getTrendLineX(), mSelectY);
              if (!waitingForOtherPairofCords) {
                lines.add(TrendLine(
                    p1, Offset(-1, -1), trendLineMax!, trendLineScale!));
              }

              if (waitingForOtherPairofCords) {
                var a = lines.last;
                lines.removeLast();
                lines.add(TrendLine(a.p1, p1, trendLineMax!, trendLineScale!));
                waitingForOtherPairofCords = false;
              } else {
                waitingForOtherPairofCords = true;
              }
              notifyChanged();
            }
          },
          onHorizontalDragDown: (details) {
            if (!widget.isSwipe) return;
            if (isScale) return;
            isOnTap = false;
            _stopAnimation();
            _onDragChanged(true);
          },
          onHorizontalDragUpdate: (details) {
            if (!widget.isSwipe) return;
            if (isScale || isLongPress) return;
            mScrollX = ((details.primaryDelta ?? 0) / mScaleX + mScrollX)
                .clamp(0.0, ChartPainter.maxScrollX)
                .toDouble();
            notifyChanged();
          },
          onHorizontalDragEnd: (DragEndDetails details) {
            if (!widget.isSwipe) return;
            var velocity = details.velocity.pixelsPerSecond.dx;
            _onFling(velocity);
          },
          onHorizontalDragCancel: () {
            if (!widget.isSwipe) return;
            _onDragChanged(false);
          },
          onDoubleTap: () {
            if (!widget.isSwipe) return;
            mScaleX = (_lastScale * 1.3).clamp(0.2, 2.2);
            if (mScaleX == 2.2) {
              mScaleX = 0.2;
            }
            _lastScale = mScaleX;
            notifyChanged();
          },
          onScaleStart: (_) {
            if (!widget.isSwipe) return;
            isScale = true;
          },
          onScaleUpdate: (details) {
            if (!widget.isSwipe) return;
            mScaleX = (_lastScale * details.scale).clamp(0.2, 2.2);
            notifyChanged();
          },
          onScaleEnd: (_) {
            if (!widget.isSwipe) return;
            isScale = false;
            _lastScale = mScaleX;
          },
          onLongPressStart: (details) {
            isOnTap = false;
            isLongPress = true;
            if ((mSelectX != details.localPosition.dx ||
                    mSelectY != details.globalPosition.dy) &&
                !widget.isTrendLine) {
              mSelectX = details.localPosition.dx;
              notifyChanged();
            }
            //For TrendLine
            if (widget.isTrendLine && changeinXposition == null) {
              mSelectX = changeinXposition = details.localPosition.dx;
              mSelectY = changeinYposition = details.localPosition.dy;
              notifyChanged();
            }
            //For TrendLine
            if (widget.isTrendLine && changeinXposition != null) {
              changeinXposition = details.localPosition.dx;
              changeinYposition = details.globalPosition.dy;
              notifyChanged();
            }
          },
          onLongPressMoveUpdate: (details) {
            if ((mSelectX != details.localPosition.dx ||
                    mSelectY != details.globalPosition.dy) &&
                !widget.isTrendLine) {
              mSelectX = details.localPosition.dx;
              mSelectY = details.localPosition.dy;
              notifyChanged();
            }
            if (widget.isTrendLine) {
              mSelectX =
                  mSelectX + (details.localPosition.dx - changeinXposition!);
              changeinXposition = details.localPosition.dx;
              mSelectY =
                  mSelectY + (details.globalPosition.dy - changeinYposition!);
              changeinYposition = details.globalPosition.dy;
              notifyChanged();
            }
          },
          onLongPressEnd: (details) {
            isLongPress = false;
            enableCordRecord = true;
            mInfoWindowStream?.sink.add(null);
            notifyChanged();
          },
          child: Stack(
            children: <Widget>[
              CustomPaint(
                size: Size(double.infinity, double.infinity),
                painter: _painter,
              ),
              if (widget.showInfoDialog) _buildInfoDialog()
            ],
          ),
        );
      },
    );
  }

  void _stopAnimation({bool needNotify = true}) {
    if (_controller != null && _controller!.isAnimating) {
      _controller!.stop();
      _onDragChanged(false);
      if (needNotify) {
        notifyChanged();
      }
    }
  }

  void _onDragChanged(bool isOnDrag) {
    isDrag = isOnDrag;
    if (widget.isOnDrag != null) {
      widget.isOnDrag!(isDrag);
    }
  }

  void _onFling(double x) {
    _controller = AnimationController(
        duration: Duration(milliseconds: widget.flingTime), vsync: this);
    aniX = null;
    aniX = Tween<double>(begin: mScrollX, end: x * widget.flingRatio + mScrollX)
        .animate(CurvedAnimation(
            parent: _controller!.view, curve: widget.flingCurve));
    aniX!.addListener(() {
      mScrollX = aniX!.value;
      if (mScrollX <= 0) {
        mScrollX = 0;
        if (widget.onLoadMore != null) {
          widget.onLoadMore!(true);
        }
        _stopAnimation();
      } else if (mScrollX >= ChartPainter.maxScrollX) {
        mScrollX = ChartPainter.maxScrollX;
        if (widget.onLoadMore != null) {
          widget.onLoadMore!(false);
        }
        _stopAnimation();
      }
      notifyChanged();
    });
    aniX!.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        _onDragChanged(false);
        notifyChanged();
      }
    });
    _controller!.forward();
  }

  void notifyChanged() => setState(() {});

  late List<String> infos;

  Widget _buildInfoDialog() {
    return StreamBuilder<InfoWindowEntity?>(
        stream: mInfoWindowStream?.stream,
        builder: (context, snapshot) {
          if ((!isLongPress && !isOnTap) ||
              !snapshot.hasData ||
              snapshot.data?.kLineEntity == null) return Container();
          if (widget.isLine == true) {
            var entity = snapshot.data!.kLineEntity;
            infos = [
              getDate(entity.time),
              entity.close.toString(),
            ];
            final dialogPadding = 8.0;
            final dialogWidth = mWidth / 2.6;
            return Container(
              margin: EdgeInsets.only(
                  left: snapshot.data!.isLeft
                      ? dialogPadding
                      : mWidth - dialogWidth - dialogPadding,
                  top: 30),
              width: dialogWidth,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  color: widget.selectFillColor,
                  border:
                      Border.all(color: widget.selectBorderColor, width: 0.3)),
              child: ListView.builder(
                padding: EdgeInsets.all(dialogPadding),
                itemCount: infos.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final translations =
                      widget.translations[widget.languageCode]!;

                  return _buildItem(
                    infos[index],
                    translations.byIndexForLine(index),
                  );
                },
              ),
            );
          } else {
            var entity = snapshot.data!.kLineEntity;

            infos = [
              getDate(entity.time),
              entity.open.toString(),
              entity.high.toString(),
              entity.low.toString(),
              entity.close.toString(),
            ];
            final dialogPadding = 8.0;
            final dialogWidth = mWidth / 2.6;
            return Container(
              margin: EdgeInsets.only(
                  left: snapshot.data!.isLeft
                      ? dialogPadding
                      : mWidth - dialogWidth - dialogPadding,
                  top: 5),
              width: dialogWidth,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  color: widget.selectFillColor,
                  border:
                      Border.all(color: widget.selectBorderColor, width: 0.3)),
              child: ListView.builder(
                padding: EdgeInsets.all(dialogPadding),
                itemCount: infos.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  var translations = widget
                      .translations[widget.languageCode] ??= ChartTranslations(
                    date: 'Tarih:',
                    open: 'Açılış:',
                    high: 'Yüksek:',
                    low: 'Düşük:',
                    close: 'Kapanış:',
                  );
                  return _buildItem(
                    infos[index],
                    translations.byIndex(index),
                  );
                },
              ),
            );
          }
        });
  }

  Widget _buildItem(String info, String infoName) {
    var color = widget.infoWindowNormalColor;
    if (info.startsWith('+')) {
      color = widget.infoWindowUpColor;
    } else if (info.startsWith('-')) {
      color = widget.infoWindowDnColor;
    }
    final infoWidget = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Text(
            '$infoName',
            style: widget.infoWindowTitleTextStyle ??
                TextStyle(color: widget.infoWindowTitleColor, fontSize: 9.5),
            textScaleFactor: 1.0,
          ),
        ),
        Text(
          info,
          style: widget.infoWindowValueTextStyle ??
              TextStyle(
                color: color,
                fontSize: 9.5,
              ),
          textScaleFactor: 1.0,
        ),
      ],
    );
    return widget.materialInfoDialog
        ? Material(color: Colors.transparent, child: infoWidget)
        : infoWidget;
  }

  String getDate(int? date) => dateFormat(
      DateTime.fromMillisecondsSinceEpoch(
          date ?? DateTime.now().millisecondsSinceEpoch),
      widget.timeFormat);
}
