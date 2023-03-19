part of 'registration_bloc.dart';

abstract class RegistrationState {
  const RegistrationState();
}

class RegistrationInitial extends RegistrationState {}

class RegistrationInProgress extends RegistrationState {}

class RegistrationSuccess extends RegistrationState {}

class RegistrationFailure extends RegistrationState {
  final String error;

  RegistrationFailure({required this.error});
}
