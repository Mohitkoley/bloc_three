import 'package:bloc_three/Cubit/cubit/internet_cubit.dart';
import 'package:bloc_three/firebase_options.dart';
import 'package:bloc_three/screens/Sign_in/phone_auth/cubit/phone_auth_cubit.dart';
import 'package:bloc_three/screens/home.dart';
import 'package:bloc_three/screens/welcome/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PhoneAuthCubit>(create: (context) => PhoneAuthCubit()),
        BlocProvider<InternetCubit>(create: (context) => InternetCubit())
      ],
      child: BlocBuilder<PhoneAuthCubit, PhoneAuthCubitState>(
        builder: (context, state) {
          if (state is AuthLoggedOutState) {
            return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Flutter Demo',
                theme: ThemeData(
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                  primarySwatch: Colors.blue,
                  inputDecorationTheme: InputDecorationTheme(
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 3, color: Colors.deepPurple[300]!),
                    ),
                    border: const OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 3, color: Colors.amberAccent),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 3, color: Colors.amberAccent),
                    ),
                  ),
                ),
                home: const WelcomeScreen(),
                routes: {
                  Home.routeName: (context) => const Home(),
                });
          }

          return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: ThemeData(
                visualDensity: VisualDensity.adaptivePlatformDensity,
                primarySwatch: Colors.blue,
                inputDecorationTheme: InputDecorationTheme(
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(width: 3, color: Colors.deepPurple[300]!),
                  ),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(width: 3, color: Colors.amberAccent),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(width: 3, color: Colors.amberAccent),
                  ),
                ),
              ),
              home: const Home(),
              routes: {
                Home.routeName: (context) => const Home(),
              });
        },
      ),
    );
  }
}
