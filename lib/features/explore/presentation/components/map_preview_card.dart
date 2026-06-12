import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ronaq_barber/core/shared/domain/entities/salon.dart';
import 'package:ronaq_barber/core/theme/app_colors.dart';

const kExploreMapCamera = CameraPosition(
  target: LatLng(24.7136, 46.6753),
  zoom: 11.5,
);

class MapPreviewCard extends StatelessWidget {
  const MapPreviewCard({super.key, required this.salons, required this.onTap});

  final List<Salon> salons;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: SizedBox(
        height: 150.h,
        child: Stack(
          fit: StackFit.expand,
          children: [
            IgnorePointer(
              child: GoogleMap(
                initialCameraPosition: kExploreMapCamera,
                markers: salons.map((salon) {
                  return Marker(
                    markerId: MarkerId('preview_${salon.id}'),
                    position: LatLng(salon.lat, salon.lng),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueOrange,
                    ),
                  );
                }).toSet(),
                liteModeEnabled: true,
                zoomControlsEnabled: false,
                myLocationButtonEnabled: false,
                mapToolbarEnabled: false,
                compassEnabled: false,
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onTap,
            ),
            PositionedDirectional(
              bottom: 10.h,
              end: 10.w,
              child: IgnorePointer(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: colors.neutral50,
                    borderRadius: BorderRadius.circular(999.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.fullscreen_rounded,
                        color: splashOrange,
                        size: 18.r,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        tr('explore.view_map'),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: colors.neutral900,
                        ),
                      ),
                    ],
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
