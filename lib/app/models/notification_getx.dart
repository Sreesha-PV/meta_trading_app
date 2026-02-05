// import 'package:get/get_state_manager/src/simple/get_controllers.dart';

// class WebSocketController extends GetxController {
//   var activeOrders = <Order>[].obs;
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   @override
//   void onInit() {
//     super.onInit();
//     _initNotifications();
//     _connectWebSocket();
//   }

//   void _initNotifications() async {
//     var android = AndroidInitializationSettings('@mipmap/ic_launcher');
//     var ios = IOSInitializationSettings();
//     var initSettings = InitializationSettings(android: android, iOS: ios);
//     await flutterLocalNotificationsPlugin.initialize(initSettings);
//   }

//   void _connectWebSocket() {
//     final token = 'your_api_token';
//     NotificationService().connect(token);

//     NotificationService().notifications.listen((notification) {
//       if (notification.type == NotificationType.placeOrder ||
//           notification.type == NotificationType.updateOrder) {
//         _handleOrderNotification(notification.data);
//       }
//     });
//   }

//   void _handleOrderNotification(Map<String, dynamic> data) {
//     var orders = (data['orders'] as List)
//         .map((e) => Order.fromJson(e))
//         .toList();

//     for (var order in orders) {
//       if (!activeOrders.any((ao) => ao.id == order.id)) {
//         _showNotification('New Order', '${order.symbol} has been placed.');
//       }
//     }

//     activeOrders.assignAll(orders);
//   }

//   void _showNotification(String title, String body) async {
//     var android =
//         AndroidNotificationDetails('channelId', 'channelName', importance: Importance.high);
//     var platform = NotificationDetails(android: android);
//     await flutterLocalNotificationsPlugin.show(0, title, body, platform);
//   }
// }



// class NotificationService {
//   FlutterLocalNotificationsPlugin notif = FlutterLocalNotificationsPlugin();

//   void initNotification() {
//     var android = AndroidInitializationSettings('@mipmap/ic_launcher');
//     var settings = InitializationSettings(android: android);
//     notif.initialize(settings);
//   }

//   void connect() {
//     initNotification();

//     channel.stream.listen((message) {
//       print("Received: $message");
//       _handleMessage(message);
//     });
//   }

//   void _handleMessage(dynamic msg) {
//     final data = jsonDecode(msg);

//     if (data['type'] == 'order_update') {
//       _showNotif(
//         "Order ${data['status']}",
//         "Order ${data['order_id']} is ${data['status']}",
//       );
//     }
//   }

//   void _showNotif(String title, String body) {
//     var android = AndroidNotificationDetails(
//       'orders', 'Order Updates',
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//     var platform = NotificationDetails(android: android);
//     notif.show(0, title, body, platform);
//   }
// }