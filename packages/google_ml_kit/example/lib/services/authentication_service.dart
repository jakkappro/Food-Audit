import 'package:firebase_auth/firebase_auth.dart';

enum LoginStatus { success, emailNotVerified, failed }

enum RegisterStatus {
  success,
  emailAlreadyInUse,
  failed,
  badEmail,
  badPassword,
  badName
}

final _emailRegex = RegExp(
  r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
);
final _passwordRegex = RegExp(
  r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?#&])[A-Za-z\d@$!%*?&]{8,}$',
);

Future<LoginStatus> login(String email, String password) async {
  try {
    final result = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    if (result.user != null) {
      // login successful
      if (result.user!.emailVerified == false) {
        return LoginStatus.emailNotVerified;
      } else {
        return LoginStatus.success;
      }
    } else {
      // login failed
      return LoginStatus.failed;
    }
  } catch (e) {
    // login failed
    return LoginStatus.failed;
  }
}

Future<RegisterStatus> register(
    String firstName, String lastName, String email, String password) async {
  if (!_emailRegex.hasMatch(email)) {
    return RegisterStatus.badEmail;
  }

  if (!_passwordRegex.hasMatch(password)) {
    return RegisterStatus.badPassword;
  }

  if (firstName == '' || lastName == '') {
    return RegisterStatus.badName;
  }

  try {
    final result = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    result.user!.updateDisplayName('$firstName $lastName');
    return RegisterStatus.success;
  } on FirebaseAuthException catch (e) {
    // Get the error code
    final code = e.code;

    // Handle the error based on the code
    switch (code) {
      case 'weak-password':
        return RegisterStatus.badPassword;
      case 'email-already-in-use':
        return RegisterStatus.emailAlreadyInUse;
      case 'invalid-email':
        return RegisterStatus.badEmail;
      default:
        return RegisterStatus.failed;
    }
  } catch (e) {
    // login failed
    return RegisterStatus.failed;
  }
}
