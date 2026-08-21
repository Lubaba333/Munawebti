import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/conversation_model.dart';
import '../models/message_model.dart';
import '../models/supervisor_model.dart';
import '../services/api_service.dart';
import 'notifications_controller.dart';

class ChatController extends GetxController {
  final ApiService _api = ApiService();

  // ============================================================
  // Messages
  // ============================================================

  final RxList<MessageModel> messages = <MessageModel>[].obs;

  final RxBool isMessagesLoading = false.obs;

  final RxBool isLoadingMore = false.obs;

  final RxInt conversationId = 0.obs;

  final RxBool hasMore = false.obs;

  final RxString nextCursor = "".obs;

  final TextEditingController messageController =
  TextEditingController();

  final ScrollController scrollController =
  ScrollController();

  final RxBool isSending = false.obs;

  // ============================================================
  // Conversations
  // ============================================================

  final RxList<ConversationModel> conversations =
      <ConversationModel>[].obs;

  final RxBool isConversationLoading = false.obs;

  // ============================================================
  // Supervisors
  // ============================================================

  final RxList<SupervisorModel> supervisors =
      <SupervisorModel>[].obs;

  final RxBool isSupervisorsLoading = false.obs;

  /// Loading more supervisors
  final RxBool isLoadingMoreSupervisors = false.obs;

  /// Current supervisors page
  final RxInt supervisorsPage = 1.obs;

  /// Is there another page?
  final RxBool hasMoreSupervisors = true.obs;

  /// Scroll controller for supervisors list
  final ScrollController supervisorsScrollController =
  ScrollController();

  // ============================================================
  // Init
  // ============================================================

  @override
  void onInit() {
    super.onInit();

    getConversations();

    getSupervisors();

    // Messages scroll
    scrollController.addListener(() {
      if (scrollController.position.pixels <=
          scrollController.position.minScrollExtent + 30) {
        if (conversationId.value != 0) {
          loadOlderMessages();
        }
      }
    });

    // Supervisors scroll
    supervisorsScrollController.addListener(() {
      if (!supervisorsScrollController.hasClients) return;

      final position = supervisorsScrollController.position;

      // عندما نقترب من نهاية القائمة
      if (position.pixels >= position.maxScrollExtent - 100) {
        loadMoreSupervisors();
      }
    });
  }

  // ============================================================
  // Supervisors
  // ============================================================

  /// جلب أول صفحة من المشرفين
  Future<void> getSupervisors() async {
    try {
      isSupervisorsLoading.value = true;

      // Reset pagination
      supervisorsPage.value = 1;
      hasMoreSupervisors.value = true;

      final response = await _api.get(
        "/supervisor/supervisors",
        queryParameters: {
          "page": 1,
          "per_page": 15,
        },
      );

      print("SUPERVISORS RESPONSE:");
      print(response);

      final data = response["data"];

      final List list = data["data"] ?? [];

      print("SUPERVISORS FIRST PAGE = ${list.length}");

      supervisors.assignAll(
        list
            .map(
              (e) => SupervisorModel.fromJson(e),
        )
            .toList(),
      );

      // ========================================================
      // Pagination
      // ========================================================

      final meta = data["meta"];

      if (meta != null) {
        final currentPage =
            int.tryParse(
              meta["current_page"]?.toString() ?? "",
            ) ??
                1;

        final lastPage =
            int.tryParse(
              meta["last_page"]?.toString() ?? "",
            ) ??
                currentPage;

        supervisorsPage.value = currentPage;

        hasMoreSupervisors.value =
            currentPage < lastPage;
      } else {
        // Fallback
        // إذا لم يكن هناك meta
        hasMoreSupervisors.value = list.length == 15;
      }

      print(
        "CURRENT PAGE = ${supervisorsPage.value}",
      );

      print(
        "HAS MORE SUPERVISORS = ${hasMoreSupervisors.value}",
      );
    } catch (e) {
      print("GET SUPERVISORS ERROR: $e");

      Get.snackbar(
        "Error",
        e.toString(),
      );
    } finally {
      isSupervisorsLoading.value = false;
    }
  }

  /// جلب الصفحة التالية من المشرفين
  Future<void> loadMoreSupervisors() async {
    // منع إرسال أكثر من request بنفس الوقت
    if (isLoadingMoreSupervisors.value) return;

    // لا يوجد صفحات إضافية
    if (!hasMoreSupervisors.value) return;

    try {
      isLoadingMoreSupervisors.value = true;

      final nextPage = supervisorsPage.value + 1;

      print(
        "LOADING SUPERVISORS PAGE = $nextPage",
      );

      final response = await _api.get(
        "/supervisor/supervisors",
        queryParameters: {
          "page": nextPage,
          "per_page": 15,
        },
      );

      print("MORE SUPERVISORS RESPONSE:");
      print(response);

      final data = response["data"];

      final List list = data["data"] ?? [];

      print(
        "NEW SUPERVISORS = ${list.length}",
      );

      // إذا لم يرجع بيانات
      if (list.isEmpty) {
        hasMoreSupervisors.value = false;
        return;
      }

      final newSupervisors = list
          .map(
            (e) => SupervisorModel.fromJson(e),
      )
          .toList();

      // ========================================================
      // مهم جداً:
      // نستخدم addAll وليس assignAll
      // حتى لا تختفي الصفحات السابقة
      // ========================================================

      supervisors.addAll(newSupervisors);

      supervisorsPage.value = nextPage;

      // ========================================================
      // Pagination
      // ========================================================

      final meta = data["meta"];

      if (meta != null) {
        final currentPage =
            int.tryParse(
              meta["current_page"]?.toString() ?? "",
            ) ??
                nextPage;

        final lastPage =
            int.tryParse(
              meta["last_page"]?.toString() ?? "",
            ) ??
                currentPage;

        supervisorsPage.value = currentPage;

        hasMoreSupervisors.value =
            currentPage < lastPage;
      } else {
        // Fallback
        hasMoreSupervisors.value = list.length == 15;
      }

      print(
        "TOTAL SUPERVISORS = ${supervisors.length}",
      );

      print(
        "CURRENT PAGE = ${supervisorsPage.value}",
      );

      print(
        "HAS MORE = ${hasMoreSupervisors.value}",
      );
    } catch (e) {
      print(
        "LOAD MORE SUPERVISORS ERROR: $e",
      );

      Get.snackbar(
        "Error",
        e.toString(),
      );
    } finally {
      isLoadingMoreSupervisors.value = false;
    }
  }

