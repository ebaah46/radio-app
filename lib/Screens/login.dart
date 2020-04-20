import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radio_app/Components/button.dart';
import 'package:radio_app/Models/ApiController.dart';
import 'package:radio_app/Screens/home.dart';
import 'package:radio_app/Screens/register.dart';
import 'package:radio_app/Widgets/CustomIcons.dart';
import 'package:radio_app/Widgets/FormCard.dart';
import 'package:radio_app/Widgets/SocialIcons.dart';
// import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

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

  navToWeb(String url) async {
    if (await canLaunch(url))
      await launch(url, forceWebView: true, enableJavaScript: true);
    else
      throw 'Failed to launch $url';
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Quit App'),
              content: Text('Are you sure you want to quit?'),
              actions: <Widget>[
                FlatButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                FlatButton(
                  child: Text('Yes'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                )
              ],
            );
          },
        ) ??
        false;
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
        padding: EdgeInsets.symmetric(horizontal: 5.0),
        child: Container(
          width: ScreenUtil.getInstance().setWidth(100),
          height: 1.0,
          color: Colors.black26.withOpacity(.2),
        ),
      );

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true);
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
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
                    child: Image.asset('assets/images/back1.png'),
                  ),
                ),
                Expanded(
                  child: Image.asset('assets/images/back2.png'),
                )
              ],
            ),
            SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height,
                    maxWidth: MediaQuery.of(context).size.width),
                child: Padding(
                  padding: EdgeInsets.only(left: 28.0, right: 28.0, top: 35.0),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            "assets/images/logo.jpeg",
                            width: ScreenUtil.getInstance().setWidth(230),
                            height: ScreenUtil.getInstance().setHeight(230),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil.getInstance().setHeight(50),
                      ),
                      Expanded(flex: 5, child: FormCard()),
                      SizedBox(height: ScreenUtil.getInstance().setHeight(20)),
                      Expanded(
                        flex: 2,
                        child: Row(
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
                                        fontSize: 12,
                                        fontFamily: "Poppins-Medium"))
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
                                  ApiController _apiController =
                                      ApiController();
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
                                    _globalKey.currentState
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                        'Incorrect email or password entered',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14),
                                      ),
                                      backgroundColor: Colors.redAccent,
                                    ));
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  } else if (response == 'Failed') {
                                    _globalKey.currentState
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                        'Login Failed',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14),
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
                                      'Please enter valid login credentials',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14),
                                      textAlign: TextAlign.left,
                                    ),
                                    backgroundColor: Colors.redAccent,
                                  ));
                                }
                              },
                              child: _isLoading
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.only(right: 50.0),
                                      child: Theme(
                                        data: Theme.of(context).copyWith(
                                            accentColor: Color(0xFF17ead9)),
                                        child: CircularProgressIndicator(
                                          strokeWidth: 5.0,
                                        ),
                                      ))
                                  : Container(
                                      height: 50,
                                      width: 135,
                                      child: CustomButton('SIGNIN')),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil.getInstance().setHeight(20),
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: <Widget>[
                      //     horizontalLine(),
                      //     Text("Social Media Pages",
                      //         style: TextStyle(
                      //             fontSize: 16.0, fontFamily: "Poppins-Medium")),
                      //     horizontalLine()
                      //   ],
                      // ),
                      // SizedBox(
                      //   height: ScreenUtil.getInstance().setHeight(40),
                      // ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: <Widget>[
                      //     Expanded(
                      //       child: SocialIcon(
                      //         colors: [
                      //           Color(0xFF102397),
                      //           Color(0xFF187adf),
                      //           Color(0xFF00eaf8),
                      //         ],
                      //         iconData: CustomIcons.facebook,
                      //         onPressed: () {
                      //           navToWeb(
                      //               'https://www.facebook.com/EWAK-RADIO-105188807796569/');
                      //         },
                      //       ),
                      //     ),
                      //     Expanded(
                      //       child: SocialIcon(
                      //         colors: [
                      //           Color(0xFFff4f38),
                      //           Color(0xFFff355d),
                      //         ],
                      //         iconData: CustomIcons.googlePlus,
                      //         onPressed: () {
                      //           navToWeb(
                      //               'https://www.google.com/search?q=EWAK+Radio&oq=EWAK+Radio&aqs=chrome..69i57j69i60l3.13999j0j7&sourceid=chrome&ie=UTF-8');
                      //         },
                      //       ),
                      //     ),
                      //     Expanded(
                      //         child: InkWell(
                      //       child: CircleAvatar(
                      //         backgroundColor: Colors.transparent,
                      //         child: Image(
                      //           image: AssetImage('assets/images/yt.png'),
                      //         ),
                      //       ),
                      //       onTap: () {
                      //         navToWeb(
                      //             'https://www.youtube.com/channel/UCZkVG0oTg5XMIjOJDVWSe5Q');
                      //       },
                      //     )),
                      //   ],
                      // ),
                      // SizedBox(
                      //   height: ScreenUtil.getInstance().setHeight(30),
                      // ),
                      Row(
                        // crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "New User?",
                              style: TextStyle(fontFamily: "Poppins-Medium"),
                            ),
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
              ),
            )
          ],
        ),
      ),
    );
  }
}
