import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import 'constants.dart';

sendNotification(
    {required String title,
    required String body,
    required List<String> token,
    required Map<String, String> dataMap}) async {
  final data = {
    'click_action': 'FLUTTER_NOTIFICATION_CLICK',
    'id': '1',
  };
  data.addEntries(dataMap.entries);
  try {
    http.Response response =
        await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization':
                  'key=AAAAIQpKLz8:APA91bGrkGZ4IwQALszhmjSkHG2BafWxzn1wIfL5kIgdPAkDciH8h1je8A3y6oMf5v16mgZv6YSnE41nk_orXb8hMU4oqIhGKE033pY5EEQv8EhAFHyQCMKwxos_BqWLWGS0DZE4oL9I'
            },
            body: jsonEncode(<String, dynamic>{
              'notification': <String, dynamic>{'title': title, 'body': body},
              'priority': 'high',
              'data': data,
              // 'to': token[0]
              'registration_ids': token
            }));

    if (response.statusCode == 200) {
      log("Notification Sent");
    } else {
      log("Notification Sent but issues");
    }
  } catch (e) {
    log(e.toString());
  }
}

sendPlanNotification() {
  firebaseMessaging.sendMessage();
}
