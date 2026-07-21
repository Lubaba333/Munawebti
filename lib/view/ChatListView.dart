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
        title:  Text("chat".tr),
        centerTitle: true,
      ),

      body: Obx(() {

        if (controller.isConversationLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.conversations.isEmpty) {
          return  Center(
            child: Text("No Conversations".tr),
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
                      conversation.lastMessageAt == null
                          ? ""
                          : "${conversation.lastMessageAt!.hour.toString().padLeft(2, '0')}:${conversation.lastMessageAt!.minute.toString().padLeft(2, '0')}"
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

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.chat),
        onPressed: () async {

          await controller.getSupervisors();

          Get.bottomSheet(

            Obx(() {

              if(controller.isSupervisorsLoading.value){
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return Container(
                height: 500,
                color: Theme.of(context).cardColor,

                child: ListView.builder(

                  itemCount: controller.supervisors.length,

                  itemBuilder: (_,index){

                    final supervisor =
                    controller.supervisors[index];

                    return ListTile(

                      leading: const CircleAvatar(
                        child: Icon(Icons.person),
                      ),

                      title: Text(
                        supervisor.fullName,
                      ),

                      subtitle: Text(
                        supervisor.email,
                      ),

                      onTap: (){

                        Get.back();

                        Get.to(
                              ()=>ChatView(

                            conversationId: 0,

                            receiverId: supervisor.id,

                            receiverName:
                            supervisor.fullName,

                          ),
                        );

                      },

                    );

                  },
                ),
              );
            }),
          );

        },
      ),
    );
  }



}