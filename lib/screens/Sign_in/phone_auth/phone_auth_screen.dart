import 'dart:ui';

import 'package:bloc_three/screens/Sign_in/phone_auth/bloc/phone_auth_bloc.dart';
import 'package:bloc_three/screens/Sign_in/phone_auth/cubit/phone_auth_cubit.dart';
import 'package:bloc_three/screens/Sign_in/phone_auth/verify_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PhoneAuthScreen extends StatefulWidget {
  PhoneAuthScreen({super.key});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final TextEditingController _textController = TextEditingController();

  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: 0);

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          foregroundColor: Colors.blue,
          title: const Text("Phone Auth"),
          flexibleSpace: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 10,
                sigmaY: 10,
              ),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white.withAlpha(200),
        ),
        body: SingleChildScrollView(
            controller: _scrollController,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.centerRight,
                      colors: [Colors.deepPurple, Colors.pink])),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 30),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "Enter your mobile number",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextField(
                              controller: _textController,
                              decoration: InputDecoration(
                                prefix: const Text("+91"),
                                labelText: 'Enter your mobile number',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            BlocConsumer<PhoneAuthCubit, PhoneAuthCubitState>(
                              listener: (context, state) {
                                if (state is AuthGotVerificationId) {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return const VerifyOTPScreen();
                                  }));
                                }
                              },
                              builder: (context, state) {
                                if (state is AuthLoadingState) {
                                  return const CircularProgressIndicator(
                                    color: Colors.black,
                                  );
                                }

                                return SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return const VerifyOTPScreen();
                                        }));

                                        BlocProvider.of<PhoneAuthCubit>(context)
                                            .sendOtp(
                                                "+91${_textController.text.trim()}");
                                      },
                                      child: const Text("Verify")),
                                );
                              },
                            )
                          ]),
                    ),
                  )
                ],
              ),
            )));
  }
}
