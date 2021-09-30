import 'package:evoter/logic/bloc/user_bloc.dart';
import 'package:evoter/models/sharedObjects.dart';
import 'package:evoter/screens/home_screen.dart';
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
  TextEditingController mobileNo = new TextEditingController();
  TextEditingController password = new TextEditingController();
  // bool obscure = true;

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
                        controller: mobileNo,
                        decoration: InputDecoration(
                            hintStyle: TextStyle(
                              color: Colors.white70,
                            ),
                            // filled: true,
                            // fillColor: Colors.grey[200],
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            errorBorder: InputBorder.none,
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            hintText: "Mobile Number",
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey))),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      TextFormField(
                          obscureText: true,

                        controller: password,
                        decoration: InputDecoration(
                          /* suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      obscure = !obscure;
                                    });
                                  },
                                  child: obscure
                                      ? Icon(
                                          Icons.visibility_off,
                                          color: Colors.grey,
                                          size: 25,
                                        )
                                      : Icon(
                                          Icons.visibility,
                                          color: Colors.grey,
                                          size: 25,
                                        )), */

                            hintStyle: TextStyle(
                              color: Colors.white70,
                            ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            errorBorder: InputBorder.none,
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            hintText: "Password",
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
                      BlocConsumer<UserBloc, UserState>(
                        listener: (context, state) {
                          if (state is UserLoggedIn) {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomeScreen(),
                                ),
                                (route) => false);
                          } else if (state is UserLogInFailure) {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(ctx);
                                      },
                                      child: Text("Ok"))
                                ],
                                content: Text("Invalid credentials!"),
                                title: Text("Error"),
                              ),
                            );
                          }
                        },
                        builder: (context, state) {
                          if (state is UserLoggingIn) {
                            return CircularProgressIndicator();
                          }
                          return Align(
                            alignment: Alignment.center,
                            child: ElevatedButton(
                                onPressed: () {
                                  context.read<UserBloc>().add(SignInRequested(
                                      mobileNo: mobileNo.text,
                                      password: password.text));
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
                          );
                        },
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
