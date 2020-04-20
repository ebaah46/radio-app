import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:email_validator/email_validator.dart';

Map<String, dynamic> loginDetails = {'email': null, 'password': null};
Map<String, dynamic> signUpDetails = {
  'email': null,
  'name': null,
  'password': null,
};
bool formRegisterReadyState = false;
bool formLoginReadyState = false;

class FormCard extends StatefulWidget {
  @override
  _FormCardState createState() => _FormCardState();
}

class _FormCardState extends State<FormCard> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var isLogingIn = false;
  bool emailState = false, passState = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: new Container(
        width: double.infinity,
        height: ScreenUtil.getInstance().setHeight(580),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0.0, 15.0),
                  blurRadius: 15.0),
              BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0.0, -10.0),
                  blurRadius: 10.0),
            ]),
        child: Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Login",
                    style: TextStyle(
                        fontSize: ScreenUtil.getInstance().setSp(45),
                        fontFamily: "Poppins-Bold",
                        letterSpacing: .6)),
                SizedBox(
                  height: ScreenUtil.getInstance().setHeight(30),
                ),
                Text("Email",
                    style: TextStyle(
                        fontFamily: "Poppins-Medium",
                        fontSize: ScreenUtil.getInstance().setSp(26))),
                Expanded(
                  child: TextFormField(
                    // autovalidate: true,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        hintText: "email",
                        hintStyle:
                            TextStyle(color: Colors.grey, fontSize: 12.0)),
                    validator: (String value) {
                      if (value.isEmpty ||
                          EmailValidator.validate(value) != true)
                        return 'Enter valid email address';
                      else {
                        emailState = true;
                        print('Done Validating');
                      }
                    },

                    onChanged: (value) {
                      loginDetails['email'] = value;
                      if (_formKey.currentState.validate())
                        formLoginReadyState = true;
                    },
                  ),
                ),
                SizedBox(
                  height: ScreenUtil.getInstance().setHeight(30),
                ),
                Text("PassWord",
                    style: TextStyle(
                        fontFamily: "Poppins-Medium",
                        fontSize: ScreenUtil.getInstance().setSp(26))),
                Expanded(
                  child: TextFormField(
                    // autovalidate: true,
                    obscureText: true,
                    decoration: InputDecoration(
                        hintText: "Password",
                        hintStyle:
                            TextStyle(color: Colors.grey, fontSize: 12.0)),
                    onChanged: (String value) {
                      loginDetails['password'] = value;
                      if (_formKey.currentState.validate()) {
                        formLoginReadyState = true;
                        _formKey.currentState.save();
                        // setState(() {
                        // });
                        print('Form validation complete');
                        print(loginDetails);
                      }
                    },
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Password field cannot be empty';
                      } else {}
                    },
                    onFieldSubmitted: (String value) {
                      // loginDetails['password'] = value;
                      // if (_formKey.currentState.validate()) {
                      //   formLoginReadyState = true;
                      //   setState(() {
                      //     _formKey.currentState.save();
                      //   });
                      //   print('Form validation complete');
                      //   print(loginDetails);
                      // }
                    },
                  ),
                ),
                SizedBox(
                  height: ScreenUtil.getInstance().setHeight(35),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                            color: Colors.blue,
                            fontFamily: "Poppins-Medium",
                            fontSize: ScreenUtil.getInstance().setSp(26)),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FormCardRegister extends StatefulWidget {
  @override
  _FormCardRegisterState createState() => _FormCardRegisterState();
}

