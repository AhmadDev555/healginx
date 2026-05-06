import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healginx/core/local_cache/shared_preferences.dart';
import 'package:healginx/core/navigation_service.dart';
import 'package:healginx/core/widgets/logout_dialog.dart';
import 'package:healginx/features/chatBot_Screen/ui/chatbot_screen.dart';
import 'package:healginx/features/health_profile/ui/health_profile.dart';
import 'package:healginx/features/login/ui/login.dart';
import 'package:healginx/injection_container.dart';
import 'package:healginx/styles/app_colors.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Healgenix',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF1D6D00),
          surface: Color(0xFFEAFFEC),
          onSurface: Color(0xFF0E1F14),
          onSurfaceVariant: Color(0xFF404A3A),
          outline: Color(0xFF707A68),
          outlineVariant: Color(0xFFBFCAB6),
          error: Color(0xFFBA1A1A),
          onError: Color(0xFFFFFFFF),
        ),
        scaffoldBackgroundColor: const Color(0xFFEAFFEC),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const HealgenixHomeScreen(),
    );
  }
}

class HealgenixHomeScreen extends StatelessWidget {
  const HealgenixHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main content with gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFF8FAF7), Color(0xFFE8F5E1)],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Header
                  const HeaderWidget(),
                  const SizedBox(height: 24),
                  // Main content (scrollable)
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          // Center Illustration & Chat Overlay
                          const HeroSection(),
                          const SizedBox(height: 25),
                          // Buttons section
                          const ButtonsSection(),
                          const SizedBox(height: 48),
                          // Footer tagline
                          Padding(
                            padding: const EdgeInsets.only(bottom: 80),
                            child: Text(
                              'EAT BETTER. LIVE LONGER.',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1.2,
                                color: const Color(0xFF404A3A).withOpacity(0.7),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Bottom Navigation Bar
        ],
      ),
    );
  }
}

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          Row(
            children: [
              const Spacer(),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.eco,
                        size: 32,
                        color: const Color(0xFF1D6D00),
                      ),
                      Positioned(
                        left: 12,
                        child: Icon(
                          Icons.chat_bubble,
                          size: 20,
                          color: const Color(0xFF1D6D00),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Healgenix',
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.24,
                      color: const Color(0xFF1D6D00),
                    ),
                  ),
                ],
              ),

              const Spacer(),

              IconButton(
                onPressed: () async{
                  LogoutDialog.show(context);
                },
                icon: const Icon(Icons.logout,color: AppColors.primary,),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Your Personal AI Nutritionist',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.2,
              color: const Color(0xFF404A3A),
            ),
          ),
        ],
      ),
    );
  }
}

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.width * 0.9,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Blur background circle
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              color: const Color(0xFF1D6D00).withOpacity(0.05),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1D6D00).withOpacity(0.1),
                  blurRadius: 32,
                  spreadRadius: 8,
                ),
              ],
            ),
          ),
          // Food image
          Container(
            width: MediaQuery.of(context).size.width * 0.65,
            height: MediaQuery.of(context).size.width * 0.65,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.07),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
              image: DecorationImage(
                image: AssetImage("assets/images/home_diet.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Floating chat bubble
          Positioned(
            bottom: 0,
            right: MediaQuery.of(context).size.width * 0.08,
            child: Container(
              width: 200,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.85),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.5)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: Color(0xFF4EA731),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.eco,
                          size: 16,
                          color: Colors.white,
                          weight: 700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AI ASSISTANT',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                              color: const Color(0xFF1D6D00),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '"Ready to plan your meals today?"',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.italic,
                              color: const Color(0xFF0E1F14),
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ButtonsSection extends StatelessWidget {
  const ButtonsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // My Profile Button
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.07),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              elevation: 0,
              child: InkWell(
                onTap: () {
                  sl<NavigationService>().push(UserProfileFormScreen());
                },
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.transparent,
                      width: 0,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Stack(
                      children: [
                        // Green left side background
                        Positioned(
                          left: 0,
                          top: 0,
                          bottom: 0,
                          child: Container(
                            width: 5,
                            color: const Color(0xFF4EA731),
                          ),
                        ),
                        // Content
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD9EEDB),
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.person,
                                    size: 28,
                                    color: Color(0xFF1D6D00),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'My Health Profile',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF0E1F14),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Manage your health data',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xFF404A3A),
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              const Icon(
                                Icons.chevron_right,
                                color: Color(0xFFBFCAB6),
                                size: 24,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.07),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: const Color(0xFF4EA731),
              borderRadius: BorderRadius.circular(24),
              elevation: 0,
              child: InkWell(
                onTap: () {
                  sl<NavigationService>().push(const ChatbotScreen());
                },
                borderRadius: BorderRadius.circular(24),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.chat_bubble_outline,
                            size: 28,
                            color: Colors.white,
                            weight: 700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Start Chat',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Talk to Healgenix AI',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

