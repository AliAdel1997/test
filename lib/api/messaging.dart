import 'dart:convert';

import 'package:http/http.dart';
import 'package:meta/meta.dart';

class Messaging {
  static final Client client = Client();

  // from 'https://console.firebase.google.com'
  // --> project settings --> cloud messaging --> "Server key"
  static const String serverKey =
//      "AAAABKwrM-c:APA91bES504WteBt_WOhI0PaKL5fRlp9Ll6VikjMTr-oQh4OnBeUjCwHBHa-YGCXuWAXpLW6LgZcyX9jAEHcmpVVtLdd9_-qAMYUO5R3XZkJzSIwdePuYAjr_xdr3ApSnsDhH0hX7pA4";
      'AAAA4CkJIbk:APA91bEr7cUjWJAVMUu0Q9ZdcmNTdZeeGyH0-ZtcjhjIARxZqTPlAqCx3ZbkcEIKclIFbhDPYGLg_Vy5_5U3NTvHDn3KRrRsKR_8UfLWcDnuP3GLBwgrqVkyKJtznDR1jai9D5OXK8lq';

  static Future<Response> sendToAll({
    @required String title,
    @required String body,
  }) =>
      sendToTopic(title: title, body: body, topic: 'all');

  static Future<Response> sendToTopic(
          {@required String title,
          @required String body,
          @required String topic}) =>
      sendTo(title: title, body: body, fcmToken: '/topics/$topic');

  static Future<Response> sendTo({
    @required String title,
    @required String body,
    @required String fcmToken,
  }) =>
      client.post(
        'https://fcm.googleapis.com/fcm/send',
        body: json.encode({
          'notification': {'body': '$body', 'title': '$title'},
          'priority': 'high',
          'data': {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
          },
          'to': '$fcmToken',
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
      );
}
