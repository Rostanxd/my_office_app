import 'package:flutter/material.dart';

import 'package:my_office_th_app/screens/login/index.dart';
import 'package:my_office_th_app/screens/home/index.dart';
import 'package:my_office_th_app/screens/signup/signup.dart';

final routes = {
  '/signup': (BuildContext context) => new SignupPage(),
  '/home': (BuildContext context) => new HomePage(null),
  '/login': (BuildContext context) => new MyLoginPage(),
  '/': (BuildContext context) => new MyLoginPage(),
};