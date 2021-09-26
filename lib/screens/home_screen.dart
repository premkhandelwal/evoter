import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:evoter/logic/bloc/user_bloc.dart';
import 'package:evoter/models/user.dart';
import 'package:evoter/screens/addUpdate_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

enum SearchBy { NAME, MOBILENO }
TextEditingController searchController = new TextEditingController();
SearchBy _val = SearchBy.NAME;
List<CurrentUser?> usersList = [];
List<CurrentUser?> filteredList = [];

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

  // ImageSource imageSource;
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        // if the internet connection is available or not etc..
        await Future.delayed(
          Duration(seconds: 2),
        );
        context.read<UserBloc>().add(UserLoaded());
      },
      child: Scaffold(
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
              } else if (state is UsersLoadSuccess && state.users.isNotEmpty) {
                print(state.users);
                usersList = List.from(state.users);
                filteredList = List.from(usersList);

                return ChildWidget();
              } else if (state is UserOperationFailure) {
                return Center(
                  child: Text("Failed to load users"),
                );
              }
              return Center(
                child: Text(
                  "No users found",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

ScrollController controller = ScrollController();

class BuildGridView extends StatefulWidget {
  const BuildGridView({Key? key}) : super(key: key);

  @override
  _BuildGridViewState createState() => _BuildGridViewState();
}

class _BuildGridViewState extends State<BuildGridView> {
  @override
  Widget build(BuildContext context) {
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
                childAspectRatio: 1.4,
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
}

Widget buildContent(int index) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      buildRichText("Name: ",
          "${usersList[index]?.firstName} ${usersList[index]?.middleName} ${usersList[index]?.lastName} "),
      SizedBox(height: 20),
      buildRichText("Mobile No: ", "${usersList[index]?.mobileNo}"),
      SizedBox(height: 20),
      buildRichText("Date of Birth: ", "${usersList[index]?.dob}"),
      SizedBox(height: 20),
      buildRichText("Gender: ", "${usersList[index]?.gender}"),
      SizedBox(height: 20),
      buildRichText("Address: ", "${usersList[index]?.address}"),
      SizedBox(height: 20),
      usersList[index]?.partNo != null
          ? buildRichText("Part No: ", "${usersList[index]?.partNo}")
          : Text("-"),
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
              color: Colors.black, fontSize: 17, fontWeight: FontWeight.normal),
        )
      ],
    ),
  );
}

class ChildWidget extends StatefulWidget {
  const ChildWidget({Key? key}) : super(key: key);

  @override
  _ChildWidgetState createState() => _ChildWidgetState();
}

class _ChildWidgetState extends State<ChildWidget> {
  @override
  Widget build(BuildContext context) {
    void Function(String)? onChanged(val) {
      if (val == "") {
        usersList = List.from(filteredList);
      }
      setState(() {
        usersList = usersList.where((user) {
          print(val);
          print(user!.mobileNo);
          if(_val == SearchBy.MOBILENO){

          return user.mobileNo!.startsWith(val);
          }
          return user.firstName!.startsWith(val);
        }).toList();
        print(filteredList.length);
        print(usersList.length);
      });
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
              height: 70,
              child: Card(
                child: new ListTile(
                    leading: new Icon(Icons.search),
                    title: new TextField(
                        controller: searchController,
                        decoration: new InputDecoration(
                            suffixIcon: IconButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertWidget());
                                },
                                icon: Icon(Icons.menu)),
                            hintText: _val == SearchBy.MOBILENO
                                ? 'Search by Mobile No'
                                : 'Search by Name',
                            border: InputBorder.none),
                        onChanged: onChanged)),
              )),
          BuildGridView()
        ],
      ),
    );
  }
}

class AlertWidget extends StatefulWidget {
  const AlertWidget({Key? key}) : super(key: key);

  @override
  _AlertWidgetState createState() => _AlertWidgetState();
}

class _AlertWidgetState extends State<AlertWidget> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Ok"))
      ],
      title: Text("Filter By"),
      content: Container(
        height: 150,
        child: Column(
          children: [
            Row(
              children: [
                Text("Name"),
                Flexible(
                    child: RadioListTile<SearchBy>(
                        value: SearchBy.NAME,
                        groupValue: _val,
                        onChanged: (val) {
                          setState(() {
                            _val = val!;
                          });
                        }))
              ],
            ),
            Row(
              children: [
                Text("Mobile Number"),
                Flexible(
                    child: RadioListTile<SearchBy>(
                        value: SearchBy.MOBILENO,
                        groupValue: _val,
                        onChanged: (val) {
                          setState(() {
                            _val = val!;
                          });
                        }))
              ],
            ),
          ],
        ),
      ), /*  */
    );
  }
}
