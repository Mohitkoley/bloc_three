import 'dart:developer';
import 'dart:ui';

import 'package:bloc_three/screens/Sign_in/bloc/sign_in_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<Offset> _slideAnimation;
  late Animation<Alignment> _topAlignMentAnimation;
  late Animation<Alignment> _bottomAlignMentAnimation;
  late AnimationController _gradientcontroller;

  final GlobalKey _formkey = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..forward();
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);

    _gradientcontroller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..forward();
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0.5, 0), end: Offset.zero)
            .animate(_controller);

    _topAlignMentAnimation = TweenSequence<Alignment>([
      TweenSequenceItem(
          tween: Tween<Alignment>(
              begin: Alignment.topLeft, end: Alignment.topRight),
          weight: 1),
      TweenSequenceItem(
          tween: Tween<Alignment>(
              begin: Alignment.topRight, end: Alignment.bottomRight),
          weight: 1),
      TweenSequenceItem(
          tween: Tween<Alignment>(
              begin: Alignment.topRight, end: Alignment.bottomLeft),
          weight: 1),
      TweenSequenceItem(
          tween: Tween<Alignment>(
              begin: Alignment.bottomLeft, end: Alignment.topLeft),
          weight: 1),
    ]).animate(_gradientcontroller);
    _bottomAlignMentAnimation = TweenSequence<Alignment>([
      TweenSequenceItem(
          tween: Tween<Alignment>(
              begin: Alignment.bottomRight, end: Alignment.bottomLeft),
          weight: 1),
      TweenSequenceItem(
          tween: Tween<Alignment>(
              begin: Alignment.bottomLeft, end: Alignment.topLeft),
          weight: 1),
      TweenSequenceItem(
          tween: Tween<Alignment>(
              begin: Alignment.topLeft, end: Alignment.topRight),
          weight: 1),
      TweenSequenceItem(
          tween: Tween<Alignment>(
              begin: Alignment.topRight, end: Alignment.bottomRight),
          weight: 1),
    ]).animate(_gradientcontroller);
    _gradientcontroller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    _gradientcontroller.dispose();
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.deepPurple, Colors.pink])),
        child: SafeArea(
          child: Form(
            key: _formkey,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 50.0),
                      FadeTransition(
                        opacity: _animation,
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: 36.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40.0),
                      BlocBuilder<SignInBloc, SignInState>(
                        builder: (context, state) {
                          if (state is SignInErrorState) {
                            return Text(state.errorMessage,
                                style: const TextStyle(color: Colors.yellow));
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                      const SizedBox(height: 20.0),
                      SlideTransition(
                        position: _slideAnimation,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: TextFormField(
                            controller: _emailController,
                            onChanged: (value) {
                              context.read<SignInBloc>().add(
                                  SignInTextChangedEvent(
                                      emailValue: _emailController.value.text,
                                      passwordValue:
                                          _passwordController.value.text));
                            },
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              hintText: 'Enter your email',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      SizeTransition(
                        sizeFactor: _animation,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: TextFormField(
                            controller: _passwordController,
                            onChanged: (value) {
                              context.read<SignInBloc>().add(
                                  SignInTextChangedEvent(
                                      emailValue: _emailController.value.text,
                                      passwordValue:
                                          _passwordController.value.text));
                            },
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              hintText: 'Enter your password',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      Builder(builder: (context) {
                        return AnimatedBuilder(
                            animation: _gradientcontroller,
                            builder: (context, _) {
                              return BlocBuilder<SignInBloc, SignInState>(
                                builder: (context, state) {
                                  if (state is SignInLoadingState) {
                                    return const Center(
                                        child: CircularProgressIndicator(
                                            color: Colors.yellow));
                                  }
                                  return Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        gradient: LinearGradient(
                                          begin: _topAlignMentAnimation.value,
                                          end: _bottomAlignMentAnimation.value,
                                          colors: [
                                            if (state is SignInValidState)
                                              Colors.purpleAccent
                                            else
                                              Colors.grey,
                                            if (state is SignInValidState)
                                              Colors.deepPurple
                                            else
                                              Colors.grey
                                          ],
                                        )),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: const Size(200, 50),
                                        foregroundColor: Colors.white,
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                      ),
                                      onPressed: () {
                                        if (state is SignInValidState) {
                                          context.read<SignInBloc>().add(
                                              SignInSubmittedEvent(
                                                  email: _emailController
                                                      .value.text,
                                                  password: _passwordController
                                                      .value.text));
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            backgroundColor:
                                                Colors.deepPurpleAccent,
                                            content: Text('Signing In'),
                                          ));
                                        }
                                      },
                                      child: const Text('Sign In',
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  );
                                },
                              );
                            });
                      }),
                      const SizedBox(height: 50.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
