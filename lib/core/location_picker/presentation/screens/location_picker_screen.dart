import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zain/core/di/service_locator.dart';
import 'package:zain/core/theme/app_map_style.dart';
import 'package:zain/core/widgets/app_snack_bar.dart';
import 'package:zain/core/location_picker/domain/entities/picked_location.dart';
import 'package:zain/core/location_picker/presentation/components/location_picker_confirm_button.dart';
import 'package:zain/core/location_picker/presentation/components/location_picker_gps_button.dart';
import 'package:zain/core/location_picker/presentation/components/location_picker_header.dart';
import 'package:zain/core/location_picker/presentation/components/location_picker_suggestions_panel.dart';
import 'package:zain/core/location_picker/presentation/cubit/location_picker_cubit.dart';
import 'package:zain/core/location_picker/presentation/cubit/location_picker_state.dart';

export 'package:zain/core/location_picker/domain/entities/picked_location.dart';

class LocationPickerScreen extends StatelessWidget {
  const LocationPickerScreen({super.key, this.initialLocation});

  final PickedLocation? initialLocation;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = sl<LocationPickerCubit>();
        if (initialLocation != null) {
          cubit.reverseGeocode(initialLocation!.lat, initialLocation!.lng);
        } else {
          cubit.autoFetchIfPermissionGranted();
        }
        return cubit;
      },
      child: _LocationPickerView(initialLocation: initialLocation),
    );
  }
}

class _LocationPickerView extends StatefulWidget {
  const _LocationPickerView({this.initialLocation});

  final PickedLocation? initialLocation;

  @override
  State<_LocationPickerView> createState() => _LocationPickerViewState();
}

class _LocationPickerViewState extends State<_LocationPickerView> {
  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = {};
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  static const _cairoCenter = LatLng(30.0444, 31.2357);

  LatLng get _initialTarget {
    if (widget.initialLocation != null) {
      return LatLng(
        widget.initialLocation!.lat,
        widget.initialLocation!.lng,
      );
    }
    return _cairoCenter;
  }

  double get _initialZoom =>
      widget.initialLocation != null ? 16 : 5;

  @override
  void initState() {
    super.initState();
    if (widget.initialLocation != null) {
      _addMarker(LatLng(
        widget.initialLocation!.lat,
        widget.initialLocation!.lng,
      ));
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _addMarker(LatLng position) {
    setState(() {
      _markers
        ..clear()
        ..add(Marker(
          markerId: const MarkerId('selected'),
          position: position,
        ));
    });
  }

  Future<void> _animateTo(double lat, double lng, {double zoom = 16}) async {
    final controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(lat, lng), zoom),
    );
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    final query = value.trim();
    if (query.isEmpty) {
      context.read<LocationPickerCubit>().clearSuggestions();
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<LocationPickerCubit>().fetchSuggestions(query);
    });
  }

  void _openSearch() => setState(() => _isSearching = true);

  void _closeSearch() {
    setState(() => _isSearching = false);
    _searchController.clear();
    _debounce?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LocationPickerCubit, LocationPickerState>(
      listener: (context, state) {
        if (state is LocationPickerGpsLoaded) {
          _addMarker(LatLng(state.lat, state.lng));
          context.read<LocationPickerCubit>().reverseGeocode(
                state.lat,
                state.lng,
              );
          _animateTo(state.lat, state.lng);
        } else if (state is LocationPickerGeocoded) {
          if (_isSearching) {
            _closeSearch();
            _addMarker(LatLng(state.result.lat, state.result.lng));
            _animateTo(state.result.lat, state.result.lng);
          }
        } else if (state is LocationPickerGeocodingError) {
          AppSnackBar.show(
            context,
            message: state.message,
            type: SnackBarType.error,
          );
        } else if (state is LocationPickerGpsError) {
          AppSnackBar.show(
            context,
            message: tr('location_picker.gps_error'),
            type: SnackBarType.error,
          );
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _initialTarget,
                zoom: _initialZoom,
              ),
              style: Theme.of(context).brightness == Brightness.dark
                  ? AppMapStyle.dark
                  : AppMapStyle.light,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              markers: _markers,
              onMapCreated: (controller) => _controller.complete(controller),
              onTap: (position) {
                if (_isSearching) {
                  _closeSearch();
                  return;
                }
                _addMarker(position);
                context.read<LocationPickerCubit>().reverseGeocode(
                      position.latitude,
                      position.longitude,
                    );
              },
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  LocationPickerHeader(
                    isSearching: _isSearching,
                    onSearchTap: _openSearch,
                    onSearchClose: _closeSearch,
                    searchController: _searchController,
                    onSearchChanged: _onSearchChanged,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: LocationPickerSuggestionsPanel(
                      isVisible: _isSearching,
                    ),
                  ),
                ],
              ),
            ),
            if (!_isSearching) ...[
              Positioned(
                bottom: 80.h + MediaQuery.paddingOf(context).bottom,
                right: 16.w,
                child: const LocationPickerGpsButton(),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: const LocationPickerConfirmButton(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
