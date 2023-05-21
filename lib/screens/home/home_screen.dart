import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schedcare_admin/providers/firebase_services_provider.dart';
import 'package:schedcare_admin/screens/home/pages/blocked_users_list_page.dart';
import 'package:schedcare_admin/screens/home/pages/doctors_list_page.dart';
import 'package:schedcare_admin/screens/home/pages/patients_list_page.dart';
import 'package:schedcare_admin/screens/home/pages/unverified_users_list_page.dart';
import 'package:schedcare_admin/utilities/components.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static String get routeName => 'home';
  static String get routePath => '/home';

  TabBar tabBar(TabController tabController) => TabBar(
        controller: tabController,
        tabs: const [
          Tab(
            text: 'Patients',
            icon: Icon(Icons.person),
          ),
          Tab(
            text: 'Doctors',
            icon: Icon(Icons.person),
          ),
          Tab(
            text: 'Blocked',
            icon: Icon(Icons.person),
          ),
          Tab(
            text: 'Unverified',
            icon: Icon(Icons.person),
          ),
        ],
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final FirebaseServicesProvider firebaseServicesNotifier =
        ref.watch(firebaseServicesProvider);
    final TabController tabController = useTabController(initialLength: 4);

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('SchedCare Admin Portal')),
        actions: [
          IconButton(
              onPressed: () async {
                await firebaseServicesNotifier.signOut();
              },
              icon: const Icon(Icons.logout))
        ],
        bottom: tabBar(tabController),
      ),
      body: Background(
        child: TabBarView(
          controller: tabController,
          children: [
            PatientsListPage(),
            DoctorsListPage(),
            BlockedUsersListPage(),
            UnverifiedUsersListPage(),
          ],
        ),
      ),
    );
  }
}
