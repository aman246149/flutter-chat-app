class UserModel {
  String? name;
  String? email;
  String? sub;
  String? sId;
  int? iV;

  UserModel({this.name, this.email, this.sub, this.sId, this.iV});

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    sub = json['sub'];
    sId = json['_id'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = name;
    data['email'] = email;
    data['sub'] = sub;
    data['_id'] = sId;
    data['__v'] = iV;
    return data;
  }
}
