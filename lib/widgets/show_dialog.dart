import 'package:flutter/material.dart';

class BaseAlertDialog extends StatelessWidget {

  //When creating please recheck 'context' if there is an error!

  Color _color = Color.fromARGB(220, 117, 218 ,255);

  late String _title;
  late String _content;
  late String _yes;
  late String _no;
  late String _cance;
  late Function _yesOnPressed;
  late Function _noOnPressed;
  late Function _cancelButton;

  BaseAlertDialog({
    required String title,
    required String content,
    required Function yesOnPressed,
    required Function noOnPressed,
    required Function cancelButton,
    String yes = "Yes",
    String no = "No",
    String cance = "Cance",}){
    this._title = title;
    this._content = content;
    this._yesOnPressed = yesOnPressed;
    this._noOnPressed = noOnPressed;
    this._cancelButton = noOnPressed;
    this._yes = yes;
    this._no = no;
    this._cance = no;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: new Text(this._title),
      content: new Text(this._content),
      backgroundColor: this._color,
      shape:
      RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15)),
      actions: <Widget>[

      ],
    );
  }
}