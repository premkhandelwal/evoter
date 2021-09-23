import 'dart:convert';

class User {
  String? code;
  String? name;
  String? mobileNo;
  String? dob;
  String? address;
  bool isAdmin;
  bool isDeleted;
  String? imageAsString;
  String? gender;

  User(
      {this.code,
      this.name,
      this.mobileNo,
      this.dob,
      this.address,
      this.gender,
      this.isAdmin = false,
      this.isDeleted = false,
      this.imageAsString});

  

  Map<String, dynamic> toMap() {
    return {
      'Name': name,
      'MobileNo': mobileNo,
      'DOB': dob,
      'Address': address,
      'Gender': gender,
      'IsAdmin': isAdmin,
      'IsDeleted': isDeleted,
      'Code':code
    };
  }

  static List<User> fromList(List<dynamic> userList) {
    List<User> retuserList = [];
    userList.forEach((map) {
      retuserList.add(User.fromMap(map));
    });
    return retuserList;
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      code: map['code'],
      name: map['name'],
      gender: map['gender'],
      mobileNo: map['mobileNo'].toString(),
      dob: map['dob'].toString().split("T")[0],
      address: map['address'],
      isAdmin: map['isAdmin'],
      imageAsString:  map["userImageString"]
      //isDeleted: map['isDeleted'],
    );
  }

  String toJson() => json.encode(toMap());

  static List<User> fromJson(String source) =>
      User.fromList(json.decode(source));

  @override
  String toString() {
    return 'User(code: $code, name: $name, mobileNo: $mobileNo, dob: $dob, address: $address, isAdmin: $isAdmin, isDeleted: $isDeleted)';
  }
}
