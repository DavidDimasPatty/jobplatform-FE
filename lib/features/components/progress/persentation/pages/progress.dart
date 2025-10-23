import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:job_platform/features/components/progress/data/datasources/aut_remote_datasource.dart';
import 'package:job_platform/features/components/progress/data/repositories/auth_repository_impl.dart';
import 'package:job_platform/features/components/progress/domain/entities/progressAllVM.dart';
import 'package:job_platform/features/components/progress/domain/usecases/progress_usecase.dart';
import 'package:job_platform/features/components/progress/persentation/widgets/progress/progressBody.dart';
import 'package:job_platform/features/components/progress/persentation/widgets/progress/progressItems.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Progress extends StatefulWidget {
  Progress({super.key});

  @override
  State<Progress> createState() => _Progress();
}

class _Progress extends State<Progress> {
  List<Progressitems> dataSub = [];
  List<Progressitems> dumpSub = [];
  String searchQuery = "";
  bool isLoading = true;
  String? errorMessage;
  AuthRepositoryImpl? _repoProgress;
  AuthRemoteDataSource? _dataSourceProgress;
  ProgressUsecase? _progressUseCase;
  final _searchController = TextEditingController();
  Future<void> _loadProgress() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('idUser');

      if (userId != null) {
        final result = await _progressUseCase!.getAllProgress(userId);
        List<ProgressAllVM>? statusData = result != null
            ? List<ProgressAllVM>.from(result)
            : null;
        if (statusData != null) {
          setState(() {
            statusData.forEach((x) {
              dataSub.add(
                Progressitems(
                  namaKandidat: x.namaKandidat,
                  jabatan: x.jabatanPosisi,
                  onTap: () => TapItems(x.idUserVacancy!),
                  namaPosisi: x.namaPosisi,
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
                  tipeKerja: x.tipeKerja,
                  url: x.url,
                ),
              );
            });
            dumpSub = dataSub;
            isLoading = false;
            errorMessage = null;
          });
        }
      } else {
        print("User ID not found in SharedPreferences");
      }
      setState(() {
        isLoading = false;
        errorMessage = null;
      });
    } catch (e) {
      print("Error loading progress data: $e");
      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = "Error progress profile: $e";
        });
      }
    }
  }

  void TapItems(String id) {
    context.go("/progressDetail", extra: {"data": id});
  }

  @override
  void initState() {
    super.initState();
    _dataSourceProgress = AuthRemoteDataSource();
    _repoProgress = AuthRepositoryImpl(_dataSourceProgress!);
    _progressUseCase = ProgressUsecase(_repoProgress!);
    _loadProgress();
  }

  void _applyFilter() {
    setState(() {
      if ((searchQuery.isEmpty || searchQuery.trim().isEmpty)) {
        dumpSub = List.from(dataSub);
        return;
      }

      dumpSub = dataSub.where((data) {
        final matchSearch =
            (data.namaKandidat?.toLowerCase().contains(
                  searchQuery.toLowerCase(),
                ) ??
                false) ||
            (data.namaPosisi?.toLowerCase().contains(
                  searchQuery.toLowerCase(),
                ) ??
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
            Text('Loading Setting data...'),
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
                child: Progressbody(
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
