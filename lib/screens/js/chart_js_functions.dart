/// JavaScript functions for chart initialization and management
class ChartJsFunctions {
  static const String functions = '''
// ── Chart Initialization ──────────────────────────────────────────
function initChart() {
  try {
    if (!chartData || !chartData.length) {
      document.getElementById('price').innerHTML = '<div style="color:red">No data</div>';
      return;
    }

    chart = LightweightCharts.createChart(document.getElementById('chart'), {
      layout: { background:{color:'#FFFFFF'}, textColor:'#333' },
      grid: { vertLines:{color:'#f0f0f0'}, horzLines:{color:'#f0f0f0'} },
      width: window.innerWidth,
      height: window.innerHeight,
      timeScale: {
        timeVisible: true,
        secondsVisible: true,
        rightOffset: 12,
        barSpacing: 3,
        minBarSpacing: 0.5,
        fixLeftEdge: false,
        fixRightEdge: false,
        lockVisibleTimeRangeOnResize: true,
        rightBarStaysOnScroll: true,
        borderVisible: true,
        borderColor: '#e1e1e1',
        visible: true,
      },
      crosshair: {
        mode: LightweightCharts.CrosshairMode.Normal,
        vertLine: {
          width: 1,
          color: '#758696',
          style: LightweightCharts.LineStyle.Dashed,
          labelBackgroundColor: '#4682B4'
        },
        horzLine: {
          width: 1,
          color: '#758696',
          style: LightweightCharts.LineStyle.Dashed,
          labelBackgroundColor: '#4682B4'
        },
      },
      rightPriceScale: {
        borderVisible: true,
        borderColor: '#e1e1e1',
        visible: true,
        scaleMargins: { top: 0.1, bottom: 0.1 }
      },
    });

    candlestickSeries = chart.addCandlestickSeries({
      upColor: '#26a69a',
      downColor: '#ef5350',
      borderVisible: false,
      wickUpColor: '#26a69a',
      wickDownColor: '#ef5350',
      priceFormat: {
        type: 'price',
        precision: dotPosition,
        minMove: pip
      },
    });

    setTimeout(function() {
      candlestickSeries.setData(chartData);
      addLivePriceLine();
      renderPositionLines();       
      setupInteractionListeners();

      chart.subscribeCrosshairMove(function(param) {
        if (param.time) {
          const d = param.seriesData.get(candlestickSeries);
          if (d) updatePriceInfo(d);
        } else {
          showLatestPrice();
        }
      });

      chart.timeScale().subscribeVisibleTimeRangeChange(function() {
        const vr = chart.timeScale().getVisibleRange();
        if (!vr || isLoadingMore) return;
        
        if (chartData && chartData.length > 0) {
          const firstTime = chartData[0].time;
          const near = chartData.filter(function(c) {
            return c.time >= vr.from && c.time <= firstTime + 20 * 60;
          }).length;
          
          if (near > 0 && vr.from <= firstTime + 20 * 60) {
            isLoadingMore = true;
            document.getElementById('loading-indicator').style.display = 'block';
            if (window.FlutterChannel) {
              window.FlutterChannel.postMessage('load_more_data:' + firstTime);
            }
          }
        }
        lastVisibleRange = vr;
      });

      showLatestPrice();
      isChartReady = true;
      renderPositionLines(); // ← ensures positions drawn before notifying Flutter

      if (window.FlutterChannel) {
        window.FlutterChannel.postMessage('chart_initialized');
      }
      console.log('Chart initialized');
    }, 200);

  } catch (err) {
    console.error('initChart error:', err);
    document.getElementById('price').innerHTML = 
      '<div style="color:red">Error: ' + err.message + '</div>';
  }
}

// ── Live Price Line ───────────────────────────────────────────────
function addLivePriceLine() {
  livePriceSeries = chart.addLineSeries({
    color: '#EF5350',
    lineWidth: 1,
    lineStyle: LightweightCharts.LineStyle.Dotted,
    priceLineVisible: false,
    lastValueVisible: false,
  });
  
  askPriceSeries = chart.addLineSeries({
    color: '#26A69A',
    lineWidth: 1,
    lineStyle: LightweightCharts.LineStyle.Dotted,
    priceLineVisible: false,
    lastValueVisible: false,
  });
}

function updateLivePrice(mid) {
  if (!livePriceSeries || !chartData.length) return;

  const last = chartData[chartData.length - 1];

  livePriceSeries.update({
    time: last.time,
    value: mid
  });
}

// ── Real-time Candle Updates ──────────────────────────────────────
function updateChart(newCandle) {
  if (!isChartReady || !chartData || !chartData.length) return;
  
  const last = chartData[chartData.length - 1];
  const newT = Number(newCandle.time);
  const lstT = Number(last.time);
  
  if (isNaN(newT) || isNaN(lstT) || newT < lstT) return;
  
  if (newT === lstT) {
    last.high = Math.max(last.high, newCandle.high);
    last.low = Math.min(last.low, newCandle.low);
    last.close = newCandle.close;
    candlestickSeries.update(last);
  } else {
    const nc = {
      time: newT,
      open: newCandle.open,
      high: newCandle.high,
      low: newCandle.low,
      close: newCandle.close
    };
    chartData.push(nc);
    candlestickSeries.update(nc);
  }
  
  showLatestPrice();
}

// ── Prepend Historical Data ───────────────────────────────────────
function prependHistoricalData(newCandles) {
  if (!isChartReady || !newCandles || !newCandles.length) return;
  
  newCandles.sort(function(a, b) { return a.time - b.time; });
  chartData = newCandles.concat(chartData);
  candlestickSeries.setData(chartData);
  
  if (currentIndicator !== 'none') {
    changeIndicator(currentIndicator);
  }
  
  document.getElementById('loading-indicator').style.display = 'none';
  isLoadingMore = false;
}

// ── Price Display ─────────────────────────────────────────────────
function updatePriceInfo(data) {
  const up = data.close >= data.open;
  document.getElementById('price').innerHTML =
    '<div class="' + (up ? 'price-up' : 'price-down') + '">' +
    'O:' + data.open.toFixed(dotPosition) + 
    ' H:' + data.high.toFixed(dotPosition) +
    ' L:' + data.low.toFixed(dotPosition) + 
    ' C:' + data.close.toFixed(dotPosition) + '</div>';
}

function showLatestPrice() {
  if (!chartData || !chartData.length) return;
  
  const last = chartData[chartData.length - 1];
  const up = last.close >= last.open;
  
  document.getElementById('price').innerHTML =
    '<div class="' + (up ? 'price-up' : 'price-down') + '">' +
    'Latest: ' + last.close.toFixed(dotPosition) + '</div>';
}
''';
}