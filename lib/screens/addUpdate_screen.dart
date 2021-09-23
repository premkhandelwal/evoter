import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:evoter/logic/bloc/user_bloc.dart';
import 'package:evoter/models/user.dart';
import 'package:evoter/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddUpdateScreen extends StatefulWidget {
  final bool isUpdate;
  final User? users;
  const AddUpdateScreen({
    Key? key,
    this.isUpdate = false,
    this.users,
  }) : super(key: key);

  @override
  _AddUpdateScreenState createState() => _AddUpdateScreenState();
}

class _AddUpdateScreenState extends State<AddUpdateScreen> {
  TextEditingController userName = new TextEditingController();
  TextEditingController userAddress = new TextEditingController();
  TextEditingController userMobileNo = new TextEditingController();
  TextEditingController dateofBirthController = new TextEditingController();
  DateTime? dateofBirth;
  String? gender;
  List<String> genders = ["Select Gender", "Male", "Female"];
  @override
  void initState() {
    genders = ["Male", "Female"];
    if (widget.isUpdate) {
      if (widget.users != null) {
        if (widget.users!.name != null) {
          userName.text = widget.users!.name!;
        }
        if (widget.users!.dob != null) {
          dateofBirthController.text = widget.users!.dob!;
          String year = dateofBirthController.text.toString().split("-")[0];
          String month = dateofBirthController.text.toString().split("-")[1];
          String date = dateofBirthController.text.toString().split("-")[2];

          dateofBirth = DateTime.parse(widget.users!.dob!);
        }
        if (widget.users!.address != null) {
          userAddress.text = widget.users!.address!;
        }
        if (widget.users!.gender != null) {
          gender = widget.users!.gender;
        }
        if (widget.users!.mobileNo != null) {
          userMobileNo.text = widget.users!.mobileNo!;
        }
      }
    } else {
      dateofBirth = DateTime.now();
      // gender = "Select Gender";

    }
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
        title: Text(
          widget.isUpdate ? "Update User" : "Add New User",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Form(
        key: _formKey,
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserOperationSuccess) {
              SchedulerBinding.instance!.addPostFrameCallback((_) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Message"),
                    content: widget.isUpdate
                        ? Text(
                            "Updated Successfully",
                          )
                        : Text(
                            "Added Successfully",
                          ),
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(),
                              ),
                              (route) => false,
                            );
                          },
                          child: Text("Ok"))
                    ],
                  ),
                );
              });
            } else if (state is UserOperationInProgress) {
              return Center(child: CircularProgressIndicator());
            }
            return Container(
              padding: EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    TextFormField(
                      validator: (val) {
                        if (val == "") {
                          return "This is a required field";
                        }
                        return null;
                      },
                      style: TextStyle(fontSize: 20, color: Colors.black),
                      controller: userName,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Name of User",
                          labelStyle:
                              TextStyle(fontSize: 20, color: Colors.black54,fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    DateTimeField(
                      validator: (val) {
                        if (val == null) {
                          return "This is a required field";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Date of Birth",
                        labelStyle: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      controller: dateofBirthController,
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      format: DateFormat(),
                      onChanged: (selectedDate) {
                        dateofBirth = selectedDate;
                        dateofBirthController.text =
                            DateFormat("dd/MM/yyyy").format(selectedDate!);
                      },
                      initialValue: dateofBirth,
                      onShowPicker: (context, currentValue) async {
                        final time = showDatePicker(
                          firstDate: DateTime(1500),
                          lastDate: DateTime(3000),
                          initialDate: DateTime.now(),
                          helpText: "Select Date",
                          fieldLabelText: "Select Date",
                          context: context,
                        );

                        return time;
                      },
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    DropdownButtonFormField(
                      validator: (val) {
                        if (val == null) {
                          return "This is a required field";
                        }
                        return null;
                      },
                      decoration: InputDecoration(border: OutlineInputBorder()),
                      hint: gender == null
                          ? Text('Select Gender')
                          : Text(
                              gender!,
                              style: TextStyle(fontSize: 20),
                            ),
                      isExpanded: true,
                      iconSize: 30.0,
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      value: gender,
                      items: genders.map(
                        (val) {
                          return DropdownMenuItem<String>(
                            value: val,
                            child: Text(
                              val,
                              style: TextStyle(color: Colors.black),
                            ),
                          );
                        },
                      ).toList(),
                      onChanged: (String? val) {
                        setState(
                          () {
                            gender = val;
                          },
                        );
                      },
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      validator: (val) {
                        if (val == "") {
                          return "This is a required field";
                        }
                        return null;
                      },
                      style: TextStyle(fontSize: 20, color: Colors.black),
                      controller: userAddress,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Address of User",
                          labelStyle: TextStyle(
                              fontSize: 20,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      validator: (val) {
                        if (val == "") {
                          return "This is a required field";
                        }
                        return null;
                      },
                      style: TextStyle(fontSize: 20, color: Colors.black),
                      controller: userMobileNo,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Mobile Number of User",
                          labelStyle: TextStyle(
                              fontSize: 20,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.red),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) callOperation();
                      },
                      child: Text("Submit"),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> callOperation() async {
    context.read<UserBloc>().add(widget.isUpdate
        ? UserUpdated(
            user: User(
                code: widget.users!.code,
                address: widget.users!.address,
                dob: dateofBirthController.text,
                mobileNo: userMobileNo.text,
                gender: gender,
                name: userName.text),
          )
        : UserAdded(
            user: User(
                code: "",
                imageAsString: "",
                isDeleted: false,
                isAdmin: true,
                address: userAddress.text,
                dob: dateofBirthController.text,
                mobileNo: userMobileNo.text,
                gender: gender,
                name: userName.text),
          ));
  }
}
