import 'dart:async';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zain/core/location_picker/presentation/components/location_picker_suggestions_panel.dart';
import 'package:zain/core/location_picker/presentation/cubit/location_picker_cubit.dart';
import 'package:zain/core/location_picker/presentation/cubit/location_picker_state.dart';
import 'package:zain/core/theme/app_colors.dart';
import 'package:zain/core/widgets/app_snack_bar.dart';
import 'package:zain/features/explore/presentation/cubit/explore_cubit.dart';
import 'package:zain/features/explore/presentation/cubit/explore_state.dart';

/// Place search pinned to the top of the explore map, mirroring the location
/// picker: a blurred search input with a live predictions panel. Selecting a
/// prediction reports the geocoded coordinates via [onPlaceSelected].
class ExploreMapSearchSection extends StatefulWidget {
  const ExploreMapSearchSection({super.key, required this.onPlaceSelected});

  final void Function(double lat, double lng, String? address) onPlaceSelected;

  @override
  State<ExploreMapSearchSection> createState() =>
      _ExploreMapSearchSectionState();
}

class _ExploreMapSearchSectionState extends State<ExploreMapSearchSection> {
  final _controller = TextEditingController();
  Timer? _debounce;
  bool _showSuggestions = false;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    final query = value.trim();
    if (query.isEmpty) {
      context.read<LocationPickerCubit>().clearSuggestions();
      if (_showSuggestions) setState(() => _showSuggestions = false);
      return;
    }
    if (!_showSuggestions) setState(() => _showSuggestions = true);
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      context.read<LocationPickerCubit>().fetchSuggestions(query);
    });
  }

  void _clear() {
    _debounce?.cancel();
    _controller.clear();
    context.read<LocationPickerCubit>().clearSuggestions();
    FocusScope.of(context).unfocus();
    setState(() => _showSuggestions = false);
  }

  void _reset() {
    if (_controller.text.isEmpty && !_showSuggestions) return;
    _debounce?.cancel();
    _controller.clear();
    context.read<LocationPickerCubit>().clearSuggestions();
    setState(() => _showSuggestions = false);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LocationPickerCubit, LocationPickerState>(
          listenWhen: (_, current) =>
              current is LocationPickerGeocoded ||
              current is LocationPickerGeocodingError,
          listener: (context, state) {
            if (state is LocationPickerGeocoded) {
              final result = state.result;
              widget.onPlaceSelected(
                result.lat,
                result.lng,
                result.formattedAddress,
              );
              _controller.text = result.formattedAddress;
              FocusScope.of(context).unfocus();
              setState(() => _showSuggestions = false);
            } else if (state is LocationPickerGeocodingError) {
              AppSnackBar.show(
                context,
                message: state.message,
                type: SnackBarType.error,
              );
            }
          },
        ),
        // Clear the field whenever the map resets back to the device location
        // (e.g. the "my location" button drops the searched place).
        BlocListener<ExploreCubit, ExploreState>(
          listenWhen: (previous, current) =>
              previous is ExploreLoaded &&
              current is ExploreLoaded &&
              previous.searchedLat != null &&
              current.searchedLat == null,
          listener: (_, _) => _reset(),
        ),
      ],
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 0),
          child: Column(
            children: [
              _SearchInput(
                controller: _controller,
                onChanged: _onChanged,
                onClear: _clear,
              ),
              SizedBox(height: 8.h),
              LocationPickerSuggestionsPanel(isVisible: _showSuggestions),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchInput extends StatelessWidget {
  const _SearchInput({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(999.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          height: 48.h,
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          decoration: BoxDecoration(
            color: colors.neutral900.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(999.r),
          ),
          child: Row(
            children: [
              Icon(
                Icons.search_rounded,
                color: Colors.white.withValues(alpha: 0.7),
                size: 20.r,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: TextField(
                  controller: controller,
                  onChanged: onChanged,
                  onTapOutside: (_) => FocusScope.of(context).unfocus(),
                  textInputAction: TextInputAction.search,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                    hintText: tr('location_picker.search_hint'),
                    hintStyle: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ),
              ValueListenableBuilder(
                valueListenable: controller,
                builder: (_, value, _) {
                  if (value.text.isEmpty) return const SizedBox.shrink();
                  return GestureDetector(
                    onTap: onClear,
                    child: Padding(
                      padding: EdgeInsetsDirectional.only(start: 8.w),
                      child: Icon(
                        Icons.close_rounded,
                        color: Colors.white.withValues(alpha: 0.7),
                        size: 18.r,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
