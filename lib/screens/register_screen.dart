import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kgrowth/components/text_field.dart';
import 'package:kgrowth/model/account.dart';
import 'package:kgrowth/screens/check_email_screen.dart';
import 'package:kgrowth/utils/auth.dart';
import 'package:kgrowth/utils/firestore.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
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
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 200,
                    width: 200,
                    child: Image.asset(
                        'assets/logo.png'),
                  ),
                  const SizedBox(height: 30),
                  Text('新規登録',style: TextStyle(fontWeight: FontWeight.bold,
                  fontSize: 25)),
                  const SizedBox(height: 25),
                  MyTextField(controller: nameController,
                      hintText: 'お名前',
                      obscureText: false),
                  const SizedBox(height: 10),
                  MyTextField(controller: emailController,
                      hintText: 'メールアドレス',
                      obscureText: false),
                  const SizedBox(height: 10),
                  MyTextField(controller: passwordController,
                      hintText: 'パスワード(6文字以上)',
                      obscureText: true),
                  const SizedBox(height: 10),
                  GestureDetector(
                      onTap: () async{
                        if(nameController.text.isNotEmpty && emailController.text.isNotEmpty &&
                        passwordController.text.isNotEmpty) {
                          var result = await Authentification.signUp(email: emailController.text, password: passwordController.text);
                          if(result is UserCredential) {
                            Account newAccount = Account(
                              id:result.user!.uid,
                              name:nameController.text,
                              approved:false,
                            );
                            var _result = await UserFirestore.setUser(newAccount);
                            if(_result==true) {
                              result.user!.sendEmailVerification();
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> CheckEmailPage(email: emailController.text,password: passwordController.text)));
                            }
                          }
                          else{
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.red,
                                content: Text('再度ご確認をお願い致します'),
                              ),
                            );
                          }

                        } else{
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.red,
                              content: Text('全て入力をお願い致します'),
                            ),
                          );
                        }
                      } ,
                      child:
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(8)
                        ),
                        child: Center(
                          child: Text(
                            '登録', style: const TextStyle(color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                          ),
                        ),
                      )
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '登録お済みの方は',
                        style: TextStyle(color: Colors.grey[700],
                        fontSize: 20),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: const Text('コチラ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.blue,
                          ),),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}