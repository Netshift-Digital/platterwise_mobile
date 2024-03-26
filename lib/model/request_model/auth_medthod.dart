import 'package:firebase_auth/firebase_auth.dart';

class AuthMethod{
 final User? user;
  final bool newUser;

 AuthMethod({this.user,required this.newUser});
}