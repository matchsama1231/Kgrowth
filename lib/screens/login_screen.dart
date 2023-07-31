import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kgrowth/components/text_field.dart';
import 'package:kgrowth/screens/chat_screen.dart';
import 'package:kgrowth/screens/register_screen.dart';
import 'package:kgrowth/screens/reset_screen.dart';
import 'package:kgrowth/utils/auth.dart';
import 'package:kgrowth/utils/firestore.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                  SizedBox(
                    height: 200,
                    width: 200,
                    child: Image.asset(
                        'assets/logo.png'),
                  ),
                  const SizedBox(height: 30),
                  Text('Krowth',style: TextStyle(fontWeight: FontWeight.bold,
                  fontSize: 25),),
                  const SizedBox(height: 25),
                  MyTextField(controller: emailController,
                      hintText: 'メールアドレス',
                      obscureText: false),
                  const SizedBox(height: 10),
                  MyTextField(controller: passwordController,
                      hintText: 'パスワード',
                      obscureText: true),
                  const SizedBox(height: 10),
                GestureDetector(
                  onTap: () async{
                   var result = await Authentification.emailSignIn(email: emailController.text, password: passwordController.text);
                   if(result is UserCredential) {
                     if(result.user!.emailVerified == true){
                     var _result = await UserFirestore.getUser(result.user!.uid); //boolを持ってくる
                     if(_result == true) {
                       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChatPage()));
                     } else{print('承認をお待ち下さい');
                     ScaffoldMessenger.of(context).showSnackBar(
                       const SnackBar(
                         backgroundColor: Colors.red,
                         content: Text('承認をお待ち下さい'),
                       ),
                     );
                      }
                    } else {
                       ScaffoldMessenger.of(context).showSnackBar(
                         const SnackBar(
                           backgroundColor: Colors.red,
                           content: Text('メール認証をお願い致します'),
                         ),
                       );
                       print('メール認証をお願い致します');
                     }
                   } else{print('メールアドレスとパスワードが一致しません');
                   ScaffoldMessenger.of(context).showSnackBar(
                     const SnackBar(
                       backgroundColor: Colors.red,
                       content: Text('メールアドレスとパスワードが一致しません'),
                     ),
                   );
                   }
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
                           'ログイン', style: TextStyle(color: Colors.white,
                             fontWeight: FontWeight.bold,
                             fontSize: 16),
                         ),
                       ),
                     )
                     ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '登録お済みでない方は',
                        style: TextStyle(color: Colors.grey[700],fontSize: 20),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> RegisterPage()));
                        },
                        child: const Text('コチラ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.blue,
                        ),),
                      )
                    ],
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'パスワードをお忘れの方は',
                        style: TextStyle(color: Colors.grey[700],
                            fontSize: 20),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> ForgotPasswordPage()));
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
