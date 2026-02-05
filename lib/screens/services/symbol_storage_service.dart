import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class SymbolStorageService {
  static const String _keyPrefix = 'selected_symbols_';
  final GetStorage _storage = GetStorage();

  // Generate key with account ID
  String _getKey(String userId) => '$_keyPrefix$userId';

  Future<String?> _getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  Future<void> saveSelectedSymbols(List<String> symbols) async {
    final userId = await _getCurrentUserId();
    if (userId == null) {
      debugPrint('No user_id found in SharedPreferences');
      return;
    }
    await _storage.write(_getKey(userId), symbols);
    debugPrint('Saved ${symbols.length} symbols for user $userId');
  }

  Future<void> saveSelectedSymbolsForUser(String userId, List<String> symbols) async {
    await _storage.write(_getKey(userId), symbols);
    debugPrint('Saved ${symbols.length} symbols for user $userId');
  }

  Future<List<String>> loadSelectedSymbols() async {
    final userId = await _getCurrentUserId();
    if (userId == null) {
      debugPrint('No user_id found in SharedPreferences');
      return [];
    }
    final data = _storage.read<List>(_getKey(userId));
    final symbols = data?.map((e) => e.toString()).toList() ?? [];
    debugPrint('Loaded ${symbols.length} symbols for user $userId');
    return symbols;
  }

  List<String> loadSelectedSymbolsForUser(String userId) {
    final data = _storage.read<List>(_getKey(userId));
    return data?.map((e) => e.toString()).toList() ?? [];
  }

  Future<bool> isSymbolSelected(String symbol) async {
    final symbols = await loadSelectedSymbols();
    return symbols.contains(symbol);
  }

  bool isSymbolSelectedForUser(String userId, String symbol) {
    final symbols = loadSelectedSymbolsForUser(userId);
    return symbols.contains(symbol);
  }

  Future<void> addSymbol(String symbol) async {
    final symbols = await loadSelectedSymbols();
    if (!symbols.contains(symbol)) {
      symbols.add(symbol);
      await saveSelectedSymbols(symbols);
    }
  }

  Future<void> addSymbolForUser(String userId, String symbol) async {
    final symbols = loadSelectedSymbolsForUser(userId);
    if (!symbols.contains(symbol)) {
      symbols.add(symbol);
      await saveSelectedSymbolsForUser(userId, symbols);
    }
  }

  Future<void> removeSymbol(String symbol) async {
    final symbols = await loadSelectedSymbols();
    symbols.remove(symbol);
    await saveSelectedSymbols(symbols);
  }

  Future<void> removeSymbolForUser(String userId, String symbol) async {
    final symbols = loadSelectedSymbolsForUser(userId);
    symbols.remove(symbol);
    await saveSelectedSymbolsForUser(userId, symbols);
  }

  Future<void> clearCurrentUserSymbols() async {
    final userId = await _getCurrentUserId();
    if (userId == null) return;
    await _storage.remove(_getKey(userId));
    debugPrint('Cleared all symbols for user $userId');
  }

  Future<void> clearUserSymbols(String userId) async {
    await _storage.remove(_getKey(userId));
    debugPrint('Cleared all symbols for user $userId');
  }

  Future<void> clearAllAccounts() async {
    final keys = _storage.getKeys();
    for (var key in keys) {
      if (key.toString().startsWith(_keyPrefix)) {
        await _storage.remove(key);
      }
    }
    debugPrint('Cleared symbols for all users');
  }

  Future<int> getSelectedCount() async {
    final symbols = await loadSelectedSymbols();
    return symbols.length;
  }

  int getSelectedCountForUser(String userId) {
    return loadSelectedSymbolsForUser(userId).length;
  }
}