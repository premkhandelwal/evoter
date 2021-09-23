import 'package:evoter/logic/bloc/user_bloc.dart';
import 'package:evoter/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddUser extends StatefulWidget {
  
  const AddUser({Key? key}) : super(key: key);

  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        return Scaffold(
            body: Container(
          child: ElevatedButton(
            child: Text("Add"),
            onPressed: () {
              context.read<UserBloc>().add(UserAdded(user: User()));
            },
          ),
        ));
      },
    );
  }
}
