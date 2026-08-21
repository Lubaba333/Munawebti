import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/ChatController.dart';
import 'chat_view.dart';

class ChatListView extends StatelessWidget {
  ChatListView({super.key});

  final ChatController controller =
  Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("chat".tr),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              controller.getConversations();
            },
          ),
        ],
      ),

      // =========================================================
      // Conversations
      // =========================================================

      body: Obx(() {
        if (controller.isConversationLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.conversations.isEmpty) {
          return RefreshIndicator(
            onRefresh: () async {
              await controller.getConversations();
            },
            child: ListView(
              physics:
              const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height:
                  MediaQuery.of(context).size.height *
                      0.7,
                  child: Center(
                    child: Text(
                      "No Conversations".tr,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await controller.getConversations();
          },
          child: ListView.separated(
            physics:
            const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),

            itemCount:
            controller.conversations.length,

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
                  overflow:
                  TextOverflow.ellipsis,
                ),

                trailing: Column(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  crossAxisAlignment:
                  CrossAxisAlignment.end,
                  children: [
                    Text(
                      conversation.lastMessageAt ==
                          null
                          ? ""
                          : "${conversation.lastMessageAt!.hour.toString().padLeft(2, '0')}:${conversation.lastMessageAt!.minute.toString().padLeft(2, '0')}",
                    ),

                    const SizedBox(
                      height: 6,
                    ),

                    if (conversation.unreadCount > 0)
                      CircleAvatar(
                        radius: 10,
                        child: Text(
                          conversation.unreadCount
                              .toString(),
                          style:
                          const TextStyle(
                            fontSize: 11,
                          ),
                        ),
                      ),
                  ],
                ),

                onTap: () {
                  Get.to(
                        () => ChatView(
                      conversationId:
                      conversation.id,
                      receiverId:
                      conversation.otherUserId,
                      receiverName:
                      conversation.otherUserName,
                    ),
                  );
                },
              );
            },
          ),
        );
      }),

      // =========================================================
      // New Chat
      // =========================================================

      floatingActionButton:
      FloatingActionButton(
        child: const Icon(Icons.chat),

        onPressed: () async {
          // جلب أول صفحة من المشرفين
          await controller.getSupervisors();

          Get.bottomSheet(
            Obx(() {
              // =================================================
              // Initial Loading
              // =================================================

              if (controller
                  .isSupervisorsLoading.value) {
                return Container(
                  height: 500,
                  color: Theme.of(context)
                      .cardColor,
                  child: const Center(
                    child:
                    CircularProgressIndicator(),
                  ),
                );
              }

              // =================================================
              // Supervisors List
              // =================================================

              return Container(
                height: 500,
                color: Theme.of(context)
                    .cardColor,

                child: ListView.builder(

                  // مهم جداً
                  // استخدام controller الخاص بالمشرفين
                  controller: controller
                      .supervisorsScrollController,

                  physics:
                  const AlwaysScrollableScrollPhysics(),

                  // عدد العناصر + Loading آخر القائمة
                  itemCount:
                  controller.supervisors.length +
                      (controller
                          .isLoadingMoreSupervisors
                          .value
                          ? 1
                          : 0),

                  itemBuilder: (_, index) {
                    // =================================================
                    // Loading في نهاية القائمة
                    // =================================================

                    if (index ==
                        controller
                            .supervisors.length) {
                      return const Padding(
                        padding:
                        EdgeInsets.all(16),
                        child: Center(
                          child:
                          CircularProgressIndicator(),
                        ),
                      );
                    }

                    // =================================================
                    // Supervisor
                    // =================================================

                    final supervisor =
                    controller
                        .supervisors[index];

                    return ListTile(
                      leading:
                      const CircleAvatar(
                        child:
                        Icon(Icons.person),
                      ),

                      title: Text(
                        supervisor.fullName,
                      ),

                      subtitle: Text(
                        supervisor.email,
                      ),

                      onTap: () {
                        // إغلاق BottomSheet
                        Get.back();

                        // فتح المحادثة
                        Get.to(
                              () => ChatView(
                            conversationId: 0,

                            receiverId:
                            supervisor.id,

                            receiverName:
                            supervisor
                                .fullName,
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            }),
            isScrollControlled: true,
          );
        },
      ),
    );
  }
}