import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schedcare_admin/models/user_models.dart';
import 'package:schedcare_admin/providers/auth_provider.dart';
import 'package:schedcare_admin/services/firestore_service.dart';
import 'package:schedcare_admin/utilities/constants.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static String get routeName => 'home';
  static String get routePath => '/home';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final FirestoreService firestoreService = FirestoreService();
    final AuthProvider authNotifier = ref.watch(authProvider);

    final TabController tabController = useTabController(initialLength: 2);

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('SchedCare Admin Portal')),
        actions: [
          IconButton(
              onPressed: () async {
                await authNotifier.signOut();
              },
              icon: const Icon(Icons.logout))
        ],
        bottom: TabBar(
          controller: tabController,
          tabs: const [
            Tab(
              text: 'List of Users',
              icon: Icon(Icons.person),
            ),
            Tab(
              text: 'Pending Doctor Registrations',
              icon: Icon(Icons.person),
            )
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          StreamBuilder(
            stream: firestoreService.getUsersSnapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  children: snapshot.data!.docs.map(
                    (QueryDocumentSnapshot snapshot) {
                      bool isPatient = snapshot['role'].toLowerCase() ==
                          FirestoreConstants.patient.toLowerCase();

                      if (isPatient) {
                        Patient patient = Patient.fromSnapshot(snapshot);
                        return ListTile(
                          title: Center(
                            child: Text(
                                '${patient.firstName} ${patient.lastName}'),
                          ),
                          subtitle: Center(
                            child: Text(patient.role),
                          ),
                        );
                      } else {
                        Doctor doctor = Doctor.fromSnapshot(snapshot);
                        return ListTile(
                          title: Center(
                            child:
                                Text('${doctor.firstName} ${doctor.lastName}'),
                          ),
                          subtitle: Center(
                            child: Text(doctor.role),
                          ),
                        );
                      }
                    },
                  ).toList(),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
          const Center(
            child: Text('Pending Doctor Registrations'),
          ),
        ],
      ),
    );
  }
}
