import 'dart:convert';
import 'package:get/get.dart';
import 'package:netdania/app/getX/position_getx.dart';
import 'package:netdania/app/models/instrument_model.dart';

import 'package:netdania/screens/js/chart_js_functions.dart';
import 'package:netdania/screens/js/indicator_js_functions.dart';
import 'package:netdania/screens/js/position_js_functions.dart';
import 'package:netdania/screens/js/bottom_sheet_js_functions.dart';

class ChartHtmlGenerator {
  static String generateHtml({
    required List<Map<String, dynamic>> ohlcData,
    required String symbol,
    required int dotPosition,
    InstrumentModel? selectedInstrument,
  }) {
    final validData = ohlcData.where((candle) {
      return candle['time'] is int &&
          candle['open'] is double &&
          candle['high'] is double &&
          candle['low'] is double &&
          candle['close'] is double &&
          !candle['open'].isNaN &&
          !candle['high'].isNaN &&
          !candle['low'].isNaN &&
          !candle['close'].isNaN;
    }).toList();

    final positionLines = _getPositionLines(selectedInstrument);

    return '''
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
  <script src="https://unpkg.com/lightweight-charts@4.1.3/dist/lightweight-charts.standalone.production.js"></script>
  <style>
    ${_getStyles()}
  </style>
</head>
<body>
  <div id="info">
    <div id="symbol"><strong>${selectedInstrument?.code ?? symbol}</strong></div>
    <div id="price">Loading...</div>
  </div>
  <div id="live-indicator"><div class="pulse"></div>LIVE</div>
  <div id="loading-indicator">Loading more data...</div>

  <div id="bs-overlay" onclick="closeBottomSheet()"></div>
  <div id="bottom-sheet"></div>
  <div id="chart"></div>

  <script>
    ${_getJavaScript(validData, positionLines, dotPosition, symbol)}
  </script>
</body>
</html>
''';
  }

  static List<Map<String, dynamic>> _getPositionLines(InstrumentModel? selectedInstrument) {
    List<Map<String, dynamic>> positionLines = [];
    try {
      final positionController = Get.find<PositionsController>();
      positionLines = positionController.positionOrders
          .where((p) =>
              selectedInstrument != null &&
              p.instrumentId == selectedInstrument.instrumentId)
          .map((p) => {
                'price': p.orderPrice,
                'color': p.side == 1 ? '#26a69a' : '#ef5350',
                'label': '${p.side == 1 ? "▲ BUY" : "▼ SELL"} #${p.positionId}',
                'positionId': p.positionId,
                'side': p.side,
                'qty': p.positionQty,
                'sl': null,
                'tp': null,
              })
          .toList();
    } catch (_) {}
    return positionLines;
  }

  static String _getStyles() {
    return '''
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body {
      margin: 0; padding: 0; overflow: hidden;
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
      background: #ffffff;
    }
    #chart { width: 100vw; height: 100vh; }

    #info {
      position: absolute; top: 10px; left: 10px;
      background: rgba(255,255,255,0.95);
      padding: 12px; border-radius: 8px; font-size: 13px;
      pointer-events: none; z-index: 1000;
      box-shadow: 0 2px 8px rgba(0,0,0,0.15);
    }
    #loading-indicator {
      position: absolute; top: 50%; left: 10px;
      background: rgba(33,150,243,0.95); color: white;
      padding: 8px 16px; border-radius: 20px;
      font-size: 12px; font-weight: bold; z-index: 1000; display: none;
    }
    #live-indicator {
      position: absolute; top: 10px; right: 10px;
      background: rgba(38,166,154,0.95); color: white;
      padding: 6px 12px; border-radius: 20px;
      font-size: 11px; font-weight: bold; z-index: 1000;
      display: flex; align-items: center; gap: 6px;
    }
    .pulse { width:8px; height:8px; background:white; border-radius:50%; animation:pulse 2s infinite; }
    @keyframes pulse { 0%,100%{opacity:1} 50%{opacity:0.3} }
    .price-up   { color:#26a69a; font-weight:bold; }
    .price-down { color:#ef5350; font-weight:bold; }

    /* Bottom Sheet Styles */
    ${_getBottomSheetStyles()}

    /* Ripple Animation */
    .tap-ripple {
      position:fixed; width:44px; height:44px; border-radius:50%;
      background:rgba(245,158,11,0.25); border:2px solid rgba(245,158,11,0.7);
      pointer-events:none; z-index:4000;
      transform:translate(-50%,-50%) scale(0);
      animation:rippleOut 0.4s ease-out forwards;
    }
    @keyframes rippleOut {
      0%   { transform:translate(-50%,-50%) scale(0); opacity:1; }
      100% { transform:translate(-50%,-50%) scale(2.4); opacity:0; }
    }
    ''';
  }

