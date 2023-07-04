import 'package:flutter/material.dart';
import 'package:kgrowth/screens/login_screen.dart';

class CheckPage extends StatelessWidget {
  const CheckPage({super.key});

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
                  Text('承認までしばらくお待ち下さい',style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 30),
                  GestureDetector(
                      onTap: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
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
                            'ログインページ', style: TextStyle(color: Colors.white,
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
