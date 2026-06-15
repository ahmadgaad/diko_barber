import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zain/core/theme/app_colors.dart';
import 'package:zain/core/widgets/auth_gate.dart';
import 'package:zain/features/salon_details/domain/entities/salon_details.dart';
import 'package:zain/features/salon_details/presentation/cubit/salon_details_cubit.dart';

class CoverSliverAppBar extends StatelessWidget {
  const CoverSliverAppBar({
    super.key,
    required this.salon,
    required this.isFavorite,
    required this.colors,
  });

  final SalonDetails salon;
  final bool isFavorite;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 240.h,
      pinned: true,
      backgroundColor: colors.neutral50,
      surfaceTintColor: Colors.transparent,
      leading: CircleIconButton(
        icon: Icons.arrow_back_ios_new_rounded,
        onTap: () => Navigator.of(context).pop(),
      ),
      actions: [
        CircleIconButton(
          icon: isFavorite
              ? Icons.favorite_rounded
              : Icons.favorite_border_rounded,
          iconColor: isFavorite ? splashOrange : Colors.white,
          onTap: () => AuthGate.guard(
            context,
            () => context.read<SalonDetailsCubit>().toggleFavorite(),
          ),
        ),
        SizedBox(width: 8.w),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: salon.coverImage,
              fit: BoxFit.cover,
              placeholder: (_, _) => Container(color: colors.neutral200),
              errorWidget: (_, _, _) => Container(
                color: colors.neutral200,
                alignment: Alignment.center,
                child: Icon(
                  Icons.store_outlined,
                  color: colors.neutral400,
                  size: 48.r,
                ),
              ),
            ),
            // Gradient overlay
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.2),
                    Colors.black.withValues(alpha: 0.6),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.iconColor = Colors.white,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36.r,
        height: 36.r,
        margin: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.45),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: 18.r),
      ),
    );
  }
}
