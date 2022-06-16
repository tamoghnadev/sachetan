class ProfileModel {
  String? name;
  String? email;
  int? id;
  String? password;
  String? base64;
  String? fileName;

  toJson() {
    return {
      'id': id.toString(),
      'name': name.toString(),
      'email': email.toString(),
      'base64': base64 == null ? null.toString() : base64.toString(),
      'fileName': fileName.toString(),
      'password': password.toString(),

    };
  }
}
