import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zain/core/theme/app_colors.dart';
import 'package:zain/core/location_picker/presentation/cubit/location_picker_cubit.dart';
import 'package:zain/core/location_picker/presentation/cubit/location_picker_state.dart';

class LocationPickerGpsButton extends StatelessWidget {
  const LocationPickerGpsButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return BlocBuilder<LocationPickerCubit, LocationPickerState>(
      buildWhen: (_, curr) =>
          curr is LocationPickerGpsLoading ||
          curr is LocationPickerGpsLoaded ||
          curr is LocationPickerGpsError ||
          curr is LocationPickerInitial,
      builder: (context, state) {
        final isLoading = state is LocationPickerGpsLoading;
        return GestureDetector(
          onTap: isLoading
              ? null
              : () =>
                    context.read<LocationPickerCubit>().fetchCurrentLocation(),
          child: Container(
            width: 44.r,
            height: 44.r,
            decoration: BoxDecoration(
              color: colors.neutral50,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: isLoading
                ? Padding(
                    padding: EdgeInsets.all(12.r),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: splashOrange,
                    ),
                  )
                : Icon(
                    Icons.my_location_rounded,
                    size: 20.r,
                    color: splashOrange,
                  ),
          ),
        );
      },
    );
  }
}
