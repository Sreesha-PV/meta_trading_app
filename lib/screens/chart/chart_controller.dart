import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:netdania/app/models/instrument_model.dart';
import 'package:netdania/screens/services/ohlc_service.dart';

enum ChartState {
  loading,
  ready,
  error,
  noData,
}

/// Controller for managing chart state and operations
class ChartController {
  final String initialSymbol;
  final String initialTimeframe;

  ChartController({
    required String symbol,
    required this.initialTimeframe,
  }) : initialSymbol = symbol.isEmpty ? 'EURUSD' : symbol {
    _init();
  }

  // State streams
  final _stateController = StreamController<ChartState>.broadcast();
  final _timeframeController = StreamController<String>.broadcast();
  final _indicatorController = StreamController<String>.broadcast();
  final _dataController = StreamController<List<Map<String, dynamic>>>.broadcast();
  final _latestPriceController = StreamController<Map<String, dynamic>?>.broadcast();

  Stream<ChartState> get stateStream => _stateController.stream;
  Stream<String> get timeframeStream => _timeframeController.stream;
  Stream<String> get indicatorStream => _indicatorController.stream;
  Stream<List<Map<String, dynamic>>> get dataStream => _dataController.stream;
  Stream<Map<String, dynamic>?> get latestPriceStream => _latestPriceController.stream;

  // Internal state
  List<Map<String, dynamic>> _ohlcData = [];
  String _currentSymbol = '';
  String _selectedTimeframe = '';
  String _selectedIndicator = 'none';
  InstrumentModel? _selectedInstrument;
  Map<String, dynamic>? _currentCandle;
  bool _chartInitialized = false;
  bool _canUpdate = true;
  Timer? _updateThrottleTimer;

  // Getters
  List<Map<String, dynamic>> get ohlcData => _ohlcData;
  String get currentSymbol => _currentSymbol;
  String get selectedTimeframe => _selectedTimeframe;
  String get selectedIndicator => _selectedIndicator;
  InstrumentModel? get selectedInstrument => _selectedInstrument;
  bool get isChartInitialized => _chartInitialized;
  int get currentDotPosition => _selectedInstrument?.decimalPlaces ?? 5;

  void _init() {
    _currentSymbol = initialSymbol;
    _selectedTimeframe = initialTimeframe;
    _initializeChart();
  }

  Future<void> _initializeChart() async {
    _stateController.add(ChartState.loading);

    try {
      final data = await OHLCService.fetchOHLC(
        symbol: _currentSymbol,
        resolution: _selectedTimeframe,
      );

      print('✅ Fetched ${data.length} candles for timeframe $_selectedTimeframe');

      _ohlcData = data;
      _dataController.add(_ohlcData);

      if (data.isEmpty) {
        _stateController.add(ChartState.noData);
        return;
      }

      _stateController.add(ChartState.ready);
    } catch (e) {
      print('❌ Error loading chart for $_currentSymbol: $e');
      _stateController.add(ChartState.error);
    }
  }

  void setChartInitialized(bool initialized) {
    _chartInitialized = initialized;
  }

  void setSelectedInstrument(InstrumentModel instrument) {
    _selectedInstrument = instrument;
  }

  Future<void> changeSymbol(String newSymbol) async {
    _currentSymbol = newSymbol.isEmpty ? 'EURUSD' : newSymbol;
    _chartInitialized = false;
    _currentCandle = null;
    _ohlcData.clear();
    await _initializeChart();
  }

  Future<void> changeTimeframe(String newTimeframe) async {
    if (_selectedTimeframe == newTimeframe) return;

    print('🔄 Changing timeframe from $_selectedTimeframe to $newTimeframe');

    _selectedTimeframe = newTimeframe;
    _timeframeController.add(newTimeframe);
    _chartInitialized = false;
    _currentCandle = null;
    _stateController.add(ChartState.loading);

    try {
      final data = await OHLCService.fetchOHLC(
        symbol: _currentSymbol,
        resolution: newTimeframe,
      );

      print('✅ Fetched ${data.length} candles for timeframe $newTimeframe');

      _ohlcData = data;
      _dataController.add(_ohlcData);

      if (data.isEmpty) {
        _stateController.add(ChartState.noData);
      } else {
        _stateController.add(ChartState.ready);
      }
    } catch (e) {
      print('❌ Error changing timeframe: $e');
      _stateController.add(ChartState.error);
    }
  }

