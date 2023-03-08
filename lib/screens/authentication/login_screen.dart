import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schedcare_admin/config/config.dart';

class LoginScreen extends HookConsumerWidget {
  LoginScreen({Key? key}) : super(key: key);
  final GlobalKey<FormState> formKeyLogin = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController usernameController = useTextEditingController();
    final TextEditingController passwordController = useTextEditingController();

    bool validateCredentials() {
      if (usernameController.text.trim() == AdminCredentials.username &&
          passwordController.text.trim() == AdminCredentials.password) {
        return true;
      }
      return false;
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: formKeyLogin,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Sign In',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 50,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: TextFormField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      hintText: 'Username',
                      contentPadding: const EdgeInsets.all(27),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.blue, width: 3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.blue, width: 3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      return value!.isEmpty ? 'Required' : null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      contentPadding: const EdgeInsets.all(27),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.blue, width: 3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.blue, width: 3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      return value!.isEmpty ? 'Required' : null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text(
                    'Sign In',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                  ),
                  onPressed: () {
                    if (formKeyLogin.currentState!.validate()) {
                      formKeyLogin.currentState?.save();

                      if (validateCredentials()) {
                        Navigator.pushNamed(context, '/home');
                        usernameController.text = '';
                        passwordController.text = '';
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
