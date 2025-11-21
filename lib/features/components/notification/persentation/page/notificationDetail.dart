import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:job_platform/core/utils/storage/storage_service.dart';
import 'package:job_platform/features/components/notification/data/datasources/aut_remote_datasource.dart';
import 'package:job_platform/features/components/notification/data/models/notificationRequest.dart';
import 'package:job_platform/features/components/notification/data/models/notificationResponse.dart';
import 'package:job_platform/features/components/notification/data/repositories/auth_repository_impl.dart';
import 'package:job_platform/features/components/notification/domain/usecases/notification_usecase.dart';
import 'package:job_platform/features/components/notification/persentation/widgets/notificationDetailBody.dart';
import 'package:job_platform/features/components/notification/persentation/widgets/notificationDetailItems.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationDetail extends StatefulWidget {
  NotificationDetail({super.key});

  @override
  State<NotificationDetail> createState() => _NotificationDetail();
}

class _NotificationDetail extends State<NotificationDetail> {
  final _searchController = TextEditingController();

  List<NotificationDetailitems> dataSub = [];
  List<NotificationDetailitems> tempSub = [];
  Timer? _debounce;

  // Loading state
  bool isLoading = true;
  String? errorMessage;

  // Usecase
  late NotificationUsecase _notificationUseCase;

  @override
  void initState() {
    super.initState();
    AuthRemoteDataSource _dataSourceNotification = AuthRemoteDataSource();
    AuthRepositoryImpl _repoNotification = AuthRepositoryImpl(
      _dataSourceNotification,
    );
    _notificationUseCase = NotificationUsecase(_repoNotification);
    _loadNotificationData();
    _startPeriodicRefresh();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadNotificationData() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      var storage = StorageService();
      String? accountId =
          await storage.get('idUser') ?? await storage.get('idCompany');

      if (accountId != null) {
        var notification = await _notificationUseCase.getNotification(
          accountId,
        );
        if (notification != null) {
          setState(() {
            dataSub = notification
                .map<NotificationDetailitems>(
                  (item) => NotificationDetailitems(
                    icon: Icons.info,
                    iconColor: Colors.blueAccent,
                    title: item.title,
                    subtitle: item.message,
                    bgColor: Colors.blue.shade200,
                    about: "job",
                    route: item.route,
                    isRead: item.isRead,
                  ),
                )
                .toList();
            isLoading = false;

            tempSub = dataSub;
          });

          // await _readNotification(
          //   NotificationRequest(
          //     idNotification: notification
          //         .where((notif) => notif.isRead == false)
          //         .map((notif) => notif.id)
          //         .toList(),
          //   ),
          // );
        }
      } else {
        print("User ID or Company ID not found in SharedPreferences");
      }
    } catch (e) {
      print("Error loading notification data: $e");
      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = "Error loading notification: $e";
        });
      }
    }
  }

  Future<void> _readNotification(NotificationRequest notificationId) async {
    try {
      var storage = StorageService();
      String? accountId =
          await storage.get('idUser') ?? await storage.get('idCompany');

      if (accountId != null) {
        NotificationResponse response = await _notificationUseCase
            .readNotification(notificationId);

        if (response.responseMessage == 'Sukses') {
          print("Notification marked as read successfully");
          await _loadNotificationData();
        } else {
          print(
            "Failed to mark notification as read: ${response.responseMessage}",
          );
        }
      } else {
        print("User ID or Company ID not found in SharedPreferences");
      }
    } catch (e) {
      print("Error marking notifications as read: $e");
    }
  }

  // Refresh notification data for every 5 minutes
  Future<void> _refreshNotificationData() async {
    await _loadNotificationData();
  }

  void _startPeriodicRefresh() {
    Timer.periodic(Duration(minutes: 1), (timer) {
      _refreshNotificationData();
    });
  }

  void _onSearchChanged() {
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 300), () {
      final query = _searchController.text.trim().toLowerCase();

      setState(() {
        tempSub = query.isEmpty
            ? dataSub
            : dataSub
                  .where(
                    (data) =>
                        data.title.toLowerCase().contains(query) ||
                        data.subtitle.toLowerCase().contains(query),
                  )
                  .toList();
      });
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
            Text('Loading notification data...'),
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
          width: ResponsiveBreakpoints.of(context).smallerThan(DESKTOP)
              ? double.infinity
              : MediaQuery.of(context).size.width * 0.45,
          alignment: Alignment.center,
          child: ResponsiveRowColumn(
            columnCrossAxisAlignment: CrossAxisAlignment.center,
            rowMainAxisAlignment: MainAxisAlignment.center,
            columnMainAxisAlignment: MainAxisAlignment.center,
            rowCrossAxisAlignment: CrossAxisAlignment.center,
            // layout: ResponsiveBreakpoints.of(context).smallerThan(TABLET)
            //     ? ResponsiveRowColumnType.COLUMN
            //     : ResponsiveRowColumnType.ROW,
            layout: ResponsiveRowColumnType.COLUMN,
            rowSpacing: 100,
            columnSpacing: 20,
            children: [
              ResponsiveRowColumnItem(
                rowFlex: 2,
                child: NotificationDetailbody(
                  items: tempSub,
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
