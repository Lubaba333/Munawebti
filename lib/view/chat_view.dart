import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/ChatController.dart';
import '../widgets/message_bubble.dart';



class ChatView extends StatefulWidget {

  final int conversationId;

  final int receiverId;

  final String receiverName;

  const ChatView({
    super.key,
    required this.conversationId,
    required this.receiverId,
    required this.receiverName,
  });

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final ChatController controller = Get.find<ChatController>();

  @override
  void initState() {
    super.initState();

    controller.messages.clear();

    controller.conversationId.value = widget.conversationId;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getMessages(
        receiverId: widget.receiverId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverName),
      ),

      body: Column(
        children: [

          Expanded(
            child: Obx(() {

              if (controller.isMessagesLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (controller.messages.isEmpty) {
                return const Center(
                  child: Text("ابدأ المحادثة 👋"),
                );
              }

              return ListView.builder(
                controller: controller.scrollController,
                reverse: false,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                itemCount: controller.messages.length +
                    (controller.isLoadingMore.value ? 1 : 0),
                itemBuilder: (_, index) {

                  if (controller.isLoadingMore.value &&
                      index == 0) {
                    return const Padding(
                      padding: EdgeInsets.all(10),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  final realIndex =
                  controller.isLoadingMore.value
                      ? index - 1
                      : index;

                  return MessageBubble(
                    message: controller.messages[realIndex],
                  );
                },
              );
            }),
          ),

          _buildInput(),
        ],
      ),
    );
  }

  Widget _buildInput() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [

            Expanded(
              child: TextField(
                controller: controller.messageController,
                decoration: const InputDecoration(
                  hintText: "اكتب رسالة...",
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            const SizedBox(width: 8),
      Obx(
            () => IconButton(
          icon: controller.isSending.value
              ? const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          )
              : const Icon(Icons.send),
          onPressed: controller.isSending.value
              ? null
              : () {
            controller.sendMessage(
              receiverId: widget.receiverId,
            );
          },
        ),
            ),
          ],
        ),
      ),
    );
  }
}