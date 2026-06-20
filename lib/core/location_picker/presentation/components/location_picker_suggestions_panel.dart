import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zain/core/theme/app_colors.dart';
import 'package:zain/core/location_picker/domain/entities/place_prediction.dart';
import 'package:zain/core/location_picker/presentation/cubit/location_picker_cubit.dart';
import 'package:zain/core/location_picker/presentation/cubit/location_picker_state.dart';

class LocationPickerSuggestionsPanel extends StatelessWidget {
  const LocationPickerSuggestionsPanel({super.key, required this.isVisible});

  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 250),
      opacity: isVisible ? 1.0 : 0.0,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        offset: isVisible ? Offset.zero : const Offset(0, -0.08),
        child: IgnorePointer(
          ignoring: !isVisible,
          child: Container(
            constraints: BoxConstraints(maxHeight: 300.h),
            margin: EdgeInsets.symmetric(horizontal: 10.w),
            decoration: BoxDecoration(
              color: colors.neutral900.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: BlocBuilder<LocationPickerCubit, LocationPickerState>(
              buildWhen: (_, curr) =>
                  curr is LocationPickerSearching ||
                  curr is LocationPickerSuggestions ||
                  curr is LocationPickerSearchCleared,
              builder: (context, state) {
                if (state is LocationPickerSearching) {
                  return Padding(
                    padding: EdgeInsets.all(24.h),
                    child: Center(
                      child: SizedBox(
                        width: 24.r,
                        height: 24.r,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: splashOrange,
                        ),
                      ),
                    ),
                  );
                }

                if (state is LocationPickerSuggestions) {
                  if (state.predictions.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.all(24.h),
                      child: Center(
                        child: Text(
                          tr('location_picker.no_results'),
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                    );
                  }
                  return ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    separatorBuilder: (_, _) => Divider(
                      color: Colors.white.withValues(alpha: 0.12),
                      height: 1,
                    ),
                    itemCount: state.predictions.length,
                    itemBuilder: (context, index) => _SuggestionItem(
                      prediction: state.predictions[index],
                      query: state.query,
                      colors: colors,
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _SuggestionItem extends StatelessWidget {
  const _SuggestionItem({
    required this.prediction,
    required this.query,
    required this.colors,
  });

  final PlacePrediction prediction;
  final String query;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          context.read<LocationPickerCubit>().selectPrediction(prediction),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Row(
          children: [
            Container(
              width: 36.r,
              height: 36.r,
              decoration: BoxDecoration(
                color: splashOrange.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.location_on_outlined,
                size: 18.r,
                color: splashOrange,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      children: _buildHighlightedSpans(
                        prediction.mainText,
                        query,
                      ),
                    ),
                  ),
                  if (prediction.secondaryText.isNotEmpty) ...[
                    SizedBox(height: 2.h),
                    Text(
                      prediction.secondaryText,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<TextSpan> _buildHighlightedSpans(String text, String query) {
    if (query.isEmpty) return [TextSpan(text: text)];

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final spans = <TextSpan>[];
    var start = 0;

    var index = lowerText.indexOf(lowerQuery, start);
    while (index != -1) {
      if (index > start) {
        spans.add(TextSpan(text: text.substring(start, index)));
      }
      spans.add(
        TextSpan(
          text: text.substring(index, index + query.length),
          style: TextStyle(color: splashOrange, fontWeight: FontWeight.w800),
        ),
      );
      start = index + query.length;
      index = lowerText.indexOf(lowerQuery, start);
    }

    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start)));
    }

    return spans;
  }
}
