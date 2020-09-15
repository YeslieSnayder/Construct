import 'package:construct/model/user.dart';
import 'package:construct/services/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User> signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return User.fromFirebase(user);
    } catch (e) {
      print('ERROR (auth.dart/signInWithEmailAndPassword): $e');
      return null;
    }
  }

  Future<User> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final AuthResult authResult =
          await _auth.signInWithCredential(credential);
      final FirebaseUser user = authResult.user;

      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);

      return await DBService().addOrUpdateUser(User.fromFirebase(user));
    } catch (e) {
      print('ERROR (auth.dart/signInWithGoogle): $e');
      return null;
    }
  }

  Future<User> registerWithEmailAndPassword(String email, String password,
      String userName, String phoneNumber, String org) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;

      UserUpdateInfo info = UserUpdateInfo();
      info.displayName = userName;
      await user.updateProfile(info);
      _auth = FirebaseAuth.instance;

      User localUser = await this.user;
      localUser.number = phoneNumber;
      localUser.organization = await DBService().getOrganization(org);

      return await DBService().addOrUpdateUser(localUser);
    } catch (e) {
      print('ERROR (auth.dart/registerWithEmailAndPassword): $e');
      return null;
    }
  }

  Future logOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
    } catch (e) {
      print('ERROR (auth.dart/logOut): $e');
    }
  }

  Future<User> get user async => User.fromFirebase(await _auth.currentUser());

  Stream<User> get currentUser => _auth.onAuthStateChanged.map(
      (FirebaseUser user) => user != null ? User.fromFirebase(user) : null);
}
