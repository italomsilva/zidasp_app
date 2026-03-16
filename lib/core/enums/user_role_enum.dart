enum UserRoleEnum {
  admin('admin'),
  employee('employee');

  final String value;
  const UserRoleEnum(this.value);

  factory UserRoleEnum.fromString(String role) {
    return UserRoleEnum.values.firstWhere(
      (e) => e.value == role,
      orElse: () => UserRoleEnum.employee,
    );
  }
}
