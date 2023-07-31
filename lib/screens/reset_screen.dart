import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kgrowth/screens/login_screen.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose(){
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Reset Password'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('ご登録頂いたアドレス宛に'),
            SizedBox(height: 10),
            Text('リンクを送信します'),
              SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                cursorColor: Colors.white,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(labelText:'メールアドレス'),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (email)=>
                    email != null && !EmailValidator.validate(email)?
                        '正しいアドレスを入力して下さい': null,
              ),
              SizedBox(height: 25),
              GestureDetector(
                  onTap: () async{
                    await resetPassword();
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                  child:
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8)
                    ),
                    child: Center(
                      child: Text(
                        '送信', style: const TextStyle(color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                      ),
                    ),
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
          email: emailController.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('送信完了'),
        ),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('アドレスが正しくありません'),
        ),
      );
    }
    }
  }

