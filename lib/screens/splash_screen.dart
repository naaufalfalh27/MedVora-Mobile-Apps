import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:intl/intl.dart';
import 'privacy_policy_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<double> _textFade;
  late Animation<double> _particlesAnim;
  late Animation<double> _exitAnim;

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _logoScale = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(parent: _mainController, curve: Curves.easeOutExpo),
    );

    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _mainController, curve: const Interval(0.1, 0.4)),
    );

    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _mainController, curve: const Interval(0.4, 0.7)),
    );

    _particlesAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _mainController, curve: Curves.easeInOut),
    );

    _exitAnim = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _mainController, curve: const Interval(0.85, 1.0, curve: Curves.easeInOutCirc)),
    );

    _mainController.forward();

    Future.delayed(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 1200),
          pageBuilder: (_, __, ___) => const PrivacyPolicyScreen(),
          transitionsBuilder: (_, animation, __, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 1.0),
                end: Offset.zero,
              ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutQuart)),
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    super.dispose();
  }

  Widget _buildParticles(Size size) {
    final particles = List.generate(40, (i) {
      final angle = 2 * pi * i / 40;
      final radius = 100 + 30 * sin(i * 2);
      final offset = Offset(
        size.width / 2 + radius * cos(angle),
        size.height / 2 + radius * sin(angle),
      );
      return Positioned(
        left: offset.dx,
        top: offset.dy,
        child: AnimatedBuilder(
          animation: _particlesAnim,
          builder: (_, __) => Transform.scale(
            scale: _particlesAnim.value,
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      );
    });
    return Stack(children: particles);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final timeNow = DateFormat('HH:mm').format(DateTime.now());

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 77, 22, 154),
      body: AnimatedBuilder(
        animation: _mainController,
        builder: (_, __) {
          return Opacity(
            opacity: _exitAnim.value,
            child: Stack(
              children: [
                _buildParticles(size),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ScaleTransition(
                        scale: _logoScale,
                        child: FadeTransition(
                          opacity: _logoFade,
                          child: Container(
                            padding: const EdgeInsets.all(28),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.tealAccent.withOpacity(0.5),
                                  blurRadius: 50,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                            child: Image.asset(
                              'assets/images/nurse.png',
                              height: 100,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      FadeTransition(
                        opacity: _textFade,
                        child: Column(
                          children: [
                            const Text(
                              'Medvora',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 2,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              '',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}