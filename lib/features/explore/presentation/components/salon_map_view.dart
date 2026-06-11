import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ronaq_barber/core/shared/domain/entities/salon.dart';
import 'package:ronaq_barber/core/theme/app_map_style.dart';
import 'package:ronaq_barber/features/explore/presentation/components/salon_marker_icons.dart';

class SalonMapView extends StatefulWidget {
  const SalonMapView({
    super.key,
    required this.salons,
    required this.highlightedSalonId,
    required this.onPinTapped,
    this.initialZoom = 13,
  });

  final List<Salon> salons;
  final int? highlightedSalonId;
  final ValueChanged<int> onPinTapped;
  final double initialZoom;

  @override
  State<SalonMapView> createState() => SalonMapViewState();
}

class SalonMapViewState extends State<SalonMapView> {
  GoogleMapController? _controller;
  SalonMarkerIcons? _icons;

  static const _riyadhCenter = LatLng(24.7136, 46.6753);

  @override
  void initState() {
    super.initState();
    _loadIcons();
  }

  Future<void> _loadIcons() async {
    final icons = await SalonMarkerIcons.generate();
    if (!mounted) return;
    setState(() => _icons = icons);
  }

  @override
  void didUpdateWidget(SalonMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.highlightedSalonId != oldWidget.highlightedSalonId &&
        widget.highlightedSalonId != null) {
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
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: _riyadhCenter,
        zoom: widget.initialZoom,
      ),
      markers: _buildMarkers(),
      style: Theme.of(context).brightness == Brightness.dark
          ? AppMapStyle.dark
          : AppMapStyle.light,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      onMapCreated: (controller) => _controller = controller,
    );
  }
}
