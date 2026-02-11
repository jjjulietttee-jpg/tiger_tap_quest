import 'package:flutter_bloc/flutter_bloc.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<SplashEvent>(_onEvent);
  }

  void _onEvent(SplashEvent event, Emitter<SplashState> emit) {}
}

abstract class SplashEvent {}

abstract class SplashState {}

class SplashInitial extends SplashState {}
