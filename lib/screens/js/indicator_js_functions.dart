/// JavaScript functions for technical indicators
class IndicatorJsFunctions {
  static const String functions = '''
// ── Indicator Management ──────────────────────────────────────────
function changeIndicator(indicator) {
  currentIndicator = indicator;
  
  if (indicatorSeries) {
    chart.removeSeries(indicatorSeries);
    indicatorSeries = null;
  }
  
  if (indicator === 'none') return;
  
  if (indicator === 'sma20') {
    addSMA(20);
  } else if (indicator === 'sma50') {
    addSMA(50);
  } else if (indicator === 'ema20') {
    addEMA(20);
  }
}

function addSMA(period) {
  indicatorSeries = chart.addLineSeries({
    color: '#2962FF',
    lineWidth: 2,
    title: 'SMA(' + period + ')'
  });
  indicatorSeries.setData(calculateSMA(chartData, period));
}

function addEMA(period) {
  indicatorSeries = chart.addLineSeries({
    color: '#FF6D00',
    lineWidth: 2,
    title: 'EMA(' + period + ')'
  });
  indicatorSeries.setData(calculateEMA(chartData, period));
}

// ── SMA Calculation ───────────────────────────────────────────────
function calculateSMA(data, period) {
  const result = [];
  
  for (let i = period - 1; i < data.length; i++) {
    let sum = 0;
    for (let j = 0; j < period; j++) {
      sum += data[i - j].close;
    }
    result.push({
      time: data[i].time,
      value: sum / period
    });
  }
  
  return result;
}

// ── EMA Calculation ───────────────────────────────────────────────
function calculateEMA(data, period) {
  const result = [];
  const k = 2 / (period + 1);
  let ema = data[0].close;
  
  for (let i = 0; i < data.length; i++) {
    if (i === 0) {
      ema = data[i].close;
    } else {
      ema = (data[i].close - ema) * k + ema;
    }
    
    result.push({
      time: data[i].time,
      value: ema
    });
  }
  
  return result;
}
''';
}