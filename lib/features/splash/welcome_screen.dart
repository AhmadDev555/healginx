import 'package:flutter/material.dart';
import 'package:healginx/features/login/ui/login.dart';
import 'package:healginx/styles/app_colors.dart';
import 'package:healginx/styles/app_theme.dart';



class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late AnimationController _imageController;
  late AnimationController _titleController;
  late AnimationController _subtitleController;

  final List<Map<String, String>> _pages = [
    {
      'image': 'assets/images/phlebotomist.png',
      'title': 'Your Personal\n Nutrition Planner',
      'subtitle': 'Achieve your health goals with customized meal plans tailored to your lifestyle',
    },
    {
      'image': 'assets/images/phlebotomist2.png',
      'title': 'Smart Meal Tracking',
      'subtitle': 'Log your meals easily and get real-time nutritional insights for better choices',
    },
    {
      'image': 'assets/images/phlebotomist3.png',
      'title': 'Reach Your Goals Faster',
      'subtitle': 'Track calories, macros, and nutrients with AI-powered recommendations',
    },
  ];

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _imageController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _titleController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
    _subtitleController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );

    // Start the animations
    _startAnimations();
  }

  void _startAnimations() {
    _imageController.forward().then((_) {
      _titleController.forward().then((_) {
        _subtitleController.forward();
      });
    });
  }

  @override
  void dispose() {
    _imageController.dispose();
    _titleController.dispose();
    _subtitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Color(0xFFECEFF1),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });

                    // Reset and start animations for the new page
                    _imageController.reset();
                    _titleController.reset();
                    _subtitleController.reset();
                    _startAnimations();
                  },
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Animated image
                          AnimatedBuilder(
                            animation: _imageController,
                            builder: (context, child) {
                              return Opacity(
                                opacity: _imageController.value,
                                child: Transform.translate(
                                  offset: Offset(0, 50 * (1 - _imageController.value)),
                                  child: child,
                                ),
                              );
                            },
                            child: Image.asset(
                              _pages[index]['image']!,
                              height: 400,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 32),

                          // Animated title
                          AnimatedBuilder(
                            animation: _titleController,
                            builder: (context, child) {
                              return Opacity(
                                opacity: _titleController.value,
                                child: Transform.translate(
                                  offset: Offset(0, 30 * (1 - _titleController.value)),
                                  child: child,
                                ),
                              );
                            },
                            child: Text(
                              _pages[index]['title']!,
                              style: AppTheme.theme.textTheme.titleMedium?.copyWith(
                                color: AppColors.primary,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 16),

                          // Animated subtitle
                          AnimatedBuilder(
                            animation: _subtitleController,
                            builder: (context, child) {
                              return Opacity(
                                opacity: _subtitleController.value,
                                child: Transform.translate(
                                  offset: Offset(0, 20 * (1 - _subtitleController.value)),
                                  child: child,
                                ),
                              );
                            },
                            child: Text(
                              _pages[index]['subtitle']!,
                              style: AppTheme.theme.textTheme.bodyMedium?.copyWith(
                                color: Color(0xFF4F4F4F),
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 12),

              // Page indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                      (index) => _buildPageIndicator(index == _currentPage),
                ),
              ),
              SizedBox(height: 32),

              // "Next" button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_currentPage < _pages.length - 1) {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      // Navigate to the next screen
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()),);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF001F54),
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
                    style: AppTheme.theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  // Widget for creating a single page indicator dot
  Widget _buildPageIndicator(bool isActive) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? Color(0xFF001F54) : Color(0xFFB0BEC5),
        shape: BoxShape.circle,
      ),
    );
  }
}
