class ChartTranslations {
  final String date;
  final String open;
  final String high;
  final String low;
  final String close;

  const ChartTranslations({
    this.date = 'Tarih:',
    this.open = 'Açılış:',
    this.high = 'Yüksek:',
    this.low = 'Düşük:',
    this.close = 'Kapanış:',
  });

  String byIndex(int index) {
    switch (index) {
      case 0:
        return date;
      case 1:
        return open;
      case 2:
        return high;
      case 3:
        return low;
      case 4:
        return close;
    }

    throw UnimplementedError();
  }

  String byIndexForLine(int index) {
    switch (index) {
      case 0:
        return date;
      case 1:
        return close;
    }
    throw UnimplementedError();
  }
}

const kChartTranslations = {
  'tr': ChartTranslations(
    date: 'Tarih:',
    open: 'Açılış:',
    high: 'Yüksek:',
    low: 'Düşük:',
    close: 'Kapanış:',
  ),
  'en': ChartTranslations(
    date: 'Date:',
    open: 'Open:',
    high: 'High:',
    low: 'Low:',
    close: 'Close:',
  ),
};