class _FormCardRegisterState extends State<FormCardRegister> {
  // bool nameState = false,
  //     emailState = false,
  //     passState = false,
  //     passwordState = false;
  final passController = TextEditingController();
  final confPassController = TextEditingController();
  final emailController = TextEditingController();
  final nameController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    passController.dispose();
    confPassController.dispose();
    emailController.dispose();
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: new Container(
        width: double.infinity,
        height: ScreenUtil.getInstance().setHeight(800),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0.0, 15.0),
                  blurRadius: 15.0),
              BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0.0, -10.0),
                  blurRadius: 10.0),
            ]),
        child: Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Register",
                    style: TextStyle(
                        fontSize: ScreenUtil.getInstance().setSp(45),
                        fontFamily: "Poppins-Bold",
                        letterSpacing: .6)),
                SizedBox(
                  height: ScreenUtil.getInstance().setHeight(45),
                ),
                Expanded(
                  child: Text("Name",
                      style: TextStyle(
                          fontFamily: "Poppins-Medium",
                          fontSize: ScreenUtil.getInstance().setSp(26))),
                ),
                Expanded(
                  child: TextFormField(
                    controller: nameController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        hintText: "Full Name",
                        hintStyle:
                            TextStyle(color: Colors.grey, fontSize: 12.0)),
                    onSaved: (value) {
                      print('Got $value');
                    },
                    autovalidate: false,
                    validator: (value) {
                      if (value.isEmpty)
                        return 'Name field cannot be empty';
                      else {}
                    },
                    onChanged: (value) {
                      signUpDetails['name'] = nameController.text;
                    },
                    // onFieldSubmitted: (String value) {
                    //   // print('Field is submitted!');
                    //   signUpDetails['name'] = value;
                    // },
                  ),
                ),
                SizedBox(
                  height: ScreenUtil.getInstance().setHeight(30),
                ),
                Expanded(
                  child: Text("Email",
                      style: TextStyle(
                          fontFamily: "Poppins-Medium",
                          fontSize: ScreenUtil.getInstance().setSp(26))),
                ),
                Expanded(
                  child: TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        hintText: "Email",
                        hintStyle:
                            TextStyle(color: Colors.grey, fontSize: 12.0)),
                    validator: (String value) {
                      if (value.isEmpty ||
                          EmailValidator.validate(value) != true)
                        return 'Enter valid email address';
                      else {}
                    },
                    onChanged: (value) {
                      signUpDetails['email'] = emailController.text;
                    },
                    onSaved: (value) {
                      print('Got $value');
                    },
                    // onFieldSubmitted: (String value) {
                    //   // print('Field is submitted!');
                    //   signUpDetails['email'] = value;
                    // },
                  ),
                ),
                SizedBox(
                  height: ScreenUtil.getInstance().setHeight(30),
                ),
                Expanded(
                  child: Text("Password",
                      style: TextStyle(
                          fontFamily: "Poppins-Medium",
                          fontSize: ScreenUtil.getInstance().setSp(26))),
                ),
                Expanded(
                  child: TextFormField(
                    controller: passController,
                    obscureText: true,
                    decoration: InputDecoration(
                        hintText: "Password",
                        hintStyle:
                            TextStyle(color: Colors.grey, fontSize: 12.0)),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Password field cannot be empty';
                      } else {}
                    },
                    onChanged: (value) {
                      signUpDetails['password'] = passController.text;
                    },
                    onSaved: (String value) {
                      print('Got $value');
                    },
                  ),
                ),
                SizedBox(
                  height: ScreenUtil.getInstance().setHeight(30),
                ),
                Expanded(
                  child: Text("Confirm Password",
                      style: TextStyle(
                          fontFamily: "Poppins-Medium",
                          fontSize: ScreenUtil.getInstance().setSp(26))),
                ),
                Expanded(
                  child: TextFormField(
                    controller: confPassController,
                    obscureText: true,
                    decoration: InputDecoration(
                        hintText: "Confirm Password",
                        hintStyle:
                            TextStyle(color: Colors.grey, fontSize: 12.0)),
                    validator: (String value) {
                      if (value.isEmpty)
                        return 'Enter valid password';
                      else if (signUpDetails['password'] != value) {
                        return 'Passwords do not match';
                      } else {
                        // if (_formKey.currentState.validate())
                        //   formRegisterReadyState = true;
                        // _formKey.currentState.save();
                        // setState(() {});
                      }
                    },
                    onChanged: (value) {
                      if (_formKey.currentState.validate()) {
                        // _formKey.currentState.save();
                        formRegisterReadyState = true;
                      } else {}
                      print('Editing is complete!');
                      _formKey.currentState.save();
                      print(signUpDetails['password']);
                      print('vs \n' + confPassController.text);
                    },
                  ),
                ),
                SizedBox(
                  height: ScreenUtil.getInstance().setHeight(45),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class Credentials implements _FormCardState {
//   // Get login details from Input fields

//   // Get Registratio details from input fields
//   Map<String, dynamic> getRegistrationDetails() {
//     var details = _FormCardRegisterState();
//     return details.signUpDetails;
//   }
// }
