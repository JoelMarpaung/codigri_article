// registration_event.dart
part of 'registration_bloc.dart';

abstract class RegistrationEvent {
  const RegistrationEvent();
}

class RegistrationSubmit extends RegistrationEvent {
  final User user;

  RegistrationSubmit({required this.user});
}
