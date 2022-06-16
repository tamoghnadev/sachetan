class Settings {
  int? id;
  String? name;
  String? email;
  int? passwordSetOrRemove;
  String? password;
  int? userId;
  String? avatar;
  String? localToken;
  String? language;
  int? fontSize;
  String? fontColor;
  String? backgroundColor;
  String? createdAt;
  String? type;

  fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.language = map['language'];
    this.userId = map['userId'];
    this.type = map['type'];
    this.name = map['name'];
    this.email = map['email'];
    this.passwordSetOrRemove = map['passwordSetOrRemove'];
    this.password = map['password'];
    this.avatar = map['avatar'];
    this.localToken = map['localToken'];
    this.fontColor = map['fontColor'];
    this.fontSize = map['fontSize'];
    this.backgroundColor = map['backgroundColor'];
    this.createdAt = map['createdAt'];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map['id'] = this.id;
    map['language'] = this.language;
    map['email'] = this.email;
    map['name'] = this.name;
    map['userId'] = this.userId;
    map['type'] = this.type;
    map['passwordSetOrRemove'] = this.passwordSetOrRemove;
    map['password'] = this.password;
    map['avatar'] = this.avatar;
    map['localToken'] = this.localToken;
    map['fontColor'] = this.fontColor;
    map['fontSize'] = this.fontSize;
    map['backgroundColor'] = this.backgroundColor;
    map['createdAt'] = this.createdAt;
    return map;
  }

  void setSettingsId(int? id) {
    this.id = id;
  }
}
