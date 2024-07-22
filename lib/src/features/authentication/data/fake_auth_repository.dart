import 'package:ecommerce_app/src/utils/delay.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:ecommerce_app/src/utils/in_memory_store.dart';

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

  @override
  Future<void> signOut() async {
    await delay(addDelay);
    //*this is to test the error state
    // throw Exception('Error signing out');
    _authState.value = null;
  }

  void dispose() => _authState.close();

  void _createNewUser(String email) {
    // create new user
    _authState.value = AppUser(
      uid: email.split('').reversed.join(),
      email: email,
      // password: password,
    );

    // // register it
    // _users.add(user);
    // // update the auth state
    // _authState.value = user;
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  // //to use this, run the app with: flutter run --dart-define=userFakeRepos=true
  // const isFake = String.fromEnvironment('userFakeRepos') == 'true';
  return FakeAuthRepository();
});

final authStateChangesProvider = StreamProvider.autoDispose<AppUser?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges();
});
