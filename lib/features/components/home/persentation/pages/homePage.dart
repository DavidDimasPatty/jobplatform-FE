import 'package:flutter/material.dart';
import 'package:job_platform/features/components/home/persentation/widgets/pelamar/benchmarkItem.dart';
import 'package:job_platform/features/components/home/persentation/widgets/pelamar/homePageBody.dart';
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

  String? idCompany;
  String? namaCompany;
  String? domainCompany;
  String? noTelpCompany;
  bool? isHRD = false;
  bool isLoading = true;

  List<Benchmarkitem> dataBenchmark = [];

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
      } else if (loginAs == "company") {
        idCompany = prefs.getString('idCompany');
        namaCompany = prefs.getString('nama');
        domainCompany = prefs.getString('domain');
        noTelpCompany = prefs.getString('noTelp');
      }
      isLoading = false;
      dataBenchmark = [
        Benchmarkitem(
          title: "Nando Witin (25)",
          subtitle: "Back End Developer",
          skill: ["Dart", "C#", "React"],
        ),
        Benchmarkitem(
          title: "Nando Sitorus (25)",
          subtitle: "Front End Developer",
          skill: ["Dart", "C#", "Java"],
        ),
        Benchmarkitem(
          title: "Nando Baltwin (25)",
          subtitle: "Backend Developer",
          skill: ["Dart", "C#", "Python"],
        ),
      ];
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

  void fetchData() async {
    try {
      setState(() {
        isLoading = true;
        //errorMessage = null;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('idUser');

      if (userId != null) {
        var result;
        if (isHRD == false) {
          result = await homePageUseCases!.getHomePageUser(userId);
        } else {
          result = await homePageUseCases!.getHomePageHR(userId);
        }
        // List<StatusAllVM>? statusData = result != null
        //     ? List<StatusAllVM>.from(result)
        //     : null;
        if (result != null) {
          setState(() {
            // statusData.forEach((x) {
            //   dataSub.add(
            //     statusjobitems(
            //       namaPerusahaan: x.namaPerusahaan ?? "",
            //       jabatan: x.jabatan ?? "",
            //       onTap: () => TapItems(x.idUserVacancy ?? ""),
            //       posisi: x.namaPosisi ?? "",
            //       status:
            //           x.isAcceptUser == false &&
            //               x.status == null &&
            //               x.alasanRejectUser == null
            //           ? "Menunggu Konfirmasi"
            //           : x.status == 0 &&
            //                 x.isAcceptUser == true &&
            //                 x.isRejectHRD == false
            //           ? "Review"
            //           : x.status == 1 &&
            //                 x.isAcceptUser == true &&
            //                 x.isRejectHRD == false
            //           ? "Interview"
            //           : x.status == 2 &&
            //                 x.isAcceptUser == true &&
            //                 x.isRejectHRD == false
            //           ? "Offering"
            //           : x.status == 3 &&
            //                 x.isAcceptUser == true &&
            //                 x.isRejectHRD == false
            //           ? "Close"
            //           : x.isAcceptUser == false &&
            //                 x.status == null &&
            //                 x.alasanRejectUser != null
            //           ? "Reject Vacancy"
            //           : x.isAcceptUser == false
            //           ? "Reject Offering"
            //           : "Reject HRD",
            //       tipeKerja: x.tipeKerja ?? "",
            //       url: x.logoPerusahaan ?? "",
            //     ),
            //   );
            // });
            // dumpSub = dataSub;

            // errorMessage = null;
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
          : Homepagebody(items: dataBenchmark),
    );
  }
}
