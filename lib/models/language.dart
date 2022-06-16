class Language {
  int? id;
  int? languageId;
  String? languageName;
  String? image;
  bool? isDefault;
  int? memberId;
  String? languageCode;

  toJson() {
    return {
      'langaugeid': this.languageId.toString(),
      'member_id': this.memberId.toString(),
    };
  }
}