  static String _getBottomSheetStyles() {
    return '''
    #bs-overlay {
      position: fixed; inset: 0; background: rgba(0,0,0,0.5);
      z-index: 3000; display: none;
    }
    #bottom-sheet {
      position: fixed; left:0; right:0; bottom:0;
      background: #ffffff; border-radius: 20px 20px 0 0;
      z-index: 3001; transform: translateY(100%);
      transition: transform 0.3s cubic-bezier(0.32,0.72,0,1);
      overflow-y: auto;
      padding-bottom: env(safe-area-inset-bottom, 20px);
      box-shadow: 0 -4px 20px rgba(0,0,0,0.15);
    }
    #bottom-sheet.open { transform: translateY(0); }
    .bs-handle-row { display:flex; justify-content:center; padding:12px 0 6px; }
    .bs-handle     { width:40px; height:4px; background:#d1d5db; border-radius:2px; }
    .bs-header     { display:flex; align-items:center; justify-content:space-between; padding:6px 20px 14px; border-bottom:1px solid #e5e7eb; }
    .bs-left       { display:flex; flex-direction:column; gap:3px; }
    .bs-instrument { font-size:20px; font-weight:800; color:#1f2937; letter-spacing:0.5px; }
    .bs-side-badge { font-size:11px; font-weight:700; padding:3px 10px; border-radius:20px; letter-spacing:0.5px; width:fit-content; }
    .bs-side-buy   { background:rgba(38,166,154,0.15); color:#26a69a; border:1px solid rgba(38,166,154,0.3); }
    .bs-side-sell  { background:rgba(239,83,80,0.15);  color:#ef5350; border:1px solid rgba(239,83,80,0.3); }
    .bs-entry-col  { display:flex; flex-direction:column; align-items:flex-end; gap:2px; }
    .bs-entry-label { font-size:10px; color:#6b7280; text-transform:uppercase; letter-spacing:1px; }
    .bs-entry-price { font-size:16px; font-weight:700; color:#1f2937; font-family:'SF Mono',monospace; }
    .sltp-row { display:flex; align-items:center; padding:16px 20px; gap:12px; border-bottom:1px solid #e5e7eb; transition:opacity 0.2s; }
    .sltp-row.disabled-row { opacity:0.45; }
    .sltp-color-bar { width:3px; height:40px; border-radius:2px; flex-shrink:0; }
    .sl-bar { background:#FF5252; }
    .tp-bar { background:#4CAF50; }
    .sltp-info { flex:1; min-width:0; }
    .sltp-title { font-size:10px; font-weight:700; text-transform:uppercase; letter-spacing:1px; margin-bottom:6px; }
    .sl-title { color:#FF5252; }
    .tp-title { color:#4CAF50; }
    .sltp-price-row { display:flex; align-items:center; gap:6px; }
    .sltp-price-input {
      background:#f9fafb; border:1px solid #d1d5db; border-radius:8px;
      color:#1f2937; font-size:13px; font-family:'SF Mono',monospace;
      padding:7px 10px; outline:none; width:130px; text-align:center;
      transition: border-color 0.15s, box-shadow 0.15s;
    }
    .sl-price-input:focus { border-color:#FF5252; box-shadow:0 0 0 2px rgba(255,82,82,0.15); }
    .tp-price-input:focus { border-color:#4CAF50; box-shadow:0 0 0 2px rgba(76,175,80,0.15); }
    .sltp-price-input:disabled { opacity:0.4; cursor:not-allowed; }
    .sltp-price-input::-webkit-inner-spin-button { display:none; }
    .sltp-pip-label { font-size:10px; color:#6b7280; white-space:nowrap; font-family:sans-serif; }
    .sltp-step-col { display:flex; flex-direction:column; gap:3px; }
    .step-btn-sm {
      width:28px; height:22px; border-radius:6px; border:1px solid #d1d5db;
      background:#f9fafb; color:#6b7280; font-size:15px; cursor:pointer;
      display:flex; align-items:center; justify-content:center; line-height:1; transition:all 0.12s;
    }
    .step-btn-sm:hover:not(:disabled) { background:#f3f4f6; color:#1f2937; }
    .step-btn-sm:disabled { opacity:0.3; cursor:not-allowed; }
    .toggle-wrap { flex-shrink:0; }
    .toggle-switch {
      position:relative; width:46px; height:26px; background:#e5e7eb;
      border-radius:13px; cursor:pointer; transition:background 0.2s;
      border:none; outline:none; display:block;
      -webkit-tap-highlight-color:transparent;
    }
    .toggle-switch.on-sl { background:#e53935; }
    .toggle-switch.on-tp { background:#43a047; }
    .toggle-knob {
      position:absolute; top:4px; left:4px; width:18px; height:18px;
      border-radius:50%; background:#9ca3af;
      transition:transform 0.2s, background 0.2s; pointer-events:none;
    }
    .toggle-switch.on-sl .toggle-knob,
    .toggle-switch.on-tp .toggle-knob { transform:translateX(20px); background:white; }
    .bs-confirm-row { padding:16px 20px 8px; }
    .bs-confirm-btn {
      width:100%; padding:15px; border-radius:12px; border:none;
      font-size:15px; font-weight:700; cursor:pointer;
      background:linear-gradient(135deg,#1e7b4f,#26a069); color:white;
      transition:all 0.15s; letter-spacing:0.3px;
    }
    .bs-confirm-btn:hover:not(:disabled) { background:linear-gradient(135deg,#26a069,#2ecc87); box-shadow:0 4px 16px rgba(38,160,105,0.35); }
    .bs-confirm-btn:disabled { opacity:0.35; cursor:not-allowed; }
    ''';
  }

