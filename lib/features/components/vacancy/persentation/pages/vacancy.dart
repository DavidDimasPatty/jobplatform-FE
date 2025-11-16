import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:job_platform/features/components/vacancy/data/datasources/aut_remote_datasource.dart';
import 'package:job_platform/features/components/vacancy/data/models/vacancyResponse.dart';
import 'package:job_platform/features/components/vacancy/data/repositories/auth_repository_impl.dart';
import 'package:job_platform/features/components/vacancy/domain/entities/vacancyData.dart';
import 'package:job_platform/features/components/vacancy/domain/usecases/vacancy_usecase.dart';
import 'package:job_platform/features/components/vacancy/persentation/widgets/vacancy/vacancyBody.dart';
import 'package:job_platform/features/components/vacancy/persentation/widgets/vacancy/vacancyItems.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Vacancy extends StatefulWidget {
  Vacancy({super.key});

  @override
  State<Vacancy> createState() => _Vacancy();
}

class _Vacancy extends State<Vacancy> {
  final _searchController = TextEditingController();

  List<Vacancyitems> dataSub = [];
  List<Vacancyitems> tempSub = [];
  Timer? _debounce;

  // Loading state
  bool isLoading = true;
  String? errorMessage;

  // Usecase
  late VacancyUseCase _vacancyUseCase;

  @override
  void initState() {
    super.initState();
    AuthRemoteDataSource _dataSourceVacancy = AuthRemoteDataSource();
    AuthRepositoryImpl _repoVacancy = AuthRepositoryImpl(_dataSourceVacancy);
    _vacancyUseCase = VacancyUseCase(_repoVacancy);
    _loadVacancyData();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadVacancyData() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? companyId = prefs.getString('idCompany');

      if (companyId != null) {
        var vacancy = await _vacancyUseCase.getListVacancy(companyId);
        if (vacancy != null) {
          int idx = 1;
          setState(() {
            isLoading = false;

            dataSub = vacancy
                .map(
                  (item) => Vacancyitems(
                    index: "${idx++}",
                    title: item.jabatan!,
                    subtitle: item.namaPosisi,
                    vacancy: VacancyData(
                      item.id,
                      item.idCompany,
                      item.lokasi,
                      item.namaPosisi,
                      item.jabatan,
                      item.gajiMin,
                      item.gajiMax,
                      item.tipeKerja,
                      item.sistemKerja,
                    ),
                    onDelete: () => _deleteVacancy(item.id),
                  ),
                )
                .toList();

            tempSub = dataSub;
          });
        }
      } else {
        print("Company ID not found in SharedPreferences".tr());
      }
    } catch (e) {
      print("${"Error loading vacancy data:".tr()} $e");
      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = "${"Error loading vacancy:".tr()} $e";
        });
      }
    }
  }

  Future<void> _deleteVacancy(String id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? idCompany = prefs.getString('idCompany');

      if (idCompany == null)
        throw Exception("Company ID not found in preferences".tr());

      VacancyResponse response = await _vacancyUseCase.vacancyDelete(id);

      if (response.responseMessage == 'Sukses') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Vacancy Delete successfully!'.tr())),
        );
        setState(() {
          _loadVacancyData();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.responseMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      debugPrint('${"Error during delete vacancy:".tr()} $e');
      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = "${"Error delete vacancy:".tr()} $e";
        });
      }
    }
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
                        (data.subtitle?.toLowerCase().contains(query) ?? false),
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
            Text('Loading vacancy data...'.tr()),
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
                child: Vacancybody(
                  items: tempSub,
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
