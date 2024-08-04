// ignore_for_file: empty_catches

import 'dart:developer';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../domain/usecases/auth_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@lazySingleton
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthUseCase _authUsecase;

  String? email;
  String? password;
  String? name;
  bool isUserValid = false;
  AuthBloc({required AuthUseCase authUseCase})
      : _authUsecase = authUseCase,
        super(AuthInitial()) {
    on<AuthEvent>((event, emit) {});
    on<CheckUserAuthEvent>(handleCheckUserAuthState);
    on<LogOutAuthEvent>(handleSignOut);
    on<ShowHideBottomBarEvent>(handleShowHideBottomBar);
    on<SignUpEvent>(handleSignUp);
    on<VerifyOtpEvent>(handleVerifyOtp);
    on<ResendOtpEvent>(handleResendOtp);
    on<SignInEvent>(handleSignIn);
    on<SignInWithGoogleEvent>(handleSignInWithGoogle);
    on<SignInWithAppleEvent>(handleSignInWithApple);
    on<UpdateBottomNavigationIndex>(handleUpdateBottomNavigationIndex);

    on<ForgotPasswordEvent>(handleForgotPassword);
    on<ConfirmPasswordEvent>(handleConfirmPassword);
    on<GetRefreshTokenEvent>(handleRefreshToken);
  }

  void handleUpdateBottomNavigationIndex(
      UpdateBottomNavigationIndex event, Emitter<AuthState> emit) async {
    emit(UpdatedNavigationState(event.index, DateTime.now()));
  }

  void handleSignOut(LogOutAuthEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoadingState());
      await _authUsecase.handleSignOut();
      emit(UnAuthenticatedAuthState());
    } catch (e) {
      emit(AuthErrorState(e.toString()));
    }
  }

  void handleCheckUserAuthState(
      CheckUserAuthEvent event, Emitter<AuthState> emit) async {
    try {
      var result = await _authUsecase.handleCheckUserAuthState();
      if (result) {
        isUserValid = true;
        emit(const AuthSuccessState());
      } else {
        isUserValid = false;
        emit(UnAuthenticatedAuthState());
      }
    } catch (e) {
      emit(AuthErrorState(e.toString()));
    }
  }

  void handleShowHideBottomBar(
      ShowHideBottomBarEvent event, Emitter<AuthState> emit) {
    emit(ShowHideBottomBarState(event.isShow, DateTime.now()));
  }

  void handleSignUp(SignUpEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoadingState());
      email = event.email;
      password = event.password;
      name = event.name;
      await _authUsecase.handleSignUp({
        "name": event.name,
        "email": event.email,
        "password": event.password
      });
      emit(RegistrationSuccessState());
    } catch (e) {
      log(e.toString());
      var msg = "Some error occurred! Please try again later.";
      if (e is UsernameExistsException) {
        msg =
            "Oops! It looks like you already have an account with us. If you're having trouble accessing it, please try logging in instead. If you need assistance, feel free to reach out to our support team for help.";
      } else if (e is NotAuthorizedServiceException) {
        msg =
            "Oops! It seems like the password entered is incorrect. Double-check and try again.";
      } else if (e is InvalidPasswordException) {
        msg = e.message;
      }
      emit(AuthErrorState(msg));
    }
  }

  void handleSignIn(SignInEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoadingState());
      bool success = await _authUsecase
          .handleSignIn({"email": event.email, "password": event.password});
      if (success) {
        emit(const AuthSuccessState());
      } else {
        email = event.email;
        password = event.password;
        emit(RegistrationSuccessState());
      }
    } catch (e) {
      var msg = "Some error occurred! Please try again later.";
      if (e is UserNotFoundException) {
        msg =
            "Sorry, but we couldn't find the user you're looking for. Please consider signing up to create a new account";
      } else if (e is NotAuthorizedServiceException) {
        msg =
            "Oops! It seems like the password entered is incorrect. Double-check and try again.";
      }
      emit(AuthErrorState(msg));
    }
  }

  void handleSignInWithApple(
      SignInWithAppleEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoadingState());
      await _authUsecase.handleSignInWithApple();
      emit(const AuthSuccessState(googleLogin: true));
    } catch (e) {
      var msg = "Some error occurred! Please try again later!";
      if (e is UserCancelledException) {
        msg = "";
      }
      emit(AuthErrorState(msg));
    }
  }

  void handleSignInWithGoogle(
      SignInWithGoogleEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoadingState());
      await _authUsecase.handleSignInWithGoogle();
      emit(const AuthSuccessState(googleLogin: true));
    } catch (e) {
      var msg = "Some error occurred! Please try again later!";
      if (e is UserCancelledException) {
        msg = "";
      }
      emit(AuthErrorState(msg));
    }
  }

  void handleVerifyOtp(VerifyOtpEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoadingState());
      await _authUsecase.handleConfirmSignUp({
        "email": email,
        "code": event.otp,
        "password": password,
        "name": name ?? "",
      });
      email = "";
      password = "";
      emit(OtpSuccessState());
    } catch (e) {
      log(e.toString());
      var msg = "Some error occurred. Please try again later.";
      if (e is CodeMismatchException) {
        msg = e.message;
      } else if (e is NotAuthorizedServiceException) {
        msg =
            "Oops! It seems like the password entered is incorrect. Double-check and try again.";
      }
      emit(AuthErrorState(msg));
    }
  }

  void handleResendOtp(ResendOtpEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoadingState());
      await _authUsecase.handleResendCode(email!);
      emit(ResendOtpSuccessState());
    } catch (e) {
      var msg = "Some error occurred. Please try again later.";
      if (e is AuthException) {
        msg = e.message;
      }
      emit(AuthErrorState(msg));
    }
  }

  void handleForgotPassword(
      ForgotPasswordEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoadingState());
      await _authUsecase.handleForgotPassword(event.email);
      emit(ForgotPasswordSuccessState());
    } catch (e) {
      var msg = "Some error occurred. Please try again later.";
      if (e is AuthException) {
        msg = e.message;
      }
      emit(AuthErrorState(msg));
    }
  }

  void handleConfirmPassword(
      ConfirmPasswordEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoadingState());
      await _authUsecase.handleConfirmPassword({
        "email": event.email,
        "password": event.password,
        "code": event.code
      });
      emit(ConfirmPasswordSuccessState());
    } catch (e) {
      var msg = "Some error occurred. Please try again later.";
      if (e is AuthException) {
        msg = e.message;
      }
      emit(AuthErrorState(msg));
    }
  }

  void handleRefreshToken(
      GetRefreshTokenEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoadingState());
      await _authUsecase.handleRefreshToken();
      emit(GetRefreshTokenSuccessState());
    } catch (e) {
      var msg = "Some error occurred. Please try again later.";
      if (e is AuthException) {
        msg = e.message;
      }
      emit(AuthErrorState(msg));
    }
  }
}
