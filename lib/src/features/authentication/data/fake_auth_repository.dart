import 'package:ecommerce_app/src/utils/delay.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:ecommerce_app/src/utils/in_memory_store.dart';

//this is just to show one of the structure, it's not neccessary to create an abstract class, and we haven't implement firebase backend yet
abstract class AuthRepository {
  Stream<AppUser?> authStateChanges();
  AppUser? get currentUser;
  Future<void> signInWithEmailAndPassword(String email, String password);
  Future<void> createUserWithEmailAndPassword(String email, String password);
  Future<void> signOut();
}

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({this.addDelay = true});
  final bool addDelay;

  final _authState = InMemoryStore<AppUser?>(null);

  @override
  Stream<AppUser?> authStateChanges() => _authState.stream;

  @override
  AppUser? get currentUser => _authState.value;

  // //TODO
  // // List to keep track of all user accounts
  // final List<FakeAppUser> _users = [];

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await delay(addDelay);
    _createNewUser(email);
  }

  @override
  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    await delay(addDelay);
    _createNewUser(email);
  }

  // //TODO
  // Future<void> signInWithEmailAndPassword(String email, String password) async {
  //   await delay(addDelay);
  //   // check the given credentials agains each registered user
  //   for (final u in _users) {
  //     // matching email and password
  //     if (u.email == email && u.password == password) {
  //       _authState.value = u;
  //       return;
  //     }
  //     // same email, wrong password
  //     if (u.email == email && u.password != password) {
  //       throw WrongPasswordException();
  //     }
  //   }
  //   throw UserNotFoundException();
  // }

  // Future<void> createUserWithEmailAndPassword(
  //     String email, String password) async {
  //   await delay(addDelay);
  //   // check if the email is already in use
  //   for (final u in _users) {
  //     if (u.email == email) {
  //       throw EmailAlreadyInUseException();
  //     }
  //   }
  //   // minimum password length requirement
  //   if (password.length < 8) {
  //     throw WeakPasswordException();
  //   }
  //   // create new user
  //   _createNewUser(email, password);
  // }

  @override
  Future<void> signOut() async {
    await delay(addDelay);
    //*this is to test the error state
    // throw Exception('Error signing out');
    _authState.value = null;
  }

  void dispose() => _authState.close();

  void _createNewUser(String email) {
    _authState.value = AppUser(
      uid: email.split('').reversed.join(),
      email: email,
    );
  }

  // //TODO
  // void _createNewUser(String email, String password) {
  //   // create new user
  //   final user = FakeAppUser(
  //     uid: email.split('').reversed.join(),
  //     email: email,
  //     password: password,
  //   );
  //   // register it
  //   _users.add(user);
  //   // update the auth state
  //   _authState.value = user;
  // }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  // //*to use this, run the app with: flutter run --dart-define=userFakeRepos=true
  // const isFake = String.fromEnvironment('userFakeRepos') == 'true';
  return FakeAuthRepository();
});

final authStateChangesProvider = StreamProvider.autoDispose<AppUser?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges();
});

// //TODO: use code generation to generate provider
// @Riverpod(keepAlive: true)
// FakeAuthRepository authRepository(AuthRepositoryRef ref) {
//   final auth = FakeAuthRepository();
//   ref.onDispose(() => auth.dispose());
//   return auth;
// }

// @Riverpod(keepAlive: true)
// Stream<AppUser?> authStateChanges(AuthStateChangesRef ref) {
//   final authRepository = ref.watch(authRepositoryProvider);
//   return authRepository.authStateChanges();
// }