  void changeIndicator(String newIndicator) {
    _selectedIndicator = newIndicator;
    _indicatorController.add(newIndicator);
  }

  Future<List<Map<String, dynamic>>> loadMoreHistoricalData(int earliestTimestamp) async {
    try {
      final timeframeSeconds = getTimeframeSeconds(_selectedTimeframe);
      final candlesToLoad = 300;
      final to = earliestTimestamp;
      final from = to - (timeframeSeconds * candlesToLoad);

      print('🔄 Fetching OHLC: symbol=$_currentSymbol, from=$from, to=$to, resolution=$_selectedTimeframe');

      final newData = await OHLCService.fetchOHLC(
        symbol: _currentSymbol,
        resolution: _selectedTimeframe,
        from: from,
        to: to,
      );

      print('✅ Fetched ${newData.length} historical candles');

      if (newData.isNotEmpty) {
        final existingTimes = _ohlcData.map((c) => c['time'] as int).toSet();
        final newCandles = newData.where((c) => !existingTimes.contains(c['time'])).toList();

        if (newCandles.isNotEmpty) {
          print('📊 Adding ${newCandles.length} new candles to chart');
          _ohlcData.insertAll(0, newCandles);
          return newCandles;
        }
      }
      return [];
    } catch (e) {
      print('❌ Error loading more historical data: $e');
      rethrow;
    }
  }

  void updateCandle({
    required double bid,
    required double ask,
    required DateTime timestamp,
  }) {
    if (!_chartInitialized) return;
    if (!_canUpdate) return;

    _canUpdate = false;
    _updateThrottleTimer?.cancel();
    _updateThrottleTimer = Timer(const Duration(milliseconds: 100), () {
      _canUpdate = true;
    });

    final price = ask;
    final timeframeSeconds = getTimeframeSeconds(_selectedTimeframe);
    final candleTime = (timestamp.millisecondsSinceEpoch ~/ 1000) ~/
        timeframeSeconds *
        timeframeSeconds;

    if (_ohlcData.isNotEmpty) {
      final lastHistoricalCandle = _ohlcData.last;
      final lastHistoricalTime = lastHistoricalCandle['time'] as int;
      if (candleTime < lastHistoricalTime) {
        print('⚠️ Ignoring old tick: $candleTime < $lastHistoricalTime');
        return;
      }
    }

    if (_currentCandle == null || _currentCandle!['time'] != candleTime) {
      _currentCandle = {
        'time': candleTime,
        'open': price,
        'high': price,
        'low': price,
        'close': price,
      };
    } else {
      _currentCandle!['high'] = math.max(
        _currentCandle!['high'] as double,
        price,
      );
      _currentCandle!['low'] = math.min(
        _currentCandle!['low'] as double,
        price,
      );
      _currentCandle!['close'] = price;
    }

    _latestPriceController.add({
      'bid': bid,
      'ask': ask,
      'open': _currentCandle!['open'],
      'high': _currentCandle!['high'],
      'low': _currentCandle!['low'],
      'close': _currentCandle!['close'],
    });
  }

  Map<String, dynamic>? getCurrentCandle() => _currentCandle;

  int getTimeframeSeconds(String timeframe) {
    switch (timeframe) {
      case '1m':
        return 60;
      case '5m':
        return 300;
      case '15m':
        return 900;
      case '30m':
        return 1800;
      case '1h':
        return 3600;
      case '4h':
        return 14400;
      case '1D':
        return 86400;
      case '1W':
        return 604800;
      case '1M':
        return 2592000;
      case '3M':
        return 7776000;
      case '6M':
        return 15552000;
      case '1Y':
        return 31536000;
      case '5Y':
        return 157680000;
      default:
        return 60;
    }
  }

  void dispose() {
    _updateThrottleTimer?.cancel();
    _stateController.close();
    _timeframeController.close();
    _indicatorController.close();
    _dataController.close();
    _latestPriceController.close();
  }
}