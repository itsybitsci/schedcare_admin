import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schedcare_admin/config/config.dart';
import 'package:schedcare_admin/providers/auth_provider.dart';

class LoginScreen extends HookConsumerWidget {
  LoginScreen({Key? key}) : super(key: key);
  final GlobalKey<FormState> formKeyLogin = GlobalKey<FormState>();
  static String get routeName => 'login';
  static String get routePath => '/login';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthProvider authNotifier = ref.watch(authProvider);
    final TextEditingController usernameController = useTextEditingController();
    final TextEditingController passwordController = useTextEditingController();
    ValueNotifier passwordVisible = useState(false);

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
                      border: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.blue, width: 3),
                        borderRadius: BorderRadius.circular(10),
                      ),
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
                      errorBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.red, width: 3),
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
                    obscureText: !passwordVisible.value,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      contentPadding: const EdgeInsets.all(27),
                      suffixIcon: IconButton(
                        icon: Icon(passwordVisible.value
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          passwordVisible.value = !passwordVisible.value;
                        },
                      ),
                      border: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.blue, width: 3),
                        borderRadius: BorderRadius.circular(10),
                      ),
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
                      errorBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.red, width: 3),
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
                ElevatedButton.icon(
                  onPressed: () async {
                    if (formKeyLogin.currentState!.validate()) {
                      formKeyLogin.currentState?.save();
                      if (AdminCredentials.admins
                          .contains(usernameController.text.trim())) {
                        await authNotifier.logInWithEmailAndPassword(
                            '${usernameController.text.trim()}@gmail.com',
                            passwordController.text.trim());
                      }
                    }
                  },
                  icon: const Icon(Icons.login),
                  label: authNotifier.isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          'Sign In',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 17),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
