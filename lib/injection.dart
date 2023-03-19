import 'package:get_it/get_it.dart';
import 'package:authentication/bloc/registration_bloc.dart';

final locator = GetIt.instance;

void init() {
  //bloc movie
  locator.registerFactory(
    () => RegistrationBloc(),
  );
}
