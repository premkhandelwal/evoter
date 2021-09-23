import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:evoter/logic/bloc/user_bloc.dart';
import 'package:evoter/models/user.dart';
import 'package:evoter/screens/addUpdate_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /* ImagePicker imagePicker = ImagePicker();

  File file = File(getTemporaryDirectory().toString());
  Future<String> pickImageFromGallery() async {
    String retString = "";
    await imagePicker.pickImage(source: ImageSource.gallery).then((imgFile) {
      setState(() {
        file = File(imgFile!.path);
      });

      Uint8List imgString = file.readAsBytesSync();
      print(imgString);
      retString = imgString.toString();
    });
    return retString;
  } */
  List<User?> usersList = [];

  // ImageSource imageSource;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AddUpdateScreen(),
          ));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      body: SafeArea(
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            print(state);
            if (state is UserOperationSuccess || state is UserDeleted) {
              context.read<UserBloc>().add(UserLoaded());
              return Center(child: CircularProgressIndicator());
            } else if (state is UsersLoadInProgress) {
              return Center(child: CircularProgressIndicator());
            }  else if (state is UsersLoadSuccess && state.users.isNotEmpty) {
              print(state.users);
              usersList = List.from(state.users);
              return buildGridView();
            }else if (state is UserOperationFailure) {
              return Center(
                child: Text("Failed to load users"),
              );
            }
            return Center(
              child: Text("No users found",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
            );
          },
        ),
      ),
    );
  }

  ScrollController controller = ScrollController();

  Widget buildGridView() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        controller: controller,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              controller: controller,
              padding: EdgeInsets.all(10),
              scrollDirection: Axis.vertical,
              itemCount: usersList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 1.6,
                mainAxisSpacing: 20,
              ),
              itemBuilder: (context, index) {
                return Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    print(direction);
                    context
                        .read<UserBloc>()
                        .add(UserDeleted(userCode: usersList[index]!.code!));
                  },
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddUpdateScreen(
                            isUpdate: true,
                            users: usersList[index],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 5.0,
                            spreadRadius: 3.0,
                          )
                        ],
                      ),
                      child: buildContent(index),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildContent(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildRichText("Name: ", "${usersList[index]?.name}"),
        SizedBox(height: 20),
        buildRichText("Mobile No: ", "${usersList[index]?.mobileNo}"),
        SizedBox(height: 20),
        buildRichText("Date of Birth: ", "${usersList[index]?.dob}"),
        SizedBox(height: 20),
        buildRichText("Gender: ", "${usersList[index]?.gender}"),
        SizedBox(height: 20),
        buildRichText("Address: ", "${usersList[index]?.address}"),
      ],
    );
  }

  Widget image(String? thumbnail) {
    print(thumbnail.runtimeType);

    List<int> ab = List<int>.from(json.decode(thumbnail!));
    /*    final _byteImage = base64Decode(thumbnail);
    print(_byteImage.toString()); */
    Uint8List list1 = Uint8List.fromList(ab);

    Widget image = Image.memory(list1);
    return image;
  }

  RichText buildRichText(String? key, String? value) {
    return RichText(
      textAlign: TextAlign.left,
      text: TextSpan(
        text: "$key",
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: "$value",
            style: TextStyle(
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.normal),
          )
        ],
      ),
    );
  }
}
