class Officers {
  int? id;
  String? name;


  toJson() {
    return {'id': id.toString(), 'name': name.toString()};
  }
}
