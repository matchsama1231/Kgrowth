

import 'package:firebase_auth/firebase_auth.dart';
import 'package:kgrowth/model/account.dart';

class Authentification {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static User? currentFirebaseUser;
  static Account? myAccount;

  static Future<dynamic> signUp ({required String email, required String password})async{
  try {
    UserCredential newAccount = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    print('登録完了');
    return newAccount;
  } on FirebaseAuthException catch(e){
    
  }
  }

  static Future<dynamic> emailSignIn ({required String email, required String password})async{
    try {
      final UserCredential _result = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      currentFirebaseUser = _result.user;
      print('完了');
      return _result;
    } on FirebaseAuthException catch(e){
      return false;
    }
  }

  static Future<void> signOut() async{
    await _firebaseAuth.signOut();
  }

  static Future<void> deleteAuth() async{
    await currentFirebaseUser!.delete();
  }

}