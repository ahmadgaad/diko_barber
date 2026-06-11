import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ronaq_barber/core/theme/app_colors.dart';
import 'package:ronaq_barber/features/explore/presentation/cubit/explore_cubit.dart';
import 'package:ronaq_barber/features/explore/presentation/cubit/explore_state.dart';

class ExploreSearchBar extends StatefulWidget {
  const ExploreSearchBar({super.key});

  @override
  State<ExploreSearchBar> createState() => _ExploreSearchBarState();
}

class _ExploreSearchBarState extends State<ExploreSearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    // Restore the active query when returning to this tab — the cubit
    // outlives the view, the text field does not.
    final state = context.read<ExploreCubit>().state;
    _controller = TextEditingController(
      text: state is ExploreLoaded ? state.query : '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return TextField(
      controller: _controller,
      onChanged: (value) {
        context.read<ExploreCubit>().search(value);
        // Rebuild only to toggle the clear button.
        setState(() {});
      },
      textInputAction: TextInputAction.search,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: colors.neutral900,
      ),
      decoration: InputDecoration(
        hintText: tr('explore.search_hint'),
        hintStyle: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: colors.neutral400,
        ),
        prefixIcon: Icon(
          Icons.search_rounded,
          color: colors.neutral400,
          size: 22.r,
        ),
        suffixIcon: _controller.text.isEmpty
            ? null
            : IconButton(
                icon: Icon(
                  Icons.close_rounded,
                  color: colors.neutral400,
                  size: 18.r,
                ),
                onPressed: () {
                  _controller.clear();
                  context.read<ExploreCubit>().search('');
                  setState(() {});
                },
              ),
        filled: true,
        fillColor: colors.neutral100,
        contentPadding: EdgeInsets.symmetric(vertical: 12.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(color: colors.neutral200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: const BorderSide(color: splashOrange, width: 1.5),
        ),
      ),
    );
  }
}
