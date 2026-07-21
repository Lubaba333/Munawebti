
import 'package:get/get.dart';

import '../models/conversation_model.dart';
import '../models/message_model.dart';
import '../models/supervisor_model.dart';
import '../services/api_service.dart';
import 'package:flutter/material.dart';

import 'notifications_controller.dart';

class ChatController extends GetxController {
  final ApiService _api = ApiService();

  final RxList<MessageModel> messages = <MessageModel>[].obs;

  final RxList<ConversationModel> conversations =
      <ConversationModel>[].obs;

  final RxBool isMessagesLoading = false.obs;

  final RxBool isConversationLoading = false.obs;

  final RxBool isLoadingMore = false.obs;

  final RxInt conversationId = 0.obs;

  final RxBool hasMore = false.obs;

  final RxString nextCursor = "".obs;

  final TextEditingController messageController =
  TextEditingController();

  final ScrollController scrollController =
  ScrollController();

  final RxBool isSending = false.obs;

  final RxList<SupervisorModel> supervisors =
      <SupervisorModel>[].obs;

  final RxBool isSupervisorsLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    getConversations();

    scrollController.addListener(() {

      if (scrollController.position.pixels <=
          scrollController.position.minScrollExtent + 30) {

        if (conversationId.value != 0) {
          loadOlderMessages();
        }

      }

    });

  }


  Future<void> getSupervisors() async {
    try {
      isSupervisorsLoading.value = true;

      final response = await _api.get(
        "/supervisor/supervisors",
        queryParameters: {
          "page": 1,
          "per_page": 100,
        },
      );

      final List list = response["data"]["data"];

      supervisors.assignAll(
        list.map((e) => SupervisorModel.fromJson(e)).toList(),
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
      );
    } finally {
      isSupervisorsLoading.value = false;
    }
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollController.hasClients) return;

      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> getMessages({
    required int receiverId,
  }) async {
    try {
      isMessagesLoading.value = true;

      Map<String, dynamic> response;

      if (conversationId.value == 0) {
        response = await _api.get(
          "/chat/messages",
          queryParameters: {
            "receiver_type": "supervisor",
            "receiver_id": receiverId,
            "limit": 20,
          },
        );
      } else {
        response = await _api.get(
          "/chat/conversations/${conversationId.value}/messages",
          queryParameters: {
            "limit": 20,
          },
        );
      }

      final data = response["data"];
      final meta = data["meta"];

      hasMore.value = meta["has_more"] ?? false;

      nextCursor.value =
          meta["next_cursor"]?.toString() ?? "";

      if (conversationId.value == 0 &&
          data["messages"].isNotEmpty) {
        conversationId.value =
        data["messages"][0]["conversation_id"];
      }

      messages.assignAll(
        (data["messages"] as List)
            .map((e) => MessageModel.fromJson(e))
            .toList(),
      );
      await markConversationAsRead();

      scrollToBottom();
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
      );
    } finally {
      isMessagesLoading.value = false;
    }
  }


  Future<void> sendMessage({
    required int receiverId,
  }) async {
    if (messageController.text.trim().isEmpty) return;

    isSending.value = true;

    final body = messageController.text.trim();

    messageController.clear();

    try {
      Map<String, dynamic> response;

      if (conversationId.value == 0) {
        response = await _api.post(
          "/chat/messages",
          {
            "receiver_type": "supervisor",
            "receiver_id": receiverId,
            "body": body,
          },
        );
      } else {
        response = await _api.post(
          "/chat/messages",
          {
            "conversation_id": conversationId.value,
            "body": body,
          },
        );
      }

      final message = MessageModel.fromJson(response["data"]);

      /// نجبرها تكون رسالتي مباشرة
      message.isMine = true;

      /// إذا أول رسالة بالمحادثة
      if (conversationId.value == 0) {
        conversationId.value = message.conversationId;
      }

      /// إضافة الرسالة مرة واحدة فقط
      messages.add(message);

      scrollToBottom();

      await getConversations();
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
      );
    } finally {
      isSending.value = false;
    }
  }


  Future<void> loadOlderMessages() async {

    if (!hasMore.value) return;

    if (isLoadingMore.value) return;

    try {

      isLoadingMore.value = true;

      final response = await _api.get(
        "/chat/conversations/${conversationId.value}/messages",
        queryParameters: {
          "limit":20,
          "cursor":nextCursor.value,
        },
      );

      final List list =
      response["data"]["messages"];

      final oldMessages =
      list.map((e)=>MessageModel.fromJson(e)).toList();

      messages.insertAll(
        0,
        oldMessages,
      );

      await Future.delayed(
        const Duration(milliseconds: 100),
      );

      if (scrollController.hasClients) {
        scrollController.jumpTo(120);
      }

      final meta =
      response["data"]["meta"];

      hasMore.value =
          meta["has_more"] ?? false;

      nextCursor.value =
          meta["next_cursor"]?.toString() ?? "";

    } catch(e){

      Get.snackbar(
        "Error",
        e.toString(),
      );

    } finally{

      isLoadingMore.value=false;

    }
  }

  Future<void> getConversations() async {
    try {
      isConversationLoading.value = true;

      final response = await _api.get(
        "/chat/conversations",
        queryParameters: {
          "page": 1,
          "per_page": 15,
        },
      );

     // final List list = response["data"]["data"];
      print(response);

      final List list = response["data"]["data"];

      print("LIST LENGTH = ${list.length}");

      print(list);
      conversations.assignAll(
        list
            .map(
              (e) => ConversationModel.fromJson(e),
        )
            .toList(),
      );
      print("CONVERSATIONS = ${conversations.length}");
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
      );
    } finally {
      isConversationLoading.value = false;
    }
  }

  Future<void> getMessagesByConversation() async {

    final response = await _api.get(
      "/chat/conversations/${conversationId.value}/messages",
      queryParameters: {
        "limit":20,
      },
    );

    final data = response["data"];

    messages.assignAll(
      (data["messages"] as List)
          .map((e)=>MessageModel.fromJson(e))
          .toList(),
    );

    hasMore.value =
        data["meta"]["has_more"] ?? false;

    nextCursor.value =
        data["meta"]["next_cursor"]?.toString() ?? "";
  }

  Future<void> onNewMessageNotification({
    required int conversationId,
    required int senderId,
  }) async {
    await getConversations();

    if (this.conversationId.value == conversationId) {
      await getMessages(
        receiverId: senderId,
      );
    }
  }

  Future<void> markConversationAsRead() async {
    if (conversationId.value == 0) return;

    try {
      await _api.post(
        "/chat/conversations/${conversationId.value}/read",
        {},
      );

      await getConversations();
      if (Get.isRegistered<NotificationsController>()) {
        await Get.find<NotificationsController>()
            .fetchNotifications(refresh: true);
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
      );
    }
  }
}