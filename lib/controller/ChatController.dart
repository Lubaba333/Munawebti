import 'package:get/get.dart';

class ChatController extends GetxController {
  var messages = <Map>[].obs;

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;

    messages.add({
      "text": text,
      "isMe": true,
      "time": DateTime.now(),
    });

    /// 🔥 Fake reply (تجريبي)
    Future.delayed(Duration(milliseconds: 800), () {
      messages.add({
        "text": "تم الاستلام 👍",
        "isMe": false,
        "time": DateTime.now(),
      });
    });
  }
}