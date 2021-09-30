import 'dart:convert';
import 'dart:typed_data';
import 'package:evoter/screens/loginScreen.dart';
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

enum SearchBy { NAME, MOBILENO, PARTNO }
TextEditingController searchController = new TextEditingController();
SearchBy? _val = SearchBy.NAME;
List<CurrentUser?> usersList = [];
List<CurrentUser?> backUpList = [];

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
  void initState() {
    context.read<UserBloc>().add(UserLoaded());
    super.initState();
  }

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
          child: BlocConsumer<UserBloc, UserState>(
            listener: (context, state) {
              if (state is UserLoggedOut) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                    (route) => false);
              }
            },
            builder: (context, state) {
              if (state is UserOperationSuccess || state is UserDeleted) {
                context.read<UserBloc>().add(UserLoaded());
                return Center(child: CircularProgressIndicator());
              } else if (state is UsersLoadInProgress) {
                return Center(child: CircularProgressIndicator());
              } else if (state is UsersLoadSuccess && state.users.isNotEmpty) {
                usersList = List.from(state.users);
                backUpList = List.from(usersList);

                return ChildWidget();
              } else if (state is UserOperationFailure) {
                return Center(
                  child: Text("Failed to load users"),
                );
              }
              return Column(
                children: [
                  Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        padding: EdgeInsets.only(right: 30, top: 20),
                        onPressed: () {
                          context.read<UserBloc>().add(LogOutRequested());
                        },
                        icon: Icon(Icons.logout),
                        alignment: Alignment.centerRight,
                      )),
                  Expanded(
                    child: Center(
                      child: Text(
                        "No users found",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

List<CurrentUser> previousList = [];
bool isInside = false;
String? insideUserName = "";
ScrollController controller = ScrollController();

class BuildGridView extends StatefulWidget {
  const BuildGridView({Key? key}) : super(key: key);

  @override
  _BuildGridViewState createState() => _BuildGridViewState();
}

class _BuildGridViewState extends State<BuildGridView> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        setState(() {
          isInside = false;
          insideUserName = "";
          usersList = previousList;
        });
        return Future.value(false);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          controller: controller,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 20),
              isInside ? Column(
                children: [
                  Text("Added by: $insideUserName",style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(height: 20),
                ],
              ) : Container(),
              GridView.builder(
                shrinkWrap: true,
                controller: controller,
                padding: EdgeInsets.all(10),
                scrollDirection: Axis.vertical,
                itemCount: usersList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: 5,
                  mainAxisSpacing: 20,
                ),
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction) {
                      context
                          .read<UserBloc>()
                          .add(UserDeleted(userCode: usersList[index]!.code!));
                    },
                    child: InkWell(
                      onTap: () {
                        if (!isInside) {
                          setState(() {
                            previousList = List.from(usersList);
                            usersList = usersList.where((user) {
                              insideUserName = "${usersList[index]!.firstName} ${usersList[index]!.middleName} ${usersList[index]!.lastName}";
                              return user!.addedBy == usersList[index]!.code;
                            }).toList();

                            isInside = true;
                          });
                        }
                        /* Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddUpdateScreen(
                              isUpdate: true,
                              users: usersList[index],
                            ),
                          ),
                        ); */
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
      ),
    );
  }
}

Widget buildContent(int index) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "${usersList[index]?.firstName} ${usersList[index]?.middleName} ${usersList[index]?.lastName} ",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("${usersList[index]?.mobileNo}"),
          usersList[index]?.partNo != null && usersList[index]?.partNo != ""
              ? Text("Part No: ${usersList[index]?.partNo}")
              : Text("PartNo: -"),
        ],
      ),

      /*  SizedBox(height: 20),
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
          : Text("-"), */
    ],
  );
}

Widget image(String? thumbnail) {
  List<int> ab = List<int>.from(json.decode(thumbnail!));
  /*    final _byteImage = base64Decode(thumbnail);
    print(_byteImage.toString()); */
  Uint8List list1 = Uint8List.fromList(ab);

  Widget image = Image.memory(list1);
  return image;
}

/* RichText buildRichText(String? key, String? value) {
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
 */
class ChildWidget extends StatefulWidget {
  const ChildWidget({Key? key}) : super(key: key);

