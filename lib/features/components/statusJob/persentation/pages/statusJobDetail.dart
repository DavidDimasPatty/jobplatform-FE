import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_platform/features/components/statusJob/data/datasources/aut_remote_datasource.dart';
import 'package:job_platform/features/components/statusJob/data/repositories/auth_repository_impl.dart';
import 'package:job_platform/features/components/statusJob/domain/entities/statusDetailVM.dart';
import 'package:job_platform/features/components/statusJob/domain/usecases/status_usecase.dart';
import 'package:job_platform/features/components/statusJob/persentation/widgets/statusJobDetail/statusJobDetailMore.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Statusjobdetail extends StatefulWidget {
  final String? dataId;
  Statusjobdetail({super.key, required this.dataId});
  @override
  State<Statusjobdetail> createState() => _Statusjobdetail();
}

class _Statusjobdetail extends State<Statusjobdetail> {
  _Statusjobdetail();

  // Data
  StatusDetailVM? data = StatusDetailVM();
  bool isLoading = true;
  String? errorMessage;
  AuthRepositoryImpl? _repoStatus;
  AuthRemoteDataSource? _dataSourceStatus;
  StatusUseCase? _statusUseCase;
  int stepsImpl = 0;
  List<String> steps = ["Review", "Interview", "Offering", "Close"];

  @override
  void initState() {
    super.initState();
    _initializeUseCase();
    _loadDetailStatus();
  }

  void _initializeUseCase() {
    _dataSourceStatus = AuthRemoteDataSource();
    _repoStatus = AuthRepositoryImpl(_dataSourceStatus!);
    _statusUseCase = StatusUseCase(_repoStatus!);
  }

  Future<void> _loadDetailStatus() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('idUser');

