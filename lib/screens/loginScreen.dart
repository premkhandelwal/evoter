import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:tech_teacher/logic/bloc/firebaseauth_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late TabController tabController;
  TextEditingController emailid = new TextEditingController();
  TextEditingController password = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 180,
            ),
            Text(
              "Login",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                  color: Colors.white),
            ),
            SizedBox(
              height: 30,
            ),
            // give the tab bar a height [can change hheight to preferred height]
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Container(
                height: 320,
                // decoration:
                //     BoxDecoration(border: Border.all(color: Colors.grey)),
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                      // color: Colors.grey[300],
                      ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        controller: emailid,
                        decoration: InputDecoration(
                            hintStyle: TextStyle(
                              color: Colors.white70,
                            ),
                            // filled: true,
                            // fillColor: Colors.grey[200],
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            errorBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: "Registered Email",
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey))),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      TextFormField(
                        controller: password,
                        decoration: InputDecoration(
                            hintStyle: TextStyle(
                              color: Colors.white70,
                            ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            errorBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: "Registered Password",
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey))),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 70,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                            onPressed: () {
                              // context.read<FirebaseauthBloc>().add(SignInRequested(emailId: emailid.text,password: password.text));
                            },
                            child: Text(
                              "Sign In",
                            ),
                            style: ButtonStyle(
                              fixedSize:
                                  MaterialStateProperty.all(Size(200, 50)),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.green),
                            )),
                      )
                    ],
                  ),
                ),
              ),
            ),

            // tab bar view here
          ],
        ),
      ),
    );
  }
}
