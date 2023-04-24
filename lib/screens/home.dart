import 'package:bloc_three/Cubit/cubit/internet_cubit.dart';
import 'package:bloc_three/screens/Sign_in/phone_auth/cubit/phone_auth_cubit.dart';
import 'package:bloc_three/screens/welcome/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatelessWidget {
  const Home({super.key});
  static String routeName = "Home";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Dummy"),
      ),
      body: BlocConsumer<InternetCubit, InternetStates>(
        listener: (context, state) {
          if (state == InternetStates.connected) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("internet Connected "),
              backgroundColor: Colors.green,
            ));
          } else if (state == InternetStates.dissconnected) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("internet DissConnected "),
              backgroundColor: Colors.red,
            ));
          }
        },
        builder: (context, state) {
          switch (state) {
            case InternetStates.connected:
              return Center(
                child: Column(
                  children: [
                    LogOut(),
                    Text("Connected"),
                  ],
                ),
              );
            case InternetStates.dissconnected:
              return Center(
                child: Column(
                  children: [
                    LogOut(),
                    Text("Disconnected"),
                  ],
                ),
              );
            default:
              return Center(
                child: Column(
                  children: [
                    LogOut(),
                    Text("No Internet "),
                  ],
                ),
              );
          }
        },
      ),
    );
  }
}

class LogOut extends StatelessWidget {
  const LogOut({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhoneAuthCubit, PhoneAuthCubitState>(
      builder: (context, state) {
        return ElevatedButton(
            onPressed: () {
              BlocProvider.of<PhoneAuthCubit>(context).signOut();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => WelcomeScreen()),
                  (route) => false);
            },
            child: Text("Log Out"));
      },
    );
  }
}
