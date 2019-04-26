import 'dart:async';

class CustomerValidator {
  static Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  static RegExp regex = new RegExp(pattern);

  final validateLastName = StreamTransformer<String, String>.fromHandlers(
    handleData: (lastName, sink){
      if(lastName.isNotEmpty){
        sink.add(lastName);
      } else {
        sink.addError('Apellido inválido');
      }
    }
  );

  final validateFirstName = StreamTransformer<String, String>.fromHandlers(
    handleData: (firstName, sink){
      if (firstName.isNotEmpty){
        sink.add(firstName);
      } else {
        sink.addError('Nombres inválidos');
      }
    }
  );

  final validateEmail = StreamTransformer<String, String>.fromHandlers(
    handleData: (email, sink){
      if (regex.hasMatch(email)){
        sink.add(email);
      } else if (email.isNotEmpty){
        sink.addError('Email inválido');
      }
    }
  );
}