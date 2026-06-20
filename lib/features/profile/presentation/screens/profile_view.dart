import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zain/core/resources/svg_resources.dart';
import 'package:zain/core/router/app_routes.dart';
import 'package:zain/core/theme/app_colors.dart';
import 'package:zain/core/theme/cubit/theme_cubit.dart';
import 'package:zain/core/theme/cubit/theme_state.dart';
import 'package:zain/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:zain/features/profile/presentation/cubit/profile_state.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return BlocConsumer<ProfileCubit, ProfileState>(
      listenWhen: (previous, current) => current is ProfileLoggedOut,
      listener: (context, state) => context.go(AppRoutes.login),
      builder: (context, state) => switch (state) {
        ProfileLoading() => _ProfileShimmer(colors: colors),
        ProfileError() => const SizedBox.shrink(),
        ProfileLoggedOut() => const SizedBox.shrink(),
        ProfileLoaded() => _ProfileContent(state: state, colors: colors),
      },
    );
  }
}

// ── Reusable SVG glyph ─────────────────────────────────────────────────────────

class _Svg extends StatelessWidget {
  const _Svg(this.asset, {required this.color, required this.size});

  final String asset;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      asset,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}

// ── Loaded content ────────────────────────────────────────────────────────────

class _ProfileContent extends StatelessWidget {
  const _ProfileContent({required this.state, required this.colors});

  final ProfileLoaded state;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        children: [
          SizedBox(height: 20.h),
          _Avatar(state: state, colors: colors),
          SizedBox(height: 14.h),
          _Identity(state: state, colors: colors),
          SizedBox(height: 18.h),
          _StatsRow(state: state, colors: colors),
          SizedBox(height: 24.h),
          _SectionLabel(tr('profile.section_account'), colors: colors),
          _SettingsGroup(
            colors: colors,
            children: [
              _SettingsTile(
                asset: SvgResources.user,
                accent: colors.primary500,
                label: tr('profile.edit_profile'),
                colors: colors,
                onTap: () {},
              ),
              _SettingsTile(
                asset: SvgResources.star,
                accent: const Color(0xFFFFB300),
                label: tr('profile.my_reviews'),
                colors: colors,
                onTap: () {},
              ),
              _SettingsTile(
                asset: SvgResources.deleteAccount,
                accent: colors.error500,
                label: tr('profile.delete_account'),
                colors: colors,
                onTap: () => _showDeleteAccountSheet(context, colors),
                isLast: true,
              ),
            ],
          ),
          SizedBox(height: 18.h),
          _SectionLabel(tr('profile.section_preferences'), colors: colors),
          _SettingsGroup(
            colors: colors,
            children: [
              _NotificationsTile(state: state, colors: colors),
              _ThemeTile(colors: colors),
              // _LanguageTile(colors: colors),
            ],
          ),
          SizedBox(height: 18.h),
          _SectionLabel(tr('profile.section_legal'), colors: colors),
          _SettingsGroup(
            colors: colors,
            children: [
              _SettingsTile(
                asset: SvgResources.document,
                accent: colors.info500,
                label: tr('profile.terms'),
                colors: colors,
                onTap: () {},
              ),
              _SettingsTile(
                asset: SvgResources.shield,
                accent: colors.success600,
                label: tr('profile.privacy'),
                colors: colors,
                onTap: () {},
              ),
              _SettingsTile(
                asset: SvgResources.info,
                accent: colors.neutral500,
                label: tr('profile.about'),
                colors: colors,
                onTap: () {},
                isLast: true,
              ),
            ],
          ),
          SizedBox(height: 22.h),
          _SignOutButton(colors: colors),
          SizedBox(height: 14.h),
          Text(
            tr('profile.version', namedArgs: {'version': '1.0.0'}),
            style: TextStyle(fontSize: 11.sp, color: colors.neutral400),
          ),
          SizedBox(height: 100.h),
        ],
      ),
    );
  }
}

// ── Avatar ────────────────────────────────────────────────────────────────────

class _Avatar extends StatelessWidget {
  const _Avatar({required this.state, required this.colors});
  final ProfileLoaded state;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 92.r,
          height: 92.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: colors.neutral50, width: 3.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipOval(
            child: CachedNetworkImage(
              imageUrl: state.avatarUrl,
              fit: BoxFit.cover,
              placeholder: (_, _) => Container(color: colors.neutral200),
              errorWidget: (_, _, _) => Container(
                color: colors.neutral200,
                alignment: Alignment.center,
                child: _Svg(
                  SvgResources.user,
                  color: colors.neutral400,
                  size: 38.r,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 28.r,
            height: 28.r,
            decoration: BoxDecoration(
              color: splashOrange,
              shape: BoxShape.circle,
              border: Border.all(color: colors.neutral50, width: 2.5),
            ),
            alignment: Alignment.center,
            child: _Svg(SvgResources.edit, color: Colors.white, size: 13.r),
          ),
        ),
      ],
    );
  }
}

