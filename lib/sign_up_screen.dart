import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_glow/flutter_glow.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _supabase = Supabase.instance.client;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose(); 
    super.dispose();
  }

  void _signUp() {
    print('Email: ${_emailController.text}');
    print('Password: ${_passwordController.text}');
    // TODO: Implement Supabase sign-up logic
  }

  Future<void> _googleSignIn() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      final googleAuth = await googleUser!.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null) {
        // TODO: Handle missing access token
        return;
      }
      if (idToken == null) {
        // TODO: Handle missing ID token
        return;
      }

      await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
    } catch (e) {}
  }

  Future<void> _appleSignIn() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.apple,
        idToken: credential.identityToken!,
        accessToken: credential.authorizationCode,
      );
    } catch (e) {
      // TODO: Handle Apple sign-in errors
      print('Error during Apple sign-in: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Apply a subtle noise texture background
    const BoxDecoration backgroundDecoration = BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/noise_texture.png'), // Add a noise texture asset
        fit: BoxFit.cover,
        repeat: ImageRepeat.repeat,
      ),
    );

    return Scaffold(
      body: Container(
        decoration: backgroundDecoration,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // App Title/Logo (placeholder)
                Text(
                  'Gradium',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        // Expressive Typography
                        fontFamily: 'Montserrat', // Example font
                        color: Theme.of(context).colorScheme.primary,
                        shadows: [
                          // Multi-layered drop shadows
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black.withOpacity(0.2),
                            offset: const Offset(5.0, 5.0),
                          ),
                          Shadow(
                            blurRadius: 20.0,
                            color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                            offset: const Offset(10.0, 10.0),
                          ),
                        ],
                      ),
                ),
                const SizedBox(height: 48.0),

                // Email and Password Fields (can be added later if direct email/password sign-up is needed)
                // For now, focusing on social sign-in

                // Social Sign-in Buttons
                GlowButton(
                  onPressed: _googleSignIn,
                  buttonVariant: ButtonVariant.fill,
                  color: Theme.of(context).colorScheme.surface,
                  glowColor: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(30.0),
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          '/assets/icons/google_icon.png', // Use absolute path
                          height: 24.0,
                        ),
                        const SizedBox(width: 12.0),
                        Text(
                          'Sign up with Google',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),

                if (Theme.of(context).platform == TargetPlatform.iOS)
                  GlowButton(
                    onPressed: _appleSignIn,
                    buttonVariant: ButtonVariant.fill,
                    color: Theme.of(context).colorScheme.surface,
                    glowColor: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(30.0),
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            '/assets/icons/apple_icon.png', // Use absolute path
                            height: 24.0,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          const SizedBox(width: 12.0),
                          Text(
                            'Sign up with Apple',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 24.0),

                // Placeholder for error messages
                // TODO: Implement error message display
                Container(
                  height: 20.0, // Reserve space for error message
                  alignment: Alignment.center,
                  child: Text(
                    '', // Error message goes here
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ),

                // Placeholder for loading indicator
                // TODO: Implement loading indicator
                Container(
                  height: 20.0, // Reserve space for loading indicator
                  alignment: Alignment.center,
                  child: const SizedBox.shrink(), // Loading indicator goes here
                ),

                const SizedBox(height: 48.0),

                // Terms of Service / Privacy Policy link (placeholder)
                // TODO: Add Terms of Service and Privacy Policy links
              ],
            ),
          ),
        ),
      ),
    );
  }
}