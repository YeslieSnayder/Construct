class Organization {
  String name;
  String email;
  String number;
  String imgProfile;
  int yearOfFoundation;

  static const String NAME = 'name';
  static const String EMAIL = 'email';
  static const String NUMBER = 'number';
  static const String IMAGE = 'imgProfile';
  static const String YEAR_FOUNDATION = 'yearOfFoundation';

  Organization.fromFirestore(Map<String, dynamic> map) {
    this.name = map[NAME];
    this.email = map[EMAIL];
    this.number = map[NUMBER];
    this.imgProfile = map[IMAGE];
    this.yearOfFoundation = map[YEAR_FOUNDATION];
  }
}
