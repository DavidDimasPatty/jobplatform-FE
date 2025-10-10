import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:job_platform/features/components/manageHRD/data/datasources/aut_remote_datasource.dart'
    show AuthRemoteDataSource;
import 'package:job_platform/features/components/manageHRD/data/models/GetAllHRDTransaction.dart';
import 'package:job_platform/features/components/manageHRD/domain/entities/HRDDataVM.dart';
import 'package:job_platform/features/components/manageHRD/domain/entities/ManageHRDResponse.dart';
import 'package:job_platform/features/components/manageHRD/domain/repositories/auth_repository.dart';
import 'package:job_platform/features/components/manageHRD/domain/usecases/manageHRD_usecase.dart';
import 'package:job_platform/features/components/manageHRD/persentation/widgets/manageHRD/manageHRDBody.dart';
import 'package:job_platform/features/components/manageHRD/persentation/widgets/manageHRD/manageHRDItems.dart';
import 'package:job_platform/features/components/manageHRD/data/repositories/auth_repository_impl.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Managehrd extends StatefulWidget {
  Managehrd({super.key});

  @override
  State<Managehrd> createState() => _Managehrd();
}

class _Managehrd extends State<Managehrd> {
  List<Managehrditems> dataSub = [];
  // Loading state
  bool isLoading = true;
  String? errorMessage;
  final _formKey = GlobalKey<FormState>();
  AuthRepositoryImpl? _repoManageHRD;
  AuthRemoteDataSource? _dataSourceHRD;
  ManagehrdUsecase? _hrdUseCase;

  final TextEditingController _emailController = TextEditingController();
  Future<void> _loadHRD() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? idCompany = prefs.getString('idCompany');

      if (idCompany != null) {
        List<HRDDataVM?>? profile = await _hrdUseCase!.getAllHRD(idCompany!);
        if (profile != null) {
          setState(() {
            isLoading = false;
            errorMessage = null;

            dataSub = profile
                .map(
                  (e) => Managehrditems(
                    title: e!.nama!,
                    subtitle: e!.email,
                    url: e.photoURL,
                    status: e!.status!,
                    onDelete: () => deleteHRD(e!.id!),
                  ),
                )
                .toList();
          });
        }
      } else {
        print("Company ID not found");
      }
    } catch (e) {
      print("Error loading Load HRD data: $e");
      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = "Error Load HRD Data: $e";
        });
      }
    }
  }

  void _showEmailDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text("Masukkan Email"),
          content: ConstrainedBox(
            constraints: BoxConstraints(minWidth: 500, maxWidth: 500),
            child: Form(
              key: _formKey,
              child: TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: "Email User Terdaftar....",
                  hintText: "contoh@email.com",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Email tidak boleh kosong";
                  }
                  final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                  if (!regex.hasMatch(value)) {
                    return "Format email tidak valid";
                  }
                  return null;
                },
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Batal", style: TextStyle(color: Colors.blue)),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.blue,
                ), // Set background color
                foregroundColor: MaterialStateProperty.all<Color>(
                  Colors.white,
                ), // Text/icon color
                padding: MaterialStateProperty.all<EdgeInsets>(
                  EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                elevation: MaterialStateProperty.all<double>(6), // Shadow depth
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  AddHRD(_emailController.text);
                  Navigator.of(context).pop();
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(content: Text("Email: ${_emailController.text}")),
                  // );
                }
              },
              child: Text("Submit", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Future deleteHRD(String id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? idCompany = prefs.getString('idCompany');

      if (idCompany == null)
        throw Exception("Company ID not found in preferences");

      GetAllHRDTransaction profile = new GetAllHRDTransaction(id: id);

      ManageHRDResponse? response = await _hrdUseCase!.deleteHRD(profile);
      if (response!.responseMessage == 'Sukses') {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('HRD Delete successfully!')));
        setState(() {
          _loadHRD();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response!.responseMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      debugPrint('Error during edit profile: $e');
      if (mounted) {
        return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Internal Error"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future AddHRD(String email) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? idCompany = prefs.getString('idCompany');

      if (idCompany == null)
        throw Exception("Company ID not found in preferences");

      GetAllHRDTransaction profile = new GetAllHRDTransaction(
        idCompany: idCompany,
      );

      ManageHRDResponse? response = await _hrdUseCase!.addHRD(profile, email);
      if (response!.responseMessage == 'Sukses') {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('HRD Delete successfully!')));
        setState(() {
          _loadHRD();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response!.responseMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      debugPrint('Error during edit profile: $e');
      if (mounted) {
        return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Internal Error"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _dataSourceHRD = AuthRemoteDataSource();
    _repoManageHRD = AuthRepositoryImpl(_dataSourceHRD!);
    _hrdUseCase = ManagehrdUsecase(_repoManageHRD!);
    _loadHRD();
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

    // Show error message if there's an error
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
            // ElevatedButton(onPressed: _loadProfileData, child: Text('Retry')),
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
            // layout: ResponsiveBreakpoints.of(context).smallerThan(TABLET)
            //     ? ResponsiveRowColumnType.COLUMN
            //     : ResponsiveRowColumnType.ROW,
            layout: ResponsiveRowColumnType.COLUMN,
            rowSpacing: 100,
            columnSpacing: 20,
            children: [
              ResponsiveRowColumnItem(
                rowFlex: 2,
                child: Managehrdbody(items: dataSub, popup: _showEmailDialog),
              ),
              // ResponsiveRowColumnItem(rowFlex: 2, child: bodySetting()),
            ],
          ),
        ),
      ),
    );
  }
}
