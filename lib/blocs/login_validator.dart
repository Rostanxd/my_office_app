import 'dart:async';

class LoginUserValidator {
  final validateId = StreamTransformer<String, String>.fromHandlers(
    handleData: (id, sink){
      if (id.isNotEmpty) {
        sink.add(id);
      }else{
        sink.addError('Enter your user.');
      }
    }
  );

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink){
        if (password.isNotEmpty) {
          sink.add(password);
        }else{
          sink.addError('Enter the password to continue.');
        }
      }
  );
}