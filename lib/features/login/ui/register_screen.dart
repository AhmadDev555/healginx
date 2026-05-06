import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healginx/core/local_cache/shared_preferences.dart';
import 'package:healginx/core/navigation_service.dart';
import 'package:healginx/core/widgets/custom_button.dart';
import 'package:healginx/core/widgets/loading.dart';
import 'package:healginx/features/home/ui/home.dart';
import 'package:healginx/features/login/bloc/login_cubit.dart';
import 'package:healginx/features/login/bloc/login_states.dart';
import 'package:healginx/features/login/ui/login.dart';
import 'package:healginx/injection_container.dart';
import 'package:healginx/styles/app_colors.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final ValueNotifier<bool> isPasswordObscure = ValueNotifier<bool>(true);
  final ValueNotifier<bool> isConfirmPasswordObscure =
  ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    isPasswordObscure.dispose();
    isConfirmPasswordObscure.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFDCFCE7),
            Color(0xFFDBEAFE),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: BlocListener<LoginCubit, LoginStates>(
          listener: _handleRegisterState,
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 24),
                      child: Column(
                        children: [
                          Container(
                            width: 88,
                            height: 88,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.4),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withOpacity(0.5),
                                width: 1,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Image.asset(
                                'assets/images/logo.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Create your account',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Set up your profile and start building your diet plan.',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: AppColors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: RepaintBoundary(
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.75),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.35),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                  const Color(0xFF1E3A8A).withOpacity(0.07),
                                  blurRadius: 32,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'New Account',
                                    style:
                                    theme.textTheme.bodySmall?.copyWith(
                                      letterSpacing: 0.5,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Register with email',
                                    style:
                                    theme.textTheme.titleLarge?.copyWith(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  _buildTextField(
                                    label: 'Full Name',
                                    controller: nameController,
                                    hintText: 'Enter your name',
                                    prefixIcon: Icons.person_outline,
                                    textCapitalization:
                                    TextCapitalization.words,
                                    validator: (text) {
                                      if (text == null ||
                                          text.trim().isEmpty) {
                                        return 'Enter your name';
                                      }
                                      if (text.trim().length < 3) {
                                        return 'Name must be at least 3 characters';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  _buildTextField(
                                    label: 'Email Address',
                                    controller: emailController,
                                    hintText: 'Enter your email',
                                    prefixIcon: Icons.email_outlined,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (text) {
                                      if (text == null ||
                                          text.trim().isEmpty) {
                                        return 'Enter email';
                                      } else if (!text.contains('@') ||
                                          !text.contains('.')) {
                                        return 'Enter a valid email';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  _buildPasswordField(
                                    label: 'Password',
                                    controller: passwordController,
                                    isObscure: isPasswordObscure,
                                    validator: (text) {
                                      if (text == null || text.isEmpty) {
                                        return 'Enter password';
                                      } else if (text.length < 6) {
                                        return 'Enter at least 6 characters';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  _buildPasswordField(
                                    label: 'Confirm Password',
                                    controller: confirmPasswordController,
                                    isObscure: isConfirmPasswordObscure,
                                    validator: (text) {
                                      if (text == null || text.isEmpty) {
                                        return 'Confirm password';
                                      } else if (text !=
                                          passwordController.text) {
                                        return 'Passwords do not match';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 24),
                                  CustomButton(
                                    borderRadius: 8,
                                    width: MediaQuery.sizeOf(context).width,
                                    buttonColor: AppColors.primary,
                                    textStyle: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    onPressed: _register,
                                    text:  "Create Account",
                                  ),
                                  const SizedBox(height: 18),
                                  Center(
                                    child: TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).maybePop(),
                                      child: RichText(
                                        text: TextSpan(
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                            color: AppColors.grey,
                                          ),
                                          children: const [
                                            TextSpan(
                                              text: 'Already have an account? ',
                                            ),
                                            TextSpan(
                                              text: 'Login',
                                              style: TextStyle(
                                                color: AppColors.primary,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E3A8A),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.55),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey[200]!,
            ),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            textCapitalization: textCapitalization,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey[400]),
              prefixIcon: Icon(
                prefixIcon,
                color: Colors.grey[400],
                size: 20,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
            ),
            validator: validator,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required ValueNotifier<bool> isObscure,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E3A8A),
          ),
        ),
        const SizedBox(height: 6),
        ValueListenableBuilder<bool>(
          valueListenable: isObscure,
          builder: (context, value, _) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.55),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey[200]!,
                ),
              ),
              child: TextFormField(
                controller: controller,
                obscureText: value,
                decoration: InputDecoration(
                  hintText: '**********',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: Colors.grey[400],
                    size: 20,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      value
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.grey[400],
                      size: 20,
                    ),
                    onPressed: () => isObscure.value = !isObscure.value,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
                validator: validator,
              ),
            );
          },
        ),
      ],
    );
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      context.read<LoginCubit>().registerWithEmail(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
      );
    }
  }

  void _handleRegisterState(BuildContext context, LoginStates state) async {
    if (state is RegisterWithEmailLoading) {
      Loading.show(context);
    } else if (state is RegisterWithEmailSuccess) {
      Loading.dismiss(context);
      // await SharedPreferencesClient.instance.setLoggedIn(true);
      sl<NavigationService>().pushAndClearStack(LoginScreen());
      context.showSuccessBar(
        content: Text('Account Created'),
        indicatorColor: AppColors.green,
      );
    } else if (state is RegisterWithEmailFailure) {
      Loading.dismiss(context);
      context.showErrorBar(
        content: Text(state.error ?? 'Unable to create account'),
        indicatorColor: AppColors.red,
      );
    }
  }
}
