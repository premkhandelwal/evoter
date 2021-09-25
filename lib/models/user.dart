import 'dart:convert';

class CurrentUser {
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

  CurrentUser(
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
      'LastName':lastName,
      'MiddleName':middleName,
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

  static List<CurrentUser> fromList(List<dynamic> userList) {
    List<CurrentUser> retuserList = [];
    userList.forEach((map) {
      retuserList.add(CurrentUser.fromMap(map));
    });
    return retuserList;
  }

  factory CurrentUser.fromMap(Map<String, dynamic> map) {
    return CurrentUser(
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
        imageAsString: map["userImageString"],
        password: map['password']
        //isDeleted: map['isDeleted'],
        );
  }

  String toJson() => json.encode(toMap());

  static List<CurrentUser> fromJson(String source) =>
      CurrentUser.fromList(json.decode(source));

  @override
  String toString() {
    return 'User(code: $code, name: $firstName, mobileNo: $mobileNo, dob: $dob, address: $address, isAdmin: $isAdmin, isDeleted: $isDeleted)';
  }
}
