import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kgrowth/screens/check_screen.dart';
import 'package:kgrowth/utils/auth.dart';
import 'package:kgrowth/utils/firestore.dart';

class CheckEmailPage extends StatefulWidget {

   CheckEmailPage({required this.email, required this.password});
  final String email;
  final String password;

  @override
  State<CheckEmailPage> createState() => _CheckEmailPageState();
}

class _CheckEmailPageState extends State<CheckEmailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body:  SafeArea(
        child: Center(
          child: Padding(

            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 200,
                    width: 200,
                    child: Image.asset(
                        'assets/logo.png'),
                  ),
                  const SizedBox(height: 30),
                  const Text('ご登録頂いたメールアドレス宛に確認のメールを送信しております。そちらに記載されているURLをクリックし承認をお願いいたします。',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 30),
                  GestureDetector(
                      onTap: () async{
                        var result = await Authentification.emailSignIn(email: widget.email, password: widget.password);
                        if(result is UserCredential){
                          await UserFirestore.getUser(result.user!.uid);
                        }
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CheckPage()));
                      },
                      child:
                      Container(
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(8)
                        ),
                        child: const Center(
                          child: Text(
                            '承認完了', style: TextStyle(color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                          ),
                        ),
                      )
                  ),
                  const SizedBox(height: 25),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
