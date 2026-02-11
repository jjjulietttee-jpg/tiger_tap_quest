import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeEvent>(_onEvent);
  }

  void _onEvent(HomeEvent event, Emitter<HomeState> emit) {}
}

abstract class HomeEvent {}

abstract class HomeState {}

class HomeInitial extends HomeState {}
