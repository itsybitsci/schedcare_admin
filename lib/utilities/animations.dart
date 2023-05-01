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

Center lottieError() => Center(
      child: Lottie.asset('assets/animations/no-connection_lottie.json',
          width: 400.w),
    );

Center lottieNoData({double width = 200}) => Center(
      child:
          Lottie.asset('assets/animations/no-data_lottie.json', width: width.w),
    );

Center lottieSearchDoctors({double width = 50}) => Center(
      child: Lottie.asset('assets/animations/search-doctors_lottie.json',
          width: width.w),
    );

Center lottieSearchUsers() => Center(
      child: Lottie.asset('assets/animations/search-users_lottie.json',
          width: 50.w),
    );
