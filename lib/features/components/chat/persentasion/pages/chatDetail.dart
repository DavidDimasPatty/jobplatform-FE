import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:job_platform/core/network/websocket_client.dart';
import 'package:job_platform/core/utils/storage/storage_service.dart';
import 'package:job_platform/features/components/chat/data/models/chatRequest.dart';
import 'package:job_platform/features/components/chat/data/models/partnerModel.dart';
import 'package:job_platform/features/components/chat/domain/usecases/chat_usecase.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:job_platform/features/components/chat/data/repositories/auth_repository_impl.dart';
import 'package:job_platform/features/components/chat/data/datasources/aut_remote_datasource.dart';
import 'package:select2dot1/select2dot1.dart';

class ChatDetail extends StatefulWidget {
  final PartnerModel partner;

  ChatDetail({super.key, required this.partner});

  @override
  State<ChatDetail> createState() => _ChatDetailState(this.partner);
}

class _ChatDetailState extends State<ChatDetail> {
  final PartnerModel partner;

  _ChatDetailState(this.partner);

  // Helper variable
  String? _userId;
  String? selectedMessage;
  final Map<String, Map<String, dynamic>> _pendingMessages = {};

  // Loading state
  bool isLoading = true;
  String? errorMessage;

  // Controller
  final ChatController _chatController = InMemoryChatController();
  late SelectDataController _messagesController;

  // Usecase
  late ChatUseCase _chatUseCase;

  // WebSocket Client
  final _webSocketClient = WebSocketClientImpl.instance;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  @override
  void dispose() {
    _chatController.dispose();

    // Clear callbacks when leaving chat
    _webSocketClient?.onMessageDelivered = null;
    _webSocketClient?.onNewMessage = null;
    _webSocketClient?.onReadReceipt = null;

    super.dispose();
  }

  Future<void> _initializeApp() async {
    _initializeUseCase();
    await _loadSharedpreferences();

    if (_userId != null) {
      _initializePredefinedMessages();
      _setupWebSocketCallbacks();
      await _loadChatHistory();
      await _markAsRead();
    } else {
      print("User ID not found in SharedPreferences");
    }
  }

  Future<void> _loadSharedpreferences() async {
    var storage = StorageService();
    String? userId = await storage.get('idUser');

    setState(() {
      _userId = userId;
    });
  }

  void _initializeUseCase() {
    final dataSource = AuthRemoteDataSource();
    final repository = AuthRepositoryImpl(dataSource);
    _chatUseCase = ChatUseCase(repository);
  }

