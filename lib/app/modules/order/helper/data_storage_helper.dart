// import 'package:get_storage/get_storage.dart';

// class DataStorageHelper {
//   static final _storage = GetStorage();

//   // Save account info
//   static Future<void> saveAccountInfo(int accountId, String accountUuid) async {
//     await _storage.write('account_id', accountId);
//     await _storage.write('account_uuid', accountUuid);
//   }

//   // Get account ID
//   static Future<int> getAccountId() async {
//     return _storage.read('account_id') ?? 0;
//   }

//   // Get account UUID
//   static Future<String> getAccountUuid() async {
//     return _storage.read('account_uuid') ?? '';
//   }
// }
