import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:job_platform/core/utils/storage/storage_service.dart';
import 'package:job_platform/features/components/home/data/models/HRDList.dart';
import 'package:job_platform/features/components/home/data/models/OpenVacancy.dart';
import 'package:job_platform/features/components/home/data/models/ProsesPelamaran.dart';
import 'package:job_platform/features/components/home/data/models/ProsesPerekrutan.dart';
import 'package:job_platform/features/components/home/domain/entities/HomePageCompanyVM.dart';
import 'package:job_platform/features/components/home/persentation/widgets/company/homePageCompanyBody.dart';
import 'package:job_platform/features/components/home/persentation/widgets/company/hrListitem.dart';
import 'package:job_platform/features/components/home/persentation/widgets/company/vacancyTableItem.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/usecases/homePageUseCase.dart';
import '../../data/datasources/HomeRemoteDataSource.dart';
import '../../data/repositories/homeRepositoryImpl.dart';

class HomePageCompany extends StatefulWidget {
  const HomePageCompany({super.key});

  @override
  State<HomePageCompany> createState() => _HomePageCompany();
}

class _HomePageCompany extends State<HomePageCompany> {
  late homePageUseCase homePageUseCases;
  String? loginAs;
  String? idUser;
  String? namaUser;
  String? emailUser;
  String? noTelpUser;

  String? idCompany;
  String? namaCompany;
  String? domainCompany;
  String? noTelpCompany;
  bool isLoading = true;

  List<Vacancytableitem> dataVacancy = [];
  List<hrListitem>? itemsHr = [];
  ProsesPelamaran? dataProsesPelamaran;
  ProsesPerekrutan? dataProsesPerekrutan;

  Future<void> getDataPref() async {
    final storage = StorageService();
    loginAs = await storage.get('loginAs');

    if (loginAs == "user") {
      idUser = await storage.get('idUser');
      namaUser = await storage.get('nama');
      emailUser = await storage.get('email');
      noTelpUser = await storage.get('noTelp');
    } else if (loginAs == "company") {
      idCompany = await storage.get('idCompany');
      namaCompany = await storage.get('nama');
      domainCompany = await storage.get('domain');
      noTelpCompany = await storage.get('noTelp');
    }
    isLoading = false;
  }

  @override
  void initState() {
    super.initState();
    init();
    final remoteDataSource = HomeRemoteDataSource();
    final repository = homeRepositoryImpl(remoteDataSource);
    homePageUseCases = homePageUseCase(repository);
    //fetchData();
  }

  Future<void> init() async {
    await getDataPref();
    await fetchData();
  }

  Future<void> fetchData() async {
    try {
      setState(() {
        isLoading = true;
      });
      final storage = StorageService();
      String? userId = await storage.get('idUser');

      if (userId != null) {
        HomePageCompanyVM? result = await homePageUseCases!.getHomePageCompany(
          userId,
        );

        if (result != null) {
          setState(() {
            dataProsesPelamaran = result.dataProsesPelamaran;
            dataProsesPerekrutan = result.dataProsesPerekrutan;

            dataVacancy = (result.dataVacancy as List<OpenVacancy>)
                .asMap()
                .entries
                .map(
                  (entry) => Vacancytableitem(
                    title: entry.value.namaPosisi ?? '',
                    index: entry.key.toString(),
                    subtitle:
                        "${entry.value.jabatan} - ${entry.value.tipeKerja}",
                  ),
                )
                .toList();

            itemsHr = (result.dataHRD as List<HRDList>)
                .map(
                  (e) =>
                      hrListitem(title: e.nama, subtitle: e.email, url: e.url),
                )
                .toList();

            isLoading = false;
          });
        }
      } else {
        setState(() {
          isLoading = false;
        });
        print("User ID not found in SharedPreferences");
      }
    } catch (e) {
      print("Error loading status data: $e");
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: isLoading
          ? CircularProgressIndicator(color: Colors.blue)
          : HomepageCompanybody(
              items: dataVacancy,
              itemsHr: itemsHr,
              dataPelamaran: dataProsesPelamaran,
              dataPerekrutan: dataProsesPerekrutan,
            ),
    );
  }
}
