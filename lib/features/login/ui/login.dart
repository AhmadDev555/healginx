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
import 'package:healginx/features/login/ui/register_screen.dart';
import 'package:healginx/features/login/ui/widgets/sing_in_text_field.dart';
import 'package:healginx/injection_container.dart';
import 'package:healginx/styles/app_colors.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin, SignInTextField {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final ValueNotifier<bool> isObscure = ValueNotifier<bool>(true);


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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // final isDarkTheme = context.watch<ThemeCubit>().state == ThemeMode.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: const [
            Color(0xFFDCFCE7),
            Color(0xFFDBEAFE),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: BlocListener<LoginCubit, LoginStates>(
          listener: _handleLoginState,
          // listener: _handleLoginState,
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo Section
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
                          const SizedBox(height: 8),
                          Text(
                            'Want a Diet plan?',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color:  AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                              'Please sign in with your login credentials to continue.',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: AppColors.grey,

                              )

                            // TextStyle(
                            //   fontSize: 16,
                            //   color: isDarkTheme ? Colors.white70 : Colors.grey[600],
                            // ),
                          ),
                        ],
                      ),
                    ),

                    // Glass Card with Animation
                    SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: RepaintBoundary(
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 20),
                            decoration: BoxDecoration(
                              color: (Colors.white).withOpacity(0.7),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF1E3A8A).withOpacity(0.07),
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
                                    'Welcome Back',

                                    style: theme.textTheme.bodySmall?.copyWith(
                                      letterSpacing: 0.5,
                                      color:  Colors.grey[500],

                                    ),

                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Login to your account',
                                    style: theme.textTheme.titleLarge?.copyWith(

                                      color:AppColors.primary,

                                    ),


                                  ),
                                  const SizedBox(height: 16),

                                  // Email Field
                                  _buildEmailField(theme,),
                                  const SizedBox(height: 12),

                                  // Password Field
                                  _buildPasswordField(theme,),
                                  const SizedBox(height: 8),

                                  // Forgot Password
                                  // Align(
                                  //   alignment: Alignment.centerRight,
                                  //   child: TextButton(
                                  //     onPressed: () {
                                  //       // sl<NavigationService>().push(const ForgotPasswordScreen());
                                  //     },
                                  //     style: TextButton.styleFrom(
                                  //       padding: EdgeInsets.zero,
                                  //       tapTargetSize:
                                  //       MaterialTapTargetSize.shrinkWrap,
                                  //     ),
                                  //     child: Text(
                                  //       'Forgot Password?',
                                  //       style: TextStyle(
                                  //         fontSize: 14,
                                  //         fontWeight: FontWeight.w500,
                                  //         color:  const Color(0xFF3B82F6),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  const SizedBox(height: 8),

                                  CustomButton(
                                    borderRadius: 8,
                                    width: MediaQuery.sizeOf(context).width,
                                    buttonColor: AppColors.primary,
                                    textStyle: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    onPressed: _login,
                                    text: "Login",
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Divider(
                                          color: Colors.grey[300],
                                          thickness: 1,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12),
                                        child: Text(
                                          'or',
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                            color: AppColors.grey,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Divider(
                                          color: Colors.grey[300],
                                          thickness: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  _buildGoogleButton(theme),
                                  const SizedBox(height: 8),
                                  TextButton(
                                    onPressed: () => sl<NavigationService>().push(const RegisterScreen()),
                                    child: RichText(
                                      text: TextSpan(
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                          color: AppColors.grey,
                                        ),
                                        children: const [
                                          TextSpan(
                                            text: "Don't have an account? ",
                                          ),
                                          TextSpan(
                                            text: 'Create Account',
                                            style: TextStyle(
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  // Login Button
                                  // SizedBox(
                                  //
                                  //   width: double.infinity,
                                  //   child: ElevatedButton(
                                  //     onPressed: _login,
                                  //     style: ElevatedButton.styleFrom(
                                  //       backgroundColor: AppColors.primary,
                                  //       foregroundColor: Colors.white,
                                  //       padding: const EdgeInsets.symmetric(
                                  //           vertical: 18),
                                  //       shape: RoundedRectangleBorder(
                                  //         borderRadius:
                                  //         BorderRadius.circular(12),
                                  //       ),
                                  //       elevation: 8,
                                  //       shadowColor:
                                  //       AppColors.primary.withOpacity(0.2),
                                  //     ),
                                  //     child: const Text(
                                  //       'Login',
                                  //       style: TextStyle(
                                  //         fontSize: 16,
                                  //         fontWeight: FontWeight.bold,
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
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

  Widget _buildGoogleButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: _loginWithGoogle,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white.withOpacity(0.58),
          foregroundColor: AppColors.blackGrey,
          side: BorderSide(color: Colors.grey[200]!),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Text(
                'G',
                style: TextStyle(
                  color: Color(0xFF4285F4),
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Continue with Google',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.blackGrey,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailField(ThemeData theme,) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Email Address",
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E3A8A),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: ( Colors.white).withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey[200]!,
            ),
          ),
          child: TextFormField(
            controller: emailController,
            obscureText: false,
            decoration: InputDecoration(
              hintText: "Enter your email ...",
              hintStyle: TextStyle(color: Colors.grey[400]),
              prefixIcon: Icon(Icons.email_outlined,
                  color: Colors.grey[400], size: 20),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
            ),
            validator: (text) {
              if (text!.isEmpty) {
                return 'Enter email';
              } else if (!text.contains('@') || !text.contains('.')) {
                return 'Enter a valid email';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField(ThemeData theme, ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Password",
          style: TextStyle(
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
                color: (Colors.white)
                    .withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey[200]!,
                ),
              ),
              child: TextFormField(
                controller: passwordController,
                obscureText: value,
                decoration: InputDecoration(
                  hintText: "**********",
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  prefixIcon: Icon(Icons.lock_outline,
                      color: Colors.grey[400], size: 20),
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
                validator: (text) {
                  if (text!.isEmpty) {
                    return 'Enter password';
                  } else if (text.length < 6) {
                    return "Enter at least 6 characters";
                  }
                  return null;
                },
              ),
            );
          },
        ),
      ],
    );
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      context.read<LoginCubit>().loginWithEmail(
        email: emailController.text,
        password: passwordController.text,
      );
    }
  }

  void _loginWithGoogle() {
    context.read<LoginCubit>().loginWithGoogle();
  }

  void _handleLoginState(BuildContext context, LoginStates state) async {
    if (state is LoginWithEmailLoading) {
      Loading.show(context);
    } else if (state is LoginWithEmailSuccess) {

      await SharedPreferencesClient.instance.setLoggedIn(true);


      // sl<FirebaseNotificationCubit>().registerDeviceCubit();
      //
      // loginModelData = state.loginModel;
      // if (state.loginModel.data!.authTenants!.length > 1) {
        sl<NavigationService>().pushAndClearStack(HomeScreen());
      // } else {
      //   await SharedPreferencesClient.instance.setLabData(
      //       loginModelData.data?.authTenants?.first.key!);
      //   sl<LoginCubit>().userRoleCheckCubit(
      //     portalKey: state.loginModel.data?.authTenants?.first.key,
      //   );
      // }
    } else if (state is LoginWithEmailFailure) {
      Navigator.pop(context);
      context.showErrorBar(content: Text(state.error??""), indicatorColor: AppColors.red);
    } else if (state is LoginWithGoogleLoading) {
      Loading.show(context);
    } else if (state is LoginWithGoogleSuccess) {
      await SharedPreferencesClient.instance.setLoggedIn(true);
      sl<NavigationService>().pushAndClearStack(HomeScreen());
    } else if (state is LoginWithGoogleFailure) {
      Navigator.pop(context);
      context.showErrorBar(
        content: Text(state.error ?? ""),
        indicatorColor: AppColors.red,
      );
    }
  }

}
