import 'package:flutter/material.dart';
import 'package:job_platform/features/components/home/persentation/widgets/benchmarkItem.dart';
import 'package:job_platform/features/components/home/persentation/widgets/homePageBody.dart';
import 'package:job_platform/features/shared/layout.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../data/datasources/product_remote_datasource.dart';
import '../../data/repositories/product_repository_impl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late GetProductsUseCase getProductsUseCase;
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
    //     await prefs.setString("loginAs", "users");
    // await prefs.setString("idUser", data!.user!.id);
    // await prefs.setString("nama", data!.user!.nama);
    // await prefs.setString("email", data!.user!.email);
    // await prefs.setString("noTelp", data!.user!.noTelp);
    super.initState();
    getDataPref();
    final remoteDataSource = ProductRemoteDataSource();
    final repository = ProductRepositoryImpl(remoteDataSource);
    getProductsUseCase = GetProductsUseCase(repository);
    fetchData();
  }

  void fetchData() async {
    // final result = await getProductsUseCase.execute();
    // setState(() {
    //   products = result;
    // });
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
