import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:job_platform/features/components/statusJob/data/datasources/aut_remote_datasource.dart';
import 'package:job_platform/features/components/statusJob/data/repositories/auth_repository_impl.dart';
import 'package:job_platform/features/components/statusJob/domain/entities/statusAllVM.dart';
import 'package:job_platform/features/components/statusJob/domain/usecases/status_usecase.dart';
import 'package:job_platform/features/components/statusJob/persentation/widgets/statusJob/statusJobBody.dart';
import 'package:job_platform/features/components/statusJob/persentation/widgets/statusJob/statusJobItems.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

class statusJob extends StatefulWidget {
  statusJob({super.key});
  @override
  State<statusJob> createState() => _statusJob();
}

class _statusJob extends State<statusJob> {
  List<statusjobitems> dataSub = [];
  List<statusjobitems> dumpSub = [];
  String searchQuery = "";
  bool isLoading = true;
  String? errorMessage;
  AuthRepositoryImpl? _repoStatus;
  AuthRemoteDataSource? _dataSourceStatus;
  StatusUseCase? _statusUseCase;
  final _searchController = TextEditingController();
  Future<void> _loadStatus() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('idUser');

      if (userId != null) {
        final result = await _statusUseCase!.getAllStatus(userId);
        List<StatusAllVM>? statusData = result != null
            ? List<StatusAllVM>.from(result)
            : null;
        if (statusData != null) {
          setState(() {
            statusData.forEach((x) {
              dataSub.add(
                statusjobitems(
                  namaPerusahaan: x.namaPerusahaan ?? "",
                  jabatan: x.jabatan ?? "",
                  onTap: () => TapItems(x.idUserVacancy ?? ""),
                  posisi: x.namaPosisi ?? "",
                  status: x.isAcceptUser == false && x.status == null
                      ? "Menunggu Konfirmasi"
                      : x.status == 0 &&
                            x.isAcceptUser == true &&
                            x.isRejectHRD == false
                      ? "Review"
                      : x.status == 1 &&
                            x.isAcceptUser == true &&
                            x.isRejectHRD == false
                      ? "Interview"
                      : x.status == 2 &&
                            x.isAcceptUser == true &&
                            x.isRejectHRD == false
                      ? "Offering"
                      : x.status == 3 &&
                            x.isAcceptUser == true &&
                            x.isRejectHRD == false
                      ? "Close"
                      : x.isAcceptUser == false
                      ? "Reject Offering"
                      : "Reject HRD",
                  tipeKerja: x.tipeKerja ?? "",
                  url: x.logoPerusahaan ?? "",
                ),
              );
            });
            dumpSub = dataSub;
            isLoading = false;
            errorMessage = null;
          });
        }
      } else {
        setState(() {
          isLoading = false;
          errorMessage = null;
        });
        print("User ID not found in SharedPreferences");
      }
    } catch (e) {
      print("Error loading status data: $e");
      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = "Error loading status: $e";
        });
      }
    }
  }

  void TapItems(String id) {
    context.go("/statusJobDetail", extra: {"data": id});
  }

  @override
  void initState() {
    super.initState();
    _dataSourceStatus = AuthRemoteDataSource();
    _repoStatus = AuthRepositoryImpl(_dataSourceStatus!);
    _statusUseCase = StatusUseCase(_repoStatus!);
    _loadStatus();
  }

  void _applyFilter() {
    setState(() {
      if ((searchQuery.isEmpty || searchQuery.trim().isEmpty)) {
        dumpSub = List.from(dataSub);
        return;
      }

      dumpSub = dataSub.where((data) {
        final matchSearch =
            (data.namaPerusahaan?.toLowerCase().contains(
                  searchQuery.toLowerCase(),
                ) ??
                false) ||
            (data.posisi?.toLowerCase().contains(searchQuery.toLowerCase()) ??
                false);
        return matchSearch;
      }).toList();
    });
  }

  void _onSearchChanged() {
    searchQuery = _searchController.text;
    _applyFilter();
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
            Text('Loading data status...'),
          ],
        ),
      );
    }

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
            layout: ResponsiveRowColumnType.COLUMN,
            rowSpacing: 100,
            columnSpacing: 20,
            children: [
              ResponsiveRowColumnItem(
                rowFlex: 2,
                child: Statusjobbody(
                  items: dumpSub,
                  onSearchChanged: _onSearchChanged,
                  searchController: _searchController,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
