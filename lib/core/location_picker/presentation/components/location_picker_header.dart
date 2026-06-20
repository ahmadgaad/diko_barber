import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zain/core/theme/app_colors.dart';
import 'package:zain/core/location_picker/presentation/cubit/location_picker_cubit.dart';
import 'package:zain/core/location_picker/presentation/cubit/location_picker_state.dart';

class LocationPickerHeader extends StatelessWidget {
  const LocationPickerHeader({
    super.key,
    required this.isSearching,
    required this.onSearchTap,
    required this.onSearchClose,
    required this.searchController,
    required this.onSearchChanged,
  });

  final bool isSearching;
  final VoidCallback onSearchTap;
  final VoidCallback onSearchClose;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: colors.neutral900.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: SafeArea(
            bottom: false,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 42.r,
                    height: 42.r,
                    decoration: BoxDecoration(
                      color: colors.neutral900.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                      size: 20.r,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: AnimatedCrossFade(
                    duration: const Duration(milliseconds: 280),
                    sizeCurve: Curves.easeInOut,
                    crossFadeState: isSearching
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    firstChild: _AddressBar(colors: colors),
                    secondChild: _SearchInput(
                      controller: searchController,
                      onChanged: onSearchChanged,
                      onClose: onSearchClose,
                      colors: colors,
                    ),
                  ),
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 280),
                  curve: Curves.easeInOut,
                  child: isSearching
                      ? const SizedBox.shrink()
                      : Padding(
                          padding: EdgeInsetsDirectional.only(start: 10.w),
                          child: GestureDetector(
                            onTap: onSearchTap,
                            child: Container(
                              width: 42.r,
                              height: 42.r,
                              decoration: BoxDecoration(
                                color:
                                    colors.neutral900.withValues(alpha: 0.5),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.search_rounded,
                                color: Colors.white,
                                size: 20.r,
                              ),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AddressBar extends StatelessWidget {
  const _AddressBar({required this.colors});
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationPickerCubit, LocationPickerState>(
      buildWhen: (_, curr) =>
          curr is LocationPickerGeocoded ||
          curr is LocationPickerGeocoding ||
          curr is LocationPickerInitial,
      builder: (context, state) {
        final address = switch (state) {
          LocationPickerGeocoded(:final result) => result.formattedAddress,
          LocationPickerGeocoding(:final lastResult) =>
            lastResult?.formattedAddress,
          _ => null,
        };
        final isLoading = state is LocationPickerGeocoding;
        return Container(
          height: 42.r,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: colors.neutral900.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(999.r),
          ),
          child: Row(
            children: [
              Icon(Icons.location_on_rounded, size: 15.r, color: splashOrange),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  address ?? tr('location_picker.select_hint'),
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isLoading) ...[
                SizedBox(width: 6.w),
                SizedBox(
                  width: 12.r,
                  height: 12.r,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    color: splashOrange,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _SearchInput extends StatefulWidget {
  const _SearchInput({
    required this.controller,
    required this.onChanged,
    required this.onClose,
    required this.colors,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClose;
  final AppColors colors;

  @override
  State<_SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<_SearchInput> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerChanged);
  }

  void _onControllerChanged() {
    final hasText = widget.controller.text.isNotEmpty;
    if (hasText != _hasText) setState(() => _hasText = hasText);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42.r,
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: widget.colors.neutral900.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search_rounded,
            color: Colors.white.withValues(alpha: 0.7),
            size: 18.r,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: TextField(
              controller: widget.controller,
              autofocus: true,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
              textInputAction: TextInputAction.search,
              onChanged: widget.onChanged,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: tr('location_picker.search_hint'),
                hintStyle: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 9.h),
              ),
            ),
          ),
          GestureDetector(
            onTap: _hasText
                ? () {
                    widget.controller.clear();
                    widget.onChanged('');
                  }
                : widget.onClose,
            child: Icon(
              Icons.close_rounded,
              color: Colors.white.withValues(alpha: 0.7),
              size: 18.r,
            ),
          ),
        ],
      ),
    );
  }
}
