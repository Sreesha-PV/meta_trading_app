import 'package:flutter/material.dart';
import 'package:netdania/app/models/instrument_model.dart';
import 'package:netdania/screens/chart/chart_controller.dart';

class ChartTradeCard extends StatefulWidget {
  final ChartController controller;
  final InstrumentModel? selectedInstrument;
  final VoidCallback onClose;
  final Function(double ask, double lotSize) onBuy;
  final Function(double bid, double lotSize) onSell;

  const ChartTradeCard({
    super.key,
    required this.controller,
    required this.selectedInstrument,
    required this.onClose,
    required this.onBuy,
    required this.onSell,
  });

  @override
  State<ChartTradeCard> createState() => _ChartTradeCardState();
}

class _ChartTradeCardState extends State<ChartTradeCard> {
  double _lotSize = 0.01;
  static const double _minLot = 0.01;
  static const double _maxLot = 100.0;
  static const double _step = 0.01;

  void _incrementLot() {
    setState(() {
      _lotSize = double.parse(
        (_lotSize + _step).clamp(_minLot, _maxLot).toStringAsFixed(2),
      );
    });
  }

  void _decrementLot() {
    setState(() {
      _lotSize = double.parse(
        (_lotSize - _step).clamp(_minLot, _maxLot).toStringAsFixed(2),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, dynamic>?>(
      stream: widget.controller.latestPriceStream,
      builder: (context, snapshot) {
        final bid = snapshot.data?['bid'] as double?;
        final ask = snapshot.data?['ask'] as double?;
        final dotPosition = widget.controller.currentDotPosition;

        final bidText = bid?.toStringAsFixed(dotPosition) ?? '--';
        final askText = ask?.toStringAsFixed(dotPosition) ?? '--';

        return Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(),
                const SizedBox(height: 12),
                _buildLotSelector(),
                const SizedBox(height: 12),
                _buildButtons(bid, ask, bidText, askText),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.selectedInstrument?.code ?? widget.controller.currentSymbol,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        GestureDetector(
          onTap: widget.onClose,
          child: const Icon(Icons.close, size: 20, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildLotSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          // Label
          const Text(
            'Lot Size',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const Spacer(),
          // Decrement Button
          _buildArrowButton(
            icon: Icons.chevron_left,
            onTap: _lotSize > _minLot ? _decrementLot : null,
          ),
          const SizedBox(width: 8),
          // Lot Value
          Container(
            width: 64,
            alignment: Alignment.center,
            child: Text(
              _lotSize.toStringAsFixed(2),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Increment Button
          _buildArrowButton(
            icon: Icons.chevron_right,
            onTap: _lotSize < _maxLot ? _incrementLot : null,
          ),
        ],
      ),
    );
  }

  Widget _buildArrowButton({
    required IconData icon,
    required VoidCallback? onTap,
  }) {
    final bool enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: enabled ? Colors.white : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: enabled ? Colors.grey.shade400 : Colors.grey.shade200,
          ),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ]
              : [],
        ),
        child: Icon(
          icon,
          size: 20,
          color: enabled ? Colors.black87 : Colors.grey.shade400,
        ),
      ),
    );
  }

  Widget _buildButtons(
    double? bid,
    double? ask,
    String bidText,
    String askText,
  ) {
    return Row(
      children: [
        Expanded(child: _buildSellButton(bid, bidText)),
        const SizedBox(width: 12),
        Expanded(child: _buildBuyButton(ask, askText)),
      ],
    );
  }

  Widget _buildSellButton(double? bid, String bidText) {
    final bool enabled = bid != null;
    return GestureDetector(
      onTap: enabled ? () => widget.onSell(bid!, _lotSize) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: enabled
              ? const Color(0xFFef5350)
              : const Color(0xFFef5350).withOpacity(0.4),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            const Text(
              'SELL',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              bidText,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBuyButton(double? ask, String askText) {
    final bool enabled = ask != null;
    return GestureDetector(
      onTap: enabled ? () => widget.onBuy(ask!, _lotSize) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: enabled
              ? const Color(0xFF26a69a)
              : const Color(0xFF26a69a).withOpacity(0.4),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            const Text(
              'BUY',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              askText,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
      ),
    );
  }
}