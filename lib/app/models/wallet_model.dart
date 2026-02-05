class WalletModel {
  final int walletId;
  final String walletUuid;
  final double balance;
  final double availableAmount;
  final double usedAmount;
  final double unclearedBalance;
  final String currencyCode;
  final double equity;
  final double unrealisedPl;

  WalletModel({
    required this.walletId,
    required this.walletUuid,
    required this.balance,
    required this.availableAmount,
    required this.usedAmount,
    required this.unclearedBalance,
    required this.currencyCode,
    required this.equity,
    required this.unrealisedPl,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json; // Handle both wrapped and unwrapped data
    
    return WalletModel(
      walletId: int.tryParse(data['wallet_id']?.toString() ?? '0') ?? 0,
      walletUuid: data['wallet_uuid'] ?? '',
      balance: double.tryParse(data['balance']?.toString() ?? '0') ?? 0.0,
      availableAmount: double.tryParse(data['available_amount']?.toString() ?? '0') ?? 0.0,
      usedAmount: double.tryParse(data['used_amount']?.toString() ?? '0') ?? 0.0,
      unclearedBalance: double.tryParse(data['uncleared_balance']?.toString() ?? '0') ?? 0.0,
      currencyCode: data['currency_code'] ?? 'USD',
      equity: double.tryParse(data['equity']?.toString() ?? '0') ?? 0.0,
      unrealisedPl: double.tryParse(data['unrealised_pl']?.toString() ?? '0') ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'wallet_id': walletId,
      'wallet_uuid': walletUuid,
      'balance': balance,
      'available_amount': availableAmount,
      'used_amount': usedAmount,
      'uncleared_balance': unclearedBalance,
      'currency_code': currencyCode,
      'equity': equity,
      'unrealised_pl': unrealisedPl,
    };
  }
}

class WalletResponse {
  final bool success;
  final int code;
  final String message;
  final WalletModel? data;

  WalletResponse({
    required this.success,
    required this.code,
    required this.message,
    this.data,
  });

  factory WalletResponse.fromJson(Map<String, dynamic> json) {
    return WalletResponse(
      success: json['success'] ?? false,
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null ? WalletModel.fromJson(json) : null,
    );
  }
}