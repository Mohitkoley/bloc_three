import 'dart:async';
import 'dart:ui';
import 'package:bloc_three/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/phone_auth_cubit.dart';

class VerifyOTPScreen extends StatefulWidget {
  const VerifyOTPScreen({super.key});

  @override
  State<VerifyOTPScreen> createState() => _VerifyOTPScreenState();
}

class _VerifyOTPScreenState extends State<VerifyOTPScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<Alignment> _animation;

  final TextEditingController _otpController = TextEditingController();

  @override
  void deactivate() {}

  @override
  void didChangeDependencies() {}

  @override
  void didUpdateWidget(covariant StatefulWidget oldWidget) {}

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    // _animationBegain = AlignmentTween(
    //   begin: Alignment.centerLeft,
    //   end: Alignment.centerRight,
    // ).animate(_controller);

    _animation = Tween<Alignment>(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ).animate(_controller);

    // _animationEnd = AlignmentTween(
    //   begin: Alignment.centerRight,
    //   end: Alignment.center,
    // ).animate(_controller);

    // _controller.reverse();
    // _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.black,
          title: const Text("Verify OTP"),
          flexibleSpace: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 10,
                sigmaY: 10,
              ),
              child: Container(color: Colors.transparent),
            ),
          ),
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white.withOpacity(0.3),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            child: ListView(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      decoration: InputDecoration(
                        labelText: 'Enter 6 Digit OTP',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    AnimatedBuilder(
                        animation: _animation,
                        builder: (context, _) {
                          return BlocConsumer<PhoneAuthCubit,
                              PhoneAuthCubitState>(
                            listener: (context, state) {
                              if (state is AuthLoggedinState) {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Home()),
                                    (route) => false);
                              } else if (state is AuthErrorState) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(state.error),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            builder: (context, state) {
                              if (state is AuthLoadingState) {
                                return const CircularProgressIndicator(
                                  color: Colors.black,
                                );
                              }

                              return Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: _animation.value,
                                      end: Alignment.centerRight,
                                      colors: const [
                                        Colors.deepPurple,
                                        Colors.pink
                                      ]),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      elevation: 0,
                                    ),
                                    onPressed: () {
                                      BlocProvider.of<PhoneAuthCubit>(context)
                                          .verifyOtp(
                                              _otpController.text.trim());
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text("Button Tapped"),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    },
                                    child: const Text("Verify")),
                              );
                            },
                          );
                        })
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
