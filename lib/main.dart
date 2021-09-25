import 'package:evoter/logic/cubit/checkbox_cubit.dart';
import 'package:evoter/models/sessionConstants.dart';
import 'package:evoter/models/sharedObjects.dart';
import 'package:evoter/screens/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:evoter/logic/bloc/user_bloc.dart';
import 'package:evoter/logic/data/apiProvider.dart';
import 'package:evoter/screens/home_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  SharedObjects.prefs = await CachedSharedPreference.getInstance();

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
        ),
        BlocProvider(
          create: (context) => CheckboxCubit()),
        
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SharedObjects.prefs?.getString( SessionConstants.sessionUid) != null ? HomeScreen():  LoginScreen(),
      ),
    );
  }
}
