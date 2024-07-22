// forces any tests to be interrupted if they take more than one second
// ignore: library_annotations
@Timeout(Duration(milliseconds: 500))
import 'package:ecommerce_app/src/features/authentication/presentation/account/account_screen_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  //Test lifecycle methods - drawbacks
  //If you put a lot of code inside the test lifecycle methods, you may introduce some side effects, where some objects or state becomes unintentionally shared across different tests.
  late MockAuthRepository mockAuthRepo;
  late AccountScreenController controller;
  // this is called before each test
  setUp(() {
    mockAuthRepo = MockAuthRepository();
    controller = AccountScreenController(
      authRepository: mockAuthRepo,
    );
  });

  group('AccountScreenController', () {
    test('initial state is AsyncValue.data(null)', () {
      expect(controller.state, const AsyncValue<void>.data(null));
    });

    test('initial state is AsyncValue.data', () {
      //this is just to confirm the signOut function is never called
      verifyNever(mockAuthRepo.signOut);
      expect(controller.state, const AsyncData<void>(null));
    });

//https://codewithandrea.com/articles/async-tests-streams-flutter/
//https://codewithandrea.com/articles/unit-test-async-notifier-riverpod/
    test(
      'signOut success',
      () async {
        // setup
        //stubbing a mock
        when(mockAuthRepo.signOut).thenAnswer(
          (_) => Future.value(),
        );

        //we can use a stream to listen to the state changes, streams are async, so we need to use expectLater and move the code before the await call
        expectLater(
            controller.stream,
            //emitsInOrder is an asynchronous matcher, used to check if the stream emits the values in the order specified
            emitsInOrder(const [
              AsyncLoading<void>(),
              AsyncData<void>(null),
            ]));

        // run
        await controller.signOut();
        // verify
        verify(mockAuthRepo.signOut).called(1);

        //this code works but if we remove  state = const flutter_riverpod.AsyncValue.loading(); we will still get success test result
        //we want to test how the state changes over time, from loading state to success state, we can't do with controller.state
        expect(controller.state, const AsyncData<void>(null));

        // //we can use a stream to listen to the state changes, streams are async, so we need to use emitsInOrder matcher
        // //but this code will fail, stream emit values over time, by the time we call expect, the stream has already emitted the values, both loading and success state. we should use expectLater and move the code before the await call
        // expect(
        //   controller.stream,
        //   emitsInOrder([const AsyncLoading<void>(), const AsyncData<void>(null)]),
        // );
      },

      //Add a timeout to the test to avoid waiting for the default timeout of 300ms
    );
  });

  test(
    'signOut failure',
    () async {
      // setup
      final exception = Exception('Connection failed');
      when(mockAuthRepo.signOut).thenThrow(exception);

      expectLater(
          controller.stream,
          emitsInOrder([
            const AsyncLoading<void>(),
            // //this code with AsyncError will fail because we can match the exception, but not the stack trace
            // AsyncError<void>(exception, StackTrace.current),

            // //either this AsyncError or the one below will work
            // predicate<AsyncError<void>>(
            //   (error) => error.error == exception,
            // ),

            predicate<AsyncValue<void>>(
              (value) {
                expect(value.hasError, true);
                return true;
              },
            ),
          ]));

      // run
      await controller.signOut();
      // verify
      verify(mockAuthRepo.signOut).called(1);

      // // this will fail because we can match the exception, but not the stack trace
      // expect(controller.state, AsyncError<void>(exception, StackTrace.current));

      // just check if the state has an error
      expect(controller.state.hasError, true);
      // or use a type matcher without checking the value, isA<T> is a generic type matcher, useful to check if a valu is of a certain type.
      expect(controller.state, isA<AsyncError>());
    },
  );
}
