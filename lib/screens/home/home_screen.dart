import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schedcare_admin/providers/auth_provider.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static String get routeName => 'home';
  static String get routePath => '/home';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Portal'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await authNotifier.signOut();
          },
          child: const Text('Logout'),
        ),
      ),
    );
  }
}
