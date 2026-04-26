import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:netdania/app/services/symbol_storage_service.dart';

class SymbolFilterController extends GetxController {
  final SymbolStorageService _symbolStorage = SymbolStorageService();

  final RxList<String> _selectedSymbols = <String>[].obs;
  final RxBool _isLoading = true.obs;

  RxList<String> get selectedSymbolsRx => _selectedSymbols;
  List<String> get selectedSymbols => _selectedSymbols;
  RxBool get isLoading => _isLoading;

  @override
  void onInit() {
    super.onInit();
    loadSelectedSymbols();
  }

  @override
  void onClose() {
    _selectedSymbols.clear();
    debugPrint('🧹 SymbolFilterController closed and cleared');
    super.onClose();
  }

  Future<void> loadSelectedSymbols() async {
    try {
      _isLoading.value = true;
      final symbols = await _symbolStorage.loadSelectedSymbols();
      _selectedSymbols.value = symbols;
      debugPrint('✅ Loaded ${symbols.length} selected symbols: $symbols');
    } catch (e) {
      debugPrint('❌ Error loading selected symbols: $e');
      _selectedSymbols.value = [];
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> addSymbol(String symbol) async {
    try {
      await _symbolStorage.addSymbol(symbol);
      await loadSelectedSymbols();
      debugPrint('➕ Added symbol: $symbol');
    } catch (e) {
      debugPrint('❌ Error adding symbol: $e');
    }
  }

  Future<void> removeSymbol(String symbol) async {
    try {
      await _symbolStorage.removeSymbol(symbol);
      await loadSelectedSymbols();
      debugPrint('➖ Removed symbol: $symbol');
    } catch (e) {
      debugPrint('❌ Error removing symbol: $e');
    }
  }

  Future<void> clearAllSymbols() async {
    try {
      await _symbolStorage.clearCurrentUserSymbols();
      _selectedSymbols.clear();
      debugPrint('🗑️ Cleared all symbols');
    } catch (e) {
      debugPrint('❌ Error clearing symbols: $e');
    }
  }

  bool isSymbolSelected(String symbol) {
    return _selectedSymbols.contains(symbol);
  }

  int get selectedCount => _selectedSymbols.length;
}
