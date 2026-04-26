import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:netdania/app/features/widgets/add/add_symbol.dart';
import 'package:netdania/app/getX/trading_getX.dart';
import 'package:netdania/app/services/symbol_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:netdania/app/modules/home/view/symbol_detail_page.dart';

class EditSymbolPage extends StatefulWidget {
  const EditSymbolPage({super.key});

  @override
  State<EditSymbolPage> createState() => _EditSymbolPageState();
}

class _EditSymbolPageState extends State<EditSymbolPage> {
  final Set<String> _selectedSymbols = {};
  final SymbolStorageService _storageService = SymbolStorageService();
  bool _isLoading = true;
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _loadSelectedSymbols();
  }

  Future<void> _loadSelectedSymbols() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _currentUserId = prefs.getString('user_id');

      if (_currentUserId != null) {
        final saved = await _storageService.loadSelectedSymbols();
        setState(() {
          _selectedSymbols.addAll(saved);
          _isLoading = false;
        });
        debugPrint(
          'Loaded ${_selectedSymbols.length} symbols for user $_currentUserId',
        );
      } else {
        setState(() {
          _isLoading = false;
        });
        debugPrint('No user_id found in SharedPreferences');
      }
    } catch (e) {
      debugPrint('Error loading selected symbols: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveSelectedSymbols() async {
    if (_currentUserId == null) {
      _showCupertinoSnackBar('No user logged in', isError: true);
      return;
    }

    HapticFeedback.mediumImpact();

    await _storageService.saveSelectedSymbols(_selectedSymbols.toList());

    if (mounted) {
      _showCupertinoSnackBar(
        '${_selectedSymbols.length} symbols saved',
        isError: false,
      );

      // Navigate to HomePage after saving
      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted) {
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    }
  }

  void _showCupertinoSnackBar(String message, {required bool isError}) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder:
          (context) => CupertinoAlertDialog(
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isError
                        ? CupertinoIcons.xmark_circle_fill
                        : CupertinoIcons.check_mark_circled_solid,
                    color:
                        isError
                            ? CupertinoColors.systemRed
                            : CupertinoColors.systemGreen,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(message, style: const TextStyle(fontSize: 15)),
                  ),
                ],
              ),
            ),
          ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    });
  }

  void _toggleSymbol(String symbolCode) {
    HapticFeedback.selectionClick();
    setState(() {
      if (_selectedSymbols.contains(symbolCode)) {
        _selectedSymbols.remove(symbolCode);
      } else {
        _selectedSymbols.add(symbolCode);
      }
    });
  }

  void _selectAll(List<String> allSymbols) {
    HapticFeedback.mediumImpact();
    setState(() {
      _selectedSymbols.addAll(allSymbols);
    });
  }

  void _deselectAll() {
    HapticFeedback.mediumImpact();
    setState(() {
      _selectedSymbols.clear();
    });
  }

  Future<void> _navigateToSymbolDetail(
    int instrumentId,
    TradingChartController tradingController,
  ) async {
    if (!tradingController.hasInstrumentDetails(instrumentId)) {
      showCupertinoDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (context) =>
                const Center(child: CupertinoActivityIndicator(radius: 15)),
      );

      await tradingController.detailsInstruments(instrumentId);

      if (mounted) {
        Navigator.pop(context);
      }
    }

    final instrumentDetails = tradingController.getCachedInstrumentDetails(
      instrumentId,
    );

    if (instrumentDetails != null && mounted) {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder:
              (context) => SymbolDetailPage(
                instrumentDetails: instrumentDetails,
                instrumentId: instrumentId,
              ),
        ),
      );
    } else {
      if (mounted) {
        _showCupertinoSnackBar(
          'Failed to load instrument details',
          isError: true,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tradingController = Get.find<TradingChartController>();

    return Scaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      appBar: _buildAppBar(context, tradingController),
      body: SafeArea(
        child:
            _isLoading
                ? const Center(child: CupertinoActivityIndicator(radius: 15))
                : Obx(() {
                  if (!tradingController.instrumentsReady) {
                    return const Center(
                      child: CupertinoActivityIndicator(radius: 15),
                    );
                  }

                  final instrumentsList =
                      tradingController.instruments.values.toList();

                  if (instrumentsList.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.chart_bar,
                            size: 64,
                            color: CupertinoColors.systemGrey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No symbols available',
                            style: TextStyle(
                              fontSize: 17,
                              color: CupertinoColors.systemGrey,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return Stack(
                    children: [
                      Column(
                        children: [
                          // Selection header
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: CupertinoColors.systemBackground,
                              border: Border(
                                bottom: BorderSide(
                                  color: CupertinoColors.separator.withOpacity(
                                    0.3,
                                  ),
                                  width: 0.5,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  '${_selectedSymbols.length} Selected',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: CupertinoColors.label,
                                  ),
                                ),
                                const Spacer(),
                                CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  minSize: 0,
                                  onPressed:
                                      () => _selectAll(
                                        instrumentsList
                                            .map((e) => e.code ?? '')
                                            .where((c) => c.isNotEmpty)
                                            .toList(),
                                      ),
                                  child: const Text(
                                    'Select All',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      color: CupertinoColors.label,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  minSize: 0,
                                  onPressed: _deselectAll,
                                  child: const Text(
                                    'Clear',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      color: CupertinoColors.label,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Symbols list
                          Expanded(
                            child: ListView.separated(
                              padding: const EdgeInsets.only(bottom: 100),
                              itemCount: instrumentsList.length,
                              separatorBuilder:
                                  (context, index) => Divider(
                                    height: 1,
                                    thickness: 0.5,
                                    indent: 60,
                                    color: CupertinoColors.separator
                                        .withOpacity(0.3),
                                  ),
                              itemBuilder: (context, index) {
                                final instrument = instrumentsList[index];
                                final symbolCode = instrument.code ?? '';
                                final isSelected = _selectedSymbols.contains(
                                  symbolCode,
                                );

                                return Container(
                                  color: CupertinoColors.systemBackground,
                                  child: CupertinoListTile(
                                    onTap: () => _toggleSymbol(symbolCode),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 12,
                                    ),
                                    leading: GestureDetector(
                                      onTap: () => _toggleSymbol(symbolCode),
                                      child: Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color:
                                                isSelected
                                                    ? CupertinoColors.activeBlue
                                                    : CupertinoColors
                                                        .systemGrey3,
                                            width: 2,
                                          ),
                                          color:
                                              isSelected
                                                  ? CupertinoColors.activeBlue
                                                  : CupertinoColors.white,
                                        ),
                                        child:
                                            isSelected
                                                ? const Icon(
                                                  CupertinoIcons.check_mark,
                                                  size: 14,
                                                  color: CupertinoColors.white,
                                                )
                                                : null,
                                      ),
                                    ),
                                    title: Transform.scale(
                                      scaleY: 1.2,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        symbolCode,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: -0.5,
                                          color: CupertinoColors.label,
                                        ),
                                      ),
                                    ),
                                    subtitle: Text(
                                      instrument.name ?? 'No description',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: CupertinoColors.secondaryLabel,
                                      ),
                                    ),
                                    trailing: CupertinoButton(
                                      padding: EdgeInsets.zero,
                                      minSize: 0,
                                      onPressed: () {
                                        _navigateToSymbolDetail(
                                          instrument.instrumentId,
                                          tradingController,
                                        );
                                      },
                                      child: const Icon(
                                        CupertinoIcons.info_circle,
                                        color: CupertinoColors.systemGrey,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      // Floating save button
                      Positioned(
                        left: 20,
                        right: 20,
                        bottom: 20,
                        child: CupertinoButton(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          borderRadius: BorderRadius.circular(14),
                          color: CupertinoColors.activeBlue,
                          onPressed: _saveSelectedSymbols,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                CupertinoIcons.checkmark_alt,
                                size: 20,
                                color: CupertinoColors.white,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Save Selection',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: CupertinoColors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    TradingChartController tradingController,
  ) {
    return AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Text(
              'Select Symbols',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
      // actions: [
      //   IconButton(
      //     onPressed: () {
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(builder: (context) => AddSymbolPage()),
      //       );
      //     },
      //     icon: const Icon(Icons.add, color: Colors.black),
      //   ),
      // ],
    );
  }
}