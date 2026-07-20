import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/ChatController.dart';
import 'chat_view.dart';

class ChatListView extends StatelessWidget {
  ChatListView({super.key});

  final ChatController controller = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats"),
        centerTitle: true,
      ),

      body: Obx(() {

        if (controller.isConversationLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.conversations.isEmpty) {
          return const Center(
            child: Text("No Conversations"),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),

          itemCount: controller.conversations.length,

          separatorBuilder: (_, __) =>
          const Divider(height: 1),

          itemBuilder: (_, index) {

            final conversation =
            controller.conversations[index];

            return ListTile(

              leading: const CircleAvatar(
                radius: 25,
                child: Icon(Icons.person),
              ),

              title: Text(
                conversation.otherUserName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              subtitle: Text(
                conversation.lastMessage,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              trailing: Column(
                mainAxisAlignment:
                MainAxisAlignment.center,

                crossAxisAlignment:
                CrossAxisAlignment.end,

                children: [

                  Text(
                    conversation.lastMessageAt.isEmpty
                        ? ""
                        : conversation.lastMessageAt.substring(11, 16),
                  ),

                  const SizedBox(height: 6),

                  if (conversation.unreadCount > 0)
                    CircleAvatar(
                      radius: 10,
                      child: Text(
                        conversation.unreadCount.toString(),
                        style: const TextStyle(
                          fontSize: 11,
                        ),
                      ),
                    ),
                ],
              ),

              onTap: () {

                Get.to(
                      () => ChatView(
                        conversationId: conversation.id,
                        receiverId: conversation.otherUserId,
                        receiverName: conversation.otherUserName,
                      )
                );

              },
            );
          },
        );
      }),
    );
  }
}