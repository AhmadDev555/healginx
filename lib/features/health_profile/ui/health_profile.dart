import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healginx/features/health_profile/bloc/health_profile_cubit.dart';
import 'package:healginx/features/health_profile/bloc/health_profile_states.dart';
import 'package:healginx/features/health_profile/data/models/user_profile_data.dart';
import 'package:healginx/features/home/ui/home.dart';
import 'package:healginx/styles/app_colors.dart';

// ─────────────────────────────────────────────
//  Data Model
// ─────────────────────────────────────────────
// ─────────────────────────────────────────────
//  Theme Constants
// ─────────────────────────────────────────────

// ─────────────────────────────────────────────
//  Main Screen
// ─────────────────────────────────────────────
class UserProfileFormScreen extends StatefulWidget {
  const UserProfileFormScreen({super.key});

  @override
  State<UserProfileFormScreen> createState() => _UserProfileFormScreenState();
}

class _UserProfileFormScreenState extends State<UserProfileFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  final UserProfileData _data = UserProfileData();
  bool _hasLoadedProfile = false;

  // Controllers
  final _nameCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  final _heightCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _targetWeightCtrl = TextEditingController();
  final _medicationsCtrl = TextEditingController();

  final List<String> _allergyChips = [];
  final _allergyInputCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HealthProfileCubit>().loadProfile();
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _ageCtrl.dispose();
    _heightCtrl.dispose();
    _weightCtrl.dispose();
    _targetWeightCtrl.dispose();
    _medicationsCtrl.dispose();
    _allergyInputCtrl.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_validateAndSyncData()) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => DataPreviewScreen(data: _data),
        ),
      );
    }
  }

  void _saveProfile() {
    if (_validateAndSyncData()) {
      context.read<HealthProfileCubit>().saveProfile(_data);
    }
  }

  bool _validateAndSyncData() {
    _commitPendingAllergy();
    final textFieldsValid = _formKey.currentState!.validate();
    _syncDataFromInputs();

    final missingSection = _missingProfileSection();
    if (!textFieldsValid || missingSection != null) {
      final step = missingSection?.step ?? 1;
      final message =
          missingSection?.message ?? 'Please fill Basic Information section';
      _showSnackBar(message, isError: true);
      _scrollToStep(step);
      return false;
    }

    return true;
  }

  void _syncDataFromInputs() {
    _data.fullName = _nameCtrl.text.trim();
    _data.age = int.tryParse(_ageCtrl.text);
    _data.heightValue = double.tryParse(_heightCtrl.text);
    _data.weightValue = double.tryParse(_weightCtrl.text);
    _data.targetWeight = double.tryParse(_targetWeightCtrl.text);
    _data.allergies = _allergyChips.join(', ');
    _data.medications = _medicationsCtrl.text.trim();
  }

  ({int step, String message})? _missingProfileSection() {
    if (_data.fullName.isEmpty ||
        _data.age == null ||
        _data.gender.isEmpty ||
        _data.heightValue == null ||
        _data.weightValue == null) {
      return (step: 1, message: 'Please fill Basic Information section');
    }
    if (_data.primaryGoal.isEmpty ||
        _data.activityLevel.isEmpty ||
        _data.dietStrictness.isEmpty) {
      return (step: 2, message: 'Please fill Goal & Activity section');
    }
    if (_data.dietType.isEmpty ||
        _data.foodRestrictions.isEmpty ||
        _data.eatingStyle.isEmpty ||
        _data.eatingWindow.isEmpty) {
      return (step: 3, message: 'Please fill Diet & Eating Style section');
    }
    if (_data.appetiteLevel.isEmpty || _data.dailyRoutineType.isEmpty) {
      return (step: 4, message: 'Please fill Behavior & Habits section');
    }
    if (_data.medicalConditions.isEmpty) {
      return (step: 5, message: 'Please fill Health & Medical section');
    }
    if (_data.trackWeekly.isEmpty) {
      return (step: 6, message: 'Please fill Future Tracking section');
    }
    return null;
  }

  void _scrollToStep(int step) {
    final estimatedOffset = ((step - 1) * 360).toDouble();
    _scrollController.animateTo(
      estimatedOffset.clamp(0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HealthProfileCubit, HealthProfileStates>(
      listener: _handleProfileState,
      builder: (context, state) {
        final isLoadingProfile = state is HealthProfileLoading;
        final isSavingProfile = state is HealthProfileSaveLoading;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: CustomScrollView(
            controller: _scrollController,
            slivers: [
              _buildAppBar(),
              if (isLoadingProfile && !_hasLoadedProfile)
                const SliverToBoxAdapter(
                  child: LinearProgressIndicator(
                    minHeight: 3,
                    color: AppColors.primary,
                    backgroundColor: AppColors.primaryLight,
                  ),
                ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 8),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildStep1(),
                          _buildStep2(),
                          _buildStep3(),
                          _buildStep4(),
                          _buildStep5(),
                          _buildStep6(),
                        ],
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          ),
          floatingActionButton: _buildSubmitButton(
            isSavingProfile: isSavingProfile,
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }

  void _handleProfileState(BuildContext context, HealthProfileStates state) {
    if (state is HealthProfileLoadSuccess) {
      _hasLoadedProfile = true;
      if (state.profile != null) {
        _applyProfileData(state.profile!);
      }
    } else if (state is HealthProfileSaveSuccess) {
      _showSnackBar('Profile saved successfully');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else if (state is HealthProfileFailure) {
      _showSnackBar(state.error, isError: true);
    }
  }

  void _applyProfileData(UserProfileData profile) {
    setState(() {
      _data.fullName = profile.fullName;
      _data.age = profile.age;
      _data.gender = profile.gender;
      _data.heightValue = profile.heightValue;
      _data.heightUnit = profile.heightUnit;
      _data.weightValue = profile.weightValue;
      _data.weightUnit = profile.weightUnit;
      _data.primaryGoal = profile.primaryGoal;
      _data.targetWeight = profile.targetWeight;
      _data.timeGoal = profile.timeGoal;
      _data.activityLevel = profile.activityLevel;
      _data.dietStrictness = profile.dietStrictness;
      _data.dietType = profile.dietType;
      _data.foodRestrictions = List<String>.from(profile.foodRestrictions);
      _data.mealsPerDay = profile.mealsPerDay;
      _data.eatingStyle = profile.eatingStyle;
      _data.eatingWindow = profile.eatingWindow;
      _data.appetiteLevel = profile.appetiteLevel;
      _data.junkFoodFrequency = profile.junkFoodFrequency;
      _data.dailyRoutineType = profile.dailyRoutineType;
      _data.medicalConditions = List<String>.from(profile.medicalConditions);
      _data.allergies = profile.allergies;
      _data.medications = profile.medications;
      _data.trackWeekly = profile.trackWeekly;

      _nameCtrl.text = profile.fullName;
      _ageCtrl.text = profile.age?.toString() ?? '';
      _heightCtrl.text = profile.heightValue?.toString() ?? '';
      _weightCtrl.text = profile.weightValue?.toString() ?? '';
      _targetWeightCtrl.text = profile.targetWeight?.toString() ?? '';
      _medicationsCtrl.text = profile.medications;
      _allergyChips
        ..clear()
        ..addAll(_splitAllergies(profile.allergies));
      _allergyInputCtrl.clear();
    });
  }

  List<String> _splitAllergies(String allergies) {
    return allergies
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : AppColors.successToastColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      leading: SizedBox.shrink(),
      expandedHeight: 120,
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0,
      shadowColor: AppColors.border,
      surfaceTintColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: AppColors.lightGreen,
          // decoration: const BoxDecoration(
          //   gradient: LinearGradient(
          //     begin: Alignment.topLeft,
          //     end: Alignment.bottomRight,
          //     colors: [Color(0xFF3B6FE8), Color(0xFF6B4EF6)],
          //   ),
          // ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    'Health Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Help us personalise your journey',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        collapseMode: CollapseMode.parallax,
      ),
      title:  SizedBox.shrink()
    );
  }

  Widget _buildSubmitButton({required bool isSavingProfile}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 54,
              child: OutlinedButton(
                onPressed: isSavingProfile ? null : _submit,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: AppColors.primary, width: 1.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Preview',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.visibility_outlined, size: 18,color: AppColors.primary,),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 54,
              child: ElevatedButton(
                onPressed: isSavingProfile ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
                  elevation: 8,
                  shadowColor: AppColors.primary.withOpacity(0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: isSavingProfile
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Save',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.2,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.save_rounded, size: 18,color: AppColors.white,),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── STEP CARD WRAPPER ───────────────────────────────────────
  Widget _stepCard({
    required int step,
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Widget> children,
  }) {
    final color = AppColors.stepColors[step - 1];
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: color.withOpacity(0.06),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: AppColors.text,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    subtitle,
                    style: TextStyle(
                      color: color,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Fields
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  // ─── FIELD LABEL ─────────────────────────────────────────────
  Widget _fieldLabel(String label, {bool required = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (required)
            const Text(' *', style: TextStyle(color: AppColors.error, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _fieldSpacing() => const SizedBox(height: 20);

  // ─── TEXT FIELD ───────────────────────────────────────────────
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      validator: validator,
      style: const TextStyle(color: AppColors.text, fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
        filled: true,
        fillColor: AppColors.background,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
      ),
    );
  }

  // ─── RADIO GROUP ──────────────────────────────────────────────
  Widget _buildRadioGroup({
    required String value,
    required List<String> options,
    required void Function(String) onChanged,
    Color? accentColor,
  }) {
    final color = accentColor ?? AppColors.primary;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((option) {
        final selected = value == option;
        return GestureDetector(
          onTap: () => setState(() => onChanged(option)),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: selected ? color.withOpacity(0.1) : AppColors.background,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: selected ? color : AppColors.border,
                width: selected ? 1.5 : 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected ? color : AppColors.textSecondary,
                      width: selected ? 5 : 1.5,
                    ),
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  option,
                  style: TextStyle(
                    color: selected ? color : AppColors.text,
                    fontSize: 13,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // ─── CHECKBOX GROUP ───────────────────────────────────────────
  Widget _buildCheckboxGroup({
    required List<String> selected,
    required List<String> options,
    required void Function(List<String>) onChanged,
    Color? accentColor,
  }) {
    final color = accentColor ?? AppColors.primary;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((option) {
        final isSelected = selected.contains(option);
        return GestureDetector(
          onTap: () {
            setState(() {
              final newList = List<String>.from(selected);
              if (isSelected) {
                newList.remove(option);
              } else if (option == 'None') {
                newList
                  ..clear()
                  ..add(option);
              } else {
                newList.remove('None');
                newList.add(option);
              }
              onChanged(newList);
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? color.withOpacity(0.1) : AppColors.background,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected ? color : AppColors.border,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: isSelected ? color : Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: isSelected ? color : AppColors.textSecondary,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, size: 13, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: 8),
                Text(
                  option,
                  style: TextStyle(
                    color: isSelected ? color : AppColors.text,
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // ─── DROPDOWN ─────────────────────────────────────────────────
  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
    Color? accentColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textSecondary),
          style: const TextStyle(color: AppColors.text, fontSize: 14),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(12),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  // ─── NUMBER + UNIT ROW ────────────────────────────────────────
  Widget _buildNumberWithUnit({
    required TextEditingController controller,
    required String hint,
    required String unitValue,
    required List<String> unitOptions,
    required void Function(String?) onUnitChanged,
    String? Function(String?)? validator,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: TextFormField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
            validator: validator,
            style: const TextStyle(color: AppColors.text, fontSize: 15),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
              filled: true,
              fillColor: AppColors.background,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.error),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary.withOpacity(0.3)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: unitValue,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down_rounded,
                    color: AppColors.primary, size: 18),
                style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600),
                dropdownColor: Colors.white,
                borderRadius: BorderRadius.circular(12),
                items: unitOptions
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: onUnitChanged,
              ),
            ),
          ),
        ),
      ],
    );
  }

  String? _validateNumberRange(
    String? value, {
    required String label,
    required double min,
    required double max,
    required String unit,
    bool required = true,
  }) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return required ? '$label is required' : null;
    }

    final number = double.tryParse(text);
    if (number == null) {
      return 'Enter a valid $label';
    }
    if (number < min || number > max) {
      return '$label must be between $min and $max $unit';
    }
    return null;
  }

  String? _validateHeight(String? value) {
    if (_data.heightUnit == 'cm') {
      return _validateNumberRange(
        value,
        label: 'Height',
        min: 50,
        max: 260,
        unit: 'cm',
      );
    }

    return _validateNumberRange(
      value,
      label: 'Height',
      min: 3,
      max: 8.5,
      unit: 'ft',
    );
  }

  String? _validateWeight(
    String? value, {
    String label = 'Weight',
    bool required = true,
  }) {
    if (_data.weightUnit == 'kg') {
      return _validateNumberRange(
        value,
        label: label,
        min: 20,
        max: 300,
        unit: 'kg',
        required: required,
      );
    }

    return _validateNumberRange(
      value,
      label: label,
      min: 44,
      max: 660,
      unit: 'lbs',
      required: required,
    );
  }

  // ─────────────────────────────────────────────
  //  STEP 1: Basic Information
  // ─────────────────────────────────────────────
  Widget _buildStep1() {
    return _stepCard(
      step: 1,
      title: 'Basic Information',
      subtitle: 'About You',
      icon: Icons.person_outline_rounded,
      children: [
        _fieldLabel('Full Name'),
        _buildTextField(
          controller: _nameCtrl,
          hint: 'Enter your name',
          validator: (v) {
            final text = v?.trim() ?? '';
            if (text.isEmpty) return 'Name is required';
            if (text.length < 2) return 'Enter a valid name';
            return null;
          },
        ),
        _fieldSpacing(),

        _fieldLabel('Age'),
        _buildTextField(
          controller: _ageCtrl,
          hint: 'Enter your age',
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (v) {
            if (v == null || v.isEmpty) return 'Age is required';
            final age = int.tryParse(v);
            if (age == null || age < 10 || age > 100) return 'Age must be between 10 and 100';
            return null;
          },
        ),
        _fieldSpacing(),

        _fieldLabel('Gender'),
        _buildRadioGroup(
          value: _data.gender,
          options: const ['Male', 'Female', 'Prefer not to say'],
          onChanged: (v) => _data.gender = v,
        ),
        _fieldSpacing(),

        _fieldLabel('Height'),
        _buildNumberWithUnit(
          controller: _heightCtrl,
          hint: 'e.g. 175',
          unitValue: _data.heightUnit,
          unitOptions: const ['cm', 'ft/in'],
          onUnitChanged: (v) => setState(() => _data.heightUnit = v!),
          validator: _validateHeight,
        ),
        _fieldSpacing(),

        _fieldLabel('Weight'),
        _buildNumberWithUnit(
          controller: _weightCtrl,
          hint: 'e.g. 70',
          unitValue: _data.weightUnit,
          unitOptions: const ['kg', 'lbs'],
          onUnitChanged: (v) => setState(() => _data.weightUnit = v!),
          validator: (v) => _validateWeight(v),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  //  STEP 2: Goal & Activity
  // ─────────────────────────────────────────────
  Widget _buildStep2() {
    return _stepCard(
      step: 2,
      title: 'Goal & Activity',
      subtitle: 'Your Mission',
      icon: Icons.flag_outlined,
      children: [
        _fieldLabel('Primary Goal'),
        _buildRadioGroup(
          value: _data.primaryGoal,
          options: const ['Lose Weight', 'Gain Weight', 'Build Muscle', 'Maintain Weight'],
          onChanged: (v) => _data.primaryGoal = v,
          accentColor: AppColors.stepColors[1],
        ),
        _fieldSpacing(),

        _fieldLabel('Target Weight', required: false),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _targetWeightCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
                validator: (v) => _validateWeight(
                  v,
                  label: 'Target weight',
                  required: false,
                ),
                style: const TextStyle(color: AppColors.text, fontSize: 15),
                decoration: InputDecoration(
                  hintText: 'Optional target weight',
                  hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                  filled: true,
                  fillColor: AppColors.background,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  suffixText: _data.weightUnit,
                  suffixStyle: const TextStyle(color: AppColors.textSecondary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.stepColors[1], width: 1.5),
                  ),
                ),
              ),
            ),
          ],
        ),
        _fieldSpacing(),

        _fieldLabel('Time Goal'),
        _buildDropdown(
          value: _data.timeGoal,
          items: const ['1 month', '3 months', '6 months', 'Flexible'],
          onChanged: (v) => setState(() => _data.timeGoal = v!),
          accentColor: AppColors.stepColors[1],
        ),
        _fieldSpacing(),

        _fieldLabel('Activity Level'),
        _buildRadioGroup(
          value: _data.activityLevel,
          options: const ['Sedentary', 'Light', 'Moderate', 'Active', 'Athlete'],
          onChanged: (v) => _data.activityLevel = v,
          accentColor: AppColors.stepColors[1],
        ),
        _fieldSpacing(),

        _fieldLabel('Diet Strictness'),
        _buildRadioGroup(
          value: _data.dietStrictness,
          options: const ['Strict (fast results)', 'Moderate', 'Flexible'],
          onChanged: (v) => _data.dietStrictness = v,
          accentColor: AppColors.stepColors[1],
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  //  STEP 3: Diet & Eating Style
  // ─────────────────────────────────────────────
  Widget _buildStep3() {
    return _stepCard(
      step: 3,
      title: 'Diet & Eating Style',
      subtitle: 'Food Habits',
      icon: Icons.restaurant_outlined,
      children: [
        _fieldLabel('Diet Type'),
        _buildRadioGroup(
          value: _data.dietType,
          options: const ['Vegetarian', 'Non-Vegetarian', 'Vegan'],
          onChanged: (v) => _data.dietType = v,
          accentColor: AppColors.stepColors[2],
        ),
        _fieldSpacing(),

        _fieldLabel('Food Restrictions'),
        _buildCheckboxGroup(
          selected: _data.foodRestrictions,
          options: const ['Halal only', 'No beef', 'No pork', 'None'],
          onChanged: (v) => _data.foodRestrictions = v,
          accentColor: AppColors.stepColors[2],
        ),
        _fieldSpacing(),

        _fieldLabel('Meals Per Day'),
        _buildDropdown(
          value: _data.mealsPerDay,
          items: const ['2 meals', '3 meals', '4 meals', '5+ meals'],
          onChanged: (v) => setState(() => _data.mealsPerDay = v!),
          accentColor: AppColors.stepColors[2],
        ),
        _fieldSpacing(),

        _fieldLabel('Eating Style'),
        _buildRadioGroup(
          value: _data.eatingStyle,
          options: const ['Home Food', 'Mixed (Home + Outside)', 'Flexible'],
          onChanged: (v) => _data.eatingStyle = v,
          accentColor: AppColors.stepColors[2],
        ),
        _fieldSpacing(),

        _fieldLabel('Preferred Eating Window'),
        _buildRadioGroup(
          value: _data.eatingWindow,
          options: const ['Early eater', 'Balanced', 'Late eater'],
          onChanged: (v) => _data.eatingWindow = v,
          accentColor: AppColors.stepColors[2],
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  //  STEP 4: Behavior & Habits
  // ─────────────────────────────────────────────
  Widget _buildStep4() {
    return _stepCard(
      step: 4,
      title: 'Behavior & Habits',
      subtitle: 'Daily Life',
      icon: Icons.psychology_outlined,
      children: [
        _fieldLabel('Appetite Level'),
        _buildRadioGroup(
          value: _data.appetiteLevel,
          options: const ['Low appetite', 'Normal', 'High appetite'],
          onChanged: (v) => _data.appetiteLevel = v,
          accentColor: AppColors.stepColors[3],
        ),
        _fieldSpacing(),

        _fieldLabel('Junk Food Frequency'),
        _buildDropdown(
          value: _data.junkFoodFrequency,
          items: const ['Rare', 'Weekly', 'Daily'],
          onChanged: (v) => setState(() => _data.junkFoodFrequency = v!),
          accentColor: AppColors.stepColors[3],
        ),
        _fieldSpacing(),

        _fieldLabel('Daily Routine Type'),
        _buildRadioGroup(
          value: _data.dailyRoutineType,
          options: const ['Fixed routine', 'Flexible routine', 'Irregular routine'],
          onChanged: (v) => _data.dailyRoutineType = v,
          accentColor: AppColors.stepColors[3],
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  //  STEP 5: Health & Medical
  // ─────────────────────────────────────────────
  Widget _buildStep5() {
    return _stepCard(
      step: 5,
      title: 'Health & Medical',
      subtitle: 'Stay Safe',
      icon: Icons.favorite_outline_rounded,
      children: [
        _fieldLabel('Medical Conditions'),
        _buildCheckboxGroup(
          selected: _data.medicalConditions,
          options: const [
            'Diabetes',
            'High Blood Pressure',
            'Thyroid',
            'PCOS',
            'Heart Disease',
            'Kidney Issues',
            'None'
          ],
          onChanged: (v) => _data.medicalConditions = v,
          accentColor: AppColors.stepColors[4],
        ),
        _fieldSpacing(),

        _fieldLabel('Allergies', required: false),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _allergyInputCtrl,
                style: const TextStyle(color: AppColors.text, fontSize: 15),
                decoration: InputDecoration(
                  hintText: 'e.g. peanuts, dairy',
                  hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                  filled: true,
                  fillColor: AppColors.background,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.stepColors[4], width: 1.5),
                  ),
                ),
                onFieldSubmitted: (_) => _addAllergyChip(),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: _addAllergyChip,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.stepColors[4].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.stepColors[4].withOpacity(0.3)),
                ),
                child: Icon(Icons.add_rounded, color: AppColors.stepColors[4]),
              ),
            ),
          ],
        ),
        if (_allergyChips.isNotEmpty) ...[
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _allergyChips.map((chip) {
              return Chip(
                label: Text(chip,
                    style: TextStyle(
                        color: AppColors.stepColors[4], fontSize: 13)),
                deleteIcon: const Icon(Icons.close, size: 16),
                onDeleted: () => setState(() => _allergyChips.remove(chip)),
                backgroundColor: AppColors.stepColors[4].withOpacity(0.1),
                deleteIconColor: AppColors.stepColors[4],
                side: BorderSide(color: AppColors.stepColors[4].withOpacity(0.3)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                labelStyle: TextStyle(color: AppColors.stepColors[4]),
                padding: const EdgeInsets.symmetric(horizontal: 4),
              );
            }).toList(),
          ),
        ],
        _fieldSpacing(),

        _fieldLabel('Medications', required: false),
        _buildTextField(
          controller: _medicationsCtrl,
          hint: 'List any medications you take...',
          maxLines: 3,
        ),
      ],
    );
  }

  void _addAllergyChip() {
    final text = _allergyInputCtrl.text.trim();
    if (text.isNotEmpty && !_allergyChips.contains(text)) {
      setState(() {
        _allergyChips.add(text);
        _allergyInputCtrl.clear();
      });
    }
  }

  void _commitPendingAllergy() {
    final text = _allergyInputCtrl.text.trim();
    if (text.isNotEmpty && !_allergyChips.contains(text)) {
      _allergyChips.add(text);
      _allergyInputCtrl.clear();
    }
  }

  // ─────────────────────────────────────────────
  //  STEP 6: Future Tracking
  // ─────────────────────────────────────────────
  Widget _buildStep6() {
    return _stepCard(
      step: 6,
      title: 'Future Tracking',
      subtitle: 'Check-ins',
      icon: Icons.track_changes_outlined,
      children: [
        _fieldLabel('Will you track your weight weekly?'),
        _buildRadioGroup(
          value: _data.trackWeekly,
          options: const ['Yes', 'No'],
          onChanged: (v) => _data.trackWeekly = v,
          accentColor: AppColors.stepColors[5],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.stepColors[5].withOpacity(0.06),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.stepColors[5].withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Icon(Icons.lightbulb_outline_rounded,
                  color: AppColors.stepColors[5], size: 18),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Tracking weekly helps us adjust your plan for better results.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  Data Preview Screen (destination)
// ─────────────────────────────────────────────
class DataPreviewScreen extends StatelessWidget {
  final UserProfileData data;
  const DataPreviewScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final map = data.toMap();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profile Summary',
            style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.text)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.text),
        surfaceTintColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: map.entries.map((e) {
                final val = e.value;
                final display = val is List ? val.join(', ') : val?.toString() ?? '-';
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 140,
                        child: Text(
                          e.key,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          display.isEmpty ? '-' : display,
                          style: const TextStyle(
                            color: AppColors.text,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
