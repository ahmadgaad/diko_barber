import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:zain/core/router/app_routes.dart';
import 'package:zain/core/theme/app_colors.dart';
import 'package:zain/features/booking/presentation/cubit/bookings_cubit.dart';

class PaymentWebviewScreen extends StatefulWidget {
  const PaymentWebviewScreen({
    super.key,
    required this.checkoutUrl,
    required this.returnUrl,
  });

  final String checkoutUrl;
  final String returnUrl;

  @override
  State<PaymentWebviewScreen> createState() => _PaymentWebviewScreenState();
}

class _PaymentWebviewScreenState extends State<PaymentWebviewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (_) {
          if (mounted) setState(() => _isLoading = true);
        },
        onPageFinished: (_) {
          if (mounted) setState(() => _isLoading = false);
        },
        onNavigationRequest: (request) {
          if (request.url.contains(widget.returnUrl)) {
            BookingsCubit.pendingRefresh = true;
            context.go(AppRoutes.bookings);
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ))
      ..loadRequest(Uri.parse(widget.checkoutUrl));
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Scaffold(
      backgroundColor: colors.neutral50,
      appBar: AppBar(
        backgroundColor: colors.neutral50,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () {
            BookingsCubit.pendingRefresh = true;
            context.go(AppRoutes.bookings);
          },
        ),
        title: Text(
          tr('checkout.payment'),
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: colors.neutral900,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            LinearProgressIndicator(
              color: splashOrange,
              backgroundColor: colors.neutral200,
            ),
        ],
      ),
    );
  }
}
