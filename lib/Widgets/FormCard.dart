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
    return new Container(
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
              TextFormField(
                // autovalidate: true,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    hintText: "email",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
                validator: (String value) {
                  if (value.isEmpty || EmailValidator.validate(value) != true)
                    return 'Enter valid email address';
                  else {
                    emailState = true;
                    print('Done Validating');
                  }
                },
                onFieldSubmitted: (String value) {
                  loginDetails['email'] = value;
                  if (_formKey.currentState.validate())
                    formLoginReadyState = true;

                  _formKey.currentState.save();
                },
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
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
                  onSaved: (String value) {
                    // loginDetails['password'] = value;
                  },
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Password field cannot be empty';
                    } else {}
                  },
                  onFieldSubmitted: (String value) {
                    loginDetails['password'] = value;
                    if (_formKey.currentState.validate()) {
                      formLoginReadyState = true;
                      setState(() {
                        _formKey.currentState.save();
                      });
                      print('Form validation complete');
                      print(loginDetails);
                    }
                  },
                ),
              ),
              SizedBox(
                height: ScreenUtil.getInstance().setHeight(35),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    "Forgot Password?",
                    style: TextStyle(
                        color: Colors.blue,
                        fontFamily: "Poppins-Medium",
                        fontSize: ScreenUtil.getInstance().setSp(26)),
                  )
                ],
              )
            ],
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

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return new Container(
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
              Text("Name",
                  style: TextStyle(
                      fontFamily: "Poppins-Medium",
                      fontSize: ScreenUtil.getInstance().setSp(26))),
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      hintText: "Full Name",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
                  onSaved: (value) {},
                  autovalidate: false,
                  validator: (value) {
                    if (value.isEmpty)
                      return 'Name field cannot be empty';
                    else {}
                  },
                  onFieldSubmitted: (String value) {
                    signUpDetails['name'] = value;
                  },
                ),
              ),
              SizedBox(
                height: ScreenUtil.getInstance().setHeight(30),
              ),
              Text("Email",
                  style: TextStyle(
                      fontFamily: "Poppins-Medium",
                      fontSize: ScreenUtil.getInstance().setSp(26))),
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      hintText: "Email",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
                  validator: (String value) {
                    if (value.isEmpty || EmailValidator.validate(value) != true)
                      return 'Enter valid email address';
                    else {}
                  },
                  onSaved: (value) {},
                  onFieldSubmitted: (String value) {
                    signUpDetails['email'] = value;
                  },
                ),
              ),
              SizedBox(
                height: ScreenUtil.getInstance().setHeight(30),
              ),
              Text("Password",
                  style: TextStyle(
                      fontFamily: "Poppins-Medium",
                      fontSize: ScreenUtil.getInstance().setSp(26))),
              Expanded(
                child: TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: "Password",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Password field cannot be empty';
                    } else {}
                  },
                  onSaved: (String value) {},
                  onFieldSubmitted: (String value) {
                    signUpDetails['password'] = value;
                    // _formKey.currentState.validate();
                  },
                ),
              ),
              SizedBox(
                height: ScreenUtil.getInstance().setHeight(30),
              ),
              Text("Confirm Password",
                  style: TextStyle(
                      fontFamily: "Poppins-Medium",
                      fontSize: ScreenUtil.getInstance().setSp(26))),
              Expanded(
                child: TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: "Confirm Password",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
                  validator: (String value) {
                    if (value.isEmpty) return 'Enter valid password';
                    if (value != signUpDetails['password']) {
                      return 'Passwords do not match';
                    } else {
                      if (_formKey.currentState.validate())
                        formRegisterReadyState = true;
                    }
                  },
                  onSaved: (String value) {},
                  onFieldSubmitted: (String value) {
                    _formKey.currentState.save();
                    print(signUpDetails['password']);
                    print('vs \n' + value);
                    if (signUpDetails['password'] == value)
                      formRegisterReadyState = true;
                    if (_formKey.currentState.validate()) {
                      formRegisterReadyState = true;
                    } else {}
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
