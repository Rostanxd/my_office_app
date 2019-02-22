import 'package:flutter/material.dart';
import './InputFields.dart';

class LoginForm extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LoginForm();
  }

}

class _LoginForm extends State<LoginForm> {

  final _formKey = GlobalKey<FormState>();
  String _user;

  @override
  Widget build(BuildContext context) {
    return (new Container(
      margin: new EdgeInsets.symmetric(horizontal: 20.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new Form(
            key: _formKey,
            child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              new TextFormField(
                decoration: InputDecoration(labelText: "User"),
                validator: (val) => val.isEmpty ? 'User is empty' : null,
                onSaved: (val) => _user = val,
              ),
              new TextFormField(
                decoration: InputDecoration(labelText: "Password"),
                validator: (val) => val.isEmpty ? 'Pleasse insert your password to '
                    'continue...' : null,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton (
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      Navigator.pushNamed(context, '/home');
//                      Scaffold.of(context)
//                          .showSnackBar(SnackBar(content: Text('Processing Data')));
                    }
                  },
                  child: Text('Log-in'),
                ),
              ),
            ],
          )),
        ],
      ),
    ));
  }
}
