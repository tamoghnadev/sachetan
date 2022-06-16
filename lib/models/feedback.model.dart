class FeedbackModel {
  String? name;
  String? email;
  String? mob;
  String? mssg;


  toJson() {
    return {
      'name': name.toString(),
      'email': email.toString(),
      'mobile': mob.toString(),
      'message': mssg.toString(),

    };
  }
}
