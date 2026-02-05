import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:netdania/app/models/instrument_detail_model.dart';

class SymbolDetailPage extends StatelessWidget {
  final InstrumentDetailsModel instrumentDetails;
  final int instrumentId;

  const SymbolDetailPage({
    super.key,
    required this.instrumentDetails,
    required this.instrumentId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      appBar: AppBar(
        title: Text(instrumentDetails.code),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Icon and Title
                    Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: CupertinoColors.activeBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Text(
                              instrumentDetails.code.substring(0, 1).toUpperCase(),
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w600,
                                color: CupertinoColors.activeBlue,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                instrumentDetails.code,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: CupertinoColors.label,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                instrumentDetails.name,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: CupertinoColors.secondaryLabel,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (instrumentDetails.description != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: CupertinoColors.systemGrey6,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          instrumentDetails.description!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: CupertinoColors.secondaryLabel,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Status Section
            _buildSection(
              'Status',
              [
                _buildStatusTile('Enabled', instrumentDetails.enabled, CupertinoColors.systemGreen),
                _buildStatusTile('Available for Trading', instrumentDetails.isAvailableForTrading, CupertinoColors.activeBlue),
                _buildStatusTile('Available for Watchlist', instrumentDetails.isAvailableForWatchList, CupertinoColors.systemOrange),
                if (instrumentDetails.allowShortSelling)
                  _buildStatusTile('Short Selling Allowed', instrumentDetails.allowShortSelling, CupertinoColors.systemPurple),
              ],
            ),

            // Basic Information
            _buildSection(
              'Basic Information',
              [
                _buildInfoTile('Instrument ID', instrumentId.toString()),
                _buildInfoTile('Source Code', instrumentDetails.sourceCode),
                if (instrumentDetails.isin != null) _buildInfoTile('ISIN', instrumentDetails.isin!),
                if (instrumentDetails.exchangeName != null) _buildInfoTile('Exchange', instrumentDetails.exchangeName!),
                _buildInfoTile('Currency ID', instrumentDetails.currencyId.toString()),
                if (instrumentDetails.quoteCurrencyId != null)
                  _buildInfoTile('Quote Currency ID', instrumentDetails.quoteCurrencyId.toString()),
                _buildInfoTile('Market ID', instrumentDetails.marketId.toString()),
              ],
            ),

            // Trading Parameters
            _buildSection(
              'Trading Parameters',
              [
                _buildInfoTile('Contract Size', instrumentDetails.contractSize.toString()),
                _buildInfoTile('Tick Size', instrumentDetails.tickSize.toString()),
                _buildInfoTile('Decimal Places', instrumentDetails.decimalPlaces.toString()),
                _buildInfoTile('Min Order Qty', instrumentDetails.minOrderQty.toString()),
                _buildInfoTile('Max Order Qty', instrumentDetails.maxOrderQty.toString()),
                _buildInfoTile('Order Qty Step', instrumentDetails.orderQtyStep.toString()),
                if (instrumentDetails.priceTick != null)
                  _buildInfoTile('Price Tick', instrumentDetails.priceTick.toString()),
              ],
            ),

            // Spread & Interest
            _buildSection(
              'Spread & Interest',
              [
                _buildInfoTile('Spread Bid', instrumentDetails.spreadBid.toString()),
                _buildInfoTile('Spread Ask', instrumentDetails.spreadAsk.toString()),
                _buildInfoTile('Spread Type ID', instrumentDetails.spreadTypeId.toString()),
                _buildInfoTile('Buy Interest Rate', '${instrumentDetails.buyInterestRate}%'),
                _buildInfoTile('Sell Interest Rate', '${instrumentDetails.sellInterestRate}%'),
                if (instrumentDetails.rolloverPip != null)
                  _buildInfoTile('Rollover Pip', instrumentDetails.rolloverPip.toString()),
              ],
            ),

            // Margin Requirements
            _buildSection(
              'Margin Requirements',
              [
                _buildInfoTile('Initial Margin', '${instrumentDetails.initialMargin}%'),
                if (instrumentDetails.initialSellMargin != null)
                  _buildInfoTile('Initial Sell Margin', '${instrumentDetails.initialSellMargin}%'),
                _buildInfoTile('Limit Order Margin', '${instrumentDetails.limitOrderMargin}%'),
                _buildInfoTile('Liquidation Margin', '${instrumentDetails.liquidationMargin}%'),
                _buildInfoTile('Intraday Order Margin', '${instrumentDetails.intradayOrderMargin}%'),
                _buildInfoTile('Overnight Margin', '${instrumentDetails.overnightMargin}%'),
                _buildInfoTile('BTST Order Margin', '${instrumentDetails.btstOrderMargin}%'),
                if (instrumentDetails.minMarginLeverageLimit != null)
                  _buildInfoTile('Min Margin Leverage Limit', instrumentDetails.minMarginLeverageLimit.toString()),
              ],
            ),

            // Order Limits
            _buildSection(
              'Order Limits',
              [
                _buildInfoTile('Limit Min Pips', instrumentDetails.limitMinPips.toString()),
                _buildInfoTile('Stop Min Pips', instrumentDetails.stopMinPips.toString()),
                if (instrumentDetails.circuitLimit != null)
                  _buildInfoTile('Circuit Limit', instrumentDetails.circuitLimit.toString()),
                if (instrumentDetails.circuitLimitUp != null)
                  _buildInfoTile('Circuit Limit Up', instrumentDetails.circuitLimitUp.toString()),
                if (instrumentDetails.circuitLimitDown != null)
                  _buildInfoTile('Circuit Limit Down', instrumentDetails.circuitLimitDown.toString()),
                if (instrumentDetails.maxSpreadLimit != null)
                  _buildInfoTile('Max Spread Limit', instrumentDetails.maxSpreadLimit.toString()),
              ],
            ),

            // Commission & Fees
            _buildSection(
              'Commission & Fees',
              [
                _buildInfoTile('Commission', instrumentDetails.commission.toString()),
                _buildInfoTile('Auto Execution Tolerance', instrumentDetails.autoExecutionTolerance.toString()),
              ],
            ),

            // Technical Information
            _buildSection(
              'Technical Information',
              [
                _buildInfoTile('Instrument Type ID', instrumentDetails.instrumentTypeId.toString()),
                _buildInfoTile('Trading Status ID', instrumentDetails.tradingStatusId.toString()),
                _buildInfoTile('Chart Mode ID', instrumentDetails.chartModeId.toString()),
                _buildInfoTile('Margin Calc Mode ID', instrumentDetails.marginCalcModeId.toString()),
                _buildInfoTile('P/L Calc Mode ID', instrumentDetails.plCalcModeId.toString()),
                _buildInfoTile('Calc Mode ID', instrumentDetails.calcModeId.toString()),
                _buildInfoTile('Hedge Mode ID', instrumentDetails.hedgeModeId.toString()),
                _buildInfoTile('Auto Execution Mode ID', instrumentDetails.autoExecutionModeId.toString()),
                _buildInfoTile('Unit ID', instrumentDetails.unitId.toString()),
                _buildInfoTile('Price Unit ID', instrumentDetails.priceUnitId.toString()),
                if (instrumentDetails.priceUnitValue != null)
                  _buildInfoTile('Price Unit Value', instrumentDetails.priceUnitValue.toString()),
              ],
            ),

            // Additional Settings
            _buildSection(
              'Additional Settings',
              [
                _buildInfoTile('Point', instrumentDetails.point.toString()),
                _buildInfoTile('LS Digit Length', instrumentDetails.lsDigitLength.toString()),
                _buildInfoTile('MS Digit Length', instrumentDetails.msDigitLength.toString()),
                _buildInfoTile('Smoothing Ticks', instrumentDetails.smoothingTicks.toString()),
                _buildInfoTile('Ignore Wrong Tick Count', instrumentDetails.ignoreWrongTickCount.toString()),
                _buildInfoTile('Cut Off Limit Percent CP', instrumentDetails.cutOffLimitPercentCp.toString()),
                if (instrumentDetails.maxUpdateFrequency != null)
                  _buildInfoTile('Max Update Frequency', instrumentDetails.maxUpdateFrequency.toString()),
                if (instrumentDetails.maxHoldingDays != null)
                  _buildInfoTile('Max Holding Days', instrumentDetails.maxHoldingDays.toString()),
              ],
            ),

            // Dates & Timeline
            if (instrumentDetails.creationDate != null ||
                instrumentDetails.fnd != null ||
                instrumentDetails.ltd != null)
              _buildSection(
                'Dates & Timeline',
                [
                  if (instrumentDetails.creationDate != null)
                    _buildInfoTile('Creation Date', instrumentDetails.creationDate!),
                  if (instrumentDetails.fnd != null) _buildInfoTile('FND', instrumentDetails.fnd!),
                  if (instrumentDetails.ltd != null) _buildInfoTile('LTD', instrumentDetails.ltd!),
                  _buildInfoTile('Last Update Time', instrumentDetails.lastUpdateTime),
                ],
              ),

            // Route Information
            _buildSection(
              'Route Information',
              [
                _buildInfoTile('Trade Route ID', instrumentDetails.tradeRouteId.toString()),
                _buildInfoTile('Default Route ID', instrumentDetails.defaultRouteId.toString()),
                _buildInfoTile('Current Trade Session Setting ID', instrumentDetails.currentTradeSessionSettingId.toString()),
              ],
            ),

            // Extra Information
            if (instrumentDetails.extraInfo != null ||
                instrumentDetails.orderSettings != null ||
                instrumentDetails.orderSettings2 != null)
              _buildSection(
                'Extra Information',
                [
                  if (instrumentDetails.extraInfo != null)
                    _buildTextTile('Extra Info', instrumentDetails.extraInfo!),
                  if (instrumentDetails.orderSettings != null)
                    _buildTextTile('Order Settings', instrumentDetails.orderSettings!),
                  if (instrumentDetails.orderSettings2 != null)
                    _buildTextTile('Order Settings 2', instrumentDetails.orderSettings2!),
                ],
              ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: CupertinoColors.secondaryLabel,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            decoration: BoxDecoration(
              color: CupertinoColors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: children,
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: CupertinoColors.separator.withOpacity(0.5),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                color: CupertinoColors.label,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: CupertinoColors.secondaryLabel,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTile(String label, bool status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: CupertinoColors.separator.withOpacity(0.5),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              color: CupertinoColors.label,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: status ? color.withOpacity(0.1) : CupertinoColors.systemGrey5,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  status ? CupertinoIcons.check_mark_circled_solid : CupertinoIcons.xmark_circle_fill,
                  size: 16,
                  color: status ? color : CupertinoColors.systemGrey,
                ),
                const SizedBox(width: 6),
                Text(
                  status ? 'Yes' : 'No',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: status ? color : CupertinoColors.systemGrey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextTile(String label, String text) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: CupertinoColors.separator.withOpacity(0.5),
            width: 0.5,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: CupertinoColors.secondaryLabel,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              color: CupertinoColors.label,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}