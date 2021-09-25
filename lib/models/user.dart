import 'dart:convert';

class User {
  String? code;
  String? firstName;
  String? lastName;
  String? middleName = "";
  String? partNo = "";
  String? mobileNo;
  String? dob;
  String? address;
  bool isAdmin;
  bool isDeleted;
  String? imageAsString;
  String? gender = "";
  String? addedBy = "";
  String? password = "";

  User(
      {this.code,
      this.firstName,
      this.lastName,
      this.middleName,
      this.partNo,
      this.mobileNo,
      this.dob,
      this.address,
      this.gender,
      this.addedBy,
      this.password,
      this.isAdmin = false,
      this.isDeleted = false,
      this.imageAsString});

  Map<String, dynamic> toMap() {
    return {
      'FirstName': firstName,
      'LastName': lastName,
      'MiddleName': middleName,
      'PartNo': partNo,
      'MobileNo': mobileNo,
      'DOB': dob,
      'Address': address,
      'Gender': gender,
      'IsAdmin': isAdmin,
      'IsDeleted': isDeleted,
      'AddedBy':addedBy,
      'Password': password,
      'Code': code


      
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
        firstName: map['firstName'],
        lastName: map['lastName'],
        middleName: map['middleName'],
        partNo: map['partNo'],
        gender: map['gender'],
        mobileNo: map['mobileNo'].toString(),
        dob: map['dob'].toString().split("T")[0],
        address: map['address'],
        isAdmin: map['isAdmin'],
        addedBy: map['addedBy'],
        imageAsString: map["userImageString"]
        //isDeleted: map['isDeleted'],
        );
  }

  String toJson() => json.encode(toMap());

  static List<User> fromJson(String source) =>
      User.fromList(json.decode(source));

  @override
  String toString() {
    return 'User(code: $code, name: $firstName, mobileNo: $mobileNo, dob: $dob, address: $address, isAdmin: $isAdmin, isDeleted: $isDeleted)';
  }
}
