import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:job_platform/features/components/notification/data/datasources/aut_remote_datasource.dart';
import 'package:job_platform/features/components/notification/data/models/notificationModel.dart';
import 'package:job_platform/features/components/notification/data/models/notificationRequest.dart';
import 'package:job_platform/features/components/notification/data/models/notificationResponse.dart';
import 'package:job_platform/features/components/notification/data/repositories/auth_repository_impl.dart';
import 'package:job_platform/features/components/notification/domain/usecases/notification_usecase.dart';
import 'package:job_platform/features/shared/Notification/Notification.dart';
import 'package:job_platform/features/shared/Notification/NotificationItem.dart';
import 'package:job_platform/features/shared/TopAppLayout.dart';
import 'package:job_platform/features/shared/bottomAppLayout.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Layout extends StatefulWidget {
  final Widget child;
  const Layout({super.key, required this.child});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  int selectedIndex = 0;
  bool _showNotification = false;
  List<Notificationitem>? dataNotif;
  List<NotificationModel>? notification;
  String? loginAs;
  String? idUser;
  String? namaUser;
  String? emailUser;
  String? noTelpUser;
  bool isLoading = true;
  String? idCompany;
  String? namaCompany;
  String? domainCompany;
  String? noTelpCompany;
  String? hrCompanyId;
  // Usecase
  late NotificationUsecase _notificationUseCase;

  toggleNotification() {
    setState(() {
      _showNotification = !_showNotification;

      if (_showNotification && notification != null) {
        int unreadCount = notification!
            .where((notif) => notif.isRead == false)
            .length;

        if (unreadCount > 0) {
          _readNotification(
            NotificationRequest(
              idNotification: notification!
                  .where((notif) => notif.isRead == false)
                  .map((notif) => notif.id)
                  .toList(),
            ),
          );
        }
      }
    });
  }

  final List<String> _routes = [
    '/home',
    '/candidate',
    '/profile',
    '/setting',
    '/chat',
    '/cart',
    '/statusJob',
    '/progress',
    '/vacancy',
    '/manageHRD',
    '/profileCompany',
  ];

  void _onTabSelected(int index) {
    setState(() => selectedIndex = index);
    context.go(_routes[index]);
  }

  Future<void> getDataPref() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      loginAs = prefs.getString('loginAs');
    });
    if (loginAs == "user") {
      idUser = prefs.getString('idUser');
      namaUser = prefs.getString('nama');
      emailUser = prefs.getString('email');
      noTelpUser = prefs.getString('noTelp');
      hrCompanyId = prefs.getString("hrCompanyId");
    } else if (loginAs == "company") {
      idCompany = prefs.getString('idCompany');
      namaCompany = prefs.getString('nama');
      domainCompany = prefs.getString('domain');
      noTelpCompany = prefs.getString('noTelp');
    }
  }

  Future<void> _initialize() async {
    await getDataPref();
    await _loadNotificationData();
    setState(() {
      isLoading = false;
    });
    _startPeriodicRefresh();
  }

  Future<void> _loadNotificationData() async {
    var notification = await _notificationUseCase.getNotification(
      idUser ?? idCompany ?? '',
    );
    if (notification != null) {
      setState(() {
        dataNotif = notification
            .map<Notificationitem>(
              (item) => Notificationitem(
                icon: Icons.info,
                iconColor: Colors.blueAccent,
                title: item.title,
                subtitle: item.message,
                bgColor: Colors.blue.shade200,
                routeName: item.route,
                isRead: item.isRead,
              ),
            )
            .toList();

        this.notification = notification;
      });
    }
  }

  Future<void> _readNotification(NotificationRequest notificationId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accountId =
          prefs.getString('idUser') ?? prefs.getString('idCompany');

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
      print("Refreshing notification data...");
      _refreshNotificationData();
    });
  }

  @override
  void initState() {
    super.initState();
    AuthRemoteDataSource _dataSourceNotification = AuthRemoteDataSource();
    AuthRepositoryImpl _repoNotification = AuthRepositoryImpl(
      _dataSourceNotification,
    );
    _notificationUseCase = NotificationUsecase(_repoNotification);
    _initialize();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return PopScope(
      canPop: false,
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.grey.shade200,
            appBar: TopApplayout(
              onToggleNotification: toggleNotification,
              currentIndex: selectedIndex,
              onTabSelected: _onTabSelected,
              loginAs: loginAs ?? "",
              notificationCount:
                  dataNotif?.where((item) => !item.isRead).length ?? 0,
            ),
            body: widget.child,
            bottomNavigationBar: BottomApplayout(
              currentIndex: selectedIndex,
              onTabSelected: _onTabSelected,
              loginAs: loginAs ?? "",
              hrCompanyId: hrCompanyId ?? null,
            ),
          ),

          if (_showNotification)
            Notificationbody(
              toggleNotification: toggleNotification,
              data: dataNotif ?? [],
            ),
        ],
      ),
    );
  }
}
