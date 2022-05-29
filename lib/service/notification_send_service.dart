import 'package:fchatty/models/client_user.model.dart';
import 'package:fchatty/models/message.model.dart';
import 'package:http/http.dart' as http;

class NotificationSendService {
  Future<bool> sendNotification(Message sendMessage, ClientUser sendUser, String token) async {
    String endURL = "https://fcm.googleapis.com/fcm/send";
    String firebaseKey =
        "AAAAUwAD-Wc:APA91bFcQhPNazn3xtQAGt246FIHzITWSoU5ckxH_5NTomynqT1iqcFRxGNpQcjNjKF9wWoAqzjBOT2od0X6NNSFg6IDWZ9Fq7KxIgxgM0x9fkznRXMc1LDQPSzb82JYAUGMR5wdE9qX";
    Map<String, String> headers = {"Content-type": "application/json", "Authorization": "key=$firebaseKey"};

    String json = '{ "to" : "$token","priority" : "high",'
        ' "notification":null,'
        ' "data" : { "click_action": "FLUTTER_NOTIFICATION_CLICK",'
        ' "message" : "${sendMessage.message}", "title": "${sendUser.userName} new message", '
        ' "sendUserProfileURL": "${sendUser.profilURL}", "sendUserEmail": "${sendUser.email}" ,'
        '"sendUserId" : "${sendUser.userId}" ,"sendUserUserName" : "${sendUser.userName}" } }';
    try {
      http.Response response = await http.post(
        Uri.parse(endURL),
        headers: headers,
        body: json,
      );

      if (response.statusCode == 200) {
        //debugPrint("********PUSHOK");
        return true;
      } else {
        //debugPrint("********PUSH-----------------");
        return false;
      }
    } catch (e) {
      //debugPrint("##################HATA" + e.toString());
      return false;
    }
  }
}
