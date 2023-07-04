import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kgrowth/model/account.dart';
import 'package:kgrowth/utils/auth.dart';

class UserFirestore {
  static final _firestoreInstance = FirebaseFirestore.instance;
  static final CollectionReference users = _firestoreInstance.collection('users');

  static Future<dynamic> setUser (Account newAccount)async{
    try{
      await users.doc(newAccount.id).set({
        'name':newAccount.name,
        'approved':newAccount.approved,
      });
      return true;
    }on FirebaseException catch(e){}
  }

  static Future<dynamic> getUser(String uid)async{
    try{
      DocumentSnapshot documentSnapshot = await users.doc(uid).get();
      Map<String,dynamic> data = documentSnapshot.data() as Map<String,dynamic>;
      Account myAccount = Account(approved: data['approved'], name: data['name'], id: uid);
      Authentification.myAccount = myAccount;
      return myAccount.approved;
    } on FirebaseException catch(e){
      return null;
    }
  }

  static Future<dynamic> deleteUser (String uid) async{
    users.doc(uid).delete();
  }
}