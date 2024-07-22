//optionally we can use @Timeout(Duration(milliseconds: 500)) to set a timeout for the test

import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_controller.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../mocks.dart';

void main() {
  group(
    'submit',
    () {
      //sign in
      test(
        '''
  Given formType is signIn
  When signInWitEmailAndPassword succeeds
  Then return true
  And state is AsyncData
  ''',
        () async {
          //setup
          final authRepository = MockAuthRepository();
          when(() => authRepository.signInWithEmailAndPassword(
              testEmail, testPassword)).thenAnswer((_) => Future.value());

          final controller = EmailPasswordSignInController(
              authRepository: authRepository,
              formType: EmailPasswordSignInFormType.signIn);

          expectLater(
              controller.stream,
              emitsInOrder([
                EmailPasswordSignInState(
                  formType: EmailPasswordSignInFormType.signIn,
                  //both the code below works with or without <void>, doesn't matter here.
                  value: const AsyncValue.loading(),
                  // value: const AsyncLoading<void>(),
                ),
                EmailPasswordSignInState(
                  formType: EmailPasswordSignInFormType.signIn,
                  value: const AsyncValue.data(null),
                  // value: const AsyncData<void>(null),
                ),
              ]));
          //act
          final result = await controller.submit(testEmail, testPassword);
          //assert
          expect(result, true);

          //this code here must have the type <void> to work
          expect(controller.state.value, const AsyncValue<void>.data(null));
        },
        timeout: const Timeout(Duration(milliseconds: 500)),
      );

      test(
        '''
  Given formType is signIn
  When signInWitEmailAndPassword fails
  Then return false
  And state is AsyncError
  ''',
        () async {
          //setup
          final authRepository = MockAuthRepository();
          final exception = Exception('Connection failed');

          when(() => authRepository.signInWithEmailAndPassword(
              testEmail, testPassword)).thenThrow(exception);

          final controller = EmailPasswordSignInController(
              authRepository: authRepository,
              formType: EmailPasswordSignInFormType.signIn);

          expectLater(
              controller.stream,
              emitsInOrder([
                EmailPasswordSignInState(
                  formType: EmailPasswordSignInFormType.signIn,
                  //both the code below works with or without <void>, doesn't matter here.
                  value: const AsyncValue.loading(),
                  // value: const AsyncLoading<void>(),
                ),
                predicate<EmailPasswordSignInState>((state) {
                  expect(state.formType, EmailPasswordSignInFormType.signIn);
                  expect(state.value.hasError, true);
                  return true;
                })
              ]));
          //act
          final result = await controller.submit(testEmail, testPassword);
          //assert
          expect(result, false);
        },
        timeout: const Timeout(Duration(milliseconds: 500)),
      );

//register
      test(
        '''
  Given formType is register
  When createUserWitEmailAndPassword succeeds
  Then return true
  And state is AsyncData
  ''',
        () async {
          //setup
          final authRepository = MockAuthRepository();
          when(() => authRepository.createUserWithEmailAndPassword(
              testEmail, testPassword)).thenAnswer((_) => Future.value());

          final controller = EmailPasswordSignInController(
              authRepository: authRepository,
              formType: EmailPasswordSignInFormType.register);

          expectLater(
              controller.stream,
              emitsInOrder([
                EmailPasswordSignInState(
                  formType: EmailPasswordSignInFormType.register,
                  //both the code below works with or without <void>, doesn't matter here.
                  value: const AsyncValue.loading(),
                  // value: const AsyncLoading<void>(),
                ),
                EmailPasswordSignInState(
                  formType: EmailPasswordSignInFormType.register,
                  value: const AsyncValue.data(null),
                  // value: const AsyncData<void>(null),
                ),
              ]));
          //act
          final result = await controller.submit(testEmail, testPassword);
          //assert
          expect(result, true);

          //this code here must have the type <void> to work
          expect(controller.state.value, const AsyncValue<void>.data(null));
        },
        timeout: const Timeout(Duration(milliseconds: 500)),
      );

      test(
        '''
  Given formType is register
  When createUserWitEmailAndPassword fails
  Then return false
  And state is AsyncError
  ''',
        () async {
          //setup
          final authRepository = MockAuthRepository();
          final exception = Exception('Connection failed');

          when(() => authRepository.createUserWithEmailAndPassword(
              testEmail, testPassword)).thenThrow(exception);

          final controller = EmailPasswordSignInController(
              authRepository: authRepository,
              formType: EmailPasswordSignInFormType.register);

          expectLater(
              controller.stream,
              emitsInOrder([
                EmailPasswordSignInState(
                  formType: EmailPasswordSignInFormType.register,
                  //both the code below works with or without <void>, doesn't matter here.
                  value: const AsyncValue.loading(),
                  // value: const AsyncLoading<void>(),
                ),
                predicate<EmailPasswordSignInState>((state) {
                  expect(state.formType, EmailPasswordSignInFormType.register);
                  expect(state.value.hasError, true);
                  return true;
                })
              ]));
          //act
          final result = await controller.submit(testEmail, testPassword);
          //assert
          expect(result, false);
        },
        timeout: const Timeout(Duration(milliseconds: 500)),
      );
    },
  );

  group('updateFormType', () {
    test('''
  Given formType is signIn
  When called with register
  Then state formType is register
  ''', () {
      //setup
      final controller = EmailPasswordSignInController(
          authRepository: MockAuthRepository(),
          formType: EmailPasswordSignInFormType.signIn);

      //act
      controller.updateFormType(EmailPasswordSignInFormType.register);

      //assert
      expect(controller.state.formType, EmailPasswordSignInFormType.register);
    });
  });
}
