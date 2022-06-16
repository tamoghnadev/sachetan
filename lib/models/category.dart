class Category {
  int? id;
  String? name;
  int? tickets;

  toJson() {
    return {'id': id.toString(), 'name': name.toString()};
  }
}
