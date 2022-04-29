import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  Future<void> signIn() async {
    setState(() {
      isLoading = true;
    });
    try {
      if (!kIsWeb) {
        var provider = GoogleSignIn();

        var u = await provider.signIn();
        final GoogleSignInAuthentication googleAuth = await u!.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
        var userCred =
            await FirebaseAuth.instance.signInWithCredential(credential);
            setState(() {
      isLoading = false;
    });
        // var r = await FirebaseAuth.instance.signInWithPopup(provider);

      } else {
        print("GG");
        var provider = GoogleAuthProvider();

        //var r =
        await FirebaseAuth.instance.signInWithRedirect(provider);
        var r = await FirebaseAuth.instance.getRedirectResult();
        var result = await FirebaseAuth.instance.signInWithCredential(r.credential!);        
        result.user;
            setState(() {
      isLoading = false;
    });
        
        // if (guser != null) {
        //   var auth = r.credential!;

        //   var cred = await GoogleAuthProvider.credential(
        //       accessToken: auth., idToken: auth.idToken);

        //   // var r = FirebaseAuth.instance.signInWithCredential(cred);
        // }
      }
    } catch (e,stack) {
      print(e);
      print(stack);
    }


  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign in "),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : ElevatedButton(
                child: Text("Sign In With Google"),
                onPressed: () async {
                  await signIn();
                },
              ),
      ),
    );
  }
}
