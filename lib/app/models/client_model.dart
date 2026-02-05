class UserProfileResponse {
  final int code;
  final String message;
  final UserProfileData data;

  UserProfileResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
    return UserProfileResponse(
      code: json["code"] ?? 0,
      message: json["message"] ?? '',
      data: UserProfileData.fromJson(json["data"] ?? {}),
    );
  }
}

class UserProfileData {
  final int userId;
  final String email;
  final String? name; // ✅ Made nullable
  final List<Account> accounts;

  UserProfileData({
    required this.userId,
    required this.email,
    this.name,
    required this.accounts,
  });

  factory UserProfileData.fromJson(Map<String, dynamic> json) {
    return UserProfileData(
      userId: json["user_id"] ?? 0,
      email: json["email"] ?? '',
      name: json["name"], // ✅ Can be null
      accounts: (json["accounts"] as List?)
              ?.map((e) => Account.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class Account {
  final int accountId;
  final String accountUuid;
  final int accountTypeId;
  final String? name; // ✅ Made nullable
  final bool tradingEnabled;
  final bool enabled;
  final int groupId;
  final String accountCreationDate;
  final int? organizationId; // ✅ Made nullable
  final String? remarks; // ✅ Made nullable
  final String? interestWaiveoffExpiryDate; // ✅ Made nullable
  final int? hedgeModeId; // ✅ Made nullable
  final int? autoExecutionModeId; // ✅ Made nullable
  final int? currencyId; // ✅ Made nullable
  final int? storageWaiveoffDays; // ✅ Made nullable
  final int? storageWaiveoffModeId; // ✅ Made nullable
  final int? tradingStatusId; // ✅ Made nullable
  final String? emailId; // ✅ Made nullable
  final int? agentAccountId; // ✅ Made nullable
  final int? marginStatusId; // ✅ Made nullable
  final int? stopOutLevel; // ✅ Made nullable
  final int? creditRating; // ✅ Made nullable
  final bool? isSimulationAccount; // ✅ Made nullable
  final String? lastUpdateTime; // ✅ Made nullable
  final bool? isRolloverAccount; // ✅ Made nullable
  final String? availableOrderTypes; // ✅ Made nullable
  final int? ibAccountId; // ✅ Made nullable
  final int? highlightColor; // ✅ Made nullable
  final int? parentAccountId; // ✅ Made nullable
  final String? accountSettings1; // ✅ Made nullable
  final int? tradingFeature; // ✅ Made nullable
  final int? tradingFeatureInheritance; // ✅ Made nullable
  final String? accountSettings2; // ✅ Made nullable

  Account({
    required this.accountId,
    required this.accountUuid,
    required this.accountTypeId,
    this.name,
    required this.tradingEnabled,
    required this.enabled,
    required this.groupId,
    required this.accountCreationDate,
    this.organizationId,
    this.remarks,
    this.interestWaiveoffExpiryDate,
    this.hedgeModeId,
    this.autoExecutionModeId,
    this.currencyId,
    this.storageWaiveoffDays,
    this.storageWaiveoffModeId,
    this.tradingStatusId,
    this.emailId,
    this.agentAccountId,
    this.marginStatusId,
    this.stopOutLevel,
    this.creditRating,
    this.isSimulationAccount,
    this.lastUpdateTime,
    this.isRolloverAccount,
    this.availableOrderTypes,
    this.ibAccountId,
    this.highlightColor,
    this.parentAccountId,
    this.accountSettings1,
    this.tradingFeature,
    this.tradingFeatureInheritance,
    this.accountSettings2,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      accountId: json["account_id"] ?? 0,
      accountUuid: json["account_uuid"] ?? '',
      accountTypeId: json["account_type_id"] ?? 0,
      name: json["name"], // Can be null
      tradingEnabled: json["trading_enabled"] ?? false,
      enabled: json["enabled"] ?? false,
      groupId: json["group_id"] ?? 0,
      accountCreationDate: json["account_creation_date"] ?? '',
      organizationId: json["organization_id"],
      remarks: json["remarks"],
      interestWaiveoffExpiryDate: json["interest_waiveoff_expiry_date"],
      hedgeModeId: json["hedge_mode_id"],
      autoExecutionModeId: json["auto_execution_mode_id"],
      currencyId: json["currency_id"],
      storageWaiveoffDays: json["storage_waiveoff_days"],
      storageWaiveoffModeId: json["storage_waiveoff_mode_id"],
      tradingStatusId: json["trading_status_id"],
      emailId: json["email_id"],
      agentAccountId: json["agent_account_id"],
      marginStatusId: json["margin_status_id"],
      stopOutLevel: json["stop_out_level"],
      creditRating: json["credit_rating"],
      isSimulationAccount: json["is_simulation_account"],
      lastUpdateTime: json["last_update_time"],
      isRolloverAccount: json["is_rollover_account"],
      availableOrderTypes: json["available_order_types"],
      ibAccountId: json["ib_account_id"],
      highlightColor: json["highlight_color"],
      parentAccountId: json["parent_account_id"],
      accountSettings1: json["account_settings1"],
      tradingFeature: json["trading_feature"],
      tradingFeatureInheritance: json["trading_feature_inheritance"],
      accountSettings2: json["account_settings2"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'account_id': accountId,
      'account_uuid': accountUuid,
      'account_type_id': accountTypeId,
      'name': name,
      'trading_enabled': tradingEnabled,
      'enabled': enabled,
      'group_id': groupId,
      'account_creation_date': accountCreationDate,
      'organization_id': organizationId,
      'remarks': remarks,
      'interest_waiveoff_expiry_date': interestWaiveoffExpiryDate,
      'hedge_mode_id': hedgeModeId,
      'auto_execution_mode_id': autoExecutionModeId,
      'currency_id': currencyId,
      'storage_waiveoff_days': storageWaiveoffDays,
      'storage_waiveoff_mode_id': storageWaiveoffModeId,
      'trading_status_id': tradingStatusId,
      'email_id': emailId,
      'agent_account_id': agentAccountId,
      'margin_status_id': marginStatusId,
      'stop_out_level': stopOutLevel,
      'credit_rating': creditRating,
      'is_simulation_account': isSimulationAccount,
      'last_update_time': lastUpdateTime,
      'is_rollover_account': isRolloverAccount,
      'available_order_types': availableOrderTypes,
      'ib_account_id': ibAccountId,
      'highlight_color': highlightColor,
      'parent_account_id': parentAccountId,
      'account_settings1': accountSettings1,
      'trading_feature': tradingFeature,
      'trading_feature_inheritance': tradingFeatureInheritance,
      'account_settings2': accountSettings2,
    };
  }
}