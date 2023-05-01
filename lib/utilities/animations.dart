import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

Center lottieLoading({double width = 200}) => Center(
      child: Lottie.asset('assets/animations/circular-loading_lottie.json',
          width: width.w),
    );

Center lottieDiamondLoading() => Center(
      child: Lottie.asset('assets/animations/diamond-loading_lottie.json',
          width: 30.w),
    );
