// lib/features/auth/presentation/pages/register_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final usernameController = TextEditingController();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthRegistered) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Registration Successful')),
              );

              Navigator.pop(context);
            }
          },

          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,

                children: [
                  TextField(
                    controller: usernameController,

                    decoration: const InputDecoration(
                      hintText: 'Username',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller: emailController,

                    decoration: const InputDecoration(
                      hintText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller: passwordController,

                    obscureText: true,

                    decoration: const InputDecoration(
                      hintText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 30),

                  if (state is AuthLoading)
                    const Center(child: CircularProgressIndicator())
                  else
                    SizedBox(
                      height: 50,

                      child: ElevatedButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(
                            RegisterRequested(
                              username: usernameController.text.trim(),

                              email: emailController.text.trim(),

                              password: passwordController.text.trim(),
                            ),
                          );
                        },

                        child: const Text('Register'),
                      ),
                    ),

                  const SizedBox(height: 20),

                  if (state is AuthError) Text(state.message),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