      if (userId != null) {
        var detailStatus = await _statusUseCase?.getDetailStatus(userId);
        if (detailStatus != null) {
          setState(() {
            data = detailStatus;
            isLoading = false;
            errorMessage = null;
          });
        }
      } else {
        print("User ID not found in SharedPreferences");
      }
    } catch (e) {
      print("Error loading status data: $e");
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = "Error loading status: $e";
      });
    }
  }

  Future<String?> showConfirmStatus(BuildContext context, bool status) {
    final TextEditingController alasanController = TextEditingController();

    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        if (status) {
          // ✅ Konfirmasi biasa
          return AlertDialog(
            title: const Text('Konfirmasi Tahapan'),
            content: const Text(
              'Apakah Anda yakin ingin konfirmasi tahapan ini?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(null),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop("CONFIRM"),
                style: TextButton.styleFrom(foregroundColor: Colors.green),
                child: const Text('Konfirmasi'),
              ),
            ],
          );
        } else {
          return AlertDialog(
            title: const Text('Tolak Tahapan'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Silakan masukkan alasan penolakan:'),
                const SizedBox(height: 10),
                TextField(
                  controller: alasanController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Tulis alasan...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(null),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () {
                  if (alasanController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Alasan tidak boleh kosong'),
                      ),
                    );
                    return;
                  }
                  Navigator.of(context).pop(alasanController.text.trim());
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Tolak'),
              ),
            ],
          );
        }
      },
    );
  }

  Future konfirmasiTahapan(bool status) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? id = prefs.getString('id');
      String? idUserVacancy = data?.userVacancy?.id;
      String? alasanReject;
      if (id == null) throw Exception("User ID not found in preferences");

      if (idUserVacancy == null) throw Exception("User ID Vacancy not found");

      final result = await showConfirmStatus(context, status);
      if (result == null) {
        return;
      }

      if (!status) {
        alasanReject = result;
      }
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      if (status == false && alasanReject!.isEmpty)
        throw Exception("Alasan Reject tidak boleh kosong jika penolakan");

      String? response = await _statusUseCase!.validateVacancy(
        idUserVacancy,
        status,
        alasanReject,
        id,
      );
      if (response == 'Sukses') {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Confirm Vacancy Success!')));
        setState(() {
          _loadDetailStatus();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response!), backgroundColor: Colors.red),
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
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading profile data...'),
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
            ElevatedButton(onPressed: _loadDetailStatus, child: Text('Retry')),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 30),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5,
                spreadRadius: 2,
                offset: Offset(3, 3),
              ),
            ],
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          width: ResponsiveBreakpoints.of(context).smallerThan(DESKTOP)
              ? double.infinity
              : MediaQuery.of(context).size.width * 0.45,
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.all(20),
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
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 250,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.blueAccent,
                        ),
                      ),
                      Positioned(right: 10, top: 0, child: Container()),
                      Column(
                        children: [
                          Center(
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.white,
                                  child: CircleAvatar(
                                    radius: 46,
                                    backgroundImage: NetworkImage(
                                      data!.logoPerusahaan!,
                                    ),
                                    backgroundColor: Colors.blueGrey,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            child: Text(
                              data?.namaPerusahaan ?? "",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.ptSerif(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 1,
                                  fontSize: 30,
                                ),
                              ),
                            ),
                          ),

                          Container(
                            child: Text(
                              data?.bidangPerusahaan ?? "",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.ptSerif(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  //letterSpacing: 2,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),

                          Container(
                            child: Text(
                              data?.lokasiPerusahaan ?? "",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.ptSerif(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  //letterSpacing: 2,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                ResponsiveRowColumnItem(child: statusJobDetailMore(data: data)),

                ResponsiveRowColumnItem(
                  child: Container(
                    child: Column(
                      spacing: 40,
                      children: [
                        LayoutBuilder(
                          builder: (context, constraints) {
                            bool isMobile = ResponsiveBreakpoints.of(
                              context,
                            ).smallerThan(TABLET);
                            if (!isMobile) {
                              return SizedBox(
                                width: 800,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(20),
                                      child: Text(
                                        "Proses Rekrutment",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.davidLibre(
                                          textStyle: TextStyle(
                                            color: Colors.blue,
                                            letterSpacing: 2,
                                            fontSize: 25,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: List.generate(
                                        steps.length * 2 - 1,
                                        (index) {
                                          if (index.isEven) {
                                            int stepIndex = index ~/ 2;
                                            return Container(
                                              margin: EdgeInsets.only(top: 60),
                                              child: Column(
                                                children: [
                                                  CircleAvatar(
                                                    radius: 25,
                                                    backgroundColor:
                                                        stepsImpl >= stepIndex
                                                        ? Colors.blue
                                                        : Colors.grey.shade200,
                                                    child: Text(
                                                      "${stepIndex + 1}",
                                                      style: TextStyle(
                                                        color:
                                                            stepsImpl >=
                                                                stepIndex
                                                            ? Colors.white
                                                            : Colors.black,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 100,
                                                    height: 60,
                                                    margin: EdgeInsets.only(
                                                      top: 10,
                                                    ),
                                                    child: Text(
                                                      steps[stepIndex],
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: GoogleFonts.ptSerif(
                                                        textStyle: TextStyle(
                                                          color:
                                                              stepsImpl >=
                                                                  stepIndex
                                                              ? Colors.blue
                                                              : Colors
                                                                    .grey
                                                                    .shade600,
                                                          letterSpacing: 1,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          } else {
                                            int stepIndex = index ~/ 2;
                                            return Expanded(
                                              child: Container(
                                                height: 2,
                                                color: stepsImpl >= stepIndex
                                                    ? Colors.blue
                                                    : Colors.grey.shade600,
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(20),
                                    child: Text(
                                      "Proses Rekrutment",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.davidLibre(
                                        textStyle: TextStyle(
                                          color: Colors.blue,
                                          letterSpacing: 2,
                                          fontSize: 25,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: GridView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 20,
                                            mainAxisSpacing: 20,
                                            childAspectRatio: 1,
                                          ),
                                      itemCount: steps.length,
                                      itemBuilder: (context, index) {
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            CircleAvatar(
                                              radius: 25,
                                              backgroundColor:
                                                  stepsImpl >= index
                                                  ? Colors.blue
                                                  : Colors.grey.shade200,
                                              child: Text(
                                                "${index + 1}",
                                                style: TextStyle(
                                                  color: stepsImpl >= index
                                                      ? Colors.white
                                                      : Colors.blue,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              steps[index],
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.ptSerif(
                                                textStyle: TextStyle(
                                                  color: stepsImpl >= index
                                                      ? Colors.blue
                                                      : Colors.grey.shade600,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                ResponsiveRowColumnItem(
                  child: Container(
                    child: Column(
                      spacing: 40,
                      children: [
                        Row(
                          spacing: 40,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Flexible(
                              flex: 3,
                              child: ElevatedButton.icon(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  minimumSize: Size(
                                    MediaQuery.of(context).size.width * 0.4,
                                    60,
                                  ),
                                ),
                                icon: Icon(Icons.check),
                                label: Text("Accept"),
                              ),
                            ),
                            Flexible(
                              flex: 3,
                              child: ElevatedButton.icon(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  minimumSize: Size(
                                    MediaQuery.of(context).size.width * 0.4,
                                    60,
                                  ),
                                ),
                                icon: Icon(Icons.close),
                                label: Text("Reject"),
                              ),
                            ),
                            Flexible(
                              flex: 4,
                              child: ElevatedButton.icon(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  minimumSize: Size(
                                    MediaQuery.of(context).size.width * 0.4,
                                    60,
                                  ),
                                ),
                                icon: Icon(Icons.chat),
                                label: Text("Chat"),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
