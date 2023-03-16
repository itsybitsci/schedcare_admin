import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schedcare_admin/models/user_models.dart';
import 'package:schedcare_admin/providers/firebase_provider.dart';
import 'package:schedcare_admin/services/firestore_service.dart';
import 'package:schedcare_admin/utilities/constants.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static String get routeName => 'home';
  static String get routePath => '/home';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final FirestoreService firestoreService = FirestoreService();
    final FirebaseProvider firebaseNotifier = ref.watch(firebaseProvider);
    final TabController tabController = useTabController(initialLength: 2);

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('SchedCare Admin Portal')),
        actions: [
          IconButton(
              onPressed: () async {
                await firebaseNotifier.signOut();
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
              text: 'Doctor Registrations',
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
                  children: snapshot.data!.docs
                      .where((QueryDocumentSnapshot snapshot) =>
                          snapshot['isApproved'])
                      .map(
                    (QueryDocumentSnapshot snapshot) {
                      bool isPatient = snapshot['role'].toLowerCase() ==
                          FirestoreConstants.patient.toLowerCase();

                      if (isPatient) {
                        Patient patient = Patient.fromSnapshot(snapshot);
                        return ListTile(
                          onTap: () {},
                          title: Center(
                            child: Text(
                                '${patient.firstName} ${patient.lastName}'),
                          ),
                          subtitle: Center(
                            child: Text(patient.role),
                          ),
                          trailing: IconButton(
                            onPressed: () async {
                              await firebaseNotifier.approveRegistration(
                                  patient.uid, false);
                            },
                            icon: const Icon(Icons.close),
                          ),
                        );
                      } else {
                        Doctor doctor = Doctor.fromSnapshot(snapshot);
                        return ListTile(
                          onTap: () {},
                          title: Center(
                            child:
                                Text('${doctor.firstName} ${doctor.lastName}'),
                          ),
                          subtitle: Center(
                            child: Text(doctor.role),
                          ),
                          trailing: IconButton(
                            onPressed: () async {
                              await firebaseNotifier.approveRegistration(
                                  doctor.uid, false);
                            },
                            icon: const Icon(Icons.close),
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
          StreamBuilder(
            stream: firestoreService.getUsersSnapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  children: snapshot.data!.docs
                      .where((snapshot) =>
                          snapshot['role'].toLowerCase() ==
                              FirestoreConstants.doctor.toLowerCase() &&
                          !snapshot['isApproved'])
                      .map(
                    (QueryDocumentSnapshot snapshot) {
                      Doctor doctor = Doctor.fromSnapshot(snapshot);
                      return ListTile(
                        onTap: () {},
                        title: Center(
                          child: Text('${doctor.firstName} ${doctor.lastName}'),
                        ),
                        subtitle: Center(
                          child: Text(doctor.role),
                        ),
                        trailing: IconButton(
                          onPressed: () async {
                            await firebaseNotifier.approveRegistration(
                                doctor.uid, true);
                          },
                          icon: const Icon(Icons.check),
                        ),
                      );
                    },
                  ).toList(),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ],
      ),
    );
  }
}
