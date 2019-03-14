import 'dart:async';

class LoginValidator {
  final validateId = StreamTransformer<String, String>.fromHandlers(
    handleData: (id, sink){
      if (id.isNotEmpty) {
        sink.add(id);
      }else{
        sink.addError('Enter a user!');
      }
    }
  );

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink){
        if (password.isNotEmpty) {
          sink.add(password);
        }else{
          sink.addError('Enter the password to continue!');
        }
      }
  );
}