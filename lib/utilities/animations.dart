import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

Center lottieLoadingScreen() => Center(
      child: Lottie.asset('assets/animations/paper-plane_lottie.json',
          width: 500.w),
    );

Center lottieLoading({double width = 200}) => Center(
      child: Lottie.asset('assets/animations/circular-loading_lottie.json',
          width: width.w),
    );
