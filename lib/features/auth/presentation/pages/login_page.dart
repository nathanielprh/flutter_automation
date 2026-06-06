import 'package:flutter/material.dart';
import 'package:flutter_automation/features/chat/presentation/pages/chat_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'register_page.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const ChatPage()),
              );
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(hintText: 'Email'),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(hintText: 'Password'),
                ),
                const SizedBox(height: 30),

                if (state is AuthLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(
                        LoginRequested(
                          email: emailController.text,
                          password: passwordController.text,
                        ),
                      );
                    },
                    child: const Text('Login'),
                  ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,

                      MaterialPageRoute(builder: (_) => const RegisterPage()),
                    );
                  },

                  child: const Text('Create Account'),
                ),

                if (state is AuthError)
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(state.message),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
