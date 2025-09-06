import 'package:flutter/material.dart';
import 'package:job_platform/features/shared/layout.dart';
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
  String? loginAs = null;
  String? idUser = null;
  String? namaUser = null;
  String? emailUser = null;
  String? noTelpUser = null;

  String? idCompany = null;
  String? namaCompany = null;
  String? domainCompany = null;
  String? noTelpCompany = null;
  bool isLoading = true;

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
    return Layout(
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : Container(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome To Skillen",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (loginAs == "user") Text("Welcome User $namaUser"),
                    if (loginAs == "company")
                      Text("Welcome Company $namaCompany"),
                    if (loginAs != "user" && loginAs != "company")
                      Text("Sesi Habis"),
                  ],
                ),
              ),
      ),
    );
  }
}
