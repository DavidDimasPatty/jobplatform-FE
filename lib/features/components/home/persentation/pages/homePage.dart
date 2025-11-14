import 'package:flutter/material.dart';
import 'package:job_platform/features/components/home/data/models/KunjunganProfile.dart';
import 'package:job_platform/features/components/home/data/models/OpenVacancy.dart';
import 'package:job_platform/features/components/home/data/models/ProfileSerupa.dart';
import 'package:job_platform/features/components/home/data/models/TawaranPekerjaan.dart';
import 'package:job_platform/features/components/home/domain/entities/HomePageHRVM.dart';
import 'package:job_platform/features/components/home/domain/entities/HomePageUserVM.dart';
import 'package:job_platform/features/components/home/persentation/widgets/pelamar/benchmarkItem.dart';
import 'package:job_platform/features/components/home/persentation/widgets/pelamar/homePageBody.dart';
import 'package:job_platform/features/components/home/persentation/widgets/pelamar/openVacancyItem.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/usecases/homePageUseCase.dart';
import '../../data/datasources/HomeRemoteDataSource.dart';
import '../../data/repositories/homeRepositoryImpl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late homePageUseCase homePageUseCases;
  String? loginAs;
  String? idUser;
  String? namaUser;
  String? emailUser;
  String? noTelpUser;
  String? photoURL;
  bool? isHRD = false;
  bool isLoading = true;

  List<Benchmarkitem> dataBenchmark = [];
  List<TawaranPekerjaan> dataTawaranPekerjaan = [];
  KunjunganProfile? kunjunganProfile = KunjunganProfile();
  List<OpenVacancyItem> dataOpenVacancy = [];
  double? profileComplete = 0;

  void getDataPref() async {
    final prefs = await SharedPreferences.getInstance();
    loginAs = prefs.getString('loginAs');
    setState(() {
      if (loginAs == "user") {
        idUser = prefs.getString('idUser');
        namaUser = prefs.getString('nama');
        emailUser = prefs.getString('email');
        noTelpUser = prefs.getString('noTelp');
        isHRD = prefs.getBool("isHRD");
        photoURL = prefs.getString("urlAva");
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getDataPref();
    final remoteDataSource = HomeRemoteDataSource();
    final repository = homeRepositoryImpl(remoteDataSource);
    homePageUseCases = homePageUseCase(repository);
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      setState(() {
        isLoading = true;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('idUser');

      if (userId != null) {
        var result;
        if (isHRD == false || isHRD == null) {
          result = await homePageUseCases!.getHomePageUser(userId);
        } else {
          result = await homePageUseCases!.getHomePageHR(userId);
        }

        if (result != null) {
          setState(() {
            if (isHRD == false) {
              HomePageUserVM? resultUser;
              if (result is HomePageUserVM) {
                resultUser = result;
              } else {
                isLoading = false;
                return;
              }
              kunjunganProfile = resultUser.dataKunjunganProfile;
              profileComplete = resultUser.dataProfileComplete;
              dataBenchmark =
                  (resultUser.dataProfileSerupa as List<ProfileSerupa>)
                      .map(
                        (e) => Benchmarkitem(
                          title: "${e!.nama!} (${e.umur})",
                          subtitle: e.posisi,
                          url: e.urlPhoto,
                        ),
                      )
                      .toList();

              dataTawaranPekerjaan =
                  (resultUser.dataTawaran as List<TawaranPekerjaan>)
                      .map(
                        (e) => TawaranPekerjaan(
                          id: e.id,
                          jabatan: e.jabatan,
                          namaPerusahaan: e.namaPerusahaan,
                          namaPosisi: e.namaPosisi,
                          status: e.status,
                          tipeKerja: e.tipeKerja,
                          urlPhoto: e.urlPhoto,
                        ),
                      )
                      .toList();
            } else {
              HomePageHRVM? resultHR;
              if (result is HomePageHRVM) {
                resultHR = result;
              } else {
                isLoading = false;
                return;
              }
              kunjunganProfile = resultHR.dataKunjunganProfile;
              profileComplete = resultHR.dataProfileComplete;
              if (resultHR.dataProfileSerupa != null) {
                dataBenchmark =
                    (resultHR.dataProfileSerupa as List<ProfileSerupa>)
                        .map(
                          (e) => Benchmarkitem(
                            title: "${e!.nama!} (${e.umur})",
                            subtitle: e.posisi,
                            url: e.urlPhoto,
                          ),
                        )
                        .toList();
              }

              if (resultHR.dataTawaran != null) {
                dataTawaranPekerjaan =
                    (resultHR.dataTawaran as List<TawaranPekerjaan>)
                        .map(
                          (e) => TawaranPekerjaan(
                            id: e.id,
                            jabatan: e.jabatan,
                            namaPerusahaan: e.namaPerusahaan,
                            namaPosisi: e.namaPosisi,
                            status: e.status,
                            tipeKerja: e.tipeKerja,
                            urlPhoto: e.urlPhoto,
                          ),
                        )
                        .toList();
              }

              if (resultHR.dataVacancy != null) {
                dataOpenVacancy = (resultHR.dataVacancy as List<OpenVacancy>)
                    .asMap()
                    .entries
                    .map(
                      (entry) => OpenVacancyItem(
                        title: entry.value.namaPosisi ?? '',
                        idx: entry.key.toString(),
                        subtitle:
                            "${entry.value.jabatan} - ${entry.value.tipeKerja}",
                      ),
                    )
                    .toList();
              }
            }
            isLoading = false;
          });
        }
      } else {
        setState(() {
          isLoading = false;
          //  errorMessage = null;
        });
        print("User ID not found in SharedPreferences");
      }
    } catch (e) {
      print("Error loading status data: $e");
      if (mounted) {
        setState(() {
          isLoading = false;
          //errorMessage = "Error loading status: $e";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: isLoading
          ? CircularProgressIndicator(color: Colors.blue)
          : Homepagebody(
              items: dataBenchmark,
              dataTawaranPekerjaan: dataTawaranPekerjaan,
              dataKunjunganProfile: kunjunganProfile,
              dataVacancies: dataOpenVacancy,
              isHRD: isHRD ?? false,
              photoURL: photoURL,
              profileComplete: profileComplete,
              username: namaUser,
            ),
    );
  }
}
