class UserModel {
  late  String name;
  late String email;
  late  String password;
  late String profile;
  late String birthday;
  late String bio;
  late String theDateOfJoin;
  late String code;
  late bool isDisabled;
  late int maximumSizeOfImagesInGB;
  late double totalSizeOfImagesUsed;

  UserModel(
      {
      required this.password,
      required this.email,
      required this.name,
      required this.profile,
      required this.bio,
        required this.birthday,
        required this.theDateOfJoin,
        required this.maximumSizeOfImagesInGB,
        required this.totalSizeOfImagesUsed,
        required this.code,
        required this.isDisabled,
      });

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    email = json['Email'];
    bio = json['Bio'];
    password = json['Password'];
    profile = json['Profile'];
    birthday = json['Birthday'];
    theDateOfJoin = json['The date of join'];
    code = json['Code'];
    maximumSizeOfImagesInGB = json['Maximum size of images in GB'];
    totalSizeOfImagesUsed = json['Total size of images used'];
    isDisabled = json['Is Disabled'];
  }

  Map<String, dynamic> toMap() {
    return {
      'Name': name,
      'Profile': profile,
      'Bio': bio,
      'Password': password,
      'Email': email,
      'Birthday': birthday,
      'The date of join': theDateOfJoin,
      'Code': code,
      'Maximum size of images in GB': maximumSizeOfImagesInGB,
      'Total size of images used': totalSizeOfImagesUsed,
      'Is Disabled': isDisabled ,
    };
  }
}
