class Employee {
  int? id;
  String? name;
  String? email;
  String? cell;
  String? address;
  String? avatar;
  String? jod;
  String? jd;
  String? category;
  int? categoryId;
  String? userId;

  toJson() {
    return {
      'id': id.toString(),
      'name': name.toString(),
      'email': email.toString(),
      'cell': cell.toString(),
      'address': address.toString(),
      'avatar': avatar.toString(),
      'jd': jd.toString(),
      'jod': jod.toString(),
      'category_id': categoryId.toString(),
      'userId': userId.toString(),
    };
  }
}
