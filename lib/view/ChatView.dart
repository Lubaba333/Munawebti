import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../const/app_colors.dart';
import '../controller/ChatController.dart';

class ChatView extends StatelessWidget {
  final controller = Get.put(ChatController());
  final TextEditingController inputCtrl = TextEditingController();

  ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        title: Row(
          children: [
            const CircleAvatar(
              radius: 18,
              child: Icon(Icons.person),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Supervisor Chat",
                    style: TextStyle(fontSize: 16)),
                Text("Online",
                    style: TextStyle(fontSize: 12)),
              ],
            )
          ],
        ),
      ),

      body: Column(
        children: [

          /// 💬 الرسائل
          Expanded(
            child: Obx(() => ListView.builder(
                  padding: const EdgeInsets.all(15),
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    final msg = controller.messages[index];
                    return _messageBubble(context, msg);
                  },
                )),
          ),

          /// ✏️ Input
          _inputArea(context),
        ],
      ),
    );
  }

  /// 💬 Bubble
  Widget _messageBubble(BuildContext context, Map msg) {
    final isMe = msg['isMe'];

    return Align(
      alignment:
          isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 250),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primary : Theme.of(context).cardColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(15),
            topRight: const Radius.circular(15),
            bottomLeft:
                Radius.circular(isMe ? 15 : 0),
            bottomRight:
                Radius.circular(isMe ? 0 : 15),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
            )
          ],
        ),
        child: Text(
          msg['text'],
          style: TextStyle(
            color: isMe
                ? Colors.white
                : Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
      ),
    );
  }

  /// ✏️ Input Area
  Widget _inputArea(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10)
        ],
      ),
      child: Row(
        children: [

          /// TextField
          Expanded(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: inputCtrl,
                decoration: const InputDecoration(
                  hintText: "Type message...",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          /// Send Button
          GestureDetector(
            onTap: () {
              controller.sendMessage(inputCtrl.text);
              inputCtrl.clear();
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient:
                    LinearGradient(colors: AppColors.buttonGradient),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.send, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}