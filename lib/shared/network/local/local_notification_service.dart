import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  LocalNotificationService();

  final _localNotificationService = FlutterLocalNotificationsPlugin();

  Future<void> intialize() async {
    const AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings('@drawable/ic_stat_elgomaa');
    DarwinInitializationSettings darwinInitializationSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
          onDidReceiveLocalNotification: onDidReceiveLocalNotification,
        );
    final InitializationSettings settings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: darwinInitializationSettings,
    );

    _localNotificationService.initialize(settings,onDidReceiveNotificationResponse: onReceiveLocalNotification);
  }
  
  Future<NotificationDetails> _notificationDetails() async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'channelId',
      'channelName',
      channelDescription: 'channelDesc',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true
    );
    const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails();
    return const NotificationDetails(android: androidNotificationDetails,iOS: darwinNotificationDetails,);
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body
}) async {
    final details = await _notificationDetails();
    await _localNotificationService.show(id, title, body, details);
  }

  void onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) {
    print('id $id');
  }

  void onReceiveLocalNotification(NotificationResponse details) {
    print('details $details');
  }
}