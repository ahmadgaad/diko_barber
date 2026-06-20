import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zain/core/widgets/app_gradient_button.dart';
import 'package:zain/core/widgets/app_snack_bar.dart';
import 'package:zain/core/location_picker/domain/entities/picked_location.dart';
import 'package:zain/core/location_picker/presentation/cubit/location_picker_cubit.dart';
import 'package:zain/core/location_picker/presentation/cubit/location_picker_state.dart';

class LocationPickerConfirmButton extends StatelessWidget {
  const LocationPickerConfirmButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationPickerCubit, LocationPickerState>(
      buildWhen: (_, curr) =>
          curr is LocationPickerGeocoded || curr is LocationPickerInitial,
      builder: (context, state) {
        final result =
            state is LocationPickerGeocoded ? state.result : null;
        return Padding(
          padding: EdgeInsets.fromLTRB(
            16.w,
            0,
            16.w,
            MediaQuery.paddingOf(context).bottom + 16.h,
          ),
          child: AppGradientButton(
            label: tr('location_picker.confirm'),
            onTap: () {
              if (result == null) {
                AppSnackBar.show(
                  context,
                  message: tr('location_picker.select_first'),
                  type: SnackBarType.info,
                );
                return;
              }
              Navigator.pop(
                context,
                PickedLocation(
                  lat: result.lat,
                  lng: result.lng,
                  address: result.formattedAddress,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
