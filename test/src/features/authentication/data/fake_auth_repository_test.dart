import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const testEmail = 'test@test.com';
  const testPassword = '1234';
  final testUser = AppUser(
    uid: testEmail.split('').reversed.join(),
    email: testEmail,
  );
  FakeAuthRepository makeAuthRepository() => FakeAuthRepository(
        addDelay: false,
      );

  group('FakeAuthRepository', () {
    test('currentUser is null by default', () {
      final authRepository = makeAuthRepository();
      // register this upfront - will be called even if the test throw an exception later
      addTearDown(authRepository.dispose);
      //initial value is null
      expect(authRepository.currentUser, null);
      //initial value is null
      expect(authRepository.authStateChanges(), emits(null));
    });

    test('currentUser is not null after sign in', () async {
      final authRepository = makeAuthRepository();
      // register this upfront - will be called even if the test throw an exception later
      addTearDown(authRepository.dispose);
      await authRepository.signInWithEmailAndPassword(
        testEmail,
        testPassword,
      );
      expect(authRepository.currentUser, testUser);
      expect(authRepository.authStateChanges(), emits(testUser));
    });

    test('currentUser is not null after register', () async {
      final authRepository = makeAuthRepository();
      // register this upfront - will be called even if the test throw an exception later
      addTearDown(authRepository.dispose);
      await authRepository.createUserWithEmailAndPassword(
        testEmail,
        testPassword,
      );
      expect(authRepository.currentUser, testUser);
      expect(authRepository.authStateChanges(), emits(testUser));
    });

    test('currentUser is not null after sign out', () async {
      final authRepository = makeAuthRepository();
      // register this upfront - will be called even if the test throw an exception later
      addTearDown(authRepository.dispose);
      await authRepository.signInWithEmailAndPassword(
        testEmail,
        testPassword,
      );

      //emitsInOrder is used to test the stream of values, but not intuitive
      expect(
          authRepository.authStateChanges(),
          //we are using BehaviorSubject,
          emitsInOrder([
            testUser, //after signIn, // latest value from signInWithEmailAndPassword()
            null, //after signOut, // upcoming value from signOut()
          ]));

      await authRepository.signOut();

      expect(authRepository.currentUser, null);
    });

    test('sign in after dispoae throws error', () async {
      final authRepository = makeAuthRepository();
      // register this upfront - will be called even if the test throw an exception later
      addTearDown(authRepository.dispose);
      authRepository.dispose();

      expect(
          () => authRepository.signInWithEmailAndPassword(
                testEmail,
                testPassword,
              ),
          throwsStateError);

      //currentUser is not null after sign out
      expect(authRepository.currentUser, null);
    });
  });
}
