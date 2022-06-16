class UserModel {
  int? id;
  String? name;
  String? email;
  String? password;
  String? avatar;
  String? cell;
  String? googleUid;
  String? base64;
  String? fileName;

  toJson() {
    return {
      //'id': id.toString(),
      'name': name.toString(),
      'cell': cell.toString(),
      'email': email.toString(),
      //'base64': base64 == null ? null.toString() : base64.toString(),
      //'fileName': fileName.toString(),
      'password': password.toString(),
      //'avatar': avatar.toString(),
      //'google_uid': googleUid.toString(),
    };
  }
}
