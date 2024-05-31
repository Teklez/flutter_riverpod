import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/Infrastructure/auth_service.dart';
import 'package:frontend/Domain/auth_state.dart';
import 'package:frontend/presentation/screens/login.dart';

final registrationProvider =
    ChangeNotifierProvider.autoDispose((ref) => RegistrationState(ref.read));

class RegistrationState extends ChangeNotifier {
  final Reader read;

  RegistrationState(this.read);

  final _authService = AuthService();

  String? username;
  String? password;
  String? confirmPassword;
  String? errorMessage;

  void setUsername(String value) {
    username = value;
  }

  void setPassword(String value) {
    password = value;
  }

  void setConfirmPassword(String value) {
    confirmPassword = value;
  }

  void clearErrorMessage() {
    errorMessage = null;
  }

  Future<void> registerUser(BuildContext context) async {
    if (username != null && password != null && confirmPassword != null) {
      if (password == confirmPassword) {
        try {
          await _authService.registerUser(username!, password!);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ProfilePage(),
            ),
          );
        } catch (error) {
          errorMessage = error.toString();
          notifyListeners();
        }
      } else {
        errorMessage = 'Passwords do not match';
        notifyListeners();
      }
    } else {
      errorMessage = 'Please fill in all fields';
      notifyListeners();
    }
  }
}

class RegistrationPage extends ConsumerWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registrationState = ref.watch(registrationProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Removes the back button
        backgroundColor: const Color.fromARGB(255, 211, 47, 47),
      ),
      body: Container(
        margin: EdgeInsets.only(bottom: 20.0),
        child: content(context, registrationState),
      ),
    );
  }

  Widget content(BuildContext context, RegistrationState registrationState) {
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
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 211, 47, 47),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.elliptical(60, 60),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Color.fromARGB(255, 59, 2, 2),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Welcome to BetEbet",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Sign up to continue.",
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      if (registrationState.errorMessage != null) ...[
                        Text(
                          registrationState.errorMessage!,
                          style: TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 10),
                      ],
                      inputForm("User Name", registrationState, 'setUsername'),
                      const SizedBox(
                        height: 20,
                      ),
                      inputForm("Password", registrationState, 'setPassword',
                          obscureText: true),
                      const SizedBox(
                        height: 20,
                      ),
                      inputForm("Confirm Password", registrationState,
                          'setConfirmPassword',
                          obscureText: true),
                      const SizedBox(
                        height: 50,
                      ),
                      Center(
                        child: Container(
                          width: 200,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 211, 47, 47),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                            ),
                            onPressed: () {
                              registrationState.registerUser(context);
                            },
                            child: const Text(
                              "Sign up",
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
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account? "),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                              );
                            },
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 221, 4, 4)),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget inputForm(
      String label, RegistrationState registrationState, String setter,
      {bool obscureText = false}) {
    return TextFormField(
      onChanged: (value) {
        if (setter == 'setUsername') {
          registrationState.setUsername(value);
        } else if (setter == 'setPassword') {
          registrationState.setPassword(value);
        } else if (setter == 'setConfirmPassword') {
          registrationState.setConfirmPassword(value);
        }
      },
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }
}
