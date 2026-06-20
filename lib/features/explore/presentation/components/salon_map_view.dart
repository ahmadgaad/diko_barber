import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zain/core/shared/domain/entities/salon.dart';
import 'package:zain/core/theme/app_colors.dart';
import 'package:zain/core/theme/app_map_style.dart';
import 'package:zain/features/explore/presentation/components/salon_marker_icons.dart';
import 'package:zain/features/explore/presentation/cubit/explore_cubit.dart';

class SalonMapView extends StatefulWidget {
  const SalonMapView({
    super.key,
    required this.salons,
    required this.highlightedSalonId,
    required this.onPinTapped,
    this.userLocation,
    this.locationButtonBottomPadding = 0,
    this.initialZoom = 13,
  });

  final List<Salon> salons;
  final int? highlightedSalonId;
  final ValueChanged<int> onPinTapped;
  final LatLng? userLocation;
  final double locationButtonBottomPadding;
  final double initialZoom;

  @override
  State<SalonMapView> createState() => SalonMapViewState();
}

class SalonMapViewState extends State<SalonMapView> {
  GoogleMapController? _controller;
  SalonMarkerIcons? _icons;
  late final AppLifecycleListener _lifecycleListener;

  final ValueNotifier<Set<Marker>> _markersNotifier = ValueNotifier({});

  @override
  void initState() {
    super.initState();
    _loadIcons();
    _lifecycleListener = AppLifecycleListener(
      onResume: () => context.read<ExploreCubit>().recheckLocation(),
    );
  }

  Future<void> _loadIcons() async {
    final icons = await SalonMarkerIcons.generate();
    if (!mounted) return;
    _icons = icons;
    _markersNotifier.value = _buildMarkers();
  }

  @override
  void didUpdateWidget(SalonMapView oldWidget) {
    super.didUpdateWidget(oldWidget);

    final salonsChanged = widget.salons != oldWidget.salons;
    final highlightChanged =
        widget.highlightedSalonId != oldWidget.highlightedSalonId;

    if (salonsChanged || highlightChanged) {
      _markersNotifier.value = _buildMarkers();
    }

    if (highlightChanged && widget.highlightedSalonId != null) {
      _animateToSalon(widget.highlightedSalonId!);
    }
  }

  void _animateToSalon(int id) {
    final salon = widget.salons.where((s) => s.id == id).firstOrNull;
    if (salon == null || _controller == null) return;
    _controller!.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(salon.lat, salon.lng), 15),
    );
  }

  void _goToMyLocation() {
    final loc = widget.userLocation;
    if (loc == null || _controller == null) return;
    _controller!.animateCamera(CameraUpdate.newLatLngZoom(loc, 15));
  }

  Set<Marker> _buildMarkers() {
    final icons = _icons;
    return widget.salons.map((salon) {
      final isHighlighted = salon.id == widget.highlightedSalonId;
      return Marker(
        markerId: MarkerId('salon_${salon.id}'),
        position: LatLng(salon.lat, salon.lng),
        icon:
            icons?.forSalon(
              isOpen: salon.isOpen,
              isHighlighted: isHighlighted,
            ) ??
            BitmapDescriptor.defaultMarker,
        anchor: const Offset(0.5, 0.92),
        zIndexInt: isHighlighted ? 1 : 0,
        onTap: () => widget.onPinTapped(salon.id),
        infoWindow: InfoWindow(title: salon.name),
      );
    }).toSet();
  }

  @override
  void dispose() {
    _lifecycleListener.dispose();
    _markersNotifier.dispose();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.userLocation == null) {
      return _LocationPermissionPrompt(
        colors: AppColors.of(context),
        bottomPadding: widget.locationButtonBottomPadding,
      );
    }

    final colors = AppColors.of(context);

    return Stack(
      children: [
        ValueListenableBuilder<Set<Marker>>(
          valueListenable: _markersNotifier,
          builder: (context, markers, child) {
            return GoogleMap(
              initialCameraPosition: CameraPosition(
                target: widget.userLocation!,
                zoom: widget.initialZoom,
              ),
              markers: markers,
              style: Theme.of(context).brightness == Brightness.dark
                  ? AppMapStyle.dark
                  : AppMapStyle.light,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              onMapCreated: (controller) => _controller = controller,
            );
          },
        ),
        Positioned(
          right: 16.w,
          bottom: widget.locationButtonBottomPadding + 16.h,
          child: _LocationButton(onTap: _goToMyLocation, colors: colors),
        ),
      ],
    );
  }
}

class _LocationPermissionPrompt extends StatelessWidget {
  const _LocationPermissionPrompt({
    required this.colors,
    this.bottomPadding = 0,
  });
  final AppColors colors;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
    color: colors.neutral100,
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.location_off_rounded,
                size: 56.r,
                color: colors.neutral400,
              ),
              SizedBox(height: 16.h),
              Text(
                tr('explore.location_required_title'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: colors.neutral800,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                tr('explore.location_required_body'),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13.sp, color: colors.neutral500),
              ),
              SizedBox(height: 20.h),
              GestureDetector(
                onTap: () => Geolocator.openAppSettings(),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: splashOrange,
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                  child: Text(
                    tr('explore.enable_location'),
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LocationButton extends StatelessWidget {
  const _LocationButton({required this.onTap, required this.colors});

  final VoidCallback onTap;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44.r,
        height: 44.r,
        decoration: BoxDecoration(
          color: colors.neutral100,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(Icons.my_location_rounded, size: 20.r, color: splashOrange),
      ),
    );
  }
}
