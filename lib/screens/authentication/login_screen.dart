import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schedcare_admin/config/config.dart';
import 'package:schedcare_admin/providers/firebase_services_provider.dart';
import 'package:schedcare_admin/utilities/animations.dart';
import 'package:schedcare_admin/utilities/components.dart';
import 'package:schedcare_admin/utilities/helpers.dart';

class LoginScreen extends HookConsumerWidget {
  LoginScreen({Key? key}) : super(key: key);
  final GlobalKey<FormState> formKeyLogin = GlobalKey<FormState>();
  static String get routeName => 'login';
  static String get routePath => '/login';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double maxWidth = MediaQuery.of(context).size.width;
    final FirebaseServicesProvider firebaseServicesNotifier =
        ref.watch(firebaseServicesProvider);
    final TextEditingController usernameController = useTextEditingController();
    final TextEditingController passwordController = useTextEditingController();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Background(
        child: Center(
          child: Form(
            key: formKeyLogin,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        maxHeight: isWeb(maxWidth) ? 200.h : 250.h),
                    child: Image.asset("assets/images/splash.png"),
                  ),
                  SizedBox(
                    height: 50.h,
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: isWeb(maxWidth) ? 100.w : 300.w),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: usernameController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[200],
                        suffixIcon: const Icon(Icons.email),
                        labelText: 'Username',
                        hintText: 'Enter username',
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 3.w),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                      ),
                      validator: (value) {
                        return value!.isNotEmpty ? null : 'Required';
                      },
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: isWeb(maxWidth) ? 100.w : 300.w),
                    child: HookBuilder(
                      builder: (_) {
                        final passwordVisible = useState(false);

                        return TextFormField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[200],
                            labelText: 'Password',
                            hintText: 'Enter password',
                            suffixIcon: IconButton(
                              icon: Icon(passwordVisible.value
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () => passwordVisible.value =
                                  !passwordVisible.value,
                            ),
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 3.w),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                          ),
                          obscureText: !passwordVisible.value,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Required';
                            }
                            return null;
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  firebaseServicesNotifier.getLoggingIn
                      ? lottieLoading(width: isWeb(maxWidth) ? 20 : 100)
                      : ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 100.w),
                          child: ElevatedButton(
                            onPressed: () async {
                              if (formKeyLogin.currentState!.validate()) {
                                formKeyLogin.currentState?.save();
                                if (AdminCredentials.admins
                                    .contains(usernameController.text.trim())) {
                                  await firebaseServicesNotifier
                                      .logInWithEmailAndPassword(
                                          '${usernameController.text.trim()}@gmail.com',
                                          passwordController.text.trim());
                                }
                              }
                            },
                            child: Text(
                              'LOGIN',
                              style: TextStyle(
                                  fontSize: isWeb(maxWidth) ? 7.sp : 15.sp),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