  @override
  _ChildWidgetState createState() => _ChildWidgetState();
}

class _ChildWidgetState extends State<ChildWidget> {
  List<CurrentUser> insideBackUpList = [];
  @override
  Widget build(BuildContext context) {
    void Function(String)? onChanged(val) {
      if (val == "" && !isInside) {
        usersList = List.from(backUpList);
      } else if (isInside && val == "") {
        usersList = List.from(insideBackUpList);
      } else if (isInside &&
          val.toString().length == 1 &&
          insideBackUpList.isEmpty) {
        insideBackUpList = List.from(usersList);
      } else if (isInside && val != "") {
        usersList = List.from(previousList);
      }
      setState(() {
        usersList = usersList.where((user) {
          if (_val == SearchBy.MOBILENO) {
            if (user!.mobileNo != null) {
              return user.mobileNo!.startsWith(val);
            }
            return true;
          } else if (_val == SearchBy.PARTNO) {
            if (user!.partNo != null) {
              return user.partNo!.startsWith(val);
            }
            return true;
          } else {
            bool isFound = false;
            if (user!.firstName != null) {
              isFound = user.firstName!
                  .toLowerCase()
                  .startsWith(val.toString().toLowerCase());
              if (isFound) {
                return true;
              }
            }
            if (user.middleName != null) {
              isFound = user.middleName!
                  .toLowerCase()
                  .startsWith(val.toString().toLowerCase());
              if (isFound) {
                return true;
              }
            }
            if (user.lastName != null) {
              isFound = user.lastName!
                  .toLowerCase()
                  .startsWith(val.toString().toLowerCase());
              if (isFound) {
                return true;
              }
            }
            return false;
          }
        }).toList();
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
                            suffixIcon: NewWidget(),
                            hintText: _val == SearchBy.MOBILENO
                                ? 'Search by Mobile No'
                                : _val == SearchBy.NAME
                                    ? 'Search by Name'
                                    : 'Search by Part No',
                            border: InputBorder.none),
                        onChanged: onChanged)),
              )),
          /* Wrap(
            // mainAxisSize: MainAxisSize.min,
            // alignment: MainAxisAlignment.spaceEvenly,
            // crossAxisAlignment: WrapCrossAlignment.start,
            direction: Axis.horizontal,
            spacing: 0.1,

            children: [
              RadioListTile<SearchBy>(

                value: SearchBy.NAME,
                groupValue: _val,
                onChanged: onChanged,
                title: Text("Name"),
              ),
              RadioListTile<SearchBy>(
                value: SearchBy.NAME,
                groupValue: _val,
                onChanged: onChanged,
                title: Text("Mobile No"),
              ),
              RadioListTile<SearchBy>(
                value: SearchBy.NAME,
                groupValue: _val,
                onChanged: onChanged,
                title: Text("Name"),
              ),
            ],
          ), */
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Radio<SearchBy?>(
                        toggleable: true,
                        value: SearchBy.NAME,
                        groupValue: _val,
                        onChanged: (val) {
                          setState(() {
                            _val = val;
                          });
                        }),
                    Expanded(
                      child: Text('Name'),
                    )
                  ],
                ),
                flex: 1,
              ),
              Expanded(
                child: Row(
                  children: [
                    Radio<SearchBy?>(
                        toggleable: true,
                        value: SearchBy.MOBILENO,
                        groupValue: _val,
                        onChanged: (val) {
                          setState(() {
                            _val = val;
                          });
                        }),
                    Expanded(child: Text('Mobile No'))
                  ],
                ),
                flex: 1,
              ),
              Expanded(
                child: Row(
                  children: [
                    Radio<SearchBy?>(
                        toggleable: true,
                        value: SearchBy.PARTNO,
                        groupValue: _val,
                        onChanged: (val) {
                          setState(() {
                            _val = val;
                          });
                        }),
                    Expanded(child: Text('Part No'))
                  ],
                ),
                flex: 1,
              ),
            ],
          ),
          BuildGridView()
        ],
      ),
    );
  }
}

class NewWidget extends StatelessWidget {
  const NewWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          context.read<UserBloc>().add(LogOutRequested());
        },
        icon: Icon(Icons.logout));
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
