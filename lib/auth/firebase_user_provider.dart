import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class ComidaDeVerdadeFirebaseUser {
  ComidaDeVerdadeFirebaseUser(this.user);
  User user;
  bool get loggedIn => user != null;
}

ComidaDeVerdadeFirebaseUser currentUser;
bool get loggedIn => currentUser?.loggedIn ?? false;
Stream<ComidaDeVerdadeFirebaseUser> comidaDeVerdadeFirebaseUserStream() =>
    FirebaseAuth.instance
        .authStateChanges()
        .debounce((user) => user == null && !loggedIn
            ? TimerStream(true, const Duration(seconds: 1))
            : Stream.value(user))
        .map<ComidaDeVerdadeFirebaseUser>(
            (user) => currentUser = ComidaDeVerdadeFirebaseUser(user));