  static String _getJavaScript(
    List<Map<String, dynamic>> validData,
    List<Map<String, dynamic>> positionLines,
    int dotPosition,
    String symbol,
  ) {
    return '''
    // Data
    let chartData     = ${jsonEncode(validData)};
    let positionLines = ${jsonEncode(positionLines)}; 
    let chart, candlestickSeries, indicatorSeries, livePriceSeries, askPriceSeries;
    let currentIndicator = 'none';
    let isChartReady  = false;
    let isLoadingMore = false;
    let lastVisibleRange = null;
    const dotPosition  = $dotPosition;
    const pip          = Math.pow(10, -dotPosition);
    const DEFAULT_PIPS = 5;

    // State
    const activePositions  = {};
    let selectedPositionId = null;
    const lastTapTime      = {};
    const DOUBLE_TAP_MS    = 350;

    ${_getChartFunctions()}
    ${_getBottomSheetFunctions()}
    ${_getPositionFunctions()}
    ${_getIndicatorFunctions()}
    ${_getInitFunction()}
    ''';
  }

  static String _getChartFunctions() {
    return ChartJsFunctions.functions;
  }

  static String _getBottomSheetFunctions() {
    return BottomSheetJsFunctions.functions;
  }

  static String _getPositionFunctions() {
    return PositionJsFunctions.functions;
  }

  static String _getIndicatorFunctions() {
    return IndicatorJsFunctions.functions;
  }

  static String _getInitFunction() {
    return '''
    // Initialization
    window.addEventListener('resize', function() { if (chart) chart.resize(window.innerWidth, window.innerHeight); });
    if (document.readyState === 'loading') { document.addEventListener('DOMContentLoaded', initChart); } else { initChart(); }
    ''';
  }
}