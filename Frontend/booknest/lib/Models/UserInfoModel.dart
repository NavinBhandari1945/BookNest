class UserInfosModel {
  final int? userId;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phoneNumber;
  final String? password;
  final String? role;

  UserInfosModel({
    this.userId,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.password,
    this.role,
  });

  factory UserInfosModel.fromJson(Map<String, dynamic> json) {
    return UserInfosModel(
      userId: json['userId'] as int?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      password: json['password'] as String?,
      role: json['role'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'password': password,
      'role': role,
    };
  }

  UserInfosModel copyWith({
    int? userId,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? password,
    String? role,
  }) {
    return UserInfosModel(
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      role: role ?? this.role,
    );
  }
}
