import 'package:authentication/bloc/registration_bloc.dart';
import 'package:authentication/page/registration_form.dart';
import 'package:core/common/util.dart';
import 'package:core/route/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider(
          create: (_) => di.locator<RegistrationBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Codigri - Article',
        home: const RegistrationForm(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case registerPage:
              return MaterialPageRoute(
                  builder: (_) => const RegistrationForm());
            default:
              return MaterialPageRoute(builder: (_) {
                return const Scaffold(
                  body: Center(
                    child: Text('Page not found :('),
                  ),
                );
              });
          }
        },
      ),
    );
  }
}
