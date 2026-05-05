class UserProfileData {
  String fullName;
  int? age;
  String gender;
  double? heightValue;
  String heightUnit;
  double? weightValue;
  String weightUnit;
  String primaryGoal;
  double? targetWeight;
  String timeGoal;
  String activityLevel;
  String dietStrictness;
  String dietType;
  List<String> foodRestrictions;
  String mealsPerDay;
  String eatingStyle;
  String eatingWindow;
  String appetiteLevel;
  String junkFoodFrequency;
  String dailyRoutineType;
  List<String> medicalConditions;
  String allergies;
  String medications;
  String trackWeekly;

  UserProfileData({
    this.fullName = '',
    this.age,
    this.gender = '',
    this.heightValue,
    this.heightUnit = 'cm',
    this.weightValue,
    this.weightUnit = 'kg',
    this.primaryGoal = '',
    this.targetWeight,
    this.timeGoal = '3 months',
    this.activityLevel = '',
    this.dietStrictness = '',
    this.dietType = '',
    List<String>? foodRestrictions,
    this.mealsPerDay = '3 meals',
    this.eatingStyle = '',
    this.eatingWindow = '',
    this.appetiteLevel = '',
    this.junkFoodFrequency = 'Weekly',
    this.dailyRoutineType = '',
    List<String>? medicalConditions,
    this.allergies = '',
    this.medications = '',
    this.trackWeekly = '',
  })  : foodRestrictions = foodRestrictions ?? [],
        medicalConditions = medicalConditions ?? [];

  factory UserProfileData.fromMap(Map<String, dynamic> map) {
    return UserProfileData(
      fullName: _readString(map['fullName']),
      age: _readInt(map['age']),
      gender: _readString(map['gender']),
      heightValue: _readDouble(map['heightValue']),
      heightUnit: _readString(map['heightUnit'], fallback: 'cm'),
      weightValue: _readDouble(map['weightValue']),
      weightUnit: _readString(map['weightUnit'], fallback: 'kg'),
      primaryGoal: _readString(map['primaryGoal']),
      targetWeight: _readDouble(map['targetWeight']),
      timeGoal: _readString(map['timeGoal'], fallback: '3 months'),
      activityLevel: _readString(map['activityLevel']),
      dietStrictness: _readString(map['dietStrictness']),
      dietType: _readString(map['dietType']),
      foodRestrictions: _readStringList(map['foodRestrictions']),
      mealsPerDay: _readString(map['mealsPerDay'], fallback: '3 meals'),
      eatingStyle: _readString(map['eatingStyle']),
      eatingWindow: _readString(map['eatingWindow']),
      appetiteLevel: _readString(map['appetiteLevel']),
      junkFoodFrequency: _readString(
        map['junkFoodFrequency'],
        fallback: 'Weekly',
      ),
      dailyRoutineType: _readString(map['dailyRoutineType']),
      medicalConditions: _readStringList(map['medicalConditions']),
      allergies: _readString(map['allergies']),
      medications: _readString(map['medications']),
      trackWeekly: _readString(map['trackWeekly']),
    );
  }

  Map<String, dynamic> toMap() => {
        'fullName': fullName,
        'age': age,
        'gender': gender,
        'heightValue': heightValue,
        'heightUnit': heightUnit,
        'weightValue': weightValue,
        'weightUnit': weightUnit,
        'primaryGoal': primaryGoal,
        'targetWeight': targetWeight,
        'timeGoal': timeGoal,
        'activityLevel': activityLevel,
        'dietStrictness': dietStrictness,
        'dietType': dietType,
        'foodRestrictions': foodRestrictions,
        'mealsPerDay': mealsPerDay,
        'eatingStyle': eatingStyle,
        'eatingWindow': eatingWindow,
        'appetiteLevel': appetiteLevel,
        'junkFoodFrequency': junkFoodFrequency,
        'dailyRoutineType': dailyRoutineType,
        'medicalConditions': medicalConditions,
        'allergies': allergies,
        'medications': medications,
        'trackWeekly': trackWeekly,
      };

  static String _readString(dynamic value, {String fallback = ''}) {
    final text = value?.toString().trim();
    return text == null || text.isEmpty ? fallback : text;
  }

  static int? _readInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '');
  }

  static double? _readDouble(dynamic value) {
    if (value is double) return value;
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '');
  }

  static List<String> _readStringList(dynamic value) {
    if (value is List) {
      return value
          .map((item) => item.toString().trim())
          .where((item) => item.isNotEmpty)
          .toList();
    }
    return [];
  }
}