// ── Identity (name / email / phone) ───────────────────────────────────────────

class _Identity extends StatelessWidget {
  const _Identity({required this.state, required this.colors});
  final ProfileLoaded state;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          state.name,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: colors.neutral900,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          state.email,
          style: TextStyle(fontSize: 13.sp, color: colors.neutral500),
        ),
        SizedBox(height: 2.h),
        Text(
          state.phone,
          style: TextStyle(fontSize: 13.sp, color: colors.neutral400),
        ),
      ],
    );
  }
}

// ── Stats row ─────────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.state, required this.colors});
  final ProfileLoaded state;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Expanded(
            child: _StatCard(
              asset: SvgResources.loyalty,
              accent: const Color(0xFFFFB300),
              label: tr('profile.loyalty_points'),
              value: '${state.loyaltyPoints}',
              colors: colors,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _StatCard(
              asset: SvgResources.wallet,
              accent: colors.success500,
              label: tr('profile.wallet_balance'),
              value: '${state.walletBalance.toInt()} ${tr('home.currency')}',
              colors: colors,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.asset,
    required this.accent,
    required this.label,
    required this.value,
    required this.colors,
  });

  final String asset;
  final Color accent;
  final String label;
  final String value;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: colors.neutral100,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: colors.neutral200),
      ),
      child: Row(
        children: [
          Container(
            width: 42.r,
            height: 42.r,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(13.r),
            ),
            alignment: Alignment.center,
            child: _Svg(asset, color: accent, size: 22.r),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 10.5.sp, color: colors.neutral500),
                ),
                SizedBox(height: 3.h),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: accent,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section label ─────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text, {required this.colors});
  final String text;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 8.h),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          text.toUpperCase(),
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
            color: colors.neutral400,
          ),
        ),
      ),
    );
  }
}

// ── Settings group (card container) ──────────────────────────────────────────

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.children, required this.colors});
  final List<Widget> children;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: colors.neutral100,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: colors.neutral200),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }
}

// ── Settings tile ─────────────────────────────────────────────────────────────

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.asset,
    required this.accent,
    required this.label,
    required this.colors,
    required this.onTap,
    this.trailing,
    this.isLast = false,
  });

  final String asset;
  final Color accent;
  final String label;
  final AppColors colors;
  final VoidCallback onTap;
  final Widget? trailing;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: accent.withValues(alpha: 0.06),
        highlightColor: accent.withValues(alpha: 0.04),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              child: Row(
                children: [
                  Container(
                    width: 38.r,
                    height: 38.r,
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(11.r),
                    ),
                    alignment: Alignment.center,
                    child: _Svg(asset, color: accent, size: 19.r),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: colors.neutral800,
                      ),
                    ),
                  ),
                  trailing ??
                      SvgPicture.asset(
                        SvgResources.chevronRight,
                        width: 18.r,
                        height: 18.r,
                        matchTextDirection: true,
                        colorFilter: ColorFilter.mode(
                          colors.neutral400,
                          BlendMode.srcIn,
                        ),
                      ),
                ],
              ),
            ),
            if (!isLast)
              Divider(height: 1, indent: 64.w, color: colors.neutral200),
          ],
        ),
      ),
    );
  }
}

// ── Notifications tile ────────────────────────────────────────────────────────

class _NotificationsTile extends StatelessWidget {
  const _NotificationsTile({required this.state, required this.colors});

  final ProfileLoaded state;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return _SettingsTile(
      asset: SvgResources.bell,
      accent: colors.warning500,
      label: tr('profile.notifications'),
      colors: colors,
      onTap: () => context.read<ProfileCubit>().toggleNotifications(),
      trailing: Switch.adaptive(
        value: state.notificationsEnabled,
        onChanged: (_) => context.read<ProfileCubit>().toggleNotifications(),
        activeThumbColor: splashOrange,
        activeTrackColor: splashOrange.withValues(alpha: 0.45),
      ),
    );
  }
}

// ── Theme toggle tile ─────────────────────────────────────────────────────────

class _ThemeTile extends StatelessWidget {
  const _ThemeTile({required this.colors});
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        const indigo = Color(0xFF818CF8);
        const amber = Color(0xFFFFB300);
        return _SettingsTile(
          asset: themeState.isDark ? SvgResources.moon : SvgResources.sun,
          accent: themeState.isDark ? indigo : amber,
          label: tr('profile.theme'),
          colors: colors,
          onTap: () => context.read<ThemeCubit>().toggle(),
          trailing: Switch.adaptive(
            value: themeState.isDark,
            onChanged: (_) => context.read<ThemeCubit>().toggle(),
            activeThumbColor: indigo,
            activeTrackColor: indigo.withValues(alpha: 0.45),
          ),
        );
      },
    );
  }
}

