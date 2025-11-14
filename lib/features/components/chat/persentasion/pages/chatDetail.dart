import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:job_platform/features/components/chat/data/models/partnerModel.dart';
import 'package:job_platform/features/components/chat/domain/entities/ChatDetailItems.dart';
import 'package:job_platform/features/components/chat/domain/usecases/chat_usecase.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  // Data
  List<Chatdetailitems> dataChat = [];

  // Helper variable
  String? _userId;
  Timer? _pollTimer;
  String? selectedMessage;

  // Loading state
  bool isLoading = true;
  String? errorMessage;

  // Controller
  final ChatController _chatController = InMemoryChatController();
  late SelectDataController _messagesController;

  // Usecase
  late ChatUseCase _chatUseCase;

  @override
  void initState() {
    super.initState();
    _initializeUseCase();
    _loadChatHistory();
    _initializePredefinedMessages();

    // _startPolling();
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _chatController.dispose();
    super.dispose();
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

  Future<void> _loadChatHistory() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      _userId = prefs.getString('idUser');

      if (_userId != null) {
        var chatHistory = await _chatUseCase.getConversation(
          _userId!,
          partner.partnerId,
        );

        if (chatHistory != null) {
          // Convert backend ChatModel to flutter_chat_core Message
          final messages = chatHistory.map((item) {
            return TextMessage(
              id: item.id,
              authorId: item.idUser,
              createdAt: item.addTime,
              text: item.message,
            );
          }).toList();

          messages.forEach((msg) {
            _chatController.insertMessage(msg);
          });

          setState(() {
            isLoading = false;
          });
        }
      } else {
        print("User ID not found in SharedPreferences");
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

  Future<void> _handleMessageSend(String text) async {
    if (_userId == null) return;

    // Create message for UI (optimistic update)
    final message = TextMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      authorId: _userId!,
      createdAt: DateTime.now().toUtc(),
      text: text,
    );

    // Insert to UI immediately
    _chatController.insertMessage(message);

    // Send to backend
    final success = false;
    // final success = await _chatUseCase.sendMessage(
    //   senderId: _userId!,
    //   receiverId: widget.partner.partnerId,
    //   message: text,
    // );

    if (!success) {
      // Handle send failure - you could show a retry option
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to send message')));
    }
  }

  // For get a new messages
  void _startPolling() {
    _pollTimer = Timer.periodic(Duration(seconds: 3), (timer) async {
      // Fetch new messages and insert them
      var newMessages = await _chatUseCase.getConversation(
        _userId!,
        partner.partnerId,
      );

      // Insert only new messages that aren't already in the controller
      if (newMessages != null) {
        final messages = newMessages.map((item) {
          return TextMessage(
            id: item.id,
            authorId: item.idUser,
            createdAt: item.addTime,
            text: item.message,
          );
        }).toList();

        messages.forEach((msg) {
          _chatController.insertMessage(msg);
        });
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
              backgroundColor: Colors.blue,
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
                    onMessageSend: _handleMessageSend,
                    builders: Builders(
                      chatAnimatedListBuilder: (context, itemBuilder) {
                        return ChatAnimatedList(itemBuilder: itemBuilder);
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
    return Material(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
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
                        _handleMessageSend(selectedMessage!);
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
      ),
    );
  }
}
