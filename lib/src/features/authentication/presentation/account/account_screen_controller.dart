import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as flutter_riverpod;

// import 'package:riverpod_annotation/riverpod_annotation.dart';

// part 'account_screen_controller.g.dart';

// @riverpod
// class AccountScreenController extends _$AccountScreenController {
//   @override
//   FutureOr<void> build() {
//     // nothing to do
//   }
//   Future<void> signOut() async {
//     final authRepository = ref.read(authRepositoryProvider);
//     state = const AsyncLoading();
//     state = await AsyncValue.guard(() => authRepository.signOut());
//   }
// }

//Type Annotations and Type Errors during tests
//* use AsyncValue<void> to make the controller more robust and handle different states, but to simplify the code, we can remove the type and use AsyncValue, but got error in test
class AccountScreenController
    extends flutter_riverpod.StateNotifier<flutter_riverpod.AsyncValue<void>> {
  AccountScreenController({required this.authRepository})
      : super(const flutter_riverpod.AsyncValue.data(
            null)); // use AsyncData rather than AsyncValue.data
  final AuthRepository authRepository;

  //   //* in some case we may want tor return a boolean value
  // Future<bool> signOut() async {
  //   state = const flutter_riverpod
  //       .AsyncValue.loading(); // use AsyncLoading rather than AsyncValue.loading
  //   state =
  //       await flutter_riverpod.AsyncValue.guard(() => authRepository.signOut());
  //   //* this is another way to do it
  //   // return state.maybeWhen(
  //   //   data: (_) => true,
  //   //   orElse: () => false,
  //   // );
  //   return state.hasError == false;
  // }

  Future<void> signOut() async {
    state = const flutter_riverpod
        .AsyncValue.loading(); // use AsyncLoading rather than AsyncValue.loading
    state =
        await flutter_riverpod.AsyncValue.guard(() => authRepository.signOut());
  }
}

final accountScreenControllerProvider =
    flutter_riverpod.StateNotifierProvider.autoDispose<AccountScreenController,
        flutter_riverpod.AsyncValue<void>>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AccountScreenController(authRepository: authRepository);
});


// When assigning the state, you can use AsyncValue subclasses:

// AsyncValue.data is the same as AsyncData
// AsyncValue.loading is the same as AsyncLoading
// AsyncValue.error is the same as AsyncError

//Note: This is the same as the above controller but with ChangeNotifier.
// class AccountScreenController2 extends ChangeNotifier {
//   AccountScreenController2({required this.authRepository});

//   final AuthRepository authRepository;

//   // bool _isLoading = false;
//   // bool get isLoading => _isLoading;

//   // String _error = '';

//   late AsyncValue state;

//   Future<void> signOut() async {
//     try {
//       // _isLoading = true;
//       state = const AsyncValue.loading();
//       notifyListeners();
//       await authRepository.signOut();
//       // _isLoading = false;
//       state = const AsyncValue.data(null);
//       notifyListeners();
//     } catch (e, st) {
//       // _isLoading = false;
//       state = AsyncValue.error(e, st);
//       notifyListeners();
//       // rethrow;
//     }
//   }
// }
