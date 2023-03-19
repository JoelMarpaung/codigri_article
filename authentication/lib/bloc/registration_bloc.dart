import 'package:core/common/constant.dart';
import 'package:core/model/user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
part 'registration_event.dart';
part 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  RegistrationBloc() : super(RegistrationInitial()) {
    on<RegistrationSubmit>(_onRegistrationSubmit);
  }

  Future<void> _onRegistrationSubmit(
      RegistrationSubmit event, Emitter<RegistrationState> emit) async {
    emit(RegistrationInProgress());

    try {
      final response = await _registerUser(event.user);

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(RegistrationSuccess());
      } else {
        final error = json.decode(response.body);
        emit(RegistrationFailure(error: error['message']));
      }
    } catch (error) {
      emit(RegistrationFailure(error: error.toString()));
    }
  }

  Future<http.Response> _registerUser(User user) async {
    final uri = Uri.parse(register);
    final request = http.MultipartRequest('POST', uri);

    request.fields['username'] = user.username;
    request.fields['password'] = user.password;
    request.fields['first_name'] = user.firstName;
    request.fields['last_name'] = user.lastName;
    request.fields['telephone'] = user.telephone;
    request.fields['address'] = user.address;
    request.fields['city'] = user.city;
    request.fields['province'] = user.province;
    request.fields['country'] = user.country;

    if (kIsWeb) {
      request.files.add(http.MultipartFile.fromBytes(
          'profile_image', user.profileImageByte as List<int>,
          filename: user.profileImage, contentType: MediaType('*', '*')));
    }

    return await request
        .send()
        .then((response) => http.Response.fromStream(response));
  }
}
