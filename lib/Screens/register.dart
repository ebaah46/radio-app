import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radio_app/Components/button.dart';
import 'package:radio_app/Models/ApiController.dart';
import 'package:radio_app/Widgets/FormCard.dart';
import 'home.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  bool _isRegistering = false;
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true);
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: true,
      key: _globalKey,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Image.network(
                      "https://raw.githubusercontent.com/vcardona/Flutter-Login-Page-UI-Explained/master/assets/image_01.png"),
                ),
              ),
              // Expanded(
              //   child: Container(),
              // ),
              Expanded(
                child: Image.network(
                    "https://raw.githubusercontent.com/vcardona/Flutter-Login-Page-UI-Explained/master/assets/image_02.png"),
              )
            ],
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 28.0, right: 28.0, top: 35.0),
              child: Column(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      "assets/images/logo.jpeg",
                      width: ScreenUtil.getInstance().setWidth(230),
                      height: ScreenUtil.getInstance().setHeight(230),
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil.getInstance().setHeight(50),
                  ),
                  FormCardRegister(),
                  SizedBox(height: ScreenUtil.getInstance().setHeight(40)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      InkWell(
                        onTap: () async {
                          print(signUpDetails);
                          if (formRegisterReadyState) {
                            setState(() {
                              _isRegistering = true;
                            });
                            // Fire API to register user
                            ApiController _apiController = ApiController();
                            String response = await _apiController.register(
                                signUpDetails['name'],
                                signUpDetails['email'],
                                signUpDetails['password']);
                            print(response);
                            if (response == 'Success') {
                              setState(() {
                                _isRegistering = false;
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          HomePage()));
                            } else if (response == 'Email Exists') {
                              setState(() {
                                _isRegistering = false;
                              });
                              _globalKey.currentState.showSnackBar(SnackBar(
                                content: Text(
                                  'User already exists',
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.redAccent,
                              ));
                            } else {
                              // Do nothing but show a snackbar to alert user on error
                              _globalKey.currentState.showSnackBar(SnackBar(
                                content: Text(
                                  'Login Failed',
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.redAccent,
                              ));
                            }
                          } else {
                            _globalKey.currentState.showSnackBar(SnackBar(
                              content: Text(
                                'Please enter registeration credentials',
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.redAccent,
                            ));
                          }
                        },
                        child: _isRegistering
                            ? Padding(
                                padding: const EdgeInsets.only(right: 15.0),
                                child: Theme(
                                  data: Theme.of(context)
                                      .copyWith(accentColor: Color(0xFF17ead9)),
                                  child: CircularProgressIndicator(
                                    strokeWidth: 5.0,
                                  ),
                                ))
                            : CustomButton('SIGNUP'),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