// ── Language tile ─────────────────────────────────────────────────────────────

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({required this.colors});
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    return _SettingsTile(
      asset: SvgResources.language,
      accent: colors.success600,
      label: tr('profile.language'),
      colors: colors,
      isLast: true,
      onTap: () =>
          context.setLocale(isArabic ? const Locale('en') : const Locale('ar')),
      trailing: Container(
        padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: colors.neutral200,
          borderRadius: BorderRadius.circular(999.r),
        ),
        child: Text(
          isArabic ? 'English' : 'عربي',
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: colors.neutral700,
          ),
        ),
      ),
    );
  }
}

// ── Sign out button ───────────────────────────────────────────────────────────

class _SignOutButton extends StatelessWidget {
  const _SignOutButton({required this.colors});
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Material(
        color: colors.error50,
        borderRadius: BorderRadius.circular(16.r),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => _confirmSignOut(context),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 15.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: colors.error200),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _Svg(SvgResources.logout, color: colors.error500, size: 18.r),
                SizedBox(width: 8.w),
                Text(
                  tr('profile.sign_out'),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: colors.error500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _confirmSignOut(BuildContext context) {
    final colors = AppColors.of(context);
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: colors.neutral100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 36.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              margin: EdgeInsets.only(bottom: 22.h),
              decoration: BoxDecoration(
                color: colors.neutral300,
                borderRadius: BorderRadius.circular(999.r),
              ),
            ),
            Container(
              width: 58.r,
              height: 58.r,
              decoration: BoxDecoration(
                color: colors.error50,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: _Svg(
                SvgResources.logout,
                color: colors.error500,
                size: 26.r,
              ),
            ),
            SizedBox(height: 14.h),
            Text(
              tr('profile.sign_out_confirm_title'),
              style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.w700,
                color: colors.neutral900,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              tr('profile.sign_out_confirm_body'),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.sp, color: colors.neutral500),
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: _SheetButton(
                    label: tr('profile.cancel'),
                    background: colors.neutral200,
                    foreground: colors.neutral700,
                    onTap: () => Navigator.of(ctx).pop(),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _SheetButton(
                    label: tr('profile.sign_out'),
                    background: colors.error500,
                    foreground: Colors.white,
                    onTap: () {
                      Navigator.of(ctx).pop();
                      context.read<ProfileCubit>().logout();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void _showDeleteAccountSheet(BuildContext context, AppColors colors) {
  showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    backgroundColor: colors.neutral100,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)),
    ),
    builder: (ctx) => Padding(
      padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 36.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40.w,
            height: 4.h,
            margin: EdgeInsets.only(bottom: 22.h),
            decoration: BoxDecoration(
              color: colors.neutral300,
              borderRadius: BorderRadius.circular(999.r),
            ),
          ),
          Container(
            width: 58.r,
            height: 58.r,
            decoration: BoxDecoration(
              color: colors.error50,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: _Svg(
              SvgResources.deleteAccount,
              color: colors.error500,
              size: 26.r,
            ),
          ),
          SizedBox(height: 14.h),
          Text(
            tr('profile.delete_account_confirm_title'),
            style: TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.w700,
              color: colors.neutral900,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            tr('profile.delete_account_confirm_body'),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13.sp, color: colors.neutral500),
          ),
          SizedBox(height: 24.h),
          Row(
            children: [
              Expanded(
                child: _SheetButton(
                  label: tr('profile.cancel'),
                  background: colors.neutral200,
                  foreground: colors.neutral700,
                  onTap: () => Navigator.of(ctx).pop(),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _SheetButton(
                  label: tr('profile.delete_account'),
                  background: colors.error500,
                  foreground: Colors.white,
                  onTap: () {
                    Navigator.of(ctx).pop();
                    // TODO: call DeleteAccountUseCase when endpoint is ready
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class _SheetButton extends StatelessWidget {
  const _SheetButton({
    required this.label,
    required this.background,
    required this.foreground,
    required this.onTap,
  });

  final String label;
  final Color background;
  final Color foreground;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: foreground,
          ),
        ),
      ),
    );
  }
}

// ── Shimmer ───────────────────────────────────────────────────────────────────

class _ProfileShimmer extends StatelessWidget {
  const _ProfileShimmer({required this.colors});
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    Widget block(double w, double h, [double r = 8]) => Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: colors.neutral200,
        borderRadius: BorderRadius.circular(r.r),
      ),
    );

    return Shimmer.fromColors(
      baseColor: colors.neutral200,
      highlightColor: colors.neutral100,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            Container(height: 168.h, color: colors.neutral200),
            SizedBox(height: 60.h),
            block(140.w, 20.h),
            SizedBox(height: 8.h),
            block(200.w, 14.h),
            SizedBox(height: 4.h),
            block(120.w, 14.h),
            SizedBox(height: 22.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  Expanded(child: block(double.infinity, 72.h, 18)),
                  SizedBox(width: 12.w),
                  Expanded(child: block(double.infinity, 72.h, 18)),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  block(double.infinity, 116.h, 18),
                  SizedBox(height: 18.h),
                  block(double.infinity, 168.h, 18),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
