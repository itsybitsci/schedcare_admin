import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:schedcare_admin/models/user_models.dart';
import 'package:schedcare_admin/utilities/helpers.dart';

class PatientDetailsScreen extends HookConsumerWidget {
  final Patient patient;
  const PatientDetailsScreen({super.key, required this.patient});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double maxWidth = MediaQuery.of(context).size.width;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text(
        patient.middleName.toString().isNotEmpty
            ? '${patient.firstName} ${patient.middleName} ${patient.lastName} ${patient.suffix}'
                .trim()
            : '${patient.firstName} ${patient.lastName} ${patient.suffix}'
                .trim(),
        style: TextStyle(fontSize: isWeb(maxWidth) ? 7.sp : 13.sp),
        textAlign: TextAlign.center,
      ),
      content: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 300.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 12.h),
            Text('Email: ${patient.email}',
                style: TextStyle(fontSize: isWeb(maxWidth) ? 5.sp : 13.sp)),
            SizedBox(height: 3.h),
            Text('Age: ${patient.age}',
                style: TextStyle(fontSize: isWeb(maxWidth) ? 5.sp : 13.sp)),
            SizedBox(height: 3.h),
            Text('Sex: ${patient.sex}',
                style: TextStyle(fontSize: isWeb(maxWidth) ? 5.sp : 13.sp)),
            SizedBox(height: 3.h),
            Text('Contact Number: ${patient.phoneNumber}',
                style: TextStyle(fontSize: isWeb(maxWidth) ? 5.sp : 13.sp)),
            SizedBox(height: 3.h),
            Text('Birthdate: ${DateFormat('yMMMMd').format(patient.birthDate)}',
                style: TextStyle(fontSize: isWeb(maxWidth) ? 5.sp : 13.sp)),
            SizedBox(height: 3.h),
            Text('Address: ${patient.address}',
                style: TextStyle(fontSize: isWeb(maxWidth) ? 5.sp : 13.sp)),
            SizedBox(height: 3.h),
            if ((patient.uhsIdNumber).toString().isNotEmpty)
              Text('UHS ID Number: ${patient.uhsIdNumber}',
                  style: TextStyle(fontSize: isWeb(maxWidth) ? 5.sp : 13.sp)),
            if ((patient.classification).toString().isNotEmpty)
              Text('Classification: ${patient.classification}',
                  style: TextStyle(fontSize: isWeb(maxWidth) ? 5.sp : 13.sp)),
            Text('Civil Status: ${patient.civilStatus}',
                style: TextStyle(fontSize: isWeb(maxWidth) ? 5.sp : 13.sp)),
            Text('Vaccination Status: ${patient.vaccinationStatus}',
                style: TextStyle(fontSize: isWeb(maxWidth) ? 5.sp : 13.sp)),
          ],
        ),
      ),
    );
  }
}
