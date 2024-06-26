import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//* use AsyncValue<void> to make the controller more robust and handle different states, but to simplify the code, we will remove the type and use AsyncValue
class AccountScreenController extends StateNotifier<AsyncValue> {
  AccountScreenController({required this.authRepository})
      : super(const AsyncValue.data(null));
  final AuthRepository authRepository;

  Future<bool> signOut() async {
    //*this is the old way of doing it, we changed to use AsyncValue.guard
    // try {
    //   state = const AsyncValue.loading();
    //   await authRepository.signOut();
    //   state = const AsyncValue.data(null);

    //   return true;
    // } catch (e, st) {
    //   state = AsyncValue.error(e, st);
    //   return false;
    // }

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => authRepository.signOut());
    //* this is another way to do it
    // return state.maybeWhen(
    //   data: (_) => true,
    //   orElse: () => false,
    // );
    return state.hasError == false;
  }
}

final accountScreenControllerProvider =
    StateNotifierProvider.autoDispose<AccountScreenController, AsyncValue>(
        (ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AccountScreenController(
    authRepository: authRepository,
  );
});

//Note: This is the same as the above controller but with ChangeNotifier.
class AccountScreenController2 extends ChangeNotifier {
  AccountScreenController2({required this.authRepository});

  final AuthRepository authRepository;

  // bool _isLoading = false;
  // bool get isLoading => _isLoading;

  // String _error = '';

  late AsyncValue state;

  Future<void> signOut() async {
    try {
      // _isLoading = true;
      state = const AsyncValue.loading();
      notifyListeners();
      await authRepository.signOut();
      // _isLoading = false;
      state = const AsyncValue.data(null);
      notifyListeners();
    } catch (e, st) {
      // _isLoading = false;
      state = AsyncValue.error(e, st);
      notifyListeners();
      // rethrow;
    }
  }
}
