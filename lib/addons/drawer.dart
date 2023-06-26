import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:url_launcher/url_launcher.dart';

class MainSideBar extends StatefulWidget {
  const MainSideBar({Key? key}) : super(key: key);

  @override
  State<MainSideBar> createState() => _MainSideBarState();
}

class _MainSideBarState extends State<MainSideBar> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    // double h = MediaQuery.of(context).size.height;
    var telegramUrl = Uri.parse('https://t.me/+VvQG2HfRTGBlYjI8');

    return Container(
      constraints: const BoxConstraints(maxWidth: 380),
      child: Drawer(
        width: w * 0.7,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Colors.black),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.black54,
                child: ClipOval(
                    child: kIsWeb
                        ? Image.network(
                            '${FirebaseAuth.instance.currentUser!.photoURL}',
                            scale: 1.0,
                            fit: BoxFit.cover,
                            width: 100,
                            height: 70,
                          )
                        : Image.network(
                            '${FirebaseAuth.instance.currentUser?.photoURL}',
                            scale: 1.0,
                            fit: BoxFit.cover,
                            width: 100,
                            height: 70,
                          )),
              ),
              accountName:
                  Text('${FirebaseAuth.instance.currentUser?.displayName}'),
              accountEmail: Text('${FirebaseAuth.instance.currentUser?.email}'),
            ),
            ListTile(
              leading: const Icon(
                Icons.feedback,
                size: 30.0,
              ),
              title: const Text(
                'Support',
                style: TextStyle(fontSize: 15.0),
              ),
              onTap: () => launchUrl(telegramUrl),
            ),
            ListTile(
                leading: const Icon(
                  Icons.logout,
                  size: 30.0,
                ),
                title: const Text(
                  'Log Out',
                  style: TextStyle(fontSize: 15.0),
                ),
                onTap: () {
                  FirebaseAuth.instance.signOut();
                }),
            ListTile(
              leading: const Icon(Ionicons.close_circle, size: 30.0),
              title: const Text(
                'Exit App',
                style: TextStyle(fontSize: 15.0),
              ),
              onTap: () {
                SystemNavigator.pop();
              },
            )
          ],
        ),
      ),
    );
  }
}
