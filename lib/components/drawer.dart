import 'package:flutter/material.dart';
import 'package:kgrowth/model/account.dart';
import 'package:kgrowth/screens/login_screen.dart';
import 'package:kgrowth/utils/auth.dart';
import 'package:kgrowth/utils/firestore.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

// URLを定義
final Uri homePageUrl = Uri.parse(
    'https://www.second-fukaya.com/');

final Uri policyUrl = Uri.parse(
    'https://sites.google.com/view/kgrowth/%E3%83%97%E3%83%A9%E3%82%A4%E3%83%90%E3%82%B7%E3%83%BC');

class DrawerMenu extends StatefulWidget {
  const DrawerMenu({super.key});

  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  Account myAccount = Authentification.myAccount!;
  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [

          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                SizedBox(
                  height: 100,
                  width: 100,
                  child: Image.asset(
                      'assets/logo.png')
                ),
                const SizedBox(width: 20),

                Text(
                  'Kgrowth',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
          // アプリをシェアするリストタイル
          ListTile(
            leading: const Icon(Icons.share_outlined),
            title: const Text('アプリをシェアする'),
            onTap: () {
              Navigator.pop(context);
              _shareApp();
            },
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Kgrowthホームページ'),
            onTap: _launchHomePage,
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('プライバシーポリシー'),
            onTap: _privacyPage,
          ),
          ListTile(
            leading: const Icon(Icons.logout_outlined),
            title: const Text('ログアウト'),
            onTap: (){
              Authentification.signOut();
              while(Navigator.canPop(context)){
                Navigator.pop(context);
              }
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginPage()));
              },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.delete_forever_outlined),
            title: const Text('アカウント削除'),
            onTap: (){
              openDialog();
            },
          ),

        ],
      ),
    );
  }

  // アプリをシェアするための関数
  void _shareApp() async {
    await Share.share(
      'Kgrowthジムでは最先端のダイエットを提供致します',
    );
  }

  // ヘルプ＆サポートのURLを開くための関数
  Future<void> _launchHomePage() async {
    if (!await launchUrl(homePageUrl)) {
      throw Exception('エラー');
    }
  }

  Future<void> _privacyPage() async {
    if (!await launchUrl(policyUrl)) {
      throw Exception('エラー');
    }
  }

  Future openDialog() => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Column(
        children: [
          Text('アカウント削除してよろしいですか？'),
          SizedBox(height: 10),
          GestureDetector(
              onTap: () {
                UserFirestore.deleteUser(myAccount.id);
                Authentification.deleteAuth();
                Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) => LoginPage()));
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
                    'はい', style: TextStyle(color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                  ),
                ),
              )
          ),
          SizedBox(height: 5),
          GestureDetector(
              onTap: () {
                Navigator.of(context).pop(false);
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
                    'いいえ', style: TextStyle(color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                  ),
                ),
              )
          )
        ],

      ),
    )
  );
}