  // ============================================================
  // Scroll To Bottom
  // ============================================================

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollController.hasClients) return;

      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(
          milliseconds: 300,
        ),
        curve: Curves.easeOut,
      );
    });
  }

  // ============================================================
  // Get Messages
  // ============================================================

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

      hasMore.value =
          meta["has_more"] ?? false;

      nextCursor.value =
          meta["next_cursor"]?.toString() ?? "";

      // أول رسالة بالمحادثة
      if (conversationId.value == 0 &&
          data["messages"].isNotEmpty) {
        conversationId.value =
        data["messages"][0]["conversation_id"];
      }

      messages.assignAll(
        (data["messages"] as List)
            .map(
              (e) => MessageModel.fromJson(e),
        )
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

  // ============================================================
  // Send Message
  // ============================================================

  Future<void> sendMessage({
    required int receiverId,
  }) async {
    if (messageController.text.trim().isEmpty) {
      return;
    }

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

      final message =
      MessageModel.fromJson(
        response["data"],
      );

      // نجبرها تكون رسالتي
      message.isMine = true;

      // إذا كانت أول رسالة
      if (conversationId.value == 0) {
        conversationId.value =
            message.conversationId;
      }

      // إضافة الرسالة مرة واحدة
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

  // ============================================================
  // Load Older Messages
  // ============================================================

  Future<void> loadOlderMessages() async {
    if (!hasMore.value) return;

    if (isLoadingMore.value) return;

    try {
      isLoadingMore.value = true;

      final response = await _api.get(
        "/chat/conversations/${conversationId.value}/messages",
        queryParameters: {
          "limit": 20,
          "cursor": nextCursor.value,
        },
      );

      final List list =
      response["data"]["messages"];

      final oldMessages = list
          .map(
            (e) => MessageModel.fromJson(e),
      )
          .toList();

      messages.insertAll(
        0,
        oldMessages,
      );

      await Future.delayed(
        const Duration(
          milliseconds: 100,
        ),
      );

      if (scrollController.hasClients) {
        scrollController.jumpTo(120);
      }

      final meta =
      response["data"]["meta"];

      hasMore.value =
          meta["has_more"] ?? false;

      nextCursor.value =
          meta["next_cursor"]
              ?.toString() ??
              "";
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
      );
    } finally {
      isLoadingMore.value = false;
    }
  }

  // ============================================================
  // Get Conversations
  // ============================================================

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

      print(response);

      final List list =
      response["data"]["data"];

      print(
        "LIST LENGTH = ${list.length}",
      );

      print(list);

      conversations.assignAll(
        list
            .map(
              (e) => ConversationModel.fromJson(e),
        )
            .toList(),
      );

      print(
        "CONVERSATIONS = ${conversations.length}",
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
      );
    } finally {
      isConversationLoading.value = false;
    }
  }

  // ============================================================
  // Get Messages By Conversation
  // ============================================================

  Future<void> getMessagesByConversation() async {
    final response = await _api.get(
      "/chat/conversations/${conversationId.value}/messages",
      queryParameters: {
        "limit": 20,
      },
    );

    final data = response["data"];

    messages.assignAll(
      (data["messages"] as List)
          .map(
            (e) => MessageModel.fromJson(e),
      )
          .toList(),
    );

    hasMore.value =
        data["meta"]["has_more"] ?? false;

    nextCursor.value =
        data["meta"]["next_cursor"]
            ?.toString() ??
            "";
  }

  // ============================================================
  // New Message Notification
  // ============================================================

  Future<void> onNewMessageNotification({
    required int conversationId,
    required int senderId,
  }) async {
    await getConversations();

    if (this.conversationId.value ==
        conversationId) {
      await getMessages(
        receiverId: senderId,
      );
    }
  }

  // ============================================================
  // Mark Conversation As Read
  // ============================================================

  Future<void> markConversationAsRead() async {
    if (conversationId.value == 0) {
      return;
    }

    try {
      await _api.post(
        "/chat/conversations/${conversationId.value}/read",
        {},
      );

      await getConversations();

      if (Get.isRegistered<
          NotificationsController>()) {
        await Get.find<
            NotificationsController>()
            .fetchNotifications(
          refresh: true,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
      );
    }
  }

  // ============================================================
  // Dispose
  // ============================================================

  @override
  void onClose() {
    messageController.dispose();

    scrollController.dispose();

    supervisorsScrollController.dispose();

    super.onClose();
  }
}