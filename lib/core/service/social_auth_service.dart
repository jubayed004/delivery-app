import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class SocialAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ফায়ারবেসের সাহায্যে ফেসবুক লগইন
  Future<UserCredential?> signInWithFacebook() async {
    try {
      // ফেসবুক থেকে লগইন ট্রিগার করা
      final LoginResult result = await FacebookAuth.instance.login();

      // লগইন সফল হলে ফায়ারবেসের সাথে লিঙ্ক করা
      if (result.status == LoginStatus.success) {
        // ফেসবুকের অ্যাক্সেস টোকেন পাওয়া
        final OAuthCredential credential = FacebookAuthProvider.credential(
            result.accessToken!.tokenString);

        // ফায়ারবেসে সাইন-ইন করা
        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        print("Facebook Login Successful: ${userCredential.user?.displayName}");
        return userCredential;
      } else {
        print('Facebook Login Failed: ${result.message}');
        return null; // লগইন ফেইল বা ক্যানসেল হয়েছে
      }
    } catch (e) {
      print('Facebook Auth Error: $e');
      return null;
    }
  }

  // ফায়ারবেসের সাহায্যে গুগল লগইন (যদি google_sign_in প্যাকেজ ইন্সটল করা থাকে)
  /*
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final google_sign_in.GoogleSignInAccount? googleUser = 
          await google_sign_in.GoogleSignIn().signIn();
      
      if (googleUser == null) return null; // ব্যবহারকারী সাইন-ইন বাতিল করেছেন

      final google_sign_in.GoogleSignInAuthentication googleAuth = 
          await googleUser.authentication;
          
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = 
          await _auth.signInWithCredential(credential);
          
      print("Google Login Successful: ${userCredential.user?.displayName}");
      return userCredential;
    } catch (e) {
      print('Google Auth Error: $e');
      return null;
    }
  }
  */

  // লগআউট
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await FacebookAuth.instance.logOut();
      // await google_sign_in.GoogleSignIn().signOut();
      print("Successfully logged out");
    } catch (e) {
      print("Logout Error: $e");
    }
  }
}
