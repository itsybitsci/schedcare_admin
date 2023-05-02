import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schedcare_admin/models/user_models.dart';
import 'package:schedcare_admin/providers/firebase_services_provider.dart';
import 'package:schedcare_admin/services/firestore_service.dart';
import 'package:schedcare_admin/utilities/animations.dart';
import 'package:schedcare_admin/utilities/components.dart';
import 'package:schedcare_admin/utilities/constants.dart';
import 'package:schedcare_admin/utilities/helpers.dart';
import 'package:schedcare_admin/utilities/prompts.dart';

class HomeScreen extends HookConsumerWidget {
  HomeScreen({Key? key}) : super(key: key);
  static String get routeName => 'home';
  static String get routePath => '/home';
  final Query<Patient> patientsQuery = FirebaseFirestore.instance
      .collection(FirebaseConstants.usersCollection)
      .where(ModelFields.role, isEqualTo: AppConstants.patient)
      .where(ModelFields.isApproved, isEqualTo: true)
      .withConverter(
        fromFirestore: (snapshot, _) => Patient.fromSnapshot(snapshot),
        toFirestore: (patient, _) => patient.toMap(),
      );
  final Query<Doctor> doctorsQuery = FirebaseFirestore.instance
      .collection(FirebaseConstants.usersCollection)
      .where(ModelFields.role, isEqualTo: AppConstants.doctor)
      .where(ModelFields.isApproved, isEqualTo: true)
      .withConverter(
        fromFirestore: (snapshot, _) => Doctor.fromSnapshot(snapshot),
        toFirestore: (doctor, _) => doctor.toMap(),
      );

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
          )
        ],
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final FirestoreService firestoreService = FirestoreService();
    final FirebaseServicesProvider firebaseServicesNotifier =
        ref.watch(firebaseServicesProvider);
    final TabController tabController = useTabController(initialLength: 3);
    final double maxWidth = MediaQuery.of(context).size.width;

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
            Center(
              child: Container(
                height: 560.h,
                width: isWeb(maxWidth) ? 140.w : 340.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: ColorConstants.primaryLight,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: isWeb(maxWidth) ? 135.w : 320.w,
                      height: 60.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Text(
                          'List of Patients',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: isWeb(maxWidth) ? 7.sp : 18.sp),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Flexible(
                      child: Container(
                        width: isWeb(maxWidth) ? 135.w : 320.w,
                        height: 470.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          color: Colors.white,
                        ),
                        child: ScrollConfiguration(
                          behavior: ScrollConfiguration.of(context).copyWith(
                            dragDevices: {
                              PointerDeviceKind.touch,
                              PointerDeviceKind.mouse,
                            },
                          ),
                          child: FirestoreQueryBuilder(
                            query: patientsQuery,
                            builder: (context, snapshot, _) {
                              if (snapshot.hasError) {
                                return Center(
                                  child: Text(
                                    Prompts.connectionError,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            isWeb(maxWidth) ? 3.sp : 14.sp),
                                  ),
                                );
                              }

                              if (snapshot.hasData) {
                                return snapshot.docs.isEmpty
                                    ? Center(
                                        child: Text(
                                          Prompts.noPatients,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: isWeb(maxWidth)
                                                  ? 3.sp
                                                  : 14.sp),
                                        ),
                                      )
                                    : ListView.builder(
                                        itemCount: snapshot.docs.length,
                                        itemBuilder: (context, index) {
                                          if (snapshot.hasMore &&
                                              index + 1 ==
                                                  snapshot.docs.length) {
                                            snapshot.fetchMore();
                                          }

                                          final Patient patient =
                                              snapshot.docs[index].data();

                                          return Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5.h,
                                                horizontal: 10.w),
                                            child: Material(
                                              type: MaterialType.transparency,
                                              child: ListTile(
                                                tileColor: Colors.grey[200],
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                      color: Colors.grey[300]!),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.r),
                                                ),
                                                onTap: null,
                                                title: Center(
                                                  child: Text(
                                                      '${patient.firstName} ${patient.lastName} ${patient.suffix}'
                                                          .trim(),
                                                      style: TextStyle(
                                                          fontSize:
                                                              isWeb(maxWidth)
                                                                  ? 5.sp
                                                                  : 12.sp,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                                subtitle: Center(
                                                  child: Text(
                                                      'Email: ${patient.email}',
                                                      style: TextStyle(
                                                          fontSize:
                                                              isWeb(maxWidth)
                                                                  ? 4.sp
                                                                  : 10.sp)),
                                                ),
                                                trailing: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    Center(
                                                      child: IconButton(
                                                        onPressed: () async {
                                                          await firebaseServicesNotifier
                                                              .approveRegistration(
                                                                  patient.id,
                                                                  false);
                                                        },
                                                        icon: const Icon(
                                                          Icons.close,
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                              }

                              return lottieLoading(
                                  width: isWeb(maxWidth) ? 10 : 50);
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: Container(
                height: 560.h,
                width: isWeb(maxWidth) ? 140.w : 340.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: ColorConstants.primaryLight,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: isWeb(maxWidth) ? 135.w : 320.w,
                      height: 60.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Text(
                          'List of Doctors',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: isWeb(maxWidth) ? 7.sp : 18.sp),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Flexible(
                      child: Container(
                        width: isWeb(maxWidth) ? 135.w : 320.w,
                        height: 470.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          color: Colors.white,
                        ),
                        child: ScrollConfiguration(
                          behavior: ScrollConfiguration.of(context).copyWith(
                            dragDevices: {
                              PointerDeviceKind.touch,
                              PointerDeviceKind.mouse,
                            },
                          ),
                          child: FirestoreQueryBuilder(
                            query: doctorsQuery,
                            builder: (context, snapshot, _) {
                              if (snapshot.hasError) {
                                return Center(
                                  child: Text(
                                    Prompts.connectionError,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            isWeb(maxWidth) ? 3.sp : 14.sp),
                                  ),
                                );
                              }

                              if (snapshot.hasData) {
                                return snapshot.docs.isEmpty
                                    ? Center(
                                        child: Text(
                                          Prompts.noPatients,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: isWeb(maxWidth)
                                                  ? 3.sp
                                                  : 14.sp),
                                        ),
                                      )
                                    : ListView.builder(
                                        itemCount: snapshot.docs.length,
                                        itemBuilder: (context, index) {
                                          if (snapshot.hasMore &&
                                              index + 1 ==
                                                  snapshot.docs.length) {
                                            snapshot.fetchMore();
                                          }

                                          final Doctor doctor =
                                              snapshot.docs[index].data();

                                          return Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5.h,
                                                horizontal: 10.w),
                                            child: Material(
                                              type: MaterialType.transparency,
                                              child: ListTile(
                                                tileColor: Colors.grey[200],
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                      color: Colors.grey[300]!),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.r),
                                                ),
                                                onTap: null,
                                                title: Center(
                                                  child: Text(
                                                      '${doctor.prefix} ${doctor.firstName} ${doctor.lastName} ${doctor.suffix}'
                                                          .trim(),
                                                      style: TextStyle(
                                                          fontSize:
                                                              isWeb(maxWidth)
                                                                  ? 5.sp
                                                                  : 12.sp,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                                subtitle: Center(
                                                  child: Text(
                                                      'Email: ${doctor.email}',
                                                      style: TextStyle(
                                                          fontSize:
                                                              isWeb(maxWidth)
                                                                  ? 4.sp
                                                                  : 10.sp)),
                                                ),
                                                trailing: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    Center(
                                                      child: IconButton(
                                                        onPressed: () async {
                                                          await firebaseServicesNotifier
                                                              .approveRegistration(
                                                                  doctor.id,
                                                                  false);
                                                        },
                                                        icon: const Icon(
                                                          Icons.close,
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                              }

                              return lottieLoading(
                                  width: isWeb(maxWidth) ? 10 : 50);
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
                                AppConstants.doctor.toLowerCase() &&
                            !snapshot['isApproved'])
                        .map(
                      (QueryDocumentSnapshot snapshot) {
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
                              await firebaseServicesNotifier
                                  .approveRegistration(doctor.id, true);
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
      ),
    );
  }
}
