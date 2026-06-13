import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ronaq_barber/core/theme/app_colors.dart';

class GalleryTab extends StatelessWidget {
  const GalleryTab({super.key, required this.gallery, required this.colors});

  final List<String> gallery;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(12.w),
      physics: const BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 6.w,
        mainAxisSpacing: 6.h,
      ),
      itemCount: gallery.length,
      itemBuilder: (context, i) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(10.r),
          child: CachedNetworkImage(
            imageUrl: gallery[i],
            fit: BoxFit.cover,
            placeholder: (_, _) => Container(color: colors.neutral200),
            errorWidget: (_, _, _) => Container(
              color: colors.neutral200,
              alignment: Alignment.center,
              child: Icon(
                Icons.image_outlined,
                color: colors.neutral400,
                size: 24.r,
              ),
            ),
          ),
        );
      },
    );
  }
}
