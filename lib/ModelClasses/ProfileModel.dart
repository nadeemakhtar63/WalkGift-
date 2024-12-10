class UserModel {
  String? name;
  String? profileImage;
  String? email;
  String? uid;
  double? points;
  String? address;
  String?phoneNumber;
  int? myOrders;

  UserModel({
    this.phoneNumber,
    this.name,
    this.profileImage,
    this.email,
    this.uid,
    this.points,
    this.address,
    this.myOrders,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      phoneNumber:data['phoneNumber'],
      name: data['name'],
      profileImage: data['userimage'],
      email: data['email'],
      uid: data['uid'],
      points: (data['points'] as num?)?.toDouble(),
      address: data['address'],
      myOrders: data['myorders'],
    );
  }
}