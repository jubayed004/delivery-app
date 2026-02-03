import 'package:delivery_app/core/di/injection.dart';
import 'package:delivery_app/core/service/datasource/local/local_service.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:delivery_app/core/router/route_path.dart';
import 'package:delivery_app/core/router/routes.dart';
import 'package:delivery_app/share/widgets/custom_image/custom_image.dart';
import 'package:delivery_app/utils/extension/base_extension.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _cityController;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _logoScaleAnimation;
  late Animation<Offset> _citySlideAnimation;
  final LocalService localService = sl();
  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _cityController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _logoController, curve: Curves.easeIn));

    _logoScaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );

    _citySlideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _cityController, curve: Curves.easeOut));

    _startAnimations();

    _handleNavigationFlow();

    _navigateToNextScreen();
  }

  void _startAnimations() async {
    _logoController.forward();

    await Future.delayed(const Duration(milliseconds: 500));
    _cityController.forward();
  }

  void _navigateToNextScreen() async {
    await Future.delayed(const Duration(milliseconds: 4000));
    if (mounted) {
      AppRouter.route.pushReplacementNamed(RoutePath.onboardingScreen);
    }
  }

  Future<void> _handleNavigationFlow() async {
    try {
      final token = await localService.getToken();
      if (token.isEmpty || JwtDecoder.isExpired(token)) {
        AppRouter.route.goNamed(RoutePath.onboardingScreen);
        return;
      }
      final role = await localService.getRole();
      if (role == "DRIVER") {
        final status = await localService.getStatus();
        final isProfileCompleted = await localService.getIsProfileCompleted();
        print(status);
        print(isProfileCompleted);
        if (status == "PENDING") {
          if (!isProfileCompleted) {
            AppRouter.route.goNamed(RoutePath.commuterRegistrationScreen);
          } else {
            AppRouter.route.goNamed(RoutePath.adminApprovalScreen);
          }
        } else {
          AppRouter.route.goNamed(RoutePath.driverNavScreen);
        }
      } else {
        AppRouter.route.goNamed(RoutePath.parcelOwnerNavScreen);
      }
    } catch (e) {
      AppRouter.route.goNamed(RoutePath.onboardingScreen);
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: FadeTransition(
              opacity: _logoFadeAnimation,
              child: ScaleTransition(
                scale: _logoScaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo image
                    CustomImage(imageSrc: "assets/images/splashmainlogo.png"),
                  ],
                ),
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: SlideTransition(
              position: _citySlideAnimation,
              child: CustomImage(
                width: context.screenWidth,
                imageSrc: "assets/images/simage.png",
              ),
            ),
          ),

          Positioned(
            bottom: 120,
            left: 30,
            child: FadeTransition(
              opacity: _logoFadeAnimation,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.10, end: 2.0),
                duration: const Duration(milliseconds: 2000),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: 0.9 + (0.2 * (value % 2)),
                    child: child,
                  );
                },
                child: CustomImage(imageSrc: "assets/icons/slogo.svg"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
