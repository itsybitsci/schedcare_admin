import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schedcare_admin/models/user_models.dart';
import 'package:schedcare_admin/screens/home/popups/doctor_details_screen.dart';
import 'package:schedcare_admin/screens/home/popups/patient_details_screen.dart';
import 'package:schedcare_admin/utilities/animations.dart';
import 'package:schedcare_admin/utilities/constants.dart';
import 'package:schedcare_admin/utilities/helpers.dart';
import 'package:schedcare_admin/utilities/prompts.dart';

class UnverifiedUsersListPage extends HookConsumerWidget {
  UnverifiedUsersListPage({super.key});
  final Query<Map<String, dynamic>> unverifiedUsersQuery = FirebaseFirestore
      .instance
      .collection(FirebaseConstants.usersCollection)
      .where(ModelFields.isEmailVerified, isEqualTo: false);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double maxWidth = MediaQuery.of(context).size.width;

    return Center(
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
                  'Unverified Users',
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
                    query: unverifiedUsersQuery,
                    builder: (context, snapshot, _) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            Prompts.connectionError,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: isWeb(maxWidth) ? 3.sp : 14.sp),
                          ),
                        );
                      }

                      if (snapshot.hasData) {
                        return snapshot.docs.isEmpty
                            ? Center(
                                child: Text(
                                  Prompts.noUnverifiedUsers,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: isWeb(maxWidth) ? 3.sp : 14.sp),
                                ),
                              )
                            : ListView.builder(
                                itemCount: snapshot.docs.length,
                                itemBuilder: (context, index) {
                                  if (snapshot.hasMore &&
                                      index + 1 == snapshot.docs.length) {
                                    snapshot.fetchMore();
                                  }

                                  bool isPatient = snapshot.docs[index]
                                          .get(ModelFields.role) ==
                                      AppConstants.patient;

                                  Patient? patient = isPatient
                                      ? Patient.fromSnapshot(
                                          snapshot.docs[index])
                                      : null;
                                  Doctor? doctor = !isPatient
                                      ? Doctor.fromSnapshot(
                                          snapshot.docs[index])
                                      : null;

                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5.h, horizontal: 10.w),
                                    child: Material(
                                      type: MaterialType.transparency,
                                      child: ListTile(
                                        tileColor: Colors.grey[200],
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: Colors.grey[300]!),
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                        ),
                                        onTap: () async => isPatient
                                            ? showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    PatientDetailsScreen(
                                                  patient: patient!,
                                                ),
                                              )
                                            : showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    DoctorDetailsScreen(
                                                  doctor: doctor!,
                                                ),
                                              ),
                                        title: Center(
                                          child: Text(
                                              isPatient
                                                  ? '${patient!.firstName} ${patient.lastName} ${patient.suffix}'
                                                      .trim()
                                                  : '${doctor!.prefix} ${doctor.firstName} ${doctor.lastName} ${doctor.suffix}'
                                                      .trim(),
                                              style: TextStyle(
                                                  fontSize: isWeb(maxWidth)
                                                      ? 4.sp
                                                      : 12.sp,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        leading: Text(
                                            isPatient
                                                ? AppConstants.patient
                                                : AppConstants.doctor,
                                            style: TextStyle(
                                                fontSize: isWeb(maxWidth)
                                                    ? 4.sp
                                                    : 10.sp)),
                                        subtitle: Center(
                                          child: Text(
                                              'Email:  ${isPatient ? patient!.email : doctor!.email}',
                                              style: TextStyle(
                                                  fontSize: isWeb(maxWidth)
                                                      ? 4.sp
                                                      : 10.sp)),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                      }

                      return lottieLoading(width: isWeb(maxWidth) ? 10 : 50);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
