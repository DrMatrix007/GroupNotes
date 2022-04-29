import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:group_notes/models/group.dart';
import 'package:group_notes/models/group_user.dart';
import 'package:group_notes/pages/home_page.dart';
import 'package:group_notes/pages/sign_in.dart';
import 'package:group_notes/services/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  try {
    runApp(MyApp());
  } catch (e, stack) {
    print(e);
    print(stack);
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    setState(() {});
  }

  Future<void> signout() async {
    await FirebaseAuth.instance.signOut().catchError((e) => print(e));
    this.setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // print("GG");
    return MaterialApp(
      home: StreamBuilder<CurrentGroupUser?>(
          stream: Auth.userChanges(),
          builder: (context, snapshot) {
            CurrentGroupUser? user = snapshot.data;
            print(user);
            print("user ${user.toString()}");
            return Navigator(
              pages: [
                if (user == null) MaterialPage(child: SignInPage()),
                if (user != null)
                  MaterialPage(
                      child: HomePage(
                    groupUser: user,
                    signout: signout,
                  ))
              ],
              onPopPage: (route, result) {
                return route.didPop(result);
              },
            );
          }),
      title: 'Group Users',
    );
  }
}
