import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:zain/core/theme/app_colors.dart';
import 'package:zain/features/packages/presentation/components/package_grid_card.dart';
import 'package:zain/features/packages/presentation/components/package_list_card.dart';
import 'package:zain/features/packages/presentation/components/packages_layout_mode.dart';
import 'package:zain/features/packages/presentation/cubit/packages_list_cubit.dart';
import 'package:zain/features/packages/presentation/cubit/packages_list_state.dart';

class PackagesContent extends StatelessWidget {
  const PackagesContent({
    super.key,
    required this.state,
    required this.colors,
    required this.mode,
  });

  final PackagesListLoaded state;
  final AppColors colors;
  final PackagesLayoutMode mode;

  @override
  Widget build(BuildContext context) {
    if (state.packages.isEmpty) {
      return Center(
        child: Text(
          tr('explore.no_results_title'),
          style: TextStyle(fontSize: 14.sp, color: colors.neutral500),
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (n) {
        if (n is ScrollEndNotification &&
            n.metrics.pixels >= n.metrics.maxScrollExtent - 200) {
          context.read<PackagesListCubit>().loadMore();
        }
        return false;
      },
      child: RefreshIndicator(
        color: splashOrange,
        onRefresh: () => context.read<PackagesListCubit>().refresh(),
        child: CustomScrollView(
          slivers: [
            if (mode == PackagesLayoutMode.grid)
              _GridSliver(state: state, colors: colors)
            else
              _ListSliver(state: state, colors: colors),
            if (state.isLoadingMore)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  child: Center(
                    child: SizedBox(
                      width: 24.r,
                      height: 24.r,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: splashOrange,
                      ),
                    ),
                  ),
                ),
              ),
            if (state.loadMoreFailed)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: Center(
                    child: TextButton(
                      onPressed: () =>
                          context.read<PackagesListCubit>().loadMore(),
                      child: Text(
                        tr('explore.load_more_failed'),
                        style: const TextStyle(color: splashOrange),
                      ),
                    ),
                  ),
                ),
              ),
            SliverToBoxAdapter(child: SizedBox(height: 24.h)),
          ],
        ),
      ),
    );
  }
}

class _GridSliver extends StatelessWidget {
  const _GridSliver({required this.state, required this.colors});

  final PackagesListLoaded state;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 0),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.h,
          mainAxisExtent: 240.h,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, i) => GestureDetector(
            onTap: () => context.push('/package/${state.packages[i].id}'),
            child: PackageGridCard(
              package: state.packages[i],
              colors: colors,
            ),
          ),
          childCount: state.packages.length,
        ),
      ),
    );
  }
}

class _ListSliver extends StatelessWidget {
  const _ListSliver({required this.state, required this.colors});

  final PackagesListLoaded state;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, i) => Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: GestureDetector(
              onTap: () => context.push('/package/${state.packages[i].id}'),
              child: PackageListCard(
                package: state.packages[i],
                colors: colors,
              ),
            ),
          ),
          childCount: state.packages.length,
        ),
      ),
    );
  }
}
