import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schedcare_admin/models/user_models.dart';
import 'package:schedcare_admin/utilities/helpers.dart';

class DoctorDetailsScreen extends HookConsumerWidget {
  final Doctor doctor;
  const DoctorDetailsScreen({super.key, required this.doctor});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double maxWidth = MediaQuery.of(context).size.width;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text(
        doctor.middleName.toString().isNotEmpty
            ? '${doctor.prefix} ${doctor.firstName} ${doctor.middleName} ${doctor.lastName} ${doctor.suffix}'
                .trim()
            : '${doctor.prefix} ${doctor.firstName} ${doctor.lastName} ${doctor.suffix}'
                .trim(),
        style: TextStyle(fontSize: isWeb(maxWidth) ? 7.sp : 13.sp),
        textAlign: TextAlign.center,
      ),
      content: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: isWeb(maxWidth) ? 200.h : 150.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 12.h),
            Text('Email: ${doctor.email}',
                style: TextStyle(fontSize: isWeb(maxWidth) ? 5.sp : 13.sp)),
            SizedBox(height: 3.h),
            Text('Sex: ${doctor.sex}',
                style: TextStyle(fontSize: isWeb(maxWidth) ? 5.sp : 13.sp)),
            SizedBox(height: 3.h),
            Text('Specialization: ${doctor.specialization}',
                style: TextStyle(fontSize: isWeb(maxWidth) ? 5.sp : 13.sp)),
          ],
        ),
      ),
    );
  }
}
