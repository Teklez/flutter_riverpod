import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/application/auth/auth_provider.dart';
import 'package:frontend/presentation/events/auth_event.dart';
import 'package:frontend/presentation/states/auth_state.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authProvider, (previous, state) {
      if (state is AuthFailure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.message),
            backgroundColor: Colors.red,
          ),
        );
      }

      if (state is AuthSuccess) {
        print('AuthSuccess: ${state.message}');
        if (state.message['roles'][0] == "admin") {
          context.go('/admin');
        } else {
          context.go('/home');
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Removes the back button
        backgroundColor: Color.fromARGB(255, 211, 47, 47),
      ),
      body: Container(
        margin: EdgeInsets.only(bottom: 20.0),
        child: content(context),
      ),
    );
  }

  Widget content(BuildContext context) {
    return Stack(
      children: [
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.3),
            BlendMode.dstATop,
          ),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              'assets/pexels-raka-miftah-4253690.jpg',
              fit: BoxFit.cover,
            ),
          ),
        ),
        SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 211, 47, 47),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.elliptical(60, 60),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Container(
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
                    child: const Icon(
                      Icons.person,
                      size: 50,
                      color: Color.fromARGB(255, 48, 1, 1),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Welcome",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Sign in to continue.",
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      inputForm(
                        "Username",
                        _usernameController,
                        (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your username';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      inputForm(
                        "Password",
                        _passwordController,
                        (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                        obscureText: true,
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Center(
                        child: Container(
                          width: 200,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 211, 47, 47),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 211, 47, 47),
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                ref
                                    .read(authProvider.notifier)
                                    .handleUserLoggedIn(
                                      UserLoggedIn(
                                        username: _usernameController.text,
                                        password: _passwordController.text,
                                      ),
                                    );
                              }
                            },
                            child: const Text(
                              "Log In",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("New User? "),
                          GestureDetector(
                            onTap: () {
                              context.go('/register');
                            },
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 249, 4, 4)),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget inputForm(String label, TextEditingController controller,
      String? Function(String?) validator,
      {bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      validator: validator,
    );
  }
}
