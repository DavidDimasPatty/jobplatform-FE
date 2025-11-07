import 'package:flutter/material.dart';
import 'package:job_platform/features/components/home/persentation/widgets/company/homePageCompanyBody.dart';
import 'package:job_platform/features/components/home/persentation/widgets/company/hrListitem.dart';
import 'package:job_platform/features/components/home/persentation/widgets/company/vacancyTableItem.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../data/datasources/product_remote_datasource.dart';
import '../../data/repositories/product_repository_impl.dart';

class HomePageCompany extends StatefulWidget {
  const HomePageCompany({super.key});

  @override
  State<HomePageCompany> createState() => _HomePageCompany();
}

class _HomePageCompany extends State<HomePageCompany> {
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

  List<Vacancytableitem> dataVacancy = [];
  List<hrListitem>? itemsHr = [];

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
      dataVacancy = [
        Vacancytableitem(
          title: "Back End Developer",
          subtitle: "Supervisor",
          index: "1",
        ),
        Vacancytableitem(
          title: "Front End Developer",
          subtitle: "Manager",
          index: "2",
        ),
        Vacancytableitem(
          title: "Bussiness Analyst",
          subtitle: "Junior Manager",
          index: "3",
        ),
      ];
      itemsHr = [
        hrListitem(title: "Nando Witin", subtitle: "email@gmail.com"),
        hrListitem(title: "Nando Sitorus (25)", subtitle: "email@gmail.com"),
        hrListitem(title: "Nando Baltwin (25)", subtitle: "email@gmail.com"),
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
          : HomepageCompanybody(items: dataVacancy, itemsHr: itemsHr),
    );
  }
}
