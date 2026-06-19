import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zain/core/theme/app_colors.dart';

class BookingSalonLogo extends StatelessWidget {
  const BookingSalonLogo({super.key, required this.url, required this.colors});

  final String url;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.r),
      child: CachedNetworkImage(
        imageUrl: url,
        width: 44.r,
        height: 44.r,
        fit: BoxFit.cover,
        placeholder: (_, _) =>
            Container(width: 44.r, height: 44.r, color: colors.neutral200),
        errorWidget: (_, _, _) => Container(
          width: 44.r,
          height: 44.r,
          color: colors.neutral200,
          alignment: Alignment.center,
          child: Icon(
            Icons.store_outlined,
            color: colors.neutral400,
            size: 20.r,
          ),
        ),
      ),
    );
  }
}
