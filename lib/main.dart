import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:my_office_th_app/screens/login/index.dart';
import 'package:my_office_th_app/screens/home/index.dart';
import 'package:my_office_th_app/screens/home/test_date_picker.dart';
import 'package:my_office_th_app/screens/inventory/index.dart';
import 'package:my_office_th_app/screens/inventory/item_home.dart';
import 'package:my_office_th_app/screens/signup/signup.dart';
import 'package:my_office_th_app/factories/post.dart';

import 'package:http/http.dart' as http;

Future<Post> fetchPost() async {
  final response =
  await http.get('https://jsonplaceholder.typicode.com/posts/1');

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    return Post.fromJson(json.decode(response.body));
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/signup': (BuildContext context) => new SignupPage(),
        '/home': (BuildContext context) => new HomePage(null),
        '/picker': (BuildContext context) => new TestDatePicker(),
        '/item_home': (BuildContext context) => new ItemHome(null),
      },
      home: new MyLoginPage(),
    );
  }
}