  void _initializePredefinedMessages() {
    try {
      setState(() {
        isLoading = true;
      });

      List<String> predefinedMessages = [
        'Hello! How are you?',
        'I am interested in your product',
        'Can you provide more details?',
        'What is the price?',
        'Is this still available?',
        'Thank you!',
        'I would like to schedule a meeting',
        'Please contact me',
      ];

      List<SingleItemCategoryModel> messagesItem = predefinedMessages
          .map(
            (msg) => SingleItemCategoryModel(nameSingleItem: msg, value: msg),
          )
          .toList();

      _messagesController = SelectDataController(
        isMultiSelect: false,
        data: [SingleCategoryModel(singleItemCategoryList: messagesItem)],
      );
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to get messages data. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _setupWebSocketCallbacks() {
    // Callback when message is delivered
    _webSocketClient?.onMessageDelivered = (jsonData) {
      print("📨 Message delivered data: $jsonData");
      final data = jsonData["data"];

      final backendMessageId = data["messageId"];
      final fromUser = data["fromUser"];
      final toUser = data["toUser"];
      final timestamp =
          jsonData["timestamp"] ?? DateTime.now().toIso8601String();

      print("✅ Message delivered - Backend ID: $backendMessageId");

      // Find the pending message from this user to this recipient
      String? matchingTempId;
      _pendingMessages.forEach((tempId, details) {
        if (details['from'] == fromUser && details['to'] == toUser) {
          matchingTempId = tempId;
        }
      });

      if (matchingTempId != null) {
        // Store the mapping of tempId -> backendId
        _pendingMessages[matchingTempId!]!['backendId'] = backendMessageId;
        _pendingMessages[matchingTempId!]!['deliveredAt'] = timestamp;
        _pendingMessages[matchingTempId!]!['status'] = 'delivered';

        print("✅ Mapped: tempId=$matchingTempId → backendId=$backendMessageId");

        // Update message status in UI
        Message? messageToUpdate;
        try {
          messageToUpdate = _chatController.messages.firstWhere(
            (msg) => msg.id == matchingTempId,
          );
        } catch (e) {
          print("⚠ Message to update not found in UI: $e");
        }

        if (messageToUpdate != null) {
          final updatedMessage = messageToUpdate.copyWith(
            status: MessageStatus.delivered,
            metadata: {
              'backendId': backendMessageId,
              'isRead': false,
              'isDeliver': true,
              'isDeleted': false,
            },
          );

          _chatController.updateMessage(messageToUpdate, updatedMessage);
          print("🔄 Updated message status to delivered in UI");
        }

        // Optional: Remove from pending after some time
        Future.delayed(const Duration(seconds: 5), () {
          _pendingMessages.remove(matchingTempId);
        });
      }
    };

    // Callback when receiving new message from other user
    _webSocketClient?.onNewMessage = (jsonData) {
      print("🟢 New message received from partner: $jsonData");
      final data = jsonData["data"];

      final fromUserId = data["fromUser"];
      final messageText = data["message"];
      final messageId = data["messageId"];
      final timestamp =
          jsonData["timestamp"] ?? DateTime.now().toIso8601String();

      // Only add if it's from the chat partner (not from yourself)
      if (fromUserId != _userId && fromUserId == widget.partner.partnerId) {
        final message = TextMessage(
          id: messageId, // Use backend ID directly
          authorId: fromUserId,
          text: messageText,
          createdAt: DateTime.parse(timestamp),
          metadata: {
            'backendId': messageId,
            'isRead': false,
            'isDeliver': false,
            'isDeleted': false,
          },
        );

        // Insert message using ChatController
        _chatController.insertMessage(message);
      }
    };

    // Callback when message is read
    _webSocketClient?.onReadReceipt = (jsonData) {
      print("👁 Message read: $jsonData");
      final data = jsonData["data"];

      final List listMessageId = data["messageIds"];
      for (var messageId in listMessageId) {
        Message? messageToUpdate;
        try {
          messageToUpdate = _chatController.messages.firstWhere(
            (msg) =>
                msg.id == messageId &&
                msg.metadata != null &&
                msg.metadata!['isRead'] != true,
          );
        } catch (e) {
          print("⚠ Message to update not found in UI: $e");
        }

        if (messageToUpdate != null) {
          final updatedMessage = messageToUpdate.copyWith(
            status: MessageStatus.seen,
            metadata: {
              'backendId': messageId,
              'isRead': true,
              'isDeliver': true,
              'isDeleted': false,
            },
          );

          _chatController.updateMessage(messageToUpdate, updatedMessage);
          print("🔄 Updated message status to seen in UI");
        }
      }
    };

    // Callback when message is deleted
    _webSocketClient?.onMessageDeleted = (jsonData) {
      print("❌ Message deleted: $jsonData");
      final data = jsonData["data"];

      final messageId = data["messageId"];
      Message? messageToDeleted;
      try {
        messageToDeleted = _chatController.messages.firstWhere(
          (msg) =>
              msg.id == messageId &&
              msg.metadata != null &&
              msg.metadata!['backendId'] == messageId,
        );
      } catch (e) {
        print("⚠ Message to update not found in UI: $e");
      }

      if (messageToDeleted != null) {
        final updatedMessage = TextMessage(
          id: messageToDeleted.id,
          authorId: messageToDeleted.authorId,
          text: "[This message has been deleted]",
          createdAt: messageToDeleted.createdAt,
          metadata: {
            'backendId': messageToDeleted.id,
            'isRead': messageToDeleted.metadata!['isRead'] ?? false,
            'isDeliver': messageToDeleted.metadata!['isDeliver'] ?? false,
            'isDeleted': true,
          },
        );
        _chatController.updateMessage(messageToDeleted, updatedMessage);

        print("🔄 Updated message status to deleted in UI");
      }
    };
  }

  Future<void> _loadChatHistory() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      if (_userId == null) {
        print("⚠ Cannot load chat history: User ID is null");
        return;
      }

      var chatHistory = await _chatUseCase.getConversation(
        _userId!,
        partner.partnerId,
      );

      if (chatHistory != null) {
        // Convert backend ChatModel to flutter_chat_core Message
        final messages = chatHistory.map((item) {
          if (item.isDelete != null) {
            return TextMessage(
              id: item.id,
              authorId: item.addId,
              text: "[This message has been deleted]",
              createdAt: item.addTime,
              metadata: {
                'backendId': item.id,
                'isRead': item.isRead != null,
                'isDeliver': item.isDelivered != null,
                'isDeleted': true,
              },
            );
          }

          MessageStatus messageStatus = MessageStatus.sent;
          if (item.isRead != null) {
            messageStatus = MessageStatus.seen;
          } else if (item.isDelivered != null) {
            messageStatus = MessageStatus.delivered;
          }

          return TextMessage(
            id: item.id,
            authorId: item.addId,
            createdAt: item.addTime,
            text: item.message,
            status: messageStatus,
            metadata: {
              'backendId': item.id,
              'isRead': item.isRead != null,
              'isDeliver': item.isDelivered != null,
              'isDeleted': false,
            },
          );
        }).toList();

        messages.forEach((msg) {
          _chatController.insertMessage(msg);
        });

        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error loading chat history data: $e");
      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = "Error loading chat history: $e";
        });
      }
    }
  }

  Future<void> _sendMessage(String text) async {
    if (_userId == null) {
      print("⚠ Cannot send message: User ID is null");
      return;
    }

    try {
      final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';

      // Store pending message details
      _pendingMessages[tempId] = {
        'from': _userId!,
        'to': widget.partner.partnerId,
        'text': text,
        'sentAt': DateTime.now().toIso8601String(),
        'status': 'sending',
      };

      // Create message for UI (optimistic update)
      final message = TextMessage(
        id: tempId,
        authorId: _userId!,
        createdAt: DateTime.now().toUtc(),
        text: text,
        status: MessageStatus.sending,
        metadata: {
          'tempId': tempId,
          'sentAt': DateTime.now().toIso8601String(),
          'pending': true,
        },
      );

      // Insert to UI immediately
      _chatController.insertMessage(message);

      // Send to websocket server
      _webSocketClient!.sendChat(
        from: _userId!,
        to: partner.partnerId,
        message: text,
      );

      print("📤 Message sent with tempId: $tempId");
    } catch (e) {
      print("Error sending message: $e");

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error sending message: $e')));
    }
  }

  Future<void> _markAsRead() async {
    if (_userId == null) {
      print("⚠ Cannot mark messages as read: User ID is null");
      return;
    }

    try {
      final request = ChatRequest(
        idSender: _userId!,
        idReceiver: widget.partner.partnerId,
      );

      await _chatUseCase.markAsRead(request);
    } catch (e) {
      print("Error marking messages as read: $e");
    }
  }

  void _deleteMessage(
    BuildContext context,
    Message message, {
    LongPressStartDetails? details,
    int? index,
  }) {
    if (message.metadata != null && message.metadata!['isDeleted'] == true) {
      // Message already deleted
      return;
    }

    if (message.authorId != _userId) {
      // Cannot delete messages from other users
      return;
    }

    // Show confirmation dialog first
    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Message'),
        content: const Text('Are you sure you want to delete this message?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    ).then((shouldDelete) async {
      if (shouldDelete != true) return;

      try {
        ChatRequest deleteRequest = ChatRequest(idChat: message.id);

        final response = await _chatUseCase.deleteMessage(deleteRequest);

        if (response.responseMessage == 'Sukses') {
          // Update message in UI to show deleted state
          final updatedMessage = TextMessage(
            id: message.id,
            authorId: message.authorId,
            text: "[This message has been deleted]",
            createdAt: message.createdAt,
            metadata: {
              'backendId': message.metadata != null
                  ? message.metadata!['backendId']
                  : message.id,
              'isRead': message.metadata != null
                  ? message.metadata!['isRead'] ?? false
                  : false,
              'isDeliver': message.metadata != null
                  ? message.metadata!['isDeliver'] ?? false
                  : false,
              'isDeleted': true,
            },
          );
          _chatController.updateMessage(message, updatedMessage);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to delete message')),
          );
        }
      } catch (e) {
        print("Error deleting message: $e");
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error deleting message: $e')));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading chat history...'),
          ],
        ),
      );
    }

    // Show error message if there's an error
    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red),
            SizedBox(height: 16),
            Text(
              errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red),
            ),
            SizedBox(height: 16),
            // ElevatedButton(onPressed: _loadProfileData, child: Text('Retry')),
          ],
        ),
      );
    }

    return Center(
      child: Container(
        margin: EdgeInsets.all(20),
        width: ResponsiveBreakpoints.of(context).smallerThan(DESKTOP)
            ? double.infinity
            : MediaQuery.of(context).size.width * 0.45,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  context.go('/chat');
                },
                icon: Icon(Icons.arrow_back),
              ),
              title: Row(
                spacing: 12,
                children: [
                  // Partner Avatar
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                      widget.partner.partnerPhotoUrl,
                    ),
                  ),
                  // Partner Name
                  Expanded(
                    child: Text(
                      widget.partner.partnerName,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ),
            body: Column(
              children: [
                Expanded(
                  child: Chat(
                    currentUserId: _userId!,
                    resolveUser: (UserID id) async {
                      if (id == _userId) {
                        return User(id: id, name: 'You');
                      } else {
                        return User(
                          id: id,
                          name: widget.partner.partnerName,
                          imageSource: widget.partner.partnerPhotoUrl,
                        );
                      }
                    },
                    chatController: _chatController,
                    onMessageSend: _sendMessage,
                    onMessageLongPress: _deleteMessage,
                    builders: Builders(
                      chatAnimatedListBuilder: (context, itemBuilder) {
                        return ChatAnimatedList(
                          itemBuilder: itemBuilder,
                          bottomPadding: 80,
                          onStartReached: () async {
                            await _markAsRead();
                          },
                        );
                      },
                      scrollToBottomBuilder: (context, animation, onPressed) {
                        return ScrollToBottom(
                          bottom: 80,
                          animation: animation,
                          onPressed: onPressed,
                        );
                      },
                      composerBuilder: (context) {
                        return Positioned(
                          left: 0,
                          right: 0,
                          bottom: MediaQuery.of(context).padding.bottom,
                          child: _buildComposer(),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildComposer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              constraints: BoxConstraints(minHeight: 48),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F0F0),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Select2dot1(
                key: ValueKey('messages-select'),
                selectDataController: _messagesController,
                pillboxSettings: PillboxSettings(
                  defaultDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  hoverDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  focusDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  activeDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                selectEmptyInfoSettings: SelectEmptyInfoSettings(
                  text: "Select a message...",
                ),
                // dropdownOverlaySettings:
                //     DropdownOverlaySettings(
                //       decoration: BoxDecoration(
                //         borderRadius: BorderRadius.all(
                //           Radius.circular(24),
                //         ),
                //       ),
                //     ),
                // searchBarOverlaySettings:
                //     SearchBarOverlaySettings(
                //       boxDecorationFocus: BoxDecoration(
                //         borderRadius: BorderRadius.all(
                //           Radius.circular(24),
                //         ),
                //       ),
                //       boxDecorationNoFocus: BoxDecoration(
                //         borderRadius: BorderRadius.all(
                //           Radius.circular(24),
                //         ),
                //       ),
                //     ),
                onChanged: (selectedValue) {
                  if (selectedValue.isNotEmpty) {
                    var actualValue = selectedValue.first.value;

                    setState(() {
                      selectedMessage = actualValue;
                    });
                  }
                },
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: selectedMessage != null
                  ? const Color(0xFF007AFF)
                  : Colors.grey.shade300,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: selectedMessage != null
                  ? () {
                      _sendMessage(selectedMessage!);
                      setState(() {
                        _messagesController.clearSelectedList();
                        selectedMessage = null;
                      });
                    }
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
