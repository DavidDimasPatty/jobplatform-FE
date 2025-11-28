import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:job_platform/core/utils/storage/storage_service.dart';
import 'package:job_platform/features/components/chat/domain/usecases/chat_usecase.dart';
import 'package:job_platform/features/components/chat/persentasion/widget/chat/chatBody.dart';
import 'package:job_platform/features/components/chat/persentasion/widget/chat/chatItems.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:job_platform/features/components/chat/data/repositories/auth_repository_impl.dart';
import 'package:job_platform/features/components/chat/data/datasources/aut_remote_datasource.dart';

class Chat extends StatefulWidget {
  Chat({super.key});

  @override
  State<Chat> createState() => _Chat();
}

class _Chat extends State<Chat> {
  final _searchController = TextEditingController();

  List<Chatitems> dataChat = [];
  List<Chatitems> tempChat = [];
  Timer? _debounce;

  // Loading state
  bool isLoading = true;
  String? errorMessage;

  // Usecase
  late ChatUseCase _chatUseCase;

  @override
  void initState() {
    super.initState();
    AuthRemoteDataSource _dataSourceChat = AuthRemoteDataSource();
    AuthRepositoryImpl _repoChat = AuthRepositoryImpl(_dataSourceChat);
    _chatUseCase = ChatUseCase(_repoChat);
    _loadChatList();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadChatList() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
      var storage = StorageService();
      String? userId = await storage.get('idUser');

      if (userId != null) {
        var chatList = await _chatUseCase.getChatList(userId);
        if (chatList != null) {
          setState(() {
            isLoading = false;
            errorMessage = null;
            dataChat = chatList
                .map<Chatitems>((item) => Chatitems(partner: item))
                .toList();

            tempChat = dataChat;
          });
        }
      } else {
        print("User ID not found in SharedPreferences");
      }
    } catch (e) {
      print("Error loading chat list data: $e");
      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = "Error loading chat list: $e";
        });
      }
    }
  }

  void _onSearchChanged() {
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 300), () {
      final query = _searchController.text.trim().toLowerCase();

      setState(() {
        tempChat = query.isEmpty
            ? dataChat
            : dataChat
                  .where(
                    (data) =>
                        data.partner.partnerName.toLowerCase().contains(
                          query,
                        ) ||
                        data.partner.lastMessage.toLowerCase().contains(query),
                  )
                  .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading Chat List...'.tr()),
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

    return SingleChildScrollView(
      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Center(
        child: Container(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5,
                spreadRadius: 2,
                offset: Offset(3, 3),
              ),
            ],
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          width: ResponsiveBreakpoints.of(context).smallerThan(DESKTOP)
              ? double.infinity
              : MediaQuery.of(context).size.width * 0.45,
          //alignment: Alignment.center,
          child: ResponsiveRowColumn(
            columnCrossAxisAlignment: CrossAxisAlignment.start,
            rowMainAxisAlignment: MainAxisAlignment.start,
            columnMainAxisAlignment: MainAxisAlignment.start,
            rowCrossAxisAlignment: CrossAxisAlignment.start,
            // layout: ResponsiveBreakpoints.of(context).smallerThan(TABLET)
            //     ? ResponsiveRowColumnType.COLUMN
            //     : ResponsiveRowColumnType.ROW,
            layout: ResponsiveRowColumnType.COLUMN,
            rowSpacing: 100,
            columnSpacing: 20,
            children: [
              ResponsiveRowColumnItem(
                rowFlex: 2,
                child: Chatbody(
                  items: tempChat,
                  onSearchChanged: _onSearchChanged,
                  searchController: _searchController,
                ),
              ),
              // ResponsiveRowColumnItem(rowFlex: 2, child: bodySetting()),
            ],
          ),
        ),
      ),
    );
  }
}
