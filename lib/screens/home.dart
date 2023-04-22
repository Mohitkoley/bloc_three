import 'package:bloc_three/Cubit/cubit/internet_cubit.dart';
import 'package:bloc_three/blocs/bloc/internet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatelessWidget {
  const Home({super.key});

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
              return const Center(
                child: Text("Connected"),
              );
            case InternetStates.dissconnected:
              return const Center(
                child: Text("Disconnected"),
              );
            default:
              return const Center(
                child: Text("No Internet "),
              );
          }
        },
      ),
    );
  }
}
