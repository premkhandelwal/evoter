import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:evoter/logic/bloc/user_bloc.dart';
import 'package:evoter/logic/data/apiProvider.dart';
import 'package:evoter/screens/home_screen.dart';

void main() {
  runApp(MyApp(
    apiProvider: ApiProvider(),
  ));
}

class MyApp extends StatelessWidget {
  final ApiProvider apiProvider;
  const MyApp({
    Key? key,
    required this.apiProvider,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UserBloc(apiProvider)..add(UserLoaded()),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen(),
      ),
    );
  }
}
