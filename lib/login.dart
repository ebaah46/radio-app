import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radio_app/ApiController.dart';
import 'package:radio_app/Components/button.dart';
import 'package:radio_app/Widgets/loading.dart';
import 'package:radio_app/home.dart';
import 'package:radio_app/register.dart';
import 'Widgets/FormCard.dart';
import 'Widgets/SocialIcons.dart';
import 'CustomIcons.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  bool _isSelected = false;
  bool _isLoading = false;
  void _radio() {
    setState(() {
      _isSelected = !_isSelected;
    });
  }

  Widget radioButton(bool isSelected) => Container(
        width: 16.0,
        height: 16.0,
        padding: EdgeInsets.all(2.0),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 2.0, color: Colors.black)),
        child: isSelected
            ? Container(
                width: double.infinity,
                height: double.infinity,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.black),
              )
            : Container(),
      );

  Widget horizontalLine() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          width: ScreenUtil.getInstance().setWidth(120),
          height: 1.0,
          color: Colors.black26.withOpacity(.2),
        ),
      );

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true);
    return new Scaffold(
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
                  padding: EdgeInsets.only(top: 30.0),
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
                    height: ScreenUtil.getInstance().setHeight(100),
                  ),
                  FormCard(),
                  SizedBox(height: ScreenUtil.getInstance().setHeight(40)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 12.0,
                          ),
                          GestureDetector(
                            onTap: _radio,
                            child: radioButton(_isSelected),
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          Text("Remember me",
                              style: TextStyle(
                                  fontSize: 12, fontFamily: "Poppins-Medium"))
                        ],
                      ),
                      InkWell(
                        onTap: () async {
                          if (formLoginReadyState) {
                            setState(() {
                              _isLoading = true;
                            });
                            // print('After initialization');
                            // print(loginDetails);
                            ApiController _apiController = ApiController();
                            String response = await _apiController.login(
                                loginDetails['email'],
                                loginDetails['password']);
                            print(response);
                            if (response == "Success") {
                              setState(() {
                                _isLoading = false;
                              });
                              // Go to the homepage
                              print('Navigating to homepage');
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          HomePage()));
                              print('Login Complete');
                            }
                            if (response == 'Unauthorized') {
                              _globalKey.currentState.showSnackBar(SnackBar(
                                content: Text(
                                  'User not found',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                                backgroundColor: Colors.redAccent,
                              ));
                              setState(() {
                                _isLoading = false;
                              });
                            } else {
                              _globalKey.currentState.showSnackBar(SnackBar(
                                content: Text(
                                  'Login Failed',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                                backgroundColor: Colors.redAccent,
                              ));
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          } else {
                            _globalKey.currentState.showSnackBar(SnackBar(
                              content: Text(
                                'Please enter login credentials',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                                textAlign: TextAlign.left,
                              ),
                              backgroundColor: Colors.redAccent,
                            ));
                          }
                        },
                        child: _isLoading
                            ? Padding(
                                padding: const EdgeInsets.only(right: 50.0),
                                child: CircularProgressIndicator(
                                  strokeWidth: 5.0,
                                  backgroundColor: Color(0xFF17ead9),
                                ),
                              )
                            : CustomButton('SIGNIN'),
                      )
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil.getInstance().setHeight(30),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      horizontalLine(),
                      Text("Social Login",
                          style: TextStyle(
                              fontSize: 16.0, fontFamily: "Poppins-Medium")),
                      horizontalLine()
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil.getInstance().setHeight(40),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: SocialIcon(
                          colors: [
                            Color(0xFF102397),
                            Color(0xFF187adf),
                            Color(0xFF00eaf8),
                          ],
                          iconData: CustomIcons.facebook,
                          onPressed: () {},
                        ),
                      ),
                      Expanded(
                        child: SocialIcon(
                          colors: [
                            Color(0xFFff4f38),
                            Color(0xFFff355d),
                          ],
                          iconData: CustomIcons.googlePlus,
                          onPressed: () {},
                        ),
                      ),
                      Expanded(
                        child: SocialIcon(
                          colors: [
                            Color(0xFF17ead9),
                            Color(0xFF6078ea),
                          ],
                          iconData: CustomIcons.twitter,
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil.getInstance().setHeight(30),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "New User?",
                        style: TextStyle(fontFamily: "Poppins-Medium"),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      Register()));
                        },
                        child: Text("SignUp",
                            style: TextStyle(
                                color: Color(0xFF5d74e3),
                                fontFamily: "Poppins-Bold")),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
