import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:job_platform/features/components/profile/data/datasources/aut_remote_datasource.dart';
import 'package:job_platform/features/components/profile/data/models/skillModel.dart';
import 'package:job_platform/features/components/profile/data/models/skillRequest.dart';
import 'package:job_platform/features/components/profile/data/models/skillResponse.dart';
import 'package:job_platform/features/components/profile/data/repositories/auth_repository_impl.dart';
import 'package:job_platform/features/components/profile/domain/entities/SkillMV.dart';
import 'package:job_platform/features/components/profile/domain/usecases/profile_usecase.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:select2dot1/select2dot1.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SkillEdit extends StatefulWidget {
  final List<SkillMV> skills;

  const SkillEdit({super.key, required this.skills});

  @override
  _SkillEditState createState() => _SkillEditState(listSkill: skills);
}

class _SkillEditState extends State<SkillEdit> {
  final List<SkillMV> listSkill;

  _SkillEditState({required this.listSkill});

  // Form key
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  late SelectDataController _selectSkillController;

  // Helper variables
  bool _isLoading = false;

  // Use case instance
  late ProfileUsecase _profileUseCase;

  @override
  void initState() {
    super.initState();
    _initializeUseCase();
    _getAllSkill();
  }

  void _initializeUseCase() {
    final dataSource = AuthRemoteDataSource();
    final repository = AuthRepositoryImpl(dataSource);
    _profileUseCase = ProfileUsecase(repository);
  }

  Future _getAllSkill({String? name = ""}) async {
    try {
      setState(() {
        _isLoading = true;
      });

      var data = await _profileUseCase.getAllSkill(name);
      if (!mounted) return;

      List<SingleItemCategoryModel> skillItem = [];

      if (data != null && data.isNotEmpty) {
        skillItem = data
            .map(
              (skill) => SingleItemCategoryModel(
                nameSingleItem: skill.nama,
                value: skill,
              ),
            )
            .toList();

        final skillList = [
          SingleCategoryModel(singleItemCategoryList: skillItem),
        ];

        // Find matching items by comparing a unique property
        var filteredSkill = listSkill
            .where((skill) => skill.idSource == null)
            .toList();
        var initSelectedItems = filteredSkill.map((userSkill) {
          return skillItem.firstWhere(
            (skillItem) => skillItem.value.idSkill == userSkill.skill.idSkill,
            orElse: () => SingleItemCategoryModel(
              nameSingleItem: userSkill.skill.nama,
              value: userSkill.skill,
            ),
          );
        }).toList();

        setState(() {
          _selectSkillController = SelectDataController(
            data: skillList,
            initSelected: initSelectedItems,
          );
        });
      }
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to get skill data. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? idUser = prefs.getString('idUser');

        // Ensure idUser is not null
        if (idUser == null) throw Exception("User ID not found in preferences");

        // Map selected skills to SkillModel list
        late List<SkillModel> skill;
        var selectedList = _selectSkillController.selectedList;
        if (selectedList.isNotEmpty) {
          skill = selectedList
              .where((item) => item.value is SkillModel)
              .map((item) => item.value as SkillModel)
              .toList();
        } else {
          skill = [];
        }

        SkillRequest editedSkill = SkillRequest(idUser: idUser, skill: skill);

        SkillResponse response = await _profileUseCase.editSkill(editedSkill);

        // On success, clear the form or navigate away
        if (response.responseMessage == 'Sukses') {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Skill edited successfully!')));
          context.go('/profile');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to edit skill. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
        _formKey.currentState!.reset();
      } catch (e) {
        // Handle errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to edit skill. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading skills...'),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(20.0),
      child: Center(
        child: Container(
          width: ResponsiveBreakpoints.of(context).smallerThan(DESKTOP)
              ? double.infinity
              : MediaQuery.of(context).size.width * 0.45,
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        child: Text(
                          'Edit Skill',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30,
                            letterSpacing: 2,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      buildDropdownField(
                        'skill-select',
                        'Skill',
                        _selectSkillController,
                      ),
                      SizedBox(height: 20),
                      _isLoading
                          ? CircularProgressIndicator()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: _submitForm,
                                  icon: Icon(Icons.check),
                                  iconAlignment: IconAlignment.end,
                                  label: Text('Submit'),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.secondary,
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
    );
  }

  Widget buildDropdownField(
    String key,
    String label,
    SelectDataController controller, {
    void Function(dynamic)? onChange,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Select2dot1(
        key: ValueKey(key),
        pillboxTitleSettings: PillboxTitleSettings(title: label),
        selectDataController: controller,
        onChanged: onChange,
      ),
    );
  }
}
