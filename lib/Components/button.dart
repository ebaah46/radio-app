import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatefulWidget {
  final String _buttonName;
  CustomButton(this._buttonName, {Key key}) : super(key: key);

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250.0,
      // ScreenUtil.getInstance().setWidth(300),
      height: 50.0,
      // ScreenUtil.getInstance().setHeight(100),
      constraints: BoxConstraints(maxWidth: 250, maxHeight: 80),
      decoration: BoxDecoration(
          gradient:
              LinearGradient(colors: [Color(0xFF17ead9), Color(0xFF6078ea)]),
          borderRadius: BorderRadius.circular(6.0),
          boxShadow: [
            BoxShadow(
                color: Color(0xFF6078ea).withOpacity(.3),
                offset: Offset(0.0, 8.0),
                blurRadius: 8.0)
          ]),
      child: Material(
        color: Colors.transparent,
        child: Center(
          child: Text(widget._buttonName,
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Poppins-Bold",
                  fontSize: 18,
                  letterSpacing: 1.0)),
        ),
      ),
    );
  }
}
