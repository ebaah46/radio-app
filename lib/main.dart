import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_app/Models/ApiController.dart';
import 'package:radio_app/Screens/home.dart';
import 'package:radio_app/Screens/login.dart';
import 'package:radio_app/Screens/messages.dart';
import 'package:radio_app/bloc/messagebloc_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

// Get User Auth State
Future<bool> getUserState() async {
  ApiController _apiController = ApiController();
  String token = await _apiController.getTokenDetails();
  if (token == '')
    return false;
  else
    return true;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        // theme: new ThemeData(primaryColor: Color.fromRGBO(58, 66, 86, 1.0)),
        // theme: ThemeData.dark().copyWith(primaryColor: kPrimaryColor),
        // routes: {'/login': (context) => Login()},
        theme: ThemeData(
            hintColor: Color(0xFF371AD8),
            primaryColor: Color(0xFF4868D8),
            fontFamily: "Montserrat",
            canvasColor: Colors.transparent),
        // home: BlocProvider(
        //   create: (BuildContext context) =>
        //       MessageblocBloc(apiController: ApiController()),
        //   child: Messages(),
        // )
        home: FutureBuilder<bool>(
            future: getUserState(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data)
                  return HomePage();
                else if (!snapshot.data)
                  return Login();
                else
                  return HomePage();
              } else
                return Theme(
                  data: Theme.of(context)
                      .copyWith(accentColor: Color(0xFF17ead9)),
                  child: CircularProgressIndicator(
                    strokeWidth: 5.0,
                  ),
                );
            }));
  }
}
